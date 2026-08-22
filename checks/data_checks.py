"""Восемь проверок данных.

Задача не «покрыть код тестами», а поймать ровно те поломки, которые уже
случались. У каждой проверки в комментарии стоит случай из жизни, ради которого
она написана: проверка без такого случая — это строка, которую однажды удалят
как непонятную.

Проверки живут ЗДЕСЬ, а не в тестах, потому что запускаются в двух местах:

  * в CI по свежей БД — упавшая блокирует деплой;
  * после каждого прогона сбора на проде — результат пишется в dq_runs, и по
    нему приложение показывает плашку «данные обновляются» вместо
    подозрительных цифр.

Тонкое место — как проверка формулируется. «Ни одной цены <= 0» ловится
запросом, возвращающим НАРУШИТЕЛЕЙ, а не число. Сообщение «нашлось 12 строк»
бесполезно в три часа ночи; «bravo/30013586 цена -50, наблюдение 14:20» —
полезно.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

# Порог по медианной цене сети, гяпики.
#
# Ловит магазин в чужой валюте. Случай из жизни: слаг «grandmart» выглядел как
# бакинский магазин, отдавал 596 товаров и грузился без единой ошибки. Но это
# была русскоязычная точка другой страны, медиана 1014 манатов против 1.4–4.4
# в бакинских. Формально данные валидные, по сути мусор.
MEDIAN_MIN_MINOR = 30
MEDIAN_MAX_MINOR = 5000

# Доля позиций с распознанной фасовкой. Просела — сломался units.py.
#
# На дампе от 17.08.2026 фактическое значение 88.0%, худшая сеть 87.2%
# (bravo). Запас до порога три пункта: этого хватает, чтобы проверка не
# срабатывала на обычных колебаниях, но ловила настоящую поломку разбора.
PACKAGING_MIN_RATIO = 0.85

# То же по каждой сети отдельно. Общая доля разбавляет поломку одного
# коннектора: если у rahat (3% позиций) разбор упадёт до нуля, общая доля
# сползёт с 88.0 лишь до 85.2 и почти проскочит. Отдельный порог по сети
# ловит это сразу.
PACKAGING_MIN_RATIO_PER_CHAIN = 0.80

# Насколько могут упасть межсетевые склейки относительно прошлого прогона.
#
# Тихая потеря склеек — самый незаметный способ убить продукт: цены на месте,
# экраны работают, только сравнивать стало нечего.
MERGES_MAX_DROP = 0.10

# Возраст самых свежих данных по сети.
MAX_AGE_HOURS = 12


@dataclass
class CheckResult:
    name: str
    passed: bool
    detail: str = ""
    #: Примеры нарушителей. Пусто, если проверка прошла.
    offenders: list[Any] = field(default_factory=list)
    #: Измеренное значение — пишется в историю независимо от вердикта.
    value: float | None = None
    #: Проверку не гоняли. Не то же самое, что «прошла»: в выводе это видно
    #: отдельным словом, иначе пропуск читается как успех.
    skipped: bool = False

    def __str__(self) -> str:
        if self.skipped:
            return f"ПРОПУЩЕНА {self.name}: {self.detail}"
        mark = "ок  " if self.passed else "УПАЛА"
        return f"{mark} {self.name}: {self.detail}"


# Каждый запрос возвращает НАРУШИТЕЛЕЙ, а не их количество: имя сети и
# конкретный sku в сообщении экономят полчаса в три часа ночи.

SQL_NON_POSITIVE_PRICE = """
SELECT c.code, si.chain_sku, po.price, po.observed_at
FROM price_observations po
JOIN store_items si ON si.id = po.store_item_id
JOIN chains c ON c.id = si.chain_id
WHERE po.price <= 0
LIMIT 20
"""

SQL_BAD_PROMO = """
SELECT c.code, si.chain_sku, po.price, po.old_price, po.observed_at
FROM price_observations po
JOIN store_items si ON si.id = po.store_item_id
JOIN chains c ON c.id = si.chain_id
WHERE po.old_price IS NOT NULL
  AND po.old_price <= po.price
LIMIT 20
"""

# COALESCE обязателен: NULL не равен NULL, и без него дубли у сетей с единой
# ценой (store_id пустой) проверка бы не увидела. Ровно на этом уже
# наступали — см. idx_si_sku.
SQL_DUPLICATE_SKU = """
SELECT c.code, si.chain_sku, coalesce(si.store_id, 0) AS store, count(*) AS n
FROM store_items si
JOIN chains c ON c.id = si.chain_id
GROUP BY c.code, si.chain_sku, coalesce(si.store_id, 0)
HAVING count(*) > 1
LIMIT 20
"""

SQL_DUPLICATE_EAN = """
SELECT ean, count(*) AS n, min(id) AS first_id, max(id) AS last_id
FROM products
WHERE ean IS NOT NULL AND ean <> ''
GROUP BY ean
HAVING count(*) > 1
LIMIT 20
"""

SQL_CHAIN_MEDIANS = """
SELECT c.code,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY cp.price)::int AS median_minor,
       count(*) AS items
FROM current_prices cp
JOIN store_items si ON si.id = cp.store_item_id
JOIN chains c ON c.id = si.chain_id
GROUP BY c.code
ORDER BY 2
"""

SQL_PACKAGING_PER_CHAIN = """
SELECT c.code,
       count(*) AS items,
       avg(CASE WHEN si.unit_type IS NOT NULL
                 AND (si.unit_type = 'kg_bulk' OR si.unit_value IS NOT NULL)
                THEN 1.0 ELSE 0.0 END) AS ratio
FROM store_items si
JOIN chains c ON c.id = si.chain_id
GROUP BY c.code
ORDER BY 3
"""

# Возраст считается по (сеть, МАГАЗИН), а не по сети.
#
# Разрез по сети оставляет дыру, через которую проходит самая частая поломка
# сбора. Коннектор молча переживает потерю отдельной точки: `pull_wolt` при
# недоступности печатает «ПРОПУЩЕН <slug>» и идёт дальше. Если у Bravo отвалилась
# одна ценовая зона из четырёх, остальные три обновят max(observed_at) СЕТИ,
# проверка скажет «Bravo свежий», а люди, выбравшие выпавшую точку, будут
# видеть вчерашние цены без единого предупреждения.
#
# COALESCE(store_id, 0) — тот же приём, что в уникальном индексе store_items:
# у сетей с единой ценой store_id пуст, и там это по-прежнему одна строка.
SQL_STORE_AGES = """
SELECT c.code,
       si.store_id,
       s.name AS store_name,
       s.price_cluster,
       max(cp.observed_at) AS last_seen,
       extract(epoch FROM (now() - max(cp.observed_at))) / 3600.0 AS age_hours,
       count(*) AS items
FROM chains c
JOIN store_items si ON si.chain_id = c.id
LEFT JOIN stores s ON s.id = si.store_id
LEFT JOIN current_prices cp ON cp.store_item_id = si.id
GROUP BY c.code, si.store_id, s.name, s.price_cluster
ORDER BY 6 DESC NULLS FIRST
"""

# Старое имя оставлено ссылкой на новое: снаружи его звали и раннер, и pytest,
# и переименовывать в двух местах ради одной строки незачем.
SQL_CHAIN_AGES = SQL_STORE_AGES


def check_non_positive_price(rows) -> CheckResult:
    """1. Ни одной цены <= 0.

    Ноль или минус в цене — это не «дешёвый товар», это разбор, который вернул
    пустую строку и получил ноль. Такая цена мгновенно становится «дешевле
    всех» и утаскивает за собой всю выдачу.
    """
    return CheckResult(
        name="цены больше нуля",
        passed=not rows,
        detail="нарушителей нет" if not rows else f"найдено {len(rows)} строк",
        offenders=list(rows),
        value=float(len(rows)),
    )


def check_bad_promo(rows) -> CheckResult:
    """2. Ни одной акции, где старая цена не больше текущей.

    «Было 10, стало 12» — это не акция. Такая строка сломает и расчёт скидки
    (деление даст отрицательное число), и доверие к ленте выгод.
    """
    return CheckResult(
        name="старая цена больше текущей",
        passed=not rows,
        detail="нарушителей нет" if not rows else f"найдено {len(rows)} акций",
        offenders=list(rows),
        value=float(len(rows)),
    )


def check_duplicate_sku(rows) -> CheckResult:
    """3. Нет дублей chain_sku внутри одного магазина.

    Уже наступали: UNIQUE (chain_id, store_id, chain_sku) не ловит дубли у
    сетей с единой ценой, потому что там store_id пустой, а NULL не равен NULL.
    Дубли дают две цены на одну позицию, и какая победит — лотерея.
    """
    return CheckResult(
        name="нет дублей chain_sku",
        passed=not rows,
        detail="дублей нет" if not rows else f"найдено {len(rows)} пар",
        offenders=list(rows),
        value=float(len(rows)),
    )


def check_duplicate_ean(rows) -> CheckResult:
    """4. Нет дублей EAN среди канонических товаров.

    Два канонических товара с одним штрихкодом — это развалившаяся склейка:
    цены одного товара разъезжаются по двум карточкам, и в каждой «есть в
    1 сети» вместо «в пяти».
    """
    return CheckResult(
        name="нет дублей EAN",
        passed=not rows,
        detail="дублей нет" if not rows else f"найдено {len(rows)} штрихкодов",
        offenders=list(rows),
        value=float(len(rows)),
    )


def check_chain_medians(rows) -> CheckResult:
    """5. Медианная цена сети в диапазоне 0.30–50 манатов.

    Ловит магазин в чужой валюте. Случай из жизни: «grandmart» выглядел как
    бакинский магазин и грузился без ошибок, но медиана там была 1014 против
    1.4–4.4 у остальных. Формально валидные данные, по сути мусор.

    Проверка постоянная, а не разовая: слаг могут подменить в любой момент.
    """
    bad = [
        r for r in rows
        if not (MEDIAN_MIN_MINOR <= r["median_minor"] <= MEDIAN_MAX_MINOR)
    ]
    worst = min((r["median_minor"] for r in rows), default=0)
    return CheckResult(
        name="медиана цены сети в разумных пределах",
        passed=not bad,
        detail=(
            f"{len(rows)} сетей, медианы "
            f"{min((r['median_minor'] for r in rows), default=0) / 100:.2f}"
            f"–{max((r['median_minor'] for r in rows), default=0) / 100:.2f} ₼"
            if not bad
            else "вне диапазона: "
            + ", ".join(f"{r['code']} {r['median_minor'] / 100:.2f} ₼" for r in bad)
        ),
        offenders=bad,
        value=float(worst),
    )


def check_packaging(rows) -> CheckResult:
    """6. Доля позиций с распознанной фасовкой не ниже 85%.

    Просела — сломался units.py. Без фасовки нельзя сравнить килограмм с
    килограммом, и весовые товары начинают выглядеть дешевле пачек.

    Порог проверяется и по всей базе, и по каждой сети: общая доля разбавляет
    поломку одного коннектора, а сломаться может именно один.
    """
    total_items = sum(r["items"] for r in rows) or 1
    overall = sum(r["ratio"] * r["items"] for r in rows) / total_items

    bad_chains = [r for r in rows if r["ratio"] < PACKAGING_MIN_RATIO_PER_CHAIN]
    passed = overall >= PACKAGING_MIN_RATIO and not bad_chains

    detail = f"распознано {overall * 100:.1f}%"
    if overall < PACKAGING_MIN_RATIO:
        detail += f", ниже порога {PACKAGING_MIN_RATIO * 100:.0f}%"
    if bad_chains:
        detail += ", просевшие сети: " + ", ".join(
            f"{r['code']} {r['ratio'] * 100:.1f}%" for r in bad_chains
        )

    return CheckResult(
        name="фасовка распознаётся",
        passed=passed,
        detail=detail,
        offenders=bad_chains,
        value=overall,
    )


def check_merges_not_dropped(current: int, previous: int | None) -> CheckResult:
    """7. Межсетевые склейки не упали больше чем на 10%.

    Тихая потеря склеек — самый незаметный способ убить продукт: цены на
    месте, экраны работают, ошибок в логах нет, а сравнивать стало нечего.
    Единственный способ это заметить — сравнить с прошлым прогоном.
    """
    if previous is None:
        # Первый прогон: сравнивать не с чем. Это не провал — но и не «ок»,
        # поэтому пишем прямо.
        return CheckResult(
            name="межсетевые склейки не потерялись",
            passed=True,
            detail=f"{current}, прошлого прогона нет — сравнить не с чем",
            value=float(current),
        )

    if previous == 0:
        return CheckResult(
            name="межсетевые склейки не потерялись",
            passed=current >= 0,
            detail=f"{current}, в прошлом прогоне было 0",
            value=float(current),
        )

    drop = (previous - current) / previous
    return CheckResult(
        name="межсетевые склейки не потерялись",
        passed=drop <= MERGES_MAX_DROP,
        detail=(
            f"{current} против {previous} "
            f"({'−' if drop > 0 else '+'}{abs(drop) * 100:.1f}%)"
        ),
        value=float(current),
    )


def _store_label(row) -> str:
    """«bravo/Bravo Superstore 28 Mall» либо просто «araz» у единой цены."""
    if row.get("store_id") is None:
        return str(row["code"])
    name = row.get("store_name") or f"store {row['store_id']}"
    return f"{row['code']}/{name}"


def check_freshness(rows) -> CheckResult:
    """8. Возраст самых свежих данных по каждому МАГАЗИНУ меньше 12 часов.

    Не по сети. Сеть с четырьмя ценовыми зонами переживает потерю одной из
    них незаметно: три оставшиеся тянут max(observed_at) наверх, и проверка
    по сети рапортует «свежо». Человек, выбравший выпавшую точку, видит
    вчерашние цены как сегодняшние — а это тот отказ, который не возвращают.

    У сетей с единой ценой store_id пуст, и строка по-прежнему одна: разрез
    ничего не меняет там, где менять нечего.
    """
    stale = [
        r for r in rows
        if r["age_hours"] is None or r["age_hours"] > MAX_AGE_HOURS
    ]
    worst = max((r["age_hours"] or 1e9 for r in rows), default=0)
    return CheckResult(
        name="данные свежие",
        passed=not stale,
        detail=(
            f"{len(rows)} точек, худшая {worst:.1f} ч"
            if not stale
            else f"устарели {len(stale)} из {len(rows)} точек: "
            + ", ".join(
                _store_label(r)
                + " "
                + ("нет данных" if r["age_hours"] is None else f"{r['age_hours']:.1f} ч")
                for r in stale[:8]
            )
            + ("" if len(stale) <= 8 else f" ...и ещё {len(stale) - 8}")
        ),
        offenders=stale,
        value=None if worst >= 1e9 else float(worst),
    )

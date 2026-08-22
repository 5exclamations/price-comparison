"""Восемь проверок данных как pytest.

Гоняются по свежей БД: в CI после миграций и импорта, и на проде после каждого
прогона сбора. Любая упавшая блокирует деплой.

Каждый тест назван поломкой, которую ловит, а не проверяемым полем. Имя
«test_no_zero_prices» ничего не говорит дежурному в три часа ночи; имя
«ноль в цене делает товар дешевле всех» — говорит.

Логика самих проверок лежит в checks/data_checks.py и покрыта отдельно
(test_check_logic.py): там подсовываются поломки и проверяется, что проверка
срабатывает. Здесь — прогон по настоящей базе.
"""
import os

import psycopg
import pytest

from checks import data_checks as dc
from checks.runner import _rows


@pytest.fixture(scope="session")
def conn():
    dsn = os.environ.get(
        "DATABASE_URL", "postgresql://qiymet@localhost:5432/qiymet"
    ).replace("postgresql+psycopg://", "postgresql://", 1)
    try:
        with psycopg.connect(dsn) as c:
            with c.cursor() as cur:
                cur.execute("SELECT count(*) FROM store_items")
                if cur.fetchone()[0] == 0:
                    pytest.exit("База пуста: сначала импорт", returncode=1)
            yield c
    except psycopg.OperationalError as exc:
        pytest.exit(f"Нет доступа к Postgres: {exc}", returncode=1)


def _query(conn, sql):
    with conn.cursor() as cur:
        cur.execute(sql)
        return _rows(cur)


def _assert(result: dc.CheckResult):
    """Падение показывает нарушителей, а не только «assert False»."""
    if result.passed:
        return
    lines = [f"{result.name}: {result.detail}"]
    lines += [f"  {o}" for o in result.offenders[:10]]
    if len(result.offenders) > 10:
        lines.append(f"  ...и ещё {len(result.offenders) - 10}")
    pytest.fail("\n".join(lines))


def test_ноль_в_цене_делает_товар_дешевле_всех(conn):
    """1. Ни одной цены <= 0.

    Ноль — это не «дёшево», это разбор, вернувший пустую строку. Такая цена
    мгновенно становится лучшей и утаскивает за собой всю выдачу.
    """
    _assert(dc.check_non_positive_price(_query(conn, dc.SQL_NON_POSITIVE_PRICE)))


def test_акция_где_цена_выросла(conn):
    """2. Ни одной акции, где старая цена не больше текущей.

    «Было 10, стало 12» ломает расчёт скидки: деление даёт отрицательное
    число, и позиция всплывает в ленте выгод.
    """
    _assert(dc.check_bad_promo(_query(conn, dc.SQL_BAD_PROMO)))


def test_дубли_sku_при_пустом_store_id(conn):
    """3. Нет дублей chain_sku внутри одного магазина.

    На этом уже наступали: UNIQUE (chain_id, store_id, chain_sku) не ловит
    дубли у сетей с единой ценой, где store_id пустой, потому что NULL не
    равен NULL. Две цены на одну позицию, и какая победит — лотерея.
    """
    _assert(dc.check_duplicate_sku(_query(conn, dc.SQL_DUPLICATE_SKU)))


def test_склейка_развалилась_на_два_товара(conn):
    """4. Нет дублей EAN среди канонических товаров.

    Два товара с одним штрихкодом — это разъехавшаяся склейка: цены делятся
    между карточками, и в каждой «есть в 1 сети» вместо «в пяти».
    """
    _assert(dc.check_duplicate_ean(_query(conn, dc.SQL_DUPLICATE_EAN)))


def test_магазин_в_чужой_валюте(conn):
    """5. Медианная цена сети в диапазоне 0.30–50 манатов.

    Случай из жизни: слаг «grandmart» выглядел как бакинский магазин, отдавал
    596 товаров и грузился без ошибок. Но это была русскоязычная точка другой
    страны с медианой 1014 против 1.4–4.4 у остальных.
    """
    _assert(dc.check_chain_medians(_query(conn, dc.SQL_CHAIN_MEDIANS)))


def test_сломался_разбор_фасовки(conn):
    """6. Доля позиций с распознанной фасовкой не ниже 85%.

    Просела — сломался units.py. Без фасовки нельзя сравнить килограмм с
    килограммом, и весовые товары выглядят дешевле пачек.

    Порог проверяется и по базе целиком, и по каждой сети. Замерено: если
    разбор упадёт в ноль у rahat (3% позиций), общая доля опустится с 88.0%
    лишь до 85.3% — выше порога, и общая проверка поломку пропустит. Ловит
    только проверка по сетям.
    """
    _assert(dc.check_packaging(_query(conn, dc.SQL_PACKAGING_PER_CHAIN)))


def test_тихая_потеря_межсетевых_склеек(conn):
    """7. Склейки не упали больше чем на 10% относительно прошлого прогона.

    Самый незаметный способ убить продукт: цены на месте, экраны работают,
    ошибок в логах нет, а сравнивать стало нечего.
    """
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM dq_metrics()")
        metrics = _rows(cur)[0]
        cur.execute(
            "SELECT cross_chain_merges FROM dq_runs ORDER BY started_at DESC LIMIT 1"
        )
        row = cur.fetchone()

    result = dc.check_merges_not_dropped(
        metrics["cross_chain_merges"], row[0] if row else None
    )
    if row is None:
        pytest.skip(
            "Прошлого прогона нет — сравнить не с чем. "
            "Проверка заработает со второго запуска."
        )
    _assert(result)


def test_магазин_не_обновлялся_сутки(conn):
    """8. Возраст самых свежих данных по каждому МАГАЗИНУ меньше 12 часов.

    Человек съездит в магазин по вчерашней цене, не найдёт её и удалит
    приложение. Это тот отказ, который не возвращают.

    Разрез по магазину, а не по сети: у Bravo четыре ценовые зоны, и потеря
    одной из них при проверке по сети не видна вовсе — три оставшиеся тянут
    max(observed_at) наверх, и сеть выглядит свежей.

    В CI база поднимается из дампа, лежащего в репозитории, и он всегда
    старше двенадцати часов — там проверка мерила бы возраст файла. Поэтому
    при QIYMET_FIXTURE_DUMP=1 она пропускается ЯВНО, с причиной в выводе, а не
    смягчённым порогом: порог трогать нельзя, он и есть смысл проверки.
    """
    if os.environ.get("QIYMET_FIXTURE_DUMP") == "1":
        pytest.skip("база из дампа в репозитории: возраст данных здесь не показателен")
    _assert(dc.check_freshness(_query(conn, dc.SQL_STORE_AGES)))

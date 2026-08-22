"""GET /v1/health — возраст данных по каждой сети и по каждой точке."""
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..cache import RedisCache, get_cache
from ..config import settings
from ..db import get_conn
from ..http import cached
from ..schemas import ChainHealth, DataQuality, HealthResponse, StoreHealth

router = APIRouter()

# Возраст берётся по свежайшему наблюдению в current_prices: именно эти цены
# видит пользователь. Считать по price_observations нельзя — там лежит и старая
# история, максимум по ней совпадёт, но смысл поля другой.
#
# Разрез по (сеть, МАГАЗИН), а не по сети. Сбор молча переживает потерю
# отдельной точки: коннектор печатает «ПРОПУЩЕН <slug>» и идёт дальше. У Bravo
# четыре ценовые зоны, и если отвалилась одна, три оставшиеся тянут
# max(observed_at) сети наверх — по сети всё свежо, а люди, выбравшие выпавшую
# точку, видят вчерашние цены без единого предупреждения.
#
# Сети попадают в ответ даже без единой позиции (LEFT JOIN): «сети нет в
# выдаче» и «сеть отдала ноль товаров» — разные аварии, и вторую надо видеть.
FRESHNESS = """
SELECT c.id, c.code, c.name,
       si.store_id,
       s.name                                    AS store_name,
       s.price_cluster,
       max(cp.observed_at)                       AS last_observed_at,
       count(cp.store_item_id)                   AS items_tracked
FROM chains c
LEFT JOIN store_items si    ON si.chain_id = c.id
LEFT JOIN stores s          ON s.id = si.store_id
LEFT JOIN current_prices cp ON cp.store_item_id = si.id
GROUP BY c.id, c.code, c.name, si.store_id, s.name, s.price_cluster
ORDER BY c.code, s.name NULLS FIRST
"""

# Последний прогон проверок данных.
DATA_QUALITY = """
SELECT started_at, passed, failures, cross_chain_merges, packaging_ratio
FROM dq_runs
ORDER BY started_at DESC
LIMIT 1
"""


@router.get("/health", response_model=HealthResponse, summary="Свежесть данных")
async def health(
    response: Response,
    conn: AsyncConnection = Depends(get_conn),
):
    """Возраст самых свежих данных по каждой сети и по каждой точке.

    Нужен клиенту, чтобы честно писать «данные устарели» вместо того, чтобы
    молча показывать вчерашнюю цену как сегодняшнюю. Точка уходит в `degraded`,
    если не обновлялась дольше 12 часов; сеть — если протухла хотя бы одна её
    точка.

    `stale_store_ids` — короткий список для клиента: приложению достаточно
    проверить, нет ли в нём выбранного магазина, чтобы показать плашку
    человеку, чья точка протухла, даже когда сеть в целом свежая.

    Кешируется на 30 секунд, а не на 5 минут, как остальные ответы. Это
    сознательное отступление: смысл эндпоинта — ответить, насколько данные
    свежи ПРЯМО СЕЙЧАС, и пятиминутный кеш задерживал бы предупреждение об
    аварии сбора ровно на пять минут.
    """

    async def build() -> HealthResponse:
        rows = (await conn.execute(text(FRESHNESS))).mappings().all()
        now = datetime.now(timezone.utc)

        # Последний прогон проверок данных. Если он упал, приложение покажет
        # плашку вместо цифр — молчать в этот момент значит показывать мусор
        # как обычные цены.
        dq_row = (
            await conn.execute(text(DATA_QUALITY))
        ).mappings().first()
        quality = DataQuality(
            checked_at=dq_row["started_at"] if dq_row else None,
            # Прогонов ещё не было — считаем, что качество не подтверждено.
            # «Проверок не было» и «проверки прошли» это разные вещи.
            passed=bool(dq_row["passed"]) if dq_row else False,
            failed_checks=[
                f.get("name", "?")
                for f in (dq_row["failures"] or [])
                # Пропущенные проверки лежат в том же поле, но упавшими не
                # являются: показывать их клиенту как поломку значит врать.
                if not f.get("skipped")
            ]
            if dq_row
            else ["проверки ещё не гонялись"],
            cross_chain_merges=dq_row["cross_chain_merges"] if dq_row else None,
            packaging_ratio=dq_row["packaging_ratio"] if dq_row else None,
        )

        def _age(last: datetime | None) -> float | None:
            return None if last is None else (now - last).total_seconds() / 3600.0

        def _status(last: datetime | None, age: float | None) -> str:
            if last is None:
                return "no_data"
            return "degraded" if age > settings.stale_after_hours else "ok"

        # Строки приходят по (сеть, точка); собираем их в сети, не теряя
        # порядок — SQL уже отсортировал.
        by_chain: dict[int, dict] = {}
        stale_store_ids: list[int] = []

        for r in rows:
            chain = by_chain.setdefault(
                r["id"],
                {
                    "chain_id": r["id"],
                    "chain_code": r["code"],
                    "chain_name": r["name"],
                    "stores": [],
                },
            )

            # У сети без единой позиции LEFT JOIN даёт одну строку с пустым
            # store_id и нулём товаров. Это не точка, это отсутствие данных:
            # заводить на неё запись в stores нечего.
            if r["items_tracked"] == 0 and r["store_id"] is None and r["store_name"] is None:
                continue

            age = _age(r["last_observed_at"])
            status = _status(r["last_observed_at"], age)

            chain["stores"].append(
                StoreHealth(
                    store_id=r["store_id"],
                    store_name=r["store_name"],
                    price_cluster=r["price_cluster"],
                    last_observed_at=r["last_observed_at"],
                    age_hours=round(age, 2) if age is not None else None,
                    items_tracked=r["items_tracked"],
                    status=status,
                )
            )
            if status != "ok" and r["store_id"] is not None:
                stale_store_ids.append(r["store_id"])

        chains, degraded = [], False
        for c in by_chain.values():
            stores = c["stores"]

            # Возраст сети — по САМОЙ СТАРОЙ точке, а не по самой свежей.
            # Максимум скрывал бы ровно ту поломку, ради которой этот разрез
            # и появился: одна отвалившаяся зона Bravo из четырёх.
            ages = [s.age_hours for s in stores if s.age_hours is not None]
            oldest = max(ages) if ages else None
            last = min(
                (s.last_observed_at for s in stores if s.last_observed_at),
                default=None,
            )

            if not stores or any(s.status == "no_data" for s in stores):
                status = "no_data"
            elif any(s.status == "degraded" for s in stores):
                status = "degraded"
            else:
                status = "ok"
            degraded |= status != "ok"

            chains.append(
                ChainHealth(
                    chain_id=c["chain_id"],
                    chain_code=c["chain_code"],
                    chain_name=c["chain_name"],
                    last_observed_at=last,
                    age_hours=round(oldest, 2) if oldest is not None else None,
                    items_tracked=sum(s.items_tracked for s in stores),
                    status=status,
                    stores=stores,
                )
            )

        return HealthResponse(
            status="degraded" if (degraded or not quality.passed) else "ok",
            stale_store_ids=sorted(set(stale_store_ids)),
            stale_after_hours=settings.stale_after_hours,
            generated_at=now,
            chains=chains,
            data_quality=quality,
            database="ok",
            cache="redis" if isinstance(get_cache(), RedisCache) else "memory",
        )

    # Свой Cache-Control: ETagMiddleware не трогает уже проставленный заголовок.
    response.headers["Cache-Control"] = "public, max-age=30"
    return await cached(response, "health", {}, build, ttl=30)

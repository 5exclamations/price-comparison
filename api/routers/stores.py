"""GET /v1/stores — магазины с расстоянием от точки."""
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..http import cached
from ..schemas import StoreOut, StoresResponse

router = APIRouter()

# Расстояние по формуле гаверсинуса прямо в SQL: PostGIS ради одной колонки
# ставить незачем, а earthdistance тянет cube. Радиус Земли 6371 км.
#
# Синтетические записи: у сетей с price_model = 'single' цена одна на всю сеть,
# и список филиалов клиенту только мешает — он начнёт думать, что выбор влияет
# на цену. Такие сети отдаются одной строкой со store_id = null.
STORES = """
WITH dist AS (
    SELECT s.id, s.chain_id, s.name, s.format, s.price_cluster, s.address,
           s.lat, s.lon,
           CASE WHEN CAST(:lat AS float8) IS NULL OR CAST(:lon AS float8) IS NULL
                     OR s.lat IS NULL OR s.lon IS NULL
                THEN NULL
                ELSE round(6371000 * 2 * asin(sqrt(
                         power(sin(radians(s.lat - CAST(:lat AS float8)) / 2), 2)
                       + cos(radians(CAST(:lat AS float8))) * cos(radians(s.lat))
                       * power(sin(radians(s.lon - CAST(:lon AS float8)) / 2), 2))))::int
           END AS distance_m
    FROM stores s
)
-- 1. Сети с единой ценой: одна синтетическая запись на сеть
SELECT NULL::int      AS store_id,
       c.id           AS chain_id,
       c.code         AS chain_code,
       c.name         AS chain_name,
       c.price_model,
       c.name         AS name,
       NULL::text     AS format,
       NULL::text     AS price_cluster,
       NULL::text     AS address,
       NULL::float8   AS lat,
       NULL::float8   AS lon,
       min(d.distance_m) AS distance_m,
       true           AS synthetic
FROM chains c
LEFT JOIN dist d ON d.chain_id = c.id
WHERE c.price_model = 'single'
GROUP BY c.id, c.code, c.name, c.price_model

UNION ALL

-- 2. Сети, где цена зависит от точки или зоны: настоящие филиалы
SELECT d.id, c.id, c.code, c.name, c.price_model,
       d.name, d.format, d.price_cluster, d.address, d.lat, d.lon,
       d.distance_m, false
FROM dist d
JOIN chains c ON c.id = d.chain_id
WHERE c.price_model <> 'single'

ORDER BY distance_m NULLS LAST, 3, 6
"""


@router.get("/stores", response_model=StoresResponse, summary="Магазины")
async def stores(
    response: Response,
    lat: float | None = Query(None, ge=-90, le=90),
    lon: float | None = Query(None, ge=-180, le=180),
    conn: AsyncConnection = Depends(get_conn),
):
    """Список магазинов, при заданных координатах — с расстоянием.

    Сети с единой ценой (Bazarstore, Araz, SPAR, Neptun, Rahat) отдаются одной
    синтетической записью со `store_id = null`: цена у них не зависит от точки,
    и передавать store_id для них не нужно. Bravo отдаётся филиалами — там у
    каждой ценовой зоны свой прайс.

    ВНИМАНИЕ: в текущем дампе `stores.lat/lon` пусты у всех 9 магазинов, поэтому
    `distance_m` всегда null, а сортировать по расстоянию нечем. Смотрите поле
    `coordinates_known` в ответе.
    """
    params = {"lat": lat, "lon": lon}

    async def build() -> StoresResponse:
        rows = (
            await conn.execute(text(STORES), {"lat": lat, "lon": lon})
        ).mappings().all()

        items = [
            StoreOut(
                store_id=r["store_id"],
                chain_id=r["chain_id"],
                chain_code=r["chain_code"],
                chain_name=r["chain_name"],
                price_model=r["price_model"],
                name=r["name"],
                format=r["format"],
                price_cluster=r["price_cluster"],
                address=r["address"],
                lat=r["lat"],
                lon=r["lon"],
                distance_m=r["distance_m"],
                synthetic=r["synthetic"],
            )
            for r in rows
        ]
        known = sum(1 for i in items if i.lat is not None and i.lon is not None)
        return StoresResponse(items=items, coordinates_known=known)

    return await cached(response, "stores", params, build)

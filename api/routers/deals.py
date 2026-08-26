"""GET /v1/deals — лента акций, отсортированная по настоящей скидке."""
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..deps import SelectedStore, limit_param, selected_store
from ..http import cached
from ..paging import decode_cursor, encode_cursor
from ..schemas import Deal, DealsResponse

router = APIRouter()

# Читаем готовую витрину deal_honesty (миграция 0005) — перенос
# pipeline/honesty.py в SQL. Считать это на лету нельзя: настоящая скидка
# требует медианы неакционных цен по всем другим сетям на каждый товар.
#
# Сортировка по real_discount, а не по claimed: смысл ленты в том, чтобы
# показать настоящую выгоду, а не самую громкую наклейку.
DEALS = """
SELECT d.store_item_id,
       d.product_id,
       p.name, p.brand, p.ean, p.image_url,
       c.code            AS chain_code,
       d.store_id,
       st.name           AS store_name,
       st.price_cluster,
       d.price,
       d.old_price,
       d.market_price,
       d.ref_count,
       d.claimed_discount,
       d.real_discount,
       d.inflation,
       d.inflated,
       d.observed_at
FROM deal_honesty d
JOIN products p     ON p.id = d.product_id
JOIN chains c       ON c.id = d.chain_id
LEFT JOIN stores st ON st.id = d.store_id
WHERE (CAST(:min_discount AS float8) IS NULL OR d.real_discount >= CAST(:min_discount AS float8))
  AND (CAST(:category AS text)     IS NULL OR p.category = CAST(:category AS text))
  -- «только мои сети». Фильтруем на сервере, а не в клиенте: при курсорной
  -- пагинации клиентский фильтр выбросил бы половину страницы, и человек
  -- увидел бы три акции там, где их двадцать.
  AND (CAST(:chains AS text[]) IS NULL OR c.code = ANY(CAST(:chains AS text[])))
  -- при выбранном магазине у его сети остаются только позиции этого магазина
  AND (CAST(:sel_chain_id AS int) IS NULL
       OR d.chain_id <> CAST(:sel_chain_id AS int)
       OR d.store_id  = CAST(:sel_store_id AS int))
  AND (CAST(:cur_disc AS float8) IS NULL
       OR d.real_discount < CAST(:cur_disc AS float8)
       OR (d.real_discount = CAST(:cur_disc AS float8) AND d.store_item_id > CAST(:cur_id AS int)))
ORDER BY d.real_discount DESC, d.store_item_id
LIMIT :lim
"""


@router.get("/deals", response_model=DealsResponse, summary="Лента акций")
async def deals(
    response: Response,
    limit: int = Depends(limit_param),
    cursor: str | None = Query(None),
    category: str | None = Query(
        None,
        description=(
            "Категория товара. Список доступных — GET /v1/categories. "
            "ВНИМАНИЕ: products.category в текущем дампе пуста на 100%, "
            "поэтому любой фильтр по категории вернёт пустой список"
        ),
    ),
    chains: str | None = Query(
        None,
        description=(
            "«Только мои сети»: коды через запятую, например bravo,araz. "
            "Пусто — все сети"
        ),
    ),
    min_discount: float | None = Query(
        None, ge=-1.0, le=1.0,
        description="Порог по НАСТОЯЩЕЙ скидке в долях: 0.25 = минус 25% от рынка",
    ),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Акции, отсортированные по настоящей скидке.

    Настоящая скидка считается от медианы неакционных цен на тот же штрихкод в
    других сетях, а не от зачёркнутой цены на ценнике. Оба числа отдаются рядом,
    плюс флаг `inflated`, когда заявленная скидка глубже настоящей больше чем на
    15 процентных пунктов.
    """
    chain_list = (
        [c.strip() for c in chains.split(",") if c.strip()] if chains else None
    ) or None

    params = {
        "limit": limit,
        "cursor": cursor,
        "category": category,
        "min_discount": min_discount,
        "chains": ",".join(sorted(chain_list)) if chain_list else None,
        "store_id": sel.store_id,
    }

    async def build() -> DealsResponse:
        cur = decode_cursor(cursor) or {}
        rows = (
            await conn.execute(
                text(DEALS),
                {
                    "min_discount": min_discount,
                    "category": category,
                    "chains": chain_list,
                    "sel_chain_id": sel.chain_id,
                    "sel_store_id": sel.store_id,
                    "cur_disc": cur.get("d"),
                    "cur_id": cur.get("id"),
                    "lim": limit + 1,
                },
            )
        ).mappings().all()

        has_more = len(rows) > limit
        rows = rows[:limit]

        items = [
            Deal(
                deal_id=r["store_item_id"],
                product_id=r["product_id"],
                name=r["name"],
                brand=r["brand"],
                ean=r["ean"],
                image_url=r["image_url"],
                chain_code=r["chain_code"],
                store_id=r["store_id"],
                store_name=r["store_name"],
                price_cluster=r["price_cluster"],
                price_minor=r["price"],
                old_price_minor=r["old_price"],
                market_price_minor=r["market_price"],
                reference_chains=r["ref_count"],
                claimed_discount=r["claimed_discount"],
                real_discount=r["real_discount"],
                inflation=r["inflation"],
                inflated=r["inflated"],
                observed_at=r["observed_at"],
            )
            for r in rows
        ]

        next_cursor = None
        if has_more and rows:
            last = rows[-1]
            next_cursor = encode_cursor(
                {"d": float(last["real_discount"]), "id": last["store_item_id"]}
            )

        return DealsResponse(
            items=items, next_cursor=next_cursor, has_more=has_more
        )

    return await cached(response, "deals", params, build)

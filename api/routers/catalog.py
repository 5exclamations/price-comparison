"""GET /v1/catalog — товары магазина или сети, с фильтром по разделу.

Отличие от /v1/search: там человек ищет конкретное, здесь — смотрит, что
вообще есть. Поэтому нет обязательного `q`, а сортировка не по похожести,
а по названию: список должен быть предсказуемым и повторяемым между
страницами.

Отличие от /v1/deals: лента показывает только то, где есть выгода. Каталог
показывает всё, включая товары без акции, — иначе «посмотреть ассортимент
Bravo» невозможно.
"""
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..deps import SelectedStore, limit_param, selected_store
from ..http import cached
from ..paging import decode_cursor, encode_cursor
from ..pricing import load_chain_counts, load_prices, summarize
from ..schemas import (
    CatalogResponse,
    CategoriesResponse,
    CategoryOut,
    SearchItem,
)

router = APIRouter()

# Товар попадает в каталог сети, если у неё есть хотя бы одна его позиция
# С ЦЕНОЙ. Без проверки цены в список лезут позиции, которые сеть завела, но
# никогда не продавала, и каталог начинает врать о наличии.
#
# EXISTS, а не JOIN: товар может лежать в сети десятком позиций по филиалам,
# и join размножил бы строки, а DISTINCT по 36 тысячам строк стоит дороже.
CATALOG = """
SELECT p.id, p.name, p.brand, p.ean, p.image_url, p.unit_value, p.unit_type
FROM products p
WHERE p.quarantined = 0
  AND (CAST(:category AS text) IS NULL OR p.category = CAST(:category AS text))
  AND EXISTS (
        SELECT 1
        FROM store_items si
        JOIN current_prices cp ON cp.store_item_id = si.id
        WHERE si.product_id = p.id
          AND (CAST(:chain_id AS int) IS NULL OR si.chain_id = CAST(:chain_id AS int))
          AND (CAST(:store_id AS int) IS NULL OR si.store_id = CAST(:store_id AS int))
      )
  AND (CAST(:cur_name AS text) IS NULL
       OR (p.name, p.id) > (CAST(:cur_name AS text), CAST(:cur_id AS int)))
ORDER BY p.name, p.id
LIMIT :lim
"""

# Разделы, в которых у выбранной сети или магазина реально есть товары.
# Показывать раздел, дающий пустой список, — обманывать человека его же
# ожиданием: он тыкает и решает, что приложение сломано.
CATALOG_CATEGORIES = """
SELECT p.category, count(*) AS n
FROM products p
WHERE p.quarantined = 0 AND p.category IS NOT NULL
  AND EXISTS (
        SELECT 1 FROM store_items si
        JOIN current_prices cp ON cp.store_item_id = si.id
        WHERE si.product_id = p.id
          AND (CAST(:chain_id AS int) IS NULL OR si.chain_id = CAST(:chain_id AS int))
          AND (CAST(:store_id AS int) IS NULL OR si.store_id = CAST(:store_id AS int))
      )
GROUP BY p.category
ORDER BY count(*) DESC, p.category
"""


@router.get("/catalog", response_model=CatalogResponse, summary="Товары магазина")
async def catalog(
    response: Response,
    chain_id: int | None = Query(None, description="Сеть целиком"),
    store_id: int | None = Query(None, description="Конкретная точка"),
    category: str | None = Query(None, description="Раздел из /v1/catalog/categories"),
    limit: int = Depends(limit_param),
    cursor: str | None = Query(None),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Каталог: что вообще продаётся, с ценами по всем сетям.

    chain_id и store_id — про то, ЧЕЙ ассортимент показывать. Выбранный
    магазин (заголовок/параметр `sel`) — про то, чью цену считать применимой,
    и это разные вещи: можно смотреть каталог Bravo, держа выбранной точку Araz.
    """
    params = {
        "chain_id": chain_id,
        "store_id": store_id,
        "category": category,
        "limit": limit,
        "cursor": cursor,
        "sel_store": sel.store_id,
    }

    async def build() -> CatalogResponse:
        cur = decode_cursor(cursor) or {}
        rows = (
            await conn.execute(
                text(CATALOG),
                {
                    "chain_id": chain_id,
                    "store_id": store_id,
                    "category": category,
                    "cur_name": cur.get("name"),
                    "cur_id": cur.get("id"),
                    "lim": limit + 1,
                },
            )
        ).mappings().all()

        has_more = len(rows) > limit
        rows = rows[:limit]

        ids = [r["id"] for r in rows]
        prices = await load_prices(conn, ids, sel)
        counts = await load_chain_counts(conn, ids)

        items = []
        for r in rows:
            pid = r["id"]
            summary = summarize(prices.get(pid, []))
            chains_count, has_promo = counts.get(pid, (0, False))
            items.append(
                SearchItem(
                    product_id=pid,
                    name=r["name"],
                    brand=r["brand"],
                    ean=r["ean"],
                    image_url=r["image_url"],
                    unit_value=r["unit_value"],
                    unit_type=r["unit_type"],
                    best_price_minor=summary.best_price_minor,
                    best_price_chain=summary.best_price_chain,
                    chains_count=chains_count,
                    has_promo=has_promo,
                    observed_at=summary.best_observed_at,
                    needs_store_selection=bool(summary.needs_store_selection),
                )
            )

        next_cursor = None
        if has_more and rows:
            last = rows[-1]
            next_cursor = encode_cursor({"name": last["name"], "id": last["id"]})

        return CatalogResponse(
            items=items, next_cursor=next_cursor, has_more=has_more
        )

    return await cached(response, "catalog", params, build)


@router.get(
    "/catalog/categories",
    response_model=CategoriesResponse,
    summary="Разделы каталога",
)
async def catalog_categories(
    response: Response,
    chain_id: int | None = Query(None),
    store_id: int | None = Query(None),
    conn: AsyncConnection = Depends(get_conn),
):
    """Разделы, в которых у этой сети или точки реально есть товары в продаже."""

    async def build() -> CategoriesResponse:
        rows = (
            await conn.execute(
                text(CATALOG_CATEGORIES),
                {"chain_id": chain_id, "store_id": store_id},
            )
        ).all()
        return CategoriesResponse(
            # deals_count здесь — число ТОВАРОВ в разделе, а не акций: поле
            # переиспользуется, чтобы клиенту не заводить вторую модель
            # ради одного числа.
            items=[CategoryOut(code=c, deals_count=n) for c, n in rows]
        )

    return await cached(
        response, "catalog-categories",
        {"chain_id": chain_id, "store_id": store_id}, build,
    )

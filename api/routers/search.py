"""GET /v1/search — поиск по названию и по штрихкоду."""
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..deps import SelectedStore, limit_param, selected_store
from ..http import cached
from ..normalize import barcode_digits, looks_like_barcode, normalize
from ..paging import decode_cursor, encode_cursor
from ..pricing import load_chain_counts, load_prices, summarize
from ..schemas import SearchItem, SearchResponse

router = APIRouter()

# Поиск по названию. Обёртка qiymet_norm стоит с обеих сторон: индекс построен
# по выражению qiymet_norm(name), и запрос обязан совпадать с ним символ в
# символ, иначе GIN не применится. Функция идемпотентна, так что повторное
# применение к уже нормализованному запросу безопасно.
#
# Сортировка: сначала похожесть, потом id. Второй ключ обязателен — без него
# товары с одинаковой похожестью прыгали бы между страницами.
SEARCH_BY_NAME = """
SELECT p.id, p.name, p.brand, p.ean, p.unit_value, p.unit_type,
       similarity(qiymet_norm(p.name), qiymet_norm(:q)) AS sim
FROM products p
WHERE p.quarantined = 0
  AND qiymet_norm(p.name) LIKE '%' || qiymet_norm(:q) || '%'
  AND (
        CAST(:cur_sim AS float8) IS NULL
     OR similarity(qiymet_norm(p.name), qiymet_norm(:q)) < CAST(:cur_sim AS float8)
     OR (similarity(qiymet_norm(p.name), qiymet_norm(:q)) = CAST(:cur_sim AS float8)
         AND p.id > CAST(:cur_id AS int))
      )
ORDER BY sim DESC, p.id
LIMIT :lim
"""

# Штрихкод ищется точным совпадением: и по каноническому товару, и по тому, что
# отдала сеть. Второе нужно, потому что products.ean заполнен не всегда, а
# store_items.ean часто есть.
SEARCH_BY_BARCODE = """
SELECT DISTINCT p.id, p.name, p.brand, p.ean, p.unit_value, p.unit_type,
       1.0::float8 AS sim
FROM products p
LEFT JOIN store_items si ON si.product_id = p.id
WHERE p.quarantined = 0
  AND (p.ean = :code OR si.ean = :code)
  AND (CAST(:cur_id AS int) IS NULL OR p.id > CAST(:cur_id AS int))
ORDER BY p.id
LIMIT :lim
"""


@router.get("/search", response_model=SearchResponse, summary="Поиск товара")
async def search(
    response: Response,
    q: str = Query(min_length=1, description="Название или штрихкод"),
    limit: int = Depends(limit_param),
    cursor: str | None = Query(None),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Ищет товар и сразу отдаёт лучшую цену, число сетей и флаг акции.

    Карантинные склейки не показываются никогда: `products.quarantined = 1`
    отсекается прямо в запросе.
    """
    params = {
        "q": q,
        "limit": limit,
        "cursor": cursor,
        "store_id": sel.store_id,
    }

    async def build() -> SearchResponse:
        cur = decode_cursor(cursor) or {}
        by_barcode = looks_like_barcode(q)

        if by_barcode:
            rows = (
                await conn.execute(
                    text(SEARCH_BY_BARCODE),
                    {"code": barcode_digits(q), "cur_id": cur.get("id"),
                     "lim": limit + 1},
                )
            ).mappings().all()
        else:
            rows = (
                await conn.execute(
                    text(SEARCH_BY_NAME),
                    {"q": q, "cur_sim": cur.get("sim"), "cur_id": cur.get("id"),
                     "lim": limit + 1},
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
            next_cursor = encode_cursor(
                {"id": last["id"]}
                if by_barcode
                else {"sim": float(last["sim"]), "id": last["id"]}
            )

        return SearchResponse(
            query=q,
            normalized_query=normalize(q),
            matched_by="barcode" if by_barcode else "name",
            items=items,
            next_cursor=next_cursor,
            has_more=has_more,
        )

    return await cached(response, "search", params, build)

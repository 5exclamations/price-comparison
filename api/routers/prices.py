"""GET /v1/prices — цены по сетям для нескольких товаров сразу."""
from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.ext.asyncio import AsyncConnection

from ..config import settings
from ..db import get_conn
from ..deps import SelectedStore, selected_store
from ..http import cached
from ..pricing import load_prices
from ..schemas import BasketPrices, BasketProduct, ChainPrice

router = APIRouter()

# Больше за раз не отдаём: список покупок такой длины — уже не список.
# Ограничение нужно, чтобы одним запросом нельзя было попросить весь каталог.
MAX_PRODUCTS = 200


@router.get("/prices", response_model=BasketPrices, summary="Цены для списка")
async def prices(
    response: Response,
    product_ids: str = Query(
        ...,
        description="Идентификаторы через запятую, не больше 200",
        examples=["9150,12940,8983"],
    ),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Цены по всем сетям для списка товаров.

    Один запрос вместо N: список покупок открывают в магазине, где связь
    плохая, и тридцать отдельных запросов там не доедут.

    Карантинные склейки и несуществующие товары попадают в `missing`, а не
    молча пропадают: клиенту важно отличать «нет цены» от «мы это потеряли».
    """
    try:
        ids = sorted(
            {int(x) for x in product_ids.split(",") if x.strip()}
        )
    except ValueError:
        raise HTTPException(status_code=400, detail="product_ids: только числа")

    if not ids:
        raise HTTPException(status_code=400, detail="product_ids пуст")
    if len(ids) > MAX_PRODUCTS:
        raise HTTPException(
            status_code=400,
            detail=f"Не больше {MAX_PRODUCTS} товаров за раз, пришло {len(ids)}",
        )

    params = {"ids": ",".join(map(str, ids)), "store_id": sel.store_id}

    async def build() -> BasketPrices:
        from sqlalchemy import text

        rows = (
            await conn.execute(
                text(
                    "SELECT id, name, brand, ean, unit_value, unit_type "
                    "FROM products WHERE id = ANY(CAST(:ids AS int[])) "
                    "AND quarantined = 0"
                ),
                {"ids": ids},
            )
        ).mappings().all()

        prices_by_product = await load_prices(conn, [r["id"] for r in rows], sel)

        items = [
            BasketProduct(
                product_id=r["id"],
                name=r["name"],
                brand=r["brand"],
                ean=r["ean"],
                unit_value=r["unit_value"],
                unit_type=r["unit_type"],
                prices=[
                    ChainPrice(
                        chain_id=p.chain_id,
                        chain_code=p.chain_code,
                        chain_name=p.chain_name,
                        price_model=p.price_model,
                        store_id=p.store_id,
                        store_name=p.store_name,
                        price_cluster=p.price_cluster,
                        price_minor=p.price,
                        old_price_minor=p.old_price,
                        is_promo=p.is_promo,
                        available=p.available,
                        observed_at=p.observed_at,
                        source=p.source,
                        requires_store_selection=p.requires_store_selection,
                    )
                    for p in sorted(
                        prices_by_product.get(r["id"], []),
                        key=lambda p: (p.price, p.chain_code),
                    )
                ],
            )
            for r in rows
        ]
        found = {i.product_id for i in items}

        return BasketPrices(
            items=items,
            missing=[i for i in ids if i not in found],
            stale_after_hours=settings.stale_after_hours,
        )

    return await cached(response, "prices", params, build)

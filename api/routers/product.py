"""GET /v1/product/{id} — карточка товара и история цены."""
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Path, Query, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..deps import SelectedStore, selected_store
from ..http import cached
from ..pricing import load_chain_counts, load_prices, summarize
from ..schemas import (
    ChainPrice,
    HistoryEvent,
    HistoryPoint,
    HistoryResponse,
    ProductCard,
)

router = APIRouter()

PRODUCT = """
SELECT id, name, brand, ean, unit_value, unit_type, quarantined
FROM products WHERE id = :pid
"""

# История: соседние наблюдения по одной позиции — это и есть событие.
# price_observations пишется только при изменении, поэтому LAG по времени даёт
# готовый список переходов. Логика классификации перенесена из
# pipeline/history.py (функция classify).
HISTORY = """
WITH seq AS (
    SELECT po.store_item_id,
           po.price,
           po.old_price,
           po.available,
           po.observed_at,
           lag(po.price)       OVER w AS prev_price,
           lag(po.old_price)   OVER w AS prev_old,
           lag(po.available)   OVER w AS prev_available
    FROM price_observations po
    JOIN store_items si ON si.id = po.store_item_id
    WHERE si.product_id = :pid
      AND po.observed_at >= :since
      AND (CAST(:sel_chain_id AS int) IS NULL
           OR si.chain_id <> CAST(:sel_chain_id AS int)
           OR si.store_id  = CAST(:sel_store_id AS int))
    WINDOW w AS (PARTITION BY po.store_item_id ORDER BY po.observed_at)
)
SELECT s.*, c.code AS chain_code, si.store_id, st.price_cluster
FROM seq s
JOIN store_items si ON si.id = s.store_item_id
JOIN chains c       ON c.id = si.chain_id
LEFT JOIN stores st ON st.id = si.store_id
ORDER BY s.observed_at
"""


def _classify(r) -> str | None:
    """Дословный перенос classify() из pipeline/history.py."""
    was_promo, now_promo = bool(r["prev_old"]), bool(r["old_price"])
    if not was_promo and now_promo:
        return "promo_started"
    if was_promo and not now_promo:
        return "promo_ended"
    if r["price"] == r["prev_price"]:
        # Цена та же, поехало наличие.
        return "availability_changed" if r["available"] != r["prev_available"] else None
    return "price_down" if r["price"] < r["prev_price"] else "price_up"


@router.get(
    "/product/{product_id}", response_model=ProductCard, summary="Карточка товара"
)
async def product_card(
    response: Response,
    product_id: int = Path(ge=1),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Цены по всем сетям. Для Bravo — по зоне выбранного магазина.

    Карантинный товар отдаёт 404: склейке не доверяем, показывать её нельзя.
    Для клиента это неотличимо от несуществующего товара, и так и задумано.
    """
    params = {"product_id": product_id, "store_id": sel.store_id}

    async def build() -> ProductCard:
        row = (
            await conn.execute(text(PRODUCT), {"pid": product_id})
        ).mappings().first()

        if row is None or row["quarantined"] == 1:
            raise HTTPException(status_code=404, detail="Товар не найден")

        prices = (await load_prices(conn, [product_id], sel)).get(product_id, [])
        counts = await load_chain_counts(conn, [product_id])
        chains_count, _ = counts.get(product_id, (0, False))
        summary = summarize(prices)

        return ProductCard(
            product_id=row["id"],
            name=row["name"],
            brand=row["brand"],
            ean=row["ean"],
            unit_value=row["unit_value"],
            unit_type=row["unit_type"],
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
                for p in sorted(prices, key=lambda p: (p.price, p.chain_code))
            ],
            chains_count=chains_count,
            best_price_minor=summary.best_price_minor,
            best_price_chain=summary.best_price_chain,
            needs_store_selection=summary.needs_store_selection,
        )

    return await cached(response, "product", params, build)


@router.get(
    "/product/{product_id}/history",
    response_model=HistoryResponse,
    summary="История цены",
)
async def product_history(
    response: Response,
    product_id: int = Path(ge=1),
    days: int = Query(30, ge=1, le=365),
    sel: SelectedStore = Depends(selected_store),
    conn: AsyncConnection = Depends(get_conn),
):
    """Точки для графика плюс события «акция началась / кончилась».

    События берутся из соседних наблюдений: таблица append-only и пишется только
    при изменении, поэтому каждая пара соседних записей — уже событие.
    """
    params = {"product_id": product_id, "days": days, "store_id": sel.store_id}

    async def build() -> HistoryResponse:
        row = (
            await conn.execute(text(PRODUCT), {"pid": product_id})
        ).mappings().first()
        if row is None or row["quarantined"] == 1:
            raise HTTPException(status_code=404, detail="Товар не найден")

        since = datetime.now(timezone.utc) - timedelta(days=days)
        rows = (
            await conn.execute(
                text(HISTORY),
                {
                    "pid": product_id,
                    "since": since,
                    "sel_chain_id": sel.chain_id,
                    "sel_store_id": sel.store_id,
                },
            )
        ).mappings().all()

        points, events = [], []
        for r in rows:
            points.append(
                HistoryPoint(
                    observed_at=r["observed_at"],
                    price_minor=r["price"],
                    old_price_minor=r["old_price"],
                    is_promo=r["old_price"] is not None,
                    available=bool(r["available"]),
                    chain_code=r["chain_code"],
                    store_id=r["store_id"],
                    price_cluster=r["price_cluster"],
                )
            )

            if r["prev_price"] is None:
                continue
            kind = _classify(r)
            if kind is None:
                continue

            # Накрутка перед скидкой: акция началась, а заявленное «было» выше
            # той цены, которую мы видели своими глазами в прошлый раз.
            inflated = bool(
                kind == "promo_started"
                and r["old_price"]
                and r["old_price"] > r["prev_price"]
            )
            events.append(
                HistoryEvent(
                    observed_at=r["observed_at"],
                    kind=kind,
                    chain_code=r["chain_code"],
                    store_id=r["store_id"],
                    price_cluster=r["price_cluster"],
                    price_minor=r["price"],
                    prev_price_minor=r["prev_price"],
                    old_price_minor=r["old_price"],
                    inflated_old_price=inflated,
                )
            )

        return HistoryResponse(
            product_id=product_id,
            days=days,
            since=since,
            points=points,
            events=events,
        )

    return await cached(response, "history", params, build)

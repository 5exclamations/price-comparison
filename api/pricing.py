"""Сбор цен по товарам и подсчёт лучшей цены."""
from dataclasses import dataclass
from datetime import datetime

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from .deps import SelectedStore
from .sql import APPLICABLE_PRICES, CHAINS_COUNT


@dataclass
class PriceRow:
    product_id: int
    chain_id: int
    chain_code: str
    chain_name: str
    price_model: str
    store_id: int | None
    store_name: str | None
    price_cluster: str | None
    price: int
    old_price: int | None
    is_promo: bool
    available: bool
    observed_at: datetime
    source: str
    requires_store_selection: bool


@dataclass
class Summary:
    best_price_minor: int | None
    best_price_chain: str | None
    best_observed_at: datetime | None
    needs_store_selection: list[str]


async def load_prices(
    conn: AsyncConnection, ids: list[int], sel: SelectedStore
) -> dict[int, list[PriceRow]]:
    if not ids:
        return {}
    rows = (
        await conn.execute(
            text(APPLICABLE_PRICES),
            {
                "ids": ids,
                "sel_chain_id": sel.chain_id,
                "sel_store_id": sel.store_id,
            },
        )
    ).mappings()

    out: dict[int, list[PriceRow]] = {}
    for r in rows:
        out.setdefault(r["product_id"], []).append(
            PriceRow(
                product_id=r["product_id"],
                chain_id=r["chain_id"],
                chain_code=r["chain_code"],
                chain_name=r["chain_name"],
                price_model=r["price_model"],
                store_id=r["store_id"],
                store_name=r["store_name"],
                price_cluster=r["price_cluster"],
                price=r["price"],
                old_price=r["old_price"],
                is_promo=bool(r["is_promo"]),
                available=bool(r["available"]),
                observed_at=r["observed_at"],
                source=r["source"],
                requires_store_selection=bool(r["requires_store_selection"]),
            )
        )
    return out


async def load_chain_counts(
    conn: AsyncConnection, ids: list[int]
) -> dict[int, tuple[int, bool]]:
    if not ids:
        return {}
    rows = (await conn.execute(text(CHAINS_COUNT), {"ids": ids})).all()
    return {r[0]: (r[1], bool(r[2])) for r in rows}


def summarize(rows: list[PriceRow]) -> Summary:
    """Лучшая цена считается только по тем сетям, чью цену вообще можно назвать.

    Bravo без выбранного магазина в расчёт не идёт: у сети четыре зоны, и любая
    из них, поставленная как «лучшая цена», была бы выдумкой. Вместо этого сеть
    попадает в needs_store_selection, и клиент может честно предложить выбрать
    магазин.
    """
    showable = [r for r in rows if not r.requires_store_selection and r.available]
    if not showable:
        # Все цены либо требуют выбора магазина, либо товара нет в наличии.
        showable = [r for r in rows if not r.requires_store_selection]

    best = min(showable, key=lambda r: r.price) if showable else None
    hidden = sorted({r.chain_code for r in rows if r.requires_store_selection})

    return Summary(
        best_price_minor=best.price if best else None,
        best_price_chain=best.chain_code if best else None,
        best_observed_at=best.observed_at if best else None,
        needs_store_selection=hidden,
    )

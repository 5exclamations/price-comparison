"""Общие зависимости эндпоинтов."""
from dataclasses import dataclass

from fastapi import Depends, HTTPException, Query
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from .config import settings
from .db import get_conn


@dataclass(frozen=True)
class SelectedStore:
    """Разобранный ?store_id=. Пустой, если магазин не выбран."""

    store_id: int | None = None
    chain_id: int | None = None
    chain_code: str | None = None
    price_cluster: str | None = None

    @property
    def chosen(self) -> bool:
        return self.store_id is not None


async def selected_store(
    store_id: int | None = Query(
        None,
        description=(
            "Магазин из /v1/stores. Обязателен, чтобы увидеть цену Bravo: "
            "у сети четыре ценовые зоны. Сетям с единой ценой не нужен"
        ),
    ),
    conn: AsyncConnection = Depends(get_conn),
) -> SelectedStore:
    if store_id is None:
        return SelectedStore()

    row = (
        await conn.execute(
            text(
                """
                SELECT s.id, s.chain_id, c.code, s.price_cluster
                FROM stores s JOIN chains c ON c.id = s.chain_id
                WHERE s.id = :sid
                """
            ),
            {"sid": store_id},
        )
    ).first()

    # Несуществующий магазин — это ошибка клиента, а не повод молча показать
    # цены «в среднем по стране». У Bravo это дало бы цену чужой зоны.
    if row is None:
        raise HTTPException(status_code=404, detail=f"Магазин {store_id} не найден")

    return SelectedStore(
        store_id=row[0], chain_id=row[1], chain_code=row[2], price_cluster=row[3]
    )


def limit_param(
    limit: int = Query(
        settings.default_limit, ge=1, le=settings.max_limit,
        description=f"Не больше {settings.max_limit}",
    ),
) -> int:
    return limit

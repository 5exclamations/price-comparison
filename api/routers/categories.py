"""GET /v1/categories — категории, по которым есть смысл фильтровать."""
from fastapi import APIRouter, Depends, Response
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from ..db import get_conn
from ..http import cached
from ..schemas import CategoriesResponse, CategoryOut

router = APIRouter()

# Только те категории, у которых сейчас есть хотя бы одна акция. Показывать
# в фильтре категорию, дающую пустой список, — обманывать пользователя его же
# ожиданием: он тыкает и решает, что приложение сломано.
CATEGORIES = """
SELECT p.category, count(*) AS deals
FROM deal_honesty d
JOIN products p ON p.id = d.product_id
WHERE p.category IS NOT NULL AND p.category <> ''
GROUP BY p.category
ORDER BY count(*) DESC, p.category
"""


@router.get(
    "/categories", response_model=CategoriesResponse, summary="Категории"
)
async def categories(
    response: Response,
    conn: AsyncConnection = Depends(get_conn),
):
    """Категории, в которых сейчас есть акции.

    Пустой список — законное состояние: на базе, куда категории ещё не
    доехали, здесь будет пусто. Клиент обязан прятать фильтр, а не показывать
    ряд чипов, ни один из которых ничего не отфильтрует.
    """

    async def build() -> CategoriesResponse:
        rows = (await conn.execute(text(CATEGORIES))).all()
        return CategoriesResponse(
            items=[CategoryOut(code=r[0], deals_count=r[1]) for r in rows],
        )

    return await cached(response, "categories", {}, build)

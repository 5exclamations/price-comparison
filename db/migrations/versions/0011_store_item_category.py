"""Раздел каталога у позиции сети.

Revision ID: 0011
Revises: 0010
Create Date: 2026-08-26

products.category существует с первой миграции, но заполнена не была: пайплайн
её не собирал. Wolt отдаёт раздел вместе с позицией (коннектор его забирал
и выбрасывал), Shopify — в product_type. Теперь и то, и другое едет в
store_items.category, а pipeline переносит на карточку самый частый раздел
среди её позиций.

Почему самый частый, а не первый попавшийся: сети раскладывают один товар
по-разному, и «Süd» из трёх сетей против «Səhər yeməyi» из одной — это
молочный отдел, а не завтраки.

Индекс на products.category нужен: по нему фильтруется лента акций и каталог
магазина, и оба запроса без него превращаются в полный проход по таблице.
Частичный (WHERE category IS NOT NULL) — потому что на пустых значениях
фильтра не бывает, а пустых сейчас большинство.
"""
from alembic import op
import sqlalchemy as sa

revision = "0011"
down_revision = "0010"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("store_items", sa.Column("category", sa.Text(), nullable=True))
    op.create_index(
        "idx_products_category",
        "products",
        ["category"],
        postgresql_where=sa.text("category IS NOT NULL"),
    )


def downgrade() -> None:
    op.drop_index("idx_products_category", table_name="products")
    op.drop_column("store_items", "category")

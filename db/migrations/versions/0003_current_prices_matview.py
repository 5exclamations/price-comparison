"""current_prices как материализованное представление + витрина product_prices.

Revision ID: 0003
Revises: 0002
Create Date: 2026-08-16

Почему матвьюха, а не обычная. В SQLite current_prices была обычной вьюхой с
join на подзапрос GROUP BY store_item_id MAX(observed_at). На секционированной
таблице в десятки миллионов строк это агрегат по всем секциям на каждый запрос:
«текущая цена» превращается в полный проход по всей истории.

Почему DISTINCT ON, а не MAX-join. Старый join по x.m = p.observed_at вернёт ДВЕ
строки на позицию, если два наблюдения попали в одну секунду. Пайплайн ставит
время через datetime('now') с точностью до секунды, так что это вопрос времени,
а не гипотеза. DISTINCT ON с добиванием по id DESC даёт ровно одну строку на
store_item_id — без этого невозможен UNIQUE-индекс, а без него не работает
REFRESH CONCURRENTLY.

is_promo здесь boolean, а не 0/1 как в SQLite: ни пайплайн, ни витрина это поле
не читают, менять нечего, а boolean — родной тип Postgres для такого выражения.
"""
from alembic import op

revision = "0003"
down_revision = "0002"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        CREATE MATERIALIZED VIEW current_prices AS
        SELECT DISTINCT ON (store_item_id)
               store_item_id,
               price,
               old_price,
               promo_until,
               (old_price IS NOT NULL) AS is_promo,
               available,
               observed_at,
               source
        FROM price_observations
        ORDER BY store_item_id, observed_at DESC, id DESC
        WITH DATA
        """
    )
    op.execute(
        "COMMENT ON MATERIALIZED VIEW current_prices IS "
        "'Последнее наблюдение по каждой позиции. Обновлять "
        "SELECT refresh_current_prices() после каждого прогона сбора'"
    )

    # Обязателен для REFRESH ... CONCURRENTLY. Он же — рабочий индекс для join
    # store_items.id = current_prices.store_item_id.
    op.execute(
        "CREATE UNIQUE INDEX current_prices_store_item_key "
        "ON current_prices(store_item_id)"
    )

    # CONCURRENTLY не блокирует читателей: витрина продолжает отвечать, пока
    # матвьюха пересобирается. Цена — двойная работа и требование уникального
    # индекса, оба условия выполнены.
    #
    # Первый REFRESH после создания WITH NO DATA обязан быть неконкурентным,
    # поэтому проверяем relispopulated, а не надеемся на удачу.
    op.execute(
        """
        CREATE FUNCTION refresh_current_prices()
        RETURNS void
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_populated boolean;
        BEGIN
            SELECT relispopulated INTO v_populated
            FROM pg_class WHERE oid = 'current_prices'::regclass;

            IF v_populated THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY current_prices;
            ELSE
                REFRESH MATERIALIZED VIEW current_prices;
            END IF;
        END;
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION refresh_current_prices() IS "
        "'Пересобрать current_prices. Вызывать после каждого прогона run.py fast/full'"
    )

    # ---------- Витрина: сравнение цены товара по сетям ----------
    # Колонки один в один с SQLite-вьюхой.
    #
    # price / 100.0 в Postgres даёт numeric, а не double precision: литерал 100.0
    # имеет тип numeric. То есть правило «никакого float для денег» не нарушено
    # даже здесь, на границе показа.
    op.execute(
        """
        CREATE VIEW product_prices AS
        SELECT pr.id            AS product_id,
               pr.name          AS product_name,
               pr.ean,
               c.code           AS chain,
               s.name           AS store,
               s.price_cluster,
               cp.price / 100.0 AS price_azn,
               cp.old_price / 100.0 AS old_price_azn,
               cp.available,
               cp.observed_at
        FROM products pr
        JOIN store_items si    ON si.product_id = pr.id
        JOIN chains c          ON c.id = si.chain_id
        LEFT JOIN stores s     ON s.id = si.store_id
        JOIN current_prices cp ON cp.store_item_id = si.id
        """
    )

    # То же самое, но без карантина. product_prices оставлена один в один с
    # SQLite и карантин НЕ фильтрует — а по правилу проекта склейки с
    # quarantined = 1 показывать пользователю нельзя никогда. Чтобы правило не
    # держалось на памяти прикладного разработчика, вот отдельная вьюха: API
    # должен ходить в неё.
    op.execute(
        """
        CREATE VIEW product_prices_public AS
        SELECT pp.*
        FROM product_prices pp
        JOIN products pr ON pr.id = pp.product_id
        WHERE pr.quarantined = 0
        """
    )
    op.execute(
        "COMMENT ON VIEW product_prices_public IS "
        "'product_prices без карантинных склеек. Витрина обязана читать эту вьюху, "
        "а не product_prices'"
    )


def downgrade() -> None:
    op.execute("DROP VIEW IF EXISTS product_prices_public")
    op.execute("DROP VIEW IF EXISTS product_prices")
    op.execute("DROP FUNCTION IF EXISTS refresh_current_prices()")
    op.execute("DROP MATERIALIZED VIEW IF EXISTS current_prices")

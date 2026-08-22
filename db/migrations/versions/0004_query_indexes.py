"""Индексы под три главных запроса витрины.

Revision ID: 0004
Revises: 0003
Create Date: 2026-08-16

  1. Поиск товара по подстроке названия  -> pg_trgm + GIN
  2. Цены товара по всем сетям           -> покрывающий индекс по product_id
  3. Лента акций                         -> частичный индекс WHERE old_price IS NOT NULL
"""
from alembic import op

revision = "0004"
down_revision = "0003"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ---------- 1. Поиск по подстроке названия ----------
    #
    # Нормализация обязана идти в порядке: заменить азербайджанские буквы,
    # ПОТОМ опустить регистр. Наоборот нельзя: lower('İ') в UTF-8 даёт
    # 'i' + U+0307 (комбинирующая точка), и «milka» перестаёт находить «MİLKA».
    # translate() отрабатывает до lower(), поэтому 'İ' до него не доживает.
    #
    # Функция строго IMMUTABLE — иначе Postgres не пустит её в индекс.
    op.execute(
        """
        CREATE FUNCTION qiymet_norm(text)
        RETURNS text
        LANGUAGE sql
        IMMUTABLE
        STRICT
        PARALLEL SAFE
        AS $$
            SELECT lower(translate($1,
                'İIıƏəÖöÜüÇçŞşĞğ',
                'IIiAaOoUuCcSsGg'))
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION qiymet_norm(text) IS "
        "'Нормализация азербайджанского текста для поиска: сначала замена "
        "İIıƏəÖöÜüÇçŞşĞğ, только потом lower(). Обратный порядок ломает İ'"
    )

    # Каноническое имя товара — то, что видит и ищет пользователь.
    op.execute(
        """
        CREATE INDEX idx_products_name_trgm
            ON products USING gin (qiymet_norm(name) gin_trgm_ops)
        """
    )
    op.execute(
        "COMMENT ON INDEX idx_products_name_trgm IS "
        "'Поиск по подстроке. Запрос обязан быть в той же обёртке: "
        "WHERE qiymet_norm(name) LIKE ''%'' || qiymet_norm(запрос) || ''%''. "
        "Триграммы работают от 3 символов, на более коротком запросе "
        "планировщик уйдёт в seq scan — это нормально'"
    )

    # norm_name пайплайн уже нормализует сам (транслит + нижний регистр), но
    # обёртка qiymet_norm всё равно нужна: индекс и запрос должны совпадать
    # выражение в выражение, а на уже нормализованной строке функция идемпотентна.
    op.execute(
        """
        CREATE INDEX idx_si_norm_name_trgm
            ON store_items USING gin (qiymet_norm(norm_name) gin_trgm_ops)
        """
    )

    # ---------- 2. Цены товара по всем сетям ----------
    #
    # Путь запроса: products.id -> store_items.product_id -> current_prices.store_item_id.
    # Второй шаг — единственный, где нужен индекс: складываем в него id, chain_id и
    # store_id, чтобы шаг закрывался index-only scan и не ходил в кучу.
    #
    # idx_si_product из 0001 после этого полностью перекрыт: те же ведущие колонки,
    # меньше полезной нагрузки. Держать оба — платить за вставку дважды.
    op.execute(
        """
        CREATE INDEX idx_si_product_covering
            ON store_items(product_id) INCLUDE (id, chain_id, store_id)
        """
    )
    op.execute("DROP INDEX idx_si_product")
    op.execute(
        "COMMENT ON INDEX idx_si_product_covering IS "
        "'Заменяет idx_si_product: те же ведущие колонки плюс INCLUDE под "
        "index-only scan в запросе цен по всем сетям'"
    )

    # idx_si_unmatched (WHERE product_id IS NULL) не трогаем: у него своя работа —
    # очередь матчера, и он на порядок меньше.

    # ---------- 3. Лента акций ----------
    #
    # Акция = old_price IS NOT NULL. Сейчас это 10 457 строк из 57 459, то есть
    # 18% таблицы; частичный индекс читает только их. INCLUDE закрывает выборку
    # целиком, без обращения к самой матвьюхе.
    #
    # Индекс на матвьюхе, а не на price_observations: лента показывает
    # действующие акции, а не историю.
    op.execute(
        """
        CREATE INDEX idx_cp_promo
            ON current_prices(store_item_id)
            INCLUDE (price, old_price, promo_until, observed_at)
            WHERE old_price IS NOT NULL
        """
    )
    op.execute(
        "COMMENT ON INDEX idx_cp_promo IS "
        "'Лента акций. Настоящая скидка считается от медианы неакционных цен на "
        "тот же товар в других сетях, а не от old_price — этот индекс только "
        "отбирает кандидатов'"
    )

    # REFRESH MATERIALIZED VIEW CONCURRENTLY перестраивает индексы матвьюхи сам,
    # так что idx_cp_promo переживает обновление.


def downgrade() -> None:
    op.execute("DROP INDEX IF EXISTS idx_cp_promo")
    op.execute("CREATE INDEX idx_si_product ON store_items(product_id)")
    op.execute("DROP INDEX IF EXISTS idx_si_product_covering")
    op.execute("DROP INDEX IF EXISTS idx_si_norm_name_trgm")
    op.execute("DROP INDEX IF EXISTS idx_products_name_trgm")
    op.execute("DROP FUNCTION IF EXISTS qiymet_norm(text)")

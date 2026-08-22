"""qiymet_norm по правилу из CLAUDE.md + витрина честности скидок.

Revision ID: 0005
Revises: 0004
Create Date: 2026-08-16

Две вещи.

1. qiymet_norm доведена до правила из CLAUDE.md и до поведения пайплайна.
   В 0004 она делала только translate азербайджанских букв и lower(). Не хватало
   двух вещей:

   - Кириллические двойники. pipeline.py в norm_name сворачивает а е о с р х у к
     в латиницу — сети мешают алфавиты внутри одного названия. Без этого поиск
     по products.name (там имя сырое, не нормализованное) не найдёт товар,
     в котором «о» кириллическая.
   - Комбинирующие знаки. CLAUDE.md требует NFD последним шагом. Нужно, если на
     вход пришла уже разложенная строка: 'I' + U+0307 вместо 'İ' — ровно то, что
     отдаёт JS-ный toLowerCase(). Без этого шага такой запрос не находит ничего.

   Порядок остался прежним и он единственно верный: сначала translate, потом
   lower, потом NFD и сброс диакритики. Если поменять первые два шага местами,
   lower('İ') даст 'i' + U+0307 — та самая ловушка из CLAUDE.md.

   Регистр кириллицы сворачивается таблицей замен, а НЕ функцией lower().
   Причина: lower() в Postgres зависит от локали базы. В кластере, созданном с
   --locale=C, lower('Щ') возвращает 'Щ'. Функция стоит в индексе, поэтому от
   локали зависело бы содержимое индекса: восстановили дамп в иначе настроенный
   сервер — и поиск молча начал терять товары. После этой замены lower() нужен
   только для ASCII, а он одинаков в любой локали. Проверено тестом
   test_python_normalize_matches_sql, который сверяет Python с SQL на живой базе.

   Функция идемпотентна: qiymet_norm(qiymet_norm(x)) = qiymet_norm(x). На это
   опирается API — он нормализует запрос у себя, а SQL применяет функцию ещё раз
   к обеим сторонам сравнения.

   Индексы по ней приходится пересоздать. CREATE OR REPLACE на функции,
   использованной в индексе, Postgres разрешает, но индекс после этого молча
   содержит записи по старому определению — то есть врёт.

2. deal_honesty — перенос pipeline/honesty.py в SQL.

   Настоящая скидка считается не от ценника сети, а от рынка: медиана
   НЕакционных цен на тот же товар в ДРУГИХ сетях. Разница между заявленной
   скидкой и настоящей — накрутка.

   Отсечка «дикого рынка» (0.33..3.0) перенесена дословно: если эталон втрое
   дешевле или втрое дороже заявленной старой цены, врёт скорее эталон, а не
   акция, и такие пары не судятся вовсе.
"""
from alembic import op

revision = "0005"
down_revision = "0004"
branch_labels = None
depends_on = None

# Заявленная скидка глубже настоящей больше чем на столько — накрутка.
# Значение из honesty.py (INFLATED = 0.15).
INFLATED_GAP = "0.15"

# Минимум неакционных цен в других сетях, чтобы вообще делать вывод (MIN_REF).
MIN_REF = "1"


def upgrade() -> None:
    # ---------- 1. qiymet_norm ----------
    op.execute("DROP INDEX idx_products_name_trgm")
    op.execute("DROP INDEX idx_si_norm_name_trgm")

    op.execute(
        r"""
        CREATE OR REPLACE FUNCTION qiymet_norm(text)
        RETURNS text
        LANGUAGE sql
        IMMUTABLE
        STRICT
        PARALLEL SAFE
        AS $$
            SELECT regexp_replace(
                     normalize(
                       lower(
                         translate($1,
                           -- 1. азербайджанские: сначала они, иначе lower сломает İ
                           'İIıƏəÖöÜüÇçŞşĞğ'
                           -- 2. кириллические двойники латиницы (как в
                           --    pipeline.norm_name), оба регистра сразу
                           || 'АЕОСРХУК' || 'аеосрхук'
                           -- 3. остальная кириллица в верхнем регистре: сворачиваем
                           --    сами, чтобы не зависеть от локали базы
                           || 'БВГДЁЖЗИЙЛМНПТФЦЧШЩЪЫЬЭЮЯ',
                           'iiiaaoouuccssgg'
                           || 'aeocpxyk' || 'aeocpxyk'
                           || 'бвгдёжзийлмнптфцчшщъыьэюя')),
                       NFD),
                     U&'[\0300-\036F]', '', 'g')
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION qiymet_norm(text) IS "
        "'Нормализация по правилу CLAUDE.md: translate азербайджанских и "
        "кириллических двойников -> lower -> NFD и сброс комбинирующих знаков. "
        "Порядок менять нельзя. Идемпотентна'"
    )

    op.execute(
        "CREATE INDEX idx_products_name_trgm "
        "ON products USING gin (qiymet_norm(name) gin_trgm_ops)"
    )
    op.execute(
        "CREATE INDEX idx_si_norm_name_trgm "
        "ON store_items USING gin (qiymet_norm(norm_name) gin_trgm_ops)"
    )

    # Поиск по штрихкоду идёт точным совпадением, ему нужен обычный btree.
    # products.ean уже UNIQUE, а вот store_items.ean индексирован в 0001 (idx_si_ean).
    # Дополнительно ничего не нужно.

    # ---------- 2. deal_honesty ----------
    op.execute(
        f"""
        CREATE MATERIALIZED VIEW deal_honesty AS
        WITH priced AS (
            -- Текущая цена каждой позиции по товарам, которые вообще можно судить:
            -- есть штрихкод и склейка не в карантине.
            SELECT si.id            AS store_item_id,
                   si.product_id,
                   si.chain_id,
                   si.store_id,
                   cp.price,
                   cp.old_price,
                   cp.observed_at
            FROM store_items si
            JOIN products p        ON p.id = si.product_id
            JOIN current_prices cp ON cp.store_item_id = si.id
            WHERE p.ean IS NOT NULL
              AND p.quarantined = 0
        ),
        promos AS (
            SELECT * FROM priced
            WHERE old_price IS NOT NULL AND old_price > price
        ),
        market AS (
            -- Базовая цена рынка: медиана неакционных цен в ДРУГИХ сетях.
            -- old_price = 0 трактуем как отсутствие акции — так делает honesty.py
            -- (там условие `not r['old_price']`).
            SELECT pr.store_item_id,
                   percentile_cont(0.5) WITHIN GROUP (ORDER BY ref.price)
                       AS market_price,
                   count(*) AS ref_count
            FROM promos pr
            JOIN priced ref
              ON ref.product_id = pr.product_id
             AND ref.chain_id  <> pr.chain_id
             AND (ref.old_price IS NULL OR ref.old_price = 0)
            GROUP BY pr.store_item_id
        )
        SELECT pr.store_item_id,
               pr.product_id,
               pr.chain_id,
               pr.store_id,
               pr.price,
               pr.old_price,
               pr.observed_at,
               round(m.market_price)::integer          AS market_price,
               m.ref_count::integer                    AS ref_count,
               -- Все три доли — double precision, как float в honesty.py.
               -- market_price ниже берётся НЕокруглённый, тоже как в оригинале:
               -- округление там только для печати.
               ((pr.old_price - pr.price)::float8 / pr.old_price)
                   AS claimed_discount,
               -- настоящая: (рынок - стало) / рынок. Может быть отрицательной,
               -- если «акционная» цена выше рынка.
               ((m.market_price - pr.price) / m.market_price)
                   AS real_discount,
               (((pr.old_price - pr.price)::float8 / pr.old_price)
                 - ((m.market_price - pr.price) / m.market_price))
                   AS inflation,
               (((pr.old_price - pr.price)::float8 / pr.old_price)
                 - ((m.market_price - pr.price) / m.market_price))
                 > {INFLATED_GAP}                      AS inflated
        FROM promos pr
        JOIN market m ON m.store_item_id = pr.store_item_id
        WHERE m.ref_count >= {MIN_REF}
          -- Отсечка дикого эталона, дословно из honesty.py: если рынок втрое
          -- дешевле или дороже заявленной старой цены, врёт эталон, а не акция.
          AND m.market_price / pr.old_price BETWEEN 0.33 AND 3.0
        WITH DATA
        """
    )
    op.execute(
        "COMMENT ON MATERIALIZED VIEW deal_honesty IS "
        "'Перенос pipeline/honesty.py в SQL. Настоящая скидка считается от медианы "
        "неакционных цен на тот же товар в других сетях, а не от old_price сети. "
        "Пересобирать после current_prices: SELECT refresh_after_crawl()'"
    )

    # Обязателен для REFRESH CONCURRENTLY. store_item_id уникален: каждая позиция
    # попадает в promos не более одного раза.
    op.execute(
        "CREATE UNIQUE INDEX deal_honesty_store_item_key "
        "ON deal_honesty(store_item_id)"
    )
    # Лента сортируется по настоящей скидке — под это отдельный индекс.
    op.execute(
        "CREATE INDEX idx_deal_honesty_real "
        "ON deal_honesty(real_discount DESC, store_item_id)"
    )
    op.execute("CREATE INDEX idx_deal_honesty_product ON deal_honesty(product_id)")

    # ---------- 3. Один вызов после прогона сбора ----------
    # Порядок обязателен: deal_honesty читает current_prices.
    op.execute(
        """
        CREATE FUNCTION refresh_after_crawl()
        RETURNS void
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_populated boolean;
        BEGIN
            PERFORM refresh_current_prices();

            SELECT relispopulated INTO v_populated
            FROM pg_class WHERE oid = 'deal_honesty'::regclass;

            IF v_populated THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY deal_honesty;
            ELSE
                REFRESH MATERIALIZED VIEW deal_honesty;
            END IF;
        END;
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION refresh_after_crawl() IS "
        "'Пересобрать обе витрины после прогона сбора, в правильном порядке. "
        "Вешать на тот же cron, что и run.py fast/full'"
    )


def downgrade() -> None:
    op.execute("DROP FUNCTION IF EXISTS refresh_after_crawl()")
    op.execute("DROP MATERIALIZED VIEW IF EXISTS deal_honesty")

    op.execute("DROP INDEX IF EXISTS idx_si_norm_name_trgm")
    op.execute("DROP INDEX IF EXISTS idx_products_name_trgm")
    op.execute(
        """
        CREATE OR REPLACE FUNCTION qiymet_norm(text)
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
        "CREATE INDEX idx_products_name_trgm "
        "ON products USING gin (qiymet_norm(name) gin_trgm_ops)"
    )
    op.execute(
        "CREATE INDEX idx_si_norm_name_trgm "
        "ON store_items USING gin (qiymet_norm(norm_name) gin_trgm_ops)"
    )

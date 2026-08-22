"""Схема qiymət на Postgres 16: перенос pipeline/schema.sql один в один.

Revision ID: 0001
Revises:
Create Date: 2026-08-16

Правила переноса SQLite -> Postgres, применённые здесь:

  INTEGER PRIMARY KEY   -> integer GENERATED ALWAYS AS IDENTITY
                           (для price_observations — bigint, таблица растёт вечно;
                            в SQLite INTEGER и так 64-битный, так что это не потеря)
  TEXT-времена          -> timestamptz, DEFAULT now()
                           В SQLite стояло datetime('now'), а это UTC. Импорт обязан
                           читать старые строки как UTC, иначе вся история цен
                           сместится на 4 часа (Баку = UTC+4).
  REAL                  -> double precision
  INTEGER-флаги (0/1)   -> smallint + CHECK (x IN (0,1))
                           НЕ boolean: в коде пайплайна и в CLAUDE.md написано
                           products.quarantined = 1, и запросы вида "= 1" должны
                           продолжать работать без правок.
  CHECK-и               -> сохранены дословно, с явными именами
  Деньги                -> integer в гяпиках. Ни numeric, ни float — как и было.

price_observations здесь сразу объявлена секционированной (PARTITION BY RANGE).
Обычную таблицу нельзя превратить в секционированную на месте: понадобился бы
полный rewrite с ACCESS EXCLUSIVE на десятках миллионов строк. Раз целевая схема
всё равно секционированная, объявляем так с самого начала. Сами секции и функции
их создания — в миграции 0002.
"""
from alembic import op

revision = "0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # pg_trgm нужен в 0004 под поиск по подстроке. Создаём заранее: CREATE EXTENSION
    # требует прав суперпользователя, и лучше упереться в это на первой миграции.
    op.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")

    # ---------- 1. Справочники ----------

    op.execute(
        """
        CREATE TABLE chains (
            id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            code        text NOT NULL UNIQUE,
            name        text NOT NULL,
            price_model text NOT NULL
                        CONSTRAINT chains_price_model_check
                        CHECK (price_model IN ('single','per_store','per_cluster'))
        )
        """
    )
    op.execute("COMMENT ON TABLE chains IS 'Торговые сети'")
    op.execute("COMMENT ON COLUMN chains.code IS 'bazarstore, bravo, araz'")
    op.execute(
        "COMMENT ON COLUMN chains.price_model IS "
        "'single = одна цена на всю сеть, per_store = цена привязана к точке, "
        "per_cluster = цена привязана к измеренной ценовой зоне (Bravo)'"
    )

    op.execute(
        """
        CREATE TABLE stores (
            id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            chain_id      integer NOT NULL REFERENCES chains(id),
            ext_id        text NOT NULL,
            name          text NOT NULL,
            format        text,
            price_cluster text,
            lat           double precision,
            lon           double precision,
            address       text,
            CONSTRAINT stores_chain_ext_key UNIQUE (chain_id, ext_id)
        )
        """
    )
    op.execute("COMMENT ON COLUMN stores.ext_id IS 'slug на Wolt или id в фиде сети'")
    op.execute(
        "COMMENT ON COLUMN stores.format IS "
        "'Hypermarket / Superstore / Supermarket / Ekspress'"
    )
    op.execute(
        "COMMENT ON COLUMN stores.price_cluster IS "
        "'Ценовая зона. Заполняется анализом (cluster2.py), НЕ берётся из названия: "
        "формат магазина и зона не совпадают'"
    )

    # ---------- 2. Канонический товар ----------
    # Одна строка = один физический товар. Сюда сходятся позиции всех сетей.

    op.execute(
        """
        CREATE TABLE products (
            id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            ean         text UNIQUE,
            name        text NOT NULL,
            brand       text,
            unit_value  double precision,
            unit_type   text,
            category    text,
            quarantined smallint NOT NULL DEFAULT 0
                        CONSTRAINT products_quarantined_check
                        CHECK (quarantined IN (0,1)),
            created_at  timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN products.ean IS "
        "'Глобальный GTIN-8/12/13/14. NULL для весовых товаров'"
    )
    op.execute("COMMENT ON COLUMN products.name IS 'Каноническое имя для показа'")
    op.execute("COMMENT ON COLUMN products.unit_type IS 'l / kg / ml / g / ədəd'")
    op.execute(
        "COMMENT ON COLUMN products.quarantined IS "
        "'1 = склейке не доверяем, на витрину не показываем, ждёт человека'"
    )
    op.execute("CREATE INDEX idx_products_brand ON products(brand)")

    # ---------- 3. Позиция в конкретной сети ----------
    # Сырьё как есть у сети. product_id ставится матчером, изначально NULL.

    op.execute(
        """
        CREATE TABLE store_items (
            id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            chain_id    integer NOT NULL REFERENCES chains(id),
            store_id    integer REFERENCES stores(id),
            chain_sku   text NOT NULL,
            ean         text,
            ean_kind    text CONSTRAINT store_items_ean_kind_check
                        CHECK (ean_kind IN ('global','internal','none')),
            raw_name    text NOT NULL,
            norm_name   text NOT NULL,
            brand       text,
            unit_value  double precision,
            unit_type   text,
            pack        integer,
            product_id  integer REFERENCES products(id),
            first_seen  timestamptz NOT NULL DEFAULT now(),
            last_seen   timestamptz NOT NULL DEFAULT now(),
            CONSTRAINT store_items_chain_store_sku_key UNIQUE (chain_id, store_id, chain_sku)
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN store_items.store_id IS 'NULL если цена общая на сеть'"
    )
    op.execute("COMMENT ON COLUMN store_items.chain_sku IS 'Внутренний код сети'")
    op.execute(
        "COMMENT ON COLUMN store_items.ean IS "
        "'Как отдала сеть, может быть внутренним кодом'"
    )
    op.execute(
        "COMMENT ON COLUMN store_items.norm_name IS "
        "'Транслит + нижний регистр + схлопнутые пробелы'"
    )
    op.execute(
        "COMMENT ON COLUMN store_items.unit_type IS "
        "'g / ml / pcs / kg_bulk (весовой, цена за кг)'"
    )
    op.execute(
        "COMMENT ON COLUMN store_items.pack IS 'Штук в упаковке: «6-LI», «10 LU»'"
    )

    # В SQLite NULL не равен NULL, поэтому UNIQUE(chain_id, store_id, chain_sku) не
    # работает для сетей с единой ценой, где store_id пустой. В Postgres ровно то же
    # поведение, поэтому явный индекс переносится как есть.
    #
    # Порядок колонок менять нельзя: pipeline.py делает
    #   ON CONFLICT (chain_id, COALESCE(store_id, 0), chain_sku) DO UPDATE
    # и Postgres выводит целевой индекс по точному совпадению выражений.
    #
    # У Postgres 15+ есть UNIQUE NULLS NOT DISTINCT — он решил бы ту же задачу
    # без функционального индекса, но сломал бы вывод индекса в ON CONFLICT выше.
    op.execute(
        """
        CREATE UNIQUE INDEX idx_si_sku
            ON store_items(chain_id, COALESCE(store_id, 0), chain_sku)
        """
    )
    op.execute("CREATE INDEX idx_si_ean ON store_items(ean)")
    op.execute("CREATE INDEX idx_si_product ON store_items(product_id)")
    op.execute(
        "CREATE INDEX idx_si_unmatched ON store_items(product_id) "
        "WHERE product_id IS NULL"
    )

    # ---------- 4. Цены. Только INSERT, никогда UPDATE ----------
    #
    # PK вынужденно составной: Postgres требует, чтобы ключ секционирования входил
    # в первичный ключ. Было (id), стало (id, observed_at). Практического смысла
    # у id как ключа всё равно нет — на price_observations никто не ссылается.

    op.execute(
        """
        CREATE TABLE price_observations (
            id             bigint GENERATED ALWAYS AS IDENTITY,
            store_item_id  integer NOT NULL REFERENCES store_items(id),
            price          integer NOT NULL,
            old_price      integer,
            promo_until    timestamptz,
            available      smallint NOT NULL DEFAULT 1
                           CONSTRAINT price_observations_available_check
                           CHECK (available IN (0,1)),
            observed_at    timestamptz NOT NULL DEFAULT now(),
            source         text NOT NULL,
            PRIMARY KEY (id, observed_at)
        ) PARTITION BY RANGE (observed_at)
        """
    )
    op.execute(
        "COMMENT ON TABLE price_observations IS "
        "'История цен. Append-only: только INSERT, никогда UPDATE'"
    )
    op.execute(
        "COMMENT ON COLUMN price_observations.price IS "
        "'В гяпиках, целое. Никаких float для денег'"
    )
    op.execute(
        "COMMENT ON COLUMN price_observations.old_price IS "
        "'Зачёркнутая цена. NOT NULL = идёт акция'"
    )
    op.execute(
        "COMMENT ON COLUMN price_observations.promo_until IS "
        "'Когда акция кончается, если сеть это отдаёт'"
    )
    op.execute(
        "COMMENT ON COLUMN price_observations.source IS "
        "'shopify_json / wolt_api / feed / receipt_ocr'"
    )
    # Секционированный индекс: Postgres заведёт его на каждой секции автоматически.
    op.execute(
        "CREATE INDEX idx_po_item_time "
        "ON price_observations(store_item_id, observed_at DESC)"
    )

    # ---------- 5. Матчинг: аудит, а не просто результат ----------

    op.execute(
        """
        CREATE TABLE matches (
            id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            store_item_id integer NOT NULL REFERENCES store_items(id),
            product_id    integer NOT NULL REFERENCES products(id),
            method        text NOT NULL
                          CONSTRAINT matches_method_check
                          CHECK (method IN ('ean','rule','embedding','llm','human')),
            confidence    double precision,
            decided_at    timestamptz NOT NULL DEFAULT now(),
            note          text,
            CONSTRAINT matches_store_item_key UNIQUE (store_item_id)
        )
        """
    )

    # Очередь на ручную проверку: всё, что модель не решила уверенно.
    op.execute(
        """
        CREATE TABLE match_queue (
            id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            store_item_id integer NOT NULL REFERENCES store_items(id),
            candidate_id  integer REFERENCES products(id),
            score         double precision,
            status        text NOT NULL DEFAULT 'pending'
                          CONSTRAINT match_queue_status_check
                          CHECK (status IN ('pending','approved','rejected')),
            created_at    timestamptz NOT NULL DEFAULT now()
        )
        """
    )

    # Почему склейка попала в карантин. Нужен, чтобы правила аудита можно было менять
    # и видеть, что изменилось, а не просто получать другое число на выходе.
    op.execute(
        """
        CREATE TABLE audit_log (
            id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            product_id  integer NOT NULL REFERENCES products(id),
            reason      text NOT NULL,
            quarantined smallint NOT NULL DEFAULT 1
                        CONSTRAINT audit_log_quarantined_check
                        CHECK (quarantined IN (0,1)),
            created_at  timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        "COMMENT ON TABLE audit_log IS "
        "'Почему склейка попала в карантин. Нужен, чтобы правила аудита можно было "
        "менять и видеть, что изменилось, а не просто получать другое число'"
    )


def downgrade() -> None:
    op.execute("DROP TABLE IF EXISTS audit_log")
    op.execute("DROP TABLE IF EXISTS match_queue")
    op.execute("DROP TABLE IF EXISTS matches")
    op.execute("DROP TABLE IF EXISTS price_observations")
    op.execute("DROP TABLE IF EXISTS store_items")
    op.execute("DROP TABLE IF EXISTS products")
    op.execute("DROP TABLE IF EXISTS stores")
    op.execute("DROP TABLE IF EXISTS chains")
    # pg_trgm не трогаем: им могут пользоваться другие схемы в той же БД.

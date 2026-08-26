-- qiymet.az — схема сравнения цен
-- SQLite. Переносится на Postgres заменой AUTOINCREMENT -> GENERATED и TEXT-времени на timestamptz.

PRAGMA journal_mode = WAL;

-- ---------- 1. Справочники ----------

CREATE TABLE IF NOT EXISTS chains (
    id          INTEGER PRIMARY KEY,
    code        TEXT UNIQUE NOT NULL,      -- bazarstore, bravo, araz
    name        TEXT NOT NULL,
    -- single = одна цена на всю сеть, per_store = цена привязана к точке
    price_model TEXT NOT NULL CHECK (price_model IN ('single','per_store','per_cluster'))
);

CREATE TABLE IF NOT EXISTS stores (
    id            INTEGER PRIMARY KEY,
    chain_id      INTEGER NOT NULL REFERENCES chains(id),
    ext_id        TEXT NOT NULL,           -- slug на Wolt или id в фиде сети
    name          TEXT NOT NULL,
    format        TEXT,                    -- Hypermarket / Superstore / Supermarket / Ekspress
    price_cluster TEXT,                    -- заполняется анализом, НЕ берётся из названия
    lat           REAL,
    lon           REAL,
    address       TEXT,
    UNIQUE (chain_id, ext_id)
);

-- ---------- 2. Канонический товар ----------
-- Одна строка = один физический товар. Сюда сходятся позиции всех сетей.

CREATE TABLE IF NOT EXISTS products (
    id          INTEGER PRIMARY KEY,
    ean         TEXT UNIQUE,               -- глобальный GTIN-8/12/13/14, NULL для весовых
    name        TEXT NOT NULL,             -- каноническое имя для показа
    brand       TEXT,
    unit_value  REAL,                      -- 1.0
    unit_type   TEXT,                      -- l / kg / ml / g / ədəd
    category    TEXT,
    -- Картинка для показа: берётся из первой позиции сети, у которой она есть.
    -- Денормализация ради одного запроса на витрине; пересчитывается каждый
    -- прогон в cmd_match(). NULL — легальное состояние: у ~2% товаров картинки
    -- нет ни в одной сети, и клиент рисует плашку из первой буквы названия.
    image_url   TEXT,
    -- 1 = склейке не доверяем, на витрину не показываем, ждёт человека
    quarantined INTEGER NOT NULL DEFAULT 0,
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_products_brand ON products(brand);

-- ---------- 3. Позиция в конкретной сети ----------
-- Сырьё как есть у сети. product_id ставится матчером, изначально NULL.

CREATE TABLE IF NOT EXISTS store_items (
    id          INTEGER PRIMARY KEY,
    chain_id    INTEGER NOT NULL REFERENCES chains(id),
    store_id    INTEGER REFERENCES stores(id),   -- NULL если цена общая на сеть
    chain_sku   TEXT NOT NULL,             -- внутренний код сети
    ean         TEXT,                      -- как отдала сеть, может быть внутренним
    ean_kind    TEXT CHECK (ean_kind IN ('global','internal','none')),
    raw_name    TEXT NOT NULL,
    norm_name   TEXT NOT NULL,             -- транслит + нижний регистр + схлопнутые пробелы
    brand       TEXT,
    unit_value  REAL,                      -- в базовых единицах: g / ml / pcs
    unit_type   TEXT,                      -- g / ml / pcs / kg_bulk (весовой, цена за кг)
    pack        INTEGER,                   -- штук в упаковке: «6-LI», «10 LU»
    image_url   TEXT,                      -- картинка как её отдала сеть
    category    TEXT,                      -- раздел каталога сети, как она его назвала
    product_id  INTEGER REFERENCES products(id),
    first_seen  TEXT NOT NULL DEFAULT (datetime('now')),
    last_seen   TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (chain_id, store_id, chain_sku)
);
-- В SQLite NULL не равен NULL, поэтому UNIQUE(chain_id, store_id, chain_sku) не
-- работает для сетей с единой ценой, где store_id пустой. Нужен явный индекс.
CREATE UNIQUE INDEX IF NOT EXISTS idx_si_sku
    ON store_items(chain_id, COALESCE(store_id, 0), chain_sku);
CREATE INDEX IF NOT EXISTS idx_si_ean       ON store_items(ean);
CREATE INDEX IF NOT EXISTS idx_si_product   ON store_items(product_id);
CREATE INDEX IF NOT EXISTS idx_si_unmatched ON store_items(product_id) WHERE product_id IS NULL;

-- ---------- 4. Цены. Только INSERT, никогда UPDATE ----------

CREATE TABLE IF NOT EXISTS price_observations (
    id             INTEGER PRIMARY KEY,
    store_item_id  INTEGER NOT NULL REFERENCES store_items(id),
    price          INTEGER NOT NULL,       -- в гяпиках, целое. никаких float для денег
    old_price      INTEGER,                -- зачёркнутая цена. NOT NULL = идёт акция
    promo_until    TEXT,                   -- когда акция кончается, если сеть это отдаёт
    available      INTEGER NOT NULL DEFAULT 1,
    observed_at    TEXT NOT NULL DEFAULT (datetime('now')),
    source         TEXT NOT NULL           -- shopify_json / wolt_api / feed / receipt_ocr
);
CREATE INDEX IF NOT EXISTS idx_po_item_time ON price_observations(store_item_id, observed_at DESC);

-- Текущая цена: последнее наблюдение по каждой позиции.
CREATE VIEW IF NOT EXISTS current_prices AS
SELECT p.store_item_id, p.price, p.old_price, p.promo_until,
       (p.old_price IS NOT NULL) AS is_promo,
       p.available, p.observed_at, p.source
FROM price_observations p
JOIN (SELECT store_item_id, MAX(observed_at) AS m
      FROM price_observations GROUP BY store_item_id) x
  ON x.store_item_id = p.store_item_id AND x.m = p.observed_at;

-- ---------- 5. Матчинг: аудит, а не просто результат ----------

CREATE TABLE IF NOT EXISTS matches (
    id            INTEGER PRIMARY KEY,
    store_item_id INTEGER NOT NULL REFERENCES store_items(id),
    product_id    INTEGER NOT NULL REFERENCES products(id),
    method        TEXT NOT NULL CHECK (method IN ('ean','rule','embedding','llm','human')),
    confidence    REAL,
    decided_at    TEXT NOT NULL DEFAULT (datetime('now')),
    note          TEXT,
    UNIQUE (store_item_id)
);

-- Очередь на ручную проверку: всё, что модель не решила уверенно.
CREATE TABLE IF NOT EXISTS match_queue (
    id            INTEGER PRIMARY KEY,
    store_item_id INTEGER NOT NULL REFERENCES store_items(id),
    candidate_id  INTEGER REFERENCES products(id),
    score         REAL,
    status        TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','approved','rejected')),
    created_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Почему склейка попала в карантин. Нужен, чтобы правила аудита можно было менять
-- и видеть, что изменилось, а не просто получать другое число на выходе.
CREATE TABLE IF NOT EXISTS audit_log (
    id         INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    reason     TEXT NOT NULL,
    quarantined INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ---------- 6. Витрина: сравнение цены товара по сетям ----------

CREATE VIEW IF NOT EXISTS product_prices AS
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
JOIN store_items si   ON si.product_id = pr.id
JOIN chains c         ON c.id = si.chain_id
LEFT JOIN stores s    ON s.id = si.store_id
JOIN current_prices cp ON cp.store_item_id = si.id;

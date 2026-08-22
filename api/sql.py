"""Куски SQL, общие для нескольких эндпоинтов.

Здесь живёт одно правило, от которого зависит корректность половины API:
какие строки цен применимы при выбранном магазине.

  * У сетей с единой ценой (price_model = 'single') позиции лежат по филиалам —
    Araz отдаёт две точки Wolt, — но цена у них одна. Такие строки схлопываются
    в одну на сеть, иначе Araz был бы представлен дважды.
  * У Bravo (per_cluster) цена привязана к измеренной ценовой зоне, и схлопывать
    нельзя: четыре зоны — четыре разные цены.
  * Если магазин выбран, у ЕГО сети остаются только строки этого магазина.
    У остальных сетей — как обычно.
  * Если магазин не выбран, строки Bravo помечаются requires_store_selection и
    не участвуют в подсчёте лучшей цены. Правило из CLAUDE.md: показывать цену
    Bravo без выбора магазина нельзя.
"""

# Разворачивает текущие цены по позициям заданных товаров.
# Параметры: :ids (list[int]), :sel_chain_id, :sel_store_id
APPLICABLE_PRICES = """
SELECT DISTINCT ON (si.product_id, c.id, grp.cluster_key)
       si.product_id,
       c.id            AS chain_id,
       c.code          AS chain_code,
       c.name          AS chain_name,
       c.price_model,
       si.store_id,
       st.name         AS store_name,
       st.price_cluster,
       cp.price,
       cp.old_price,
       cp.is_promo,
       cp.available,
       cp.observed_at,
       cp.source,
       (c.price_model = 'per_cluster' AND CAST(:sel_store_id AS int) IS NULL)
                       AS requires_store_selection
FROM store_items si
JOIN chains c          ON c.id = si.chain_id
LEFT JOIN stores st    ON st.id = si.store_id
JOIN current_prices cp ON cp.store_item_id = si.id
CROSS JOIN LATERAL (
    -- Ключ схлопывания: у per_cluster — зона, у остальных — ничего,
    -- то есть одна строка на сеть.
    SELECT CASE WHEN c.price_model = 'per_cluster'
                THEN coalesce(st.price_cluster, '?')
                ELSE '' END AS cluster_key
) grp
-- Приведения типов обязательны: параметр, встречающийся только в IS NULL,
-- Postgres типизировать не может и отвечает AmbiguousParameter.
WHERE si.product_id = ANY(CAST(:ids AS int[]))
  AND (
        CAST(:sel_chain_id AS int) IS NULL
     OR si.chain_id <> CAST(:sel_chain_id AS int)
     OR si.store_id  = CAST(:sel_store_id AS int)
      )
ORDER BY si.product_id, c.id, grp.cluster_key,
         -- при равных ключах берём свежайшее наблюдение, потом меньший store_id:
         -- порядок обязан быть детерминированным, иначе ответ будет плясать
         cp.observed_at DESC, si.store_id NULLS FIRST
"""

# Сколько всего сетей знает товар — считается по всем позициям, без учёта
# выбранного магазина: «есть в 5 сетях» не должно меняться от выбора точки.
CHAINS_COUNT = """
SELECT si.product_id,
       count(DISTINCT si.chain_id)                        AS chains_count,
       bool_or(cp.old_price IS NOT NULL)                  AS has_promo
FROM store_items si
JOIN current_prices cp ON cp.store_item_id = si.id
WHERE si.product_id = ANY(CAST(:ids AS int[]))
GROUP BY si.product_id
"""

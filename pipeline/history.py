#!/usr/bin/env python3
"""История цен: что изменилось между прогонами.

`price_observations` пишется только при изменении, поэтому две соседние записи по
одной позиции — это и есть событие «цена поехала». Отсюда берётся всё интересное:
что подорожало, что подешевело, когда началась акция и, главное, поднимали ли
цену перед тем, как объявить скидку.

  python3 history.py            что изменилось за последние сутки
  python3 history.py 168        то же за неделю
"""
import os, sqlite3, sys, statistics as st, csv

SQL_CHANGES = """
WITH seq AS (
  SELECT po.id, po.store_item_id, po.price, po.old_price, po.observed_at,
         LAG(po.price)       OVER w AS prev_price,
         LAG(po.old_price)   OVER w AS prev_old,
         LAG(po.observed_at) OVER w AS prev_at
  FROM price_observations po
  WINDOW w AS (PARTITION BY po.store_item_id ORDER BY po.observed_at)
)
SELECT s.*, c.code AS chain, st.price_cluster AS cluster,
       si.raw_name, si.ean, si.ean_kind
FROM seq s
JOIN store_items si ON si.id = s.store_item_id
JOIN chains c       ON c.id = si.chain_id
LEFT JOIN stores st ON st.id = si.store_id
WHERE s.prev_price IS NOT NULL
  AND s.observed_at >= datetime('now', ?)
ORDER BY s.observed_at DESC
"""


def changes(hours=24, db=None):
    db = db or os.environ.get('QIYMET_SQLITE', 'qiymet.db')
    con = sqlite3.connect(db)
    con.row_factory = sqlite3.Row
    return con.execute(SQL_CHANGES, (f'-{int(hours)} hours',)).fetchall()


def classify(r):
    """Что именно произошло с ценником."""
    was_promo, now_promo = bool(r['prev_old']), bool(r['old_price'])
    if not was_promo and now_promo:
        return 'акция началась'
    if was_promo and not now_promo:
        return 'акция кончилась'
    if r['price'] == r['prev_price']:
        return 'наличие изменилось'      # цена та же, поехало available
    return 'подешевело' if r['price'] < r['prev_price'] else 'подорожало'


def main():
    hours = int(sys.argv[1]) if len(sys.argv) > 1 else 24
    rows = changes(hours)
    if not rows:
        print(f'за последние {hours} ч изменений нет. Это нормально, если прогон был один:\n'
              f'история появляется со второго запуска.')
        return

    import collections
    kinds = collections.Counter(classify(r) for r in rows)
    print(f'изменений за {hours} ч: {len(rows)}')
    for k, v in kinds.most_common():
        print(f'  {v:6}  {k}')

    deltas = [(r['price'] - r['prev_price']) / r['prev_price'] * 100 for r in rows]
    up = [d for d in deltas if d > 0]
    dn = [d for d in deltas if d < 0]
    if up:
        print(f'\nподорожания: {len(up)}, медиана +{round(st.median(up),1)}%')
    if dn:
        print(f'подешевления: {len(dn)}, медиана {round(st.median(dn),1)}%')

    print('\n--- самые заметные ---')
    for r in sorted(rows, key=lambda r: -abs(r['price'] - r['prev_price']) / r['prev_price'])[:12]:
        d = (r['price'] - r['prev_price']) / r['prev_price'] * 100
        print(f"  {r['chain']:11}{(r['cluster'] or ''):3} {r['prev_price']/100:>7.2f} → "
              f"{r['price']/100:>7.2f}  {d:+6.1f}%  {classify(r):16} {r['raw_name'][:38]}")

    # Накрутка перед скидкой: цена выросла, а следом объявили акцию.
    susp = []
    for r in rows:
        if classify(r) == 'акция началась' and r['old_price'] and r['old_price'] > r['prev_price']:
            susp.append(r)
    print(f'\nакций, где заявленная старая цена выше той, что мы видели своими глазами: {len(susp)}')
    for r in susp[:8]:
        print(f"  {r['chain']:11} видели {r['prev_price']/100:.2f}, заявили «было» "
              f"{r['old_price']/100:.2f}, продают за {r['price']/100:.2f}  {r['raw_name'][:36]}")

    with open('price_changes.csv', 'w', newline='', encoding='utf-8-sig') as f:
        w = csv.writer(f)
        w.writerow(['when', 'chain', 'cluster', 'ean', 'product', 'was', 'now', 'delta_%',
                    'was_old_price', 'now_old_price', 'event'])
        for r in rows:
            w.writerow([r['observed_at'], r['chain'], r['cluster'] or '', r['ean'] or '',
                        r['raw_name'], r['prev_price'] / 100, r['price'] / 100,
                        round((r['price'] - r['prev_price']) / r['prev_price'] * 100, 1),
                        (r['prev_old'] or 0) / 100, (r['old_price'] or 0) / 100, classify(r)])
    print(f'\nprice_changes.csv записан: {len(rows)} строк')


if __name__ == '__main__':
    main()

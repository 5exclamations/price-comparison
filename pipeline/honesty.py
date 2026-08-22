#!/usr/bin/env python3
"""Проверка честности скидок.

Идея простая. Сеть заявляет «было 34.49, стало 13.99». Проверить это по истории
нельзя, пока истории нет. Зато можно проверить по рынку: если тот же товар
(тот же EAN) в других сетях спокойно лежит по 14.20 без всякой акции, то
«старая цена» 34.49 существует только на ценнике.

Считаем две величины:
  скидка заявленная  = (old - price) / old
  скидка настоящая   = (базовая цена рынка - price) / базовая цена рынка,
                        где базовая цена рынка — медиана НЕакционных цен на этот EAN
                        в других сетях.
Разница между ними и есть накрутка.
"""
import os, sqlite3, statistics as st, sys, csv

MIN_REF = 1          # сколько неакционных цен в других сетях нужно для вывода
INFLATED = 0.15      # заявленная скидка глубже настоящей на столько — считаем накрученной


def load(db=None):
    db = db or os.environ.get('QIYMET_SQLITE', 'qiymet.db')
    con = sqlite3.connect(db)
    con.row_factory = sqlite3.Row
    rows = con.execute("""
        SELECT p.id AS pid, p.ean, p.name, c.code AS chain, s.price_cluster AS cl,
               cp.price, cp.old_price
        FROM products p
        JOIN store_items si    ON si.product_id = p.id
        JOIN chains c          ON c.id = si.chain_id
        LEFT JOIN stores s     ON s.id = si.store_id
        JOIN current_prices cp ON cp.store_item_id = si.id
        WHERE p.ean IS NOT NULL AND p.quarantined = 0
    """).fetchall()
    by = {}
    for r in rows:
        by.setdefault(r['pid'], []).append(r)
    return by


def analyse(by):
    out = []
    for pid, rs in by.items():
        promos = [r for r in rs if r['old_price'] and r['old_price'] > r['price']]
        if not promos:
            continue
        for pr in promos:
            # базовая цена рынка: неакционные цены в ДРУГИХ сетях
            ref = [r['price'] for r in rs
                   if r['chain'] != pr['chain'] and not r['old_price']]
            if len(ref) < MIN_REF:
                continue
            market = st.median(ref)
            # Если «рынок» сам по себе дикий (втрое дешевле или втрое дороже заявленной
            # старой цены), то врёт скорее эталон, а не акция. Пример: Bazarstore держит
            # консервы Seleste 140 г по 1.00 при 3.69 у Bravo. Такие пары не судим.
            if not (0.33 <= market / pr['old_price'] <= 3.0):
                continue
            claimed = (pr['old_price'] - pr['price']) / pr['old_price']
            realdisc = (market - pr['price']) / market
            out.append({
                'ean': pr['ean'], 'name': pr['name'], 'chain': pr['chain'],
                'cluster': pr['cl'], 'price': pr['price'], 'old': pr['old_price'],
                'market': round(market), 'claimed': claimed, 'real': realdisc,
                'inflation': claimed - realdisc,
            })
    return out


def main():
    res = analyse(load())
    if not res:
        print('нет данных'); return
    infl = [r for r in res if r['inflation'] > INFLATED]
    fake = [r for r in res if r['real'] <= 0]
    print(f'акций, которые удалось проверить по рынку: {len(res)}')
    print(f'  заявленная скидка глубже настоящей больше чем на {int(INFLATED*100)} п.п.: '
          f'{len(infl)} ({round(100*len(infl)/len(res),1)}%)')
    print(f'  «скидка», при которой цена НЕ ниже рынка: {len(fake)} ({round(100*len(fake)/len(res),1)}%)')
    print(f'  медиана заявленной скидки: {round(100*st.median([r["claimed"] for r in res]))}%')
    print(f'  медиана настоящей скидки:  {round(100*st.median([r["real"] for r in res]))}%')

    print('\n--- сильнее всего накручено ---')
    for r in sorted(res, key=lambda x: -x['inflation'])[:10]:
        pct = lambda x: f"{-round(100*x):+d}%"
        print(f"  {r['chain']:11} {r['price']/100:>6.2f} (было {r['old']/100:>6.2f}, "
              f"рынок {r['market']/100:>6.2f})  заявлено {pct(r['claimed']):>5} "
              f"реально {pct(r['real']):>6}  {r['name'][:38]}")

    print('\n--- настоящие выгоды ---')
    for r in sorted(res, key=lambda x: -x['real'])[:10]:
        print(f"  {r['chain']:11} {r['price']/100:>6.2f} против рынка {r['market']/100:>6.2f}  "
              f"{-round(100*r['real']):+d}%  {r['name'][:44]}")

    with open('promo_honesty.csv', 'w', newline='', encoding='utf-8-sig') as f:
        w = csv.DictWriter(f, fieldnames=list(res[0].keys()))
        w.writeheader()
        for r in sorted(res, key=lambda x: -x['inflation']):
            r = dict(r)
            r['claimed'] = round(100 * r['claimed'], 1)
            r['real'] = round(100 * r['real'], 1)
            r['inflation'] = round(100 * r['inflation'], 1)
            r['price'] = r['price'] / 100
            r['old'] = r['old'] / 100
            r['market'] = r['market'] / 100
            w.writerow(r)
    print(f'\npromo_honesty.csv записан: {len(res)} строк')


if __name__ == '__main__':
    main()

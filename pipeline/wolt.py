"""Коннектор к витрине доставки Wolt. Забирает цену, акцию и GTIN."""
import json, urllib.request, urllib.parse, time
from concurrent.futures import ThreadPoolExecutor

HDR = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
                     'AppleWebKit/537.36 Chrome/128.0 Safari/537.36',
       'Accept': 'application/json', 'platform': 'Web',
       'clientversionnumber': '1.15.13',
       'Origin': 'https://wolt.com', 'Referer': 'https://wolt.com/'}

BASE = 'https://consumer-api.wolt.com/consumer-api/consumer-assortment/v1/venues/slug/{v}/assortment'


def get(url, tries=3):
    for a in range(tries):
        try:
            return json.load(urllib.request.urlopen(
                urllib.request.Request(url, headers=HDR), timeout=30))
        except Exception:
            if a == tries - 1:
                return None
            time.sleep(1.5 * (a + 1))


def leaves(cats):
    out = []
    for c in cats:
        sub = c.get('subcategories') or []
        out.extend(leaves(sub) if sub else [c])
    return out


def _item(x, cat):
    """Достаём цену и акцию.

    price          — цена, которую платит покупатель сейчас
    original_price — зачёркнутая цена, приходит только когда идёт акция
    """
    orig = x.get('original_price')
    price = x.get('price')
    promo = bool(orig and price is not None and orig > price)
    per = x.get('item_price_discount_validity_period') or {}
    return {'id': x.get('id'), 'name': x.get('name'), 'price': price,
            'old': orig if promo else None,
            'promo': promo,
            'promo_until': per.get('end_time') if promo else None,
            'gtin': x.get('barcode_gtin'), 'cat': cat,
            'available': not x.get('disabled_info'),
            'unit_price': (x.get('unit_price') or {}).get('price') if x.get('unit_price') else None}


def venue(slug, cat_filter=None, max_cats=None, threads=6):
    """Скачивает ассортимент точки. cat_filter — список подстрок в названии категории."""
    a = get(BASE.format(v=slug))
    if not a:
        return None
    lv = leaves(a.get('categories', []))
    if cat_filter:
        lv = [c for c in lv if any(t in c['name'].lower() for t in cat_filter)]
    if max_cats:
        lv = lv[:max_cats]

    def one(c):
        r = get(BASE.format(v=slug) + '/categories/slug/' + urllib.parse.quote(c['slug'], safe=''))
        return [_item(x, c['name']) for x in (r.get('items', []) if r else [])]

    items = []
    with ThreadPoolExecutor(threads) as ex:
        for r in ex.map(one, lv):
            items.extend(r)
    return {'assortment_id': a.get('assortment_id'), 'n_cats': len(lv), 'items': items}


def cluster_matrix(data, key_fn, skip_cats=()):
    """Матрица совпадения цен между точками. Возвращает (matrix, shared_count)."""
    import collections, re
    idx = collections.defaultdict(dict)
    for v, d in data.items():
        for it in d['items']:
            if it['price'] is None:
                continue
            if any(s in (it['cat'] or '').lower() for s in skip_cats):
                continue
            idx[key_fn(it)][v] = it['price']
    shared = {k: v for k, v in idx.items() if len(v) >= max(3, len(data) // 2)}
    vs = list(data)
    m = {}
    for a in vs:
        m[a] = {}
        for b in vs:
            com = [k for k in shared if a in shared[k] and b in shared[k]]
            eq = sum(1 for k in com if shared[k][a] == shared[k][b])
            m[a][b] = round(100 * eq / len(com)) if com else None
    return m, len(shared)

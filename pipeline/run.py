#!/usr/bin/env python3
"""Один вход для всего пайплайна.

  python3 run.py init      создать пустую БД (один раз)
  python3 run.py fast      цены и акции всех сетей. Вешать на cron каждые 2-4 часа
  python3 run.py full      то же плюс новые товары и штрихкоды. Раз в сутки ночью
  python3 run.py build     пересобрать demo.html из того, что уже в БД

Штрихкоды Bazarstore тянутся отдельным медленным проходом (21 тыс. запросов,
около часа), поэтому они только в full и кэшируются в raw/bazarstore_ean.json.
"""
import json, os, subprocess, sys, time, urllib.request, urllib.parse
from concurrent.futures import ThreadPoolExecutor

import pipeline as P
import wolt

RAW = 'raw'
os.makedirs(RAW, exist_ok=True)

# По одному магазину на измеренную ценовую зону. Состав зон проверять раз в неделю
# скриптом cluster2.py: если сети перекроят прайсы, зоны разъедутся молча.
VENUES = {
    'bravo': {'bravo-hypermarket-koroglu':   ('Hypermarket', 'A1'),
              'bravo-supermarket-sherifzade': ('Supermarket', 'A2'),
              'bravo-superstore-28-mall':    ('Superstore',  'B'),
              'bravo-ekspress-hovsan':       ('Ekspress',    'C')},
    # у Araz цена по филиалам совпадает на 89-100%, зон нет
    'araz':  {'araz-supermarket-narimanov':  ('Supermarket', 'ALL'),
              'araz-yasamal-3-superstore-f': ('Superstore',  'ALL')},
    # у Neptun три точки совпали на 100%, хватает одной
    'neptun':    {'neptun-supermarket-28':  ('Supermarket', 'ALL')},
    'spar':      {'spar-axundov':           ('Supermarket', 'ALL')},
    'rahat':     {'rahat-gourmet':          ('Gourmet',     'ALL')},
    # grandmart отсюда убран: слаг ведёт в русскоязычный магазин другой страны,
    # медианная цена там 1014 против 1.4-4.4 в бакинских. Проверка ниже ловит это сама.
}

BZ_COLLECTIONS = ['endirimli-mehsullar']     # витрина акций Bazarstore


def _get(url, tries=3):
    for a in range(tries):
        try:
            return json.load(urllib.request.urlopen(
                urllib.request.Request(url, headers=P.UA), timeout=30))
        except Exception:
            if a == tries - 1:
                raise
            time.sleep(1.5 * (a + 1))


def _paged(url_tpl, cap=200):
    out, page = [], 1
    while page <= cap:
        d = _get(url_tpl.format(page=page))
        pr = d.get('products', [])
        if not pr:
            break
        out.extend(pr); page += 1
        time.sleep(0.2)
    return out


def pull_bazarstore():
    prods = _paged('https://bazarstore.az/products.json?limit=250&page={page}')
    json.dump(prods, open(f'{RAW}/bazarstore.json', 'w'), ensure_ascii=False)
    print(f'  Bazarstore каталог: {len(prods)}')
    for c in BZ_COLLECTIONS:
        pr = _paged(f'https://bazarstore.az/collections/{c}/products.json?limit=250&page={{page}}', cap=20)
        json.dump(pr, open(f'{RAW}/bazarstore_promo.json', 'w'), ensure_ascii=False)
        print(f'  Bazarstore акции ({c}): {len(pr)}')
    return prods


def pull_barcodes(prods, threads=10):
    """Медленно и только в full. Кэш переживает перезапуски."""
    cache = {}
    path = f'{RAW}/bazarstore_ean.json'
    if os.path.exists(path):
        cache = json.load(open(path))
    todo = [p for p in prods
            if not all(str(v['sku'] or v['id']) in cache for v in p['variants'])]
    print(f'  штрихкоды: в кэше {len(cache)}, надо добрать {len(todo)}')
    if not todo:
        return cache

    def one(p):
        h = urllib.parse.quote(p['handle'], safe='')
        for a in range(2):
            try:
                d = _get(f'https://bazarstore.az/products/{h}.js', tries=1)
                return {str(v['sku'] or v['id']): (v.get('barcode') or '').strip()
                        for v in d['variants']}
            except Exception:
                time.sleep(0.8 * (a + 1))
        return {}

    with ThreadPoolExecutor(threads) as ex:
        for i, m in enumerate(ex.map(one, todo)):
            cache.update({k: v for k, v in m.items() if v})
            if i % 1000 == 0:
                print(f'    {i}/{len(todo)}', flush=True)
    json.dump(cache, open(path, 'w'))
    print(f'  штрихкодов в кэше: {len(cache)}')
    return cache


def pull_wolt():
    """Снимает все точки из VENUES. Возвращает (данные, список пропущенных).

    VENUES — это КОНФИГУРАЦИЯ, а не пожелание. Раньше недоступная точка давала
    строчку «ПРОПУЩЕН <slug>» и прогон шёл дальше с нулевым кодом возврата.
    Для сети целиком это ловилось проверкой свежести с опозданием в двенадцать
    часов, а для одной точки не ловилось вовсе: у Bravo четыре ценовые зоны, и
    три оставшиеся тянули возраст сети наверх.

    Теперь пропуски едут наверх и роняют прогон. Пустой ассортимент — тоже
    пропуск: точка, отдавшая ноль товаров, ничем не лучше недоступной, а
    выглядит успешной.
    """
    out, missing = {}, []
    for chain, venues in VENUES.items():
        out[chain] = {}
        for slug, (fmt, cl) in venues.items():
            try:
                d = wolt.venue(slug, threads=8)
            except Exception as exc:                       # noqa: BLE001
                # Исключение здесь — это сеть или разметка витрины, а не наша
                # логика. Гасим его ради остальных точек, но не ради тишины:
                # slug уходит в missing и уронит прогон в конце.
                print(f'  ПРОПУЩЕН {slug}: {type(exc).__name__} {exc}')
                missing.append((slug, f'{type(exc).__name__}: {exc}'))
                continue

            if not d:
                print(f'  ПРОПУЩЕН {slug}: точка недоступна')
                missing.append((slug, 'точка недоступна'))
                continue
            if not d['items']:
                print(f'  ПРОПУЩЕН {slug}: ассортимент пуст')
                missing.append((slug, 'ассортимент пуст'))
                continue

            out[chain][slug] = {'format': fmt, 'cluster': cl,
                                'assortment_id': d['assortment_id'], 'items': d['items']}
            promo = sum(1 for i in d['items'] if i['promo'])
            print(f'  {chain:11}{slug:34} товаров {len(d["items"]):5} акций {promo:4}')
    json.dump(out, open(f'{RAW}/wolt_all.json', 'w'), ensure_ascii=False)
    return out, missing


def load_bazarstore(ean):
    con = P.db()
    cid = con.execute("SELECT id FROM chains WHERE code='bazarstore'").fetchone()['id']
    n = 0
    for src, path in (('shopify_json', f'{RAW}/bazarstore.json'),
                      ('shopify_collection', f'{RAW}/bazarstore_promo.json')):
        if not os.path.exists(path):
            continue
        for p in json.load(open(path)):
            for v in p['variants']:
                sku = str(v['sku'] or v['id'])
                old = v.get('compare_at_price')
                old = int(round(float(old) * 100)) if old and float(old) > 0 else None
                price = int(round(float(v['price']) * 100))
                if old and old <= price:
                    old = None
                # У весовых товаров Bazarstore фасовка сидит в варианте: «1 KG» и
                # «250 gr» с пропорциональной ценой. Без этого 0.25 за 250 г
                # выглядит как килограмм картошки по четверти маната.
                vt = (v.get('title') or '').strip()
                name = p['title']
                if vt and vt.lower() not in ('default title', 'ədəd', 'eded'):
                    name = f"{name} {vt}"
                iid = P.upsert_item(con, cid, None, sku, ean.get(sku, ''),
                                    name, p.get('vendor'), P._shopify_image(p, v))
                if P.add_price(con, iid, price, old, v.get('available', True), src):
                    n += 1
    con.commit()
    print(f'  Bazarstore: новых наблюдений {n}')


def step(name, fn, *a):
    t = time.time()
    print(f'[{name}]')
    r = fn(*a)
    print(f'  {round(time.time() - t)} c\n')
    return r


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'fast'

    if cmd == 'init':
        P.cmd_init(); return 0

    if not os.path.exists(P.DB):
        P.cmd_init()

    if cmd == 'build':
        subprocess.run([sys.executable, 'demo.py'], check=True); return 0

    prods = step('Bazarstore', pull_bazarstore)
    ean = (step('штрихкоды', pull_barcodes, prods) if cmd == 'full'
           else (json.load(open(f'{RAW}/bazarstore_ean.json'))
                 if os.path.exists(f'{RAW}/bazarstore_ean.json') else {}))
    step('загрузка Bazarstore', load_bazarstore, ean)

    _, missing = step('Wolt: все сети', pull_wolt)
    rejected = step('загрузка Wolt', P.cmd_wolt) or []

    step('матчинг', P.cmd_match)
    step('похожесть названий', P.cmd_similar)
    step('аудит склеек', P.cmd_audit)
    step('витрина', lambda: subprocess.run([sys.executable, 'demo.py'], check=True))
    P.cmd_report()

    # --- итог по точкам ------------------------------------------------------
    # Всё, что снято, уже лежит в базе: обрывать прогон на середине смысла нет,
    # пять сетей из шести лучше нуля. Но заканчиваться нулём такой прогон не
    # имеет права — иначе цепочка в run-crawl.sh пойдёт дальше, пересоберёт
    # витрины, прогонит проверки и отрапортует об успехе.
    lost = [(s, w, 'не снят') for s, w in missing] + \
           [(s, w, 'отклонён') for s, w in rejected]

    expected = sum(len(v) for v in VENUES.values())
    print(f'\nТочек ожидалось {expected}, снято {expected - len(lost)}')

    if lost:
        print(f'\nВЫПАЛО ТОЧЕК: {len(lost)} из {expected}')
        for slug, why, kind in lost:
            print(f'  {kind:9} {slug:34} {why}')
        print('\nVENUES — это конфигурация, а не пожелание. Пока точка в списке,')
        print('её отсутствие считается аварией, даже если остальные сняты.')
        return 1

    return 0


if __name__ == '__main__':
    sys.exit(main() or 0)

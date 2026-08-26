#!/usr/bin/env python3
"""
qiymet.az — пайплайн загрузки цен.

Запуск:  python3 pipeline.py init      создать БД
         python3 pipeline.py bazarstore  загрузить каталог Bazarstore
         python3 pipeline.py bravo       загрузить цены Bravo из сохранённого дампа Wolt
         python3 pipeline.py match       сматчить позиции между сетями
         python3 pipeline.py report      что получилось
"""
import sqlite3, json, re, sys, time, urllib.request, urllib.parse, os
from concurrent.futures import ThreadPoolExecutor
import units, fingerprint, similar

DB = 'qiymet.db'
UA = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
                    'AppleWebKit/537.36 Chrome/128.0 Safari/537.36'}

# ---------- нормализация ----------

TRANS = str.maketrans({'ə':'a','ı':'i','ö':'o','ü':'u','ç':'c','ş':'s','ğ':'g',
                       'Ə':'a','I':'i','İ':'i','Ö':'o','Ü':'u','Ç':'c','Ş':'s','Ğ':'g',
                       'а':'a','е':'e','о':'o','с':'c','р':'p','х':'x','у':'y','к':'k'})

def norm_name(s: str) -> str:
    s = (s or '').translate(TRANS).lower()
    s = re.sub(r'[^\w\s.,%]', ' ', s)
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def parse_unit(s: str):
    """См. units.py. Возвращает (value, unit, pack)."""
    return units.parse(s)


def ean_kind(b: str) -> str:
    b = (b or '').strip()
    if not b.isdigit() or len(b) < 8:
        return 'none'
    if len(b) > 14 or b[:2] in {'20','21','22','23','24','25','26','27','28','29'}:
        return 'internal'
    if len(b) == 13 and not _check13(b):
        return 'internal'
    return 'global'


def _check13(c: str) -> bool:
    s = sum(int(d) * (3 if i % 2 else 1) for i, d in enumerate(c[:12]))
    return (10 - s % 10) % 10 == int(c[12])


# ---------- БД ----------

def db():
    c = sqlite3.connect(DB)
    c.row_factory = sqlite3.Row
    c.execute('PRAGMA foreign_keys = ON')
    return c


def ensure_columns(con):
    """Дотягивает колонки, появившиеся после создания базы.

    schema.sql весь на CREATE TABLE IF NOT EXISTS, поэтому существующей базе
    новые колонки он не добавит — и прогон упадёт на INSERT с image_url.
    Отдельных миграций у SQLite-части нет и заводить их ради двух колонок
    незачем: список ниже идемпотентен и стоит один SELECT.
    """
    for table, column, decl in (
        ('store_items', 'image_url', 'TEXT'),
        ('products', 'image_url', 'TEXT'),
    ):
        have = {r['name'] for r in con.execute(f'PRAGMA table_info({table})')}
        if column not in have:
            con.execute(f'ALTER TABLE {table} ADD COLUMN {column} {decl}')
            print(f'  добавлена колонка {table}.{column}')
    con.commit()


def cmd_init():
    con = db()
    con.executescript(open('schema.sql').read())
    ensure_columns(con)
    con.executemany(
        'INSERT OR IGNORE INTO chains (code, name, price_model) VALUES (?,?,?)',
        [('bazarstore', 'Bazarstore', 'single'),
         ('bravo',      'Bravo',      'per_cluster'),
         ('araz',       'Araz',       'single'),
         ('neptun',     'Neptun',     'single'),
         ('spar',       'SPAR',       'single'),
         ('rahat',      'Rahat',      'single')])
    con.commit()
    print('БД создана:', DB)


def upsert_item(con, chain_id, store_id, sku, ean, raw, brand=None, image=None):
    kind = ean_kind(ean)
    uv, ut, pack = parse_unit(raw)
    con.execute("""
        INSERT INTO store_items (chain_id, store_id, chain_sku, ean, ean_kind,
                                 raw_name, norm_name, brand, unit_value, unit_type,
                                 pack, image_url)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
        ON CONFLICT (chain_id, COALESCE(store_id, 0), chain_sku) DO UPDATE SET
            last_seen = datetime('now'),
            ean       = COALESCE(excluded.ean, store_items.ean),
            raw_name  = excluded.raw_name,
            norm_name = excluded.norm_name,
            -- COALESCE, а не присваивание: если сеть в этот прогон картинку не
            -- отдала (перебои на их CDN, пустой ответ), лучше показать вчерашнюю,
            -- чем обнулить и уронить карточку на плашку.
            image_url = COALESCE(excluded.image_url, store_items.image_url)
    """, (chain_id, store_id, sku, ean or None, kind, raw, norm_name(raw),
          brand, uv, ut, pack, image or None))
    r = con.execute("""SELECT id FROM store_items
                       WHERE chain_id=? AND chain_sku=?
                         AND (store_id IS ? OR store_id=?)""",
                    (chain_id, sku, store_id, store_id)).fetchone()
    return r['id']


def add_price(con, item_id, price_minor, old_minor, available, source, promo_until=None):
    """Пишем только если что-то изменилось. Иначе история распухнет впустую."""
    last = con.execute("""SELECT price, old_price, available FROM price_observations
                          WHERE store_item_id=? ORDER BY observed_at DESC LIMIT 1""",
                       (item_id,)).fetchone()
    if (last and last['price'] == price_minor and last['old_price'] == old_minor
            and last['available'] == int(available)):
        return False
    con.execute("""INSERT INTO price_observations
                   (store_item_id, price, old_price, promo_until, available, source)
                   VALUES (?,?,?,?,?,?)""",
                (item_id, price_minor, old_minor, promo_until, int(available), source))
    return True


# ---------- коннектор 1: Bazarstore (Shopify) ----------

def fetch_bazarstore(with_barcodes=True, limit=None):
    out, page = [], 1
    while True:
        u = f'https://bazarstore.az/products.json?limit=250&page={page}'
        try:
            d = json.load(urllib.request.urlopen(urllib.request.Request(u, headers=UA), timeout=30))
        except Exception as e:
            print('  стоп на странице', page, e); break
        pr = d.get('products', [])
        if not pr:
            break
        out.extend(pr); page += 1
        if limit and len(out) >= limit:
            out = out[:limit]; break
        time.sleep(0.2)
    print(f'  каталог: {len(out)} товаров')

    if not with_barcodes:
        return out

    # barcode отдаётся только эндпоинтом /products/<handle>.js
    def bc(p):
        h = urllib.parse.quote(p['handle'], safe='')
        for a in range(3):
            try:
                d = json.load(urllib.request.urlopen(
                    urllib.request.Request(f'https://bazarstore.az/products/{h}.js',
                                           headers=UA), timeout=25))
                p['_bc'] = {v['id']: (v.get('barcode') or '').strip() for v in d['variants']}
                return
            except Exception:
                time.sleep(1.5 * (a + 1))
        p['_bc'] = {}

    with ThreadPoolExecutor(5) as ex:
        list(ex.map(bc, out))
    got = sum(1 for p in out if p.get('_bc'))
    print(f'  штрихкоды получены для {got} товаров')
    return out


def _shopify_image(p, v):
    """Картинка варианта, иначе картинка товара, иначе None.

    У весовых товаров Bazarstore варианты («1 kg», «250 gr») — это один и тот же
    продукт в разной фасовке, и своей картинки у них обычно нет. Поэтому сначала
    featured_image варианта, потом общая: иначе 250-граммовая пачка осталась бы
    вовсе без картинки, хотя у килограммовой она есть.
    """
    fi = (v.get('featured_image') or {}).get('src') if v.get('featured_image') else None
    if fi:
        return fi
    for img in (p.get('images') or []):
        src = (img or {}).get('src')
        if src:
            return src
    return None


def cmd_bazarstore(limit=None):
    con = db()
    cid = con.execute("SELECT id FROM chains WHERE code='bazarstore'").fetchone()['id']
    prods = fetch_bazarstore(limit=limit)
    n_new = 0
    for p in prods:
        for v in p['variants']:
            ean = (p.get('_bc') or {}).get(v['id'], '')
            iid = upsert_item(con, cid, None, str(v['sku'] or v['id']), ean,
                              p['title'], p.get('vendor'), _shopify_image(p, v))
            price = int(round(float(v['price']) * 100))
            old = v.get('compare_at_price')
            old = int(round(float(old) * 100)) if old and float(old) > 0 else None
            if add_price(con, iid, price, old, v.get('available', True), 'shopify_json'):
                n_new += 1
    con.commit()
    print(f'  записано наблюдений цены: {n_new}')


def cmd_bazarstore_promo(path='raw/bazarstore_promo.json'):
    """Акции Bazarstore.

    В общем фиде /products.json поле compare_at_price приходит нулём, а в фиде
    коллекции «Endirimli Məhsullar» — настоящим. Поэтому акции берём оттуда.
    """
    if not os.path.exists(path):
        print('нет файла', path); return
    con = db()
    cid = con.execute("SELECT id FROM chains WHERE code='bazarstore'").fetchone()['id']
    EAN = json.load(open('raw/bazarstore_ean.json')) if os.path.exists('raw/bazarstore_ean.json') else {}
    n = 0
    for p in json.load(open(path)):
        for v in p['variants']:
            old = v.get('compare_at_price')
            old = int(round(float(old) * 100)) if old and float(old) > 0 else None
            if not old:
                continue
            price = int(round(float(v['price']) * 100))
            if old <= price:
                continue
            sku = str(v['sku'] or v['id'])
            iid = upsert_item(con, cid, None, sku, EAN.get(sku, ''), p['title'], p.get('vendor'))
            if add_price(con, iid, price, old, v.get('available', True), 'shopify_collection'):
                n += 1
    con.commit()
    print(f'  Bazarstore: акций записано {n}')


# ---------- коннектор 2: Bravo (Wolt), из сохранённого дампа ----------

# Ниже и выше этих границ магазин почти наверняка не бакинский: цены в другой
# валюте. Так в выборку один раз заехал русскоязычный «grandmart» с медианой 1014.
SANE_MEDIAN = (30, 5000)      # в гяпиках: от 0.30 до 50 манатов


def _sane(items):
    pr = sorted(i['price'] for i in items if i.get('price'))
    if not pr:
        return False, 'нет цен'
    med = pr[len(pr) // 2]
    if not (SANE_MEDIAN[0] <= med <= SANE_MEDIAN[1]):
        return False, f'медиана цены {med/100:.2f} вне разумного диапазона'
    return True, ''


def cmd_wolt(path='raw/wolt_all.json'):
    """Грузит любую сеть с витрины Wolt: цена, акция, GTIN, привязка к точке."""
    if not os.path.exists(path):
        print('нет файла', path); return
    con = db()
    D = json.load(open(path))
    for chain, venues in D.items():
        cid = con.execute('SELECT id FROM chains WHERE code=?', (chain,)).fetchone()['id']
        n_new = n_promo = 0
        for slug, d in venues.items():
            ok, why = _sane(d['items'])
            if not ok:
                print(f'  ОТКЛОНЁН {slug}: {why}'); continue
            con.execute("""INSERT OR IGNORE INTO stores
                           (chain_id, ext_id, name, format, price_cluster) VALUES (?,?,?,?,?)""",
                        (cid, slug, slug.replace('-', ' ').title(), d['format'], d.get('cluster')))
            sid = con.execute('SELECT id FROM stores WHERE chain_id=? AND ext_id=?',
                              (cid, slug)).fetchone()['id']
            for it in d['items']:
                if it.get('price') is None:
                    continue
                # id товара у Wolt стабилен и уникален. Раньше я выводил sku из
                # хвостовых цифр названия, и «Siyəzən Toyuq 1010» слипался с
                # «Qələm Pensan 1010»: разные товары, один ключ, ложная смена цены.
                sku = it.get('id') or norm_name(it['name'])[:60]
                iid = upsert_item(con, cid, sid, sku, it.get('gtin') or '', it['name'],
                                  None, it.get('image'))
                if add_price(con, iid, int(it['price']), it.get('old'),
                             it.get('available', True), 'wolt_api', it.get('promo_until')):
                    n_new += 1
                if it.get('promo'):
                    n_promo += 1
        con.commit()
        print(f'  {chain}: точек {len(venues)}, наблюдений {n_new}, из них по акции {n_promo}')


def cmd_bravo(path=None):
    path = path or ('raw/wolt_bravo_full.json'
                    if os.path.exists('raw/wolt_bravo_full.json') else 'raw/wolt_bravo.json')
    if not os.path.exists(path):
        print('нет файла', path); return
    print('  источник:', path)
    con = db()
    cid = con.execute("SELECT id FROM chains WHERE code='bravo'").fetchone()['id']
    D = json.load(open(path))
    clusters = json.load(open('raw/bravo_clusters.json')) if os.path.exists('raw/bravo_clusters.json') else {}
    n_new = 0
    for slug, d in D.items():
        cl = d.get('cluster') or clusters.get(slug)
        con.execute("""INSERT OR IGNORE INTO stores (chain_id, ext_id, name, format, price_cluster)
                       VALUES (?,?,?,?,?)""",
                    (cid, slug, slug.replace('-', ' ').title(), d['format'], cl))
        sid = con.execute('SELECT id FROM stores WHERE chain_id=? AND ext_id=?',
                          (cid, slug)).fetchone()['id']
        for it in d['items']:
            if it.get('price') is None:
                continue
            # внутренний код Bravo зашит в хвост названия
            m = re.search(r'(\d{3,6})\s*$', it['name'].strip())
            sku = m.group(1) if m else norm_name(it['name'])[:60]
            iid = upsert_item(con, cid, sid, sku, it.get('gtin') or '', it['name'],
                              None, it.get('image'))
            if add_price(con, iid, int(it['price']), None, 1, 'wolt_api'):
                n_new += 1
    con.commit()
    print(f'  Bravo: точек {len(D)}, наблюдений цены {n_new}')


# ---------- матчинг ----------

def cmd_match():
    """Ступень 1: по глобальному EAN. Ступень 2: бренд + объём + нормализованное имя."""
    con = db()
    ean_n = rule_n = 0

    # 1. EAN
    rows = con.execute("""SELECT id, ean, raw_name, brand, unit_value, unit_type
                          FROM store_items
                          WHERE product_id IS NULL AND ean_kind='global'""").fetchall()
    for r in rows:
        p = con.execute('SELECT id FROM products WHERE ean=?', (r['ean'],)).fetchone()
        if p:
            pid = p['id']
        else:
            cur = con.execute("""INSERT INTO products (ean, name, brand, unit_value, unit_type)
                                 VALUES (?,?,?,?,?)""",
                              (r['ean'], r['raw_name'], r['brand'], r['unit_value'], r['unit_type']))
            pid = cur.lastrowid
        con.execute('UPDATE store_items SET product_id=? WHERE id=?', (pid, r['id']))
        con.execute("""INSERT OR IGNORE INTO matches (store_item_id, product_id, method, confidence)
                       VALUES (?,?,'ean',1.0)""", (r['id'], pid))
        ean_n += 1

    # 1b. отпечаток против УЖЕ существующих карточек.
    #
    # Без этого шага сети без штрихкода никогда не приклеятся к товару, который
    # уже нашёлся по EAN. Шаг 2 ниже сводит между собой только позиции без пары,
    # а карточка, созданная на шаге 1, для него не существует — и Neptun,
    # у которого штрихкод есть у 4% позиций, заводил себе отдельную карточку
    # на каждый товар. В базе это дало 4007 пар, где рядом лежат «Atena Süd
    # 2.4% 1 l» из neptun и «Atena Süd 2.4% 1 l» из spar с ОДИНАКОВЫМ
    # отпечатком: пользователь видит один товар дважды с разными ценами.
    #
    # Сравнение точное, а не по похожести: отпечаток включает слова, фасовку и
    # жирность, и совпадение целиком — то же основание, на котором склеивает
    # шаг 2. Порог 0.82 из cmd_similar() сюда не годится вовсе: «Azərsüd Süd»
    # и «Azər Süd» дают 0.62 и не склеятся, а понижать порог нельзя — на нём
    # держится точность 96%.
    known = {}
    for r in con.execute("""SELECT si.product_id, si.raw_name
                            FROM store_items si
                            WHERE si.product_id IS NOT NULL""").fetchall():
        k = fingerprint.key(r['raw_name'])
        if k is not None:
            # Первый победивший остаётся: карточки создаются по возрастанию id,
            # и держаться раннего id стабильнее между прогонами.
            known.setdefault(k, r['product_id'])

    exist_n = 0
    for r in con.execute("""SELECT id, raw_name, chain_id FROM store_items
                            WHERE product_id IS NULL""").fetchall():
        k = fingerprint.key(r['raw_name'])
        pid = known.get(k) if k is not None else None
        if pid is None:
            continue
        con.execute('UPDATE store_items SET product_id=? WHERE id=?', (pid, r['id']))
        con.execute("""INSERT OR IGNORE INTO matches (store_item_id, product_id, method, confidence)
                       VALUES (?,?,'rule',0.75)""", (r['id'], pid))
        exist_n += 1

    # 2. отпечаток по названию: слова + фасовка + жирность.
    # Это единственный способ сравнить весовые товары и сети без штрихкодов.
    rows = con.execute("""SELECT id, raw_name, brand, unit_value, unit_type, chain_id
                          FROM store_items WHERE product_id IS NULL""").fetchall()
    fp = {}
    for r in rows:
        k = fingerprint.key(r['raw_name'])
        if k is None:
            continue
        fp.setdefault(k, []).append(r)

    fp_n = 0
    for k, rs in fp.items():
        if len({r['chain_id'] for r in rs}) < 2:
            continue                      # отпечаток внутри одной сети ничего не даёт
        cur = con.execute("""INSERT INTO products (name, brand, unit_value, unit_type)
                             VALUES (?,?,?,?)""",
                          (rs[0]['raw_name'], rs[0]['brand'],
                           rs[0]['unit_value'], rs[0]['unit_type']))
        pid = cur.lastrowid
        for r in rs:
            con.execute('UPDATE store_items SET product_id=? WHERE id=?', (pid, r['id']))
            con.execute("""INSERT OR IGNORE INTO matches
                           (store_item_id, product_id, method, confidence)
                           VALUES (?,?,'rule',0.75)""", (r['id'], pid))
            fp_n += 1

    # 3. остаток: каждому своя карточка, сравнивать не с чем
    rows = con.execute("""SELECT id, norm_name, unit_value, unit_type, raw_name, brand
                          FROM store_items WHERE product_id IS NULL""").fetchall()
    seen = {}
    for r in rows:
        k = (r['norm_name'], r['unit_value'], r['unit_type'])
        if k in seen:
            pid = seen[k]
        else:
            cur = con.execute("""INSERT INTO products (name, brand, unit_value, unit_type)
                                 VALUES (?,?,?,?)""",
                              (r['raw_name'], r['brand'], r['unit_value'], r['unit_type']))
            pid = seen[k] = cur.lastrowid
        con.execute('UPDATE store_items SET product_id=? WHERE id=?', (pid, r['id']))
        con.execute("""INSERT OR IGNORE INTO matches (store_item_id, product_id, method, confidence)
                       VALUES (?,?,'rule',0.5)""", (r['id'], pid))
        rule_n += 1

    refresh_product_images(con)

    con.commit()
    print(f'  сматчено по EAN: {ean_n}, приклеено к готовым карточкам: {exist_n}, '
          f'по отпечатку названия: {fp_n}, без пары: {rule_n}')


def refresh_product_images(con):
    """Проставляет products.image_url по позициям сетей.

    Отдельным проходом, а не в трёх местах, где создаётся продукт: карточка,
    найденная по EAN, переиспользует уже существующий продукт, и картинка у неё
    могла бы не появиться никогда — INSERT для неё просто не выполняется.

    Берём картинку любой сети, у которой она есть, предпочитая ту, что пришла
    раньше (min(id) — сеть, которую собрали первой). Товар один, картинки в
    сетях отличаются ракурсом, а не содержимым.

    Переписываем только там, где картинки нет: если сеть в этот прогон отдала
    пустоту, карточка должна остаться со вчерашней, а не мигать плашкой.
    """
    cur = con.execute("""
        UPDATE products SET image_url = (
            SELECT si.image_url FROM store_items si
             WHERE si.product_id = products.id AND si.image_url IS NOT NULL
             ORDER BY si.id LIMIT 1
        )
        WHERE image_url IS NULL
          AND EXISTS (SELECT 1 FROM store_items si
                       WHERE si.product_id = products.id AND si.image_url IS NOT NULL)
    """)
    total = con.execute('SELECT count(*) c FROM products').fetchone()['c']
    withimg = con.execute(
        'SELECT count(*) c FROM products WHERE image_url IS NOT NULL').fetchone()['c']
    pct = 100.0 * withimg / total if total else 0.0
    print(f'  картинки: проставлено {cur.rowcount}, всего с картинкой '
          f'{withimg}/{total} ({pct:.1f}%)')


def cmd_similar():
    """Четвёртая ступень: похожесть названий для того, что осталось без пары.

    Автоматически склеиваем только при совпавшей фасовке и близких ценах.
    Всё сомнительное уходит в match_queue, а не на витрину.
    """
    con = db()
    rows = con.execute("""
        SELECT si.id, si.chain_id, si.raw_name, si.product_id, cp.price, cp.old_price
        FROM store_items si
        JOIN current_prices cp ON cp.store_item_id = si.id
        JOIN products p ON p.id = si.product_id
        WHERE p.ean IS NULL
          AND si.id IN (SELECT store_item_id FROM matches WHERE confidence <= 0.5)
    """).fetchall()
    items = [{'id': r['id'], 'chain': r['chain_id'], 'name': r['raw_name'],
              'price': r['price'], 'base': r['old_price'] or r['price'],
              'pid': r['product_id']} for r in rows]
    print(f'  кандидатов без пары: {len(items)}')
    if not items:
        return

    pairs = similar.candidates(items)
    print(f'  похожих пар найдено: {len(pairs)}')

    merged = queued = 0
    done, asked = set(), set()

    def pid_of(item_id):
        # карточка могла переехать предыдущей склейкой, поэтому спрашиваем базу,
        # а не кэш из candidates()
        r = con.execute('SELECT product_id FROM store_items WHERE id=?', (item_id,)).fetchone()
        return r['product_id'] if r else None

    for sim, a, b in pairs:
        act, why = similar.decide(sim, a, b)
        if act == 'drop':
            continue
        pa, pb = pid_of(a['id']), pid_of(b['id'])
        if pa is None or pb is None or pa == pb:
            continue
        if act == 'queue':
            # одна строка на пару карточек, а не на каждую позицию: у Bravo четыре
            # ценовые зоны, и без этого человек получит один и тот же вопрос четырежды
            if (pa, pb) in asked:
                continue
            asked.add((pa, pb))
            con.execute("""INSERT INTO match_queue (store_item_id, candidate_id, score, status)
                           VALUES (?,?,?, 'pending')""", (a['id'], pb, round(sim, 3)))
            queued += 1
            continue
        if a['id'] in done or b['id'] in done:
            continue
        a = dict(a, pid=pa); b = dict(b, pid=pb)
        # Переселяем ВСЁ, что висело на карточке b, в карточку a. Двигать только
        # одну позицию нельзя: на b могут ссылаться другие store_items и matches,
        # и тогда карточка остаётся полупустой, а внешний ключ падает.
        con.execute('UPDATE store_items SET product_id=? WHERE product_id=?', (a['pid'], b['pid']))
        con.execute("""UPDATE matches SET product_id=?, method='embedding', confidence=?
                       WHERE product_id=?""", (a['pid'], round(sim, 3), b['pid']))
        con.execute('UPDATE match_queue SET candidate_id=? WHERE candidate_id=?', (a['pid'], b['pid']))
        con.execute('DELETE FROM audit_log WHERE product_id=?', (b['pid'],))
        con.execute('DELETE FROM products WHERE id=?', (b['pid'],))
        done.add(a['id']); done.add(b['id'])
        merged += 1

    con.commit()
    print(f'  склеено автоматически: {merged}, отправлено человеку: {queued}')


# ---------- аудит склеек ----------

SPREAD_LIMIT = 0.50      # расхождение цен между сетями, выше которого склейке не верим
PACK_TOLERANCE = 0.02    # расхождение фасовки, которое считаем округлением
PRICE_SANITY   = 0.25    # если при разной фасовке цены расходятся сильнее — склейке не верим


def cmd_audit():
    """Ищем склейки, которым нельзя верить, и отправляем их человеку.

    Два признака. Первый: цены расходятся сильнее чем в полтора раза, при этом ни у
    одной стороны не заявлена акция. Второй: у сетей разная фасовка при одинаковом EAN,
    это либо мультипак под тем же кодом, либо ошибка в GTIN.
    """
    con = db()
    # Аудит идемпотентен: свой прошлый вердикт сбрасываем целиком. Свои строки —
    # это те, где score пустой; со score в очереди лежат кандидаты от cmd_similar,
    # и стирать их здесь нельзя, иначе они исчезают при каждом прогоне аудита.
    con.execute("DELETE FROM match_queue WHERE status='pending' AND score IS NULL")
    con.execute('DELETE FROM audit_log')
    con.execute('UPDATE products SET quarantined = 0 WHERE quarantined = 1')

    rows = con.execute("""
        SELECT p.id AS pid, p.ean, p.name,
               si.id AS sid, c.code AS chain, si.unit_value, si.unit_type, si.pack,
               cp.price, cp.old_price
        FROM products p
        JOIN store_items si    ON si.product_id = p.id
        JOIN chains c          ON c.id = si.chain_id
        JOIN current_prices cp ON cp.store_item_id = si.id
        WHERE p.ean IS NOT NULL
    """).fetchall()

    by = {}
    for r in rows:
        by.setdefault(r['pid'], []).append(r)

    flagged = []
    for pid, rs in by.items():
        chains = {r['chain'] for r in rs}
        if len(chains) < 2:
            continue

        # берём по одной минимальной цене на сеть, чтобы промо в одной зоне не било в глаза
        per_chain = {}
        for r in rs:
            cur = per_chain.get(r['chain'])
            if cur is None or r['price'] < cur['price']:
                per_chain[r['chain']] = r
        vals = [r['price'] for r in per_chain.values()]
        lo, hi = min(vals), max(vals)
        spread = (hi - lo) / lo if lo else 0
        any_promo = any(r['old_price'] for r in per_chain.values())

        # расхождение в фасовке между сетями
        us = sorted(r['unit_value'] for r in per_chain.values()
                    if r['unit_type'] and r['unit_value'])
        pack_off = bool(us) and (us[-1] - us[0]) / us[0] > PACK_TOLERANCE
        types = {r['unit_type'] for r in per_chain.values() if r['unit_type']}
        ps = {r['pack'] for r in per_chain.values() if r['pack']}

        reason, quarantine = None, True
        if spread > SPREAD_LIMIT and not any_promo:
            reason = f'разброс {round(spread * 100)}% без акции'
        elif (pack_off or len(types) > 1) and spread > PRICE_SANITY:
            reason = (f'разная фасовка при одном EAN и цена расходится на '
                      f'{round(spread * 100)}%: {sorted(types)} {us}')
        elif len(ps) > 1 and spread > PRICE_SANITY:
            reason = f'разное число штук в упаковке: {sorted(ps)}'
        elif pack_off or len(types) > 1 or len(ps) > 1:
            # цены сходятся, значит товар почти наверняка тот же, а расходятся описания.
            # Это дефект данных у сети, а не ошибка склейки: логируем, но не прячем.
            reason, quarantine = f'разные описания фасовки, цены сходятся: {us}', False

        if reason:
            flagged.append((pid, reason, quarantine, rs))

    for pid, reason, quarantine, rs in flagged:
        con.execute('INSERT INTO audit_log (product_id, reason, quarantined) VALUES (?,?,?)',
                    (pid, reason, int(quarantine)))
        if not quarantine:
            continue
        for r in rs:
            con.execute("""INSERT INTO match_queue (store_item_id, candidate_id, score, status)
                           VALUES (?,?,?, 'pending')""", (r['sid'], pid, None))
        con.execute('UPDATE products SET quarantined = 1 WHERE id = ?', (pid,))
    con.commit()

    total = sum(1 for pid, rs in by.items() if len({r['chain'] for r in rs}) > 1)
    q = sum(1 for f in flagged if f[2])
    print(f'  межсетевых склеек:        {total}')
    if not total:
        # Ноль межсетевых склеек — это не «нечего проверять», а отказ сбора:
        # значит, ни один товар не нашёлся больше чем в одной сети.
        print('  ВНИМАНИЕ: межсетевых склеек ноль. Похоже, сбор привёз данные'
              ' только одной сети или матчинг не отработал.')
        con.commit()
        return
    print(f'  в карантин (человеку):    {q} ({round(100 * q / total, 1)}%)')
    print(f'  помечено, но показываем:  {len(flagged) - q}')
    import collections
    kinds = collections.Counter(re.sub(r'\d+', 'N', r).split(':')[0] for _, r, _, _ in flagged)
    for k, v in kinds.most_common():
        print(f'    {v:5}  {k}')


# ---------- отчёт ----------

def cmd_report():
    con = db()
    q = lambda s: con.execute(s).fetchone()[0]
    print(f"сетей:              {q('SELECT COUNT(*) FROM chains')}")
    print(f"точек:              {q('SELECT COUNT(*) FROM stores')}")
    print(f"позиций в сетях:    {q('SELECT COUNT(*) FROM store_items')}")
    print(f"канонических тов.:  {q('SELECT COUNT(*) FROM products')}")
    print(f"наблюдений цены:    {q('SELECT COUNT(*) FROM price_observations')}")
    print()
    print('позиции по типу штрихкода:')
    for r in con.execute("""SELECT c.code, si.ean_kind, COUNT(*) n FROM store_items si
                            JOIN chains c ON c.id=si.chain_id
                            GROUP BY 1,2 ORDER BY 1,3 DESC"""):
        print(f'  {r[0]:12} {r[1]:9} {r[2]:6}')
    print()
    print('товары, найденные больше чем в одной сети:')
    rows = con.execute("""SELECT p.name, p.ean, COUNT(DISTINCT si.chain_id) nch
                          FROM products p JOIN store_items si ON si.product_id=p.id
                          GROUP BY p.id HAVING nch > 1 LIMIT 10""").fetchall()
    n_multi = con.execute("""SELECT COUNT(*) FROM (
                    SELECT p.id FROM products p
                    JOIN store_items si ON si.product_id = p.id
                    GROUP BY p.id HAVING COUNT(DISTINCT si.chain_id) > 1)""").fetchone()[0]
    print(f'  всего таких: {n_multi}')
    for r in rows:
        print(f'  {r["ean"] or "-":>14}  {r["name"][:55]}')


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'report'
    lim = int(sys.argv[2]) if len(sys.argv) > 2 else None
    {'init': cmd_init, 'bazarstore': lambda: cmd_bazarstore(lim),
     'bravo': cmd_bravo, 'wolt': cmd_wolt, 'bzpromo': cmd_bazarstore_promo,
     'match': cmd_match, 'similar': cmd_similar,
     'audit': cmd_audit, 'report': cmd_report}[cmd]()

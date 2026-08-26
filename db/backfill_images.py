"""Разовый добор картинок для уже собранной базы.

Обычный прогон пайплайна картинки проставляет сам: upsert_item() пишет
image_url, cmd_match() переносит её в products. Этот скрипт нужен там, где
база уже есть, а ждать следующего сбора не хочется — например, сразу после
миграции 0010 на боевой базе.

Ничего, кроме image_url, не трогает: ни цен, ни матчинга, ни времён наблюдения.

    python3 db/backfill_images.py                     всё
    python3 db/backfill_images.py --chains araz,spar  только эти сети
    python3 db/backfill_images.py --dry-run           посчитать, не записывая

Сопоставление идёт по chain_sku, и это работает потому, что для сетей с Wolt
там лежит настоящий id товара из источника, а не выведенный из названия.
Именно ради таких случаев в своё время и отказались от «взять хвостовые цифры
названия»: ключ должен принадлежать источнику, иначе он врёт.
"""
import argparse
import json
import os
import sys
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

import psycopg

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "pipeline"))
import wolt  # noqa: E402  (после sys.path)

UA = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                  "AppleWebKit/537.36 Chrome/128.0 Safari/537.36",
    "Accept": "application/json",
}

# Сети, которые собираются через Wolt. Bazarstore живёт на Shopify и разбирается
# отдельной веткой ниже.
WOLT_CHAINS = ("bravo", "araz", "neptun", "spar", "rahat")


def pg_dsn() -> str:
    """DSN для psycopg. Из окружения, как и везде в проекте."""
    url = (os.environ.get("QIYMET_DATABASE_URL")
           or os.environ.get("DATABASE_URL")
           or "postgresql://qiymet@localhost:5432/qiymet")
    # SQLAlchemy-префикс psycopg не понимает.
    return url.replace("postgresql+psycopg://", "postgresql://")


def wolt_images(slug: str) -> dict[str, str]:
    """{item_id: image_url} для одной точки."""
    base = wolt.BASE.format(v=slug)
    a = wolt.get(base)
    if not a:
        return {}
    lv = wolt.leaves(a.get("categories", []))

    def one(c):
        r = wolt.get(base + "/categories/slug/" + urllib.parse.quote(c["slug"], safe=""))
        return r.get("items", []) if r else []

    out: dict[str, str] = {}
    with ThreadPoolExecutor(6) as ex:
        for items in ex.map(one, lv):
            for it in items:
                url = wolt._image(it)
                if url and it.get("id"):
                    out[str(it["id"])] = url
    return out


def bazarstore_images() -> dict[str, str]:
    """{variant_sku: image_url} по всему каталогу Shopify."""
    out: dict[str, str] = {}
    page = 1
    while True:
        u = f"https://bazarstore.az/products.json?limit=250&page={page}"
        try:
            d = json.load(urllib.request.urlopen(
                urllib.request.Request(u, headers=UA), timeout=30))
        except Exception as e:
            print(f"  Bazarstore: стоп на странице {page}: {e}")
            break
        prods = d.get("products", [])
        if not prods:
            break
        for p in prods:
            for v in p.get("variants", []):
                src = None
                fi = v.get("featured_image") or {}
                if fi.get("src"):
                    src = fi["src"]
                else:
                    for img in (p.get("images") or []):
                        if (img or {}).get("src"):
                            src = img["src"]
                            break
                if src:
                    out[str(v.get("sku") or v.get("id"))] = src
        page += 1
    return out


def apply(conn, chain_code: str, mapping: dict[str, str], dry: bool) -> int:
    """Пишет image_url тем позициям сети, у которых его ещё нет."""
    if not mapping:
        return 0
    with conn.cursor() as cur:
        cur.execute("SELECT id FROM chains WHERE code = %s", (chain_code,))
        row = cur.fetchone()
        if not row:
            return 0
        cid = row[0]
        # Только там, где пусто: свежая картинка из прогона важнее нашей.
        cur.execute(
            "SELECT id, chain_sku FROM store_items "
            "WHERE chain_id = %s AND image_url IS NULL", (cid,))
        pending = cur.fetchall()
        pairs = [(mapping[sku], sid) for sid, sku in pending if sku in mapping]
        if dry or not pairs:
            return len(pairs)
        cur.executemany("UPDATE store_items SET image_url = %s WHERE id = %s", pairs)
    return len(pairs)


def main() -> int:
    ap = argparse.ArgumentParser(description="Добор картинок в уже собранную базу")
    ap.add_argument("--chains", help="через запятую; по умолчанию все")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    want = {c.strip() for c in args.chains.split(",")} if args.chains else None

    conn = psycopg.connect(pg_dsn(), autocommit=False)
    total = 0

    with conn.cursor() as cur:
        cur.execute(
            "SELECT c.code, s.ext_id FROM stores s JOIN chains c ON c.id = s.chain_id "
            "WHERE c.code = ANY(%s) ORDER BY c.code", (list(WOLT_CHAINS),))
        venues = cur.fetchall()

    for code, slug in venues:
        if want and code not in want:
            continue
        imgs = wolt_images(slug)
        n = apply(conn, code, imgs, args.dry_run)
        total += n
        print(f"  {code:12} {slug:34} картинок у источника {len(imgs):5}, проставлено {n}")

    if not want or "bazarstore" in want:
        imgs = bazarstore_images()
        n = apply(conn, "bazarstore", imgs, args.dry_run)
        total += n
        print(f"  {'bazarstore':12} {'shopify':34} картинок у источника {len(imgs):5}, проставлено {n}")

    # Перенос на карточку — той же логикой, что в пайплайне: только пустым.
    if not args.dry_run:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE products p SET image_url = sub.image_url
                  FROM (SELECT DISTINCT ON (product_id) product_id, image_url
                          FROM store_items
                         WHERE product_id IS NOT NULL AND image_url IS NOT NULL
                         ORDER BY product_id, id) sub
                 WHERE sub.product_id = p.id AND p.image_url IS NULL
            """)
            moved = cur.rowcount
        conn.commit()
        print(f"  на карточки перенесено: {moved}")
    else:
        conn.rollback()
        print("  --dry-run: ничего не записано")

    with conn.cursor() as cur:
        cur.execute("SELECT count(*) FILTER (WHERE image_url IS NOT NULL), count(*) "
                    "FROM products WHERE quarantined = 0")
        withimg, tot = cur.fetchone()
    print(f"\nкарточек с картинкой: {withimg}/{tot} "
          f"({100.0 * withimg / tot if tot else 0:.1f}%)")
    conn.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

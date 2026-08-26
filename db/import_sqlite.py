#!/usr/bin/env python3
"""Перелив qiymet.db (SQLite) в Postgres.

  export DATABASE_URL=postgresql://qiymet@localhost:5432/qiymet
  python3 db/import_sqlite.py --sqlite pipeline/qiymet.db

  python3 db/import_sqlite.py --verify     только сверить счётчики строк
  python3 db/import_sqlite.py --restart    снести данные и начать заново

Как устроен перезапуск с места обрыва. В Postgres заводится табличка
_import_progress с водяным знаком (последний перенесённый id) по каждой таблице.
Пакет строк и сдвиг водяного знака пишутся в ОДНОЙ транзакции, поэтому обрыв
питания в середине пакета откатывает и то и другое. После перезапуска работа
продолжается ровно с последнего зафиксированного id: ни дублей, ни дыр,
ON CONFLICT не нужен.

Про время. В SQLite времена лежат текстом от datetime('now'), а это UTC.
Здесь они читаются как UTC явно. Если этого не сделать, вся история цен уедет
на 4 часа (Баку = UTC+4) и «время наблюдения» на витрине станет враньём.
"""
import argparse
import os
import sqlite3
import sys
import time
from datetime import datetime, timezone

try:
    import psycopg
except ImportError:
    sys.exit("Нужен psycopg 3:  pip install 'psycopg[binary]'")


# Порядок важен: внешние ключи. Дети идут после родителей.
# Колонки перечислены явно, чтобы SELECT * не поехал при следующей миграции.
TABLES = [
    ("chains", ["id", "code", "name", "price_model"], []),
    ("stores",
     ["id", "chain_id", "ext_id", "name", "format", "price_cluster",
      "lat", "lon", "address"], []),
    ("products",
     ["id", "ean", "name", "brand", "unit_value", "unit_type", "category",
      "image_url", "quarantined", "created_at"], ["created_at"]),
    ("store_items",
     ["id", "chain_id", "store_id", "chain_sku", "ean", "ean_kind", "raw_name",
      "norm_name", "brand", "unit_value", "unit_type", "pack", "image_url", "category",
      "product_id", "first_seen", "last_seen"], ["first_seen", "last_seen"]),
    ("price_observations",
     ["id", "store_item_id", "price", "old_price", "promo_until", "available",
      "observed_at", "source"], ["promo_until", "observed_at"]),
    ("matches",
     ["id", "store_item_id", "product_id", "method", "confidence",
      "decided_at", "note"], ["decided_at"]),
    ("match_queue",
     ["id", "store_item_id", "candidate_id", "score", "status",
      "created_at"], ["created_at"]),
    ("audit_log",
     ["id", "product_id", "reason", "quarantined", "created_at"],
     ["created_at"]),
]


def pg_dsn() -> str:
    url = os.environ.get("DATABASE_URL")
    if not url:
        sys.exit("DATABASE_URL не задан.\n"
                 "  export DATABASE_URL=postgresql://qiymet@localhost:5432/qiymet")
    # env.py Alembic-а хочет диалект postgresql+psycopg://, libpq его не понимает
    return url.replace("postgresql+psycopg://", "postgresql://", 1)


def as_utc(v):
    """Текстовое время SQLite -> timestamptz. Наивное значение считаем UTC."""
    if v is None or v == "":
        return None
    if isinstance(v, (int, float)):
        return datetime.fromtimestamp(v, tz=timezone.utc)
    try:
        dt = datetime.fromisoformat(str(v).strip())
    except ValueError:
        sys.exit(f"Не разобрал время из SQLite: {v!r}. "
                 "Ожидался формат datetime('now') — 'YYYY-MM-DD HH:MM:SS'.")
    return dt if dt.tzinfo else dt.replace(tzinfo=timezone.utc)


def human(n: float) -> str:
    return f"{n:,.0f}".replace(",", " ")


class Progress:
    """Однострочный счётчик. В файл лога пишет построчно, без забоя каретки."""

    def __init__(self, table: str, total: int):
        self.table, self.total = table, total
        self.t0 = time.monotonic()
        self.tty = sys.stdout.isatty()

    def show(self, done: int, final: bool = False) -> None:
        el = time.monotonic() - self.t0
        rate = done / el if el > 0 else 0
        pct = 100.0 * done / self.total if self.total else 100.0
        eta = (self.total - done) / rate if rate > 0 and not final else 0
        tail = "" if final else f"  осталось ~{eta:5.0f}с"
        line = (f"  {self.table:<20} {human(done):>10} / {human(self.total):<10} "
                f"{pct:5.1f}%  {human(rate):>7} стр/с{tail}")
        if self.tty and not final:
            sys.stdout.write("\r" + line)
        else:
            sys.stdout.write(("\r" if self.tty else "") + line + "\n")
        sys.stdout.flush()


def ensure_progress_table(pg) -> None:
    pg.execute("""
        CREATE TABLE IF NOT EXISTS _import_progress (
            table_name text PRIMARY KEY,
            last_id    bigint      NOT NULL DEFAULT 0,
            rows_done  bigint      NOT NULL DEFAULT 0,
            updated_at timestamptz NOT NULL DEFAULT now()
        )
    """)
    pg.execute("COMMENT ON TABLE _import_progress IS "
               "'Водяные знаки разового перелива из SQLite. "
               "После успешной сверки таблицу можно удалить'")


def watermark(pg, table: str) -> tuple[int, int]:
    row = pg.execute(
        "SELECT last_id, rows_done FROM _import_progress WHERE table_name = %s",
        (table,)).fetchone()
    return (row[0], row[1]) if row else (0, 0)


def prepare_partitions(pg, lite) -> None:
    """Секции должны существовать до вставки, иначе всё уедет в DEFAULT."""
    r = lite.execute(
        "SELECT MIN(observed_at), MAX(observed_at) FROM price_observations"
    ).fetchone()
    if not r or not r[0]:
        return
    lo, hi = as_utc(r[0]).date(), as_utc(r[1]).date()
    n = pg.execute("SELECT ensure_price_partitions(%s, %s)", (lo, hi)).fetchone()[0]
    print(f"  секций price_observations под диапазон {lo}..{hi}: {n}")


def copy_table(pg, lite, table: str, cols: list[str], ts_cols: list[str],
               batch: int) -> int:
    last_id, done = watermark(pg, table)
    remaining = lite.execute(
        f"SELECT COUNT(*) FROM {table} WHERE id > ?", (last_id,)).fetchone()[0]

    if remaining == 0:
        print(f"  {table:<20} {human(done):>10} — уже перенесена")
        return done

    if last_id:
        print(f"  {table:<20} продолжаю с id > {human(last_id)}")

    ts_idx = [cols.index(c) for c in ts_cols]
    collist = ", ".join(cols)
    sel = f"SELECT {collist} FROM {table} WHERE id > ? ORDER BY id LIMIT ?"
    copy_sql = f"COPY {table} ({collist}) FROM STDIN"

    bar = Progress(table, remaining)
    moved = 0

    while True:
        rows = lite.execute(sel, (last_id, batch)).fetchall()
        if not rows:
            break

        # Пакет и водяной знак — одна транзакция. Обрыв откатывает оба.
        with pg.transaction():
            with pg.cursor().copy(copy_sql) as cp:
                for r in rows:
                    r = list(r)
                    for i in ts_idx:
                        r[i] = as_utc(r[i])
                    cp.write_row(r)

            last_id = rows[-1][0]
            done += len(rows)
            pg.execute("""
                INSERT INTO _import_progress (table_name, last_id, rows_done)
                VALUES (%s, %s, %s)
                ON CONFLICT (table_name) DO UPDATE
                   SET last_id = EXCLUDED.last_id,
                       rows_done = EXCLUDED.rows_done,
                       updated_at = now()
            """, (table, last_id, done))

        moved += len(rows)
        bar.show(moved)

        if len(rows) < batch:
            break

    bar.show(moved, final=True)
    return done


def reset_sequences(pg) -> None:
    """Identity-последовательности переставить за максимальный перенесённый id,
    иначе первый же INSERT из пайплайна упрётся в занятый ключ."""
    for table, cols, _ in TABLES:
        pg.execute(f"""
            SELECT setval(pg_get_serial_sequence('{table}', 'id'),
                          GREATEST(COALESCE(MAX(id), 0), 1),
                          COALESCE(MAX(id), 0) > 0)
            FROM {table}
        """)
    print("  последовательности переставлены")


def verify(pg, lite) -> bool:
    print("\nСверка количества строк:")
    print(f"  {'таблица':<20} {'SQLite':>12} {'Postgres':>12}   итог")
    ok = True
    for table, _, _ in TABLES:
        a = lite.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        b = pg.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        good = a == b
        ok &= good
        print(f"  {table:<20} {human(a):>12} {human(b):>12}   "
              f"{'совпало' if good else 'РАСХОЖДЕНИЕ ' + human(b - a)}")

    stray = pg.execute(
        "SELECT count(*) FROM price_observations_default").fetchone()[0]
    if stray:
        ok = False
        print(f"\n  {stray} строк осели в секции DEFAULT — не хватило "
              f"помесячных секций")
    return ok


def restart(pg) -> None:
    names = ", ".join(t for t, _, _ in TABLES)
    pg.execute(f"TRUNCATE {names} RESTART IDENTITY CASCADE")
    pg.execute("DELETE FROM _import_progress")
    print("Данные снесены, водяные знаки сброшены.")


def main() -> int:
    ap = argparse.ArgumentParser(description="Перелив qiymet.db в Postgres")
    ap.add_argument("--sqlite", default="pipeline/qiymet.db")
    ap.add_argument("--batch", type=int, default=5000)
    ap.add_argument("--restart", action="store_true",
                    help="снести данные в Postgres и начать заново")
    ap.add_argument("--verify", action="store_true",
                    help="только сверить счётчики, ничего не переносить")
    ap.add_argument("--no-refresh", action="store_true",
                    help="не пересобирать current_prices в конце")
    args = ap.parse_args()

    if not os.path.exists(args.sqlite):
        sys.exit(f"Нет файла {args.sqlite}")

    lite = sqlite3.connect(f"file:{args.sqlite}?mode=ro", uri=True)

    # autocommit=True здесь обязателен, и это не косметика. Без него psycopg
    # открывает неявную транзакцию на первом же execute (у нас это SELECT
    # водяного знака), и тогда `with pg.transaction()` вкладывается в неё
    # SAVEPOINT-ом вместо отдельной транзакции. Пакеты не фиксируются, kill -9
    # в середине откатывает вообще всю работу, а водяные знаки остаются
    # пустыми — то есть перезапуск с места обрыва не работает ровно тогда,
    # когда он нужен. Проверено обрывом: откатилось всё до нуля.
    pg = psycopg.connect(pg_dsn(), autocommit=True)

    try:
        ensure_progress_table(pg)

        # Сброс идёт первым: иначе --restart --verify молча свёлся бы к одной
        # сверке, и «я же сбросил» разошлось бы с тем, что в базе.
        if args.restart:
            restart(pg)

        if args.verify:
            return 0 if verify(pg, lite) else 1

        print(f"Перелив {args.sqlite} -> Postgres, пакет {human(args.batch)} строк\n")
        t0 = time.monotonic()

        prepare_partitions(pg, lite)

        for table, cols, ts_cols in TABLES:
            copy_table(pg, lite, table, cols, ts_cols, args.batch)

        reset_sequences(pg)

        # Планировщику нужна свежая статистика, иначе первые запросы поедут
        # по плану для пустых таблиц.
        print("  ANALYZE...")
        pg.execute("ANALYZE")

        # СВЕРКА ИДЁТ ДО ПЕРЕСБОРКИ ВИТРИН, и порядок здесь — весь смысл.
        #
        # Раньше verify() стоял последней строкой, после refresh_after_crawl().
        # Оборванный перелив — сеть моргнула, кончилось место, процесс убили по
        # OOM — доводил дело до конца так: витрины пересобирались по неполным
        # данным, current_prices и deal_honesty становились «свежими», и только
        # потом печаталось расхождение счётчиков. Дальше по цепочке проверки
        # данных и уведомления работали уже с этой полуправдой.
        #
        # Половина каталога в current_prices выглядит не как авария, а как
        # обычные цены: у товара просто «нет цены в этой сети». Уведомления по
        # такой картине рассылают падения, которых не было.
        if not verify(pg, lite):
            print(
                "\nПерелив неполный: витрины НЕ пересобирались.\n"
                "В базе остались прежние current_prices и deal_honesty — "
                "старые, но целые.\n"
                "Повторный запуск продолжит с места обрыва: водяные знаки "
                "в _import_progress на месте."
            )
            return 1

        if not args.no_refresh:
            print("  пересобираю витрины (current_prices, deal_honesty)...")
            pg.execute("SELECT refresh_after_crawl()")
            pg.execute("ANALYZE current_prices")
            pg.execute("ANALYZE deal_honesty")

        print(f"\nГотово за {time.monotonic() - t0:.1f}с")
        return 0

    finally:
        pg.close()
        lite.close()


if __name__ == "__main__":
    raise SystemExit(main())

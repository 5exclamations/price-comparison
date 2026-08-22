"""Прогон проверок данных.

  python3 -m checks.runner                 прогнать и напечатать
  python3 -m checks.runner --source crawl  и записать результат в dq_runs

Запускается в двух местах:

  * в CI по свежей БД — ненулевой код возврата блокирует деплой;
  * после каждого прогона сбора — с --source crawl, чтобы результат лёг в
    dq_runs и приложение показало плашку «данные обновляются» вместо
    подозрительных цифр.

Прогон НЕ останавливается на первой упавшей проверке: если сломался сбор, чаще
падает сразу несколько, и видеть надо все, а не первую по алфавиту.
"""
from __future__ import annotations

import argparse
import json
import os
import sys

from . import data_checks as dc


def _rows(cur) -> list[dict]:
    cols = [d[0] for d in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


def run_all(conn, *, allow_stale: bool = False) -> tuple[list[dc.CheckResult], dict]:
    """Прогнать все восемь проверок. Возвращает результаты и метрики.

    `allow_stale` пропускает восьмую (свежесть данных) и нужен ровно в одном
    месте — в CI. Там база поднимается из дампа, лежащего в репозитории, и он
    заведомо старше двенадцати часов: проверка мерила бы возраст файла, а не
    работу сбора. На проде пропускать её нельзя, и раннер это запрещает.
    """
    results: list[dc.CheckResult] = []

    with conn.cursor() as cur:
        cur.execute(dc.SQL_NON_POSITIVE_PRICE)
        results.append(dc.check_non_positive_price(_rows(cur)))

        cur.execute(dc.SQL_BAD_PROMO)
        results.append(dc.check_bad_promo(_rows(cur)))

        cur.execute(dc.SQL_DUPLICATE_SKU)
        results.append(dc.check_duplicate_sku(_rows(cur)))

        cur.execute(dc.SQL_DUPLICATE_EAN)
        results.append(dc.check_duplicate_ean(_rows(cur)))

        cur.execute(dc.SQL_CHAIN_MEDIANS)
        results.append(dc.check_chain_medians(_rows(cur)))

        cur.execute(dc.SQL_PACKAGING_PER_CHAIN)
        packaging = dc.check_packaging(_rows(cur))
        results.append(packaging)

        # Склейки сравниваются с прошлым прогоном — читаем его до записи нового.
        cur.execute("SELECT * FROM dq_metrics()")
        metrics = _rows(cur)[0]

        cur.execute(
            "SELECT cross_chain_merges FROM dq_runs ORDER BY started_at DESC LIMIT 1"
        )
        previous_row = cur.fetchone()
        previous = previous_row[0] if previous_row else None

        results.append(
            dc.check_merges_not_dropped(metrics["cross_chain_merges"], previous)
        )

        if allow_stale:
            results.append(
                dc.CheckResult(
                    name="данные свежие",
                    passed=True,
                    skipped=True,
                    detail=(
                        "не гонялась: база поднята из дампа в репозитории, "
                        "её возраст ничего не говорит о сборе"
                    ),
                )
            )
        else:
            cur.execute(dc.SQL_STORE_AGES)
            results.append(dc.check_freshness(_rows(cur)))

    return results, metrics


def record(conn, results: list[dc.CheckResult], metrics: dict, source: str) -> None:
    """Записать прогон в историю.

    Пишется ВСЕГДА, и при провале тоже: именно по упавшему прогону приложение
    понимает, что надо показать плашку вместо цифр.
    """
    failures = [
        {"name": r.name, "detail": r.detail, "offenders": r.offenders[:5]}
        for r in results
        if not r.passed
    ]
    # Пропущенная проверка тоже пишется: иначе по истории нельзя отличить
    # полный прогон от урезанного, и «всё зелено» перестаёт что-то значить.
    failures += [
        {"name": r.name, "detail": r.detail, "skipped": True}
        for r in results
        if r.skipped
    ]
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO dq_runs (products, store_items, cross_chain_merges,
                                 packaging_ratio, worst_age_hours,
                                 passed, failures, source)
            VALUES (%s, %s, %s, %s, %s, %s, %s::jsonb, %s)
            """,
            (
                metrics["products"],
                metrics["store_items"],
                metrics["cross_chain_merges"],
                metrics["packaging_ratio"],
                metrics["worst_age_hours"],
                all(r.passed for r in results),
                json.dumps(failures, ensure_ascii=False, default=str),
                source,
            ),
        )
    conn.commit()


def main() -> int:
    ap = argparse.ArgumentParser(prog="checks.runner")
    ap.add_argument(
        "--source",
        choices=["ci", "crawl", "manual"],
        default="ci",
        help="Записать прогон в dq_runs с этим источником",
    )
    ap.add_argument(
        "--no-record", action="store_true", help="Не писать в историю"
    )
    ap.add_argument(
        "--allow-stale",
        action="store_true",
        help=(
            "Пропустить проверку свежести. Только для CI, где база поднята "
            "из дампа в репозитории"
        ),
    )
    args = ap.parse_args()

    # Прод пропускать свежесть не имеет права: именно она ловит сеть, которая
    # не обновлялась сутки, а это тот отказ, после которого не возвращаются.
    if args.allow_stale and args.source == "crawl":
        ap.error("--allow-stale несовместим с --source crawl")

    import psycopg

    dsn = os.environ.get(
        "DATABASE_URL", "postgresql://qiymet@localhost:5432/qiymet"
    ).replace("postgresql+psycopg://", "postgresql://", 1)

    with psycopg.connect(dsn) as conn:
        results, metrics = run_all(conn, allow_stale=args.allow_stale)
        if not args.no_record:
            record(conn, results, metrics, args.source)

    print(f"\nПроверки данных ({len(results)}):\n")
    for r in results:
        print(f"  {r}")
        for offender in r.offenders[:3]:
            print(f"        {offender}")

    skipped = [r for r in results if r.skipped]
    failed = [r for r in results if not r.passed]
    print()
    if skipped:
        print(f"Пропущено {len(skipped)}: " + ", ".join(r.name for r in skipped))
    if failed:
        print(f"УПАЛО {len(failed)} из {len(results)}. Деплой заблокирован.")
        return 1
    print(f"Прошло {len(results) - len(skipped)} из {len(results)}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

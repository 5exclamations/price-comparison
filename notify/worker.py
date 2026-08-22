"""Воркер: собрать дельты после прогона сбора и поставить уведомления в очередь.

Опроса в цикле нет. price_observations пишется только при изменении цены, значит
пара соседних наблюдений — это уже событие; тот же приём, что в
pipeline/history.py. Воркер помнит, докуда разобрал (worker_state.watermark), и
берёт только то, что появилось после.

Сравнивается самое свежее наблюдение в окне с последним наблюдением ДО окна, а
не соседние пары внутри окна. Если за прогон цена успела сходить 100 -> 90 -> 95,
пользователю важно, что стало 95 против прежних 100, а не промежуточные шаги.

Первый запуск ничего не рассылает: водяной знак ставится на текущий максимум
observed_at. Иначе развёртывание на живой базе разослало бы всем историю за всё
время разом.
"""
import logging
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from .rules import Delta, Draft, Skip, Watch, plan

log = logging.getLogger("notify.worker")

WORKER_NAME = "price_drop"

# Дельты: самое свежее наблюдение в окне против последнего наблюдения до окна.
#
# LATERAL, а не оконная функция с оглядкой на N дней: цена пишется только при
# изменении, поэтому предыдущее наблюдение может оказаться и трёхмесячной
# давности. Любое окно оглядки рано или поздно промахнулось бы мимо него.
# LATERAL идёт по idx_po_item_time и берёт ровно одну строку.
DELTAS = """
WITH latest AS (
    SELECT DISTINCT ON (po.store_item_id)
           po.store_item_id, po.price, po.old_price, po.available, po.observed_at
    FROM price_observations po
    WHERE po.observed_at > :since AND po.observed_at <= :until
    ORDER BY po.store_item_id, po.observed_at DESC, po.id DESC
)
SELECT l.store_item_id,
       si.product_id,
       si.chain_id,
       c.code            AS chain_code,
       c.name            AS chain_name,
       si.store_id,
       st.price_cluster,
       p.name            AS product_name,
       l.price,
       prev.price        AS prev_price,
       l.old_price,
       l.available,
       l.observed_at,
       dh.market_price,
       dh.real_discount,
       coalesce(dh.inflated, false) AS inflated
FROM latest l
JOIN store_items si   ON si.id = l.store_item_id
JOIN products p       ON p.id = si.product_id
JOIN chains c         ON c.id = si.chain_id
LEFT JOIN stores st   ON st.id = si.store_id
LEFT JOIN deal_honesty dh ON dh.store_item_id = l.store_item_id
CROSS JOIN LATERAL (
    SELECT p2.price
    FROM price_observations p2
    WHERE p2.store_item_id = l.store_item_id
      AND p2.observed_at <= :since
    ORDER BY p2.observed_at DESC
    LIMIT 1
) prev
WHERE p.quarantined = 0        -- карантинную склейку не показываем никогда
  AND l.price < prev.price     -- нас интересует только падение
"""

WATCHES = """
SELECT w.id, w.user_id, w.product_id, w.store_id, w.target_price_minor,
       u.lang, u.timezone,
       ws.chain_id  AS store_chain_id,
       wc.price_model AS store_price_model
FROM watches w
JOIN users u        ON u.id = w.user_id
LEFT JOIN stores ws ON ws.id = w.store_id
LEFT JOIN chains wc ON wc.id = ws.chain_id
WHERE w.active
  AND w.product_id = ANY(CAST(:pids AS int[]))
"""

# Кому уже слали за последние сутки. Смотрим по факту отправки, а не по факту
# постановки в очередь: уведомление, пролежавшее ночь и не ушедшее, не должно
# блокировать утреннее.
RECENT = """
SELECT DISTINCT user_id, product_id
FROM notifications
WHERE status = 'sent'
  AND sent_at > :since
  AND product_id = ANY(CAST(:pids AS int[]))
"""

# Частичный уникальный индекс не даёт положить второе ожидающее уведомление по
# паре пользователь-товар. Если за время ожидания нашлось предложение выгоднее,
# обновляем ту же строку.
ENQUEUE = """
INSERT INTO notifications (
    user_id, watch_id, product_id, store_item_id, chain_id, store_id,
    price_minor, prev_price_minor, old_price_minor, market_price_minor,
    drop_pct, real_discount, reason, observed_at, send_after)
VALUES (
    :user_id, :watch_id, :product_id, :store_item_id, :chain_id, :store_id,
    :price, :prev_price, :old_price, :market_price,
    :drop_pct, :real_discount, :reason, :observed_at, :send_after)
ON CONFLICT (user_id, product_id) WHERE status = 'pending'
DO UPDATE SET
    watch_id           = EXCLUDED.watch_id,
    store_item_id      = EXCLUDED.store_item_id,
    chain_id           = EXCLUDED.chain_id,
    store_id           = EXCLUDED.store_id,
    price_minor        = EXCLUDED.price_minor,
    prev_price_minor   = EXCLUDED.prev_price_minor,
    old_price_minor    = EXCLUDED.old_price_minor,
    market_price_minor = EXCLUDED.market_price_minor,
    drop_pct           = EXCLUDED.drop_pct,
    real_discount      = EXCLUDED.real_discount,
    reason             = EXCLUDED.reason,
    observed_at        = EXCLUDED.observed_at,
    -- send_after не трогаем: если уведомление уже дождалось утра, вечернее
    -- обновление не должно отложить его на следующие сутки
    created_at         = notifications.created_at
WHERE EXCLUDED.price_minor < notifications.price_minor
RETURNING id
"""


@dataclass
class RunResult:
    watermark_from: datetime
    watermark_to: datetime
    deltas: int
    drafts: int
    queued: int
    skips: list[Skip]

    def __str__(self) -> str:
        return (
            f"дельт {self.deltas}, черновиков {self.drafts}, "
            f"в очередь {self.queued}, отказов {len(self.skips)}"
        )


async def _watermark(conn: AsyncConnection) -> datetime | None:
    row = (
        await conn.execute(
            text("SELECT watermark FROM worker_state WHERE worker = :w"),
            {"w": WORKER_NAME},
        )
    ).first()
    return row[0] if row else None


async def _init_watermark(conn: AsyncConnection) -> datetime:
    """Первый запуск: встаём на текущий максимум и ничего не рассылаем."""
    now = (
        await conn.execute(
            text("SELECT coalesce(max(observed_at), now()) FROM price_observations")
        )
    ).scalar()
    await conn.execute(
        text(
            "INSERT INTO worker_state (worker, watermark) VALUES (:w, :t) "
            "ON CONFLICT (worker) DO NOTHING"
        ),
        {"w": WORKER_NAME, "t": now},
    )
    log.info("первый запуск: водяной знак поставлен на %s, рассылки нет", now)
    return now


async def load_deltas(
    conn: AsyncConnection, since: datetime, until: datetime
) -> list[Delta]:
    rows = (
        await conn.execute(text(DELTAS), {"since": since, "until": until})
    ).mappings().all()
    return [
        Delta(
            store_item_id=r["store_item_id"],
            product_id=r["product_id"],
            chain_id=r["chain_id"],
            chain_code=r["chain_code"],
            chain_name=r["chain_name"],
            store_id=r["store_id"],
            price_cluster=r["price_cluster"],
            product_name=r["product_name"],
            price=r["price"],
            prev_price=r["prev_price"],
            old_price=r["old_price"],
            available=bool(r["available"]),
            observed_at=r["observed_at"],
            market_price=r["market_price"],
            real_discount=r["real_discount"],
            inflated=bool(r["inflated"]),
        )
        for r in rows
    ]


async def load_watches(conn: AsyncConnection, pids: list[int]) -> list[Watch]:
    if not pids:
        return []
    rows = (await conn.execute(text(WATCHES), {"pids": pids})).mappings().all()
    return [
        Watch(
            id=r["id"],
            user_id=r["user_id"],
            product_id=r["product_id"],
            store_id=r["store_id"],
            target_price_minor=r["target_price_minor"],
            lang=r["lang"],
            timezone=r["timezone"],
            store_chain_id=r["store_chain_id"],
            store_price_model=r["store_price_model"],
        )
        for r in rows
    ]


async def load_recent(
    conn: AsyncConnection, pids: list[int], now: datetime
) -> set[tuple[int, int]]:
    if not pids:
        return set()
    rows = (
        await conn.execute(
            text(RECENT), {"pids": pids, "since": now - timedelta(hours=24)}
        )
    ).all()
    return {(r[0], r[1]) for r in rows}


async def enqueue(conn: AsyncConnection, drafts: list[Draft]) -> int:
    queued = 0
    for d in drafts:
        row = (
            await conn.execute(
                text(ENQUEUE),
                {
                    "user_id": d.watch.user_id,
                    "watch_id": d.watch.id,
                    "product_id": d.delta.product_id,
                    "store_item_id": d.delta.store_item_id,
                    "chain_id": d.delta.chain_id,
                    "store_id": d.delta.store_id,
                    "price": d.delta.price,
                    "prev_price": d.delta.prev_price,
                    "old_price": d.delta.old_price,
                    "market_price": d.delta.market_price,
                    "drop_pct": d.delta.drop_pct,
                    "real_discount": d.delta.real_discount,
                    "reason": d.reason,
                    "observed_at": d.delta.observed_at,
                    "send_after": d.send_after,
                },
            )
        ).first()
        if row is not None:
            queued += 1
    return queued


async def run_once(conn: AsyncConnection, now: datetime | None = None) -> RunResult:
    """Один проход. Вызывать после каждого прогона сбора."""
    now = now or datetime.now(timezone.utc)

    since = await _watermark(conn)
    if since is None:
        since = await _init_watermark(conn)
        return RunResult(since, since, 0, 0, 0, [])

    deltas = await load_deltas(conn, since, now)
    pids = sorted({d.product_id for d in deltas})

    watches = await load_watches(conn, pids)
    recent = await load_recent(conn, pids, now)

    drafts, skips = plan(deltas, watches, recent, now)
    queued = await enqueue(conn, drafts)

    await conn.execute(
        text(
            """
            UPDATE worker_state
               SET watermark = :t, updated_at = now(),
                   last_run_deltas = :d, last_run_queued = :q
             WHERE worker = :w
            """
        ),
        {"t": now, "d": len(deltas), "q": queued, "w": WORKER_NAME},
    )

    result = RunResult(since, now, len(deltas), len(drafts), queued, skips)
    log.info("прогон уведомлений: %s", result)
    return result

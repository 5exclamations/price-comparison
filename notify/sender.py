"""Отправщик: берёт из очереди то, чему пришло время, и шлёт в FCM.

Про часовые пояса здесь ничего нет и быть не должно: тихие часы уже учтены в
notifications.send_after, когда воркер ставил уведомление в очередь. Отправщик
только сравнивает send_after с текущим временем.

Уведомление уходит на все живые устройства пользователя. Успехом считается хотя
бы одна успешная доставка: у человека может быть выключенный старый телефон,
и из-за него терять пуш на рабочем не надо.
"""
import logging
from dataclasses import dataclass, field
from datetime import datetime, timezone

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncConnection

from .fcm import FcmMessage, FcmResult, FcmTransport, Verdict
from .messages import render
from .rules import Delta, Watch

log = logging.getLogger("notify.sender")

MAX_ATTEMPTS = 5

DUE = """
SELECT n.id, n.user_id, n.watch_id, n.product_id, n.store_item_id,
       n.chain_id, n.store_id,
       n.price_minor, n.prev_price_minor, n.old_price_minor,
       n.market_price_minor, n.drop_pct, n.real_discount,
       n.reason, n.observed_at, n.attempts,
       p.name  AS product_name,
       c.code  AS chain_code,
       c.name  AS chain_name,
       st.price_cluster,
       u.lang, u.timezone,
       w.target_price_minor
FROM notifications n
JOIN users u        ON u.id = n.user_id
JOIN products p     ON p.id = n.product_id
JOIN chains c       ON c.id = n.chain_id
LEFT JOIN stores st ON st.id = n.store_id
LEFT JOIN watches w ON w.id = n.watch_id
WHERE n.status = 'pending'
  AND n.send_after <= :now
ORDER BY n.send_after, n.id
LIMIT :lim
"""

TOKENS = """
SELECT user_id, token
FROM device_tokens
WHERE disabled_at IS NULL
  AND user_id = ANY(CAST(:uids AS int[]))
"""


@dataclass
class SendReport:
    due: int = 0
    sent: int = 0
    failed: int = 0
    no_tokens: int = 0
    retried: int = 0
    tokens_disabled: int = 0
    messages: list[FcmMessage] = field(default_factory=list)

    def __str__(self) -> str:
        return (
            f"к отправке {self.due}, отправлено {self.sent}, "
            f"без токенов {self.no_tokens}, повтор {self.retried}, "
            f"провал {self.failed}, выключено токенов {self.tokens_disabled}"
        )


def _to_delta(row) -> Delta:
    """Собрать Delta из сохранённой строки очереди — рендер ждёт именно её."""
    return Delta(
        store_item_id=row["store_item_id"],
        product_id=row["product_id"],
        chain_id=row["chain_id"],
        chain_code=row["chain_code"],
        chain_name=row["chain_name"],
        store_id=row["store_id"],
        price_cluster=row["price_cluster"],
        product_name=row["product_name"],
        price=row["price_minor"],
        prev_price=row["prev_price_minor"],
        old_price=row["old_price_minor"],
        available=True,
        observed_at=row["observed_at"],
        market_price=row["market_price_minor"],
        real_discount=row["real_discount"],
        inflated=False,
    )


async def send_due(
    conn: AsyncConnection,
    transport: FcmTransport,
    now: datetime | None = None,
    limit: int = 500,
) -> SendReport:
    now = now or datetime.now(timezone.utc)
    report = SendReport()

    rows = (await conn.execute(text(DUE), {"now": now, "lim": limit})).mappings().all()
    report.due = len(rows)
    if not rows:
        return report

    uids = sorted({r["user_id"] for r in rows})
    token_rows = (await conn.execute(text(TOKENS), {"uids": uids})).all()
    by_user: dict[int, list[str]] = {}
    for uid, tok in token_rows:
        by_user.setdefault(uid, []).append(tok)

    messages: list[FcmMessage] = []
    owner: list[int] = []          # id уведомления для каждого сообщения

    for r in rows:
        tokens = by_user.get(r["user_id"], [])
        if not tokens:
            # Подписка есть, устройства нет. Это не ошибка отправки, поэтому
            # не жжём попытки, а закрываем уведомление.
            await conn.execute(
                text(
                    "UPDATE notifications SET status='failed', "
                    "last_error='нет живых токенов' WHERE id = :id"
                ),
                {"id": r["id"]},
            )
            report.no_tokens += 1
            continue

        watch = Watch(
            id=r["watch_id"] or 0,
            user_id=r["user_id"],
            product_id=r["product_id"],
            store_id=r["store_id"],
            target_price_minor=r["target_price_minor"],
            lang=r["lang"],
            timezone=r["timezone"],
        )
        text_out = render(watch, _to_delta(r), r["reason"])

        for tok in tokens:
            messages.append(
                FcmMessage(
                    token=tok,
                    title=text_out.title,
                    body=text_out.body,
                    data={
                        "product_id": r["product_id"],
                        "chain": r["chain_code"],
                        "price_minor": r["price_minor"],
                        "notification_id": r["id"],
                    },
                )
            )
            owner.append(r["id"])

    if not messages:
        return report

    results: list[FcmResult] = await transport.send(messages)
    report.messages = messages

    # Разложить результаты по уведомлениям.
    per_notification: dict[int, list[FcmResult]] = {}
    for nid, res in zip(owner, results):
        per_notification.setdefault(nid, []).append(res)

    dead_tokens = {res.token for res in results if res.verdict is Verdict.DEAD_TOKEN}
    good_tokens = {res.token for res in results if res.ok}

    if dead_tokens:
        await conn.execute(
            text(
                "UPDATE device_tokens SET disabled_at = :now, "
                "disabled_reason = 'FCM: токен не адресуем' "
                "WHERE token = ANY(CAST(:t AS text[])) AND disabled_at IS NULL"
            ),
            {"now": now, "t": sorted(dead_tokens)},
        )
        report.tokens_disabled = len(dead_tokens)

    if good_tokens:
        await conn.execute(
            text(
                "UPDATE device_tokens SET last_success_at = :now "
                "WHERE token = ANY(CAST(:t AS text[]))"
            ),
            {"now": now, "t": sorted(good_tokens)},
        )

    for nid, res_list in per_notification.items():
        if any(r.ok for r in res_list):
            await conn.execute(
                text(
                    "UPDATE notifications SET status='sent', sent_at=:now, "
                    "attempts = attempts + 1 WHERE id = :id"
                ),
                {"now": now, "id": nid},
            )
            report.sent += 1
            continue

        retryable = any(r.verdict is Verdict.RETRY for r in res_list)
        codes = ",".join(sorted({r.error_code for r in res_list if r.error_code}))

        if retryable:
            row = (
                await conn.execute(
                    text(
                        "UPDATE notifications SET attempts = attempts + 1, "
                        "last_error = :err WHERE id = :id "
                        "RETURNING attempts"
                    ),
                    {"id": nid, "err": codes},
                )
            ).first()
            if row and row[0] >= MAX_ATTEMPTS:
                await conn.execute(
                    text(
                        "UPDATE notifications SET status='failed' WHERE id = :id"
                    ),
                    {"id": nid},
                )
                report.failed += 1
            else:
                report.retried += 1
        else:
            # Все токены мертвы — повторять нечего.
            await conn.execute(
                text(
                    "UPDATE notifications SET status='failed', "
                    "attempts = attempts + 1, last_error = :err WHERE id = :id"
                ),
                {"id": nid, "err": codes},
            )
            report.failed += 1

    log.info("отправка: %s", report)
    return report

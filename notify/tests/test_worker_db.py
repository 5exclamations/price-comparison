"""Воркер против настоящего Postgres: дельты, очередь, дедупликация.

Чистые правила проверены в test_rules.py. Здесь проверяется всё остальное:
выборка дельт по водяному знаку, LATERAL до предыдущего наблюдения, стык с
deal_honesty и уникальный индекс на ожидающие уведомления.
"""
from datetime import timedelta

import pytest
from sqlalchemy import text

from notify.worker import run_once

from .conftest import (
    BRAVO_STORE_A1,
    INFLATED_PRODUCT,
    INFLATED_STORE_ITEM,
    PLAIN_PRODUCT,
    PLAIN_STORE_ITEM,
)

pytestmark = pytest.mark.asyncio


async def queued(conn):
    rows = (
        await conn.execute(
            text(
                "SELECT user_id, product_id, store_item_id, price_minor, "
                "prev_price_minor, reason, status, send_after "
                "FROM notifications ORDER BY id"
            )
        )
    ).mappings().all()
    return [dict(r) for r in rows]


async def test_price_drop_is_queued(conn, make_user, make_watch, observe,
                                    set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)          # -30%

    result = await run_once(conn, now=now)

    assert result.queued == 1
    rows = await queued(conn)
    assert len(rows) == 1
    assert rows[0]["user_id"] == uid
    assert rows[0]["product_id"] == PLAIN_PRODUCT
    assert rows[0]["price_minor"] == 700
    assert rows[0]["prev_price_minor"] == 1000
    assert rows[0]["reason"] == "price_drop"
    assert rows[0]["status"] == "pending"


async def test_small_drop_is_not_queued(conn, make_user, make_watch, observe,
                                        set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 980, t1)          # -2%

    result = await run_once(conn, now=now)
    assert result.queued == 0
    assert await queued(conn) == []


async def test_inflated_promo_is_never_queued(conn, make_user, make_watch,
                                              observe, set_watermark, times):
    """Главное правило: накрученную скидку не шлём, как бы ни упала цена.

    Позиция взята из настоящей витрины deal_honesty — та самая, где заявленная
    скидка глубже настоящей на 53 п.п.
    """
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, INFLATED_PRODUCT)

    await observe(INFLATED_STORE_ITEM, 2000, t0)
    await set_watermark(t0)
    await observe(INFLATED_STORE_ITEM, 989, t1, old_price=1390)   # -50%

    result = await run_once(conn, now=now)

    assert result.queued == 0
    assert await queued(conn) == []
    assert any(s.reason == "inflated" for s in result.skips)


async def test_target_price_fires_below_threshold(conn, make_user, make_watch,
                                                  observe, set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT, target=990)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 985, t1)          # всего -1.5%, но ниже цели

    await run_once(conn, now=now)
    rows = await queued(conn)
    assert len(rows) == 1
    assert rows[0]["reason"] == "target_hit"


async def test_unavailable_is_not_queued(conn, make_user, make_watch, observe,
                                         set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1, available=0)

    result = await run_once(conn, now=now)
    assert result.queued == 0


async def test_net_change_across_several_observations(conn, make_user,
                                                      make_watch, observe,
                                                      set_watermark, times):
    """За прогон цена сходила 1000 -> 500 -> 960.

    Пользователю важно, что стало 960 против прежних 1000, а не промежуточные
    шаги: -4% порога не берут, уведомления быть не должно.
    """
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1)
    await observe(PLAIN_STORE_ITEM, 960, t1 + timedelta(minutes=5))

    result = await run_once(conn, now=now)
    assert result.queued == 0


async def test_previous_observation_may_be_old(conn, make_user, make_watch,
                                               observe, set_watermark, times):
    """Предыдущее наблюдение может быть месячной давности.

    price_observations пишется только при изменении, поэтому оглядка на
    фиксированное окно рано или поздно промахнулась бы мимо предшественника.
    LATERAL находит его всегда.

    Сценарий вынесен вперёд по времени относительно дампа: иначе предшественником
    оказалась бы не наша «старая» запись, а наблюдение из самого дампа.
    """
    t0, _, _ = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    old = t0 + timedelta(days=15)          # начало сентября
    drop = old + timedelta(days=40)        # середина октября
    uid_now = drop + timedelta(hours=1)

    await observe(PLAIN_STORE_ITEM, 1000, old)
    await set_watermark(drop - timedelta(hours=1))
    await observe(PLAIN_STORE_ITEM, 700, drop)

    result = await run_once(conn, now=uid_now)
    assert result.queued == 1
    assert (await queued(conn))[0]["prev_price_minor"] == 1000


async def test_no_watch_no_notification(conn, observe, set_watermark, times):
    t0, t1, now = times
    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1)

    result = await run_once(conn, now=now)
    assert result.deltas >= 1        # дельту видим
    assert result.queued == 0        # а слать некому


async def test_watch_on_other_store_does_not_fire(conn, make_user, make_watch,
                                                  observe, set_watermark, times):
    """Подписка на зону Bravo не срабатывает от падения в другой зоне."""
    t0, t1, now = times
    uid = await make_user()
    # PLAIN_STORE_ITEM живёт в магазине 1 (зона A1), подписываемся на магазин 3
    await make_watch(uid, PLAIN_PRODUCT, store_id=3)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1)

    result = await run_once(conn, now=now)
    assert result.queued == 0


async def test_watch_on_matching_store_fires(conn, make_user, make_watch,
                                             observe, set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT, store_id=BRAVO_STORE_A1)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1)

    result = await run_once(conn, now=now)
    assert result.queued == 1


# ---------- дедупликация ----------


async def test_only_one_pending_per_user_and_product(conn, make_user, make_watch,
                                                     observe, set_watermark, times):
    """Два прогона подряд не дают двух ожидающих уведомлений.

    Держится на частичном уникальном индексе, а не на аккуратности кода: воркер
    однажды запустят в двух экземплярах.
    """
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)
    await run_once(conn, now=now)

    await set_watermark(t0)                      # как будто прогон повторили
    await observe(PLAIN_STORE_ITEM, 650, now)
    await run_once(conn, now=now + timedelta(minutes=1))

    rows = await queued(conn)
    assert len(rows) == 1, "второе ожидающее уведомление по той же паре"
    assert rows[0]["price_minor"] == 650, "должна остаться более выгодная цена"


async def test_pending_is_not_downgraded(conn, make_user, make_watch, observe,
                                         set_watermark, times):
    """Если новая цена хуже уже ожидающей, очередь не портим."""
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 500, t1)
    await run_once(conn, now=now)

    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 800, now)
    await run_once(conn, now=now + timedelta(minutes=1))

    rows = await queued(conn)
    assert len(rows) == 1
    assert rows[0]["price_minor"] == 500


async def test_sent_today_blocks_new_notification(conn, make_user, make_watch,
                                                  observe, set_watermark, times):
    """Не больше одного пуша в сутки на пользователя по одному товару."""
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)
    await run_once(conn, now=now)

    # помечаем как отправленное час назад
    await conn.execute(
        text(
            "UPDATE notifications SET status='sent', sent_at = :t WHERE status='pending'"
        ),
        {"t": now - timedelta(hours=1)},
    )

    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 400, now)
    result = await run_once(conn, now=now + timedelta(minutes=1))

    assert result.queued == 0
    assert any(s.reason == "already_sent_today" for s in result.skips)


async def test_after_24h_notification_is_allowed_again(conn, make_user,
                                                       make_watch, observe,
                                                       set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)
    await run_once(conn, now=now)
    await conn.execute(
        text(
            "UPDATE notifications SET status='sent', sent_at = :t WHERE status='pending'"
        ),
        {"t": now - timedelta(hours=25)},
    )

    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 400, now)
    result = await run_once(conn, now=now + timedelta(minutes=1))

    assert result.queued == 1


# ---------- водяной знак ----------


async def test_first_run_sends_nothing(conn, make_user, make_watch, observe):
    """Развёртывание на живой базе не должно разослать историю за всё время."""
    await conn.execute(text("DELETE FROM worker_state WHERE worker = 'price_drop'"))
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    result = await run_once(conn)

    assert result.queued == 0
    assert result.deltas == 0
    row = (
        await conn.execute(
            text("SELECT watermark FROM worker_state WHERE worker='price_drop'")
        )
    ).first()
    assert row is not None, "водяной знак обязан быть выставлен"


async def test_watermark_moves_forward(conn, observe, set_watermark, times):
    t0, t1, now = times
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 900, t1)

    await run_once(conn, now=now)

    row = (
        await conn.execute(
            text("SELECT watermark FROM worker_state WHERE worker='price_drop'")
        )
    ).first()
    assert row[0] == now


async def test_second_run_sees_nothing_new(conn, make_user, make_watch, observe,
                                           set_watermark, times):
    t0, t1, now = times
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)

    first = await run_once(conn, now=now)
    second = await run_once(conn, now=now + timedelta(minutes=1))

    assert first.queued == 1
    assert second.deltas == 0
    assert second.queued == 0


# ---------- тихие часы на уровне базы ----------


async def test_night_notification_waits_for_morning(conn, make_user, make_watch,
                                                    observe, set_watermark, times):
    """Уведомление, родившееся ночью, копится и уходит утром."""
    t0, _, _ = times
    night = t0.replace(hour=20)                  # 00:00 Баку следующего дня
    uid = await make_user(tz="Asia/Baku")
    await make_watch(uid, PLAIN_PRODUCT)

    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, night)

    await run_once(conn, now=night)

    rows = await queued(conn)
    assert len(rows) == 1
    send_after = rows[0]["send_after"]
    assert send_after > night
    # 00:00 Баку -> 08:00 Баку того же дня
    assert send_after - night == timedelta(hours=8)

"""Отправщик и классификация ответов FCM."""
from datetime import timedelta

import pytest
from sqlalchemy import text

from notify.fcm import CollectingFcm, FcmResult, Verdict, classify
from notify.sender import MAX_ATTEMPTS, send_due
from notify.worker import run_once

from .conftest import PLAIN_PRODUCT, PLAIN_STORE_ITEM

# Модульного pytestmark здесь нет намеренно: в файле есть и синхронные тесты
# классификации, а asyncio_mode = auto в pytest.ini сам пометит асинхронные.


# ---------- классификация ответов ----------


def test_success():
    assert classify(200, {"name": "projects/x/messages/1"})[0] is Verdict.OK


@pytest.mark.parametrize("code", ["UNREGISTERED", "NOT_FOUND", "INVALID_ARGUMENT",
                                  "SENDER_ID_MISMATCH"])
def test_dead_token_codes(code):
    payload = {"error": {"status": code}}
    assert classify(400, payload)[0] is Verdict.DEAD_TOKEN


@pytest.mark.parametrize("code", ["UNAVAILABLE", "INTERNAL", "QUOTA_EXCEEDED"])
def test_retryable_codes(code):
    payload = {"error": {"status": code}}
    assert classify(503, payload)[0] is Verdict.RETRY


def test_error_code_from_details():
    """Точная причина лежит в details, а не в верхнеуровневом status."""
    payload = {
        "error": {
            "status": "INVALID_ARGUMENT",
            "details": [{"errorCode": "UNREGISTERED"}],
        }
    }
    verdict, code = classify(400, payload)
    assert verdict is Verdict.DEAD_TOKEN
    assert code == "UNREGISTERED"


def test_auth_failure_is_retryable_not_dead_token():
    """401 — это протухшие учётные данные СЕРВЕРА.

    Выключить из-за этого токены пользователей значило бы потерять всю базу
    устройств из-за своей же ошибки конфигурации.
    """
    verdict, _ = classify(401, {"error": {"status": "UNAUTHENTICATED"}})
    assert verdict is Verdict.RETRY


def test_unknown_error_defaults_to_retry():
    """Неизвестное считаем временным: потерять пользователя навсегда хуже."""
    assert classify(418, {"error": {"status": "I_AM_A_TEAPOT"}})[0] is Verdict.RETRY


def test_server_errors_are_retryable():
    for code in (500, 502, 503, 429):
        assert classify(code, None)[0] is Verdict.RETRY


# ---------- отправка ----------


async def _queue_one(conn, make_user, make_watch, observe, set_watermark, times,
                     lang="ru", with_token=True):
    t0, t1, now = times
    uid = await make_user(lang=lang, with_token=with_token)
    await make_watch(uid, PLAIN_PRODUCT)
    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)
    await run_once(conn, now=now)
    return uid, now


async def test_sends_and_marks_sent(conn, make_user, make_watch, observe,
                                    set_watermark, times):
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    fcm = CollectingFcm()

    report = await send_due(conn, fcm, now=now)

    assert report.due == 1
    assert report.sent == 1
    assert len(fcm.sent) == 1
    assert "7.00" in fcm.sent[0].body and "10.00" in fcm.sent[0].body

    status = (
        await conn.execute(text("SELECT status, sent_at FROM notifications"))
    ).first()
    assert status[0] == "sent"
    assert status[1] is not None


async def test_quiet_hours_hold_the_message(conn, make_user, make_watch, observe,
                                            set_watermark, times):
    """Ночное уведомление лежит в очереди и не уходит до утра."""
    t0, _, _ = times
    night = t0.replace(hour=20)            # 00:00 по Баку
    uid = await make_user()
    await make_watch(uid, PLAIN_PRODUCT)
    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, night)
    await run_once(conn, now=night)

    fcm = CollectingFcm()

    # ночью — ничего
    assert (await send_due(conn, fcm, now=night)).due == 0
    assert fcm.sent == []

    # в 07:59 по Баку всё ещё ничего
    almost = night + timedelta(hours=7, minutes=59)
    assert (await send_due(conn, fcm, now=almost)).due == 0

    # в 08:00 уходит
    morning = night + timedelta(hours=8)
    assert (await send_due(conn, fcm, now=morning)).sent == 1
    assert len(fcm.sent) == 1


async def test_message_language_follows_user(conn, make_user, make_watch, observe,
                                             set_watermark, times):
    _, now = await _queue_one(conn, make_user, make_watch, observe, set_watermark,
                              times, lang="az")
    fcm = CollectingFcm()
    await send_due(conn, fcm, now=now)
    assert "əvəzinə" in fcm.sent[0].body


async def test_user_without_tokens_is_not_retried_forever(conn, make_user,
                                                          make_watch, observe,
                                                          set_watermark, times):
    """Подписка есть, устройства нет — закрываем, а не жжём попытки."""
    _, now = await _queue_one(conn, make_user, make_watch, observe, set_watermark,
                              times, with_token=False)
    fcm = CollectingFcm()

    report = await send_due(conn, fcm, now=now)

    assert report.no_tokens == 1
    assert fcm.sent == []
    assert (
        await conn.execute(text("SELECT status FROM notifications"))
    ).scalar() == "failed"


async def test_dead_token_is_disabled(conn, make_user, make_watch, observe,
                                      set_watermark, times):
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    token = (
        await conn.execute(
            text("SELECT token FROM device_tokens WHERE user_id = :u"), {"u": uid}
        )
    ).scalar()

    fcm = CollectingFcm({token: FcmResult(token, Verdict.DEAD_TOKEN, "UNREGISTERED")})
    report = await send_due(conn, fcm, now=now)

    assert report.tokens_disabled == 1
    assert report.failed == 1
    row = (
        await conn.execute(
            text("SELECT disabled_at, disabled_reason FROM device_tokens "
                 "WHERE token = :t"),
            {"t": token},
        )
    ).first()
    assert row[0] is not None and row[1]


async def test_disabled_token_is_not_used_again(conn, make_user, make_watch,
                                                observe, set_watermark, times):
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    await conn.execute(
        text("UPDATE device_tokens SET disabled_at = now() WHERE user_id = :u"),
        {"u": uid},
    )
    fcm = CollectingFcm()
    report = await send_due(conn, fcm, now=now)

    assert fcm.sent == []
    assert report.no_tokens == 1


async def test_retryable_error_keeps_notification_pending(conn, make_user,
                                                          make_watch, observe,
                                                          set_watermark, times):
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    token = (
        await conn.execute(
            text("SELECT token FROM device_tokens WHERE user_id = :u"), {"u": uid}
        )
    ).scalar()

    fcm = CollectingFcm({token: FcmResult(token, Verdict.RETRY, "UNAVAILABLE")})
    report = await send_due(conn, fcm, now=now)

    assert report.retried == 1
    row = (
        await conn.execute(
            text("SELECT status, attempts, last_error FROM notifications")
        )
    ).first()
    assert row[0] == "pending"
    assert row[1] == 1
    assert row[2] == "UNAVAILABLE"

    # токен временной ошибкой не выключается
    assert (
        await conn.execute(
            text("SELECT disabled_at FROM device_tokens WHERE token = :t"),
            {"t": token},
        )
    ).scalar() is None


async def test_retries_give_up_eventually(conn, make_user, make_watch, observe,
                                          set_watermark, times):
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    token = (
        await conn.execute(
            text("SELECT token FROM device_tokens WHERE user_id = :u"), {"u": uid}
        )
    ).scalar()
    fcm = CollectingFcm({token: FcmResult(token, Verdict.RETRY, "UNAVAILABLE")})

    for _ in range(MAX_ATTEMPTS):
        await send_due(conn, fcm, now=now)

    status, attempts = (
        await conn.execute(text("SELECT status, attempts FROM notifications"))
    ).first()
    assert status == "failed"
    assert attempts == MAX_ATTEMPTS


async def test_several_devices_one_success_is_enough(conn, make_user, make_watch,
                                                     observe, set_watermark, times):
    """У человека может быть выключенный старый телефон.

    Из-за него нельзя терять пуш на рабочем.
    """
    uid, now = await _queue_one(conn, make_user, make_watch, observe,
                                set_watermark, times)
    await conn.execute(
        text(
            "INSERT INTO device_tokens (user_id, token, platform) "
            "VALUES (:u, 'dead-token', 'ios')"
        ),
        {"u": uid},
    )

    fcm = CollectingFcm(
        {"dead-token": FcmResult("dead-token", Verdict.DEAD_TOKEN, "UNREGISTERED")}
    )
    report = await send_due(conn, fcm, now=now)

    assert report.sent == 1
    assert report.tokens_disabled == 1
    assert (
        await conn.execute(text("SELECT status FROM notifications"))
    ).scalar() == "sent"


async def test_batching(conn, make_user, make_watch, observe, set_watermark, times):
    """Все сообщения уходят одной пачкой, а не по одному запросу на цикл."""
    t0, t1, now = times
    for _ in range(5):
        uid = await make_user()
        await make_watch(uid, PLAIN_PRODUCT)
    await observe(PLAIN_STORE_ITEM, 1000, t0)
    await set_watermark(t0)
    await observe(PLAIN_STORE_ITEM, 700, t1)
    await run_once(conn, now=now)

    fcm = CollectingFcm()
    report = await send_due(conn, fcm, now=now)

    assert report.due == 5
    assert report.sent == 5
    assert fcm.batches == [5], "ожидалась одна пачка на пять адресатов"


async def test_nothing_due_is_a_noop(conn):
    fcm = CollectingFcm()
    report = await send_due(conn, fcm)
    assert report.due == 0
    assert fcm.sent == []


async def test_payload_carries_ids_for_deeplink(conn, make_user, make_watch,
                                                observe, set_watermark, times):
    _, now = await _queue_one(conn, make_user, make_watch, observe, set_watermark,
                              times)
    fcm = CollectingFcm()
    await send_due(conn, fcm, now=now)

    data = fcm.sent[0].data
    assert data["product_id"] == PLAIN_PRODUCT
    assert data["chain"] == "bravo"
    # FCM принимает только строки — проверяем, что сериализуется без потерь
    payload = fcm.sent[0].to_payload()
    assert all(isinstance(v, str) for v in payload["message"]["data"].values())

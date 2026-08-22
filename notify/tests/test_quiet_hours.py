"""Тихие часы 23:00–08:00 по Баку: копим и шлём утром."""
from datetime import datetime, timezone
from zoneinfo import ZoneInfo

import pytest

from notify.quiet_hours import is_quiet, send_after

BAKU = ZoneInfo("Asia/Baku")


def baku(y, m, d, hh, mm=0) -> datetime:
    return datetime(y, m, d, hh, mm, tzinfo=BAKU)


@pytest.mark.parametrize(
    "hour,quiet",
    [
        (8, False),    # ровно 08:00 — уже можно
        (9, False),
        (12, False),
        (22, False),
        (22, False),
        (23, True),    # ровно 23:00 — уже нельзя
        (0, True),
        (3, True),
        (7, True),
    ],
)
def test_boundaries(hour, quiet):
    assert is_quiet(baku(2026, 8, 17, hour), "Asia/Baku") is quiet


def test_seven_fifty_nine_is_quiet_and_eight_is_not():
    assert is_quiet(baku(2026, 8, 17, 7, 59)) is True
    assert is_quiet(baku(2026, 8, 17, 8, 0)) is False


def test_daytime_sends_immediately():
    moment = baku(2026, 8, 17, 14, 30)
    assert send_after(moment) == moment.astimezone(timezone.utc)


def test_late_evening_waits_for_next_morning():
    """23:30 понедельника -> 08:00 вторника."""
    moment = baku(2026, 8, 17, 23, 30)
    got = send_after(moment).astimezone(BAKU)
    assert (got.year, got.month, got.day, got.hour, got.minute) == (
        2026, 8, 18, 8, 0
    )


def test_after_midnight_waits_for_same_morning():
    """02:15 вторника -> 08:00 того же вторника, а не среды."""
    moment = baku(2026, 8, 18, 2, 15)
    got = send_after(moment).astimezone(BAKU)
    assert (got.year, got.month, got.day, got.hour) == (2026, 8, 18, 8)


def test_exactly_eight_is_not_delayed():
    moment = baku(2026, 8, 18, 8, 0)
    assert send_after(moment) == moment.astimezone(timezone.utc)


def test_month_boundary():
    """31 августа 23:40 -> 1 сентября 08:00."""
    got = send_after(baku(2026, 8, 31, 23, 40)).astimezone(BAKU)
    assert (got.month, got.day, got.hour) == (9, 1, 8)


def test_year_boundary():
    got = send_after(baku(2026, 12, 31, 23, 55)).astimezone(BAKU)
    assert (got.year, got.month, got.day, got.hour) == (2027, 1, 1, 8)


def test_utc_input_is_converted():
    """Вход в UTC, а тишина считается по Баку.

    18:00 UTC = 22:00 в Баку — ещё можно.
    19:00 UTC = 23:00 в Баку — уже нельзя.
    """
    assert is_quiet(datetime(2026, 8, 17, 18, 0, tzinfo=timezone.utc)) is False
    assert is_quiet(datetime(2026, 8, 17, 19, 0, tzinfo=timezone.utc)) is True


def test_other_timezone_is_respected():
    """Зона берётся из профиля пользователя, а не прибита к Баку."""
    moment = datetime(2026, 8, 17, 19, 0, tzinfo=timezone.utc)
    assert is_quiet(moment, "Asia/Baku") is True        # 23:00 в Баку
    assert is_quiet(moment, "Europe/Moscow") is False   # 22:00 в Москве


def test_result_is_always_utc_and_never_earlier():
    for hour in range(24):
        moment = baku(2026, 8, 17, hour)
        got = send_after(moment)
        assert got.tzinfo is timezone.utc
        assert got >= moment

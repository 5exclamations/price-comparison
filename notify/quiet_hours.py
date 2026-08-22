"""Тихие часы: 23:00–08:00 по местному времени пользователя.

Уведомление, родившееся ночью, не отбрасывается — оно копится и уходит утром.
Момент отправки считается один раз, при постановке в очередь, и ложится в
notifications.send_after. Отправщик потом просто берёт всё, чему пришло время,
и про часовые пояса ничего не знает.

Зона берётся из users.timezone (по умолчанию Asia/Baku) именем из базы tz, а не
смещением +04. Азербайджан отменил переход на летнее время в 2016-м, но
прибивать смещение гвоздями всё равно не стоит: правило может вернуться, и тогда
поедут все ночные отправки разом.
"""
from datetime import datetime, time, timedelta, timezone
from zoneinfo import ZoneInfo

QUIET_START = time(23, 0)   # включительно
QUIET_END = time(8, 0)      # не включая: ровно в 08:00 уже можно


def is_quiet(moment: datetime, tz: str = "Asia/Baku") -> bool:
    local = moment.astimezone(ZoneInfo(tz))
    return local.time() >= QUIET_START or local.time() < QUIET_END


def send_after(moment: datetime, tz: str = "Asia/Baku") -> datetime:
    """Ближайший момент, когда уведомление можно отправить, в UTC.

    Днём — прямо сейчас. Ночью — сегодняшние или завтрашние 08:00 по местному.
    """
    zone = ZoneInfo(tz)
    local = moment.astimezone(zone)

    if not is_quiet(moment, tz):
        return moment.astimezone(timezone.utc)

    # После 23:00 утро наступит завтра, до 08:00 — уже сегодня.
    wake_day = local.date()
    if local.time() >= QUIET_START:
        wake_day = wake_day + timedelta(days=1)

    # Собираем через datetime.combine с tzinfo, а не .replace() на уже
    # локализованном значении: при переходе на летнее время .replace() умеет
    # родить несуществующее время.
    wake = datetime.combine(wake_day, QUIET_END, tzinfo=zone)
    return wake.astimezone(timezone.utc)

"""Решение, слать ли уведомление. Чистая логика, без базы.

Здесь нет ни SQL, ни сети — только вход, правила и выход. Поэтому набор дельт
из теста проходит ровно тот же код, что и боевой прогон.

Правила:

  * цена упала минимум на 5% ИЛИ опустилась не выше target_price_minor;
  * накрученные скидки не шлём вовсе (deal_honesty.inflated);
  * не больше одного пуша в сутки на пользователя по одному товару;
  * если товару соответствует несколько подешевевших позиций (у Bravo это
    четыре ценовые зоны), берём одну — самую выгодную, а не четыре пуша.

Отдельно: падение считается от цены, которую мы ВИДЕЛИ в прошлом наблюдении,
а не от зачёркнутой цены на ценнике. Ценник может врать, наши наблюдения — нет.
"""
from dataclasses import dataclass
from datetime import datetime, timedelta

from .quiet_hours import send_after

MIN_DROP = 0.05           # 5%
DEDUP_WINDOW = timedelta(hours=24)


@dataclass(frozen=True)
class Delta:
    """Одна подешевевшая позиция: что было и что стало."""

    store_item_id: int
    product_id: int
    chain_id: int
    chain_code: str
    chain_name: str
    store_id: int | None
    price_cluster: str | None
    product_name: str

    price: int                      # гяпики
    prev_price: int                 # гяпики, наше прошлое наблюдение
    old_price: int | None           # зачёркнутая цена сети
    available: bool
    observed_at: datetime

    market_price: int | None = None      # медиана неакционных цен в других сетях
    real_discount: float | None = None   # настоящая скидка от рынка
    inflated: bool = False               # заявленная скидка глубже настоящей >15 п.п.

    @property
    def drop_pct(self) -> float:
        if self.prev_price <= 0:
            return 0.0
        return (self.prev_price - self.price) / self.prev_price


@dataclass(frozen=True)
class Watch:
    id: int
    user_id: int
    product_id: int
    store_id: int | None
    target_price_minor: int | None
    lang: str = "az"
    timezone: str = "Asia/Baku"
    # Сеть выбранного магазина и её модель цены — нужны, чтобы подписка на
    # филиал сети с единой ценой ловила всю сеть.
    store_chain_id: int | None = None
    store_price_model: str | None = None


@dataclass(frozen=True)
class Draft:
    """Готовое к постановке в очередь уведомление."""

    watch: Watch
    delta: Delta
    reason: str                     # price_drop | target_hit
    send_after: datetime


@dataclass(frozen=True)
class Skip:
    """Почему не отправили. Нужен для отладки и для тестов."""

    watch_id: int
    store_item_id: int
    reason: str


def matches(watch: Watch, delta: Delta) -> bool:
    """Относится ли подешевевшая позиция к этой подписке."""
    if watch.product_id != delta.product_id:
        return False
    if watch.store_id is None:
        return True                                  # следим за всеми сетями
    if delta.store_id == watch.store_id:
        return True
    # Подписка на филиал сети с единой ценой = подписка на всю сеть: прайс там
    # один, а позиции Bazarstore вообще лежат без store_id.
    return (
        watch.store_price_model == "single"
        and watch.store_chain_id == delta.chain_id
    )


def evaluate(watch: Watch, delta: Delta) -> tuple[str | None, str | None]:
    """(причина отправки, причина отказа). Ровно одно из двух не None."""
    if delta.inflated:
        # Смысл продукта в том, чтобы не врать. Накрученная скидка — враньё,
        # даже если формально цена упала.
        return None, "inflated"

    if not delta.available:
        # Цена на то, чего нет в наличии, — не выгода, а приманка.
        return None, "unavailable"

    if delta.price >= delta.prev_price:
        return None, "no_drop"

    target = watch.target_price_minor
    if target is not None and delta.price <= target:
        return "target_hit", None

    if delta.drop_pct >= MIN_DROP:
        return "price_drop", None

    return None, "below_threshold"


def _better(a: Delta, b: Delta) -> Delta:
    """Из двух подходящих позиций выбираем ту, что выгоднее пользователю."""
    if a.price != b.price:
        return a if a.price < b.price else b
    if a.drop_pct != b.drop_pct:
        return a if a.drop_pct > b.drop_pct else b
    return a if a.store_item_id < b.store_item_id else b   # детерминированность


def plan(
    deltas: list[Delta],
    watches: list[Watch],
    recently_notified: set[tuple[int, int]],
    now: datetime,
) -> tuple[list[Draft], list[Skip]]:
    """Разложить дельты по подпискам и решить, что отправлять.

    recently_notified — пары (user_id, product_id), которым уже слали за
    последние сутки. Приходит снаружи, чтобы функция оставалась чистой.

    Возвращает не больше одного черновика на пару (пользователь, товар).
    """
    best: dict[tuple[int, int], tuple[Watch, Delta, str]] = {}
    skips: list[Skip] = []

    for watch in watches:
        for delta in deltas:
            if not matches(watch, delta):
                continue

            key = (watch.user_id, watch.product_id)
            if key in recently_notified:
                skips.append(Skip(watch.id, delta.store_item_id, "already_sent_today"))
                continue

            reason, skip_reason = evaluate(watch, delta)
            if reason is None:
                skips.append(Skip(watch.id, delta.store_item_id, skip_reason))
                continue

            current = best.get(key)
            if current is None:
                best[key] = (watch, delta, reason)
                continue

            # Уже есть кандидат по этой паре — оставляем более выгодный,
            # чтобы у пользователя не набралось четыре пуша про зоны Bravo.
            winner = _better(current[1], delta)
            if winner is delta:
                best[key] = (watch, delta, reason)
                skips.append(
                    Skip(watch.id, current[1].store_item_id, "superseded_by_better")
                )
            else:
                skips.append(Skip(watch.id, delta.store_item_id, "superseded_by_better"))

    drafts = [
        Draft(
            watch=w,
            delta=d,
            reason=r,
            send_after=send_after(now, w.timezone),
        )
        for w, d, r in best.values()
    ]
    drafts.sort(key=lambda x: (x.watch.user_id, x.watch.product_id))
    return drafts, skips

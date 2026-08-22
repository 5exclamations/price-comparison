"""Воркер на подготовленном наборе дельт даёт ровно ожидаемый список.

Здесь нет ни базы, ни сети: plan() — чистая функция, и набор дельт из теста
проходит ровно тот же код, что и боевой прогон.
"""
from datetime import datetime, timedelta, timezone

import pytest

from notify.rules import MIN_DROP, Delta, Watch, evaluate, matches, plan

# Полдень по Баку — вне тихих часов, чтобы они не мешали проверять правила.
NOON = datetime(2026, 8, 17, 8, 0, tzinfo=timezone.utc)   # 12:00 Asia/Baku


def delta(
    store_item_id=1, product_id=100, price=1000, prev_price=2000, *,
    chain_id=2, chain_code="bravo", chain_name="Bravo",
    store_id=3, cluster="B", available=True, inflated=False,
    market_price=None, real_discount=None, old_price=None, name="Товар",
) -> Delta:
    return Delta(
        store_item_id=store_item_id, product_id=product_id,
        chain_id=chain_id, chain_code=chain_code, chain_name=chain_name,
        store_id=store_id, price_cluster=cluster, product_name=name,
        price=price, prev_price=prev_price, old_price=old_price,
        available=available, observed_at=NOON,
        market_price=market_price, real_discount=real_discount, inflated=inflated,
    )


def watch(id=1, user_id=10, product_id=100, store_id=None, target=None,
          lang="ru", tz="Asia/Baku", chain_id=None, model=None) -> Watch:
    return Watch(
        id=id, user_id=user_id, product_id=product_id, store_id=store_id,
        target_price_minor=target, lang=lang, timezone=tz,
        store_chain_id=chain_id, store_price_model=model,
    )


# ---------- отдельные правила ----------


def test_big_drop_sends():
    reason, skip = evaluate(watch(), delta(price=1000, prev_price=2000))
    assert (reason, skip) == ("price_drop", None)


def test_exactly_five_percent_sends():
    """Порог включающий: «упала минимум на 5%»."""
    reason, _ = evaluate(watch(), delta(price=950, prev_price=1000))
    assert pytest.approx(delta(price=950, prev_price=1000).drop_pct) == MIN_DROP
    assert reason == "price_drop"


def test_small_drop_skipped():
    reason, skip = evaluate(watch(), delta(price=960, prev_price=1000))
    assert reason is None and skip == "below_threshold"


def test_price_rise_skipped():
    reason, skip = evaluate(watch(), delta(price=1200, prev_price=1000))
    assert reason is None and skip == "no_drop"


def test_target_hit_sends_even_on_small_drop():
    """Цель важнее порога: «упала на 5% ИЛИ ниже target»."""
    reason, _ = evaluate(watch(target=990), delta(price=980, prev_price=1000))
    assert reason == "target_hit"


def test_target_not_hit_and_small_drop_skipped():
    reason, skip = evaluate(watch(target=500), delta(price=980, prev_price=1000))
    assert reason is None and skip == "below_threshold"


def test_target_never_fires_on_a_rise():
    """Цена ниже цели, но выросла — «цена упала» было бы враньём."""
    reason, skip = evaluate(watch(target=5000), delta(price=1200, prev_price=1000))
    assert reason is None and skip == "no_drop"


def test_inflated_never_sent():
    """Главное правило продукта: накрученную скидку не шлём вовсе.

    Падение здесь огромное — 60%, — но deal_honesty говорит, что заявленная
    скидка глубже настоящей больше чем на 15 п.п. Смысл продукта в том, чтобы
    не врать, а не в том, чтобы слать побольше пушей.
    """
    reason, skip = evaluate(
        watch(), delta(price=1000, prev_price=2500, inflated=True)
    )
    assert reason is None and skip == "inflated"


def test_inflated_beats_target_too():
    reason, skip = evaluate(
        watch(target=99999), delta(price=1000, prev_price=2500, inflated=True)
    )
    assert reason is None and skip == "inflated"


def test_unavailable_skipped():
    reason, skip = evaluate(watch(), delta(price=100, prev_price=1000,
                                           available=False))
    assert reason is None and skip == "unavailable"


# ---------- сопоставление подписки и позиции ----------


def test_watch_without_store_matches_any_chain():
    assert matches(watch(store_id=None), delta(chain_id=2, store_id=3))
    assert matches(watch(store_id=None), delta(chain_id=1, store_id=None))


def test_watch_with_store_matches_only_that_store():
    w = watch(store_id=3, chain_id=2, model="per_cluster")
    assert matches(w, delta(store_id=3, chain_id=2))
    assert not matches(w, delta(store_id=4, chain_id=2))


def test_watch_on_single_price_chain_matches_whole_chain():
    """Подписка на филиал сети с единой ценой = подписка на всю сеть.

    У Araz прайс один на все точки, а позиции Bazarstore вообще лежат без
    store_id. Требовать точного совпадения значило бы никогда не находить их.
    """
    w = watch(store_id=5, chain_id=3, model="single")
    assert matches(w, delta(store_id=6, chain_id=3))
    assert matches(w, delta(store_id=None, chain_id=3))
    assert not matches(w, delta(store_id=None, chain_id=1))


def test_other_product_never_matches():
    assert not matches(watch(product_id=100), delta(product_id=101))


# ---------- план целиком ----------


def test_plan_returns_exactly_expected():
    """Набор из шести дельт: пройти должны ровно две."""
    deltas = [
        delta(store_item_id=1, product_id=100, price=1000, prev_price=2000),   # -50%, ок
        delta(store_item_id=2, product_id=101, price=970, prev_price=1000),    # -3%, мимо
        delta(store_item_id=3, product_id=102, price=500, prev_price=2000,
              inflated=True),                                                  # накрутка
        delta(store_item_id=4, product_id=103, price=1100, prev_price=1000),   # рост
        delta(store_item_id=5, product_id=104, price=980, prev_price=1000),    # -2%, но цель
        delta(store_item_id=6, product_id=105, price=100, prev_price=1000,
              available=False),                                                # нет в наличии
    ]
    watches = [
        watch(id=1, user_id=10, product_id=100),
        watch(id=2, user_id=10, product_id=101),
        watch(id=3, user_id=10, product_id=102),
        watch(id=4, user_id=10, product_id=103),
        watch(id=5, user_id=10, product_id=104, target=990),
        watch(id=6, user_id=10, product_id=105),
    ]

    drafts, skips = plan(deltas, watches, recently_notified=set(), now=NOON)

    assert [(d.watch.id, d.delta.product_id, d.reason) for d in drafts] == [
        (1, 100, "price_drop"),
        (5, 104, "target_hit"),
    ]
    assert {s.reason for s in skips} == {
        "below_threshold", "inflated", "no_drop", "unavailable"
    }


def test_four_bravo_zones_give_one_notification():
    """Один товар в четырёх зонах Bravo — один пуш, а не четыре.

    Берётся самая выгодная зона.
    """
    deltas = [
        delta(store_item_id=11, store_id=1, cluster="A1", price=900, prev_price=2000),
        delta(store_item_id=12, store_id=2, cluster="A2", price=850, prev_price=2000),
        delta(store_item_id=13, store_id=3, cluster="B",  price=700, prev_price=2000),
        delta(store_item_id=14, store_id=4, cluster="C",  price=880, prev_price=2000),
    ]
    drafts, skips = plan(deltas, [watch(store_id=None)], set(), NOON)

    assert len(drafts) == 1
    assert drafts[0].delta.price == 700
    assert drafts[0].delta.price_cluster == "B"
    assert sum(1 for s in skips if s.reason == "superseded_by_better") == 3


def test_dedup_one_push_per_user_per_product_per_day():
    """Кому уже слали сегодня по этому товару — не шлём второй раз."""
    deltas = [delta(price=100, prev_price=2000)]
    ws = [watch(id=1, user_id=10, product_id=100)]

    drafts, _ = plan(deltas, ws, recently_notified=set(), now=NOON)
    assert len(drafts) == 1

    drafts, skips = plan(deltas, ws, recently_notified={(10, 100)}, now=NOON)
    assert drafts == []
    assert [s.reason for s in skips] == ["already_sent_today"]


def test_dedup_is_per_user_not_global():
    deltas = [delta(price=100, prev_price=2000)]
    ws = [
        watch(id=1, user_id=10, product_id=100),
        watch(id=2, user_id=20, product_id=100),
    ]
    drafts, _ = plan(deltas, ws, recently_notified={(10, 100)}, now=NOON)
    assert [d.watch.user_id for d in drafts] == [20]


def test_dedup_is_per_product_not_per_user():
    deltas = [
        delta(store_item_id=1, product_id=100, price=100, prev_price=2000),
        delta(store_item_id=2, product_id=200, price=100, prev_price=2000),
    ]
    ws = [
        watch(id=1, user_id=10, product_id=100),
        watch(id=2, user_id=10, product_id=200),
    ]
    drafts, _ = plan(deltas, ws, recently_notified={(10, 100)}, now=NOON)
    assert [d.delta.product_id for d in drafts] == [200]


def test_two_users_same_product_both_get_it():
    deltas = [delta(price=100, prev_price=2000)]
    ws = [
        watch(id=1, user_id=10, product_id=100),
        watch(id=2, user_id=20, product_id=100),
    ]
    drafts, _ = plan(deltas, ws, set(), NOON)
    assert sorted(d.watch.user_id for d in drafts) == [10, 20]


def test_empty_inputs():
    assert plan([], [], set(), NOON) == ([], [])
    assert plan([delta()], [], set(), NOON) == ([], [])
    assert plan([], [watch()], set(), NOON) == ([], [])


def test_result_is_deterministic():
    """Один и тот же вход обязан давать один и тот же порядок."""
    deltas = [
        delta(store_item_id=i, store_id=i, price=900, prev_price=2000)
        for i in range(1, 5)
    ]
    first, _ = plan(deltas, [watch()], set(), NOON)
    second, _ = plan(list(reversed(deltas)), [watch()], set(), NOON)
    assert [d.delta.store_item_id for d in first] == [
        d.delta.store_item_id for d in second
    ]


def test_send_after_is_immediate_outside_quiet_hours():
    drafts, _ = plan([delta(price=100, prev_price=2000)], [watch()], set(), NOON)
    assert drafts[0].send_after == NOON


def test_send_after_waits_for_morning_at_night():
    # 02:00 по Баку = 22:00 UTC предыдущего дня
    night = datetime(2026, 8, 16, 22, 0, tzinfo=timezone.utc)
    drafts, _ = plan([delta(price=100, prev_price=2000)], [watch()], set(), night)
    assert drafts[0].send_after > night
    assert drafts[0].send_after - night == timedelta(hours=6)   # до 08:00 Баку

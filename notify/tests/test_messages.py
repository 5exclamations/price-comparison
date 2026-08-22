"""Текст уведомления: коротко, с числами, на языке пользователя."""
from datetime import datetime, timezone

from notify.messages import format_money, render
from notify.rules import Delta, Watch

NOW = datetime(2026, 8, 17, 8, 0, tzinfo=timezone.utc)

PAPIA = Delta(
    store_item_id=1, product_id=100, chain_id=2,
    chain_code="bravo", chain_name="Bravo", store_id=3, price_cluster="B",
    product_name="Papia tualet kağızı 32 li",
    price=1399, prev_price=3469, old_price=3469, available=True,
    observed_at=NOW, market_price=3500, real_discount=0.60, inflated=False,
)


def w(lang: str) -> Watch:
    return Watch(id=1, user_id=1, product_id=100, store_id=None,
                 target_price_minor=None, lang=lang)


def test_money_format():
    assert format_money(1399) == "13.99"
    assert format_money(3469) == "34.69"
    assert format_money(5) == "0.05"
    assert format_money(100) == "1.00"
    assert format_money(0) == "0.00"


def test_russian_matches_the_brief():
    """Образец из задания:

    «Papia tualet kağızı 32 li — 13.99 ₼ в Bravo вместо 34.69.
     Дешевле рынка на 60%.»
    """
    body = render(w("ru"), PAPIA, "price_drop").body
    assert body.startswith("Papia tualet kağızı 32 li — 13.99 ₼ в Bravo вместо 34.69.")
    assert "Дешевле рынка на 60%." in body


def test_all_languages_carry_the_numbers():
    for lang in ("az", "ru", "en"):
        body = render(w(lang), PAPIA, "price_drop").body
        assert "13.99" in body
        assert "34.69" in body
        assert "60" in body
        assert "Bravo" in body
        assert "Papia tualet kağızı 32 li" in body


def test_azerbaijani_is_not_russian():
    az = render(w("az"), PAPIA, "price_drop").body
    ru = render(w("ru"), PAPIA, "price_drop").body
    assert az != ru
    assert "əvəzinə" in az
    assert "Bazardan" in az


def test_unknown_language_falls_back_to_azerbaijani():
    body = render(w("fr"), PAPIA, "price_drop").body
    assert body == render(w("az"), PAPIA, "price_drop").body


def test_bravo_zone_is_named():
    """Цена Bravo без указания зоны бессмысленна: у сети их четыре."""
    body = render(w("ru"), PAPIA, "price_drop").body
    assert "зона B" in body


def test_single_price_chain_has_no_zone_noise():
    """У сетей с единой ценой price_cluster = 'ALL' — про зону молчим."""
    araz = Delta(
        store_item_id=2, product_id=100, chain_id=3, chain_code="araz",
        chain_name="Araz", store_id=5, price_cluster="ALL",
        product_name="Çay", price=300, prev_price=400, old_price=None,
        available=True, observed_at=NOW,
    )
    body = render(w("ru"), araz, "price_drop").body
    assert "зона" not in body
    assert "ALL" not in body


def test_market_line_absent_without_market_data():
    """Без эталона обещать «дешевле рынка» нельзя — просто молчим."""
    no_market = Delta(
        store_item_id=3, product_id=100, chain_id=3, chain_code="araz",
        chain_name="Araz", store_id=None, price_cluster=None,
        product_name="Çay", price=300, prev_price=400, old_price=None,
        available=True, observed_at=NOW, market_price=None, real_discount=None,
    )
    body = render(w("ru"), no_market, "price_drop").body
    assert "рынка" not in body
    assert "3.00" in body and "4.00" in body


def test_market_line_absent_when_not_cheaper_than_market():
    """Цена упала, но всё ещё выше рынка — хвастаться нечем."""
    worse = Delta(
        store_item_id=4, product_id=100, chain_id=3, chain_code="araz",
        chain_name="Araz", store_id=None, price_cluster=None,
        product_name="Çay", price=300, prev_price=400, old_price=None,
        available=True, observed_at=NOW, market_price=250, real_discount=-0.2,
    )
    assert "рынка" not in render(w("ru"), worse, "price_drop").body


def test_target_hit_is_mentioned():
    body = render(w("ru"), PAPIA, "target_hit").body
    assert "Ниже вашей цели." in body
    body_az = render(w("az"), PAPIA, "target_hit").body
    assert "İstədiyiniz" in body_az


def test_prev_price_is_what_we_saw_not_the_shelf_tag():
    """«Вместо X» — это наше прошлое наблюдение, а не заявленная старая цена.

    Ценник врёт у 4.6% акций; наши наблюдения нет.
    """
    lying_tag = Delta(
        store_item_id=5, product_id=100, chain_id=2, chain_code="bravo",
        chain_name="Bravo", store_id=3, price_cluster="B",
        product_name="Товар", price=1000, prev_price=1500,
        old_price=9999,                     # сеть заявляет «было 99.99»
        available=True, observed_at=NOW,
    )
    body = render(w("ru"), lying_tag, "price_drop").body
    assert "15.00" in body
    assert "99.99" not in body


def test_title_is_short():
    for lang in ("az", "ru", "en"):
        assert len(render(w(lang), PAPIA, "price_drop").title) <= 20

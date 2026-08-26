"""GET /v1/deals."""
import pytest

from .conftest import BRAVO_STORE_B, MISSING_STORE

pytestmark = pytest.mark.asyncio


async def test_deals(client):
    r = await client.get("/v1/deals", params={"limit": 20})
    assert r.status_code == 200
    items = r.json()["items"]
    assert items, "на этом дампе акции есть, лента пустой быть не должна"

    for d in items:
        # деньги целыми гяпиками
        for field in ("price_minor", "old_price_minor", "market_price_minor"):
            assert isinstance(d[field], int)
        assert d["observed_at"]
        assert d["reference_chains"] >= 1


async def test_sorted_by_real_discount(client):
    """Лента отсортирована по настоящей скидке, а не по заявленной."""
    r = await client.get("/v1/deals", params={"limit": 50})
    reals = [d["real_discount"] for d in r.json()["items"]]
    assert reals == sorted(reals, reverse=True)


async def test_real_discount_math(client):
    """Настоящая скидка считается от рынка, заявленная — от ценника сети."""
    r = await client.get("/v1/deals", params={"limit": 50})
    for d in r.json()["items"]:
        claimed = (d["old_price_minor"] - d["price_minor"]) / d["old_price_minor"]
        real = (d["market_price_minor"] - d["price_minor"]) / d["market_price_minor"]
        assert claimed == pytest.approx(d["claimed_discount"], abs=1e-6)
        # market_price_minor округлён до гяпика, поэтому допуск шире
        assert real == pytest.approx(d["real_discount"], abs=1e-3)
        assert d["inflation"] == pytest.approx(
            d["claimed_discount"] - d["real_discount"], abs=1e-6
        )


async def test_inflated_flag(client):
    """inflated поднимается ровно тогда, когда накрутка больше 15 п.п."""
    r = await client.get("/v1/deals", params={"limit": 100})
    for d in r.json()["items"]:
        assert d["inflated"] == (d["inflation"] > 0.15)


async def test_inflated_deals_exist(client):
    """В дампе 136 накрученных акций из 2935 — обязаны найтись и быть помечены.

    Идём курсором по ленте, а не смотрим только первую страницу: накрутка чаще
    всего у неглубоких настоящих скидок, то есть в хвосте сортировки.
    """
    seen_inflated, cursor, pages = 0, None, 0
    while pages < 30:
        params = {"limit": 100, "min_discount": -1.0}
        if cursor:
            params["cursor"] = cursor
        body = (await client.get("/v1/deals", params=params)).json()
        seen_inflated += sum(1 for d in body["items"] if d["inflated"])
        if not body["has_more"]:
            break
        cursor, pages = body["next_cursor"], pages + 1

    assert seen_inflated > 0, "ни одной накрученной акции не помечено"


async def test_min_discount_filter(client):
    r = await client.get("/v1/deals", params={"limit": 50, "min_discount": 0.30})
    assert r.status_code == 200
    for d in r.json()["items"]:
        assert d["real_discount"] >= 0.30


async def test_min_discount_empty_result(client):
    """Недостижимый порог — пустой список, а не ошибка."""
    r = await client.get("/v1/deals", params={"min_discount": 0.999})
    assert r.status_code == 200
    assert r.json()["items"] == []
    assert r.json()["has_more"] is False


async def test_category_filter_is_empty_on_this_dump(client):
    """products.category в дампе пуста на 100%, фильтр обязан честно вернуть пусто."""
    r = await client.get("/v1/deals", params={"category": "süd"})
    assert r.status_code == 200
    assert r.json()["items"] == []


async def test_missing_store_id_is_404(client):
    r = await client.get("/v1/deals", params={"store_id": MISSING_STORE})
    assert r.status_code == 404


async def test_store_filter_keeps_only_its_zone(client):
    """При выбранном магазине Bravo в ленте остаётся только его зона."""
    r = await client.get("/v1/deals", params={"limit": 100, "store_id": BRAVO_STORE_B})
    assert r.status_code == 200
    for d in r.json()["items"]:
        if d["chain_code"] == "bravo":
            assert d["store_id"] == BRAVO_STORE_B
            assert d["price_cluster"] == "B"


async def test_cursor_pagination_no_overlap(client):
    first = await client.get("/v1/deals", params={"limit": 10})
    body1 = first.json()
    assert body1["has_more"] is True

    second = await client.get(
        "/v1/deals", params={"limit": 10, "cursor": body1["next_cursor"]}
    )
    # Сверяем по deal_id, а не по product_id: один товар законно даёт несколько
    # акций — по одной на сеть и ценовую зону, — и пересечение по product_id
    # между страницами ничего не сказало бы о правильности курсора.
    ids1 = {d["deal_id"] for d in body1["items"]}
    ids2 = {d["deal_id"] for d in second.json()["items"]}
    assert ids1 & ids2 == set()

    # вторая страница не «выше» первой по скидке
    assert min(d["real_discount"] for d in body1["items"]) >= max(
        d["real_discount"] for d in second.json()["items"]
    )


# ---------- фильтр «только мои сети» ----------


async def test_chains_filter(client):
    """Фильтр на сервере, а не в клиенте.

    При курсорной пагинации клиентский фильтр выбросил бы половину страницы,
    и человек увидел бы три акции там, где их двадцать.
    """
    r = await client.get("/v1/deals", params={"limit": 50, "chains": "araz"})
    assert r.status_code == 200
    codes = {d["chain_code"] for d in r.json()["items"]}
    assert codes <= {"araz"}
    assert codes, "по Araz акции в дампе есть"


async def test_chains_filter_multiple(client):
    r = await client.get(
        "/v1/deals", params={"limit": 50, "chains": "araz,spar"}
    )
    assert r.status_code == 200
    assert {d["chain_code"] for d in r.json()["items"]} <= {"araz", "spar"}


async def test_chains_filter_ignores_whitespace_and_order(client):
    a = await client.get("/v1/deals", params={"limit": 20, "chains": "araz,spar"})
    b = await client.get("/v1/deals", params={"limit": 20, "chains": " spar , araz "})
    assert [d["deal_id"] for d in a.json()["items"]] == [
        d["deal_id"] for d in b.json()["items"]
    ]


async def test_unknown_chain_gives_empty_not_error(client):
    r = await client.get("/v1/deals", params={"chains": "nosuchchain"})
    assert r.status_code == 200
    assert r.json()["items"] == []


async def test_empty_chains_param_means_all(client):
    everything = await client.get("/v1/deals", params={"limit": 10})
    empty = await client.get("/v1/deals", params={"limit": 10, "chains": ""})
    assert [d["deal_id"] for d in everything.json()["items"]] == [
        d["deal_id"] for d in empty.json()["items"]
    ]


async def test_chains_filter_keeps_real_discount_order(client):
    r = await client.get("/v1/deals", params={"limit": 50, "chains": "araz"})
    reals = [d["real_discount"] for d in r.json()["items"]]
    assert reals == sorted(reals, reverse=True)


async def test_chains_filter_paginates(client):
    first = await client.get("/v1/deals", params={"limit": 5, "chains": "araz"})
    body = first.json()
    if not body["has_more"]:
        pytest.skip("на этом дампе одна страница")

    second = await client.get(
        "/v1/deals",
        params={"limit": 5, "chains": "araz", "cursor": body["next_cursor"]},
    )
    ids1 = {d["deal_id"] for d in body["items"]}
    ids2 = {d["deal_id"] for d in second.json()["items"]}
    assert ids1 & ids2 == set()
    assert {d["chain_code"] for d in second.json()["items"]} <= {"araz"}


async def test_chains_filter_in_cache_key(client):
    """Ответ по Araz не должен прийти из кеша ответа по всем сетям."""
    everything = await client.get("/v1/deals", params={"limit": 10})
    araz = await client.get("/v1/deals", params={"limit": 10, "chains": "araz"})
    assert everything.headers["x-cache"] == "miss"
    assert araz.headers["x-cache"] == "miss"


async def test_single_price_chain_not_duplicated_by_branch(client):
    """Сеть с единой ценой не должна повторяться по филиалам.

    У Araz две точки Wolt и один прайс. До схлопывания одна акция приходила
    в ленту дважды — как «тот же товар два раза», ровно та жалоба, с которой
    это и нашли. У Bravo (per_cluster) схлопывать нельзя: зоны дают разные
    цены, и это разные предложения.
    """
    r = await client.get("/v1/deals", params={"limit": 100})
    assert r.status_code == 200

    seen = set()
    for item in r.json()["items"]:
        # Ключ предложения: товар + сеть + ценовая зона. У сети с единой ценой
        # зона всегда одна, поэтому повтор ключа означает повтор филиала.
        key = (item["product_id"], item["chain_code"], item["price_cluster"])
        assert key not in seen, f"дубль по филиалу: {item['name']} / {item['chain_code']}"
        seen.add(key)


async def test_quarantined_not_in_feed(client):
    """Карантинную склейку не показываем никогда — правило из CLAUDE.md."""
    r = await client.get("/v1/deals", params={"limit": 50})
    for item in r.json()["items"]:
        card = await client.get(f"/v1/product/{item['product_id']}")
        assert card.status_code == 200

"""GET /v1/prices — цены для списка покупок."""
import pytest

from .conftest import BRAVO_STORE_B, PRODUCT_IN_5_CHAINS, PRODUCT_QUARANTINED

pytestmark = pytest.mark.asyncio


async def test_batch(client):
    """Один запрос вместо N: в магазине со слабой связью это и есть разница."""
    r = await client.get(
        "/v1/prices",
        params={"product_ids": f"{PRODUCT_IN_5_CHAINS},8983,12940"},
    )
    assert r.status_code == 200
    body = r.json()
    assert len(body["items"]) == 3
    assert body["missing"] == []

    for item in body["items"]:
        assert item["prices"], "у товара обязана быть хотя бы одна цена"
        for p in item["prices"]:
            assert isinstance(p["price_minor"], int)
            assert p["observed_at"]


async def test_prices_sorted_cheapest_first(client):
    r = await client.get(
        "/v1/prices", params={"product_ids": str(PRODUCT_IN_5_CHAINS)}
    )
    prices = [p["price_minor"] for p in r.json()["items"][0]["prices"]]
    assert prices == sorted(prices)


async def test_quarantined_goes_to_missing(client):
    """Карантинный товар не пропадает молча — он в missing.

    Клиенту важно отличать «нет цены» от «мы это потеряли»: в первом случае
    строку в списке надо оставить, во втором — предложить убрать.
    """
    r = await client.get(
        "/v1/prices",
        params={"product_ids": f"{PRODUCT_IN_5_CHAINS},{PRODUCT_QUARANTINED}"},
    )
    body = r.json()
    assert [i["product_id"] for i in body["items"]] == [PRODUCT_IN_5_CHAINS]
    assert body["missing"] == [PRODUCT_QUARANTINED]


async def test_unknown_product_goes_to_missing(client):
    r = await client.get("/v1/prices", params={"product_ids": "99999999"})
    assert r.status_code == 200
    assert r.json()["items"] == []
    assert r.json()["missing"] == [99999999]


async def test_bravo_needs_store_without_selection(client):
    """Без выбранного магазина цены Bravo помечены и в корзину не годятся."""
    r = await client.get(
        "/v1/prices", params={"product_ids": str(PRODUCT_IN_5_CHAINS)}
    )
    bravo = [
        p
        for p in r.json()["items"][0]["prices"]
        if p["chain_code"] == "bravo"
    ]
    assert len(bravo) == 4
    assert all(p["requires_store_selection"] for p in bravo)


async def test_bravo_single_zone_with_store(client):
    r = await client.get(
        "/v1/prices",
        params={
            "product_ids": str(PRODUCT_IN_5_CHAINS),
            "store_id": BRAVO_STORE_B,
        },
    )
    bravo = [
        p
        for p in r.json()["items"][0]["prices"]
        if p["chain_code"] == "bravo"
    ]
    assert len(bravo) == 1
    assert bravo[0]["price_cluster"] == "B"
    assert bravo[0]["requires_store_selection"] is False


async def test_duplicates_collapse(client):
    r = await client.get(
        "/v1/prices",
        params={"product_ids": f"{PRODUCT_IN_5_CHAINS},{PRODUCT_IN_5_CHAINS}"},
    )
    assert len(r.json()["items"]) == 1


async def test_empty_is_400(client):
    assert (await client.get("/v1/prices", params={"product_ids": ""})).status_code == 400


async def test_garbage_is_400(client):
    r = await client.get("/v1/prices", params={"product_ids": "abc"})
    assert r.status_code == 400


async def test_too_many_is_400(client):
    """Нельзя одним запросом попросить весь каталог."""
    ids = ",".join(str(i) for i in range(1, 300))
    r = await client.get("/v1/prices", params={"product_ids": ids})
    assert r.status_code == 400
    assert "200" in r.json()["detail"]


async def test_cache_key_includes_store(client):
    a = await client.get(
        "/v1/prices", params={"product_ids": str(PRODUCT_IN_5_CHAINS)}
    )
    b = await client.get(
        "/v1/prices",
        params={
            "product_ids": str(PRODUCT_IN_5_CHAINS),
            "store_id": BRAVO_STORE_B,
        },
    )
    assert a.headers["x-cache"] == "miss"
    assert b.headers["x-cache"] == "miss", "ответ для магазина пришёл из общего кеша"


async def test_order_of_ids_does_not_split_cache(client):
    a = await client.get("/v1/prices", params={"product_ids": "9150,8983"})
    b = await client.get("/v1/prices", params={"product_ids": "8983,9150"})
    assert a.headers["x-cache"] == "miss"
    assert b.headers["x-cache"] == "hit", "порядок id не должен плодить ключи"

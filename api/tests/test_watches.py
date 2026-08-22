"""POST /v1/devices, GET/POST/DELETE /v1/watches."""
import uuid

import pytest

from .conftest import BRAVO_STORE_B, MISSING_STORE, PRODUCT_IN_5_CHAINS, PRODUCT_QUARANTINED

pytestmark = pytest.mark.asyncio


def device() -> str:
    return f"test-{uuid.uuid4()}"


def headers(dev: str) -> dict[str, str]:
    return {"X-Device-Id": dev}


async def register(client, dev: str, lang: str = "ru"):
    return await client.post(
        "/v1/devices",
        headers=headers(dev),
        json={"token": f"fcm-{dev}", "platform": "android", "lang": lang},
    )


async def test_register_device(client):
    dev = device()
    r = await register(client, dev)
    assert r.status_code == 200
    assert r.json()["lang"] == "ru"
    assert r.json()["timezone"] == "Asia/Baku"


async def test_register_is_idempotent(client):
    """Приложение зовёт этот маршрут при каждом запуске — записи плодиться не должны."""
    dev = device()
    first = await register(client, dev, lang="ru")
    second = await register(client, dev, lang="az")

    assert first.json()["user_id"] == second.json()["user_id"]
    assert first.json()["device_token_id"] == second.json()["device_token_id"]
    assert second.json()["lang"] == "az"


async def test_device_id_header_required(client):
    r = await client.post(
        "/v1/devices", json={"token": "x" * 20, "platform": "ios"}
    )
    assert r.status_code == 422


async def test_watch_lifecycle(client):
    dev = device()
    await register(client, dev)

    created = await client.post(
        "/v1/watches",
        headers=headers(dev),
        json={"product_id": PRODUCT_IN_5_CHAINS, "target_price_minor": 300},
    )
    assert created.status_code == 201
    watch_id = created.json()["id"]
    assert created.json()["target_price_minor"] == 300

    listed = await client.get("/v1/watches", headers=headers(dev))
    assert listed.status_code == 200
    items = listed.json()["items"]
    assert [i["id"] for i in items] == [watch_id]
    assert items[0]["product_name"]
    # текущая цена приходит вместе со временем наблюдения
    assert items[0]["current_best_price_minor"] is not None
    assert items[0]["observed_at"]

    deleted = await client.delete(f"/v1/watches/{watch_id}", headers=headers(dev))
    assert deleted.status_code == 204

    assert (await client.get("/v1/watches", headers=headers(dev))).json()["items"] == []


async def test_duplicate_watch_does_not_create_second(client):
    """Ловушка NULL: при store_id IS NULL обычный UNIQUE дубли не ловит.

    Без индекса по COALESCE(store_id, 0) пользователь получал бы по два пуша.
    """
    dev = device()
    await register(client, dev)
    body = {"product_id": PRODUCT_IN_5_CHAINS}

    first = await client.post("/v1/watches", headers=headers(dev), json=body)
    second = await client.post("/v1/watches", headers=headers(dev), json=body)

    assert first.json()["id"] == second.json()["id"]
    assert len((await client.get("/v1/watches", headers=headers(dev))).json()["items"]) == 1


async def test_same_product_different_stores_are_separate(client):
    dev = device()
    await register(client, dev)

    a = await client.post(
        "/v1/watches", headers=headers(dev), json={"product_id": PRODUCT_IN_5_CHAINS}
    )
    b = await client.post(
        "/v1/watches",
        headers=headers(dev),
        json={"product_id": PRODUCT_IN_5_CHAINS, "store_id": BRAVO_STORE_B},
    )
    assert a.json()["id"] != b.json()["id"]


async def test_cannot_watch_quarantined_product(client):
    """На карантинную склейку нельзя даже подписаться.

    Мы не доверяем этой склейке, значит не сможем честно сказать, на что упала
    цена.
    """
    dev = device()
    await register(client, dev)
    r = await client.post(
        "/v1/watches", headers=headers(dev), json={"product_id": PRODUCT_QUARANTINED}
    )
    assert r.status_code == 404


async def test_missing_product_is_404(client):
    dev = device()
    await register(client, dev)
    r = await client.post(
        "/v1/watches", headers=headers(dev), json={"product_id": 99999999}
    )
    assert r.status_code == 404


async def test_missing_store_is_404(client):
    dev = device()
    await register(client, dev)
    r = await client.post(
        "/v1/watches",
        headers=headers(dev),
        json={"product_id": PRODUCT_IN_5_CHAINS, "store_id": MISSING_STORE},
    )
    assert r.status_code == 404


async def test_negative_target_rejected(client):
    dev = device()
    await register(client, dev)
    r = await client.post(
        "/v1/watches",
        headers=headers(dev),
        json={"product_id": PRODUCT_IN_5_CHAINS, "target_price_minor": -5},
    )
    assert r.status_code == 422


async def test_unknown_device_cannot_list(client):
    r = await client.get("/v1/watches", headers=headers(device()))
    assert r.status_code == 404


async def test_cannot_delete_someone_elses_watch(client):
    mine, theirs = device(), device()
    await register(client, mine)
    await register(client, theirs)

    created = await client.post(
        "/v1/watches", headers=headers(mine), json={"product_id": PRODUCT_IN_5_CHAINS}
    )
    watch_id = created.json()["id"]

    # чужой запрос получает 404, а не 403: по коду ответа нельзя перебором
    # узнать, какие подписки существуют у других
    r = await client.delete(f"/v1/watches/{watch_id}", headers=headers(theirs))
    assert r.status_code == 404

    still = await client.get("/v1/watches", headers=headers(mine))
    assert [i["id"] for i in still.json()["items"]] == [watch_id]


async def test_watches_are_not_cached(client):
    """Личные данные не должны попадать в общий кеш."""
    dev = device()
    await register(client, dev)
    r = await client.get("/v1/watches", headers=headers(dev))
    assert r.headers["cache-control"] == "private, no-store"


async def test_watch_list_is_per_device(client):
    a, b = device(), device()
    await register(client, a)
    await register(client, b)
    await client.post("/v1/watches", headers=headers(a),
                      json={"product_id": PRODUCT_IN_5_CHAINS})

    assert (await client.get("/v1/watches", headers=headers(b))).json()["items"] == []

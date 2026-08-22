"""GET /v1/product/{id} и /v1/product/{id}/history."""
import pytest

from .conftest import (
    ARAZ_STORE,
    BRAVO_STORE_B,
    BRAVO_STORE_C,
    MISSING_STORE,
    PRODUCT_IN_5_CHAINS,
    PRODUCT_QUARANTINED,
)

pytestmark = pytest.mark.asyncio


async def test_card(client):
    r = await client.get(f"/v1/product/{PRODUCT_IN_5_CHAINS}")
    assert r.status_code == 200
    body = r.json()

    assert body["product_id"] == PRODUCT_IN_5_CHAINS
    assert body["chains_count"] >= 2
    assert body["prices"], "карточка без цен бессмысленна"

    for p in body["prices"]:
        assert isinstance(p["price_minor"], int)
        # каждое число сопровождается временем наблюдения
        assert p["observed_at"]


async def test_quarantined_is_404(client):
    """Карантинный товар не показываем — для клиента он просто не существует."""
    r = await client.get(f"/v1/product/{PRODUCT_QUARANTINED}")
    assert r.status_code == 404


async def test_missing_product_is_404(client):
    r = await client.get("/v1/product/99999999")
    assert r.status_code == 404


async def test_missing_store_id_is_404(client):
    r = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": MISSING_STORE}
    )
    assert r.status_code == 404


async def test_bravo_all_zones_without_store(client):
    """Без магазина Bravo отдаёт все зоны и помечает их как требующие выбора."""
    r = await client.get(f"/v1/product/{PRODUCT_IN_5_CHAINS}")
    body = r.json()
    bravo = [p for p in body["prices"] if p["chain_code"] == "bravo"]

    assert len(bravo) == 4, "у Bravo четыре измеренные ценовые зоны"
    assert {p["price_cluster"] for p in bravo} == {"A1", "A2", "B", "C"}
    assert all(p["requires_store_selection"] for p in bravo)
    assert "bravo" in body["needs_store_selection"]
    assert body["best_price_chain"] != "bravo"


async def test_bravo_single_zone_with_store(client):
    """С выбранным магазином Bravo остаётся ровно его зона."""
    r = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": BRAVO_STORE_B}
    )
    body = r.json()
    bravo = [p for p in body["prices"] if p["chain_code"] == "bravo"]

    assert len(bravo) == 1
    assert bravo[0]["price_cluster"] == "B"
    assert bravo[0]["store_id"] == BRAVO_STORE_B
    assert bravo[0]["requires_store_selection"] is False
    assert body["needs_store_selection"] == []


async def test_different_bravo_zones_are_independent(client):
    """Зоны B и C — разные прайсы, а не одна цена с разными названиями."""
    b = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": BRAVO_STORE_B}
    )
    c = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": BRAVO_STORE_C}
    )
    zone_b = [p for p in b.json()["prices"] if p["chain_code"] == "bravo"][0]
    zone_c = [p for p in c.json()["prices"] if p["chain_code"] == "bravo"][0]
    assert zone_b["price_cluster"] == "B"
    assert zone_c["price_cluster"] == "C"


async def test_single_price_chain_collapsed(client):
    """Сеть с единой ценой представлена одной строкой, а не списком филиалов.

    У Araz в дампе две точки Wolt, но прайс один — показывать обе значило бы
    намекать, что выбор филиала влияет на цену.
    """
    r = await client.get(f"/v1/product/{PRODUCT_IN_5_CHAINS}")
    araz = [p for p in r.json()["prices"] if p["chain_code"] == "araz"]
    assert len(araz) <= 1


async def test_araz_store_does_not_hide_others(client):
    """Выбор магазина сети с единой ценой не должен ломать остальные сети."""
    r = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": ARAZ_STORE}
    )
    assert r.status_code == 200
    codes = {p["chain_code"] for p in r.json()["prices"]}
    assert len(codes) >= 2


# ---------- история ----------


async def test_history(client):
    r = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}/history", params={"days": 30}
    )
    assert r.status_code == 200
    body = r.json()
    assert body["product_id"] == PRODUCT_IN_5_CHAINS
    assert body["days"] == 30
    assert isinstance(body["points"], list)
    assert isinstance(body["events"], list)
    for p in body["points"]:
        assert isinstance(p["price_minor"], int)
        assert p["observed_at"]
    for e in body["events"]:
        assert e["kind"] in {
            "promo_started", "promo_ended", "price_up", "price_down",
            "availability_changed",
        }


async def test_history_quarantined_is_404(client):
    r = await client.get(f"/v1/product/{PRODUCT_QUARANTINED}/history")
    assert r.status_code == 404


async def test_history_days_validated(client):
    r = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}/history", params={"days": 0}
    )
    assert r.status_code == 422

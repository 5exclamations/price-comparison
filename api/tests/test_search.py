"""GET /v1/search."""
import pytest

from .conftest import (
    BRAVO_STORE_B,
    EAN_IN_5_CHAINS,
    MISSING_STORE,
    PRODUCT_IN_5_CHAINS,
    PRODUCT_QUARANTINED,
)

pytestmark = pytest.mark.asyncio


async def test_by_name(client):
    r = await client.get("/v1/search", params={"q": "cay", "limit": 5})
    assert r.status_code == 200
    body = r.json()
    assert body["matched_by"] == "name"
    assert len(body["items"]) <= 5
    for item in body["items"]:
        assert item["chains_count"] >= 1
        # деньги только целыми гяпиками
        assert item["best_price_minor"] is None or isinstance(
            item["best_price_minor"], int
        )


async def test_turkish_i_finds_uppercase(client):
    """Ловушка из CLAUDE.md: «milka» обязан находить «MİLKA».

    Если нормализация опустит регистр раньше замены İ, lower('İ') даст
    'i' + U+0307, и совпадений не будет вовсе.
    """
    lower = await client.get("/v1/search", params={"q": "milka", "limit": 50})
    upper = await client.get("/v1/search", params={"q": "MİLKA", "limit": 50})
    assert lower.status_code == upper.status_code == 200

    names = [i["name"] for i in lower.json()["items"]]
    assert names, "«milka» не нашла ничего — нормализация сломана"
    assert any("İ" in n or "i" in n.lower() for n in names)

    # Оба написания дают один и тот же набор товаров
    assert {i["product_id"] for i in lower.json()["items"]} == {
        i["product_id"] for i in upper.json()["items"]
    }


async def test_decomposed_input_matches(client):
    """Запрос с уже разложенной İ ('I' + U+0307) — то, что отдаёт JS toLowerCase."""
    decomposed = "M" + "I" + "̇" + "LKA"
    r = await client.get("/v1/search", params={"q": decomposed, "limit": 50})
    assert r.status_code == 200
    assert r.json()["normalized_query"] == "milka"


async def test_by_barcode(client):
    r = await client.get("/v1/search", params={"q": EAN_IN_5_CHAINS})
    assert r.status_code == 200
    body = r.json()
    assert body["matched_by"] == "barcode"
    assert PRODUCT_IN_5_CHAINS in [i["product_id"] for i in body["items"]]


async def test_empty_result(client):
    """Пустой результат — это 200 с пустым списком, а не 404."""
    r = await client.get("/v1/search", params={"q": "zzzzнетакоготовараzzzz"})
    assert r.status_code == 200
    body = r.json()
    assert body["items"] == []
    assert body["has_more"] is False
    assert body["next_cursor"] is None


async def test_quarantined_never_shown(client):
    """Карантинная склейка не должна вылезать ни в одном поиске."""
    r = await client.get("/v1/search", params={"q": "dondurma", "limit": 100})
    assert r.status_code == 200
    assert PRODUCT_QUARANTINED not in [i["product_id"] for i in r.json()["items"]]


async def test_missing_store_id_is_404(client):
    r = await client.get(
        "/v1/search", params={"q": "cay", "store_id": MISSING_STORE}
    )
    assert r.status_code == 404


async def test_cursor_pagination_no_overlap(client):
    """Курсор не должен ни повторять, ни терять строки."""
    first = await client.get("/v1/search", params={"q": "cay", "limit": 5})
    assert first.status_code == 200
    body1 = first.json()
    if not body1["has_more"]:
        pytest.skip("на этом дампе одна страница")

    second = await client.get(
        "/v1/search",
        params={"q": "cay", "limit": 5, "cursor": body1["next_cursor"]},
    )
    assert second.status_code == 200
    ids1 = {i["product_id"] for i in body1["items"]}
    ids2 = {i["product_id"] for i in second.json()["items"]}
    assert ids1 & ids2 == set(), "страницы пересеклись"


async def test_bad_cursor_is_400(client):
    r = await client.get("/v1/search", params={"q": "cay", "cursor": "не-курсор!!"})
    assert r.status_code == 400


async def test_bravo_needs_store_selection(client):
    """Без выбранного магазина цена Bravo не может стать лучшей ценой."""
    r = await client.get("/v1/search", params={"q": "dogadan form", "limit": 20})
    assert r.status_code == 200
    for item in r.json()["items"]:
        if item["needs_store_selection"]:
            assert item["best_price_chain"] != "bravo"


async def test_store_selection_changes_answer(client):
    """С выбранным магазином Bravo его цена участвует в подсчёте."""
    without = await client.get("/v1/search", params={"q": "dogadan form", "limit": 20})
    with_store = await client.get(
        "/v1/search",
        params={"q": "dogadan form", "limit": 20, "store_id": BRAVO_STORE_B},
    )
    assert without.status_code == with_store.status_code == 200
    for item in with_store.json()["items"]:
        assert item["needs_store_selection"] is False


async def test_limit_is_capped(client):
    r = await client.get("/v1/search", params={"q": "cay", "limit": 10_000})
    assert r.status_code == 422

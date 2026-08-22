"""Кеш, ETag, Cache-Control, нормализация и сборка OpenAPI."""
import pytest
from sqlalchemy import text

from api.db import engine
from api.normalize import normalize

from .conftest import BRAVO_STORE_B, BRAVO_STORE_C, PRODUCT_IN_5_CHAINS

pytestmark = pytest.mark.asyncio


# ---------- нормализация ----------

CASES = [
    "MİLKA",
    "milka",
    "M" + "I" + "̇" + "LKA",          # разложенная İ — то, что даёт JS toLowerCase
    "Çay Ətirli",
    "ŞƏKƏR TOZU 1 KQ",
    "ЩЕКОЛАД",                        # кириллица вперемешку с латиницей
    "Pomidor Çəhrayı",
    "GÜLLÜ ĞĞ ıI",
    "",
    "  пробелы  ",
]


async def test_python_normalize_matches_sql():
    """Python и SQL обязаны нормализовать одинаково.

    Индекс построен по SQL-выражению qiymet_norm(name). Если Python разойдётся
    с ним хоть на одном символе, поиск начнёт молча терять товары — без ошибок
    и без единого признака в логах.
    """
    async with engine().connect() as conn:
        for s in CASES:
            sql_value = (
                await conn.execute(text("SELECT qiymet_norm(:s)"), {"s": s})
            ).scalar()
            assert normalize(s) == (sql_value or ""), f"разошлись на {s!r}"


async def test_normalize_is_idempotent():
    """API нормализует запрос у себя, а SQL применяет функцию ещё раз."""
    for s in CASES:
        assert normalize(normalize(s)) == normalize(s)


async def test_turkish_i_rule():
    """İ обязана стать 'i', а не 'i' + комбинирующая точка."""
    assert normalize("İ") == "i"
    assert normalize("MİLKA") == "milka"
    assert "̇" not in normalize("İstanbul")


# ---------- ETag ----------


async def test_etag_and_cache_control(client):
    r = await client.get("/v1/stores")
    assert r.status_code == 200
    assert r.headers["etag"]
    assert r.headers["cache-control"] == "public, max-age=300"


async def test_if_none_match_gives_304(client):
    first = await client.get("/v1/stores")
    etag = first.headers["etag"]

    second = await client.get("/v1/stores", headers={"If-None-Match": etag})
    assert second.status_code == 304
    assert second.content == b""


async def test_etag_present_on_every_get(client):
    """Заголовки ставятся middleware, а не руками на каждом маршруте."""
    for url, params in [
        ("/v1/search", {"q": "cay"}),
        (f"/v1/product/{PRODUCT_IN_5_CHAINS}", {}),
        (f"/v1/product/{PRODUCT_IN_5_CHAINS}/history", {}),
        ("/v1/deals", {}),
        ("/v1/stores", {}),
        ("/v1/health", {}),
    ]:
        r = await client.get(url, params=params)
        assert r.status_code == 200, url
        assert "etag" in r.headers, url
        assert "cache-control" in r.headers, url


# ---------- кеш ----------


async def test_cache_hit_on_second_call(client):
    first = await client.get("/v1/deals", params={"limit": 5})
    second = await client.get("/v1/deals", params={"limit": 5})
    assert first.headers["x-cache"] == "miss"
    assert second.headers["x-cache"] == "hit"
    assert first.json() == second.json()


async def test_cache_key_includes_store_id(client):
    """Ключ обязан включать store_id.

    Иначе клиент, выбравший зону C, получил бы ответ, посчитанный для зоны B.
    У Bravo это четыре разных прайса, так что вопрос корректности, а не скорости.
    """
    b = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": BRAVO_STORE_B}
    )
    c = await client.get(
        f"/v1/product/{PRODUCT_IN_5_CHAINS}", params={"store_id": BRAVO_STORE_C}
    )
    assert b.headers["x-cache"] == "miss"
    assert c.headers["x-cache"] == "miss", "ответ зоны C пришёл из кеша зоны B"

    zone_b = [p for p in b.json()["prices"] if p["chain_code"] == "bravo"][0]
    zone_c = [p for p in c.json()["prices"] if p["chain_code"] == "bravo"][0]
    assert zone_b["price_cluster"] == "B"
    assert zone_c["price_cluster"] == "C"


async def test_cache_key_ignores_absent_params(client):
    """?limit=20 и ?limit=20&cursor= — это один и тот же запрос."""
    first = await client.get("/v1/deals", params={"limit": 20})
    second = await client.get("/v1/deals", params={"limit": 20, "cursor": ""})
    assert first.headers["x-cache"] == "miss"
    assert second.headers["x-cache"] == "hit"


# ---------- OpenAPI ----------


async def test_openapi_builds(client):
    r = await client.get("/openapi.json")
    assert r.status_code == 200
    schema = r.json()

    assert schema["openapi"].startswith("3.")
    paths = set(schema["paths"])
    assert paths == {
        "/v1/search",
        "/v1/product/{product_id}",
        "/v1/product/{product_id}/history",
        "/v1/deals",
        "/v1/stores",
        "/v1/health",
        "/v1/devices",
        "/v1/watches",
        "/v1/watches/{watch_id}",
        "/v1/categories",
        "/v1/prices",
        "/v1/receipts",
        "/v1/receipts/{receipt_id}",
        "/v1/consents",
        "/v1/consents/receipts/text",
        "/v1/points",
    }


async def test_money_fields_are_integers_in_schema(client):
    """Под Flutter генерятся модели — деньги обязаны быть int, а не number."""
    schema = (await client.get("/openapi.json")).json()
    checked = 0
    for name, model in schema["components"]["schemas"].items():
        for field, spec in model.get("properties", {}).items():
            if not field.endswith("_minor"):
                continue
            checked += 1
            types = {spec.get("type")} | {
                v.get("type") for v in spec.get("anyOf", [])
            }
            assert "integer" in types, f"{name}.{field} не целое: {spec}"
            assert "number" not in types, f"{name}.{field} допускает float"
    assert checked >= 6, "денежных полей в схеме подозрительно мало"

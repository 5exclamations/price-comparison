"""GET /v1/categories."""
import pytest

pytestmark = pytest.mark.asyncio


async def test_categories(client):
    r = await client.get("/v1/categories")
    assert r.status_code == 200
    assert "items" in r.json()


async def test_empty_on_this_dump(client):
    """products.category пуста на 100% (0 из 36 214) — список обязан быть пуст.

    Клиент по пустому списку прячет фильтр целиком: ряд чипов, ни один из
    которых ничего не отфильтрует, читается как поломка.
    """
    r = await client.get("/v1/categories")
    assert r.json()["items"] == []


async def test_has_etag_and_cache(client):
    r = await client.get("/v1/categories")
    assert "etag" in r.headers
    assert r.headers["cache-control"] == "public, max-age=300"
    second = await client.get("/v1/categories")
    assert second.headers["x-cache"] == "hit"

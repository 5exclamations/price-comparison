"""GET /v1/categories."""
import pytest

pytestmark = pytest.mark.asyncio


async def test_categories(client):
    r = await client.get("/v1/categories")
    assert r.status_code == 200
    assert "items" in r.json()


async def test_only_categories_with_deals(client):
    """В списке только разделы, где акции ЕСТЬ.

    Раньше здесь стояло `items == []`: products.category была пуста на 100%,
    потому что пайплайн категорию не собирал, хотя Wolt её отдаёт. Теперь
    собирает, и проверять надо не пустоту, а обещание эндпоинта — раздел без
    единой акции в фильтр попадать не должен. Клиент по пустому списку прячет
    фильтр целиком: ряд чипов, ни один из которых ничего не отфильтрует,
    читается как поломка.
    """
    r = await client.get("/v1/categories")
    for item in r.json()["items"]:
        assert item["deals_count"] > 0
        assert item["code"]


async def test_has_etag_and_cache(client):
    r = await client.get("/v1/categories")
    assert "etag" in r.headers
    assert r.headers["cache-control"] == "public, max-age=300"
    second = await client.get("/v1/categories")
    assert second.headers["x-cache"] == "hit"

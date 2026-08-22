"""Проверка рабочего класса RedisCache, а не тестовой обёртки.

Остальные тесты подставляют свой бэкенд, поэтому код api.cache.RedisCache в них
не исполняется вовсе. Здесь он берётся как есть, а подменяется только фабрика
соединения redis.asyncio.from_url — на fakeredis. Так проверяется настоящий
путь: параметр ex у SET, декодирование ответов, aclose().

Полноценный Redis для этого не нужен, но перед выкатом стоит прогнать те же
проверки против живого сервера: QIYMET_REDIS_URL=redis://localhost:6379/0
"""
import asyncio

import pytest

pytestmark = pytest.mark.asyncio


@pytest.fixture
def redis_cache(monkeypatch):
    import fakeredis.aioredis

    import api.cache as cache_mod

    def fake_from_url(url, **kw):
        return fakeredis.aioredis.FakeRedis(decode_responses=kw.get(
            "decode_responses", False))

    import redis.asyncio as aioredis

    monkeypatch.setattr(aioredis, "from_url", fake_from_url)
    return cache_mod.RedisCache("redis://localhost:6379/0")


async def test_set_get_roundtrip(redis_cache):
    await redis_cache.set("k", "значение с кириллицей", ttl=300)
    assert await redis_cache.get("k") == "значение с кириллицей"


async def test_missing_key_is_none(redis_cache):
    assert await redis_cache.get("нет-такого") is None


async def test_ttl_expires(redis_cache):
    """TTL действительно передаётся в Redis, а не игнорируется."""
    await redis_cache.set("k", "v", ttl=1)
    assert await redis_cache.get("k") == "v"
    await asyncio.sleep(1.1)
    assert await redis_cache.get("k") is None


async def test_clear(redis_cache):
    await redis_cache.set("a", "1", ttl=300)
    await redis_cache.clear()
    assert await redis_cache.get("a") is None


async def test_close(redis_cache):
    await redis_cache.set("a", "1", ttl=300)
    await redis_cache.close()


async def test_endpoint_works_through_redis_backend(client, redis_cache):
    """Полный путь эндпоинта через RedisCache: промах, затем попадание."""
    import api.cache as cache_mod

    cache_mod.set_cache(redis_cache)
    try:
        first = await client.get("/v1/stores")
        second = await client.get("/v1/stores")
        assert first.headers["x-cache"] == "miss"
        assert second.headers["x-cache"] == "hit"
        assert first.json() == second.json()
    finally:
        cache_mod.set_cache(None)

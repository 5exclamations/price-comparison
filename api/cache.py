"""Кеш ответов на 5 минут.

Ключ всегда включает store_id — иначе клиент, выбравший магазин Bravo в зоне C,
получит ответ, посчитанный для зоны A1. Это не оптимизация, а корректность:
у Bravo четыре разных прайса.

Бэкенда два. Настоящий — Redis. Если QIYMET_REDIS_URL пуст, работает словарь в
памяти процесса: этого хватает для тестов и одиночного локального запуска, но при
нескольких воркерах у каждого будет свой кеш. В проде Redis обязателен.
"""
import hashlib
import json
import time
from typing import Any

from .config import settings


def cache_key(endpoint: str, **params: Any) -> str:
    """Стабильный ключ по эндпоинту и параметрам.

    Параметры сортируются; None и пустые строки выбрасываются, чтобы
    ?limit=20 и ?limit=20&cursor= давали один ключ, а не два. Это верно, пока ни
    у одного параметра пустая строка не значит что-то своё, отличное от
    «не задан» — сейчас так и есть: q объявлен min_length=1, а пустой курсор
    decode_cursor() и так трактует как отсутствующий.
    """
    clean = {k: v for k, v in sorted(params.items()) if v is not None and v != ""}
    blob = json.dumps(clean, sort_keys=True, ensure_ascii=False, default=str)
    digest = hashlib.sha256(blob.encode("utf-8")).hexdigest()[:32]
    return f"{settings.cache_prefix}:{endpoint}:{digest}"


class MemoryCache:
    """Запасной бэкенд. Хранит (истекает_в, значение)."""

    def __init__(self) -> None:
        self._data: dict[str, tuple[float, str]] = {}

    async def get(self, key: str) -> str | None:
        hit = self._data.get(key)
        if hit is None:
            return None
        expires_at, value = hit
        if expires_at < time.monotonic():
            self._data.pop(key, None)
            return None
        return value

    async def set(self, key: str, value: str, ttl: int) -> None:
        self._data[key] = (time.monotonic() + ttl, value)

    async def clear(self) -> None:
        self._data.clear()

    async def close(self) -> None:
        self._data.clear()


class RedisCache:
    def __init__(self, url: str) -> None:
        import redis.asyncio as aioredis

        self._r = aioredis.from_url(url, decode_responses=True)

    async def get(self, key: str) -> str | None:
        return await self._r.get(key)

    async def set(self, key: str, value: str, ttl: int) -> None:
        await self._r.set(key, value, ex=ttl)

    async def clear(self) -> None:
        await self._r.flushdb()

    async def close(self) -> None:
        await self._r.aclose()


_cache: MemoryCache | RedisCache | None = None


def get_cache() -> MemoryCache | RedisCache:
    global _cache
    if _cache is None:
        _cache = RedisCache(settings.redis_url) if settings.redis_url else MemoryCache()
    return _cache


def set_cache(backend: MemoryCache | RedisCache | None) -> None:
    """Подменить бэкенд. Нужно тестам, чтобы подставить fakeredis."""
    global _cache
    _cache = backend


async def close_cache() -> None:
    global _cache
    if _cache is not None:
        await _cache.close()
        _cache = None

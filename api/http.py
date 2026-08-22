"""ETag, Cache-Control и обёртка над кешем ответов."""
import hashlib
import json
from collections.abc import Awaitable, Callable
from typing import Any

from fastapi import Response
from fastapi.encoders import jsonable_encoder
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response as StarletteResponse

from .cache import cache_key, get_cache
from .config import settings


class ETagMiddleware(BaseHTTPMiddleware):
    """ETag и Cache-Control на все успешные GET.

    ETag считается от тела ответа, поэтому не врёт: если данные не изменились,
    не изменится и он. Клиент присылает If-None-Match — отвечаем 304 без тела.

    Вешается на все GET разом, а не расставляется по эндпоинтам руками: забытый
    заголовок на одном маршруте иначе не заметен до продакшена.
    """

    async def dispatch(
        self, request: Request, call_next: Callable[[Request], Awaitable[StarletteResponse]]
    ) -> StarletteResponse:
        response = await call_next(request)

        if request.method not in ("GET", "HEAD") or response.status_code != 200:
            return response

        body = b""
        async for chunk in response.body_iterator:
            body += chunk if isinstance(chunk, bytes) else chunk.encode("utf-8")

        etag = '"' + hashlib.sha256(body).hexdigest()[:32] + '"'
        # dict(response.headers) отдаёт ключи в нижнем регистре. Обращаться к ним
        # надо тоже в нижнем: иначе setdefault("Cache-Control") не увидит уже
        # выставленный "cache-control" и добавит ВТОРОЙ заголовок.
        headers = dict(response.headers)
        headers["etag"] = etag
        # Если эндпоинт выставил свой Cache-Control — не трогаем. Так /v1/health
        # держит 30 секунд вместо общих пяти минут.
        headers.setdefault(
            "cache-control", f"public, max-age={settings.cache_ttl_seconds}"
        )
        headers.pop("content-length", None)

        if request.headers.get("if-none-match") == etag:
            headers.pop("content-type", None)
            return StarletteResponse(status_code=304, headers=headers)

        return StarletteResponse(
            content=body,
            status_code=response.status_code,
            headers=headers,
            media_type=response.media_type,
        )


async def cached(
    response: Response,
    endpoint: str,
    params: dict[str, Any],
    producer: Callable[[], Awaitable[Any]],
    ttl: int | None = None,
) -> Any:
    """Отдать ответ из кеша либо посчитать и положить туда на 5 минут.

    params обязан содержать store_id везде, где ответ от него зависит: у Bravo
    четыре разных прайса, и общий на всех ключ подсунул бы клиенту цену чужой
    зоны.
    """
    key = cache_key(endpoint, **params)
    cache = get_cache()

    hit = await cache.get(key)
    if hit is not None:
        response.headers["X-Cache"] = "hit"
        return json.loads(hit)

    payload = jsonable_encoder(await producer())
    await cache.set(
        key,
        json.dumps(payload, ensure_ascii=False, default=str),
        ttl if ttl is not None else settings.cache_ttl_seconds,
    )
    response.headers["X-Cache"] = "miss"
    return payload

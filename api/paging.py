"""Курсорная пагинация.

Offset на этих данных не годится: лента акций пересобирается после каждого
прогона сбора, и страница 3 при OFFSET 40 покажет товары, часть которых уже
была на странице 2. Курсор фиксирует место в сортировке, а не номер строки.

Курсор непрозрачный для клиента: base64 от JSON. Внутри — значения полей
сортировки последней отданной строки. Ключ сортировки всегда заканчивается
уникальным id, иначе строки с одинаковой скидкой будут перепрыгивать друг через
друга и часть потеряется.
"""
import base64
import json
from typing import Any

from fastapi import HTTPException


def encode_cursor(payload: dict[str, Any]) -> str:
    raw = json.dumps(payload, separators=(",", ":"), default=str).encode("utf-8")
    return base64.urlsafe_b64encode(raw).decode("ascii").rstrip("=")


def decode_cursor(cursor: str | None) -> dict[str, Any] | None:
    if not cursor:
        return None
    try:
        pad = "=" * (-len(cursor) % 4)
        raw = base64.urlsafe_b64decode(cursor + pad)
        value = json.loads(raw)
    except Exception:
        raise HTTPException(status_code=400, detail="Курсор испорчен")
    if not isinstance(value, dict):
        raise HTTPException(status_code=400, detail="Курсор испорчен")
    return value

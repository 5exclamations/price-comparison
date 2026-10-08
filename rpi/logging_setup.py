"""Structured (JSON) logging. One line per event, machine-parsable, with run context."""

from __future__ import annotations

import json
import logging
import sys
from contextvars import ContextVar
from datetime import UTC, datetime

_context: ContextVar[dict] = ContextVar("rpi_log_context", default={})

_RESERVED = set(logging.LogRecord("", 0, "", 0, "", (), None).__dict__) | {"message", "asctime"}


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        payload = {
            "ts": datetime.fromtimestamp(record.created, UTC).isoformat(timespec="milliseconds"),
            "level": record.levelname,
            "logger": record.name,
            "event": record.getMessage(),
            **_context.get(),
        }
        for key, value in record.__dict__.items():
            if key not in _RESERVED and not key.startswith("_"):
                payload[key] = value
        if record.exc_info:
            payload["exception"] = self.formatException(record.exc_info)
        return json.dumps(payload, default=str, ensure_ascii=False)


def configure(level: str = "INFO") -> None:
    root = logging.getLogger()
    if any(getattr(h, "_rpi", False) for h in root.handlers):
        root.setLevel(level)
        return
    handler = logging.StreamHandler(sys.stderr)
    handler.setFormatter(JsonFormatter())
    handler._rpi = True  # type: ignore[attr-defined]
    root.addHandler(handler)
    root.setLevel(level)


def bind(**values) -> None:
    """Attach fields (run_id, step, source ...) to every following log line in this context."""
    _context.set({**_context.get(), **values})


def unbind(*keys: str) -> None:
    _context.set({k: v for k, v in _context.get().items() if k not in keys})


def get(name: str) -> logging.Logger:
    return logging.getLogger(name)

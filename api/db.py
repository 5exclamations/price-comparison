"""Подключение к Postgres: SQLAlchemy 2.0 async поверх psycopg3.

Моделей нет намеренно. Схема живёт в миграциях, запросы — голый SQL через
text(). ORM-слой поверх матвьюх и секционированной таблицы дал бы только
лишний уровень, в котором прячутся планы запросов.
"""
from collections.abc import AsyncIterator

from sqlalchemy.ext.asyncio import AsyncConnection, AsyncEngine, create_async_engine

from .config import settings

_engine: AsyncEngine | None = None


def engine() -> AsyncEngine:
    global _engine
    if _engine is None:
        _engine = create_async_engine(
            settings.database_url,
            echo=settings.db_echo,
            pool_pre_ping=True,
            pool_size=10,
            max_overflow=20,
        )
    return _engine


async def dispose_engine() -> None:
    global _engine
    if _engine is not None:
        await _engine.dispose()
        _engine = None


async def get_conn() -> AsyncIterator[AsyncConnection]:
    """Зависимость FastAPI: соединение только на чтение.

    Все эндпоинты читающие, поэтому транзакция не открывается явно —
    SQLAlchemy сам обернёт запрос, а коммитить нечего.
    """
    async with engine().connect() as conn:
        yield conn

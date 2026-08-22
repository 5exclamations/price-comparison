"""Обвязка для тестов воркера против настоящего Postgres.

Каждый тест идёт в своей транзакции, которая в конце откатывается: база после
прогона остаётся ровно такой, какой была. Поэтому тесты можно гонять на той же
базе, что и API-тесты, и в любом порядке.
"""
import os
from datetime import datetime, timedelta, timezone

import pytest
import pytest_asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine

os.environ.setdefault(
    "QIYMET_DATABASE_URL", "postgresql+psycopg://qiymet@localhost:5432/qiymet"
)

# Фактура из залитого дампа.
INFLATED_STORE_ITEM = 46618      # накрученная акция: заявлено -29%, рынок дешевле
INFLATED_PRODUCT = 1601
PLAIN_STORE_ITEM = 23689         # Bravo, зона A1, без акции
PLAIN_PRODUCT = 20658
BRAVO_STORE_A1 = 1


@pytest_asyncio.fixture(scope="session")
async def engine():
    eng = create_async_engine(os.environ["QIYMET_DATABASE_URL"])
    try:
        async with eng.connect() as conn:
            await conn.execute(text("SELECT 1 FROM notifications LIMIT 1"))
    except Exception as exc:  # pragma: no cover
        pytest.exit(
            f"Нет доступа к Postgres со схемой 0006 ({exc}).\n"
            "  cd db && alembic upgrade head\n"
            "  python3 db/import_sqlite.py --sqlite pipeline/qiymet.db",
            returncode=1,
        )
    yield eng
    await eng.dispose()


@pytest_asyncio.fixture
async def conn(engine):
    """Соединение в транзакции, которая всегда откатывается."""
    async with engine.connect() as c:
        tx = await c.begin()
        try:
            yield c
        finally:
            await tx.rollback()


@pytest_asyncio.fixture
async def make_user(conn):
    """Создать анонимного пользователя с токеном устройства."""
    counter = {"n": 0}

    async def _make(lang="ru", tz="Asia/Baku", with_token=True):
        counter["n"] += 1
        anon = f"test-device-{counter['n']}"
        uid = (
            await conn.execute(
                text(
                    "INSERT INTO users (anon_id, lang, timezone) "
                    "VALUES (:a, :l, :t) RETURNING id"
                ),
                {"a": anon, "l": lang, "t": tz},
            )
        ).scalar()
        if with_token:
            await conn.execute(
                text(
                    "INSERT INTO device_tokens (user_id, token, platform) "
                    "VALUES (:u, :tok, 'android')"
                ),
                {"u": uid, "tok": f"token-{anon}"},
            )
        return uid

    return _make


@pytest_asyncio.fixture
async def make_watch(conn):
    async def _make(user_id, product_id, store_id=None, target=None):
        return (
            await conn.execute(
                text(
                    "INSERT INTO watches (user_id, product_id, store_id, "
                    "target_price_minor) VALUES (:u, :p, :s, :t) RETURNING id"
                ),
                {"u": user_id, "p": product_id, "s": store_id, "t": target},
            )
        ).scalar()

    return _make


@pytest_asyncio.fixture
async def observe(conn):
    """Добавить наблюдение цены. Возвращает момент наблюдения."""

    async def _observe(store_item_id, price, at, old_price=None, available=1):
        await conn.execute(
            text(
                "INSERT INTO price_observations (store_item_id, price, old_price, "
                "available, observed_at, source) "
                "VALUES (:si, :p, :op, :av, :at, 'test')"
            ),
            {"si": store_item_id, "p": price, "op": old_price,
             "av": available, "at": at},
        )
        return at

    return _observe


@pytest_asyncio.fixture
async def set_watermark(conn):
    async def _set(moment):
        await conn.execute(
            text(
                "INSERT INTO worker_state (worker, watermark) VALUES ('price_drop', :t) "
                "ON CONFLICT (worker) DO UPDATE SET watermark = EXCLUDED.watermark"
            ),
            {"t": moment},
        )

    return _set


@pytest.fixture
def times():
    """Три момента: база, падение, «сейчас». Все днём по Баку."""
    t0 = datetime(2026, 8, 17, 6, 0, tzinfo=timezone.utc)   # 10:00 Баку
    return t0, t0 + timedelta(hours=1), t0 + timedelta(hours=2)

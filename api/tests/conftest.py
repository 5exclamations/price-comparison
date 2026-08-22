"""Общая обвязка тестов.

Тесты идут против НАСТОЯЩЕГО Postgres со схемой из db/ и залитым qiymet.db.
Мокать базу тут нечего: половина логики — это SQL (матвьюха честности скидок,
схлопывание зон Bravo, trigram-поиск), и на моках она бы не проверялась вовсе.

Redis по умолчанию подменяется на fakeredis — он говорит на настоящем протоколе
Redis, но не требует поднятого сервера. Этого достаточно для логики кеша, но
НЕ достаточно, чтобы утверждать, что мы умеем работать с настоящим Redis:
fakeredis не воспроизводит ни выселение по maxmemory, ни обрыв соединения, ни
разницу в кодировке ответов.

Поэтому весь набор гоняется и против живого сервера:

  QIYMET_TEST_REDIS_URL=redis://localhost:6379/1 pytest api/tests -q

Так это делается в docker-compose после первого старта и так же в CI.

  QIYMET_DATABASE_URL=postgresql+psycopg://qiymet@localhost:5432/qiymet \
      pytest api/tests -q
"""
import os

import pytest
import pytest_asyncio
from httpx import ASGITransport, AsyncClient

# Настройки читаются при импорте, поэтому подставляем URL до импорта приложения.
os.environ.setdefault(
    "QIYMET_DATABASE_URL", "postgresql+psycopg://qiymet@localhost:5432/qiymet"
)
os.environ["QIYMET_REDIS_URL"] = ""

from api import cache as cache_mod  # noqa: E402
from api.db import dispose_engine, engine  # noqa: E402
from api.main import app  # noqa: E402

# ---------- фактура из залитого дампа ----------
# Значения проверяются фикстурой ниже: если дамп сменился, тесты скажут об этом
# внятно, а не посыплются загадочными ассертами.

PRODUCT_IN_5_CHAINS = 9150          # DOGADAN FORM ÇAY, есть в 5 сетях и во всех 4 зонах Bravo
PRODUCT_QUARANTINED = 26            # MİLLA DONDURMA, склейка в карантине
EAN_IN_5_CHAINS = "8699432202179"
BRAVO_STORE_B = 3                   # Bravo Superstore 28 Mall, зона B
BRAVO_STORE_C = 4                   # Bravo Ekspress Hovsan, зона C
ARAZ_STORE = 5                      # сеть с единой ценой
MISSING_STORE = 999999


# База 1, а не 0: если кто-то по ошибке направит тесты на боевой Redis,
# flushdb() снесёт пустую базу, а не кеш продакшена.
TEST_REDIS_URL = os.environ.get("QIYMET_TEST_REDIS_URL", "")


class FakeRedisCache:
    """Обёртка над fakeredis с тем же интерфейсом, что у RedisCache."""

    def __init__(self) -> None:
        import fakeredis.aioredis

        self._r = fakeredis.aioredis.FakeRedis(decode_responses=True)

    async def get(self, key):
        return await self._r.get(key)

    async def set(self, key, value, ttl):
        await self._r.set(key, value, ex=ttl)

    async def clear(self):
        await self._r.flushdb()

    async def close(self):
        await self._r.aclose()


@pytest.fixture(scope="session")
def anyio_backend():
    return "asyncio"


@pytest_asyncio.fixture(scope="session", autouse=True)
async def _require_database():
    """Без базы тесты бессмысленны — падаем внятно, а не двадцатью ошибками."""
    from sqlalchemy import text

    try:
        async with engine().connect() as conn:
            n = (await conn.execute(text("SELECT count(*) FROM products"))).scalar()
            deals = (
                await conn.execute(text("SELECT count(*) FROM deal_honesty"))
            ).scalar()
    except Exception as exc:  # pragma: no cover
        pytest.exit(
            f"Нет доступа к Postgres ({exc}).\n"
            "Подними схему и залей данные:\n"
            "  cd db && alembic upgrade head\n"
            "  python3 db/import_sqlite.py --sqlite pipeline/qiymet.db",
            returncode=1,
        )
    if not n or not deals:
        pytest.exit(
            f"База пуста (products={n}, deal_honesty={deals}). "
            "Залей дамп и вызови SELECT refresh_after_crawl().",
            returncode=1,
        )
    yield
    await dispose_engine()


# loop_scope="function" здесь обязателен, и это не украшение.
#
# В pytest.ini стоит asyncio_default_fixture_loop_scope = session: асинхронные
# фикстуры по умолчанию идут на сессионном цикле, а сами тесты — на своём.
# Настоящий redis.asyncio привязывает соединение к тому циклу, где выполнил
# первую команду, и запрос из теста падает с «Future attached to a different
# loop». fakeredis это прятал: у него нет сокета, и на каком цикле его дёргают,
# ему всё равно.
@pytest_asyncio.fixture(autouse=True, loop_scope="function")
async def _fresh_cache():
    """Каждому тесту — свой чистый кеш, иначе они начнут видеть чужие ответы.

    С QIYMET_TEST_REDIS_URL берётся настоящий RedisCache — тот же класс, что
    работает в бою, без единой подмены. Без переменной — fakeredis, чтобы
    тесты запускались на машине разработчика без поднятого сервера.
    """
    if TEST_REDIS_URL:
        backend = cache_mod.RedisCache(TEST_REDIS_URL)
        # Чистим ДО теста, а не только после: прошлый прогон мог упасть
        # и оставить ключи, и тест начал бы с чужого кеша.
        await backend.clear()
    else:
        backend = FakeRedisCache()

    cache_mod.set_cache(backend)
    yield backend
    await backend.clear()
    await backend.close()
    cache_mod.set_cache(None)


@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as c:
        yield c

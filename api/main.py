"""qiymət API.

  uvicorn api.main:app --reload

Требует поднятой схемы из db/ (alembic upgrade head) и залитых данных.
"""
from contextlib import asynccontextmanager

from fastapi import FastAPI

from .cache import close_cache
from .db import dispose_engine
from .http import ETagMiddleware
from .routers import (
    catalog,
    categories,
    deals,
    prices,
    receipts,
    health,
    product,
    search,
    stores,
    watches,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    await dispose_engine()
    await close_cache()


app = FastAPI(
    title="qiymət API",
    version="1.0.0",
    description=(
        "Сравнение цен в супермаркетах Азербайджана.\n\n"
        "**Деньги.** Любое денежное поле — целое число гяпиков и называется "
        "`*_minor`. Форматирование на стороне клиента: 34990 -> 349.90 ₼.\n\n"
        "**Время наблюдения.** Рядом с каждой ценой лежит `observed_at`. "
        "Показывать цену без времени нельзя — сеть могла не обновляться сутки, "
        "и `/v1/health` покажет это явно.\n\n"
        "**Bravo.** У сети четыре измеренные ценовые зоны, и они не совпадают с "
        "форматом магазина. Без выбранного магазина цена Bravo не участвует в "
        "подсчёте лучшей цены, а сеть попадает в `needs_store_selection`.\n\n"
        "**Карантин.** Склейки с `products.quarantined = 1` не отдаются никогда: "
        "карточка такого товара возвращает 404."
    ),
    lifespan=lifespan,
)

app.add_middleware(ETagMiddleware)

for module in (
    search,
    catalog,
    product,
    deals,
    stores,
    health,
    watches,
    categories,
    prices,
    receipts,
):
    app.include_router(module.router, prefix="/v1", tags=["v1"])


@app.get("/healthz", include_in_schema=False)
async def liveness() -> dict[str, str]:
    """Жив ли процесс. Ничего не проверяет, кроме самого себя.

    Отдельно от `/v1/health` намеренно. Тот ходит в базу и в историю проверок
    данных, и дёргать его раз в пятнадцать секунд из docker healthcheck значило
    бы гонять эти запросы шесть тысяч раз в сутки ради вопроса «процесс
    отвечает?».

    Внешний монитор смотрит сюда же: если упал процесс, ответа не будет вовсе,
    а если данные протухли — это видно в `/v1/health`, и туда монитор ходит
    раз в пять минут, а не каждые пятнадцать секунд.
    """
    return {"status": "ok"}

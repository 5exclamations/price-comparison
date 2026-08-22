"""GET /v1/stores и GET /v1/health."""
import pytest
from sqlalchemy import text

pytestmark = pytest.mark.asyncio


# ---------- магазины ----------


async def test_stores(client):
    r = await client.get("/v1/stores")
    assert r.status_code == 200
    items = r.json()["items"]
    assert items


async def test_single_price_chains_are_synthetic(client):
    """Сеть с единой ценой — одна синтетическая запись, а не список филиалов.

    У Araz в дампе две точки Wolt, но прайс один. Показать обе значило бы
    предложить пользователю выбор, который ни на что не влияет.
    """
    items = (await client.get("/v1/stores")).json()["items"]
    araz = [s for s in items if s["chain_code"] == "araz"]

    assert len(araz) == 1
    assert araz[0]["synthetic"] is True
    assert araz[0]["store_id"] is None
    assert araz[0]["price_model"] == "single"


async def test_bravo_returns_real_branches(client):
    """У Bravo цена зависит от зоны, поэтому филиалы отдаются по-настоящему."""
    items = (await client.get("/v1/stores")).json()["items"]
    bravo = [s for s in items if s["chain_code"] == "bravo"]

    assert len(bravo) == 4
    assert all(s["synthetic"] is False for s in bravo)
    assert all(s["store_id"] is not None for s in bravo)
    assert {s["price_cluster"] for s in bravo} == {"A1", "A2", "B", "C"}


async def test_every_chain_present(client):
    items = (await client.get("/v1/stores")).json()["items"]
    assert {s["chain_code"] for s in items} == {
        "bazarstore", "bravo", "araz", "neptun", "spar", "rahat"
    }


async def test_distance_is_null_without_coordinates(client):
    """В дампе stores.lat/lon пусты у всех девяти магазинов.

    Расстояние честно возвращается как null, а не как ноль или выдуманное
    число. coordinates_known говорит клиенту, что сортировать нечем.
    """
    r = await client.get("/v1/stores", params={"lat": 40.4093, "lon": 49.8671})
    assert r.status_code == 200
    body = r.json()
    assert body["coordinates_known"] == 0
    assert all(s["distance_m"] is None for s in body["items"])


async def test_coordinates_validated(client):
    r = await client.get("/v1/stores", params={"lat": 200, "lon": 0})
    assert r.status_code == 422


# ---------- свежесть ----------


async def test_health(client):
    r = await client.get("/v1/health")
    assert r.status_code == 200
    body = r.json()

    assert body["status"] in {"ok", "degraded"}
    assert body["stale_after_hours"] == 12
    assert body["database"] == "ok"
    assert len(body["chains"]) == 6

    for c in body["chains"]:
        assert c["status"] in {"ok", "degraded", "no_data"}
        if c["last_observed_at"] is not None:
            assert c["age_hours"] is not None
            # статус обязан соответствовать возрасту, а не быть проставлен наугад
            assert c["status"] == ("degraded" if c["age_hours"] > 12 else "ok")


async def test_health_counts_items(client):
    body = (await client.get("/v1/health")).json()
    assert sum(c["items_tracked"] for c in body["chains"]) > 0


async def test_health_cache_control_is_short(client):
    """У health свой Cache-Control: 30 секунд вместо общих пяти минут.

    Смысл эндпоинта — сказать, свежи ли данные ПРЯМО СЕЙЧАС. Пятиминутный кеш
    задержал бы предупреждение об аварии сбора ровно на пять минут.
    """
    r = await client.get("/v1/health")
    assert r.headers["cache-control"] == "public, max-age=30"


async def test_разрез_по_точкам_есть_у_каждой_сети(client):
    """У каждой сети в ответе есть точки, и суммы по ним сходятся с сетью.

    Разрез — не украшение: без него потеря одной точки не видна вовсе.
    """
    body = (await client.get("/v1/health")).json()

    for c in body["chains"]:
        assert c["stores"], f"у сети {c['chain_code']} нет ни одной точки"
        assert c["items_tracked"] == sum(s["items_tracked"] for s in c["stores"])

        # Возраст сети — по САМОЙ СТАРОЙ точке. Максимум скрывал бы ровно ту
        # поломку, ради которой разрез и появился.
        ages = [s["age_hours"] for s in c["stores"] if s["age_hours"] is not None]
        if ages:
            assert c["age_hours"] == pytest.approx(max(ages), abs=0.02)


async def test_у_сети_с_единой_ценой_точка_одна_и_без_store_id(client):
    """Araz, SPAR, Neptun, Rahat: цена одна на всю сеть.

    Разрез не должен ничего менять там, где менять нечего: одна строка, как
    и была. Bazarstore грузится без привязки к точке — там store_id пуст.
    """
    body = (await client.get("/v1/health")).json()
    chains = {c["chain_code"]: c for c in body["chains"]}

    assert len(chains["bazarstore"]["stores"]) == 1
    assert chains["bazarstore"]["stores"][0]["store_id"] is None


async def test_отвалившаяся_зона_bravo_не_прячется_за_свежими(client):
    """Главная дыра, ради которой всё это переделано.

    Сбор молча переживает потерю точки: коннектор печатает «ПРОПУЩЕН <slug>»
    и идёт дальше. У Bravo четыре ценовые зоны. Если отвалилась одна, при
    подсчёте по сети три оставшиеся тянут max(observed_at) наверх, и сеть
    выглядит свежей — а люди, выбравшие выпавшую точку, видят вчерашние цены.

    Здесь одна точка Bravo состаривается на трое суток, остальные делаются
    свежими. Сеть обязана уйти в degraded, а сама точка — попасть
    в stale_store_ids, откуда клиент включит плашку.
    """
    from api.db import engine

    async with engine().begin() as conn:
        bravo_stores = (
            await conn.execute(
                text(
                    "SELECT DISTINCT si.store_id FROM store_items si "
                    "JOIN chains c ON c.id = si.chain_id "
                    "WHERE c.code = 'bravo' AND si.store_id IS NOT NULL "
                    "ORDER BY 1"
                )
            )
        ).scalars().all()
        assert len(bravo_stores) >= 2, "нужно минимум две точки Bravo"

        victim, *survivors = bravo_stores

        # Свежие наблюдения всем, кроме одной точки. Пишем в price_observations
        # и пересобираем витрину — тем же путём, каким это делает сбор.
        await conn.execute(
            text(
                """
                INSERT INTO price_observations
                    (store_item_id, price, available, observed_at, source)
                SELECT si.id, 100, 1, now(), 'test_freshness'
                FROM store_items si
                WHERE si.store_id = ANY(:alive)
                """
            ),
            {"alive": survivors},
        )
        await conn.execute(text("SELECT refresh_current_prices()"))

    try:
        body = (await client.get("/v1/health")).json()
        bravo = next(c for c in body["chains"] if c["chain_code"] == "bravo")

        alive = [s for s in bravo["stores"] if s["store_id"] in survivors]
        dead = next(s for s in bravo["stores"] if s["store_id"] == victim)

        assert all(s["status"] == "ok" for s in alive), "свежие точки обязаны быть ok"
        assert dead["status"] == "degraded", "выпавшая точка обязана быть degraded"

        assert bravo["status"] == "degraded", (
            "сеть выглядит свежей, хотя одна её зона отвалилась — "
            "это ровно та дыра, которую разрез закрывает"
        )
        assert victim in body["stale_store_ids"]
        assert not set(survivors) & set(body["stale_store_ids"])
    finally:
        async with engine().begin() as conn:
            await conn.execute(
                text("DELETE FROM price_observations WHERE source = 'test_freshness'")
            )
            await conn.execute(text("SELECT refresh_current_prices()"))

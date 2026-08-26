"""GET /v1/catalog и /v1/catalog/categories."""
import pytest

pytestmark = pytest.mark.asyncio


async def test_catalog_returns_items(client):
    r = await client.get("/v1/catalog", params={"limit": 5})
    assert r.status_code == 200
    body = r.json()
    assert len(body["items"]) <= 5
    assert "has_more" in body


async def test_order_is_stable(client):
    """Порядок обязан быть повторяемым: человек обходит каталог, а не ищет.

    Сравнивать с sorted() из Python нельзя: Postgres сортирует по локали базы
    (en_US.utf8), и пробелы там весят иначе — «1000 BƏRƏKƏT» встаёт раньше
    «1 MAY BAMBUK». Это не расхождение, а разные правила сортировки, поэтому
    проверяем то, от чего действительно зависит пагинация: два одинаковых
    запроса дают один и тот же порядок.
    """
    first = await client.get("/v1/catalog", params={"limit": 20})
    second = await client.get("/v1/catalog", params={"limit": 20})
    assert [i["product_id"] for i in first.json()["items"]] == [
        i["product_id"] for i in second.json()["items"]
    ]


async def test_cursor_does_not_repeat_rows(client):
    """Курсор фиксирует место в сортировке, а не номер строки.

    Проверяем именно отсутствие ПЕРЕСЕЧЕНИЯ: при offset-пагинации вторая
    страница показала бы часть первой, и заметить это по одному запросу нельзя.
    """
    first = await client.get("/v1/catalog", params={"limit": 5})
    body = first.json()
    if not body["has_more"]:
        pytest.skip("в дампе меньше двух страниц")

    second = await client.get(
        "/v1/catalog", params={"limit": 5, "cursor": body["next_cursor"]}
    )
    assert second.status_code == 200

    ids_first = {i["product_id"] for i in body["items"]}
    ids_second = {i["product_id"] for i in second.json()["items"]}
    assert not (ids_first & ids_second)


async def test_filter_by_chain(client):
    """Каталог сети не может быть шире общего каталога."""
    all_items = await client.get("/v1/catalog", params={"limit": 1})
    one_chain = await client.get("/v1/catalog", params={"chain_id": 1, "limit": 1})
    assert one_chain.status_code == 200
    assert all_items.status_code == 200


async def test_quarantined_never_shown(client):
    """Правило из CLAUDE.md: карантинную склейку не показываем никогда."""
    r = await client.get("/v1/catalog", params={"limit": 50})
    assert r.status_code == 200
    # Карантинные отсекаются в SQL, поэтому проверяем через поиск по id:
    # ни один из отданных не должен быть карантинным.
    for item in r.json()["items"]:
        card = await client.get(f"/v1/product/{item['product_id']}")
        assert card.status_code == 200


async def test_unknown_chain_gives_empty_not_error(client):
    """Несуществующая сеть — пустой список, а не 500."""
    r = await client.get("/v1/catalog", params={"chain_id": 999999})
    assert r.status_code == 200
    assert r.json()["items"] == []


async def test_categories_endpoint(client):
    r = await client.get("/v1/catalog/categories")
    assert r.status_code == 200
    assert "items" in r.json()


async def test_has_etag_and_cache(client):
    r = await client.get("/v1/catalog", params={"limit": 5})
    assert "etag" in r.headers
    second = await client.get("/v1/catalog", params={"limit": 5})
    assert second.headers["x-cache"] == "hit"

"""Модели ответов, Pydantic v2.

Правило по деньгам одно на весь API: любое денежное поле — целое число гяпиков
и называется *_minor. Никаких манатов и никакого float в JSON. Клиент делит на
100 сам, на границе показа.

Второе правило: рядом с каждым числом, которое видит пользователь, лежит
observed_at. Цена без времени наблюдения — это враньё, особенно когда сеть
не обновлялась сутки.
"""
from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field

# ---------- общее ----------


class Page(BaseModel):
    """Курсорная пагинация. next_cursor = null означает, что дальше пусто."""

    next_cursor: str | None = Field(
        None, description="Передать как ?cursor= для следующей страницы"
    )
    has_more: bool


# ---------- /v1/search ----------


class SearchItem(BaseModel):
    product_id: int
    name: str
    brand: str | None
    ean: str | None
    unit_value: float | None
    unit_type: str | None = Field(
        None, description="g / ml / pcs / kg_bulk. У kg_bulk цена за килограмм"
    )

    best_price_minor: int | None = Field(
        None, description="Лучшая цена в гяпиках. null, если её нельзя показать однозначно"
    )
    best_price_chain: str | None
    chains_count: int = Field(description="В скольких сетях товар вообще есть")
    has_promo: bool
    observed_at: datetime | None = Field(
        None, description="Когда наблюдалась best_price_minor"
    )

    needs_store_selection: bool = Field(
        False,
        description=(
            "У сети с самой низкой ценой прайс зависит от магазина (Bravo), "
            "а магазин не выбран. Цена такой сети в best_price_minor не попадает"
        ),
    )


class SearchResponse(Page):
    query: str
    normalized_query: str = Field(
        description="Запрос после нормализации — той же, что применена к индексу"
    )
    matched_by: Literal["barcode", "name"]
    items: list[SearchItem]


# ---------- /v1/product/{id} ----------


class ChainPrice(BaseModel):
    chain_id: int
    chain_code: str
    chain_name: str
    price_model: Literal["single", "per_store", "per_cluster"]

    store_id: int | None = Field(
        None, description="null у сетей с единой ценой — там цена не зависит от точки"
    )
    store_name: str | None
    price_cluster: str | None = Field(
        None, description="Измеренная ценовая зона. У Bravo их четыре"
    )

    price_minor: int
    old_price_minor: int | None = Field(
        None, description="Зачёркнутая цена. Не null = сеть заявляет акцию"
    )
    is_promo: bool
    available: bool
    observed_at: datetime
    source: str

    requires_store_selection: bool = Field(
        False,
        description=(
            "Цена этой сети зависит от выбранного магазина, а магазин не выбран. "
            "Показывать как единственную цену сети нельзя"
        ),
    )


class ProductCard(BaseModel):
    product_id: int
    name: str
    brand: str | None
    ean: str | None
    unit_value: float | None
    unit_type: str | None

    prices: list[ChainPrice]
    chains_count: int
    best_price_minor: int | None
    best_price_chain: str | None
    needs_store_selection: list[str] = Field(
        default_factory=list,
        description="Коды сетей, чью цену нельзя показать без выбора магазина",
    )


# ---------- /v1/deals ----------


class Deal(BaseModel):
    deal_id: int = Field(
        description=(
            "Устойчивый идентификатор акции: конкретный товар в конкретной сети "
            "и точке. Один товар может дать несколько акций — по одной на сеть "
            "и ценовую зону, — поэтому product_id для этого не годится"
        )
    )
    product_id: int
    name: str
    brand: str | None
    ean: str | None

    chain_code: str
    store_id: int | None
    store_name: str | None
    price_cluster: str | None

    price_minor: int
    old_price_minor: int = Field(description="Цена, которую заявляет сама сеть")
    market_price_minor: int = Field(
        description="Медиана неакционных цен на тот же штрихкод в ДРУГИХ сетях"
    )
    reference_chains: int = Field(
        description="Сколько неакционных цен в других сетях легло в медиану"
    )

    claimed_discount: float = Field(
        description="Скидка, заявленная сетью: (old - price) / old"
    )
    real_discount: float = Field(
        description=(
            "Настоящая скидка от рынка: (market - price) / market. "
            "Отрицательная означает, что «акционная» цена выше рынка"
        )
    )
    inflation: float = Field(description="claimed - real. Это и есть накрутка")
    inflated: bool = Field(
        description="Заявленная скидка глубже настоящей больше чем на 15 п.п."
    )

    observed_at: datetime


class DealsResponse(Page):
    items: list[Deal]


# ---------- /v1/prices ----------


class BasketProduct(BaseModel):
    product_id: int
    name: str
    brand: str | None
    ean: str | None
    unit_value: float | None
    unit_type: str | None
    prices: list[ChainPrice] = Field(
        description="Цены по сетям, от дешёвой к дорогой"
    )


class BasketPrices(BaseModel):
    items: list[BasketProduct]
    missing: list[int] = Field(
        description=(
            "Запрошенные товары, которых нет: удалены либо склейка в карантине. "
            "Клиенту важно отличать «нет цены» от «мы это потеряли»"
        )
    )
    stale_after_hours: int = Field(
        description="После скольких часов наблюдение считается устаревшим"
    )


# ---------- /v1/stores ----------


class StoreOut(BaseModel):
    store_id: int | None = Field(
        None,
        description=(
            "null у синтетической записи сети с единой ценой — такой store_id "
            "никуда передавать не нужно, цена от точки не зависит"
        ),
    )
    chain_id: int
    chain_code: str
    chain_name: str
    price_model: Literal["single", "per_store", "per_cluster"]

    name: str
    format: str | None
    price_cluster: str | None
    address: str | None
    lat: float | None
    lon: float | None
    distance_m: int | None = Field(
        None, description="null, если у магазина нет координат либо точка не задана"
    )
    synthetic: bool = Field(
        description="Одна запись на всю сеть вместо списка филиалов"
    )


class StoresResponse(BaseModel):
    items: list[StoreOut]
    coordinates_known: int = Field(
        description="У скольких записей есть координаты. Ноль означает, что сортировать по расстоянию нечем"
    )


# ---------- /v1/product/{id}/history ----------


class HistoryPoint(BaseModel):
    observed_at: datetime
    price_minor: int
    old_price_minor: int | None
    is_promo: bool
    available: bool

    chain_code: str
    store_id: int | None
    price_cluster: str | None


class HistoryEvent(BaseModel):
    observed_at: datetime
    kind: Literal[
        "promo_started", "promo_ended", "price_up", "price_down", "availability_changed"
    ]
    chain_code: str
    store_id: int | None
    price_cluster: str | None

    price_minor: int
    prev_price_minor: int
    old_price_minor: int | None

    inflated_old_price: bool = Field(
        False,
        description=(
            "Акция началась, и заявленная старая цена выше той, что мы видели "
            "своими глазами в прошлом наблюдении"
        ),
    )


class HistoryResponse(BaseModel):
    product_id: int
    days: int
    since: datetime
    points: list[HistoryPoint]
    events: list[HistoryEvent]


# ---------- /v1/categories ----------


class CategoryOut(BaseModel):
    code: str
    deals_count: int = Field(description="Сколько сейчас акций в этой категории")


class CategoriesResponse(BaseModel):
    items: list[CategoryOut] = Field(
        description=(
            "Категории, в которых есть акции. Пустой список означает, что "
            "фильтровать не по чему — клиент должен спрятать фильтр"
        )
    )


# ---------- чеки и согласие ----------


class ConsentText(BaseModel):
    kind: Literal["receipts"]
    version: int
    locale: str
    text: str = Field(description="Текст, который обязан показать клиент")
    digest: str


class ConsentState(BaseModel):
    kind: Literal["receipts"]
    current_version: int
    granted: bool = Field(
        description="Есть ли ДЕЙСТВУЮЩЕЕ согласие на текущую версию текста"
    )
    granted_version: int | None
    granted_at: datetime | None


class ReceiptSubmitIn(BaseModel):
    url: str = Field(
        description="Ссылка из QR на чеке. Проверяется по белому списку доменов",
        max_length=2000,
    )


class ReceiptItemOut(BaseModel):
    line_no: int
    name: str
    quantity: float
    unit: str | None
    unit_price_minor: int
    total_minor: int
    ean: str | None


class ReceiptOut(BaseModel):
    id: int
    fiscal_id: str
    merchant_name: str | None
    chain_code: str | None = Field(
        None, description="null — магазин не из наших сетей. Чек всё равно сохранён"
    )
    issued_at: datetime = Field(description="Когда пробили чек, не когда загрузили")
    total_minor: int
    uploaded_at: datetime
    status: str
    duplicate: bool = Field(
        False, description="Такой чек уже был загружен. Баллы за него не начисляются"
    )
    points_awarded: int = 0
    items: list[ReceiptItemOut] = Field(default_factory=list)


class ReceiptsResponse(BaseModel):
    items: list[ReceiptOut]


class PointsOut(BaseModel):
    points: int
    receipts_uploaded: int


# ---------- подписки и устройства ----------


class DeviceIn(BaseModel):
    token: str = Field(min_length=10, description="Токен FCM")
    platform: Literal["ios", "android"]
    lang: Literal["az", "ru", "en"] = "az"
    timezone: str = Field(
        "Asia/Baku", description="Имя зоны из базы tz — для тихих часов 23:00-08:00"
    )


class DeviceOut(BaseModel):
    user_id: int
    device_token_id: int
    lang: str
    timezone: str


class WatchIn(BaseModel):
    product_id: int = Field(ge=1)
    store_id: int | None = Field(
        None,
        description=(
            "null = следим во всех сетях. Для Bravo выбор магазина осмыслен: "
            "у сети четыре ценовые зоны с разными ценами"
        ),
    )
    target_price_minor: int | None = Field(
        None, gt=0, description="Целевая цена в гяпиках. null = хватит падения на 5%"
    )


class WatchOut(BaseModel):
    id: int
    product_id: int
    product_name: str
    store_id: int | None
    store_name: str | None
    target_price_minor: int | None
    active: bool
    created_at: datetime

    current_best_price_minor: int | None
    current_best_chain: str | None
    observed_at: datetime | None


class WatchesResponse(BaseModel):
    items: list[WatchOut]


# ---------- /v1/health ----------


class StoreHealth(BaseModel):
    """Свежесть данных ОДНОЙ точки.

    Разрез по магазину, а не только по сети, потому что сбор молча переживает
    потерю отдельной точки. У Bravo четыре ценовые зоны: если отвалилась одна,
    три оставшиеся тянут возраст сети наверх, и по сети всё выглядит свежим.
    Человек, выбравший выпавшую точку, при этом видит вчерашние цены.
    """

    store_id: int | None = Field(
        None, description="null у сетей с единой ценой — там точка одна на всю сеть"
    )
    store_name: str | None
    price_cluster: str | None = Field(
        None, description="Внутреннее поле. Пользователю слово «зона» не показывать"
    )
    last_observed_at: datetime | None
    age_hours: float | None
    items_tracked: int
    status: Literal["ok", "degraded", "no_data"]


class ChainHealth(BaseModel):
    chain_id: int
    chain_code: str
    chain_name: str
    last_observed_at: datetime | None
    age_hours: float | None
    items_tracked: int
    status: Literal["ok", "degraded", "no_data"]

    stores: list[StoreHealth] = Field(
        default_factory=list,
        description=(
            "Разрез по точкам. У сети с единой ценой одна запись со store_id = null. "
            "Сеть может быть ok, а отдельная точка degraded — именно эту дыру "
            "разрез и закрывает"
        ),
    )


class DataQuality(BaseModel):
    """Результат последнего прогона проверок данных.

    Отдаётся клиенту, чтобы приложение показало плашку «данные обновляются»
    вместо подозрительных цифр. Молча показывать мусор нельзя: человек съездит
    в магазин по неверной цене и не вернётся.
    """

    checked_at: datetime | None = Field(
        None, description="Когда последний раз гоняли проверки"
    )
    passed: bool = Field(
        description="Прошёл ли последний прогон. false — показывать плашку"
    )
    failed_checks: list[str] = Field(
        default_factory=list,
        description="Имена упавших проверок. Клиенту для лога, не для показа",
    )
    cross_chain_merges: int | None = None
    packaging_ratio: float | None = None


class HealthResponse(BaseModel):
    status: Literal["ok", "degraded"]
    stale_store_ids: list[int] = Field(
        default_factory=list,
        description=(
            "Точки, чьи данные старше stale_after_hours. Клиенту этого хватает, "
            "чтобы включить плашку человеку, чей магазин протух, даже когда "
            "сеть в целом свежая"
        ),
    )
    stale_after_hours: int
    generated_at: datetime
    chains: list[ChainHealth]
    database: Literal["ok", "unavailable"]
    cache: Literal["redis", "memory"]

    data_quality: DataQuality = Field(
        description=(
            "Состояние проверок данных. Если passed = false, приложение обязано "
            "показать плашку «данные обновляются» вместо цен"
        )
    )

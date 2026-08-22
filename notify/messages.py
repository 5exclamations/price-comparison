"""Текст уведомления на языке пользователя.

Коротко и с числами:

    Papia tualet kağızı 32 li — 13.99 ₼ в Bravo вместо 34.69.
    Дешевле рынка на 60%.

«Вместо 34.69» — это цена, которую мы ВИДЕЛИ в прошлом наблюдении, а не
зачёркнутая цена с ценника. Ценник врёт у 4.6% акций, наши наблюдения нет.

Вторая фраза появляется только когда есть с чем сравнивать: медиана неакционных
цен на тот же штрихкод в других сетях. Без неё обещать «дешевле рынка» нельзя,
и мы просто молчим об этом.
"""
from dataclasses import dataclass

from .rules import Delta, Watch

MANAT = "₼"

# Заголовок пуша: короткий крючок. Тело несёт числа.
TITLES = {
    "az": "Qiymət düşdü",
    "ru": "Цена упала",
    "en": "Price drop",
}

# {name} — {price} ₼ ...
BODY = {
    "az": "{name} — {chain}-da {prev} əvəzinə {price} {m}.",
    "ru": "{name} — {price} {m} в {chain} вместо {prev}.",
    "en": "{name} — {price} {m} at {chain}, was {prev}.",
}

MARKET = {
    "az": " Bazardan {pct}% ucuz.",
    "ru": " Дешевле рынка на {pct}%.",
    "en": " {pct}% below market.",
}

# Приписка про зону: цена Bravo без указания зоны бессмысленна.
ZONE = {
    "az": " ({chain} {cluster} zonası)",
    "ru": " ({chain}, зона {cluster})",
    "en": " ({chain}, zone {cluster})",
}

TARGET = {
    "az": " İstədiyiniz qiymətdən aşağıdır.",
    "ru": " Ниже вашей цели.",
    "en": " Below your target.",
}


def format_money(minor: int) -> str:
    """Гяпики в манаты. Единственное место, где деньги перестают быть целыми."""
    sign = "-" if minor < 0 else ""
    minor = abs(minor)
    return f"{sign}{minor // 100}.{minor % 100:02d}"


@dataclass(frozen=True)
class Rendered:
    title: str
    body: str

    @property
    def text(self) -> str:
        return f"{self.title}: {self.body}"


def render(watch: Watch, delta: Delta, reason: str) -> Rendered:
    lang = watch.lang if watch.lang in BODY else "az"

    body = BODY[lang].format(
        name=delta.product_name,
        price=format_money(delta.price),
        prev=format_money(delta.prev_price),
        chain=delta.chain_name,
        m=MANAT,
    )

    # Зона нужна только там, где цена от неё зависит. У сетей с единой ценой
    # price_cluster тоже заполнен ('ALL'), но говорить о зоне там бессмысленно.
    if delta.price_cluster and delta.price_cluster != "ALL":
        body += ZONE[lang].format(chain=delta.chain_name, cluster=delta.price_cluster)

    if delta.real_discount is not None and delta.real_discount > 0:
        body += MARKET[lang].format(pct=round(100 * delta.real_discount))

    if reason == "target_hit":
        body += TARGET[lang]

    return Rendered(title=TITLES[lang], body=body)

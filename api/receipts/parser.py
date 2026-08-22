"""Разбор ответа портала в структуру чека.

Чистые функции: на вход строка, на выход [ParsedReceipt] либо исключение.
Ни сети, ни базы — поэтому разбор проверяется тестами целиком, а не «на глаз».

ВАЖНО про формат. Точный ответ портала не подтверждён: публичной страницы чека
я не нашёл, настоящего чека с QR у меня не было (подробности в source.py).
Поэтому здесь разобраны две формы:

  * JSON — если портал отдаёт данные как API;
  * HTML-таблица — если страница рендерится на сервере.

Обе разбираются по ИМЕНАМ полей и по структуре, а не по позициям, поэтому
подстройка под настоящий ответ — это правка карты имён ниже, а не
переписывание. Всё, что вокруг разбора, от формата не зависит.

Деньги: портал печатает манаты («13,99»), а мы всюду держим целые гяпики.
Перевод здесь единственный на весь бэкенд, и он целочисленный — никакого float
в деньгах.
"""
from __future__ import annotations

import html
import json
import re
from dataclasses import dataclass, field
from datetime import datetime, timezone


class ReceiptParseError(ValueError):
    """Ответ портала не удалось разобрать как чек."""


@dataclass
class ParsedItem:
    line_no: int
    raw_name: str
    quantity: float
    unit: str | None
    unit_price_minor: int
    total_minor: int
    ean: str | None = None


@dataclass
class ParsedReceipt:
    fiscal_id: str
    issued_at: datetime
    total_minor: int
    merchant_name: str | None = None
    merchant_tin: str | None = None
    items: list[ParsedItem] = field(default_factory=list)


# Имена полей, под которыми портал может отдавать одно и то же. Подстройка под
# настоящий ответ — правка этих списков.
FIELD_ALIASES = {
    "fiscal_id": ("documentId", "fiscalId", "docId", "documentNumber", "id"),
    "issued_at": ("dateTime", "createdAt", "documentDate", "date", "issuedAt"),
    "total": ("totalAmount", "total", "sum", "amount", "cashAmount"),
    "merchant": ("objectName", "companyName", "merchantName", "taxpayerName"),
    "tin": ("tin", "taxNumber", "voen", "taxId"),
    "items": ("items", "products", "goods", "lines", "documentItems"),
    "item_name": ("name", "productName", "goodName", "title", "description"),
    "item_qty": ("quantity", "qty", "count", "amount"),
    "item_unit": ("unit", "unitName", "measure"),
    "item_price": ("price", "unitPrice", "priceAmount"),
    "item_total": ("total", "totalPrice", "sum", "amount"),
    "item_ean": ("barcode", "ean", "gtin", "code"),
}


def money_to_minor(value: object) -> int:
    """Манаты в гяпики, целочисленно.

    «13,99» и «13.99» дают 1399. Дробную часть длиннее двух знаков не
    принимаем: это не деньги, а чья-то ошибка, и молча округлять её нельзя.
    """
    if isinstance(value, bool):
        raise ReceiptParseError("Сумма не может быть булевой")
    if isinstance(value, int):
        return value * 100
    if isinstance(value, float):
        # Портал может отдать 13.99. Считаем через строку, чтобы не поймать
        # 13.989999999.
        value = f"{value:.4f}".rstrip("0").rstrip(".")

    text = str(value).strip().replace(" ", "").replace(" ", "")
    text = text.replace(",", ".")
    if not text:
        raise ReceiptParseError("Пустая сумма")

    negative = text.startswith("-")
    if negative:
        text = text[1:]

    if not re.fullmatch(r"\d+(\.\d{1,2})?", text):
        raise ReceiptParseError(f"Не похоже на сумму: {value!r}")

    whole, _, frac = text.partition(".")
    minor = int(whole) * 100 + int((frac or "0").ljust(2, "0"))
    return -minor if negative else minor


def parse_datetime(value: object) -> datetime:
    """Время чека. Наивное значение считаем бакинским, а не UTC.

    Касса печатает местное время. Прочитать его как UTC значит сдвинуть все
    покупки на четыре часа — и потом объяснять, почему человек «покупал в 4 утра».
    """
    from zoneinfo import ZoneInfo

    if isinstance(value, datetime):
        dt = value
    else:
        text = str(value).strip()
        if not text:
            raise ReceiptParseError("Пустая дата")
        dt = None
        for fmt in (
            "%Y-%m-%dT%H:%M:%S",
            "%Y-%m-%dT%H:%M:%S.%f",
            "%Y-%m-%d %H:%M:%S",
            "%d.%m.%Y %H:%M:%S",
            "%d.%m.%Y %H:%M",
        ):
            try:
                dt = datetime.strptime(text.replace("Z", ""), fmt)
                break
            except ValueError:
                continue
        if dt is None:
            try:
                dt = datetime.fromisoformat(text)
            except ValueError as exc:
                raise ReceiptParseError(f"Не разобрал дату: {value!r}") from exc

    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=ZoneInfo("Asia/Baku"))
    return dt.astimezone(timezone.utc)


def _pick(source: dict, key: str):
    """Достать поле по любому из известных имён, регистр не важен."""
    lowered = {k.lower(): v for k, v in source.items()}
    for alias in FIELD_ALIASES[key]:
        if alias.lower() in lowered:
            value = lowered[alias.lower()]
            if value not in (None, ""):
                return value
    return None


def parse_receipt(payload: str, fallback_id: str | None = None) -> ParsedReceipt:
    """Разобрать ответ портала. Пробуем JSON, потом HTML."""
    text = (payload or "").strip()
    if not text:
        raise ReceiptParseError("Пустой ответ портала")

    if text[0] in "{[":
        return _parse_json(text, fallback_id)
    return _parse_html(text, fallback_id)


def _parse_json(text: str, fallback_id: str | None) -> ParsedReceipt:
    try:
        data = json.loads(text)
    except json.JSONDecodeError as exc:
        raise ReceiptParseError("Ответ не разобрался как JSON") from exc

    if isinstance(data, list):
        data = data[0] if data else {}
    if not isinstance(data, dict):
        raise ReceiptParseError("Ожидался объект чека")

    # Портал может завернуть чек в конверт вида {"data": {...}}.
    for envelope in ("data", "result", "document", "receipt"):
        inner = data.get(envelope)
        if isinstance(inner, dict):
            data = {**inner, **{k: v for k, v in data.items() if k != envelope}}
            break

    raw_items = _pick(data, "items") or []
    if not isinstance(raw_items, list):
        raise ReceiptParseError("Позиции чека не список")

    items: list[ParsedItem] = []
    for i, raw in enumerate(raw_items, start=1):
        if not isinstance(raw, dict):
            continue
        name = _pick(raw, "item_name")
        price = _pick(raw, "item_price")
        if name is None or price is None:
            # Строка без названия или цены — не позиция. Пропускаем, но не
            # роняем весь чек: остальные позиции всё ещё полезны.
            continue

        qty_raw = _pick(raw, "item_qty")
        quantity = _to_float(qty_raw) if qty_raw is not None else 1.0
        unit_price = money_to_minor(price)
        total_raw = _pick(raw, "item_total")
        total = (
            money_to_minor(total_raw)
            if total_raw is not None
            else round(unit_price * quantity)
        )

        items.append(
            ParsedItem(
                line_no=i,
                raw_name=str(name).strip(),
                quantity=quantity,
                unit=_str_or_none(_pick(raw, "item_unit")),
                unit_price_minor=unit_price,
                total_minor=total,
                ean=_clean_ean(_pick(raw, "item_ean")),
            )
        )

    if not items:
        raise ReceiptParseError("В чеке нет ни одной позиции")

    fiscal = _str_or_none(_pick(data, "fiscal_id")) or fallback_id
    if not fiscal:
        raise ReceiptParseError("У чека нет номера")

    issued = _pick(data, "issued_at")
    if issued is None:
        raise ReceiptParseError("У чека нет времени")

    total_raw = _pick(data, "total")
    total = (
        money_to_minor(total_raw)
        if total_raw is not None
        else sum(i.total_minor for i in items)
    )

    return ParsedReceipt(
        fiscal_id=str(fiscal).strip(),
        issued_at=parse_datetime(issued),
        total_minor=total,
        merchant_name=_str_or_none(_pick(data, "merchant")),
        merchant_tin=_str_or_none(_pick(data, "tin")),
        items=items,
    )


# Строка таблицы: название, количество, цена, сумма.
_ROW = re.compile(r"<tr[^>]*>(.*?)</tr>", re.I | re.S)
_CELL = re.compile(r"<t[dh][^>]*>(.*?)</t[dh]>", re.I | re.S)
_TAGS = re.compile(r"<[^>]+>")


def _parse_html(text: str, fallback_id: str | None) -> ParsedReceipt:
    """Разбор серверного HTML.

    Идём по таблицам и берём строки, у которых достаточно ячеек и в последних
    стоят числа. Привязки к номерам колонок нет: у портала они поменяются
    раньше, чем мы об этом узнаем.
    """
    items: list[ParsedItem] = []
    line = 0

    for row_html in _ROW.findall(text):
        cells = [_clean_html(c) for c in _CELL.findall(row_html)]
        cells = [c for c in cells if c != ""]
        if len(cells) < 3:
            continue

        # Название — первая ячейка, которая не число.
        name = next((c for c in cells if not _looks_numeric(c)), None)
        numbers = [c for c in cells if _looks_numeric(c)]
        if name is None or len(numbers) < 2:
            continue

        try:
            # Последнее число — сумма строки, предпоследнее — цена.
            total = money_to_minor(numbers[-1])
            unit_price = money_to_minor(numbers[-2])
            quantity = _to_float(numbers[-3]) if len(numbers) >= 3 else 1.0
        except (ReceiptParseError, ValueError):
            continue

        line += 1
        items.append(
            ParsedItem(
                line_no=line,
                raw_name=name,
                quantity=quantity or 1.0,
                unit=None,
                unit_price_minor=unit_price,
                total_minor=total,
            )
        )

    if not items:
        raise ReceiptParseError("В ответе не нашлось позиций чека")

    fiscal = _search_labeled(text, ("fiskal", "fiscal", "sənəd", "document", "чек")) \
        or fallback_id
    if not fiscal:
        raise ReceiptParseError("У чека нет номера")

    issued_raw = _search_datetime(text)
    if issued_raw is None:
        raise ReceiptParseError("У чека нет времени")

    return ParsedReceipt(
        fiscal_id=fiscal,
        issued_at=parse_datetime(issued_raw),
        total_minor=sum(i.total_minor for i in items),
        merchant_name=_search_labeled(text, ("obyekt", "şirkət", "магазин")),
        merchant_tin=_search_labeled(text, ("vöen", "voen", "tin")),
        items=items,
    )


def _clean_html(value: str) -> str:
    return html.unescape(_TAGS.sub(" ", value)).replace(" ", " ").strip()


def _looks_numeric(value: str) -> bool:
    return bool(re.fullmatch(r"-?\d+([.,]\d+)?", value.replace(" ", "")))


def _to_float(value: object) -> float:
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).strip().replace(",", ".").replace(" ", "")
    try:
        return float(text)
    except ValueError:
        return 1.0


def _str_or_none(value: object) -> str | None:
    if value is None:
        return None
    text = str(value).strip()
    return text or None


def _clean_ean(value: object) -> str | None:
    if value is None:
        return None
    digits = re.sub(r"\D", "", str(value))
    return digits if 8 <= len(digits) <= 14 else None


def _search_labeled(text: str, labels: tuple[str, ...]) -> str | None:
    """Значение рядом с подписью: «VÖEN: 1234567890»."""
    plain = _clean_html(text)
    for label in labels:
        m = re.search(
            rf"{re.escape(label)}\s*[:№#]?\s*([A-Za-z0-9\-]{{4,40}})",
            plain,
            re.I,
        )
        if m:
            return m.group(1)
    return None


def _search_datetime(text: str) -> str | None:
    plain = _clean_html(text)
    m = re.search(r"\d{2}\.\d{2}\.\d{4}[ T]\d{2}:\d{2}(:\d{2})?", plain)
    if m:
        return m.group(0)
    m = re.search(r"\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}(:\d{2})?", plain)
    return m.group(0) if m else None

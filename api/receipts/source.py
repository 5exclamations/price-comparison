"""Проверка ссылки с QR и загрузка страницы чека.

Здесь два разных вопроса, и путать их нельзя.

**Первый — безопасность.** Клиент присылает URL, а ходит по нему НАШ сервер.
Это классический SSRF: без проверки любой желающий заставит наш бэкенд
постучаться во внутреннюю сеть, в облачные метаданные или в чужой хост и
принести ответ. Поэтому хост сверяется с белым списком доменов e-kassa, схема
только https, а перенаправления запрещены — редирект на localhost обошёл бы
проверку хоста, сделанную до запроса.

**Второй — формат ответа.** Портал живой, но публичной страницы чека я не
нашёл: `monitoring.e-kassa.gov.az` оказался консолью операторов и налоговых
инспекторов (маршруты /admin, /inspector, /companies, вход по логину), а его
единственный API ведёт на сервис обновления прошивок. Настоящего чека с QR у
меня нет, поэтому точный ответ портала не подтверждён.

Отсюда устройство модуля: загрузка отделена от разбора. [ReceiptFetcher] —
это то, что надо будет подправить под реальный ответ, и правка сводится к
одному методу. Всё остальное — проверка ссылки, разбор, дедупликация,
согласие, баллы, обезличивание — от формата не зависит и проверено тестами.
"""
from __future__ import annotations

import ipaddress
import socket
from dataclasses import dataclass
from typing import Protocol
from urllib.parse import parse_qs, urlparse

# Домены портала. Только эти, только https.
ALLOWED_HOSTS = {
    "e-kassa.gov.az",
    "www.e-kassa.gov.az",
    "monitoring.e-kassa.gov.az",
}

# Разумный потолок: страница чека — это килобайты, а не мегабайты.
MAX_BYTES = 512 * 1024
TIMEOUT_SECONDS = 10


class ReceiptUrlError(ValueError):
    """Ссылка не похожа на чек e-kassa."""


@dataclass(frozen=True)
class ReceiptRef:
    """Разобранная ссылка с QR."""

    url: str

    #: Идентификатор документа из ссылки. Он же ложится в fiscal_id, если
    #: сам чек не назовёт номер иначе.
    doc_id: str


def parse_receipt_url(raw: str) -> ReceiptRef:
    """Проверить ссылку и вытащить идентификатор документа.

    Бросает [ReceiptUrlError] на всём, что не является ссылкой на портал.
    Никаких «попробуем всё равно»: сходить по чужому адресу с нашего сервера
    хуже, чем отказать пользователю.
    """
    raw = (raw or "").strip()
    if not raw:
        raise ReceiptUrlError("Пустая ссылка")
    if len(raw) > 2000:
        raise ReceiptUrlError("Ссылка подозрительно длинная")

    parsed = urlparse(raw)

    if parsed.scheme != "https":
        raise ReceiptUrlError("Только https")

    host = (parsed.hostname or "").lower()
    if host not in ALLOWED_HOSTS:
        raise ReceiptUrlError(f"Чужой хост: {host or 'не указан'}")

    # Порт не подменяем: 443 или ничего.
    if parsed.port not in (None, 443):
        raise ReceiptUrlError("Нестандартный порт")

    doc = _extract_doc_id(parsed.query, parsed.fragment, parsed.path)
    if not doc:
        raise ReceiptUrlError("В ссылке нет идентификатора чека")

    return ReceiptRef(url=raw, doc_id=doc)


def _extract_doc_id(query: str, fragment: str, path: str) -> str | None:
    """Найти идентификатор документа.

    Ссылка с чека — это SPA-адрес, и параметры у него могут оказаться и в
    query, и во фрагменте после #. Смотрим в обоих местах, потом в пути.
    """
    for source in (query, fragment):
        if not source:
            continue
        # Во фрагменте вида "/index?doc=ABC" параметры идут после '?'
        candidate = source.split("?", 1)[-1] if "?" in source else source
        params = parse_qs(candidate, keep_blank_values=False)
        for key in ("doc", "docId", "documentId", "id"):
            values = params.get(key)
            if values and values[0].strip():
                return values[0].strip()

    # Последний вариант: идентификатор последним сегментом пути.
    tail = [p for p in path.split("/") if p]
    if tail and len(tail[-1]) >= 6:
        return tail[-1]
    return None


def is_public_address(host: str) -> bool:
    """Резолвится ли хост в публичный адрес.

    Проверка хоста по имени недостаточна: DNS может указывать на 127.0.0.1 или
    на адрес внутри VPC. Это тот же SSRF, только через DNS.
    """
    try:
        infos = socket.getaddrinfo(host, 443, proto=socket.IPPROTO_TCP)
    except OSError:
        return False

    for info in infos:
        addr = ipaddress.ip_address(info[4][0])
        if (
            addr.is_private
            or addr.is_loopback
            or addr.is_link_local
            or addr.is_reserved
            or addr.is_multicast
            or addr.is_unspecified
        ):
            return False
    return True


class ReceiptFetcher(Protocol):
    """Загрузчик страницы чека.

    ЕДИНСТВЕННОЕ место, которое надо будет подправить, когда станет известен
    настоящий ответ портала.
    """

    async def fetch(self, ref: ReceiptRef) -> str: ...


class HttpReceiptFetcher:
    """Загрузка по https с портала.

    Перенаправления выключены сознательно: проверка хоста сделана ДО запроса,
    и редирект на другой адрес её бы обошёл.
    """

    def __init__(self, client=None) -> None:
        self._client = client

    async def fetch(self, ref: ReceiptRef) -> str:
        parsed = urlparse(ref.url)
        host = (parsed.hostname or "").lower()

        if not is_public_address(host):
            raise ReceiptUrlError("Хост резолвится во внутренний адрес")

        client = self._client
        if client is None:
            import httpx

            client = httpx.AsyncClient(
                timeout=TIMEOUT_SECONDS,
                follow_redirects=False,
                headers={"User-Agent": "qiymet/1.0 (+https://qiymet.az)"},
            )
            close = True
        else:
            close = False

        try:
            response = await client.get(ref.url)
            if response.status_code >= 400:
                raise ReceiptUrlError(f"Портал ответил {response.status_code}")
            body = response.text
            if len(body.encode("utf-8")) > MAX_BYTES:
                raise ReceiptUrlError("Ответ слишком большой")
            return body
        finally:
            if close:
                await client.aclose()

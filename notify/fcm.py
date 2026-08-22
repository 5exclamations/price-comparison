"""Транспорт Firebase Cloud Messaging.

Про «батчами». У HTTP v1 больше нет группового эндпоинта: /batch объявлен
устаревшим и отключён в 2024-м, а sendEach() в Admin SDK внутри просто шлёт
сообщения параллельно. Поэтому здесь батч — это пачка одиночных запросов с
ограниченным параллелизмом, а не один запрос на 500 адресатов. Это не обходной
путь, а то, как FCM работает сегодня.

Классификация ошибок важнее самой отправки. FCM отвечает по-разному, и путать
эти случаи нельзя:

  UNREGISTERED / NOT_FOUND   приложение удалили, токен мёртв   -> выключить токен
  INVALID_ARGUMENT           токен битый                       -> выключить токен
  UNAVAILABLE / INTERNAL     у Google сбой                     -> повторить позже
  QUOTA_EXCEEDED             слишком быстро шлём               -> повторить позже

Выключить токен при временной ошибке значит молча потерять пользователя
навсегда, поэтому по умолчанию всё неизвестное считается временным.

ОГОВОРКА: класс HttpV1Fcm против настоящего Google не проверялся — для этого
нужен сервисный аккаунт Firebase. Проверена вся логика вокруг: разбор ответов,
классификация ошибок, батчи, выключение токенов, повторы (см. tests/). Перед
выкатом прогоните send() на тестовом проекте Firebase.
"""
import asyncio
import logging
from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Callable, Protocol

log = logging.getLogger("notify.fcm")

FCM_ENDPOINT = "https://fcm.googleapis.com/v1/projects/{project}/messages:send"


class Verdict(str, Enum):
    OK = "ok"
    DEAD_TOKEN = "dead_token"   # выключить токен, больше не пытаться
    RETRY = "retry"             # временная беда, попробовать позже


# Коды FCM, означающие, что токен больше не адресуем.
DEAD_CODES = {
    "UNREGISTERED",
    "NOT_FOUND",
    "INVALID_ARGUMENT",
    "SENDER_ID_MISMATCH",
}

RETRY_CODES = {
    "UNAVAILABLE",
    "INTERNAL",
    "QUOTA_EXCEEDED",
    "RESOURCE_EXHAUSTED",
    "DEADLINE_EXCEEDED",
}


def classify(status_code: int, payload: dict[str, Any] | None) -> tuple[Verdict, str]:
    """Что делать с этим ответом FCM."""
    if 200 <= status_code < 300:
        return Verdict.OK, ""

    err = ((payload or {}).get("error") or {})
    code = err.get("status") or ""

    # Точная причина лежит глубже, в details: там FCM кладёт ErrorCode.
    for detail in err.get("details") or []:
        if detail.get("errorCode"):
            code = detail["errorCode"]
            break

    if code in DEAD_CODES:
        return Verdict.DEAD_TOKEN, code
    if code in RETRY_CODES:
        return Verdict.RETRY, code

    if status_code in (401, 403):
        # Протухли учётные данные сервера. Токены пользователей ни при чём —
        # выключать их было бы катастрофой.
        return Verdict.RETRY, code or f"HTTP_{status_code}"
    if status_code == 404:
        return Verdict.DEAD_TOKEN, code or "NOT_FOUND"
    if status_code == 400:
        return Verdict.DEAD_TOKEN, code or "INVALID_ARGUMENT"
    if status_code >= 500 or status_code == 429:
        return Verdict.RETRY, code or f"HTTP_{status_code}"

    # Неизвестное считаем временным: потерять пользователя навсегда хуже,
    # чем сходить в FCM ещё раз.
    return Verdict.RETRY, code or f"HTTP_{status_code}"


@dataclass
class FcmMessage:
    token: str
    title: str
    body: str
    data: dict[str, str] = field(default_factory=dict)

    def to_payload(self) -> dict[str, Any]:
        return {
            "message": {
                "token": self.token,
                "notification": {"title": self.title, "body": self.body},
                # data только строками — FCM другого не принимает
                "data": {k: str(v) for k, v in self.data.items()},
                "android": {"priority": "high"},
                "apns": {"headers": {"apns-priority": "10"}},
            }
        }


@dataclass
class FcmResult:
    token: str
    verdict: Verdict
    error_code: str = ""

    @property
    def ok(self) -> bool:
        return self.verdict is Verdict.OK


class FcmTransport(Protocol):
    async def send(self, messages: list[FcmMessage]) -> list[FcmResult]: ...


class HttpV1Fcm:
    """Отправка через FCM HTTP v1.

    access_token_provider отдаёт свежий OAuth2-токен сервисного аккаунта.
    Вынесен наружу намеренно: google-auth тянет за собой криптографию, и
    прибивать его к транспорту не за чем — тесты подставляют свою функцию.
    """

    def __init__(
        self,
        project_id: str,
        access_token_provider: Callable[[], str],
        client: Any = None,
        concurrency: int = 20,
        timeout: float = 10.0,
    ) -> None:
        self.project_id = project_id
        self._token = access_token_provider
        self._client = client
        self._sem = asyncio.Semaphore(concurrency)
        self._timeout = timeout

    async def _client_or_default(self):
        if self._client is None:
            import httpx

            self._client = httpx.AsyncClient(timeout=self._timeout)
        return self._client

    async def _send_one(self, msg: FcmMessage) -> FcmResult:
        client = await self._client_or_default()
        url = FCM_ENDPOINT.format(project=self.project_id)
        headers = {
            "Authorization": f"Bearer {self._token()}",
            "Content-Type": "application/json; UTF-8",
        }
        async with self._sem:
            try:
                resp = await client.post(url, json=msg.to_payload(), headers=headers)
            except Exception as exc:                     # сеть легла
                log.warning("FCM недоступен: %s", exc)
                return FcmResult(msg.token, Verdict.RETRY, "TRANSPORT")

        try:
            payload = resp.json()
        except Exception:
            payload = None

        verdict, code = classify(resp.status_code, payload)
        return FcmResult(msg.token, verdict, code)

    async def send(self, messages: list[FcmMessage]) -> list[FcmResult]:
        if not messages:
            return []
        return list(await asyncio.gather(*(self._send_one(m) for m in messages)))


class CollectingFcm:
    """Транспорт для тестов и сухого прогона: ничего не шлёт, всё запоминает.

    responses задаёт вердикт по токену, чтобы проверять обработку мёртвых
    токенов и повторов, не поднимая Firebase.
    """

    def __init__(self, responses: dict[str, FcmResult] | None = None) -> None:
        self.sent: list[FcmMessage] = []
        self.batches: list[int] = []
        self._responses = responses or {}

    async def send(self, messages: list[FcmMessage]) -> list[FcmResult]:
        self.sent.extend(messages)
        self.batches.append(len(messages))
        return [
            self._responses.get(m.token, FcmResult(m.token, Verdict.OK))
            for m in messages
        ]

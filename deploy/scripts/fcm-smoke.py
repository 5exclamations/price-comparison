#!/usr/bin/env python3
"""Проверка FCM против настоящего Google.

Зачем отдельный скрипт. Вся отправка до сих пор проверялась на моках:
`CollectingFcm` возвращает заранее заданные вердикты, и тесты убеждаются, что
воркер правильно на них реагирует. Чего моки НЕ проверяют — что настоящий FCM
отвечает именно теми кодами, которые мы разбираем в `classify()`. Разница
вылезет в тот день, когда у половины пользователей окажутся мёртвые токены,
а мы будем считать их живыми и слать в пустоту.

Что делает скрипт:

  1. посылает настоящий пуш на настоящий токен устройства;
  2. посылает заведомо мусорный токен и смотрит, что FCM отвечает
     UNREGISTERED/INVALID_ARGUMENT, а `classify()` называет это DEAD_TOKEN;
  3. посылает с испорченным OAuth-токеном и смотрит, что 401 попадает
     в RETRY, а НЕ в DEAD_TOKEN — иначе первая же протухшая учётка сервера
     выключит токены всех пользователей разом;
  4. печатает сводку: что ответил Google и что из этого сделал разбор.

Случай 429 (слишком часто) искусственно не воспроизводится: чтобы получить
его от Google честно, надо реально выйти за квоту. Проверяется по-другому —
`classify(429, None)` вызывается напрямую, и это ровно та же функция, что
разбирает живой ответ.

Запуск:

  export QIYMET_FCM_PROJECT_ID=qiymet-test
  export GOOGLE_APPLICATION_CREDENTIALS=/path/fcm-service-account.json
  python3 deploy/scripts/fcm-smoke.py --token '<токен устройства>'

Токен устройства берётся из приложения: он приходит в /v1/devices при
регистрации, либо печатается в консоль при отладочной сборке.

Отдельный проект Firebase, а не боевой: скрипт шлёт настоящий пуш, и на
боевом проекте он прилетит настоящему человеку.
"""
from __future__ import annotations

import argparse
import asyncio
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", ".."))

from notify.fcm import FcmMessage, HttpV1Fcm, Verdict, classify  # noqa: E402

# Мусорный токен нужного вида: длина и алфавит правдоподобные, поэтому FCM
# отвечает не «неверный формат», а «такого получателя нет» — то есть ровно
# тем кодом, который приходит на удалённое приложение.
GARBAGE_TOKEN = (
    "fPmA8k2vQ0yTn3XcJlLdRe:APA91bF" + "x" * 100 + "_qiymet_smoke_test"
)


def _google_token_provider():
    from google.auth.transport.requests import Request
    from google.oauth2 import service_account

    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"],
        scopes=["https://www.googleapis.com/auth/firebase.messaging"],
    )

    def token() -> str:
        if not creds.valid:
            creds.refresh(Request())
        return creds.token

    return token


async def main() -> int:
    ap = argparse.ArgumentParser(prog="fcm-smoke")
    ap.add_argument("--token", required=True, help="Настоящий токен устройства")
    ap.add_argument(
        "--skip-real",
        action="store_true",
        help="Не слать настоящий пуш, проверить только классификацию ошибок",
    )
    args = ap.parse_args()

    project = os.environ.get("QIYMET_FCM_PROJECT_ID")
    if not project:
        print("QIYMET_FCM_PROJECT_ID не задан — проверять нечего")
        return 1
    if "prod" in project:
        print(f"Проект {project} похож на боевой. Скрипт шлёт настоящий пуш —")
        print("возьми тестовый проект Firebase, иначе прилетит живому человеку.")
        return 1

    provider = _google_token_provider()
    fcm = HttpV1Fcm(project_id=project, access_token_provider=provider)

    results: list[tuple[str, str, str]] = []   # что проверяли, ждали, получили

    # --- 1. живой токен --------------------------------------------------------
    if not args.skip_real:
        msg = FcmMessage(
            token=args.token,
            title="qiymət: проверка",
            body="Süd 2.5% подешевело до 1,89 ₼ в Araz",
            data={"product_id": "1", "smoke": "1"},
        )
        [res] = await fcm.send([msg])
        results.append(
            ("живой токен", "OK", f"{res.verdict.name} {res.error_code}".strip())
        )
        if res.verdict is not Verdict.OK:
            print("  Пуш не ушёл. Смотри код выше: 403 обычно значит, что в")
            print("  проекте не включён Firebase Cloud Messaging API.")

    # --- 2. мёртвый токен ------------------------------------------------------
    [res] = await fcm.send([FcmMessage(GARBAGE_TOKEN, "x", "x")])
    results.append(
        ("мёртвый токен", "DEAD_TOKEN", f"{res.verdict.name} {res.error_code}".strip())
    )

    # --- 3. протухшая учётка сервера -------------------------------------------
    # Самый важный случай. Если 401 уедет в DEAD_TOKEN, одна протухшая учётка
    # сервера выключит токены ВСЕХ пользователей — и обратно их не вернуть,
    # приложение перерегистрирует токен только при переустановке.
    broken = HttpV1Fcm(project_id=project, access_token_provider=lambda: "не-токен")
    [res] = await broken.send([FcmMessage(args.token, "x", "x")])
    results.append(
        ("битый OAuth", "RETRY", f"{res.verdict.name} {res.error_code}".strip())
    )

    # --- 4. 429 напрямую через разбор -------------------------------------------
    verdict, code = classify(429, {"error": {"status": "RESOURCE_EXHAUSTED"}})
    results.append(("429 (через classify)", "RETRY", f"{verdict.name} {code}"))

    verdict, code = classify(500, None)
    results.append(("500 (через classify)", "RETRY", f"{verdict.name} {code}"))

    # --- сводка ------------------------------------------------------------------
    print()
    print(f"{'случай':<26} {'ждали':<12} получили")
    print("-" * 70)
    bad = 0
    for case, expected, got in results:
        mark = "ок " if got.startswith(expected) else "НЕ ТО"
        if not got.startswith(expected):
            bad += 1
        print(f"{case:<26} {expected:<12} {got:<24} {mark}")

    print()
    if bad:
        print(f"Расхождений с моками: {bad}. Разбор ответов FCM в notify/fcm.py")
        print("описывает не то, что отвечает настоящий Google.")
        return 1

    print("Классификация ошибок совпадает с тем, что проверяют моки.")
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))

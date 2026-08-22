"""Запуск воркера и отправщика.

  python3 -m notify worker    разобрать дельты и поставить уведомления в очередь
  python3 -m notify send      отправить всё, чему пришло время
  python3 -m notify run       и то и другое: вешать сразу после прогона сбора

Порядок в cron важен: сначала сбор, потом пересборка витрин, потом уведомления.
Без свежей deal_honesty воркер не узнает про накрутку и отправит то, что обещал
не отправлять.

  0 */3 * * *  cd /srv/qiymet && python3 run.py fast \\
                 && psql -c "SELECT refresh_after_crawl()" \\
                 && python3 -m notify run
"""
import argparse
import asyncio
import logging
import os
import sys

from sqlalchemy.ext.asyncio import create_async_engine

from .fcm import CollectingFcm, HttpV1Fcm
from .sender import send_due
from .worker import run_once


def _transport():
    """Настоящий FCM, если настроен. Иначе сухой прогон с записью в лог."""
    project = os.environ.get("QIYMET_FCM_PROJECT_ID")
    if not project:
        logging.warning(
            "QIYMET_FCM_PROJECT_ID не задан — сухой прогон, ничего не отправляется"
        )
        return CollectingFcm()

    # google-auth подтягивается только когда FCM действительно настроен:
    # держать криптографию в зависимостях воркера ради сухого прогона незачем.
    from google.auth.transport.requests import Request          # noqa: PLC0415
    from google.oauth2 import service_account                    # noqa: PLC0415

    creds = service_account.Credentials.from_service_account_file(
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"],
        scopes=["https://www.googleapis.com/auth/firebase.messaging"],
    )

    def token() -> str:
        if not creds.valid:
            creds.refresh(Request())
        return creds.token

    return HttpV1Fcm(project_id=project, access_token_provider=token)


async def _main(action: str) -> int:
    url = os.environ.get(
        "QIYMET_DATABASE_URL",
        "postgresql+psycopg://qiymet@localhost:5432/qiymet",
    )
    engine = create_async_engine(url)
    try:
        async with engine.connect() as conn:
            if action in ("worker", "run"):
                async with conn.begin():
                    result = await run_once(conn)
                print(f"воркер: {result}")

            if action in ("send", "run"):
                transport = _transport()
                async with conn.begin():
                    report = await send_due(conn, transport)
                print(f"отправка: {report}")
                if isinstance(transport, CollectingFcm) and transport.sent:
                    print("\nсухой прогон, тексты уведомлений:")
                    for m in transport.sent[:20]:
                        print(f"  [{m.token[:12]}…] {m.title}: {m.body}")
    finally:
        await engine.dispose()
    return 0


def main() -> int:
    logging.basicConfig(
        level=logging.INFO, format="%(levelname)s %(name)s: %(message)s"
    )
    ap = argparse.ArgumentParser(prog="notify")
    ap.add_argument("action", choices=["worker", "send", "run"])
    args = ap.parse_args()
    return asyncio.run(_main(args.action))


if __name__ == "__main__":
    sys.exit(main())

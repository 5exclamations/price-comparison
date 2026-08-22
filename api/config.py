"""Настройки API. Всё через окружение, ничего в коде."""
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="QIYMET_", extra="ignore")

    # SQLAlchemy 2.0 async поверх psycopg3 — того же драйвера, что у миграций.
    database_url: str = "postgresql+psycopg://qiymet@localhost:5432/qiymet"

    # Пусто -> кеш работает в памяти процесса. Годится для тестов и локального
    # запуска, но не для нескольких воркеров: у каждого будет свой кеш.
    redis_url: str = ""

    cache_ttl_seconds: int = 300          # 5 минут, как просили
    cache_prefix: str = "qiymet:v1"

    # Сеть считается протухшей, если свежайшее наблюдение старше этого.
    stale_after_hours: int = 12

    default_limit: int = 20
    max_limit: int = 100

    # Порог, при котором заявленная скидка считается накрученной (в долях).
    # Держать согласованным с INFLATED_GAP в миграции 0005.
    inflated_gap: float = 0.15

    db_echo: bool = False


settings = Settings()

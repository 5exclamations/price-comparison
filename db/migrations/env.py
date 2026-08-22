"""Окружение Alembic.

Строка подключения берётся только из DATABASE_URL. В alembic.ini её нет
намеренно: иначе пароль от прода однажды уедет в git.

Моделей SQLAlchemy в проекте нет — схема описана голым SQL в versions/,
поэтому target_metadata = None и автогенерация выключена. Это осознанно:
схема пришла из работающего SQLite, и переписывать её в декларативные модели
значит потерять комментарии, в которых записаны решения.
"""
import os
from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

DATABASE_URL = os.environ.get("DATABASE_URL")
if not DATABASE_URL:
    raise SystemExit(
        "DATABASE_URL не задан.\n"
        "  export DATABASE_URL=postgresql+psycopg://user@host:5432/qiymet"
    )
config.set_main_option("sqlalchemy.url", DATABASE_URL)

target_metadata = None


def run_migrations_offline() -> None:
    context.configure(
        url=DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()

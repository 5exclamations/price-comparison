"""Подписки на товар и очередь уведомлений о падении цены.

Revision ID: 0006
Revises: 0005
Create Date: 2026-08-16

Регистрации нет: пользователь — это анонимный id устройства. Для первой версии
этого достаточно, а отсутствие почты и пароля снимает целый класс обязанностей
по персональным данным.

Три правила отправки вшиты в схему, а не только в код воркера:

  1. Не больше одного пуша в сутки на пользователя по одному товару.
     Частичный уникальный индекс не даёт положить в очередь второе ожидающее
     уведомление по той же паре, а проверка «отправляли ли за последние 24 часа»
     живёт в воркере. Полагаться только на код нельзя: воркер однажды запустят
     в двух экземплярах, и без индекса пользователь получит два пуша.

  2. Тихие часы. Момент отправки считается заранее и лежит в send_after.
     Отправщик просто берёт всё, чему пришло время, и ничего не знает про
     часовые пояса.

  3. Накрученные скидки не шлём. Это проверка воркера по deal_honesty.inflated,
     в схеме её не выразить, но след решения остаётся: в очереди хранятся и
     market_price_minor, и real_discount, по которым потом видно, что мы
     посчитали в момент отправки.
"""
from alembic import op

revision = "0006"
down_revision = "0005"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ---------- Пользователь без регистрации ----------
    op.execute(
        """
        CREATE TABLE users (
            id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            anon_id      text NOT NULL UNIQUE,
            lang         text NOT NULL DEFAULT 'az'
                         CONSTRAINT users_lang_check CHECK (lang IN ('az','ru','en')),
            timezone     text NOT NULL DEFAULT 'Asia/Baku',
            created_at   timestamptz NOT NULL DEFAULT now(),
            last_seen_at timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN users.anon_id IS "
        "'Анонимный идентификатор устройства. Генерит клиент, сервер не знает, "
        "кто это'"
    )
    op.execute(
        "COMMENT ON COLUMN users.timezone IS "
        "'Зона для тихих часов. По умолчанию Asia/Baku. Имя из базы tz, а не "
        "смещение: Азербайджан отменил переход на летнее время в 2016-м, но "
        "прибивать +04 гвоздями всё равно не стоит'"
    )

    # ---------- Токены устройств ----------
    op.execute(
        """
        CREATE TABLE device_tokens (
            id              integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id         integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            token           text NOT NULL UNIQUE,
            platform        text NOT NULL
                            CONSTRAINT device_tokens_platform_check
                            CHECK (platform IN ('ios','android')),
            created_at      timestamptz NOT NULL DEFAULT now(),
            last_success_at timestamptz,
            disabled_at     timestamptz,
            disabled_reason text
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN device_tokens.disabled_at IS "
        "'Проставляется, когда FCM ответил UNREGISTERED или INVALID_ARGUMENT. "
        "Токен не удаляем: по нему видно, почему устройство отвалилось'"
    )
    # Отправщику нужны только живые токены пользователя.
    op.execute(
        "CREATE INDEX idx_device_tokens_live ON device_tokens(user_id) "
        "WHERE disabled_at IS NULL"
    )

    # ---------- Подписки ----------
    op.execute(
        """
        CREATE TABLE watches (
            id                 integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id            integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            product_id         integer NOT NULL REFERENCES products(id),
            store_id           integer REFERENCES stores(id),
            target_price_minor integer
                               CONSTRAINT watches_target_positive
                               CHECK (target_price_minor IS NULL
                                      OR target_price_minor > 0),
            active             boolean NOT NULL DEFAULT true,
            created_at         timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN watches.store_id IS "
        "'NULL = следим за товаром во всех сетях. Для Bravo выбор магазина "
        "осмыслен: у сети четыре ценовые зоны'"
    )
    op.execute(
        "COMMENT ON COLUMN watches.target_price_minor IS "
        "'Целевая цена в гяпиках. NULL = достаточно падения на 5%'"
    )

    # Та же ловушка, что и в store_items: NULL не равен NULL, поэтому обычный
    # UNIQUE(user_id, product_id, store_id) НЕ поймает вторую подписку на тот же
    # товар «во всех сетях». Пользователь получил бы два одинаковых пуша.
    op.execute(
        """
        CREATE UNIQUE INDEX idx_watches_unique
            ON watches(user_id, product_id, COALESCE(store_id, 0))
        """
    )
    op.execute(
        "COMMENT ON INDEX idx_watches_unique IS "
        "'COALESCE обязателен: при store_id IS NULL обычный UNIQUE пропускает "
        "дубли, и пользователь получает два пуша на один товар'"
    )
    op.execute(
        "CREATE INDEX idx_watches_product ON watches(product_id) WHERE active"
    )

    # ---------- Очередь уведомлений ----------
    op.execute(
        """
        CREATE TABLE notifications (
            id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id            integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            watch_id           integer REFERENCES watches(id) ON DELETE CASCADE,
            product_id         integer NOT NULL REFERENCES products(id),
            store_item_id      integer NOT NULL REFERENCES store_items(id),
            chain_id           integer NOT NULL REFERENCES chains(id),
            store_id           integer REFERENCES stores(id),

            price_minor        integer NOT NULL,
            prev_price_minor   integer NOT NULL,
            old_price_minor    integer,
            market_price_minor integer,
            drop_pct           double precision NOT NULL,
            real_discount      double precision,

            reason             text NOT NULL
                               CONSTRAINT notifications_reason_check
                               CHECK (reason IN ('price_drop','target_hit')),
            status             text NOT NULL DEFAULT 'pending'
                               CONSTRAINT notifications_status_check
                               CHECK (status IN ('pending','sent','failed','cancelled')),

            observed_at        timestamptz NOT NULL,
            created_at         timestamptz NOT NULL DEFAULT now(),
            send_after         timestamptz NOT NULL,
            sent_at            timestamptz,
            attempts           integer NOT NULL DEFAULT 0,
            last_error         text
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN notifications.send_after IS "
        "'Момент, начиная с которого можно слать. Тихие часы уже учтены здесь, "
        "поэтому отправщик про часовые пояса ничего не знает'"
    )
    op.execute(
        "COMMENT ON COLUMN notifications.prev_price_minor IS "
        "'Цена, которую мы видели своими глазами в прошлом наблюдении, а не та, "
        "что заявлена на ценнике'"
    )

    # Не больше одного ОЖИДАЮЩЕГО уведомления на пару пользователь-товар.
    # Если за время ожидания цена упала ещё ниже, воркер обновляет эту же строку,
    # а не кладёт вторую.
    op.execute(
        """
        CREATE UNIQUE INDEX idx_notifications_one_pending
            ON notifications(user_id, product_id)
            WHERE status = 'pending'
        """
    )
    # Выборка отправщика: что уже пора слать.
    op.execute(
        """
        CREATE INDEX idx_notifications_due
            ON notifications(send_after)
            WHERE status = 'pending'
        """
    )
    # Проверка «слали ли за последние сутки».
    op.execute(
        """
        CREATE INDEX idx_notifications_recent_sent
            ON notifications(user_id, product_id, sent_at DESC)
            WHERE status = 'sent'
        """
    )

    # ---------- Водяной знак воркера ----------
    op.execute(
        """
        CREATE TABLE worker_state (
            worker     text PRIMARY KEY,
            watermark  timestamptz NOT NULL,
            updated_at timestamptz NOT NULL DEFAULT now(),
            last_run_deltas   integer NOT NULL DEFAULT 0,
            last_run_queued   integer NOT NULL DEFAULT 0
        )
        """
    )
    op.execute(
        "COMMENT ON TABLE worker_state IS "
        "'Докуда воркер уже разобрал price_observations. Дельты берутся по "
        "этому знаку, а не опросом в цикле'"
    )


def downgrade() -> None:
    op.execute("DROP TABLE IF EXISTS worker_state")
    op.execute("DROP TABLE IF EXISTS notifications")
    op.execute("DROP TABLE IF EXISTS watches")
    op.execute("DROP TABLE IF EXISTS device_tokens")
    op.execute("DROP TABLE IF EXISTS users")

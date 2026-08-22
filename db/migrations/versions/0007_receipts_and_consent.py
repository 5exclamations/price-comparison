"""Чеки из фискальных касс, согласие на обработку и баллы.

Revision ID: 0007
Revises: 0006
Create Date: 2026-08-17

Зачем отдельные таблицы, а не сразу price_observations. Чек — другой источник,
и он лучше витрины: там цена, по которой товар реально пробили на кассе. Но у
него другая природа ошибок (человек мог сфотографировать чужой чек, портал мог
отдать неполный состав) и, главное, другой правовой статус: это персональные
данные конкретного человека. Смешивать их с публичным скрейпингом в одной
таблице значит терять и то и другое.

Поэтому: receipts + receipt_items хранят данные КАК ЕСТЬ и со ссылкой на
пользователя, а в общий пул price_observations уходит обезличенная выжимка с
source = 'receipt' и без единой ссылки назад.

Правовая часть — закон Азербайджанской Республики «О персональных данных»:
согласие явное и версионированное, отзыв в один шаг, удаление чеков по
требованию, обезличивание до попадания в общую аналитику.
"""
from alembic import op

revision = "0007"
down_revision = "0006"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ---------- согласие ----------
    #
    # Версия обязательна. Текст согласия меняется, и «человек когда-то что-то
    # нажал» — не согласие. При смене версии спрашиваем заново.
    op.execute(
        """
        CREATE TABLE consents (
            id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id      integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            kind         text NOT NULL
                         CONSTRAINT consents_kind_check
                         CHECK (kind IN ('receipts')),
            version      integer NOT NULL,
            granted_at   timestamptz NOT NULL DEFAULT now(),
            revoked_at   timestamptz,

            -- Что именно человек видел на экране, когда соглашался. Без этого
            -- невозможно доказать, на что он согласился.
            text_digest  text NOT NULL,
            locale       text NOT NULL
        )
        """
    )
    op.execute(
        "COMMENT ON COLUMN consents.text_digest IS "
        "'Хеш текста согласия, который был показан. Меняется текст — меняется "
        "хеш, и согласие спрашивается заново'"
    )
    # Действующее согласие одного вида у пользователя может быть только одно.
    op.execute(
        """
        CREATE UNIQUE INDEX idx_consents_active
            ON consents(user_id, kind)
            WHERE revoked_at IS NULL
        """
    )
    op.execute("CREATE INDEX idx_consents_user ON consents(user_id)")

    # ---------- чеки ----------
    op.execute(
        """
        CREATE TABLE receipts (
            id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id        integer REFERENCES users(id) ON DELETE SET NULL,

            -- Уникальный номер чека с портала. По нему и ловим повторы.
            fiscal_id      text NOT NULL,

            -- Ссылка из QR, как её прислал клиент. Хранится для разбора
            -- спорных случаев; никуда не показывается.
            source_url     text NOT NULL,

            -- Сеть, если магазин удалось узнать. NULL — магазин не наш, и это
            -- нормально: такие чеки бесплатно расширяют покрытие.
            chain_id       integer REFERENCES chains(id),
            store_id       integer REFERENCES stores(id),

            -- Как магазин назван в самом чеке. Для незнакомых сетей это
            -- единственное, что у нас есть.
            merchant_name  text,
            merchant_tin   text,

            -- Когда пробили чек. Не когда загрузили: это разные времена, и
            -- цена относится к первому.
            issued_at      timestamptz NOT NULL,
            total_minor    integer NOT NULL,

            status         text NOT NULL DEFAULT 'parsed'
                           CONSTRAINT receipts_status_check
                           CHECK (status IN ('parsed','failed','revoked')),
            parse_error    text,

            uploaded_at    timestamptz NOT NULL DEFAULT now(),

            -- Отметка обезличенного переноса в общий пул. Ставится один раз.
            promoted_at    timestamptz
        )
        """
    )
    op.execute(
        "COMMENT ON TABLE receipts IS "
        "'Чеки, загруженные пользователями. Персональные данные: обрабатываются "
        "только при действующем согласии, удаляются по требованию'"
    )
    # Один и тот же чек не загружаем дважды — ни этим пользователем, ни другим.
    # Фискальный номер уникален глобально, и это свойство самого чека.
    op.execute("CREATE UNIQUE INDEX idx_receipts_fiscal ON receipts(fiscal_id)")
    op.execute("CREATE INDEX idx_receipts_user ON receipts(user_id, uploaded_at DESC)")
    op.execute(
        "CREATE INDEX idx_receipts_unpromoted ON receipts(issued_at) "
        "WHERE promoted_at IS NULL AND status = 'parsed'"
    )

    op.execute(
        """
        CREATE TABLE receipt_items (
            id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            receipt_id   bigint NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
            line_no      integer NOT NULL,

            raw_name     text NOT NULL,
            norm_name    text NOT NULL,

            -- Штрихкод, если касса его печатает. Печатают не все.
            ean          text,

            quantity     double precision NOT NULL DEFAULT 1,
            unit         text,

            -- Деньги целыми гяпиками, как и везде.
            unit_price_minor  integer NOT NULL,
            total_minor       integer NOT NULL,

            -- Ставится матчером, изначально NULL. Тот же путь, что у позиций
            -- из скрейпинга.
            product_id   integer REFERENCES products(id),

            CONSTRAINT receipt_items_line_key UNIQUE (receipt_id, line_no)
        )
        """
    )
    op.execute(
        "CREATE INDEX idx_receipt_items_product ON receipt_items(product_id)"
    )
    op.execute(
        "CREATE INDEX idx_receipt_items_ean ON receipt_items(ean) "
        "WHERE ean IS NOT NULL"
    )
    op.execute(
        """
        CREATE INDEX idx_receipt_items_norm_trgm
            ON receipt_items USING gin (qiymet_norm(norm_name) gin_trgm_ops)
        """
    )

    # ---------- баллы ----------
    #
    # Журнал, а не счётчик: начисления должны быть объяснимы. «У вас 40 баллов»
    # без истории — это число, которому нечем возразить.
    op.execute(
        """
        CREATE TABLE point_events (
            id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            user_id    integer NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            points     integer NOT NULL,
            reason     text NOT NULL
                       CONSTRAINT point_events_reason_check
                       CHECK (reason IN (
                           'receipt_uploaded',
                           'receipt_new_store',
                           'receipt_revoked'
                       )),
            receipt_id bigint REFERENCES receipts(id) ON DELETE SET NULL,
            created_at timestamptz NOT NULL DEFAULT now()
        )
        """
    )
    op.execute(
        "COMMENT ON TABLE point_events IS "
        "'Журнал баллов. Начисления только добавляются: отзыв согласия пишет "
        "отдельную строку со знаком минус, а не правит прошлые'"
    )
    op.execute(
        "CREATE INDEX idx_point_events_user ON point_events(user_id, created_at DESC)"
    )
    # Одна загрузка — одно начисление, даже если запрос повторили.
    op.execute(
        """
        CREATE UNIQUE INDEX idx_point_events_once
            ON point_events(receipt_id, reason)
            WHERE receipt_id IS NOT NULL
        """
    )

    op.execute(
        """
        CREATE VIEW user_points AS
        SELECT u.id AS user_id,
               coalesce(sum(pe.points), 0)::int AS points
        FROM users u
        LEFT JOIN point_events pe ON pe.user_id = u.id
        GROUP BY u.id
        """
    )

    # ---------- обезличенный перенос в общий пул ----------
    #
    # Здесь и происходит обезличивание: в price_observations уходит цена,
    # магазин и время — и ни одного поля, ведущего к человеку. Обратной
    # ссылки на receipt_id тоже нет намеренно: она сделала бы обезличивание
    # обратимым одним join-ом.
    #
    # Время округляется до часа. Точная минута покупки вместе с редким товаром
    # — это уже почти отпечаток: по ней можно узнать человека, зная, когда он
    # был в магазине. Часа достаточно, чтобы цена оставалась осмысленной.
    op.execute(
        """
        CREATE FUNCTION promote_receipt_items(p_receipt_id bigint)
        RETURNS integer
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_store_id integer;
            v_chain_id integer;
            v_issued   timestamptz;
            v_count    integer := 0;
        BEGIN
            SELECT store_id, chain_id, date_trunc('hour', issued_at)
              INTO v_store_id, v_chain_id, v_issued
            FROM receipts
            WHERE id = p_receipt_id
              AND status = 'parsed'
              AND promoted_at IS NULL;

            IF NOT FOUND THEN
                RETURN 0;
            END IF;

            -- Позиции без сопоставленного товара не переносим: цена без
            -- товара никому не поможет, а угадывать нельзя.
            INSERT INTO price_observations
                (store_item_id, price, available, observed_at, source)
            SELECT si.id,
                   ri.unit_price_minor,
                   1,
                   v_issued,
                   'receipt'
            FROM receipt_items ri
            JOIN store_items si
              ON si.product_id = ri.product_id
             AND si.chain_id = v_chain_id
             AND coalesce(si.store_id, 0) = coalesce(v_store_id, 0)
            WHERE ri.receipt_id = p_receipt_id
              AND ri.product_id IS NOT NULL
              AND v_chain_id IS NOT NULL;

            GET DIAGNOSTICS v_count = ROW_COUNT;

            UPDATE receipts SET promoted_at = now() WHERE id = p_receipt_id;
            RETURN v_count;
        END;
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION promote_receipt_items(bigint) IS "
        "'Обезличенный перенос позиций чека в общий пул наблюдений. Ссылки на "
        "пользователя и на сам чек не переносятся, время округляется до часа'"
    )

    # ---------- удаление по требованию ----------
    op.execute(
        """
        CREATE FUNCTION forget_user_receipts(p_user_id integer)
        RETURNS integer
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_count integer;
        BEGIN
            SELECT count(*) INTO v_count FROM receipts WHERE user_id = p_user_id;

            -- Позиции уедут каскадом. Обезличенные наблюдения остаются: они
            -- больше не персональные данные, и в тексте согласия это сказано
            -- прямо.
            DELETE FROM receipts WHERE user_id = p_user_id;

            INSERT INTO point_events (user_id, points, reason)
            SELECT p_user_id, -coalesce(sum(points), 0), 'receipt_revoked'
            FROM point_events
            WHERE user_id = p_user_id AND reason <> 'receipt_revoked';

            RETURN v_count;
        END;
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION forget_user_receipts(integer) IS "
        "'Удалить все чеки пользователя и списать начисленные за них баллы. "
        "Обезличенные наблюдения остаются — они уже не персональные данные, "
        "и текст согласия про это говорит прямо'"
    )


def downgrade() -> None:
    op.execute("DROP FUNCTION IF EXISTS forget_user_receipts(integer)")
    op.execute("DROP FUNCTION IF EXISTS promote_receipt_items(bigint)")
    op.execute("DROP VIEW IF EXISTS user_points")
    op.execute("DROP TABLE IF EXISTS point_events")
    op.execute("DROP TABLE IF EXISTS receipt_items")
    op.execute("DROP TABLE IF EXISTS receipts")
    op.execute("DROP TABLE IF EXISTS consents")

"""История метрик качества данных.

Revision ID: 0008
Revises: 0007
Create Date: 2026-08-17

Нужна ради одной проверки: «число межсетевых склеек не упало больше чем на 10%
относительно прошлого прогона». Сравнивать не с чем, если прошлый прогон нигде
не записан.

Заодно из этой же таблицы читает /v1/health: если проверки качества упали на
проде, приложение обязано показать плашку «данные обновляются», а не молча
показывать подозрительные цифры. Плашка берётся отсюда, а не из логов CI.

Таблица append-only, как и всё остальное про наблюдения: строки только
добавляются. По ней видно не только текущее состояние, но и когда именно
что-то поехало.
"""
from alembic import op

revision = "0008"
down_revision = "0007"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        CREATE TABLE dq_runs (
            id                integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            started_at        timestamptz NOT NULL DEFAULT now(),

            -- Метрики. Числа, а не «прошло/не прошло»: порог может измениться,
            -- а история должна остаться сравнимой.
            products          integer NOT NULL,
            store_items       integer NOT NULL,

            -- Товары, склеенные минимум из двух сетей. Тихая потеря склеек —
            -- самый незаметный способ убить продукт: цены на месте, сравнивать
            -- стало нечего.
            cross_chain_merges integer NOT NULL,

            -- Доля позиций с распознанной фасовкой, в долях.
            packaging_ratio   double precision NOT NULL,

            -- Возраст самых свежих данных, часы, по худшей сети.
            worst_age_hours   double precision,

            -- Сводный вердикт и подробности упавших проверок.
            passed            boolean NOT NULL,
            failures          jsonb NOT NULL DEFAULT '[]'::jsonb,

            -- Что это был за прогон: CI или после сбора.
            source            text NOT NULL DEFAULT 'ci'
                              CONSTRAINT dq_runs_source_check
                              CHECK (source IN ('ci', 'crawl', 'manual'))
        )
        """
    )
    op.execute(
        "COMMENT ON TABLE dq_runs IS "
        "'История метрик качества данных. Нужна проверке «склейки не упали на "
        "10%» и плашке «данные обновляются» в приложении'"
    )
    op.execute("CREATE INDEX idx_dq_runs_recent ON dq_runs(started_at DESC)")

    # Метрики считаются одним запросом: он же используется и проверками,
    # и health-эндпоинтом. Две реализации разошлись бы через месяц.
    op.execute(
        """
        CREATE FUNCTION dq_metrics()
        RETURNS TABLE (
            products integer,
            store_items integer,
            cross_chain_merges integer,
            packaging_ratio double precision,
            worst_age_hours double precision
        )
        LANGUAGE sql
        STABLE
        AS $$
            SELECT
                (SELECT count(*)::int FROM products WHERE quarantined = 0),
                (SELECT count(*)::int FROM store_items),
                (SELECT count(*)::int FROM (
                    SELECT si.product_id
                    FROM store_items si
                    JOIN products p ON p.id = si.product_id
                    WHERE p.quarantined = 0
                    GROUP BY si.product_id
                    HAVING count(DISTINCT si.chain_id) >= 2
                 ) m),
                -- Распознанной считается позиция, у которой известен тип
                -- единицы, а для невесовых ещё и число. Весовой товар без
                -- числа — это НЕ поломка разбора: у него фасовки нет по
                -- природе, цена за килограмм.
                (SELECT coalesce(
                    avg(CASE WHEN unit_type IS NOT NULL
                              AND (unit_type = 'kg_bulk' OR unit_value IS NOT NULL)
                             THEN 1.0 ELSE 0.0 END), 0)
                 FROM store_items),
                (SELECT max(extract(epoch FROM (now() - last_seen)) / 3600.0)
                 FROM (
                    SELECT c.id, max(cp.observed_at) AS last_seen
                    FROM chains c
                    LEFT JOIN store_items si ON si.chain_id = c.id
                    LEFT JOIN current_prices cp ON cp.store_item_id = si.id
                    GROUP BY c.id
                 ) ages)
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION dq_metrics() IS "
        "'Метрики качества данных. Один источник и для CI-проверок, и для "
        "/v1/health: две реализации разошлись бы через месяц'"
    )

    # Последний прогон — то, с чем сравнивается текущий и что читает health.
    op.execute(
        """
        CREATE VIEW dq_latest AS
        SELECT * FROM dq_runs ORDER BY started_at DESC LIMIT 1
        """
    )


def downgrade() -> None:
    op.execute("DROP VIEW IF EXISTS dq_latest")
    op.execute("DROP FUNCTION IF EXISTS dq_metrics()")
    op.execute("DROP TABLE IF EXISTS dq_runs")

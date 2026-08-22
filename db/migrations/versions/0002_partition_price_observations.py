"""Помесячные секции price_observations и функции их создания.

Revision ID: 0002
Revises: 0001
Create Date: 2026-08-16

Зачем. Шесть сетей, прогон каждые 2-4 часа, 57 тыс. позиций. Пайплайн пишет
наблюдение только когда цена изменилась (add_price в pipeline.py), но за год
это всё равно десятки миллионов строк. Запрос «текущая цена» не должен читать
историю целиком.

Ключ секционирования — observed_at, границы в UTC. Месяц здесь всегда месяц UTC,
а не бакинский: иначе границы поехали бы при смене TimeZone у сессии.

Пустая секция DEFAULT стоит страховкой: без неё INSERT с датой вне известных
секций падает, и ночной прогон молча теряет данные. Но держать её надо пустой —
при создании новой секции Postgres сканирует DEFAULT под ACCESS EXCLUSIVE, чтобы
убедиться, что там нет строк из нового диапазона. Пустая сканируется мгновенно.
Проверка наполнения — во вьюхе price_partitions_health ниже.
"""
from alembic import op

revision = "0002"
down_revision = "0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Создаёт одну помесячную секцию. Идемпотентна: повторный вызов ничего не делает.
    op.execute(
        """
        CREATE FUNCTION ensure_price_partition(p_month date)
        RETURNS text
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_start date := date_trunc('month', p_month)::date;
            v_end   date := (date_trunc('month', p_month) + interval '1 month')::date;
            v_name  text := format('price_observations_y%sm%s',
                                   to_char(v_start, 'YYYY'), to_char(v_start, 'MM'));
        BEGIN
            IF to_regclass(format('public.%I', v_name)) IS NOT NULL THEN
                RETURN v_name;
            END IF;

            EXECUTE format(
                'CREATE TABLE %I PARTITION OF price_observations '
                'FOR VALUES FROM (%L) TO (%L)',
                v_name,
                to_char(v_start, 'YYYY-MM-DD') || ' 00:00:00+00',
                to_char(v_end,   'YYYY-MM-DD') || ' 00:00:00+00');

            RETURN v_name;
        END;
        $$
        """
    )
    op.execute(
        "COMMENT ON FUNCTION ensure_price_partition(date) IS "
        "'Создаёт помесячную секцию price_observations, если её ещё нет. "
        "Границы в UTC. Идемпотентна'"
    )

    # Диапазон секций разом.
    op.execute(
        """
        CREATE FUNCTION ensure_price_partitions(p_from date, p_to date)
        RETURNS integer
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_cur date := date_trunc('month', p_from)::date;
            v_end date := date_trunc('month', p_to)::date;
            v_n   integer := 0;
        BEGIN
            WHILE v_cur <= v_end LOOP
                PERFORM ensure_price_partition(v_cur);
                v_cur := (v_cur + interval '1 month')::date;
                v_n := v_n + 1;
            END LOOP;
            RETURN v_n;
        END;
        $$
        """
    )

    # Держать секции «на вырост». Вешать на тот же cron, что и прогон сбора:
    #   SELECT ensure_price_partitions_ahead(3);
    # Дешевле, чем ловить упавший ночной прогон первого числа месяца.
    op.execute(
        """
        CREATE FUNCTION ensure_price_partitions_ahead(p_months integer DEFAULT 3)
        RETURNS integer
        LANGUAGE sql
        AS $$
            SELECT ensure_price_partitions(
                current_date,
                (current_date + make_interval(months => p_months))::date);
        $$
        """
    )

    # Секция-страховка. Должна оставаться пустой.
    op.execute(
        "CREATE TABLE price_observations_default "
        "PARTITION OF price_observations DEFAULT"
    )
    op.execute(
        "COMMENT ON TABLE price_observations_default IS "
        "'Страховка от INSERT с датой вне известных секций. Обязана быть пустой: "
        "непустая тормозит создание новых секций и означает, что "
        "ensure_price_partitions_ahead() не вызывается'"
    )

    # Окно секций на старте: прошлый месяц (на случай досбора истории) и полгода вперёд.
    op.execute(
        """
        SELECT ensure_price_partitions(
            (date_trunc('month', current_date) - interval '1 month')::date,
            (date_trunc('month', current_date) + interval '6 months')::date)
        """
    )

    # Что мониторить: строки в DEFAULT и когда кончатся заготовленные секции.
    op.execute(
        """
        CREATE VIEW price_partitions_health AS
        SELECT c.relname                                   AS partition,
               pg_get_expr(c.relpartbound, c.oid)          AS bounds,
               c.relname = 'price_observations_default'    AS is_default,
               pg_total_relation_size(c.oid)               AS bytes,
               c.reltuples::bigint                         AS approx_rows
        FROM pg_class c
        JOIN pg_inherits i ON i.inhrelid = c.oid
        WHERE i.inhparent = 'price_observations'::regclass
        ORDER BY c.relname
        """
    )
    op.execute(
        "COMMENT ON VIEW price_partitions_health IS "
        "'Состав секций price_observations. Тревога, если approx_rows > 0 "
        "у price_observations_default'"
    )


def downgrade() -> None:
    op.execute("DROP VIEW IF EXISTS price_partitions_health")
    op.execute("DROP FUNCTION IF EXISTS ensure_price_partitions_ahead(integer)")
    op.execute("DROP FUNCTION IF EXISTS ensure_price_partitions(date, date)")
    op.execute("DROP FUNCTION IF EXISTS ensure_price_partition(date)")
    # Сами секции не удаляем: в них лежат данные. Их снесёт DROP TABLE
    # price_observations в downgrade 0001.

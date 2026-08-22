#!/usr/bin/env bash
#
# Сторож данных. Раз в час.
#
# Три вопроса, на каждый — свой алерт:
#
#   1. Не протухла ли ТОЧКА (свежайшее наблюдение старше 12 часов).
#      Именно точка, а не сеть: сбор молча переживает потерю одного магазина,
#      и у Bravo с четырьмя ценовыми зонами это не видно по сети вовсе.
#   2. Не упал ли последний прогон проверок данных.
#   3. МЕНЯЮТСЯ ли цены вообще.
#
# Третья проверка — про то, чего ещё ни разу не было. Пайплайн до сих пор не
# работал по расписанию: истории цен нет, она начнёт копиться только сейчас.
# Сбор, который исправно пишет наблюдения, но ни одно из них не отличается от
# предыдущего, выглядит совершенно здоровым: возраст данных свежий, проверки
# проходят, в логах пусто. А продукта нет — сравнивать нечего.
#
# Поэтому со вторых суток жизни считаем дельты за последние 24 часа. Ноль
# дельт при непустом сборе значит, что сравнение цен сломалось: либо сеть
# отдаёт одно и то же, либо мы перестали замечать разницу.
# -e: любая необработанная ошибка останавливает скрипт. -E: ловушка ERR из
# lib.sh работает и внутри функций. Без -e упавший шаг шёл дальше, и прогон
# заканчивался успехом на половине сделанного.
set -Eeuo pipefail

# Путь задаётся снаружи, чтобы скрипт можно было прогнать не только
# в контейнере. По умолчанию — тот, что в образе.
: "${ROOT:=/srv/qiymet}"
: "${LOG_DIR:=$ROOT/logs}"
LOG="$LOG_DIR/watchdog.log"
mkdir -p "$LOG_DIR"

SCRIPT_NAME=$(basename "$0")

# shellcheck source=lib.sh
. "$ROOT/deploy/scripts/lib.sh"

exec >> >(rotating_tee "$LOG") 2>&1

# --- 1. возраст данных по сетям ----------------------------------------------
# format() в Postgres умеет только %s, %I и %L — никаких %.1f. Первая версия
# этого запроса падала на нём молча (stderr уходил в /dev/null), сторож
# получал пустую строку и радостно писал «все сети в пределах 12 часов»
# на данных 35-часовой давности. Поэтому округляем round() и подставляем %s,
# а stderr больше не выбрасывается.
# Разрез по (сеть, МАГАЗИН), а не по сети — как в проверке 8 и в /v1/health.
# По сети потеря одной ценовой зоны Bravo не видна вовсе: три оставшиеся тянут
# max(observed_at) наверх, и сторож бодро молчит.
stale=$(psql_q "
    SELECT string_agg(x.label || ' ' || x.hours || ' ч', ', ' ORDER BY x.label)
    FROM (
        SELECT c.code || coalesce('/' || s.name, '') AS label,
               round(extract(epoch FROM now() - max(cp.observed_at)) / 3600, 1) AS hours
        FROM chains c
        JOIN store_items si ON si.chain_id = c.id
        LEFT JOIN stores s ON s.id = si.store_id
        JOIN current_prices cp ON cp.store_item_id = si.id
        GROUP BY c.id, c.code, si.store_id, s.name
        HAVING max(cp.observed_at) < now() - interval '12 hours'
    ) x
")

if [ -n "$stale" ]; then
    alert "Точка не обновлялась дольше 12 часов: ${stale}. Приложение показывает время последней проверки, но цены уже могли уехать."
else
    say "возраст данных: все точки в пределах 12 часов"
fi

# --- 2. последний прогон проверок --------------------------------------------
# Читаем сам прогон, а не пересчитываем проверки заново: тот же результат
# видит приложение через /v1/health, и сторож обязан говорить о том же.
dq=$(psql_q "
    SELECT passed::int || '|' ||
           coalesce((SELECT string_agg(f->>'name', ', ')
                     FROM jsonb_array_elements(failures) f
                     WHERE NOT coalesce((f->>'skipped')::boolean, false)), '') || '|' ||
           extract(epoch FROM now() - started_at)::int
    FROM dq_runs ORDER BY started_at DESC LIMIT 1
")

if [ -z "$dq" ]; then
    alert "В dq_runs нет ни одного прогона проверок. Приложение считает качество неподтверждённым и показывает плашку."
else
    passed=${dq%%|*}
    rest=${dq#*|}
    failed=${rest%%|*}
    age=${rest##*|}

    if [ "$passed" != "1" ]; then
        alert "Проверки данных не прошли: ${failed}. Приложение показывает плашку «данные обновляются»."
    elif [ "$age" -gt 14400 ]; then
        # Четыре часа: сбор ходит каждые три, один пропуск бывает, два — уже
        # значит, что расписание встало.
        alert "Проверки данных не запускались $(( age / 3600 )) ч. Похоже, встало расписание сбора."
    else
        say "проверки данных: прошли $(( age / 60 )) мин назад"
    fi
fi

# --- 3. появляются ли дельты --------------------------------------------------
# Считаем со вторых суток: в первые сутки сравнивать не с чем по определению,
# и алерт был бы ложным ровно один раз, зато сразу после деплоя, когда его
# меньше всего хотят видеть.
lifetime=$(psql_q "
    SELECT extract(epoch FROM now() - min(observed_at))::int
    FROM price_observations
")

if [ -z "$lifetime" ] || [ "$lifetime" -lt 172800 ]; then
    say "дельты не проверяем: базе меньше двух суток, сравнивать не с чем"
else
    # Дельта — это наблюдение, у которого предыдущее по тому же товару
    # отличается ценой. Ровно то же определение, что у notify/worker.py:
    # если оно разъедется, сторож начнёт мерить не то, о чём пишет.
    deltas=$(psql_q "
        SELECT count(*)
        FROM price_observations po
        JOIN LATERAL (
            SELECT price
            FROM price_observations prev
            WHERE prev.store_item_id = po.store_item_id
              AND prev.observed_at < po.observed_at
            ORDER BY prev.observed_at DESC
            LIMIT 1
        ) prev ON prev.price IS DISTINCT FROM po.price
        WHERE po.observed_at >= now() - interval '24 hours'
    ")

    fresh=$(psql_q "
        SELECT count(*) FROM price_observations
        WHERE observed_at >= now() - interval '24 hours'
    ")

    if [ "${fresh:-0}" -eq 0 ]; then
        alert "За сутки не появилось ни одного наблюдения. Сбор не пишет в базу вообще."
    elif [ "${deltas:-0}" -eq 0 ]; then
        alert "За сутки ${fresh} наблюдений и НОЛЬ изменений цены. Сбор пишет, но ничего не меняется — сломалось сравнение, а не сбор. Данные выглядят здоровыми, продукта при этом нет."
    else
        say "дельты за сутки: ${deltas} из ${fresh} наблюдений"
    fi
fi

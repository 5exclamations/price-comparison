#!/usr/bin/env bash
#
# Проверка восстановления. Первого числа каждого месяца.
#
# Бэкап, который ни разу не разворачивали, — это не бэкап, а надежда. Проверка
# автоматическая и на ПУСТУЮ базу: развернуть поверх существующей значит
# проверить, что pg_restore умеет чинить конфликты, а не что дамп целый.
#
# Проверяется не только «pg_restore не упал». Он не падает и на дампе, где
# половина таблиц пустые. Поэтому после отката считаются строки в главных
# таблицах и вызывается refresh_after_crawl(): витрины строятся из данных, и
# если данные битые, ошибка вылезет именно здесь.
# -e: любая необработанная ошибка останавливает скрипт. -E: ловушка ERR из
# lib.sh работает и внутри функций. Без -e упавший шаг шёл дальше, и прогон
# заканчивался успехом на половине сделанного.
set -Eeuo pipefail

BACKUP_DIR=${BACKUP_DIR:-/backups}
LOG_DIR=${LOG_DIR:-/var/log/qiymet}
LOG="$LOG_DIR/restore-test.log"
TEST_DB=${TEST_DB:-qiymet_restore_test}

mkdir -p "$LOG_DIR"

SCRIPT_NAME=$(basename "$0")

# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

exec >> >(rotating_tee "$LOG") 2>&1

say "=== проверка восстановления начата ==="

latest=$(find "$BACKUP_DIR" -maxdepth 1 -name 'qiymet-*.dump' -type f \
         | sort | tail -1)

if [ -z "$latest" ]; then
    alert "Проверка восстановления: бэкапов нет вообще. Восстанавливаться не из чего."
    exit 1
fi

age_days=$(( ( $(date +%s) - $(date -r "$latest" +%s) ) / 86400 ))
say "берём свежайший: $latest (возраст $age_days дн)"

if [ "$age_days" -gt 2 ]; then
    alert "Свежайшему бэкапу $age_days дней. Ежедневный дамп не снимается."
fi

# Пустая база под откат. Дропаем прошлую попытку: она могла остаться от
# упавшей проверки, и разворачивать поверх неё — это уже не проверка.
psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null
if ! psql_q "CREATE DATABASE ${TEST_DB} TEMPLATE template0 ENCODING 'UTF8' LC_COLLATE 'C' LC_CTYPE 'C'" > /dev/null; then
    alert "Проверка восстановления: не удалось создать пустую базу ${TEST_DB}."
    exit 1
fi

started=$(date +%s)
restore_log=$(mktemp)

# --exit-on-error: без него pg_restore досыпает что может и возвращает ноль,
# то есть рапортует об успехе на частично развалившемся дампе.
if ! pg_restore --dbname="$TEST_DB" --no-owner --no-privileges \
        --exit-on-error "$latest" > "$restore_log" 2>&1; then
    alert "Проверка восстановления УПАЛА на pg_restore. Бэкап $(basename "$latest") развернуть нельзя.
$(tail -5 "$restore_log")"
    rm -f "$restore_log"
    psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null
    exit 1
fi
rm -f "$restore_log"
elapsed=$(( $(date +%s) - started ))
say "pg_restore прошёл за ${elapsed} с"

# --- что именно развернулось --------------------------------------------------
# Без 2>/dev/null: упавший запрос дал бы пустую строку, а пустая строка ниже
# превратилась бы в «дамп почти пустой» — сообщение про другую аварию.
if ! counts=$(psql --no-psqlrc --quiet --tuples-only --no-align --dbname="$TEST_DB" \
    -v ON_ERROR_STOP=1 -c "
    SELECT (SELECT count(*) FROM chains) || '|' ||
           (SELECT count(*) FROM products) || '|' ||
           (SELECT count(*) FROM store_items) || '|' ||
           (SELECT count(*) FROM price_observations)
" 2>&1); then
    alert "Проверка восстановления: дамп развернулся, но пересчитать строки не удалось.
$(printf '%s' "$counts" | tail -3)"
    psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null
    exit 1
fi

chains=${counts%%|*};        rest=${counts#*|}
products=${rest%%|*};        rest=${rest#*|}
items=${rest%%|*}
observations=${rest##*|}

say "развернулось: сетей $chains, товаров $products, позиций $items, наблюдений $observations"

if [ "${chains:-0}" -lt 1 ] || [ "${products:-0}" -lt 1000 ] || [ "${observations:-0}" -lt 1000 ]; then
    alert "Проверка восстановления: дамп развернулся, но почти пустой (сетей $chains, товаров $products, наблюдений $observations). Это не рабочая копия."
    psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null
    exit 1
fi

# --- витрины ------------------------------------------------------------------
# Матвьюхи в дампе лежат пустыми: pg_dump сохраняет определение, а не
# содержимое. Собираем их заново — заодно это проверка, что данные пригодны
# не только для count(*).
if ! refresh_err=$(psql --no-psqlrc --quiet --dbname="$TEST_DB" -v ON_ERROR_STOP=1 \
        -c "SELECT refresh_after_crawl()" 2>&1); then
    # Текст ошибки Postgres кладём в алерт целиком: без него «витрины не
    # строятся» — сообщение, с которым нечего делать.
    alert "Проверка восстановления: данные развернулись, но витрины по ним не строятся. refresh_after_crawl() упал.
$(printf '%s' "$refresh_err" | tail -3)"
    psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null
    exit 1
fi

prices=$(psql --no-psqlrc --quiet --tuples-only --no-align --dbname="$TEST_DB" \
    -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM current_prices")
say "витрины собрались: current_prices $prices строк"

psql_q "DROP DATABASE IF EXISTS ${TEST_DB}" > /dev/null

# Успех тоже сообщаем. Молчащий мониторинг неотличим от сломанного: раз
# в месяц увидеть «откат проверен» стоит дешевле, чем однажды обнаружить,
# что проверка не запускалась полгода.
alert "Проверка восстановления прошла. Бэкап $(basename "$latest"), откат за ${elapsed} с, товаров $products, наблюдений $observations, current_prices $prices."

say "=== проверка восстановления закончена ==="

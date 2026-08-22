#!/usr/bin/env bash
#
# Перезамер ценовых зон Bravo. По понедельникам.
#
# У Bravo четыре зоны, и они НЕ совпадают с форматом магазина: в одной зоне
# лежат Superstore, Supermarket и Ekspress с ценами до копейки одинаковыми.
# Зона — измеренное значение в stores.price_cluster, выводить её из названия
# магазина нельзя.
#
# Если сеть перекроит прайсы, зоны разъедутся МОЛЧА: цены останутся
# правдоподобными, просто не из той зоны. Человек приедет в свой филиал и
# увидит другую цену — то есть ровно тот отказ, ради которого всё это писалось.
# Поэтому замер стоит в расписании, а не «когда вспомним».
# -e: любая необработанная ошибка останавливает скрипт. -E: ловушка ERR из
# lib.sh работает и внутри функций. Без -e упавший шаг шёл дальше, и прогон
# заканчивался успехом на половине сделанного.
set -Eeuo pipefail

# Путь задаётся снаружи, чтобы скрипт можно было прогнать не только
# в контейнере. По умолчанию — тот, что в образе.
: "${ROOT:=/srv/qiymet}"
: "${LOG_DIR:=$ROOT/logs}"
LOG="$LOG_DIR/zones.log"
mkdir -p "$LOG_DIR"

SCRIPT_NAME=$(basename "$0")

# shellcheck source=lib.sh
. "$ROOT/deploy/scripts/lib.sh"

exec >> >(rotating_tee "$LOG") 2>&1

say "=== перезамер зон Bravo начат ==="

# Без 2>/dev/null: упавший запрос дал бы пустую строку и «до» и «после», они
# совпали бы, и скрипт написал бы «зоны прежние». Ровно тот случай, когда
# заглушённая ошибка выглядит как успешная проверка.
before=$(psql_q "
    SELECT string_agg(name || '=' || coalesce(price_cluster, '?'), ', ' ORDER BY name)
    FROM stores WHERE chain_id = (SELECT id FROM chains WHERE code = 'bravo')
")

cd "$ROOT/pipeline" || exit 1
if ! timeout 1h python3 cluster2.py; then
    alert "Перезамер зон Bravo упал. Зоны остались прежними — если сеть их перекроила, цены Bravo показываются не из той зоны."
    exit 1
fi

# Импорт подхватит новые price_cluster вместе с остальными таблицами.
cd "$ROOT" || exit 1
if ! timeout 30m python3 db/import_sqlite.py \
        --sqlite "$ROOT/pipeline/state/qiymet.db" --no-refresh; then
    alert "Перелив после перезамера зон упал."
    exit 1
fi
psql_q "SELECT refresh_after_crawl()" > /dev/null || \
    alert "refresh_after_crawl() после перезамера зон упал."

after=$(psql_q "
    SELECT string_agg(name || '=' || coalesce(price_cluster, '?'), ', ' ORDER BY name)
    FROM stores WHERE chain_id = (SELECT id FROM chains WHERE code = 'bravo')
")

if [ "$before" != "$after" ]; then
    # Это не авария, а новость: состав зон меняется редко, и знать об этом надо.
    alert "Состав ценовых зон Bravo изменился.
Было: ${before}
Стало: ${after}"
    say "зоны изменились"
else
    say "зоны прежние: ${after}"
fi

say "=== перезамер зон Bravo закончен ==="

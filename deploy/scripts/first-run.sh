#!/usr/bin/env bash
#
# Первый запуск на новой машине. Порядок здесь тоже не случайный.
#
# Скрипт останавливается на первой ошибке и после каждого шага говорит, что
# получилось. Разворачивать вслепую нельзя: половина шагов необратима на
# живой базе — водяной знак уведомлений ставится один раз.
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1
COMPOSE="docker compose"

step() { printf '\n\033[1m== %s\033[0m\n' "$*"; }

# --- 0. окружение --------------------------------------------------------------
step "проверяю .env"
[ -f .env ] || { echo "нет deploy/.env — скопируй .env.example и заполни"; exit 1; }
# shellcheck disable=SC1091
set -a; . ./.env; set +a

: "${POSTGRES_PASSWORD:?пароль базы не задан}"
: "${QIYMET_DOMAIN:?домен не задан, Caddy без него не выпустит сертификат}"

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
    echo "  ВНИМАНИЕ: телеграм не настроен. Алерты будут только в логах —"
    echo "  то есть их никто не увидит, пока не пойдёт смотреть."
fi

# --- 1. база и кеш --------------------------------------------------------------
step "поднимаю postgres и redis"
$COMPOSE up -d postgres redis
$COMPOSE exec -T postgres bash -c 'until pg_isready -U qiymet -d qiymet; do sleep 2; done'

step "расширения"
$COMPOSE exec -T postgres psql -U qiymet -d qiymet -v ON_ERROR_STOP=1 \
    -c "CREATE EXTENSION IF NOT EXISTS pg_trgm"

# --- 2. миграции ----------------------------------------------------------------
step "миграции"
$COMPOSE run --rm --workdir /srv/qiymet/db api alembic upgrade head

step "секции price_observations на 3 месяца вперёд"
# Тот же вызов стоит в начале каждого прогона сбора. Здесь он нужен, чтобы
# первый же импорт не уехал в DEFAULT.
$COMPOSE exec -T postgres psql -U qiymet -d qiymet -v ON_ERROR_STOP=1 \
    -c "SELECT ensure_price_partitions_ahead(3)"

# --- 3. первичные данные --------------------------------------------------------
step "первый сбор"
echo "  Это займёт около часа: full тянет штрихкоды по одному."
$COMPOSE run --rm worker bash -lc \
    'cd /srv/qiymet/pipeline && python3 run.py full'

step "перелив в Postgres"
$COMPOSE run --rm worker bash -lc \
    'cd /srv/qiymet && python3 db/import_sqlite.py --sqlite pipeline/state/qiymet.db'

# --- 4. проверки данных ---------------------------------------------------------
step "проверки данных"
# --source crawl и БЕЗ --allow-stale: данные только что собраны, и восьмая
# проверка обязана быть настоящей. --allow-stale существует только для CI.
$COMPOSE run --rm worker python3 -m checks.runner --source crawl || {
    echo
    echo "  Проверки не прошли. Разворачивать поверх плохих данных нельзя:"
    echo "  приложение покажет плашку, а пуши уйдут по мусору."
    echo "  Разбирайся по выводу выше, потом запусти скрипт заново."
    exit 1
}

# --- 5. водяной знак уведомлений ------------------------------------------------
step "первый прогон notify: обязан НИКОГО не оповестить"
# Самое опасное место всего разворота. В базе лежит история за всё время, и
# воркер, не поставивший водяной знак, разошлёт её разом каждому подписчику.
#
# Логика «первый запуск ставит знак и молчит» реализована в notify/worker.py,
# и это ровно та вещь, которая ломается при переносе незаметно: подписчиков
# на новой базе ещё нет, так что тишина выглядит одинаково и когда всё
# правильно, и когда сломано.
#
# Поэтому проверяем не тишину, а сам знак: он обязан появиться и совпасть
# с максимумом observed_at.
$COMPOSE run --rm worker python3 -m notify run

watermark=$($COMPOSE exec -T postgres psql -U qiymet -d qiymet -Atc \
    "SELECT watermark FROM worker_state WHERE worker = 'price_drop'")
max_obs=$($COMPOSE exec -T postgres psql -U qiymet -d qiymet -Atc \
    "SELECT max(observed_at) FROM price_observations")
queued=$($COMPOSE exec -T postgres psql -U qiymet -d qiymet -Atc \
    "SELECT count(*) FROM notifications")

echo "  водяной знак: ${watermark:-НЕТ}"
echo "  максимум observed_at: ${max_obs}"
echo "  уведомлений в очереди: ${queued}"

if [ -z "$watermark" ]; then
    echo
    echo "  ОСТАНОВ: водяной знак не поставлен. Второй запуск разошлёт всю"
    echo "  историю цен разом каждому подписчику. Чинить notify/worker.py."
    exit 1
fi
if [ "${queued:-0}" != "0" ]; then
    echo
    echo "  ОСТАНОВ: первый прогон поставил в очередь ${queued} уведомлений."
    echo "  На свежей базе их должно быть ноль. Очередь надо очистить"
    echo "  (DELETE FROM notifications) и разобраться, почему знак не сработал."
    exit 1
fi
echo "  первый прогон никого не оповестил — как и должен"

# --- 6. приложение --------------------------------------------------------------
step "поднимаю api, caddy, worker, backup"
$COMPOSE up -d --build

step "жду, пока api станет здоровым"
for _ in $(seq 30); do
    if [ "$($COMPOSE ps -q api | xargs docker inspect -f '{{.State.Health.Status}}')" = "healthy" ]; then
        break
    fi
    sleep 5
done

# --- 7. первая проверка снаружи --------------------------------------------------
step "проверяю API снаружи"
echo "  Сертификат выпускается при первом обращении, это до минуты."
sleep 10
if curl -fsS --max-time 30 "https://${QIYMET_DOMAIN}/v1/health" | head -c 400; then
    echo
    echo "  API отвечает по HTTPS"
else
    echo
    echo "  API снаружи не ответил. Смотри: docker compose logs caddy"
    echo "  Чаще всего дело в A-записи: домен должен указывать сюда ДО старта."
fi

# --- 8. первый бэкап -------------------------------------------------------------
step "первый бэкап и проверка отката"
# Не дожидаясь ночи: развернуть бэкап надо один раз до того, как он
# понадобится, а не в тот день, когда понадобится.
$COMPOSE exec -T backup /srv/qiymet/backup.sh
$COMPOSE exec -T backup /srv/qiymet/restore-test.sh

cat <<'DONE'

== Готово ==

Что происходит дальше само:
  каждые 3 часа   — сбор fast, перелив, витрины, проверки, уведомления
  4:15            — полный прогон
  понедельник 5:30 — перезамер ценовых зон Bravo
  каждые 15 минут — отправка накопленных уведомлений
  каждый час      — сторож: возраст данных, проверки, дельты
  3:30            — бэкап
  1-го в 5:00     — проверка восстановления

Что проверить руками ЗАВТРА, а не сегодня:
  История цен начинает копиться только сейчас — до этого пайплайн ни разу
  не работал по расписанию. За первые сутки дельт не будет по определению,
  сравнивать не с чем. Со вторых суток сторож начнёт следить, что дельты
  появляются; ноль дельт при непустом сборе означает, что сломалось
  сравнение, а не сбор, и выглядеть это будет совершенно здорово.

  Посмотреть самому:
    docker compose exec postgres psql -U qiymet -d qiymet \
      -c "SELECT count(*) FROM price_observations WHERE observed_at > now() - interval '24 hours'"
DONE

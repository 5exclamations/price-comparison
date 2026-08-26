#!/usr/bin/env bash
#
# Локальный бэкенд для отладки приложения на живом устройстве.
#
# Поднимает Postgres в контейнере и uvicorn на 0.0.0.0, то есть ровно то, что
# нужно телефону: он ходит по Wi-Fi на LAN-адрес этой машины. Скрипт
# идемпотентный — его можно запускать повторно, ничего не сломается.
#
# Это НЕ боевой запуск. Боевой живёт в deploy/docker-compose.yml, там другой
# пароль, Redis, Caddy и сеть без опубликованных портов.
#
#   ./deploy/dev/local-api.sh          запустить (блокирующе, uvicorn в фореграунде)
#
# Порты выбраны не по вкусу:
#
#   5433  вместо 5432 — стандартный занят SSH-туннелем на этой машине.
#   8001  вместо 8000 — там чужой Django, тоже через туннель.
#
# Если туннель когда-нибудь уедет, менять эти числа всё равно не нужно:
# приложение собирается с --dart-define=QIYMET_API_URL и знает адрес оттуда.

set -euo pipefail

# Корень репозитория вычисляем от себя, а не хардкодим: скрипт зовётся и руками,
# и из LaunchAgent, у которых разный рабочий каталог.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

CONTAINER=qiymet-pg-dev
PGPORT=5433
APIPORT=8001
PGIMAGE=postgres:16          # та же мажорная версия, что в CI и в бою
DATABASE_URL="postgresql+psycopg://qiymet:qiymet@localhost:${PGPORT}/qiymet"

log() { printf '%s  %s\n' "$(date '+%H:%M:%S')" "$*"; }

# --- Postgres ----------------------------------------------------------------

# PATH под launchd — это /usr/bin:/bin:/usr/sbin:/sbin, без Homebrew. Свой
# PATH прописан в LaunchAgent, но скрипт зовут и руками, и из launchd, поэтому
# отсутствие бинарника проверяется отдельно от неготовности демона: иначе
# "docker не установлен" сорок раз подряд выглядит как "docker не успел
# запуститься", и в логе оказывается неправдa.
if ! command -v docker >/dev/null 2>&1; then
    log "docker не найден в PATH ($PATH)"
    exit 1
fi

# Docker Desktop после логина стартует не мгновенно, а LaunchAgent — сразу.
# Без ожидания первый же `docker` падает с "cannot connect to the Docker daemon",
# launchd считает это крахом и уходит в бэкофф на минуты.
for _ in $(seq 1 60); do
    docker info >/dev/null 2>&1 && break
    sleep 2
done
if ! docker info >/dev/null 2>&1; then
    log "демон docker не ответил за две минуты — выходим, launchd перезапустит"
    exit 1
fi

if ! docker inspect "$CONTAINER" >/dev/null 2>&1; then
    log "контейнера нет, создаю"
    # restart=unless-stopped: после перезагрузки Docker поднимет его сам, и
    # скрипту останется только дождаться готовности.
    docker run -d --name "$CONTAINER" --restart unless-stopped \
        -e POSTGRES_USER=qiymet \
        -e POSTGRES_PASSWORD=qiymet \
        -e POSTGRES_DB=qiymet \
        -p "${PGPORT}:5432" \
        "$PGIMAGE" >/dev/null
elif [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER")" != "true" ]; then
    log "контейнер есть, но лежит — поднимаю"
    docker start "$CONTAINER" >/dev/null
fi

log "жду готовности Postgres"
for _ in $(seq 1 60); do
    docker exec "$CONTAINER" pg_isready -U qiymet -q 2>/dev/null && break
    sleep 1
done
docker exec "$CONTAINER" pg_isready -U qiymet -q || { log "Postgres не ответил"; exit 1; }

# --- схема и данные ----------------------------------------------------------

# `alembic upgrade head` на уже накатанной базе — это один SELECT из
# alembic_version. Дешевле, чем однажды поймать расхождение схемы с кодом
# после git pull и полчаса читать невнятную ошибку в SQL.
log "миграции"
(cd "$ROOT/db" && DATABASE_URL="$DATABASE_URL" "$ROOT/.venv/bin/alembic" upgrade head >/dev/null)

# Данные заливаем только в пустую базу. Иначе каждый логин перетирал бы то,
# что могло быть собрано свежим прогоном.
rows=$(docker exec "$CONTAINER" psql -U qiymet -d qiymet -tAc \
    "SELECT count(*) FROM store_items" 2>/dev/null || echo 0)
if [ "${rows:-0}" -eq 0 ]; then
    log "база пустая, заливаю pipeline/qiymet.db"
    (cd "$ROOT" && DATABASE_URL="$DATABASE_URL" QIYMET_DATABASE_URL="$DATABASE_URL" \
        "$ROOT/.venv/bin/python" db/import_sqlite.py --sqlite pipeline/qiymet.db)
else
    log "в базе $rows позиций, импорт пропускаю"
fi

# --- API ---------------------------------------------------------------------

ip=$(ipconfig getifaddr en0 2>/dev/null || echo '?')
log "API: http://${ip}:${APIPORT}  (для сборки: --dart-define=QIYMET_API_URL=http://${ip}:${APIPORT})"

# exec, а не запуск в фоне: launchd должен следить за самим uvicorn, иначе он
# увидит завершившийся скрипт-обёртку и решит, что сервис умер.
# --host 0.0.0.0 обязателен, иначе телефон не достучится.
cd "$ROOT"
exec env QIYMET_DATABASE_URL="$DATABASE_URL" \
    "$ROOT/.venv/bin/python" -m uvicorn api.main:app \
    --host 0.0.0.0 --port "$APIPORT"

# Общее для скриптов прогона: лог с ротацией, psql, алерт в телеграм.
#
# Подключается через `. lib.sh`, самостоятельно не запускается.

: "${ROOT:=/srv/qiymet}"
: "${LOG_DIR:=$ROOT/logs}"
: "${LOG_MAX_BYTES:=20971520}"   # 20 МБ
: "${LOG_KEEP:=5}"

say() {
    printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

# Ротация своими руками, без logrotate.
#
# logrotate в контейнере — это ещё один демон и ещё один cron, который надо
# держать живым ради пяти файлов. Здесь достаточно проверить размер перед
# записью: прогонов шесть в сутки, накладных расходов нет.
rotate_if_big() {
    local file="$1"
    [ -f "$file" ] || return 0

    local size
    # Существование файла проверено строкой выше, поэтому глушить wc нечего.
    size=$(wc -c < "$file")
    [ "$size" -lt "$LOG_MAX_BYTES" ] && return 0

    local i=$((LOG_KEEP - 1))
    while [ "$i" -ge 1 ]; do
        if [ -f "$file.$i" ]; then
            mv -f "$file.$i" "$file.$((i + 1))"
        fi
        i=$((i - 1))
    done
    mv -f "$file" "$file.1"
    # Всё, что старше LOG_KEEP, удаляется: место на VPS кончается тихо, а
    # закончившееся место роняет и Postgres тоже.
    rm -f "$file.$((LOG_KEEP + 1))"
}

rotating_tee() {
    local file="$1"
    rotate_if_big "$file"
    cat >> "$file"
}

# psql без интерактива и с падением на первой же ошибке.
#
# ON_ERROR_STOP обязателен: без него psql проглотит ошибку в середине скрипта
# и вернёт ноль, то есть «всё хорошо» на сломанном прогоне.
psql_q() {
    psql --no-psqlrc --quiet --tuples-only --no-align \
         -v ON_ERROR_STOP=1 -c "$1"
}

# Алерт в телеграм.
#
# Без токена — только в лог. Так задумано: на машине разработчика бот не
# настроен, и падать из-за этого прогон не должен.
alert() {
    local text="$1"
    say "АЛЕРТ: $text"

    [ -n "${TELEGRAM_BOT_TOKEN:-}" ] || return 0
    [ -n "${TELEGRAM_CHAT_ID:-}" ] || return 0

    curl -sS --max-time 15 \
        -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "disable_web_page_preview=true" \
        --data-urlencode "text=qiymət: ${text}" \
        > /dev/null || say "телеграм недоступен, алерт остался только в логе"
}

# Пульс во внешний монитор (healthchecks.io, BetterStack, любой другой,
# принимающий GET).
#
# Зачем он, если есть проверка /v1/health: монитор, который спрашивает наш
# API, узнает про упавший API. Про то, что ВСТАЛО РАСПИСАНИЕ, он не узнает
# никогда — API продолжит бодро отдавать вчерашние цены. Пульс работает
# наоборот: молчание само по себе является сигналом.
#
# Без HEARTBEAT_URL_* функция молчит: на машине разработчика монитора нет.
heartbeat() {
    local name="$1" status="${2:-}"
    local var="HEARTBEAT_URL_${name}"
    local url="${!var:-}"

    [ -n "$url" ] || return 0
    curl -sS --max-time 10 --retry 2 "${url}${status}" > /dev/null \
        || say "пульс в монитор не ушёл (${name})"
}

# Ловушка на всё, что не поймали руками.
#
# `set -e` без неё просто обрывает скрипт: код возврата ненулевой, но в
# телеграм не уходит ничего, а в логе остаётся оборванная строка без причины.
# Ловушка называет номер строки и саму команду — этого хватает, чтобы понять
# аварию, не заходя на машину.
#
# Ставится при подключении lib.sh, то есть во всех скриптах разом.
on_error() {
    local code=$? line="$1" cmd="$2"
    say "ОБОРВАНО на строке ${line}: ${cmd} (код ${code})"
    alert "${SCRIPT_NAME:-скрипт} оборван на строке ${line}: ${cmd} (код ${code}). Дальнейшие шаги НЕ выполнялись."
    exit "$code"
}
trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

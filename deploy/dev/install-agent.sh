#!/usr/bin/env bash
#
# Ставит local-api.sh в автозапуск при входе в систему (macOS LaunchAgent).
#
#   ./deploy/dev/install-agent.sh            поставить и запустить
#   ./deploy/dev/install-agent.sh --uninstall снять
#
# Плист генерируется, а не лежит в репозитории готовым: launchd понимает только
# абсолютные пути, а они у каждого свои. Хранить чужой /Users/... в git — это
# файл, который у всех, кроме автора, молча не работает.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LABEL=az.qiymet.dev-api
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
LOG="$HOME/Library/Logs/qiymet-dev-api.log"
DOMAIN="gui/$(id -u)"

if [ "${1:-}" = "--uninstall" ]; then
    launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
    rm -f "$PLIST"
    echo "снято. контейнер Postgres не тронут: docker stop qiymet-pg-dev"
    exit 0
fi

[ -x "$ROOT/deploy/dev/local-api.sh" ] || { echo "нет $ROOT/deploy/dev/local-api.sh"; exit 1; }
[ -x "$ROOT/.venv/bin/python" ] || { echo "нет .venv — см. deploy/dev/README.md"; exit 1; }

mkdir -p "$HOME/Library/LaunchAgents" "$(dirname "$LOG")"

# PATH прописываем явно: launchd не наследует пользовательский, у него
# /usr/bin:/bin:/usr/sbin:/sbin, а docker стоит из Homebrew. Без этого агент
# уходит в бесконечный перезапуск с "docker не найден".
cat > "$PLIST" <<PLIST_END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LABEL}</string>
	<key>ProgramArguments</key>
	<array>
		<string>${ROOT}/deploy/dev/local-api.sh</string>
	</array>
	<key>EnvironmentVariables</key>
	<dict>
		<key>PATH</key>
		<string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
	</dict>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
	<key>ThrottleInterval</key>
	<integer>30</integer>
	<key>WorkingDirectory</key>
	<string>${ROOT}</string>
	<key>StandardOutPath</key>
	<string>${LOG}</string>
	<key>StandardErrorPath</key>
	<string>${LOG}</string>
	<key>ProcessType</key>
	<string>Background</string>
</dict>
</plist>
PLIST_END

plutil -lint "$PLIST" >/dev/null

# bootout возвращает управление раньше, чем launchd действительно снимает
# сервис. Если сразу звать bootstrap, он падает с "Input/output error" (код 5) —
# сообщение, по которому не догадаться, что дело в гонке, а не в плисте.
launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
for _ in $(seq 1 50); do
    launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1 || break
    sleep 0.2
done

launchctl bootstrap "$DOMAIN" "$PLIST"

echo "поставлено: $PLIST"
echo "лог:        $LOG"
echo "статус:     launchctl print $DOMAIN/$LABEL"

# Локальный бэкенд для отладки на устройстве

Приложение на живом iPhone не может ходить на `localhost`: там localhost — это
сам телефон. Нужен API, слушающий `0.0.0.0` на машине разработчика, и сборка,
которая знает её LAN-адрес.

Боевой запуск тут ни при чём — он в `deploy/docker-compose.yml`.

## Разовая подготовка

```bash
python3 -m venv .venv
.venv/bin/pip install -r db/requirements.txt -r api/requirements.txt
```

## Запуск

```bash
./deploy/dev/local-api.sh
```

Скрипт идемпотентный: поднимает контейнер Postgres, если тот лежит, накатывает
миграции, заливает `pipeline/qiymet.db` **только в пустую базу** и запускает
uvicorn. В конце печатает готовую строку с `--dart-define`.

## Автозапуск при входе в систему

```bash
./deploy/dev/install-agent.sh
```

`launchctl` держит сервис живым (`KeepAlive`) и поднимает его при логине.
Снять — `./deploy/dev/install-agent.sh --uninstall`.

Лог: `~/Library/Logs/qiymet-dev-api.log`.

## Сборка приложения

```bash
flutter run -d <udid> --dart-define=QIYMET_API_URL=http://192.168.0.104:8001
```

**Адрес зашивается в сборку.** Сменился IP машины — пересобрать; забыть об этом
легко, потому что симптом тот же, что у выключенного бэкенда: «Something went
wrong» на первом же экране.

Со стороны iOS нужны два ключа в `Info.plist`, оба уже на месте:
`NSAllowsLocalNetworking` (ATS режет открытый HTTP) и
`NSLocalNetworkUsageDescription` (с iOS 14 доступ в локальную сеть спрашивается
отдельно, и без строки соединение обрывается молча, по таймауту).

## Порты

| | порт | почему не стандартный |
|---|---|---|
| Postgres | 5433 | 5432 занят SSH-туннелем |
| API | 8001 | 8000 занят чужим Django |

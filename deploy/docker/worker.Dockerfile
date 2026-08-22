# Воркер: сбор по расписанию и рассылка уведомлений.
#
# Расписание внутри контейнера, а не в crontab хоста. Причина простая: cron
# хоста ничего не знает про образ, и после `docker compose pull` он продолжит
# звать вчерашний код по старым путям. Здесь расписание едет вместе с кодом.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# supercronic вместо cron: работает от обычного пользователя, пишет в stdout
# и, главное, не мрёт молча. Системный cron в контейнере — это PID 1, который
# не пробрасывает сигналы и не даёт понять, почему задача не запустилась.
ARG SUPERCRONIC_VERSION=v0.2.29
ARG TARGETARCH=amd64
ADD https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH} /usr/local/bin/supercronic
RUN chmod +x /usr/local/bin/supercronic

# psql нужен для refresh_after_crawl() и ensure_price_partitions_ahead():
# это одна строка SQL, ради которой поднимать питоновский клиент незачем.
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/qiymet

COPY api/requirements.txt api/requirements.txt
COPY deploy/docker/worker-requirements.txt deploy/docker/worker-requirements.txt
RUN pip install --no-cache-dir -r api/requirements.txt \
    && pip install --no-cache-dir -r deploy/docker/worker-requirements.txt

COPY pipeline/ pipeline/
COPY notify/ notify/
COPY checks/ checks/
COPY db/ db/
COPY deploy/scripts/ deploy/scripts/
COPY deploy/docker/crontab /etc/qiymet/crontab

RUN chmod +x deploy/scripts/*.sh \
    && useradd --system --uid 10002 --create-home qiymet \
    && mkdir -p /srv/qiymet/logs /srv/qiymet/pipeline/state \
    && chown -R qiymet:qiymet /srv/qiymet /etc/qiymet
USER qiymet

# Пайплайн держит SQLite рядом с собой; в контейнере это том, иначе прогон
# терялся бы при каждой пересборке образа вместе со всей историей сбора.
ENV QIYMET_SQLITE=/srv/qiymet/pipeline/state/qiymet.db

CMD ["supercronic", "-passthrough-logs", "/etc/qiymet/crontab"]

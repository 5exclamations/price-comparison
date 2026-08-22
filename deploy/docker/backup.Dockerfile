# Бэкапы. Отдельный контейнер, а не cron внутри postgres.
#
# Официальный образ Postgres не запускает ничего, кроме сервера, и правильно
# делает. Класть туда свой cron значит собирать свой образ базы и потом
# тащить его через каждое обновление минорной версии.
FROM postgres:16-alpine

# supercronic: тот же планировщик, что у воркера. Один инструмент вместо двух.
ARG SUPERCRONIC_VERSION=v0.2.29
ARG TARGETARCH=amd64
ADD https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH} /usr/local/bin/supercronic
RUN chmod +x /usr/local/bin/supercronic \
    && apk add --no-cache bash curl coreutils findutils

COPY deploy/scripts/lib.sh deploy/scripts/backup.sh deploy/scripts/restore-test.sh /srv/qiymet/
COPY deploy/docker/crontab-backup /etc/qiymet/crontab
RUN chmod +x /srv/qiymet/*.sh

# ROOT переопределён: в этом образе нет ни pipeline, ни notify — только два
# скрипта и psql. LOG_DIR смотрит на том, поэтому логи бэкапов переживают
# пересоздание контейнера.
ENV ROOT=/srv/qiymet \
    LOG_DIR=/var/log/qiymet \
    BACKUP_DIR=/backups

CMD ["supercronic", "-passthrough-logs", "/etc/qiymet/crontab"]

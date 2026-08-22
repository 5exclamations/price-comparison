# API: uvicorn за caddy.
#
# Slim, а не alpine: psycopg[binary] и pydantic-core тянут колёса под glibc,
# на musl их нет и всё собирается из исходников минут по пятнадцать.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /srv/qiymet

# Зависимости отдельным слоем: код меняется каждый деплой, зависимости — раз
# в месяц, и пересобирать их каждый раз незачем.
COPY api/requirements.txt api/requirements.txt
RUN pip install --no-cache-dir -r api/requirements.txt

COPY api/ api/
COPY db/ db/
COPY checks/ checks/

# Не root. Контейнер смотрит наружу через caddy, и первая же дыра в разборе
# запроса не должна давать права на запись в образ.
RUN useradd --system --uid 10001 qiymet && chown -R qiymet:qiymet /srv/qiymet
USER qiymet

EXPOSE 8000

# Воркеров два, не больше: на VPS с двумя ядрами третий будет отбирать время
# у сбора, а он и так самая тяжёлая работа на машине.
CMD ["uvicorn", "api.main:app", \
     "--host", "0.0.0.0", "--port", "8000", \
     "--workers", "2", \
     "--proxy-headers", "--forwarded-allow-ips", "*", \
     "--no-access-log"]

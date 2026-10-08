# One image for the pipeline, the API and the dashboard (different commands in docker-compose.yml).
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1 PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

# Dependencies first so code edits do not invalidate this layer.
COPY pyproject.toml ./
RUN mkdir rpi && touch rpi/__init__.py \
    && pip install -e . \
    && rm -rf rpi

COPY rpi ./rpi
COPY warehouse ./warehouse
# The platform reuses two proven text parsers from the original pipeline (units, fingerprints).
# Only those two files are copied: nothing else from pipeline/ belongs in this image.
COPY pipeline/units.py pipeline/fingerprint.py ./pipeline/
COPY .streamlit ./.streamlit

ENV RPI_DATABASE_URL=postgresql://rpi:rpi@postgres:5432/rpi \
    RPI_LANDING_DIR=/app/data/landing RPI_TRUTH_DIR=/app/data/truth RPI_REPORTS_DIR=/app/data/reports \
    PREFECT_HOME=/tmp/prefect PREFECT_LOGGING_LEVEL=WARNING PREFECT_SERVER_ANALYTICS_ENABLED=false

CMD ["python", "-m", "rpi.cli", "--help"]

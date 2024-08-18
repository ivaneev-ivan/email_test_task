FROM python:3.12-alpine

RUN apk add --no-cache \
        shadow \
        gcc \
        musl-dev \
        libffi-dev && \
    adduser -D -h /home/user user && \
    mkdir -p /app && \
    pip install poetry==1.4.2 && \
    apk del \
        shadow \
        gcc \
        musl-dev \
        libffi-dev

WORKDIR /app

COPY pyproject.toml poetry.lock ./
ENV POETRY_VIRTUALENVS_PATH=/usr/src/.venv \
    POETRY_VIRTUALENVS_IN_PROJECT=0
RUN poetry install --no-root --no-cache

COPY entrypoint.sh ./
RUN chmod a+x ./entrypoint.sh

ENTRYPOINT ["sh", "-c", "./entrypoint.sh"]
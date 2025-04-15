FROM python:3.9-alpine3.13

LABEL maintainer="RKLJ"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Installér systempakker og opret virtualenv
RUN apk add --no-cache \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    libgcc && \
    python -m venv /py && \
    /py/bin/python -m ensurepip && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp

# Tilføj bruger
RUN adduser --disabled-password --no-create-home -D django-user

ENV PATH="/py/bin:$PATH"

USER django-user

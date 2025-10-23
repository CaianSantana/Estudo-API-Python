FROM python:3.11-alpine AS builder

RUN apk add --no-cache build-base

WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


FROM python:3.11-alpine

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv

COPY . .

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

WORKDIR /app

CMD ["flask", "--app", "api:create_app", "run", "--host=0.0.0.0"]
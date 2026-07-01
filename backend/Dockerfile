FROM python:3.12-slim AS base

WORKDIR /app

# System deps needed for psycopg2 / postgres client libs
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1 \
    PORT=8000

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Assumes a FastAPI app exposed as `app` in main.py
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

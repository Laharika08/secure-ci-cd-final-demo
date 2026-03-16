FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

# Create non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 8000

ENV APP_VERSION=0.1.0 \
    BUILD_ID=local \
    DEPLOYMENT_ENV=prod \
    SECURITY_STATUS=unknown \
    BUILD_TIMESTAMP=""

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

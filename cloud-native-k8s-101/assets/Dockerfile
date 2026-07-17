# syntax=docker/dockerfile:1
# Reference Dockerfile — follows practices taught in this lab.
FROM python:3.12-slim

# Run as non-root (same expectation as most enterprise policies / PSS)
RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser

WORKDIR /app

# Copy only what the app needs (smaller image, better layer cache, less attack surface)
COPY app.py ./
RUN chown appuser:appuser /app/app.py

USER appuser

ENV PORT=8080 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

EXPOSE 8080

# Container-native health signal (K8s probes are still the source of truth in-cluster)
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthz')"

# Exec form — no shell, correct signal handling (PID 1)
CMD ["python", "app.py"]

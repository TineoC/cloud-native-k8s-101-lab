# syntax=docker/dockerfile:1
# STARTER Dockerfile — intentionally runs as ROOT.
# Challenge (step 2): add a non-root user and switch with USER before you ship.
FROM python:3.12-slim

WORKDIR /app

# Copy only what the app needs (smaller image, better layer cache, less attack surface)
COPY app.py ./

ENV PORT=8080 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

EXPOSE 8080

# Container-native health signal (K8s probes are still the source of truth in-cluster)
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthz')"

# Exec form — no shell, correct signal handling (PID 1)
CMD ["python", "app.py"]

# TODO (you): create a non-root user, chown /app, and add:
#   USER appuser
# Without USER, the process runs as root (uid 0) — not enterprise-ready.

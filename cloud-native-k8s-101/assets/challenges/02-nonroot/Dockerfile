# Intentionally BAD — Challenge 2
# Problems for learners to fix:
# 1) Process runs as root
# 2) No HEALTHCHECK
# 3) Missing PYTHONUNBUFFERED (logs buffered — harder to debug)
FROM python:3.12-slim
WORKDIR /app
COPY app.py ./
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]

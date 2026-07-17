# Intentionally BAD — Challenge 3
# Problems for learners to fix:
# 1) Secret baked into the image layer (visible in history / registry)
# 2) Still running as root
# Secrets belong in Kubernetes Secrets / external stores — never ENV in Dockerfile.
FROM python:3.12-slim
WORKDIR /app
COPY app.py ./
ENV PORT=8080
ENV API_KEY=acme-super-secret-prod-key-do-not-ship
EXPOSE 8080
CMD ["python", "app.py"]

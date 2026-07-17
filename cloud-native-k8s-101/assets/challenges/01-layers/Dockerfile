# Intentionally BAD — Challenge 1
# Problems for learners to fix:
# 1) Fat base image (python:3.12 instead of slim)
# 2) COPY of the whole build context (dot to dot) — copy only app.py
FROM python:3.12
WORKDIR /app
COPY . .
CMD python app.py

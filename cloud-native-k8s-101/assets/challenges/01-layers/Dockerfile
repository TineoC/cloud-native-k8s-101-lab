# Intentionally BAD — Challenge 1
# Problems for learners to fix:
# 1) Fat base image (python:3.12 instead of slim)
# 2) COPY . . pulls the whole context
# 3) Shell-form CMD (worse signals / PID 1)
FROM python:3.12
WORKDIR /app
COPY . .
CMD python app.py

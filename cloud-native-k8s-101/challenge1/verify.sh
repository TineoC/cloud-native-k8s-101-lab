#!/usr/bin/env bash
set -euo pipefail

DF=/root/shop/challenges/01-layers/Dockerfile
[[ -f "$DF" ]] || { echo "Missing $DF"; exit 1; }

grep -Eiq 'FROM[[:space:]]+python:3\.12-slim' "$DF" \
  || { echo "Use FROM python:3.12-slim"; exit 1; }

grep -Eq 'COPY[[:space:]]+\.[[:space:]]+\.' "$DF" \
  && { echo "Remove COPY . . — copy only app.py"; exit 1; }

grep -Eq 'COPY[[:space:]]+(\./)?app\.py' "$DF" \
  || { echo "Need COPY app.py (or ./app.py)"; exit 1; }

grep -Eq 'CMD[[:space:]]*\[[[:space:]]*"python"' "$DF" \
  || { echo 'Need exec-form CMD ["python", "app.py"]'; exit 1; }

docker build -t challenge-01:fixed /root/shop/challenges/01-layers >/tmp/c01-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c01-build.log; exit 1; }

echo "Challenge 1 passed: slim base, narrow COPY, exec-form CMD."

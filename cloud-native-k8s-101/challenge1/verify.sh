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

docker image inspect challenge-01:fat >/dev/null 2>&1 \
  || { echo "Build the fat image first: docker build -t challenge-01:fat . (before editing)"; exit 1; }

docker build -t challenge-01:fixed /root/shop/challenges/01-layers >/tmp/c01-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c01-build.log; exit 1; }

fat_bytes="$(docker image inspect challenge-01:fat --format '{{.Size}}')"
slim_bytes="$(docker image inspect challenge-01:fixed --format '{{.Size}}')"

echo "challenge-01:fat   size = ${fat_bytes} bytes"
echo "challenge-01:fixed size = ${slim_bytes} bytes"

[[ "${slim_bytes}" -lt "${fat_bytes}" ]] \
  || { echo "Expected slim (:fixed) to be smaller than fat — rebuild after switching to python:3.12-slim"; exit 1; }

echo "Challenge 1 passed: slim base, narrow COPY, exec-form CMD, slim < fat."

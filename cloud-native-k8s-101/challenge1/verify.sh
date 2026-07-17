#!/usr/bin/env bash
# Verify via Docker Engine API / image runtime — not Dockerfile text.
set -euo pipefail

CTX=/root/shop/challenges/01-layers
[[ -d "$CTX" ]] || { echo "Missing $CTX"; exit 1; }

docker image inspect challenge-01:fat >/dev/null 2>&1 \
  || { echo "Build the fat image first: docker build -t challenge-01:fat . (before editing)"; exit 1; }

docker build -t challenge-01:fixed "$CTX" >/tmp/c01-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c01-build.log; exit 1; }

fat_bytes="$(docker image inspect challenge-01:fat --format '{{.Size}}')"
slim_bytes="$(docker image inspect challenge-01:fixed --format '{{.Size}}')"

echo "challenge-01:fat   size = ${fat_bytes} bytes"
echo "challenge-01:fixed size = ${slim_bytes} bytes"

[[ "${slim_bytes}" -lt "${fat_bytes}" ]] \
  || { echo "Expected :fixed to be smaller than :fat — switch to python:3.12-slim and rebuild"; exit 1; }

# Narrow COPY: whole-context COPY . . would also ship Dockerfile into /app
listing="$(docker run --rm --entrypoint ls challenge-01:fixed -la /app)"
echo "$listing"
echo "$listing" | grep -Eq '[[:space:]]app\.py([[:space:]]|$)' \
  || { echo "Image must contain /app/app.py"; exit 1; }
echo "$listing" | grep -Eqi '[[:space:]]Dockerfile([[:space:]]|$)' \
  && { echo "Image still contains /app/Dockerfile — use COPY app.py . (not the whole context)"; exit 1; }

echo "Challenge 1 passed: slim < fat, narrow COPY (app.py only in /app)."

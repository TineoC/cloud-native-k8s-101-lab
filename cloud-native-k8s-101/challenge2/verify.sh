#!/usr/bin/env bash
set -euo pipefail

DF=/root/shop/challenges/02-nonroot/Dockerfile
[[ -f "$DF" ]] || { echo "Missing $DF"; exit 1; }

grep -Eq '^[[:space:]]*USER[[:space:]]+' "$DF" \
  || { echo "Add a USER directive (non-root)"; exit 1; }

grep -Eq '^[[:space:]]*USER[[:space:]]+root[[:space:]]*$' "$DF" \
  && { echo "USER must not be root"; exit 1; }

grep -Eiq '^[[:space:]]*HEALTHCHECK' "$DF" \
  || { echo "Add a HEALTHCHECK"; exit 1; }

grep -Eq 'PYTHONUNBUFFERED' "$DF" \
  || { echo "Set PYTHONUNBUFFERED (e.g. ENV PYTHONUNBUFFERED=1)"; exit 1; }

docker build -t challenge-02:fixed /root/shop/challenges/02-nonroot >/tmp/c02-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c02-build.log; exit 1; }

uid="$(docker run --rm challenge-02:fixed id -u)"
[[ "$uid" != "0" ]] || { echo "Container still runs as root (uid=0)"; exit 1; }

echo "Challenge 2 passed: non-root uid=${uid}, HEALTHCHECK + PYTHONUNBUFFERED present."

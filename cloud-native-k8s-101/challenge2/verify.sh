#!/usr/bin/env bash
# Verify via Docker Engine API / image runtime — not Dockerfile text.
set -euo pipefail

CTX=/root/shop/challenges/02-nonroot
[[ -d "$CTX" ]] || { echo "Missing $CTX"; exit 1; }

docker build -t challenge-02:fixed "$CTX" >/tmp/c02-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c02-build.log; exit 1; }

img_user="$(docker image inspect challenge-02:fixed --format '{{.Config.User}}')"
[[ -n "${img_user}" && "${img_user}" != "root" && "${img_user}" != "0" ]] \
  || { echo "Image Config.User must be non-root (got '${img_user}')"; exit 1; }

hc="$(docker image inspect challenge-02:fixed --format '{{json .Config.Healthcheck}}')"
[[ -n "${hc}" && "${hc}" != "null" ]] \
  || { echo "Image has no HEALTHCHECK (Config.Healthcheck is empty)"; exit 1; }

env_block="$(docker image inspect challenge-02:fixed --format '{{range .Config.Env}}{{println .}}{{end}}')"
echo "${env_block}" | grep -Eq '^PYTHONUNBUFFERED=' \
  || { echo "Image Config.Env missing PYTHONUNBUFFERED=..."; exit 1; }

uid="$(docker run --rm --entrypoint id challenge-02:fixed -u)"
[[ "$uid" != "0" ]] || { echo "Container still runs as root (uid=0)"; exit 1; }

echo "Challenge 2 passed: User=${img_user} uid=${uid}; HEALTHCHECK + PYTHONUNBUFFERED in image config."

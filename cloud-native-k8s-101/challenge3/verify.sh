#!/usr/bin/env bash
# Verify via Docker Engine API / image runtime — not Dockerfile text.
set -euo pipefail

CTX=/root/shop/challenges/03-no-secrets
[[ -d "$CTX" ]] || { echo "Missing $CTX"; exit 1; }

docker build -t challenge-03:fixed "$CTX" >/tmp/c03-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c03-build.log; exit 1; }

env_block="$(docker image inspect challenge-03:fixed --format '{{range .Config.Env}}{{println .}}{{end}}')"
if echo "${env_block}" | grep -Eqi 'API_KEY=|acme-super-secret|do-not-ship'; then
  echo "Secret still present in image Config.Env — remove baked-in API_KEY and rebuild"
  echo "${env_block}" | grep -Ei 'API_KEY=|acme-super-secret|do-not-ship' || true
  exit 1
fi

if docker history --no-trunc challenge-03:fixed 2>/dev/null | grep -Eqi 'acme-super-secret|API_KEY='; then
  echo "Secret still visible in docker history — rebuild after removing ENV"
  exit 1
fi

img_user="$(docker image inspect challenge-03:fixed --format '{{.Config.User}}')"
[[ -n "${img_user}" && "${img_user}" != "root" && "${img_user}" != "0" ]] \
  || { echo "Image Config.User must be non-root (practice from challenge 2; got '${img_user}')"; exit 1; }

uid="$(docker run --rm --entrypoint id challenge-03:fixed -u)"
[[ "$uid" != "0" ]] || { echo "Container still runs as root (uid=0)"; exit 1; }

echo "Challenge 3 passed: no secret in image config/history; User=${img_user} uid=${uid}."

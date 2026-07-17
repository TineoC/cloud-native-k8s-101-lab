#!/usr/bin/env bash
set -euo pipefail

DF=/root/shop/challenges/03-no-secrets/Dockerfile
[[ -f "$DF" ]] || { echo "Missing $DF"; exit 1; }

if grep -Eiq 'API_KEY|super-secret|do-not-ship' "$DF"; then
  echo "Remove secrets / API_KEY from the Dockerfile"
  exit 1
fi

grep -Eq '^[[:space:]]*USER[[:space:]]+' "$DF" \
  || { echo "Add a non-root USER (practice from challenge 2)"; exit 1; }

grep -Eq '^[[:space:]]*USER[[:space:]]+root[[:space:]]*$' "$DF" \
  && { echo "USER must not be root"; exit 1; }

docker build -t challenge-03:fixed /root/shop/challenges/03-no-secrets >/tmp/c03-build.log 2>&1 \
  || { echo "docker build failed:"; tail -30 /tmp/c03-build.log; exit 1; }

# Belt-and-suspenders: secret string must not appear in image history config
if docker history --no-trunc challenge-03:fixed 2>/dev/null | grep -Eqi 'acme-super-secret|API_KEY='; then
  echo "Secret still visible in docker history — rebuild after removing ENV"
  exit 1
fi

echo "Challenge 3 passed: no baked-in secrets; non-root image builds."

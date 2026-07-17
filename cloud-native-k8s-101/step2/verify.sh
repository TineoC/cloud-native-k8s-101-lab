#!/usr/bin/env bash
set -euo pipefail

docker image inspect acme-shop:local >/dev/null
docker image inspect acme-shop:lab >/dev/null \
  || { echo "Challenge: tag acme-shop:lab (docker tag acme-shop:local acme-shop:lab)"; exit 1; }

grep -Eq '^[[:space:]]*USER[[:space:]]+' /root/shop/Dockerfile \
  || { echo "Challenge: reference Dockerfile should contain USER"; exit 1; }

echo "Images acme-shop:local and acme-shop:lab present; Dockerfile has USER."

#!/usr/bin/env bash
set -euo pipefail

DF=/root/shop/Dockerfile

grep -Eq '^[[:space:]]*USER[[:space:]]+' "$DF" \
  || { echo "Challenge: edit Dockerfile — add a non-root USER (still missing)"; exit 1; }

grep -Eq '^[[:space:]]*USER[[:space:]]+root[[:space:]]*$' "$DF" \
  && { echo "Challenge: USER must not be root"; exit 1; }

docker image inspect acme-shop:local >/dev/null 2>&1 \
  || { echo "Build acme-shop:local after fixing the Dockerfile (./scripts/build-and-load.sh)"; exit 1; }

docker image inspect acme-shop:lab >/dev/null 2>&1 \
  || { echo "Challenge: tag acme-shop:lab (docker tag acme-shop:local acme-shop:lab)"; exit 1; }

img_user="$(docker image inspect acme-shop:local --format '{{.Config.User}}')"
[[ -n "${img_user}" && "${img_user}" != "root" && "${img_user}" != "0" ]] \
  || { echo "Challenge: rebuild after USER — image still runs as root (Config.User='${img_user}')"; exit 1; }

echo "OK: Dockerfile USER set; acme-shop:local + :lab tagged; image User=${img_user}"

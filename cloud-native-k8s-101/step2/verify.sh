#!/usr/bin/env bash
# Verify via Docker Engine API — not Dockerfile text.
set -euo pipefail

docker image inspect acme-shop:local >/dev/null 2>&1 \
  || { echo "Build acme-shop:local after fixing the Dockerfile (./scripts/build-and-load.sh)"; exit 1; }

docker image inspect acme-shop:lab >/dev/null 2>&1 \
  || { echo "Tag acme-shop:lab (docker tag acme-shop:local acme-shop:lab)"; exit 1; }

img_user="$(docker image inspect acme-shop:lab --format '{{.Config.User}}')"
[[ -n "${img_user}" && "${img_user}" != "root" && "${img_user}" != "0" ]] \
  || { echo "Rebuild after USER — image still runs as root (Config.User='${img_user}')"; exit 1; }

echo "OK: acme-shop:local + :lab tagged; image Config.User=${img_user}"

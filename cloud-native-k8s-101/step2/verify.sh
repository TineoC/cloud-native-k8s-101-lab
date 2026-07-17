#!/usr/bin/env bash
set -euo pipefail

docker image inspect acme-shop:local >/dev/null
echo "Image acme-shop:local exists."

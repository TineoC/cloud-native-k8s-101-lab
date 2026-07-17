#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
kubectl apply -f "${ROOT}/assets/manifests/namespace.yaml"
kubectl label namespace shop purpose=coffee-and-code --overwrite
echo "Setup complete. Namespace shop is ready."

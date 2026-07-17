#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT}"

IMAGE_NAME=cloud-native-101-app:local
KEY="${ROOT}/cosign.pub"
if [[ ! -f "${KEY}" ]]; then
  KEY="${ROOT}/stretch/scripts/cosign.pub"
fi

echo "Verifying signed image ${IMAGE_NAME}..."
cosign verify --key "${KEY}" "${IMAGE_NAME}"

echo "Image signature is valid."

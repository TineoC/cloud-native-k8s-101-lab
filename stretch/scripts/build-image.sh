#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT}"

IMAGE_NAME=cloud-native-101-app:local
SBOM_FILE=sbom.spdx.json

docker buildx build --load --tag "${IMAGE_NAME}" --sbom="${SBOM_FILE}" .

echo "Scanning ${IMAGE_NAME} with trivy..."
trivy image --exit-code 0 --format table "${IMAGE_NAME}"

echo "Signing image with cosign..."
cosign sign --key stretch/scripts/cosign.key "${IMAGE_NAME}" 2>/dev/null || cosign sign --key cosign.key "${IMAGE_NAME}"

echo "Image build, scan, and signing complete."

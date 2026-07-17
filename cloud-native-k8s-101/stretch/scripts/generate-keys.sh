#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT}"

if [[ -f cosign.key || -f cosign.pub ]]; then
  echo "Cosign keys already exist in lab root."
  exit 0
fi

cosign generate-key-pair
echo "Keys written to ${ROOT}/cosign.key and cosign.pub"

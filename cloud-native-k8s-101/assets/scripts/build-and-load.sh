#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-acme-shop:local}"

echo "Building ${IMAGE_NAME}..."
docker build -t "${IMAGE_NAME}" .

# Killercoda kubeadm uses containerd — import so kubelet can pull locally.
if command -v ctr >/dev/null 2>&1; then
  echo "Loading image into containerd (k8s.io namespace)..."
  docker save "${IMAGE_NAME}" | ctr -n k8s.io images import -
fi

echo "Image ready: ${IMAGE_NAME}"
docker images "${IMAGE_NAME}"

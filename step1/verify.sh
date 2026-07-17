#!/usr/bin/env bash
set -euo pipefail

kubectl get nodes --no-headers | grep -qi Ready
kubectl get ns shop >/dev/null
echo "Cluster reachable and shop namespace present."

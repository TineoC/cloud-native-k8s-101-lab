#!/usr/bin/env bash
# Runs when the scenario opens (Killercoda intro background).
set -euo pipefail

echo "Waiting for Kubernetes API..."
for i in $(seq 1 60); do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl apply -f /root/shop/manifests/namespace.yaml >/dev/null 2>&1 || true

chmod +x /root/shop/scripts/*.sh 2>/dev/null || true

# Marker so foreground / steps know prepare finished.
touch /tmp/.shop-lab-ready
echo "Shop lab environment ready."

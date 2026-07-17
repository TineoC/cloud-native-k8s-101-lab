#!/usr/bin/env bash
set -euo pipefail

kubectl get gatewayclass webapp-gw >/dev/null
kubectl get gateway shop-gateway -n shop >/dev/null
kubectl get httproute checkout-route -n shop >/dev/null
echo "Gateway API objects present (platform Gateway + app HTTPRoute)."

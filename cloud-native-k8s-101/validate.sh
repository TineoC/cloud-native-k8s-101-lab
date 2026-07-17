#!/usr/bin/env bash
set -euo pipefail
echo "Validating lab state..."
kubectl get namespace shop
kubectl get deploy,svc -n shop
kubectl get pods -n shop
echo "Validation complete."

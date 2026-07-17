#!/usr/bin/env bash
set -euo pipefail

kubectl get nodes --no-headers | grep -qi Ready
kubectl get ns shop >/dev/null

team="$(kubectl get ns shop -o jsonpath='{.metadata.labels.team}')"
envl="$(kubectl get ns shop -o jsonpath='{.metadata.labels.env}')"
[[ "${team}" == "acme" ]] || { echo "Challenge: label team=acme missing (got '${team}')"; exit 1; }
[[ "${envl}" == "lab" ]] || { echo "Challenge: label env=lab missing (got '${envl}')"; exit 1; }

echo "Cluster reachable; shop namespace labeled team=acme env=lab."

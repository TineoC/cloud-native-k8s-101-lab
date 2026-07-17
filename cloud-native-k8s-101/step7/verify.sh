#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy payments -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "2" ]] || { echo "Challenge: scale payments to 2 ready replicas (got ${ready:-0})"; exit 1; }

eps="$(kubectl get endpoints payments -n shop -o jsonpath='{.subsets[*].addresses[*].ip}')"
[[ -n "${eps}" ]] || { echo "payments Service has no endpoints"; exit 1; }

addr_count="$(kubectl get endpoints payments -n shop -o jsonpath='{.subsets[*].addresses[*].ip}' | wc -w | tr -d ' ')"
[[ "${addr_count}" -ge 2 ]] || { echo "Challenge: expect >=2 endpoint addresses (got ${addr_count})"; exit 1; }

echo "payments HA OK: 2 replicas with endpoints."

#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "2" ]]
count="$(kubectl get pods -n shop -l app=checkout --field-selector=status.phase=Running --no-headers | wc -l | tr -d ' ')"
[[ "${count}" -ge 2 ]]
echo "Self-healing OK: checkout still has 2 running pods."

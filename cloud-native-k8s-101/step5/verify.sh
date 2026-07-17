#!/usr/bin/env bash
set -euo pipefail

kubectl get svc checkout -n shop >/dev/null
eps="$(kubectl get endpoints checkout -n shop -o jsonpath='{.subsets[*].addresses[*].ip}')"
[[ -n "${eps}" ]]
echo "Service checkout has endpoints: ${eps}"

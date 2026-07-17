#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy payments -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "1" ]]
eps="$(kubectl get endpoints payments -n shop -o jsonpath='{.subsets[*].addresses[*].ip}')"
[[ -n "${eps}" ]]
echo "payments service is up with endpoints."

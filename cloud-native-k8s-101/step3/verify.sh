#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "2" ]]
echo "checkout Deployment has 2 ready replicas."

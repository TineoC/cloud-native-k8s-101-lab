#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "3" ]] || { echo "Challenge: scale checkout to 3 ready replicas (got ${ready:-0})"; exit 1; }
echo "checkout Deployment has 3 ready replicas."

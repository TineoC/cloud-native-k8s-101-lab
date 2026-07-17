#!/usr/bin/env bash
set -euo pipefail

kubectl get configmap checkout-config -n shop >/dev/null
kubectl get secret checkout-secret -n shop >/dev/null

env_yaml="$(kubectl get deploy checkout -n shop -o yaml)"
echo "${env_yaml}" | grep -q 'name: checkout-config'
echo "${env_yaml}" | grep -q 'name: checkout-secret'

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "2" ]]
echo "ConfigMap + Secret wired into checkout Deployment."

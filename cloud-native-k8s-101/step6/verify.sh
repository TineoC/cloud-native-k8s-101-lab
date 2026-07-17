#!/usr/bin/env bash
set -euo pipefail

kubectl get configmap checkout-config -n shop >/dev/null
kubectl get secret checkout-secret -n shop >/dev/null

env_yaml="$(kubectl get deploy checkout -n shop -o yaml)"
echo "${env_yaml}" | grep -q 'name: checkout-config'
echo "${env_yaml}" | grep -q 'name: checkout-secret'

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "3" ]] || { echo "checkout should have 3 ready replicas (got ${ready:-0})"; exit 1; }

environment="$(kubectl get configmap checkout-config -n shop -o jsonpath='{.data.ENVIRONMENT}')"
[[ "${environment}" == "lab" ]] || { echo "Challenge: set ConfigMap ENVIRONMENT=lab (got '${environment}')"; exit 1; }

welcome="$(kubectl get configmap checkout-config -n shop -o jsonpath='{.data.WELCOME_MESSAGE}')"
echo "${welcome}" | grep -q 'Coffee & Code' \
  || { echo "Challenge: WELCOME_MESSAGE must contain 'Coffee & Code' (got '${welcome}')"; exit 1; }

echo "ConfigMap + Secret wired; challenge ConfigMap values OK."

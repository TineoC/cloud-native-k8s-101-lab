#!/usr/bin/env bash
set -euo pipefail

kubectl get svc checkout -n shop >/dev/null
eps="$(kubectl get endpoints checkout -n shop -o jsonpath='{.subsets[*].addresses[*].ip}')"
[[ -n "${eps}" ]] || { echo "checkout Service has no endpoints"; exit 1; }

sel="$(kubectl get svc checkout-debug -n shop -o jsonpath='{.spec.selector.app}' 2>/dev/null || true)"
[[ "${sel}" == "checkout" ]] || { echo "Challenge: fix checkout-debug selector to app=checkout (got '${sel}')"; exit 1; }

deps="$(kubectl get endpoints checkout-debug -n shop -o jsonpath='{.subsets[*].addresses[*].ip}')"
[[ -n "${deps}" ]] || { echo "Challenge: checkout-debug still has no endpoints"; exit 1; }

echo "Services OK: checkout + fixed checkout-debug have endpoints."

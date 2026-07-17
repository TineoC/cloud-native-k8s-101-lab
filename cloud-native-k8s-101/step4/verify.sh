#!/usr/bin/env bash
set -euo pipefail

ready="$(kubectl get deploy checkout -n shop -o jsonpath='{.status.readyReplicas}')"
[[ "${ready}" == "3" ]] || { echo "Expected 3 ready replicas (got ${ready:-0})"; exit 1; }

count="$(kubectl get pods -n shop -l app=checkout --field-selector=status.phase=Running --no-headers | wc -l | tr -d ' ')"
[[ "${count}" -ge 3 ]] || { echo "Expected >=3 running checkout pods"; exit 1; }

anno="$(kubectl get deploy checkout -n shop -o jsonpath='{.metadata.annotations.lab\.acme/probes}')"
[[ "${anno}" == "verified" ]] || { echo "Challenge: annotate lab.acme/probes=verified"; exit 1; }

echo "Self-healing OK: 3 pods + probes annotation present."

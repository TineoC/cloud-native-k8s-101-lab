#!/usr/bin/env bash
set -euo pipefail

type="$(kubectl get svc checkout-external -n shop -o jsonpath='{.spec.type}')"
[[ "${type}" == "NodePort" ]] || { echo "checkout-external must be type NodePort (got ${type})"; exit 1; }

node_port="$(kubectl get svc checkout-external -n shop -o jsonpath='{.spec.ports[0].nodePort}')"
[[ "${node_port}" == "30080" ]] || { echo "expected nodePort 30080 (got ${node_port})"; exit 1; }

NODE_IP="$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')"
curl -fsS "http://${NODE_IP}:30080/healthz" | grep -q '"status": "ok\|"status":"ok"' \
  || curl -fsS "http://${NODE_IP}:30080/healthz" | grep -qi ok \
  || { echo "NodePort did not respond on ${NODE_IP}:30080/healthz"; exit 1; }

echo "NodePort exposure OK: http://${NODE_IP}:30080"

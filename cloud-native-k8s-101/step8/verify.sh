#!/usr/bin/env bash
set -euo pipefail

type="$(kubectl get svc checkout-external -n shop -o jsonpath='{.spec.type}')"
[[ "${type}" == "NodePort" ]] || { echo "checkout-external must be type NodePort (got ${type})"; exit 1; }

node_port="$(kubectl get svc checkout-external -n shop -o jsonpath='{.spec.ports[0].nodePort}')"
[[ "${node_port}" == "30080" ]] || { echo "expected nodePort 30080 (got ${node_port})"; exit 1; }

owner="$(kubectl get svc checkout-external -n shop -o jsonpath='{.metadata.labels.owner}')"
expose="$(kubectl get svc checkout-external -n shop -o jsonpath='{.metadata.labels.expose}')"
[[ "${owner}" == "app-team" ]] || { echo "Challenge: label owner=app-team (got '${owner}')"; exit 1; }
[[ "${expose}" == "public" ]] || { echo "Challenge: label expose=public (got '${expose}')"; exit 1; }

NODE_IP="$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')"
curl -fsS "http://${NODE_IP}:30080/healthz" | grep -qi ok \
  || { echo "NodePort did not respond on ${NODE_IP}:30080/healthz"; exit 1; }
curl -fsS "http://${NODE_IP}:30080/checkout" | grep -qi checkout \
  || { echo "Challenge: /checkout via NodePort should return checkout JSON"; exit 1; }

echo "NodePort exposure OK: http://${NODE_IP}:30080 (labeled owner=app-team expose=public)"

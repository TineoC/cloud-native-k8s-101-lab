## Probes = self-healing traffic control

From the talk:

| Probe | Job |
|-------|-----|
| **Startup** | Slow boot? delay other probes |
| **Liveness** | Hung process? restart container |
| **Readiness** | Not ready? remove from Service endpoints |

Large AI/inference platforms rely on this so bad replicas stop taking traffic without human SSH.

## Prove healing

```bash
kubectl get pods -n shop -l app=checkout -o wide
POD=$(kubectl get pods -n shop -l app=checkout -o jsonpath='{.items[0].metadata.name}')
echo "Deleting $POD ..."
kubectl delete pod "$POD" -n shop
kubectl wait --for=condition=Ready pod -l app=checkout -n shop --timeout=90s
kubectl get pods -n shop -l app=checkout -o wide
```{{exec}}

Optional: run `kubectl get pods -n shop -l app=checkout -w` yourself to watch live. Then inspect probes:

```bash
kubectl get pod -n shop -l app=checkout -o jsonpath='{range .items[*]}{.metadata.name}{" ready="}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}'
kubectl get deploy checkout -n shop -o yaml | grep -A6 -E 'startupProbe|readinessProbe|livenessProbe'
```{{exec}}

**Check:** still 2 ready checkout Pods after the delete.

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

Inspect probes on the live Deployment:

```bash
kubectl get deploy checkout -n shop -o yaml | grep -A6 -E 'startupProbe|readinessProbe|livenessProbe'
```{{exec}}

### Challenge

Annotate the Deployment to record that you verified probes, then trigger a **rolling restart** (common during config/image bumps):

```bash
kubectl annotate deployment/checkout -n shop lab.acme/probes=verified --overwrite
kubectl rollout restart deployment/checkout -n shop
kubectl rollout status deployment/checkout -n shop --timeout=120s
```

**Check:** still **3** ready Pods, and annotation `lab.acme/probes=verified` is set.

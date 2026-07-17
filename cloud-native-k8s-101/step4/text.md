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
```{{exec}}

```bash
POD=$(kubectl get pods -n shop -l app=checkout -o jsonpath='{.items[0].metadata.name}') && echo "Deleting $POD ..." && kubectl delete pod "$POD" -n shop
```{{exec}}

```bash
kubectl wait --for=condition=Ready pod -l app=checkout -n shop --timeout=90s
```{{exec}}

```bash
kubectl get pods -n shop -l app=checkout -o wide
```{{exec}}

Inspect probes on the live Deployment:

```bash
kubectl get deploy checkout -n shop -o yaml | grep -A6 -E 'startupProbe|readinessProbe|livenessProbe'
```{{exec}}

### Challenge

Annotate the Deployment, then trigger a **rolling restart**:

```bash
kubectl annotate deployment/checkout -n shop lab.acme/probes=verified --overwrite
```{{exec}}

```bash
kubectl rollout restart deployment/checkout -n shop
```{{exec}}

```bash
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

**Check:** still **3** ready Pods, and annotation `lab.acme/probes=verified` is set.

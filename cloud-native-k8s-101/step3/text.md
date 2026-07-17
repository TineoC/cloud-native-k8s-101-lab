## Pods & Deployments

A **Pod** is the smallest deployable unit (one or more containers sharing network/storage). You rarely create Pods by hand.

A **Deployment** owns desired replica count; a ReplicaSet keeps Pods alive. Delete a Pod → another appears. Same idea at smaller scale as Kapiche riding 10× spikes on GKE: declare desired state, let controllers reconcile.

## Deploy checkout

```bash
cd /root/shop
```{{exec}}

```bash
kubectl apply -f manifests/namespace.yaml
```{{exec}}

```bash
kubectl apply -f manifests/checkout-deployment.yaml
```{{exec}}

```bash
kubectl apply -f manifests/checkout-service.yaml
```{{exec}}

```bash
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

```bash
kubectl get pods,deploy,rs -n shop -o wide
```{{exec}}

Inspect the desired → actual relationship:

```bash
kubectl describe deployment checkout -n shop | sed -n '1,40p'
```{{exec}}

Optional: `k9s -n shop` (quit with `:q`).

### Challenge

Scale checkout like a traffic spike (leave it at **3** replicas):

```bash
kubectl scale deployment/checkout -n shop --replicas=3
```{{exec}}

```bash
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

```bash
kubectl get deploy,pods -n shop -l app=checkout
```{{exec}}

**Check:** Deployment `checkout` has **3** ready replicas.

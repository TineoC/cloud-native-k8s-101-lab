## Why this matters

Production is not “it works on my laptop.” Enterprises run **distributed** apps: APIs, workers, caches, databases — with security, supply chain, HA, and observability.

Kubernetes became the default control plane:

- **OpenAI** — 7,500-node clusters for research workloads
- **Anthropic** — Claude inference on GKE
- **AT&T** — Ask AT&T gen-AI on AKS
- **Kapiche** — AI on GKE through 10× spikes

You never SSH to “fix the app.” You tell the **API** what you want; controllers reconcile.

## Explore your cluster

Click each command separately (Killercoda pastes a whole block at once):

```bash
cd /root/shop
```{{exec}}

```bash
kubectl apply -f manifests/namespace.yaml
```{{exec}}

```bash
kubectl get nodes -o wide
```{{exec}}

```bash
kubectl get --raw='/readyz?verbose' 2>/dev/null | head -20 || true
```{{exec}}

```bash
kubectl api-resources | head -30
```{{exec}}

```bash
kubectl get ns
```{{exec}}

### Challenge

Label the `shop` namespace so platform tooling can find it (`team=acme`, `env=lab`):

```bash
kubectl label namespace shop team=acme env=lab --overwrite
```{{exec}}

```bash
kubectl get ns shop --show-labels
```{{exec}}

**Check:** API is Ready, namespace `shop` exists, and both labels are set.

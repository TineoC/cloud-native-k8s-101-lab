## Why this matters

Production is not “it works on my laptop.” Enterprises run **distributed** apps: APIs, workers, caches, databases — with security, supply chain, HA, and observability.

Kubernetes became the default control plane:

- **OpenAI** — 7,500-node clusters for research workloads
- **Anthropic** — Claude inference on GKE
- **AT&T** — Ask AT&T gen-AI on AKS
- **Kapiche** — AI on GKE through 10× spikes

You never SSH to “fix the app.” You tell the **API** what you want; controllers reconcile.

## Explore your cluster

```bash
cd /root/shop
kubectl apply -f manifests/namespace.yaml
kubectl get nodes -o wide
kubectl get --raw='/readyz?verbose' 2>/dev/null | head -20 || true
kubectl api-resources | head -30
kubectl get ns
```{{exec}}

You should see a ready control-plane node (Killercoda’s single-node kubeadm). Namespace `shop` may already exist from lab prepare.

**Check:** confirm the API answers and list namespaces.

# Killercoda Lab: Cloud Native Kubernetes 101 (Acme Shop)

Hands-on companion for **Coffee & Code Philly** — covers the talk deck with an enterprise-style shop:

containers → Deployments/probes → Services → ConfigMaps/Secrets → multi-service DNS → Gateway API ownership.

Enterprise stories referenced in-lab: OpenAI (7,500-node K8s), Anthropic (GKE), NVIDIA (GPU DRA), Kapiche (GKE spikes), AT&T (AKS).

## Steps

1. Explore the cluster (control plane / API)
2. Package with Docker (+ Compose peek)
3. Deployments & replicas
4. Self-healing with probes
5. Services & selectors
6. ConfigMaps & Secrets
7. Payments backend (ClusterIP DNS)
8. Gateway API platform vs app ownership

## Layout

| Path | Purpose |
|------|---------|
| `index.json` | Killercoda scenario definition |
| `step*/` | Step markdown + `verify.sh` |
| `assets/` | Files uploaded into the Killercoda VM at `/root/shop` |
| `stretch/` | Optional advanced track (local / early finishers) |

## Local run (kind / minikube / Killercoda)

```bash
cd assets
chmod +x scripts/*.sh
./scripts/build-and-load.sh
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/checkout-deployment.yaml
kubectl apply -f manifests/checkout-service.yaml
```

## Publish to Killercoda

1. Put this scenario at the **root** of a GitHub repo (or a dedicated scenario folder Killercoda can discover).
2. Creator → add repo + branch → deploy key + webhook.
3. Push; open the public scenario URL.

Validate locally:

```bash
pip install killercoda-cli
killercoda-cli validate
```

# Killercoda Lab: Cloud Native Kubernetes 101 (Acme Shop)

Hands-on companion for **Coffee & Code Philly** — covers the talk deck with an enterprise-style shop:

containers → Deployments/probes → Services → ConfigMaps/Secrets → multi-service DNS → Gateway API ownership.

Enterprise stories referenced in-lab: OpenAI (7,500-node K8s), Anthropic (GKE), NVIDIA (GPU DRA), Kapiche (GKE spikes), AT&T (AKS).

**GitHub:** https://github.com/TineoC/cloud-native-k8s-101-lab  

**Publish steps:** see [PUBLISH.md](PUBLISH.md) (connect this repo in Killercoda Creator once).

## Steps

1. Explore the cluster (control plane / API)
2. Dockerfile best practices + build Acme Shop image
3. Challenge: slim base, narrow `COPY`, exec-form `CMD`
4. Challenge: non-root `USER` + `HEALTHCHECK`
5. Challenge: never bake secrets into images
6. Deployments & replicas
7. Self-healing with probes
8. Services & selectors
9. ConfigMaps & Secrets
10. Payments backend (ClusterIP DNS)
11. Gateway API platform vs app ownership

## Layout

| Path | Purpose |
|------|---------|
| `index.json` | Killercoda scenario definition |
| `step*/` | Step markdown + `verify.sh` |
| `assets/` | Files uploaded into the Killercoda VM at `/root/shop` |
| `stretch/` | Optional advanced track (local / early finishers) |
| `PUBLISH.md` | One-time Killercoda Creator + GitHub wiring |
| `scripts/apply-killercoda-github-access.sh` | Apply deploy key / webhook via `gh` |

## Local run (kind / minikube / Killercoda)

```bash
cd assets
chmod +x scripts/*.sh
./scripts/build-and-load.sh
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/checkout-deployment.yaml
kubectl apply -f manifests/checkout-service.yaml
```

## Validate

```bash
pip install killercoda-cli
killercoda-cli validate
```

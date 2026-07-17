# Killercoda Lab: Cloud Native Kubernetes 101 (Acme Shop)

Hands-on companion for **Coffee & Code Philly** — covers the talk deck with an enterprise-style shop:

containers → Deployments/probes → Services → ConfigMaps/Secrets → multi-service DNS → NodePort exposure.

Enterprise stories referenced in-lab: OpenAI (7,500-node K8s), Anthropic (GKE), NVIDIA (GPU DRA), Kapiche (GKE spikes), AT&T (AKS).

**GitHub:** https://github.com/TineoC/cloud-native-k8s-101-lab  

**Publish steps:** see [PUBLISH.md](PUBLISH.md) (connect this repo in Killercoda Creator once).

## Steps (each has a Challenge)

1. Explore cluster — label `shop` (`team=acme`, `env=lab`)
2. Dockerfile practices + build — tag `acme-shop:lab`
3. Fix Dockerfile: slim base + `COPY app.py` only
4. Fix Dockerfile: non-root + `HEALTHCHECK`
5. Fix Dockerfile: no baked-in secrets
6. Deployments — scale checkout to 3
7. Probes — annotate + rolling restart
8. Services — fix broken selector on `checkout-debug`
9. ConfigMaps/Secrets — set lab welcome / `ENVIRONMENT=lab`
10. Payments — scale to 2 replicas
11. NodePort — label `owner=app-team` `expose=public`

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

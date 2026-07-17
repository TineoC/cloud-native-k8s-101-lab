## Containers: the shipping unit

Containers share the host kernel (namespaces + cgroups) — lighter than VMs. Docker made the packaging UX usable: each Dockerfile line is a **layer**.

`docker-compose.yml` in this lab shows the **laptop company stack** pattern from the talk. Compose is great for onboarding; production still needs an orchestrator (healing, rollouts, multi-host).

## Build and load the shop image

```bash
cd /root/shop
chmod +x scripts/*.sh
./scripts/build-and-load.sh
docker images acme-shop:local
```{{exec}}

Optional peek at Compose (Compose is pre-installed — great for laptop stacks; K8s still wins in prod):

```bash
cd /root/shop
docker compose config
cat docker-compose.yml
```{{exec}}

Cluster UI tip: `k9s` is also pre-installed — try it anytime after deploy (`:namespace shop`, then browse Pods).

**Enterprise note:** platforms like OpenAI/Anthropic still start from container images — then schedule thousands of them with Kubernetes.

**Check:** image `acme-shop:local` exists locally.

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

Optional peek at Compose (do not need it running for later steps):

```bash
cat /root/shop/docker-compose.yml
```{{exec}}

**Enterprise note:** platforms like OpenAI/Anthropic still start from container images — then schedule thousands of them with Kubernetes.

**Check:** image `acme-shop:local` exists locally.

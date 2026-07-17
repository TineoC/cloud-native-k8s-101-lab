## Containers: the shipping unit

Containers share the host kernel (namespaces + cgroups). Docker made packaging usable: each Dockerfile instruction becomes a **layer**.

### Dockerfile best practices (enterprise defaults)

| Practice | Why it matters |
|----------|----------------|
| Prefer **slim/distroless** bases | Smaller image → faster pulls, smaller CVE surface |
| **COPY only what you need** | Avoids leaking `.git`, keys, lab junk into layers |
| Use a **`.dockerignore`** | Keeps build context small and safe |
| **Non-root `USER`** | Matches Pod Security / most org policies |
| **Exec-form `CMD`/`ENTRYPOINT`** (`["cmd","arg"]`) | Correct signals; app is PID 1 |
| **No secrets in the image** | `ENV API_KEY=...` is forever in layer history |
| Pin / be deliberate about tags | `python:3.12-slim` beats floating `latest` for rebuilds |
| Optional `HEALTHCHECK` | Useful locally; **in Kubernetes, probes still win** |

Open the reference Dockerfile used for Acme Shop:

```bash
cd /root/shop
sed -n '1,80p' Dockerfile
cat .dockerignore
```{{exec}}

## Build and load the shop image

```bash
cd /root/shop
chmod +x scripts/*.sh
./scripts/build-and-load.sh
docker images acme-shop:local
```{{exec}}

Optional Compose peek (Compose is pre-installed — laptop stacks; K8s still wins in prod):

```bash
cd /root/shop
docker compose config
```{{exec}}

### Challenge

Tag the image for promotion-style workflows (same digest, clearer name):

```bash
docker tag acme-shop:local acme-shop:lab
docker image inspect acme-shop:lab >/dev/null
docker images 'acme-shop'
```

Also confirm the reference Dockerfile runs **non-root** (`USER` present) — enterprise default.

**Check:** `acme-shop:local` and `acme-shop:lab` exist; Dockerfile contains `USER`.

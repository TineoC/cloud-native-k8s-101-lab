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
```{{exec}}

```bash
sed -n '1,80p' Dockerfile
```{{exec}}

```bash
cat .dockerignore
```{{exec}}

## Build and load the shop image

```bash
chmod +x scripts/*.sh
```{{exec}}

```bash
./scripts/build-and-load.sh
```{{exec}}

```bash
docker images acme-shop:local
```{{exec}}

Optional Compose peek:

```bash
docker compose config
```{{exec}}

### Challenge

Tag the image for promotion-style workflows, then confirm the reference Dockerfile is non-root:

```bash
docker tag acme-shop:local acme-shop:lab
```{{exec}}

```bash
docker image inspect acme-shop:lab >/dev/null
```{{exec}}

```bash
docker images 'acme-shop'
```{{exec}}

```bash
grep -n '^USER' Dockerfile
```{{exec}}

**Check:** `acme-shop:local` and `acme-shop:lab` exist; Dockerfile contains `USER`.

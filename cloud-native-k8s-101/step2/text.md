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

Open the starter Dockerfile (it currently runs as **root** — you’ll fix that):

```bash
cd /root/shop
```{{exec}}

```bash
cat Dockerfile
```{{exec}}

```bash
cat .dockerignore
```{{exec}}

### Challenge — fix non-root, then build & tag

1. Edit `/root/shop/Dockerfile` so the app does **not** run as root. Add something like:

```dockerfile
RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser
RUN chown -R appuser:appuser /app
USER appuser
```

Put `USER` **after** `COPY` / `chown`, and **before** `CMD`.

2. Rebuild and load into the cluster:

```bash
chmod +x scripts/*.sh
```{{exec}}

```bash
./scripts/build-and-load.sh
```{{exec}}

```bash
docker images acme-shop:local
```{{exec}}

3. Tag for promotion-style workflows:

```bash
docker tag acme-shop:local acme-shop:lab
```{{exec}}

4. Inspect the image and **read** the config (do not hide output). Confirm `"User": "appuser"` (or your non-root user):

```bash
docker image inspect acme-shop:lab | jq '.[0].Config.User, .[0].RepoTags, .[0].Config.Env'
```{{exec}}

```bash
docker images 'acme-shop'
```{{exec}}

Optional Compose peek:

```bash
docker compose config
```{{exec}}

**Check:** images `acme-shop:local` and `acme-shop:lab` exist; `docker image inspect` shows non-root `Config.User`.

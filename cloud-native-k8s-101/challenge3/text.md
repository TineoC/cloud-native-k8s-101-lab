## Challenge 3 — Never bake secrets into images

Broken file: `/root/shop/challenges/03-no-secrets/Dockerfile`

It sets:

```dockerfile
ENV API_KEY=acme-super-secret-prod-key-do-not-ship
```

That secret is now in an image **layer** forever (`docker history`, registries, SBOMs). Same lesson as the talk’s Secrets slide: **base64 ≠ encryption**, and Dockerfile `ENV` is even worse for prod keys.

### Your job

1. **Remove** any `API_KEY` / secret `ENV` from the Dockerfile
2. Keep the image runnable (still `COPY app.py`, prefer non-root `USER`)
3. Remember: in Kubernetes you inject secrets at **runtime** (later step: `Secret` + `secretKeyRef`)

```bash
cd /root/shop/challenges/03-no-secrets
```{{exec}}

```bash
cat Dockerfile
```{{exec}}

### Solution lines to paste

Replace the whole file with (note: **create** `appuser` before `USER` — a bare `USER appuser` will fail at runtime):

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY app.py ./
ENV PORT=8080

RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8080
CMD ["python", "app.py"]
```

Then build and confirm via the Docker API / history (not by grepping the file):

```bash
docker build -t challenge-03:fixed .
```{{exec}}

```bash
docker image inspect challenge-03:fixed --format '{{range .Config.Env}}{{println .}}{{end}}'
```{{exec}}

```bash
docker history --no-trunc challenge-03:fixed | head -20
```{{exec}}

```bash
docker image inspect challenge-03:fixed --format 'User={{.Config.User}}'
```{{exec}}

```bash
docker run --rm --entrypoint id challenge-03:fixed -u
```{{exec}}

Expect UID `10001`, not `0`. No `API_KEY` should appear in env or history.

**Check:** no secret in image `Config.Env` / history; non-root `Config.User`; `id -u` ≠ 0.

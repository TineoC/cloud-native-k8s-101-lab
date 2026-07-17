## Challenge 2 — Non-root + HEALTHCHECK

Broken file: `/root/shop/challenges/02-nonroot/Dockerfile`

It builds, but:

1. Runs as **root** (no `USER`)
2. Has **no `HEALTHCHECK`**
3. Omits `PYTHONUNBUFFERED=1` (logs buffered — harder to debug)

### Your job

Edit the Dockerfile to:

- Create a non-root user and `USER` to it
- Add a `HEALTHCHECK` that hits `http://127.0.0.1:8080/healthz`
- Set `ENV PYTHONUNBUFFERED=1` (and keep `PORT=8080`)

```bash
cd /root/shop/challenges/02-nonroot
```{{exec}}

```bash
cat Dockerfile
```{{exec}}

### Solution lines to paste

Replace the trailing `ENV` / `EXPOSE` / `CMD` block (or append before `CMD`) with:

```dockerfile
ENV PORT=8080 \
    PYTHONUNBUFFERED=1

RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthz')"

CMD ["python", "app.py"]
```

Then build and confirm via the Docker API (image config), not by grepping the file:

```bash
docker build -t challenge-02:fixed .
```{{exec}}

```bash
docker image inspect challenge-02:fixed --format 'User={{.Config.User}} Healthcheck={{json .Config.Healthcheck}}'
```{{exec}}

```bash
docker image inspect challenge-02:fixed --format '{{range .Config.Env}}{{println .}}{{end}}' | grep PYTHONUNBUFFERED
```{{exec}}

```bash
docker run --rm --entrypoint id challenge-02:fixed -u
```{{exec}}

Expect a non-zero UID (e.g. `10001`), not `0`. Optional: compare with the shop reference image patterns:

```bash
docker image inspect acme-shop:lab --format 'User={{.Config.User}}' 2>/dev/null || true
```{{exec}}

**Check:** image `challenge-02:fixed` has non-root `Config.User`, a `HEALTHCHECK`, `PYTHONUNBUFFERED` in `Config.Env`, and `id -u` ≠ 0.

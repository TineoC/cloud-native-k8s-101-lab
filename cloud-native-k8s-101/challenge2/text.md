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

Edit `Dockerfile`, then:

```bash
docker build -t challenge-02:fixed .
```{{exec}}

```bash
docker run --rm challenge-02:fixed id -u
```{{exec}}

Expect a non-zero UID (e.g. `10001`), not `0`. Compare with the reference:

```bash
grep -nE 'USER|HEALTHCHECK|PYTHONUNBUFFERED' /root/shop/Dockerfile
```{{exec}}

**Check:** non-root `USER`, `HEALTHCHECK`, `PYTHONUNBUFFERED`, and a successful build.

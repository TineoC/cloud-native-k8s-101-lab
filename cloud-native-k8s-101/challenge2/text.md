## Challenge 2 — Non-root + HEALTHCHECK

Broken file: `/root/shop/challenges/02-nonroot/Dockerfile`

It builds, but:

1. Runs as **root** (no `USER`)
2. Has **no `HEALTHCHECK`**
3. Omits `PYTHONUNBUFFERED=1` (logs can look “stuck”)

### Your job

Edit the Dockerfile to:

- Create a non-root user (e.g. `useradd` / `adduser`) and `USER` to it
- Add a `HEALTHCHECK` that hits `http://127.0.0.1:8080/healthz`
- Set `ENV PYTHONUNBUFFERED=1` (and keep `PORT=8080`)

Prove it:

```bash
cd /root/shop/challenges/02-nonroot
docker build -t challenge-02:fixed .
docker run --rm challenge-02:fixed id -u
# expect a non-zero UID (e.g. 10001), not 0
```

Compare with `/root/shop/Dockerfile` for a working pattern.

**Check:** non-root `USER`, `HEALTHCHECK`, `PYTHONUNBUFFERED`, and a successful build.

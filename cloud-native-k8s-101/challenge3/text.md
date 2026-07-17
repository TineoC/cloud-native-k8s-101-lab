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

Edit `Dockerfile`, then verify it’s clean:

```bash
grep -n -i 'secret\|API_KEY' Dockerfile || echo "looks clean"
```{{exec}}

```bash
docker build -t challenge-03:fixed .
```{{exec}}

```bash
docker history challenge-03:fixed
```{{exec}}

**Check:** no secret/`API_KEY` in the Dockerfile, non-root `USER`, image builds.

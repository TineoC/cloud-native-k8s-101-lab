## Challenge 1 — Layers & build context

Broken file: `/root/shop/challenges/01-layers/Dockerfile`

It currently:

1. Uses a **fat** base (`python:3.12` instead of `slim`)
2. Does `COPY . .` (pulls everything in the folder into the image)
3. Uses **shell-form** `CMD` (weaker signal handling)

### Step A — measure the fat image first

Build the broken Dockerfile **as-is** and note its size:

```bash
cd /root/shop/challenges/01-layers
```{{exec}}

```bash
cat Dockerfile
```{{exec}}

```bash
docker build -t challenge-01:fat .
```{{exec}}

```bash
docker images challenge-01:fat --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'
```{{exec}}

### Step B — fix it (slim + narrow COPY + exec CMD)

Edit `Dockerfile` so it:

- Uses `python:3.12-slim`
- Copies **only** `app.py`
- Uses exec-form: `CMD ["python", "app.py"]`

Then build the fixed image:

```bash
docker build -t challenge-01:fixed .
```{{exec}}

### Step C — compare fat vs slim size

```bash
docker images 'challenge-01' --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'
```{{exec}}

Slim should be **noticeably smaller** than fat (often hundreds of MB less). That’s why enterprises prefer slim/distroless bases.

Prove the slim image still runs:

```bash
docker run --rm -d -p 18080:8080 --name c01 challenge-01:fixed
```{{exec}}

```bash
curl -sS http://127.0.0.1:18080/healthz
```{{exec}}

```bash
docker rm -f c01
```{{exec}}

Stuck? Peek at `/root/shop/Dockerfile` for patterns (after you fixed `USER` in step 2):

```bash
sed -n '1,40p' /root/shop/Dockerfile
```{{exec}}

**Check:** Dockerfile uses slim + `COPY app.py` + JSON `CMD`; both `challenge-01:fat` and `:fixed` exist; slim image is smaller.

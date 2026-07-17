## Challenge 1 — Layers & build context

Broken file: `/root/shop/challenges/01-layers/Dockerfile`

It currently:

1. Uses a **fat** base (`python:3.12` instead of `slim`)
2. Does `COPY . .` (pulls everything in the folder into the image)
3. Uses **shell-form** `CMD` (weaker signal handling)

### Your job

Edit that Dockerfile so it:

- Uses `python:3.12-slim`
- Copies **only** `app.py`
- Uses exec-form: `CMD ["python", "app.py"]`

Then build and prove it works (one click at a time):

```bash
cd /root/shop/challenges/01-layers
```{{exec}}

```bash
cat Dockerfile
```{{exec}}

Edit `Dockerfile` in the IDE (or `vi Dockerfile`), then:

```bash
docker build -t challenge-01:fixed .
```{{exec}}

```bash
docker run --rm -d -p 18080:8080 --name c01 challenge-01:fixed
```{{exec}}

```bash
curl -sS http://127.0.0.1:18080/healthz
```{{exec}}

```bash
docker rm -f c01
```{{exec}}

Hints live in comments at the top of the broken Dockerfile. Peek at `/root/shop/Dockerfile` if you get stuck:

```bash
sed -n '1,40p' /root/shop/Dockerfile
```{{exec}}

**Check:** Dockerfile uses slim + `COPY app.py` + JSON `CMD` (and image builds).

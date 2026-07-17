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

Then build to prove it works:

```bash
cd /root/shop/challenges/01-layers
# edit Dockerfile with vi / nano / the IDE
docker build -t challenge-01:fixed .
docker run --rm -d -p 18080:8080 --name c01 challenge-01:fixed
curl -sS http://127.0.0.1:18080/healthz
docker rm -f c01
```

Hints live in comments at the top of the broken Dockerfile. Peek at `/root/shop/Dockerfile` if you get stuck.

**Check:** Dockerfile uses slim + `COPY app.py` + JSON `CMD` (and image builds).

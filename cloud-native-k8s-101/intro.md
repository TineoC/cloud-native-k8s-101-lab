<br>

### Cloud Native & Kubernetes 101 — Hands-on Lab

Coffee & Code Philly companion lab for the talk deck.

You will run an **Acme Shop** microservices pattern the same way enterprises do on Kubernetes:

- package with containers (Docker)
- deploy with Deployments + probes
- route with Services (and see Gateway API ownership)
- inject ConfigMaps & Secrets without rebuilding

**Enterprise context (from the talk):**

| Org | What they published |
|-----|---------------------|
| OpenAI | Scaled Kubernetes to **7,500 nodes** for GPT-3 / CLIP / DALL·E research |
| Anthropic | Claude inference on **GKE** |
| NVIDIA | GPU DRA driver donated to CNCF |
| Google / Kapiche | AI on GKE through **10×** traffic spikes |
| Microsoft / AT&T | Ask AT&T gen-AI platform on **AKS** |

CNCF 2025: **98%** cloud native adoption · **82%** of container users run K8s in prod.

Lab files live in `/root/shop`. **Docker Compose** and **k9s** are installed on start.

Click **Start** when ready.

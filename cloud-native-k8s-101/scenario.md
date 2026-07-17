# Cloud Native Kubernetes 101 — Lab Scenario

Enterprise **Acme Shop** path aligned to the talk slides.

## Objective

Practice containers and core Kubernetes objects with a checkout + payments layout, citing how large orgs run the same API (OpenAI, Anthropic, AT&T, Kapiche).

## Steps (Killercoda)

1. Explore cluster / API
2. `docker build` + load into containerd
3. Deployment + Service for checkout
4. Delete a Pod → watch probes/healing
5. Service DNS + port-forward
6. ConfigMap + Secret injection (base64 demo)
7. Payments Deployment/Service
8. Gateway API CRDs + Gateway/HTTPRoute ownership

Working directory on Killercoda: `/root/shop` (from `assets/`).

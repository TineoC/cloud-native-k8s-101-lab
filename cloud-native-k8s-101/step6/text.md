## Config without rebuilding · Secrets are not encryption

**ConfigMap** = non-secret settings (flags, URLs, log levels). Same image, different env (laptop → staging → prod).

**Secret** = base64-encoded, **not** encrypted. Real protection = RBAC + etcd encryption at rest + external stores (Vault, cloud secret managers) — the same lesson as the talk slide.

## Apply config and roll the Deployment

```bash
cd /root/shop
```{{exec}}

```bash
kubectl apply -f manifests/checkout-config.yaml
```{{exec}}

```bash
kubectl apply -f manifests/checkout-deployment-config.yaml
```{{exec}}

```bash
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

Prove base64 ≠ encryption:

```bash
kubectl get secret checkout-secret -n shop -o jsonpath='{.data.API_KEY}' | base64 -d; echo
```{{exec}}

```bash
kubectl get configmap checkout-config -n shop -o yaml
```{{exec}}

### Challenge — promote branding without rebuilding

Update the ConfigMap so:

1. `ENVIRONMENT` is `lab`
2. `WELCOME_MESSAGE` contains `Coffee & Code`

```bash
kubectl create configmap checkout-config -n shop \
  --from-literal=WELCOME_MESSAGE='Acme Shop — Coffee & Code' \
  --from-literal=ENVIRONMENT=lab \
  --from-literal=PAYMENTS_URL=http://payments.shop.svc.cluster.local \
  --dry-run=client -o yaml | kubectl apply -f -
```{{exec}}

```bash
kubectl rollout restart deployment/checkout -n shop
```{{exec}}

```bash
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

```bash
kubectl exec -n shop deploy/checkout -- printenv ENVIRONMENT
```{{exec}}

```bash
kubectl exec -n shop deploy/checkout -- printenv WELCOME_MESSAGE
```{{exec}}

**Check:** Deployment uses ConfigMap + Secret; `ENVIRONMENT=lab`; welcome contains `Coffee & Code`.

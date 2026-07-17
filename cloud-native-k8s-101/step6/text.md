## Config without rebuilding · Secrets are not encryption

**ConfigMap** = non-secret settings (flags, URLs, log levels). Same image, different env (laptop → staging → prod).

**Secret** = base64-encoded, **not** encrypted. Real protection = RBAC + etcd encryption at rest + external stores (Vault, cloud secret managers) — the same lesson as the talk slide.

## Apply config and roll the Deployment

```bash
cd /root/shop
kubectl apply -f manifests/checkout-config.yaml
kubectl apply -f manifests/checkout-deployment-config.yaml
kubectl rollout status deployment/checkout -n shop --timeout=120s
```{{exec}}

Prove base64 ≠ encryption:

```bash
kubectl get secret checkout-secret -n shop -o jsonpath='{.data.API_KEY}' | base64 -d; echo
kubectl get configmap checkout-config -n shop -o yaml
```{{exec}}

### Challenge — promote “staging” → lab branding

Update the ConfigMap **without rebuilding the image**:

1. Set `ENVIRONMENT` to `lab`
2. Set `WELCOME_MESSAGE` to contain `Coffee & Code`
3. Roll the Deployment so Pods pick up the change

```bash
kubectl edit configmap checkout-config -n shop
# or:
kubectl create configmap checkout-config -n shop \
  --from-literal=WELCOME_MESSAGE='Acme Shop — Coffee & Code' \
  --from-literal=ENVIRONMENT=lab \
  --from-literal=PAYMENTS_URL=http://payments.shop.svc.cluster.local \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl rollout restart deployment/checkout -n shop
kubectl rollout status deployment/checkout -n shop --timeout=120s
kubectl exec -n shop deploy/checkout -- printenv ENVIRONMENT WELCOME_MESSAGE
```

**Check:** Deployment uses ConfigMap + Secret; `ENVIRONMENT=lab`; welcome message contains `Coffee & Code`.

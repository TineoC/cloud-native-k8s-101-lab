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

Port-forward if needed, then:

```bash
curl -sS http://127.0.0.1:8080/checkout
```

You should see the new welcome message, `environment: staging`, and `api_key_present: true`.

**Check:** Deployment env references ConfigMap + Secret keys.

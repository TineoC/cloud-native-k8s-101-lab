## Services: Pods die, the name stays

Pods are ephemeral. A **Service** gives stable virtual IP + DNS and selects Pods by **labels**.

Service types from the talk:

| Type | Typical use |
|------|-------------|
| **ClusterIP** | Internal backends, DBs, caches (default) |
| **NodePort** | Static high port on every node |
| **LoadBalancer** | Cloud LB (AWS ELB, GCP LB, MetalLB) |

## Hit checkout through the Service

```bash
kubectl get svc checkout -n shop -o wide
kubectl get endpoints checkout -n shop
kubectl run curl-checkout --rm -i --restart=Never --image=curlimages/curl:8.5.0 -n shop -- \
  curl -sS http://checkout.shop.svc.cluster.local/checkout
```{{exec}}

Optional port-forward:

```bash
kubectl port-forward svc/checkout 8080:80 -n shop
# other terminal: curl -sS http://127.0.0.1:8080/checkout
```

### Challenge — fix a broken selector

A common outage: Service exists, but **selector doesn’t match** Pod labels → empty Endpoints.

```bash
kubectl apply -f /root/shop/manifests/challenges/broken-checkout-debug-svc.yaml
kubectl get endpoints checkout-debug -n shop
# expect no addresses
```

Fix the Service selector to `app: checkout` (edit YAML or `kubectl edit svc/checkout-debug -n shop`), then re-apply / save.

```bash
kubectl get endpoints checkout-debug -n shop
kubectl run curl-debug --rm -i --restart=Never --image=curlimages/curl:8.5.0 -n shop -- \
  curl -sS http://checkout-debug.shop.svc.cluster.local/checkout
```

**Check:** `checkout` and `checkout-debug` both have Endpoints.

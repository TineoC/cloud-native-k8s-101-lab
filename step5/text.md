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

From your terminal (host), port-forward like a laptop tunnel:

```bash
kubectl port-forward svc/checkout 8080:80 -n shop
```

In another terminal (or background with `&`):

```bash
curl -sS http://127.0.0.1:8080/checkout
```

**Check:** Service `checkout` exists and has endpoints.

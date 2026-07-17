## Distributed apps need more than one process

Real products look like the talk’s distributed-app diagram: checkout API, payments, cache, data store. On Kubernetes each tier is usually its own Deployment + ClusterIP Service. DNS replaces brittle IPs:

`http://payments.shop.svc.cluster.local`

Same pattern whether you run a Philly startup shop or AT&T-scale AI platforms on AKS — many services, one cluster API.

## Add the payments backend

```bash
cd /root/shop
```{{exec}}

```bash
kubectl apply -f manifests/payments-deployment.yaml
```{{exec}}

```bash
kubectl apply -f manifests/payments-service.yaml
```{{exec}}

```bash
kubectl rollout status deployment/payments -n shop --timeout=120s
```{{exec}}

```bash
kubectl get pods,svc -n shop
```{{exec}}

Call payments **from inside the cluster** (ClusterIP is not public):

```bash
kubectl run curl-payments --rm -i --restart=Never --image=curlimages/curl:8.5.0 -n shop -- curl -sS http://payments.shop.svc.cluster.local/pay
```{{exec}}

### Challenge — HA for payments

Scale payments to **2** replicas:

```bash
kubectl scale deployment/payments -n shop --replicas=2
```{{exec}}

```bash
kubectl rollout status deployment/payments -n shop --timeout=120s
```{{exec}}

```bash
kubectl get pods -n shop -l app=payments
```{{exec}}

```bash
kubectl get endpoints payments -n shop
```{{exec}}

**Check:** `payments` has **2** ready replicas and Endpoints.

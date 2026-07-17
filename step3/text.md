## Pods & Deployments

A **Pod** is the smallest deployable unit (one or more containers sharing network/storage). You rarely create Pods by hand.

A **Deployment** owns desired replica count; a ReplicaSet keeps Pods alive. Delete a Pod → another appears. Same idea at smaller scale as Kapiche riding 10× spikes on GKE: declare desired state, let controllers reconcile.

## Deploy checkout

```bash
cd /root/shop
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/checkout-deployment.yaml
kubectl apply -f manifests/checkout-service.yaml
kubectl rollout status deployment/checkout -n shop --timeout=120s
kubectl get pods,deploy,rs -n shop -o wide
```{{exec}}

Inspect the desired → actual relationship:

```bash
kubectl describe deployment checkout -n shop | sed -n '1,40p'
```{{exec}}

**Check:** Deployment `checkout` has 2 ready replicas in namespace `shop`.

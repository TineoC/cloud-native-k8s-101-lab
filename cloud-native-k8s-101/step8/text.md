## Expose checkout with NodePort

Killercoda’s kubeadm image does **not** ship Gateway API CRDs or an ingress controller. In this lab we expose the shop the simple way: a **NodePort** Service.

Service types (from the talk):

| Type | This lab |
|------|----------|
| **ClusterIP** | Internal only — `checkout` + `payments` stay here |
| **NodePort** | Open a high port (30000–32767) on the node — what we use now |
| **LoadBalancer** | Needs a cloud LB / MetalLB (not available here) |

### Talk context (no install required)

In production, teams often move from NodePort → cloud LB → **Gateway API** (`GatewayClass` / `Gateway` / `HTTPRoute`) with platform vs app ownership. Manifests under `manifests/gateway*.yaml` are **reference only** for that talk sample — do not apply them here.

## Apply NodePort and hit the app

```bash
cd /root/shop
kubectl apply -f manifests/checkout-nodeport.yaml
kubectl get svc -n shop -o wide
```{{exec}}

Reach it via the node IP + port `30080`:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "NodePort URL: http://${NODE_IP}:30080/checkout"
curl -sS "http://${NODE_IP}:30080/checkout"
curl -sS "http://${NODE_IP}:30080/healthz"
```{{exec}}

On Killercoda you can also open traffic to the node port from the UI: {{TRAFFIC_HOST1_30080}}

**Check:** Service `checkout-external` is `NodePort` with port **30080** and answers on `/healthz`.

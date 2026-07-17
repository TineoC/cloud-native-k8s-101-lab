## Gateway API: platform door, app routes

Classic Ingress mixed responsibilities. **Gateway API** splits ownership (talk sample: `shop.example.com/checkout`):

| Role | Objects |
|------|---------|
| **Platform** | `GatewayClass`, `Gateway` (entry, TLS, controller) |
| **App** | `HTTPRoute` → Service → Pods |

This lab installs official CRDs and applies the objects. No ingress controller is running here, so the Gateway will not get a public address — you still practice the **enterprise ownership model** used with Envoy Gateway / Contour / cloud LBs.

## Install CRDs and apply shop ingress objects

```bash
cd /root/shop
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
kubectl wait --for=condition=Established crd/gatewayclasses.gateway.networking.k8s.io --timeout=120s
kubectl apply -f manifests/gatewayclass.yaml
kubectl apply -f manifests/gateway-api.yaml
kubectl get gatewayclass
kubectl get gateway,httproute -n shop
```{{exec}}

Read the ownership labels:

```bash
kubectl get gateway shop-gateway -n shop -o yaml | grep -A2 'owner:'
kubectl get httproute checkout-route -n shop -o yaml | grep -A6 'matches:'
```{{exec}}

Path mental model:

`shop.example.com/checkout` → Gateway → HTTPRoute → Service `checkout` → Pods

**Check:** `GatewayClass/webapp-gw`, `Gateway/shop-gateway`, and `HTTPRoute/checkout-route` exist.

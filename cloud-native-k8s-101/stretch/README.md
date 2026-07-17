# Stretch track (optional)

Finish the main lab first. This folder keeps the **advanced** path for people who finish early or want a follow-up session.

## What is here

| Topic | Location |
|-------|----------|
| Secure image build (buildx SBOM, Trivy, Cosign) | `scripts/build-image.sh`, `scripts/verify-image.sh`, `scripts/generate-keys.sh` |
| Kustomize base + local/cloud overlays | `manifests/base/`, `manifests/overlays/` |
| Gateway API exposure | `manifests/base/gateway-api.yaml` |

## Suggested stretch flow

From the lab root (`killercoda/cloud-native-k8s-101/`):

```bash
./stretch/scripts/generate-keys.sh
./stretch/scripts/build-image.sh    # needs trivy + cosign
kubectl apply -k stretch/manifests/overlays/local
```

The main Killercoda scenario exposes traffic with **NodePort** (step 8). Gateway API YAML under `assets/manifests/gateway*.yaml` is talk reference only — Killercoda clusters do not ship those CRDs. Stretch adds SBOM/signing and Kustomize overlays — not verified by Killercoda CHECK buttons.

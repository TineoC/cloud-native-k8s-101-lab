<br>

### You shipped the talk on a cluster

You practiced the core Cloud Native & Kubernetes 101 path:

1. Explored the API / control plane
2. Learned Dockerfile best practices and built a solid image
3. Fixed progressive Dockerfile challenges (layers, non-root, no secrets)
4. Ran Deployments (replicas + ReplicaSets)
5. Saw probe-driven self-healing
6. Used Services + label selectors
7. Injected ConfigMaps & Secrets (and decoded base64)
8. Added a second service (payments) via cluster DNS
9. Applied Gateway API with platform vs app ownership

**Same ideas at enterprise scale:** OpenAI’s multi-thousand-node clusters, Anthropic on GKE, AT&T on AKS, Kapiche surviving traffic spikes — all talk to the Kubernetes API and let controllers reconcile.

### Keep going

- Lab: [killercoda.com/tineoc/scenario/cloud-native-k8s-101](https://killercoda.com/tineoc/scenario/cloud-native-k8s-101) · [GitHub](https://github.com/TineoC/cloud-native-k8s-101-lab)
- Certs: KCNA → CKAD / CKA → CKS → Kubestronaut — [cncf.io/training](https://www.cncf.io/training/certification/)
- Practice: [Killercoda](https://killercoda.com/) · [killer.sh](https://killer.sh/) · KodeKloud · Linux Foundation training
- Community: CNCF Slack, Kubernetes Slack, KCD / KubeCon

Finished early locally? See `stretch/README.md` in the repo for Trivy/Cosign and Kustomize overlays.

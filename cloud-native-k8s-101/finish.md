<br>

### You shipped the talk on a cluster

You practiced the core Cloud Native & Kubernetes 101 path — **every step had a Challenge**:

1. Explored the API / control plane (+ namespace labels)
2. Dockerfile best practices + image tag challenge
3. Fixed Dockerfile challenges (layers, non-root, no secrets)
4. Deployments + scale to 3
5. Probes + annotate / rolling restart
6. Services + fixed a broken selector
7. ConfigMaps & Secrets + lab branding
8. Payments HA (2 replicas)
9. NodePort exposure + ownership labels

**Same ideas at enterprise scale:** OpenAI’s multi-thousand-node clusters, Anthropic on GKE, AT&T on AKS, Kapiche surviving traffic spikes — all talk to the Kubernetes API and let controllers reconcile.

### Keep going

- Lab: [killercoda.com/tineoc/scenario/cloud-native-k8s-101](https://killercoda.com/tineoc/scenario/cloud-native-k8s-101) · [GitHub](https://github.com/TineoC/cloud-native-k8s-101-lab)
- Certs: KCNA → CKAD / CKA → CKS → Kubestronaut — [cncf.io/training](https://www.cncf.io/training/certification/)
- Practice: [Killercoda](https://killercoda.com/) · [killer.sh](https://killer.sh/) · KodeKloud · Linux Foundation training
- Community: CNCF Slack, Kubernetes Slack, KCD / KubeCon

Finished early locally? See `stretch/README.md` in the repo for Trivy/Cosign and Kustomize overlays.

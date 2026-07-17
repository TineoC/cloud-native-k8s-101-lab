# Killercoda labs

Published companion scenario for **Cloud Native & Kubernetes 101**:

- **Live:** https://killercoda.com/tineoc/scenario/cloud-native-k8s-101
- **Source of truth for Killercoda:** https://github.com/TineoC/cloud-native-k8s-101-lab  
  (scenario lives in `cloud-native-k8s-101/` inside that repo)
- **Working copy in this monorepo:** [cloud-native-k8s-101/](cloud-native-k8s-101/)

To sync changes to the live Killercoda repo:

```bash
rsync -a --delete \
  --exclude '.git' --exclude '__pycache__' --exclude '*.pyc' \
  killercoda/cloud-native-k8s-101/ \
  /path/to/cloud-native-k8s-101-lab/cloud-native-k8s-101/
```

Then push in the dedicated repo. See that repo’s `PUBLISH.md` for Creator wiring.

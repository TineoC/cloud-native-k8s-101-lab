# Publish this scenario to Killercoda

GitHub repo (already live): https://github.com/TineoC/cloud-native-k8s-101-lab

Killercoda has **no publish CLI**. You connect this repo once in the Creator UI, then every `git push` updates the lab.

## One-time Creator setup

1. Sign in: https://killercoda.com/login  
2. Open Creator Repository: https://killercoda.com/creators/repository  
3. Add repository:
   - Name: `TineoC/cloud-native-k8s-101-lab`
   - Branch: `main`
4. Copy the **Deploy Key** Killercoda shows → run locally:

```bash
# Paste the public key Killercoda gave you (one line, starts with ssh-rsa or ssh-ed25519)
export KILLERCODA_DEPLOY_KEY='ssh-ed25519 AAAA... killercoda'
./scripts/apply-killercoda-github-access.sh
```

5. Copy Killercoda **Webhook** Payload URL + Secret →:

```bash
export KILLERCODA_WEBHOOK_URL='https://killercoda.com/...'   # from Creator UI
export KILLERCODA_WEBHOOK_SECRET='...'                       # from Creator UI
./scripts/apply-killercoda-github-access.sh
```

Or add them manually in GitHub:

- https://github.com/TineoC/cloud-native-k8s-101-lab/settings/keys  
- https://github.com/TineoC/cloud-native-k8s-101-lab/settings/hooks  
  - Content type: **application/json**

6. Push an empty commit (or any change) to trigger sync:

```bash
git commit --allow-empty -m "Trigger Killercoda sync"
git push
```

7. Confirm under Creator Scenarios: https://killercoda.com/creators/scenarios  

Expected public URL (creator path may vary by your Killercoda username):

- https://killercoda.com/tineoc/scenario/cloud-native-k8s-101-lab  

If the scenario folder slug differs, use the link shown in Creator Scenarios.

## Validate locally before push

```bash
pip install killercoda-cli
killercoda-cli validate
```

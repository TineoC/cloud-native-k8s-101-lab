#!/usr/bin/env bash
# Apply Killercoda deploy key and/or webhook to this GitHub repo.
# Values come from https://killercoda.com/creators/repository after you add the repo.
set -euo pipefail

REPO="${KILLERCODA_GITHUB_REPO:-TineoC/cloud-native-k8s-101-lab}"

if [[ -n "${KILLERCODA_DEPLOY_KEY:-}" ]]; then
  echo "Adding deploy key to ${REPO}..."
  # Remove prior Killercoda key title if re-running
  existing="$(gh api "repos/${REPO}/keys" --jq '.[] | select(.title=="Killercoda") | .id' || true)"
  if [[ -n "${existing}" ]]; then
    gh api -X DELETE "repos/${REPO}/keys/${existing}"
  fi
  gh api "repos/${REPO}/keys" \
    -f title='Killercoda' \
    -f key="${KILLERCODA_DEPLOY_KEY}" \
    -F read_only=true
  echo "Deploy key added."
else
  echo "KILLERCODA_DEPLOY_KEY not set — skip deploy key."
fi

if [[ -n "${KILLERCODA_WEBHOOK_URL:-}" && -n "${KILLERCODA_WEBHOOK_SECRET:-}" ]]; then
  echo "Adding webhook to ${REPO}..."
  existing_hook="$(gh api "repos/${REPO}/hooks" --jq '.[] | select(.config.url==env.KILLERCODA_WEBHOOK_URL) | .id' || true)"
  if [[ -n "${existing_hook}" ]]; then
    gh api -X DELETE "repos/${REPO}/hooks/${existing_hook}"
  fi
  gh api "repos/${REPO}/hooks" \
    -f name='web' \
    -f 'config[url]'="${KILLERCODA_WEBHOOK_URL}" \
    -f 'config[content_type]'='json' \
    -f 'config[secret]'="${KILLERCODA_WEBHOOK_SECRET}" \
    -F 'config[insecure_ssl]'=0 \
    -f 'events[]=push' \
    -F active=true
  echo "Webhook added."
else
  echo "KILLERCODA_WEBHOOK_URL / KILLERCODA_WEBHOOK_SECRET not set — skip webhook."
fi

echo "Done. Push to main to sync: git push origin main"

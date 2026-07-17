#!/usr/bin/env bash
# Runs when the scenario opens (Killercoda intro background).
set -euo pipefail

echo "Waiting for Kubernetes API..."
for i in $(seq 1 60); do
  if kubectl get nodes >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

kubectl apply -f /root/shop/manifests/namespace.yaml >/dev/null 2>&1 || true

chmod +x /root/shop/scripts/*.sh 2>/dev/null || true

# --- tooling: Docker Compose plugin + k9s ---
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64|amd64) COMPOSE_ARCH=x86_64; K9S_ARCH=amd64 ;;
  aarch64|arm64) COMPOSE_ARCH=aarch64; K9S_ARCH=arm64 ;;
  *) COMPOSE_ARCH=x86_64; K9S_ARCH=amd64 ;;
esac

COMPOSE_VERSION="${COMPOSE_VERSION:-v2.36.2}"
K9S_VERSION="${K9S_VERSION:-v0.50.9}"

if ! docker compose version >/dev/null 2>&1; then
  echo "Installing Docker Compose ${COMPOSE_VERSION}..."
  mkdir -p /usr/local/lib/docker/cli-plugins
  curl -fsSL \
    "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${COMPOSE_ARCH}" \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
  chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
  # Also expose as docker-compose for older muscle memory
  ln -sfn /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
fi

if ! command -v k9s >/dev/null 2>&1; then
  echo "Installing k9s ${K9S_VERSION}..."
  TMP="$(mktemp -d)"
  curl -fsSL \
    "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz" \
    -o "${TMP}/k9s.tgz"
  tar -xzf "${TMP}/k9s.tgz" -C /usr/local/bin k9s
  chmod +x /usr/local/bin/k9s
  rm -rf "${TMP}"
fi

docker compose version || true
k9s version || true

# Marker so foreground / steps know prepare finished.
touch /tmp/.shop-lab-ready
echo "Shop lab environment ready (docker compose + k9s installed)."

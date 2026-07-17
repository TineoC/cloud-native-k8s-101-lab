#!/usr/bin/env bash
# Shows in the terminal while background prepare runs.
echo "Preparing Acme Shop lab (namespace + scripts)..."
while [ ! -f /tmp/.shop-lab-ready ]; do sleep 1; done
echo "Ready. Follow the steps on the left — start in /root/shop"
cd /root/shop || true

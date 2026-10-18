#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nginx curl
systemctl enable --now nginx

systemctl is-active nginx
curl --fail --silent --show-error http://127.0.0.1/ \
  --output /dev/null \
  --write-out 'Local web response: HTTP %{http_code}\n'

#!/usr/bin/env bash
set -u

date -u
echo "=== Service status ==="
systemctl status nginx --no-pager --full || true

echo "=== Configuration check ==="
nginx -t 2>&1 || true

echo "=== Local HTTP check ==="
curl --silent --show-error --max-time 5 \
  --output /dev/null \
  --write-out 'HTTP %{http_code}\n' \
  http://127.0.0.1/ || true

echo "=== Disk space ==="
df -h /

echo "=== Recent service logs ==="
journalctl -u nginx -n 15 --no-pager

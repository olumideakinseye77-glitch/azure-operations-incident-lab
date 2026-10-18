#!/usr/bin/env bash
set -eu

fault=/etc/nginx/conf.d/olu-lab-fault.conf

if [ -e "$fault" ]; then
  echo "Test file already exists; stopping."
  exit 1
fi

nginx -t
trap 'rm -f "$fault"' EXIT

echo 'olu_invalid_directive on;' > "$fault"

echo "=== Detect configuration fault ==="
if nginx -t 2>&1; then
  echo "Unexpected result: invalid configuration passed."
  exit 1
else
  echo "Configuration fault detected as expected."
fi

rm -f "$fault"

echo "=== Verify restored configuration ==="
nginx -t

echo "=== Verify website remained available locally ==="
curl --fail --silent --show-error --max-time 5 \
  --output /dev/null \
  --write-out 'HTTP %{http_code}\n' \
  http://127.0.0.1/

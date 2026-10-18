#!/usr/bin/env bash
set -eu

lab=$(mktemp -d /tmp/olu-disk-lab.XXXXXX)

cleanup() {
  if mountpoint -q "$lab"; then
    umount "$lab" || return 1
  fi
  rmdir "$lab"
}
trap cleanup EXIT

mount -t tmpfs -o size=32m,mode=0700 tmpfs "$lab"

echo "=== Baseline ==="
df -h "$lab"

dd if=/dev/zero of="$lab/test-data" bs=1M count=29 status=none

echo "=== Simulated pressure ==="
df -h "$lab"
du -h "$lab/test-data"

usage=$(df -P "$lab" | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
if [ "$usage" -ge 90 ]; then
  echo "ALERT: isolated filesystem usage is ${usage}%"
else
  echo "Expected pressure threshold not reached."
  exit 1
fi

rm "$lab/test-data"

echo "=== Recovery ==="
df -h "$lab"

echo "=== Root disk unchanged by test data ==="
df -h /

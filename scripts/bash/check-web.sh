#!/usr/bin/env bash
set -eu

checker="$(dirname -- "$0")/check_web.py"
if result=$(python3 "$checker" 2>&1); then
    state=healthy
    priority=info
else
    state=unhealthy
    priority=err
fi

logger -p "local0.$priority" -t olu-web-health -- "state=$state ${result//$'\n'/ }"

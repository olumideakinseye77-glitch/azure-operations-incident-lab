# Scheduled health checks and incident alerts

Status: timer, syslog wrapper and alert query added. Azure alert creation, email delivery and the recovery drill are pending a live lab run.

## Install on the lab VM

Rebuild the lab and install Nginx using the [README](../README.md). Transfer these repository files to the VM using your existing Azure Run Command access. From the repository root on the VM, run:

```bash
sudo install -D -m 0644 scripts/python/check_web.py /usr/local/lib/olu-operations/check_web.py
sudo install -D -m 0755 scripts/bash/check-web.sh /usr/local/lib/olu-operations/check-web.sh
sudo install -m 0644 scripts/systemd/olu-web-health.{service,timer} /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now olu-web-health.timer
sudo systemctl start olu-web-health.service
systemctl list-timers olu-web-health.timer
```

The timer runs every minute. The wrapper logs healthy and unhealthy results to `local0`, which the existing Azure Monitor Agent configuration collects. Confirm ingestion in Log Analytics with `Syslog | where ProcessName == "olu-web-health" | take 20` before creating the alert.

## Configure and exercise the alert

1. In Azure Monitor, create a log search alert scoped to the lab Log Analytics workspace. Use the [failure query](../queries/web-health-failures.kql), the number of returned rows, and a threshold greater than zero. Use a five-minute lookback and evaluation frequency with automatic resolution enabled.
2. Create or select an action group with your email address. Confirm receipt of its test notification, then associate the action group with the alert.
3. Record the UTC baseline time and stop Nginx on the lab VM. Leave it stopped until the failure row and fired alert appear. Record the UTC failure, alert and email receipt times.
4. Start Nginx again. Verify its active status, local HTTP 200 and a new healthy Syslog row. Confirm the alert resolves after the lookback clears. Restore Nginx immediately if the drill is interrupted.
5. Capture the relevant query results, alert history and redacted email evidence. Remove the alert and any lab-only action group when cleaning up the lab.

A stopped VM or a broken ingestion path can prevent any health records from arriving. This alert detects reported failures. A missing-heartbeat alert would cover a separate scenario.

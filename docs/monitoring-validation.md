# Monitoring validation

Verified on 19 October 2026.

## Configuration
Azure Monitor Agent uses the VM's system-assigned managed identity.
A data collection rule collects local0 syslog messages at Info severity
and above into the operations Log Analytics workspace.

## Evidence
- Azure Monitor Agent and rsyslog services reported active.
- A Heartbeat query returned vm-olu-operations.
- The rsyslog configuration passed validation.
- A Syslog query returned two labelled test messages:
  - 18 October 2026, 21:51:22 UTC.
  - 18 October 2026, 21:52:22 UTC.
- Both records had facility local0 and severity info.

## Troubleshooting
Initial queries returned no matching records.
A later query confirmed ingestion without a forwarding configuration change.
The precise ingestion delay and cause of the initial absence were not established.

## Limits
This verifies labelled test-message collection.
It does not establish automatic collection of Nginx logs or incident detection.
No Azure alert notification has been configured for this project.

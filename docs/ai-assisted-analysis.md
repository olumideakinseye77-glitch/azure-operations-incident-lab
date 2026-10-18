# AI-assisted incident analysis

AI assistance was provided through ChatGPT during the lab.
No AI API integration or autonomous remediation was deployed.

## Evidence reviewed and interpretation

| Exercise | Evidence | Interpretation |
|---|---|---|
| Stopped service | Nginx inactive, connection refused, valid configuration, disk usage 8% | The deliberately stopped service caused the local outage. |
| Invalid configuration | nginx -t rejected an unknown directive | Remove the dedicated test file and validate again before any reload. |
| Filesystem pressure | Isolated tmpfs reached 91%; root disk stayed at 8% | Pressure affected the test filesystem, not the root disk. |

## Human review and verification

I ran the commands and reviewed their outputs with AI assistance.
Recovery was checked against actual results:
- Service restart: active and HTTP 200.
- Configuration cleanup: syntax test passed and HTTP 200.
- Test-data removal: isolated filesystem returned to 0%.

## Limits

These were deliberately introduced faults with known causes.
The exercises do not establish AI accuracy on unknown incidents.
AI suggestions require review; command success alone is not proof of recovery.
No credentials or private SSH keys were included in the documented evidence.

## Reusable investigation prompt

Review this sanitised incident evidence.
Separate observed facts from possible explanations.
Suggest read-only checks first, then a reversible recovery step.
State what evidence would confirm recovery.
Do not assume missing facts or execute changes.

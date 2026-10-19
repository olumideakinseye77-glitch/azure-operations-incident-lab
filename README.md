# AI-Assisted Azure Operations & Incident Lab

## Purpose

I built this Azure Cloud Engineering learning lab to challenge myself with Linux troubleshooting, Python automation and evidence-based incident investigation. Building on my deployment projects, I wanted to practise explaining why a service failed and verifying its recovery.

## Status

Core exercises and monitoring validated on 18–19 October 2026. Infrastructure remains deployed pending cost-control cleanup. A Terraform plan on 19 October reported no changes. GitHub Actions validation passed.

## Architecture

An Ubuntu 24.04 VM runs Nginx in UK South. Terraform manages its network, security group, VM, managed identity and monitoring resources using separate remote state in shared Azure Storage. No public inbound access rule is configured; exercises use Azure Run Command and local HTTP checks.

Azure Monitor Agent authenticates with the VM's system-assigned identity. A data collection rule routes local0 syslog messages at Info severity and above to Log Analytics. Agent heartbeat and two labelled syslog messages were verified with KQL.

## Completed exercises and evidence

| Exercise | Observed result | Evidence |
|---|---|---|
| Stopped web service | Inactive Nginx and connection refused; restart restored active status and HTTP 200 | [Incident 001](incidents/001-stopped-web-service.md) |
| Invalid configuration | Unknown directive rejected before reload; cleanup restored valid configuration; final HTTP 200 | [Exercise 002](incidents/002-invalid-configuration.md) |
| Filesystem pressure | Isolated 32 MB tmpfs reached 91%, then returned to 0%; root usage stayed at 8% | [Exercise 003](incidents/003-disk-pressure.md) |
| Python health checker | Healthy service returned true; stopped service returned false and exit code 1 | [Python validation](docs/python-check-validation.md) |
| Central monitoring | Heartbeat and two local0/info test records queried successfully | [Monitoring validation](docs/monitoring-validation.md) |

## Code and queries

- [Nginx installation](scripts/bash/install-web.sh)
- [Bash diagnostics](scripts/bash/diagnose-web.sh)
- [Python JSON health checker](scripts/python/check_web.py)
- [KQL test-message query](queries/syslog-test.kql)
- [Terraform configuration](terraform)
- [GitHub Actions validation](.github/workflows/ci.yml)

The workflow checks Python syntax, Bash syntax, Terraform formatting and backend-free Terraform validation. It does not deploy Azure resources or run live incident tests. The Python checker was tested separately inside the VM against healthy and stopped-service conditions.

## AI assistance and human review

ChatGPT helped interpret the displayed evidence and suggest commands. I ran the commands and checked results against the expected behaviour. This is interactive AI assistance, not an API integration or autonomous remediation system. See [analysis and limitations](docs/ai-assisted-analysis.md).

## Rebuild outline

1. Clone this repository and authenticate Azure CLI to the intended subscription and tenant.
2. Provide a public SSH key at `~/.ssh/olu-operations-lab.pub`; keep its private key secure and outside Git. For an existing deployment, recover its deployed public key from Azure rather than generating a replacement blindly.
3. Confirm the backend storage account and container exist and that the account has state access. The backend uses a separate `operations-incident-lab.tfstate` key in shared storage.
4. Set `TF_VAR_subscription_id`, run Terraform initialization, review a saved plan, then apply it. VM SKU availability and quota must be rechecked for a new deployment.
5. Run the installation script inside the VM using Azure Run Command. Terraform does not install Nginx or copy the diagnostic scripts automatically.
6. Run the exercises inside the VM, review results and publish sanitised evidence. Send labelled local0 messages and verify ingestion using KQL.

This outline documents the dependencies; a complete destroy-and-rebuild test has not yet been performed.

## Troubleshooting lessons

- SKU restrictions and family vCPU quota are separate deployment checks. Zone-specific restrictions must be distinguished from regional restrictions.
- Cloud Shell files and authentication can disappear between sessions. Pushed Git commits and remote state enabled recovery.
- Configuration validation and running service health are separate checks.
- A healthy agent heartbeat did not initially prove syslog ingestion. A later query found the test messages without forwarding changes; the precise ingestion delay was not established.
- A storage-token timeout blocked Terraform initialization until tenant-specific device authentication was renewed.

## Scope and limitations

- Deliberate faults had known causes; these tests do not demonstrate diagnosis of unknown production incidents.
- HTTP checks were local to the VM. Public availability and continuous uptime were not tested.
- Disk pressure used RAM-backed tmpfs, not a full persistent disk or application write failure.
- The DCR collects selected local0 messages; automatic Nginx access/error log collection and health-check scheduling are not configured.
- No Azure incident alert or notification delivery is configured.
- AI suggestions require human verification; AI accuracy was not benchmarked.

## Cost control

The VM, managed disk, public IP and Log Analytics can incur charges while deployed. Deallocating the VM alone leaves other billable resources. The workspace daily ingestion cap is not a guaranteed spending limit.

For full lab cleanup, review a Terraform destroy plan and apply it, then verify the project resource group is absent. Preserve the separate shared state storage used by other projects. Previously incurred charges remain payable.

## What I want to learn next

I want to strengthen this lab with scheduled health checks, incident alerts and more robust automated tests. My next planned challenge is an Enterprise Landing Zone and Self-Service Cloud Platform, where I intend to practise reusable Terraform modules, governance and controlled deployments.

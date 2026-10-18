# Incident 001: Stopped Nginx service

Date: 18 October 2026.
Scope: Local HTTP checks inside the Azure Ubuntu VM.

## Baseline
Nginx active, configuration valid, HTTP 200, root disk usage 8%.

## Fault
Deliberately stopped Nginx.
At 21:08:41 UTC, diagnostics showed inactive (dead), connection refused
and HTTP 000 (no HTTP response). Configuration remained valid.
The journal recorded the service stop at 21:08:09 UTC.

## Recovery
Ran systemctl start nginx.
Verified active status and HTTP 200.
Exact recovery time was not captured.

## Lesson
A running VM does not guarantee a working web service.
Check service status, configuration, logs and HTTP response together.

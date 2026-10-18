# Python health-check validation

Test date: 18 October 2026.
Checks ran inside the Azure Ubuntu VM.

## Healthy test
At 21:15:53 UTC:
- Service: active
- HTTP status: 200
- Error: null
- Healthy: true

## Controlled outage test
At 21:17:13 UTC, after deliberately stopping Nginx:
- Service: inactive
- HTTP status: null
- Connection refused
- Healthy: false
- Python exit code: 1

The test restarted Nginx and verified active service status.
A post-restart HTTP check was not included in this test.

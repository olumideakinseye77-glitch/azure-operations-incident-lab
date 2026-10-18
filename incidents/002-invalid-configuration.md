# Exercise 002: Invalid Nginx configuration

Date: 18 October 2026.

## Fault
Created a dedicated configuration file containing an invalid directive.
At 21:19:16 UTC, nginx -t rejected olu_invalid_directive.

## Response
Removed the test file and reran configuration validation successfully.
The final local HTTP check returned 200.

## Scope
The invalid configuration was never reloaded.
This demonstrates detecting a configuration fault before deployment.
No continuous availability measurement was performed.

## Lesson
Validate configuration before reloading or restarting a service.
Keep changes reversible and verify service health afterwards.

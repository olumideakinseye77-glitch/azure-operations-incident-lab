# Exercise 003: Isolated filesystem pressure

Date: 18 October 2026.

## Method
Mounted a temporary 32 MB tmpfs filesystem.
Created a 29 MB test file, without filling the root disk.

## Evidence
- Baseline test filesystem usage: 0%.
- Usage after writing the file: 91%.
- Script printed an alert at the 90% threshold.
- Removing the test file returned usage to 0%.
- Root filesystem usage remained 8%.

## Scope
This was a RAM-backed filesystem capacity simulation.
The alert was console output, not an Azure Monitor notification.
It did not test persistent disk failure or application write errors.

## Lesson
Use df to identify filesystem pressure and du to locate large files.
Confirm the affected filesystem before removing data.

# Batch User & Group Management Automation

## Overview
A Bash automation script for bulk Linux user and group lifecycle management. Reads structured CSV input and performs create/delete operations with idempotency checks, auto group provisioning, and timestamped audit logging — simulating real-world enterprise IAM workflows.

---

## Security Relevance (SOC/Blue Team)

This project maps directly to identity-based attack techniques monitored by SOC analysts:

| MITRE ATT&CK Technique | ID | Relevance |
|---|---|---|
| Create Account: Local Account | T1136.001 | Detects unauthorized local user creation |
| Account Manipulation | T1098 | Monitors group membership changes |
| Valid Accounts | T1078 | Identifies stale/unused accounts |

> A SOC analyst monitoring these techniques would look for bulk account creation events in SIEM — this script generates structured logs that can be directly ingested into tools like Splunk or ELK Stack.

---

## Features
- Bulk user creation/deletion via CSV input
- Auto group provisioning if group doesn't exist
- Idempotency checks — skips if user already exists
- Timestamped audit log for compliance tracking
- Root privilege enforcement
- Input validation & error handling

---

# User Onboarding & Access Provisioning

## Problem Statement
Manual user onboarding is error-prone and time-consuming. A single mistake — wrong permissions, missing group assignment, or no forced password reset — can create serious security gaps. This script automates the entire process consistently and logs every action for audit purposes.

---

## What It Does
- Creates a new Linux user with home directory and bash shell
- Forces password reset on first login (no default passwords)
- Adds user to the `soc-team` group for role-based access control
- Sets `700` permissions on home directory (owner-only access)
- Logs every action with timestamp to `logs/onboard.log`
- Supports `--dry-run` mode for safe testing before real execution

---

## Usage

```bash
# Normal run
sudo ./onboard.sh <username>

# Dry-run (nothing is created — just shows what would happen)
./onboard.sh --dry-run <username>

# View audit report
./audit_report.sh
```

---

## Sample Output

**Dry-run:**
```
[2026-04-17 09:01:16] [DRY-RUN] Would create user: testuser
[2026-04-17 09:01:16] [DRY-RUN] Would force password reset for: testuser
[2026-04-17 09:01:16] [DRY-RUN] Would add testuser to group: soc-team
[2026-04-17 09:01:16] [DRY-RUN] Would set permission 700 on /home/testuser
```

**Real run:**
```
[2026-04-17 09:04:04] Created user: sibbu
[2026-04-17 09:04:04] Password reset forced for sibbu
[2026-04-17 09:04:04] Added sibbu to group: soc-team
[2026-04-17 09:04:04] Set permissions 700 on /home/sibbu
```

**Audit Report:**
```
===== AUDIT REPORT =====
Generated: Fri Apr 17 09:15:37 UTC 2026
========================
Total actions: 18
Real actions:  10
DRY-RUN actions: 8
Users created:
sibbu
Rahul
```

---

## MITRE ATT&CK Mapping

| Technique | ID | Relevance |
|---|---|---|
| Create Account | T1136 | Attackers create unauthorized accounts to maintain persistence. This script enforces controlled, logged account creation — preventing unauthorized provisioning. |
| Valid Accounts | T1078 | Attackers abuse valid credentials to move laterally. Proper group-based access control and forced password reset on first login reduces this attack surface. |

---

## Files

| File | Purpose |
|---|---|
| `onboard.sh` | Main script — creates user, assigns group, sets permissions, logs actions |
| `audit_report.sh` | Parses log file and prints summary of all onboarding actions |
| `logs/onboard.log` | Timestamped audit trail of every action performed |
| `backups/` | Reserved for home directory backups during offboarding |

---

## Skills Demonstrated
- Linux user & group management (`useradd`, `usermod`, `chage`, `chmod`)
- Bash scripting — functions, flags, input validation, error handling
- Audit logging with timestamps
- Least privilege principle via `chmod 700` and group-based access
- Dry-run mode for safe testing
- MITRE ATT&CK framework mapping (T1136, T1078)

# Project Phoenix — Log Investigator Lab

## Overview

**Lab Title:** Log Investigator — Troubleshooting Critical Failures  
**Role:** Log Investigator / Detective  
**Difficulty:** Intermediate  
**Skills Covered:** `grep`, `dmesg`, `diff`, pipelines (`|`), redirection (`>`, `>>`)

---

## Objective

Project Phoenix is experiencing critical failures in production. As the **Log Investigator**, your job is to systematically analyze log files, kernel messages, and configuration files to identify root causes and deliver actionable intelligence to Sarah Chen and the development team.

---

##  Prerequisites

- Completed Lab 1: Digital Architect (Project Phoenix Setup)
- Linux/Unix terminal (Ubuntu recommended)
- Basic familiarity with file system navigation
- `project_phoenix/` directory structure from Lab 1

---

##  Lab Tasks

### Task 1 — Filter Critical Errors with `grep`
Search log files for ERROR and CRITICAL level messages. Extract only what matters — ignore the noise.

```bash
grep "ERROR\|CRITICAL" logs/app.log
grep -i "failed\|timeout\|refused" logs/server.log
grep -n "ERROR" logs/app.log          # Show line numbers
grep -c "ERROR" logs/app.log          # Count occurrences
```

### Task 2 — Investigate System-Level Issues with `dmesg`
Check kernel ring buffer for hardware errors, OOM kills, and disk issues that may have caused the crash.

```bash
dmesg | grep -i "error\|fail\|oom\|killed"
dmesg | grep -i "disk\|memory\|usb" | tail -20
dmesg --level=err,crit                # Filter by severity
```

### Task 3 — Compare Configs with `diff`
Identify discrepancies between dev, staging, and production config files that caused environment-specific failures.

```bash
diff config/dev/app.conf config/prod/app.conf
diff -u config/staging/app.conf config/prod/app.conf   # Unified format
diff -y config/dev/app.conf config/staging/app.conf    # Side by side
```

### Task 4 — Pipeline Processing
Chain commands to extract, filter, sort, and count log data efficiently.

```bash
grep "ERROR" logs/app.log | sort | uniq -c | sort -rn
cat logs/*.log | grep "CRITICAL" | wc -l
grep "ERROR" logs/app.log | awk '{print $1, $2, $NF}'
```

### Task 5 — Document Findings with Redirection
Save your investigation report to a file for handoff to the development team.

```bash
echo "=== Investigation Report ===" > report.txt
grep "ERROR\|CRITICAL" logs/app.log >> report.txt
diff config/dev/app.conf config/prod/app.conf >> report.txt
dmesg | grep -i "error" >> report.txt
```

---

##  Key Commands Reference

| Command | Flag | Purpose |
|---------|------|---------|
| `grep` | `-i` | Case-insensitive search |
| `grep` | `-n` | Show line numbers |
| `grep` | `-c` | Count matching lines |
| `grep` | `-r` | Recursive search in directories |
| `grep` | `-v` | Invert match (exclude pattern) |
| `grep` | `-E` | Extended regex (`\|` for OR) |
| `dmesg` | `--level` | Filter by severity (err, crit, warn) |
| `dmesg` | `-T` | Human-readable timestamps |
| `diff` | `-u` | Unified diff format (like git diff) |
| `diff` | `-y` | Side-by-side comparison |
| `diff` | `-i` | Ignore case differences |
| `\|` | — | Pipe output of one command to another |
| `>` | — | Redirect output to file (overwrite) |
| `>>` | — | Redirect output to file (append) |

---

##  Investigation Checklist

- [ ] Extracted all ERROR and CRITICAL entries from app logs
- [ ] Checked system-level issues via `dmesg`
- [ ] Compared dev vs staging vs prod configs using `diff`
- [ ] Identified missing deployment files
- [ ] Used pipelines to count/sort errors by frequency
- [ ] Saved full investigation report to `investigation_report.txt`

---

##  Root Causes Found

| Issue | Location | Command Used |
|-------|----------|--------------|
| DB connection timeout | `logs/app.log` | `grep` |
| Config mismatch (DB_HOST) | `config/dev` vs `config/prod` | `diff` |
| OOM kill event | Kernel buffer | `dmesg` |
| Missing deployment file | `src/backend/` | `grep -r` |

---

##  Success Criteria

- [ ] All critical log entries identified and extracted
- [ ] At least 2 config discrepancies found using `diff`
- [ ] Kernel-level issues documented from `dmesg`
- [ ] Full investigation report generated as `investigation_report.txt`
- [ ] Root causes clearly stated with supporting evidence

---

##  Learning Outcomes

After completing this lab, you will be able to:
1. Use `grep` with flags to extract signal from noisy log files
2. Read kernel messages with `dmesg` for hardware/OS-level debugging
3. Compare config files across environments using `diff`
4. Build powerful one-liners using pipes and redirection
5. Generate structured investigation reports from CLI output

---

##  Real-World SOC Application

| Lab Skill | SOC/DFIR Equivalent |
|-----------|---------------------|
| `grep` on logs | SIEM alert triage, IOC hunting |
| `dmesg` analysis | Endpoint crash investigation |
| `diff` on configs | Baseline deviation detection |
| Pipelines | Log parsing in incident response |
| Redirection to file | Evidence documentation, chain of custody |

---


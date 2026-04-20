# Nginx Log Analysis — SOC Triage Lab

A hands-on Blue Team project analyzing a real-world nginx access log using Linux CLI tools to identify anomalous traffic patterns and document findings in a SOC analyst workflow.

---

## Overview

| | |
|---|---|
| **Type** | Blue Team / Log Analysis |
| **Tools** | `grep` `awk` `cut` `sort` `uniq` `bash` |
| **Environment** | Ubuntu (WSL2) |
| **Dataset** | Real nginx access log — 51,462 requests |
| **Duration** | Attack span: 17 May – 04 Jun 2015 |

---

## Objective

Simulate a SOC analyst's first-response log triage workflow — parse a raw nginx access log, identify suspicious patterns, and document findings with supporting evidence.

---

## Dataset

```
Total Requests : 51,462
Unique IPs     : 2,660
Date Range     : 17 May 2015 – 04 Jun 2015
Log Format     : Combined Log Format
```

---

## Methodology

### 1. Core Parsing
Extracted key fields using CLI tools — IPs, status codes, endpoints, user agents, and response sizes.

```bash
# Status code distribution
awk '{print $9}' access.log | sort | uniq -c | sort -rn

# Top requested endpoints
awk '{print $7}' access.log | sort | uniq -c | sort -rn | head -10

# Top IPs by volume
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

### 2. Anomaly Detection
Identified brute force candidates, 404 floods, scanner user agents, and suspicious path attempts.

```bash
# IPs with 50+ 4xx errors
awk '$9 ~ /^4/ {print $1}' access.log | sort | uniq -c | sort -rn | awk '$1 >= 50'

# Coordinated 404 pattern
awk '$9 == "404" {print $1, $7}' access.log | sort | uniq -c | sort -rn | head -20

# Attack duration
grep "/downloads/product_" access.log | cut -d'[' -f2 | cut -d':' -f1 | sort | uniq -c
```

---

## Findings

### Finding 1 — Coordinated Resource Hammering `CRITICAL`

| Metric | Value |
|--------|-------|
| Unique attacker IPs | 1,258 |
| Total malicious requests | 33,876 |
| Attack duration | 19 days |
| Daily average | ~2,860 requests/day |
| Targeted endpoints | `/downloads/product_1`, `/downloads/product_2` |

1,258 distributed IPs continuously requested two non-existent endpoints over 19 days at a consistent, machine-like rate. Traffic dropped sharply on 04 Jun 2015 — indicating botnet deactivation or target shift.

### Finding 2 — APT Package Mirror Identified

```
11,830  Debian APT-HTTP/1.3 (1.0.1ubuntu2)
11,365  Debian APT-HTTP/1.3 (0.9.7.9)
 6,719  Debian APT-HTTP/1.3 (0.8.16~exp12ubuntu10.21)
```

All high-volume traffic originated from `apt-get` package managers on Ubuntu/Debian systems. The server was a software package mirror — the targeted endpoints were deleted or moved packages, causing 1,258 client machines to repeatedly fail on download attempts.

### Finding 3 — Status Code Distribution

| Status Code | Count | Interpretation |
|-------------|-------|----------------|
| 404 | 33,876 | Missing resources — primary attack surface |
| 304 | 13,330 | Cached responses — legitimate clients |
| 200 | 4,028 | Successful requests |
| 206 | 186 | Partial content — large file downloads |
| 403 | 38 | Forbidden — access control functioning |

---

## MITRE ATT&CK Mapping

| Technique | ID | Observation |
|-----------|-----|-------------|
| Network Denial of Service | T1498 | 33,876 requests from 1,258 IPs over 19 days |
| Automated Exfiltration | T1020 | Machine-rate requests with no human pattern |
| Resource Hijacking | T1496 | Sustained server resource consumption |

---

## Automation Script

`analyze_nginx.sh` runs the full analysis pipeline on any nginx log file.

```bash
chmod +x analyze_nginx.sh
./analyze_nginx.sh access.log          # analyze default log
./analyze_nginx.sh access.log | tee report.txt  # save output
```

**What it covers:**
- Request overview — total, unique IPs, date range
- Status code breakdown
- Top 10 IPs and endpoints
- Brute force candidates (50+ 4xx threshold)
- Scanner UA detection
- Suspicious path detection — LFI, SQLi, XSS
- Coordinated 404 attack summary

---

## Key Takeaways

- High 404 volume is not always a scan — user agent and path context changes the interpretation entirely
- Botnet traffic is identifiable by machine-like request regularity across distributed IPs
- APT user agents reveal server purpose and help narrow down the client base
- Sustained low-rate attacks (~2,860/day) can evade simple volume-based threshold alerts

---

## Tools Reference

| Tool | Used For |
|------|----------|
| `awk` | Field extraction, conditional filtering, arithmetic |
| `grep` | Pattern matching, attack signature detection |
| `cut` | Delimiter-based field splitting |
| `sort` | Sorting and deduplication |
| `uniq -c` | Frequency counting |
| `bash` | Automation scripting |

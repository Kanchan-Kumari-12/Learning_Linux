# Network Packet Statistics Analyzer

## Overview
A Linux CLI tool to analyze network packet captures and detect suspicious activity — a Wireshark complement using pure Bash.

## Tools Used
- `awk` — field extraction
- `grep` — pattern matching
- `tr` — character filtering
- `tcpdump` — packet capture (live)

## Features
- Total packet count
- Top 5 Source IPs
- Protocol breakdown (TCP/UDP/ICMP)
- Top destination ports
- Suspicious activity detection (port scan, DNS tunneling)
- JSON report generation

## MITRE ATT&CK Mapping
| Technique | ID | Detection |
|---|---|---|
| Network Scanning | T1046 | Multiple packets from single IP |
| DNS Tunneling | T1071.004 | Excessive DNS queries |

## Sample Output
```
{
        "total_packets": 15,
        "top_source_ip": "192.168.1.105",
        "most_used_port": "443",
        "dns_queries": 4,
        "report_time": "Wed Apr 22 17:42:22 UTC 2026"
}
```

#!/bin/bash

LOG=${1:-access.log}

if [ ! -f "$LOG" ]; then
    echo "Usage: ./analyze_nginx.sh <logfile>"
    exit 1
fi

echo "================================================"
echo "   NGINX LOG ANALYSIS REPORT"
echo "   File: $LOG"
echo "   Date: $(date)"
echo "================================================"

echo ""
echo "[ OVERVIEW ]"
echo "Total Requests  : $(wc -l < "$LOG")"
echo "Unique IPs      : $(awk '{print $1}' "$LOG" | sort -u | wc -l)"
echo "Date Range      : $(awk -F'[' '{print $2}' "$LOG" | cut -d':' -f1 | sort | head -1) to $(awk -F'[' '{print $2}' "$LOG" | cut -d':' -f1 | sort | tail -1)"

echo ""
echo "[ STATUS CODE BREAKDOWN ]"
awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn

echo ""
echo "[ TOP 10 IPs ]"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -n 10

echo ""
echo "[ TOP 10 ENDPOINTS ]"
awk '{print $7}' "$LOG" | sort | uniq -c | sort -rn | head -n 10

echo ""
echo "[ BRUTE FORCE CANDIDATES (50+ 4xx errors) ]"
awk '$9 ~ /^4/ {print $1}' "$LOG" | sort | uniq -c | sort -rn | awk '$1 >= 50'

echo ""
echo "[ COORDINATED 404 ATTACK DETECTION ]"
echo "Unique IPs hammering missing resources:"
awk '$9 == "404" {print $1}' "$LOG" | sort -u | wc -l
echo "Total 404 requests:"
awk '$9 == "404"' "$LOG" | wc -l

echo ""
echo "[ SCANNER / MALICIOUS UA ]"
SCANNERS=$(grep -icE "(sqlmap|nikto|dirbuster|gobuster|masscan|hydra)" "$LOG")
echo "Known scanner UAs detected: $SCANNERS"

echo ""
echo "[ SUSPICIOUS PATH ATTEMPTS ]"
LFI=$(grep -cE "\.\./|%2e%2e" "$LOG")
SQLI=$(grep -icE "(union.*select|or 1=1|drop table)" "$LOG")
XSS=$(grep -icE "(<script|alert\(|onerror=)" "$LOG")
echo "LFI attempts  : $LFI"
echo "SQLi attempts : $SQLI"
echo "XSS attempts  : $XSS"

echo ""
echo "[ TOP USER AGENTS ]"
awk -F'"' '{print $6}' "$LOG" | sort | uniq -c | sort -rn | head -5

echo ""
echo "================================================"
echo "   END OF REPORT"
echo "================================================"

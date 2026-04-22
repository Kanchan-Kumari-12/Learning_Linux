#!/bin/bash
LOG_FILE="./netdata.log"
Report="./report.json"

echo "========================================="
echo "   Network Packet Statistics Analyzer"
echo "========================================="
echo ""

TOTAL=$(wc -l < "$LOG_FILE")

echo "Total packet captured : $TOTAL"

echo "Top 5 Source IP"

awk '{print $3}' "$LOG_FILE" | cut -d'.' -f1-4 | sort | uniq -c | sort -rn | head -n 5

echo "Protocol Breakdown:"
TCP=$(grep -c 'Flags' "$LOG_FILE")
UDP=$(grep -c 'UDP' "$LOG_FILE")

echo "          TCP : $TCP"
echo "          UDP : $UDP"

echo "Top 5 Destination Ports"
awk '{print $5}' "$LOG_FILE" | grep -oE '\.[0-9]+:' | tr -d '.:' | sort | uniq -c | sort -rn | head -n 5

echo "Suspicious Activity Check:"

echo "Possible Port Scan (1 IP > 3 destinations):"
awk '{print $3}' "$LOG_FILE" | cut -d'.' -f1-4 | sort | uniq -c | awk '$1 > 3 {print "  [ALERT] "$2 " - " $1 " packets"}'

echo "DNS Queries (port 53):"
grep '\.53:' "$LOG_FILE" | awk '{print $3}' | cut -d'.' -f1-4 | sort | uniq -c | awk '{print "  [INFO] "$2 " - " $1 " queries"}'

echo "Saving Report..."
cat > "$Report" << EOF
{
        "total_packets": $TOTAL,
        "top_source_ip": "$(awk '{print $3}' "$LOG_FILE" | cut -d'.' -f1-4 | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')",
        "most_used_port": "$(awk '{print $5}' "$LOG_FILE" | grep -oE '\.[0-9]+:' | tr -d '.:' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')",
        "dns_queries": $(grep -c '\.53:' "$LOG_FILE"),
        "report_time": "$(date)"
}
EOF

echo "[✓] Report saved "
echo ""
echo "========================================="

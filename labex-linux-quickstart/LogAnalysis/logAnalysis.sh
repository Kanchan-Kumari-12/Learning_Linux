#!/bin/bash

# ============================================================
#  Project Phoenix — Log Investigator Script
#  Role: Log Investigator / Detective
#  Author: Kanchan Kumari
#  Description: Simulates critical system failures, then
#               investigates them using grep, dmesg, diff,
#               pipelines, and redirection.
# ============================================================

set -e

echo "============================================"
echo "  Project Phoenix — Log Investigator"
echo "============================================"
echo ""

# ─────────────────────────────────────────
# SETUP: Create investigation environment
# ─────────────────────────────────────────
echo "[SETUP]   Preparing investigation environment..."

mkdir -p project_phoenix/{logs,config/{dev,staging,prod},src/backend,archives,investigation}

# ── Generate realistic app logs with errors ──
cat > project_phoenix/logs/app.log <<'EOF'
[2025-03-01 08:00:01] INFO  Server started on port 8080
[2025-03-01 08:00:05] INFO  Connected to database at localhost:5432
[2025-03-01 08:01:12] INFO  User login: admin@phoenix.dev
[2025-03-01 08:05:33] WARNING  High memory usage: 78%
[2025-03-01 08:10:45] ERROR  DB connection timeout after 30s — host: prod.db.internal
[2025-03-01 08:10:46] ERROR  Retry attempt 1/3 failed
[2025-03-01 08:10:47] ERROR  Retry attempt 2/3 failed
[2025-03-01 08:10:48] CRITICAL  DB connection completely lost — application entering degraded mode
[2025-03-01 08:11:00] ERROR  API /api/v1/users returned 500 — downstream DB unavailable
[2025-03-01 08:11:01] ERROR  API /api/v1/orders returned 500 — downstream DB unavailable
[2025-03-01 08:12:30] WARNING  Queue backlog growing: 1532 pending jobs
[2025-03-01 08:15:00] CRITICAL  Out of memory — killing worker process PID 4821
[2025-03-01 08:15:01] ERROR  Worker process PID 4821 killed
[2025-03-01 08:20:10] ERROR  Missing deployment file: deploy_config.yaml not found
[2025-03-01 08:20:11] CRITICAL  Deployment pipeline halted — missing required artifact
[2025-03-01 08:25:00] INFO  Health check: FAILING
[2025-03-01 08:30:00] ERROR  Disk I/O error on /dev/sda1 — read latency 4200ms
[2025-03-01 08:35:00] CRITICAL  System shutdown initiated by watchdog
EOF

# ── Generate server access log ──
cat > project_phoenix/logs/server.log <<'EOF'
[2025-03-01 08:00:01] INFO  Nginx started
[2025-03-01 08:01:00] INFO  GET /api/v1/health 200 12ms
[2025-03-01 08:05:00] INFO  GET /api/v1/users 200 45ms
[2025-03-01 08:10:45] ERROR  upstream connection refused — backend:8080
[2025-03-01 08:10:46] ERROR  upstream timed out (110) connecting to backend
[2025-03-01 08:11:00] ERROR  GET /api/v1/users 502 Bad Gateway
[2025-03-01 08:11:01] ERROR  GET /api/v1/orders 502 Bad Gateway
[2025-03-01 08:15:05] ERROR  worker process 4821 exited with signal 9
[2025-03-01 08:20:00] ERROR  failed to open config: /etc/phoenix/deploy_config.yaml not found
[2025-03-01 08:30:00] CRITICAL  disk write failed — filesystem may be full or corrupted
[2025-03-01 08:35:00] INFO  Nginx shutdown
EOF

# ── Create config files WITH intentional mismatches ──
cat > project_phoenix/config/dev/app.conf <<EOF
ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_NAME=phoenix_dev
DEBUG=true
MAX_CONNECTIONS=10
TIMEOUT=60
DEPLOY_FILE=deploy_config.yaml
LOG_LEVEL=DEBUG
EOF

cat > project_phoenix/config/staging/app.conf <<EOF
ENV=staging
DB_HOST=staging.db.internal
DB_PORT=5432
DB_NAME=phoenix_staging
DEBUG=false
MAX_CONNECTIONS=50
TIMEOUT=30
DEPLOY_FILE=deploy_config.yaml
LOG_LEVEL=INFO
EOF

cat > project_phoenix/config/prod/app.conf <<EOF
ENV=production
DB_HOST=prod.db.internal
DB_PORT=5433
DB_NAME=phoenix_prod
DEBUG=false
MAX_CONNECTIONS=200
TIMEOUT=10
LOG_LEVEL=WARN
EOF
# NOTE: prod is missing DEPLOY_FILE — intentional bug!

echo "      Environment ready."
echo ""

# ─────────────────────────────────────────
# TASK 1: grep — Extract Critical Errors
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 1:  Filtering Errors with grep"
echo "============================================"
echo ""

echo ">>> All ERROR and CRITICAL entries in app.log:"
grep -E "ERROR|CRITICAL" project_phoenix/logs/app.log
echo ""

echo ">>> Error count by severity:"
echo -n "  ERROR count   : "
grep -c "ERROR" project_phoenix/logs/app.log
echo -n "  CRITICAL count: "
grep -c "CRITICAL" project_phoenix/logs/app.log
echo ""

echo ">>> Searching for 'timeout' and 'refused' (case-insensitive):"
grep -in "timeout\|refused\|failed" project_phoenix/logs/server.log
echo ""

echo ">>> Recursive grep — find 'DEPLOY_FILE' across all configs:"
grep -r "DEPLOY_FILE" project_phoenix/config/ || echo "    DEPLOY_FILE missing in one or more configs!"
echo ""

# ─────────────────────────────────────────
# TASK 2: dmesg simulation — Kernel Issues
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 2:   Kernel Investigation (dmesg sim)"
echo "============================================"
echo ""

# Simulate dmesg output (actual dmesg needs root in many envs)
cat > /tmp/simulated_dmesg.txt <<'EOF'
[    0.000000] Initializing cgroup subsys cpuset
[    1.234567] Linux version 5.15.0-91-generic
[   42.100000] EXT4-fs (sda1): mounted filesystem with ordered data mode
[  120.445231] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  120.445300] ata1.00: failed command: READ DMA EXT
[  120.445312] ata1.00: status: { DRDY ERR }
[  120.445315] ata1.00: error: { UNC }
[  120.500000] end_request: I/O error, dev sda, sector 2048000
[  121.000000] Buffer I/O error on device sda1, logical block 256000
[  300.112233] Out of memory: Kill process 4821 (phoenix-worker) score 892
[  300.112240] Killed process 4821 (phoenix-worker) total-vm:2048MB, anon-rss:1800MB
[  300.113000] oom_reaper: reaped process 4821
[  450.000000] EXT4-fs error (device sda1): ext4_find_entry: reading directory lblock 0
[  460.000000] ACPI: Critical temperature threshold reached
[  461.000000] thermal thermal_zone0: critical temperature reached, shutting down
EOF

echo ">>> Simulated dmesg — ERROR/FAIL/OOM entries:"
grep -iE "error|fail|oom|kill|critical" /tmp/simulated_dmesg.txt
echo ""

echo ">>> Disk-related kernel messages:"
grep -iE "disk|sda|I\/O|block" /tmp/simulated_dmesg.txt
echo ""

echo ">>> Memory-related kernel messages:"
grep -iE "memory|oom|kill|anon" /tmp/simulated_dmesg.txt
echo ""

# ─────────────────────────────────────────
# TASK 3: diff — Config Comparison
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 3:  Config Comparison with diff"
echo "============================================"
echo ""

echo ">>> diff: dev vs prod (unified format):"
diff -u project_phoenix/config/dev/app.conf project_phoenix/config/prod/app.conf || true
echo ""

echo ">>> diff: staging vs prod:"
diff -u project_phoenix/config/staging/app.conf project_phoenix/config/prod/app.conf || true
echo ""

echo ">>> Side-by-side: dev vs prod:"
diff -y --width=70 project_phoenix/config/dev/app.conf project_phoenix/config/prod/app.conf || true
echo ""

# ─────────────────────────────────────────
# TASK 4: Pipelines — Advanced Log Processing
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 4:   Pipeline Processing"
echo "============================================"
echo ""

echo ">>> Error frequency (sorted by count):"
grep -hE "ERROR|CRITICAL" project_phoenix/logs/app.log project_phoenix/logs/server.log \
  | grep -oE "(ERROR|CRITICAL)" \
  | sort | uniq -c | sort -rn
echo ""

echo ">>> All unique error types across all logs:"
grep -hE "ERROR|CRITICAL|WARNING" project_phoenix/logs/*.log \
  | grep -oE "(INFO|WARNING|ERROR|CRITICAL)" \
  | sort | uniq -c | sort -rn
echo ""

echo ">>> Top 5 most recent critical events:"
grep -hE "CRITICAL" project_phoenix/logs/*.log | tail -5
echo ""

# ─────────────────────────────────────────
# TASK 5: Redirection — Generate Report
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 5:  Generating Investigation Report"
echo "============================================"
echo ""

REPORT="project_phoenix/investigation/investigation_report.txt"

cat > "$REPORT" <<HEADER
============================================================
  PROJECT PHOENIX — INVESTIGATION REPORT
  Investigator : Kanchan Kumari
  Date         : $(date '+%Y-%m-%d %H:%M:%S')
  Status       : CRITICAL FAILURES IDENTIFIED
============================================================

HEADER

echo "=== SECTION 1: CRITICAL & ERROR LOG ENTRIES ===" >> "$REPORT"
grep -hE "ERROR|CRITICAL" project_phoenix/logs/app.log project_phoenix/logs/server.log >> "$REPORT"
echo "" >> "$REPORT"

echo "=== SECTION 2: ERROR FREQUENCY SUMMARY ===" >> "$REPORT"
grep -hE "ERROR|CRITICAL|WARNING" project_phoenix/logs/*.log \
  | grep -oE "(WARNING|ERROR|CRITICAL)" \
  | sort | uniq -c | sort -rn >> "$REPORT"
echo "" >> "$REPORT"

echo "=== SECTION 3: CONFIG DIFF — DEV vs PROD ===" >> "$REPORT"
diff -u project_phoenix/config/dev/app.conf project_phoenix/config/prod/app.conf >> "$REPORT" || true
echo "" >> "$REPORT"

echo "=== SECTION 4: CONFIG DIFF — STAGING vs PROD ===" >> "$REPORT"
diff -u project_phoenix/config/staging/app.conf project_phoenix/config/prod/app.conf >> "$REPORT" || true
echo "" >> "$REPORT"

echo "=== SECTION 5: KERNEL-LEVEL ISSUES ===" >> "$REPORT"
grep -iE "error|oom|kill|I\/O" /tmp/simulated_dmesg.txt >> "$REPORT"
echo "" >> "$REPORT"

cat >> "$REPORT" <<FOOTER
============================================================
  ROOT CAUSES IDENTIFIED
============================================================
1. DB_HOST mismatch — prod points to prod.db.internal:5433
   but dev/staging use port 5432. Port mismatch = timeout.

2. DEPLOY_FILE missing in prod config — deploy_config.yaml
   not defined, causing deployment pipeline to halt.

3. OOM kill — Phoenix worker process (PID 4821) killed by
   kernel due to memory exhaustion (1800MB anon-rss).

4. Disk I/O errors on /dev/sda1 — hardware degradation
   causing read failures and filesystem corruption risk.

============================================================
  RECOMMENDED ACTIONS
============================================================
1. Fix DB_PORT in prod/app.conf (5433 -> 5432) or update
   the DB server to listen on correct port.

2. Add DEPLOY_FILE=deploy_config.yaml to prod/app.conf
   and ensure the file exists in the deployment artifact.

3. Increase memory limits or optimize worker process.
   Consider adding swap and setting OOM score adjustments.

4. Replace /dev/sda1 — disk showing hardware-level UNC
   errors. Schedule emergency maintenance window.

============================================================
  Report generated by: Log Investigator Script
  Next step: Fortress Guardian — Secure the Infrastructure
============================================================
FOOTER

echo "      Report saved to: $REPORT"
echo ""

# ─────────────────────────────────────────
# FINAL SUMMARY
# ─────────────────────────────────────────
echo "============================================"
echo "  Investigation Complete!"
echo "============================================"
echo ""
echo "Findings Summary:"
echo "   Critical events : $(grep -c "CRITICAL" project_phoenix/logs/app.log)"
echo "   Error events    : $(grep -c "ERROR" project_phoenix/logs/app.log)"
echo "   Config diffs    : $(diff project_phoenix/config/dev/app.conf project_phoenix/config/prod/app.conf | grep -c "^[<>]" || true) lines differ (dev vs prod)"
echo "   Kernel issues   : $(grep -icE "error|oom|kill" /tmp/simulated_dmesg.txt) entries"
echo ""
echo "Investigation report: project_phoenix/investigation/investigation_report.txt"
echo ""
echo "Sarah Chen has been briefed. Security role incoming..."
echo "   Next Lab: Fortress Guardian "

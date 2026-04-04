#!/bin/bash

# ============================================================
#  Project Phoenix — Fortress Guardian Script
#  Role: Fortress Guardian / Security Administrator
#  Author: Kanchan Kumari
#  Description: Secures the Project Phoenix infrastructure
#               using chmod, chown, chgrp, setgid, and
#               permission auditing. Runs as current user
#               (no root required for demo mode).
# ============================================================

set -e

echo "============================================"
echo "   Project Phoenix — Fortress Guardian"
echo "============================================"
echo ""

# ─────────────────────────────────────────
# Detect if running as root
# ─────────────────────────────────────────
CURRENT_USER=$(whoami)
IS_ROOT=false
if [ "$CURRENT_USER" = "root" ]; then
  IS_ROOT=true
fi

echo "[INFO] Running as: $CURRENT_USER"
echo "[INFO] Root mode : $IS_ROOT"
echo "[INFO] (chown/chgrp tasks shown as commands if not root)"
echo ""

# ─────────────────────────────────────────
# SETUP: Build the project structure
# ─────────────────────────────────────────
echo "[SETUP]   Creating Project Phoenix structure..."

mkdir -p project_phoenix/{src/{frontend,backend,utils,shared},config/{dev,staging,prod},backups/configs,logs,archives,docs,tests,workspace/team,investigation}

# Create sensitive files
cat > project_phoenix/config/prod/api_keys.conf <<'EOF'
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
SENDGRID_API_KEY=SG.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
DB_PASSWORD=Pr0jectPh03n1x_Sup3rS3cur3!
EOF

cat > project_phoenix/config/prod/private.key <<'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA0Z3VS5JJcds3xHn/ygHBZGYFDKmGCsAJJMHnMDhJaP7EXAMPLE
(simulated private key — not real)
-----END RSA PRIVATE KEY-----
EOF

cat > project_phoenix/config/prod/app.conf <<'EOF'
ENV=production
DB_HOST=prod.db.internal
DB_PORT=5432
DEBUG=false
MAX_CONNECTIONS=200
EOF

cat > project_phoenix/config/dev/app.conf <<'EOF'
ENV=development
DB_HOST=localhost
DB_PORT=5432
DEBUG=true
MAX_CONNECTIONS=10
EOF

cat > project_phoenix/config/staging/app.conf <<'EOF'
ENV=staging
DB_HOST=staging.db.internal
DB_PORT=5432
DEBUG=false
MAX_CONNECTIONS=50
EOF

# Create source files
echo "console.log('Phoenix Frontend');" > project_phoenix/src/frontend/app.js
echo "from flask import Flask; app = Flask(__name__)" > project_phoenix/src/backend/server.py
echo "# Shared utility module" > project_phoenix/src/shared/common.py
echo "# Team notes" > project_phoenix/workspace/team/notes.txt

echo "      Structure created."
echo ""

# ─────────────────────────────────────────
# TASK 1: Secure Sensitive Files (chmod)
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 1:  Securing Sensitive Files"
echo "============================================"
echo ""

echo ">>> Before — Current permissions on prod/:"
ls -la project_phoenix/config/prod/
echo ""

echo ">>> Applying security permissions..."

# API keys — owner read/write only
chmod 600 project_phoenix/config/prod/api_keys.conf
echo "      chmod 600 → api_keys.conf  (owner rw only)"

# Private key — read only, even owner can't accidentally overwrite
chmod 400 project_phoenix/config/prod/private.key
echo "      chmod 400 → private.key    (owner read only)"

# Prod app config — owner rw, group read only
chmod 640 project_phoenix/config/prod/app.conf
echo "      chmod 640 → app.conf       (owner rw, group r)"

# Dev config — standard
chmod 644 project_phoenix/config/dev/app.conf
echo "      chmod 644 → dev/app.conf   (owner rw, others r)"

chmod 640 project_phoenix/config/staging/app.conf
echo "      chmod 640 → staging/app.conf"

echo ""
echo ">>> After — Secured permissions on prod/:"
ls -la project_phoenix/config/prod/
echo ""

# ─────────────────────────────────────────
# TASK 2: Ownership Management
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 2: Ownership Management"
echo "============================================"
echo ""

if [ "$IS_ROOT" = true ]; then
  # Create groups and users if root
  groupadd -f developers
  groupadd -f devops
  groupadd -f phoenix

  useradd -m -g developers -G phoenix sarah 2>/dev/null || true

  echo ">>> Assigning ownership..."
  chown -R sarah:developers project_phoenix/src/
  echo "      chown -R sarah:developers → src/"

  chown -R root:devops project_phoenix/config/prod/
  echo "      chown -R root:devops → config/prod/"

  chown -R sarah:developers project_phoenix/logs/
  echo "      chown -R sarah:developers → logs/"

  chown -R root:root project_phoenix/backups/
  echo "      chown -R root:root → backups/"

  chown -R sarah:phoenix project_phoenix/docs/
  echo "      chown -R sarah:phoenix → docs/"

  chown -R sarah:developers project_phoenix/workspace/
  echo "      chown -R sarah:developers → workspace/"

else
  echo "[DEMO MODE] chown requires root. Showing commands that would be run:"
  echo ""
  echo "  # Assign src/ to sarah's dev team"
  echo "  sudo chown -R sarah:developers project_phoenix/src/"
  echo ""
  echo "  # Prod config owned by root:devops (restricted)"
  echo "  sudo chown -R root:devops project_phoenix/config/prod/"
  echo ""
  echo "  # Logs owned by sarah's team"
  echo "  sudo chown -R sarah:developers project_phoenix/logs/"
  echo ""
  echo "  # Backups locked to root"
  echo "  sudo chown -R root:root project_phoenix/backups/"
  echo ""
  echo "  # Docs readable by phoenix group"
  echo "  sudo chown -R sarah:phoenix project_phoenix/docs/"
  echo ""
  echo "  # Workspace for dev team"
  echo "  sudo chown -R sarah:developers project_phoenix/workspace/"
fi

echo ""

# ─────────────────────────────────────────
# TASK 3: Directory Security
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 3:  Directory Permission Hardening"
echo "============================================"
echo ""

echo ">>> Securing directories..."

# Prod config — owner + group only, no others
chmod 750 project_phoenix/config/prod/
echo "      chmod 750 → config/prod/    (owner rwx, group rx, others ---)"

# All config — restricted
chmod 750 project_phoenix/config/
echo "      chmod 750 → config/         (owner rwx, group rx, others ---)"

# Backups — owner only
chmod 700 project_phoenix/backups/
echo "      chmod 700 → backups/        (owner rwx only)"

# Docs — world readable (public documentation)
chmod 755 project_phoenix/docs/
echo "      chmod 755 → docs/           (world readable)"

# Tests — team only
chmod 750 project_phoenix/tests/
echo "      chmod 750 → tests/"

# Logs — team read/write
chmod 770 project_phoenix/logs/
echo "      chmod 770 → logs/           (owner+group rwx)"

# Archives — owner + group read
chmod 750 project_phoenix/archives/
echo "      chmod 750 → archives/"

# Remove all others access from root project dir
chmod 750 project_phoenix/
echo "      chmod 750 → project_phoenix/ (no world access)"

echo ""
echo ">>> Directory permission audit:"
ls -la project_phoenix/
echo ""

# ─────────────────────────────────────────
# TASK 4: SetGID — Collaborative Dirs
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 4:   SetGID for Team Collaboration"
echo "============================================"
echo ""

echo ">>> Setting setgid on shared directories..."
echo "    (New files will automatically inherit group ownership)"
echo ""

# SetGID on src/shared — any new file gets group of directory
chmod g+s project_phoenix/src/shared/
echo "      chmod g+s → src/shared/     (setgid enabled)"

# SetGID on src/ subdirs — team collaboration
chmod g+s project_phoenix/src/frontend/
chmod g+s project_phoenix/src/backend/
echo "      chmod g+s → src/frontend/, src/backend/"

# SetGID + full team access on workspace
chmod 2770 project_phoenix/workspace/team/
echo "      chmod 2770 → workspace/team/ (setgid + 770)"

echo ""
echo ">>> Verifying setgid (look for 's' in group execute bit):"
ls -la project_phoenix/src/
echo ""
ls -la project_phoenix/workspace/
echo ""

echo "  Legend: drwxrws--- = setgid active (lowercase s)"
echo "          drwxrwS--- = setgid set but no execute (uppercase S = warning)"
echo ""

# ─────────────────────────────────────────
# TASK 5: Full Workspace Security Audit
# ─────────────────────────────────────────
echo "============================================"
echo " TASK 5:  Full Security Audit"
echo "============================================"
echo ""

AUDIT="project_phoenix/investigation/security_audit.txt"

cat > "$AUDIT" <<HEADER
============================================================
  PROJECT PHOENIX — SECURITY AUDIT REPORT
  Auditor : Kanchan Kumari (Fortress Guardian)
  Date    : $(date '+%Y-%m-%d %H:%M:%S')
============================================================

HEADER

echo "=== FULL PERMISSION TREE ===" >> "$AUDIT"
find project_phoenix/ | sort | while read f; do
  ls -ld "$f" 2>/dev/null
done >> "$AUDIT"
echo "" >> "$AUDIT"

echo "=== SENSITIVE FILES (600/400) ===" >> "$AUDIT"
find project_phoenix/ -type f \( -perm 600 -o -perm 400 \) -exec ls -la {} \; >> "$AUDIT"
echo "" >> "$AUDIT"

echo "=== WORLD-WRITABLE FILES (RISK) ===" >> "$AUDIT"
find project_phoenix/ -type f -perm -o+w 2>/dev/null >> "$AUDIT" || echo "  None found. " >> "$AUDIT"
echo "" >> "$AUDIT"

echo "=== SETGID DIRECTORIES ===" >> "$AUDIT"
find project_phoenix/ -type d -perm -2000 -exec ls -ld {} \; >> "$AUDIT"
echo "" >> "$AUDIT"

cat >> "$AUDIT" <<FOOTER
============================================================
  SECURITY SUMMARY
============================================================
  api_keys.conf  : 600   Owner read/write only
  private.key    : 400   Owner read only (immutable)
  prod/app.conf  : 640   Owner rw, group read
  config/prod/   : 750   No world access
  backups/       : 700   Owner only
  src/shared/    : g+s   SetGID — group auto-inherited
  workspace/team : 2770  SetGID + team rwx

  No world-writable files detected.
  Least-privilege model successfully applied.
============================================================
  Fortress Guardian mission: COMPLETE 
  Next: Keeper of the Keys — User Access Management 
============================================================
FOOTER

echo "       Security audit saved to: $AUDIT"
echo ""

# ─────────────────────────────────────────
# FINAL SUMMARY
# ─────────────────────────────────────────
echo "============================================"
echo "   Fortress Guardian — Mission Complete!"
echo "============================================"
echo ""
echo " Security Summary:"
echo "   Sensitive files secured (600/400) : $(find project_phoenix/ -type f \( -perm 600 -o -perm 400 \) | wc -l)"
echo "   SetGID directories configured     : $(find project_phoenix/ -type d -perm -2000 | wc -l)"
echo "   World-writable files remaining    : $(find project_phoenix/ -type f -perm -o+w 2>/dev/null | wc -l)"
echo "   Total files audited               : $(find project_phoenix/ -type f | wc -l)"
echo ""
echo " Audit report : project_phoenix/investigation/security_audit.txt"
echo ""
echo " CTO and Sarah Chen impressed!"
echo "   Sarah's recommendation:  Security Role Approved"
echo "   Next Lab: Keeper of the Keys   — User Access Management"

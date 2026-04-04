#!/bin/bash

# ============================================================
#  Project Phoenix — Linux File System Organization Script
#  Role: Digital Architect
#  Author: Kanchan Kumari
#  Description: Automates the full lab setup — directory
#               structure, file organization, backups,
#               log archiving, and cleanup.
# ============================================================

set -e  # Exit immediately on any error

echo "============================================"
echo "   Project Phoenix — Setup Script"
echo "============================================"
echo ""

# ─────────────────────────────────────────
# TASK 1: Create Directory Structure
# ─────────────────────────────────────────
echo "[1/5]  Creating directory structure..."

mkdir -p project_phoenix/{src/{frontend,backend,utils},config/{dev,staging,prod},backups/configs,logs,archives,docs,tests}

echo "      Directory structure created."
echo ""

# ─────────────────────────────────────────
# TASK 2: Create & Organize Sample Files
# ─────────────────────────────────────────
echo "[2/5]  Creating and organizing sample source files..."

# Simulate scattered files (as if they existed in a messy env)
touch /tmp/phoenix_app.js /tmp/phoenix_index.html /tmp/phoenix_style.css
touch /tmp/phoenix_server.py /tmp/phoenix_db.py /tmp/phoenix_api.py
touch /tmp/phoenix_helpers.sh /tmp/phoenix_utils.py

# Move to appropriate src/ subdirectories
mv /tmp/phoenix_app.js       project_phoenix/src/frontend/app.js
mv /tmp/phoenix_index.html   project_phoenix/src/frontend/index.html
mv /tmp/phoenix_style.css    project_phoenix/src/frontend/style.css

mv /tmp/phoenix_server.py    project_phoenix/src/backend/server.py
mv /tmp/phoenix_db.py        project_phoenix/src/backend/db.py
mv /tmp/phoenix_api.py       project_phoenix/src/backend/api.py

mv /tmp/phoenix_helpers.sh   project_phoenix/src/utils/helpers.sh
mv /tmp/phoenix_utils.py     project_phoenix/src/utils/utils.py

echo "       Source files organized into src/."
echo ""

# ─────────────────────────────────────────
# TASK 3: Config Files + Backups
# ─────────────────────────────────────────
echo "[3/5]  Setting up config files and backups..."

# Create sample config files
cat > project_phoenix/config/dev/app.conf <<EOF
ENV=development
DB_HOST=localhost
DB_PORT=5432
DEBUG=true
EOF

cat > project_phoenix/config/staging/app.conf <<EOF
ENV=staging
DB_HOST=staging.db.internal
DB_PORT=5432
DEBUG=false
EOF

cat > project_phoenix/config/prod/app.conf <<EOF
ENV=production
DB_HOST=prod.db.internal
DB_PORT=5432
DEBUG=false
EOF

# Backup all config files
cp -r project_phoenix/config/dev/app.conf   project_phoenix/backups/configs/dev_app.conf.bak
cp -r project_phoenix/config/staging/app.conf project_phoenix/backups/configs/staging_app.conf.bak
cp -r project_phoenix/config/prod/app.conf  project_phoenix/backups/configs/prod_app.conf.bak

echo "       Configs created and backed up to backups/configs/."
echo ""

# ─────────────────────────────────────────
# TASK 4: Generate Logs + Archive Old Ones
# ─────────────────────────────────────────
echo "[4/5]   Generating logs and archiving old ones..."

# Create current active logs
echo "[INFO] Server started at $(date)" > project_phoenix/logs/app.log
echo "[INFO] DB connected at $(date)"  >> project_phoenix/logs/app.log
echo "[INFO] API ready at $(date)"     >> project_phoenix/logs/app.log

# Simulate old logs to archive
mkdir -p /tmp/old_logs_phoenix
echo "[INFO] Old server log - Jan 2025"  > /tmp/old_logs_phoenix/server_jan.log
echo "[ERROR] Timeout error - Jan 2025" >> /tmp/old_logs_phoenix/server_jan.log
echo "[INFO] Old server log - Feb 2025"  > /tmp/old_logs_phoenix/server_feb.log

# Archive old logs as tar.gz
tar -czf project_phoenix/archives/logs_jan_feb_2025.tar.gz -C /tmp/old_logs_phoenix .

# Clean up temp old logs
rm -rf /tmp/old_logs_phoenix

echo "       Active logs in logs/, old logs archived to archives/."
echo ""

# ─────────────────────────────────────────
# TASK 5: Cleanup Temp Files
# ─────────────────────────────────────────
echo "[5/5]  Cleaning up temporary files..."

# Remove any stray .tmp files if present
find project_phoenix/ -name "*.tmp" -type f -delete 2>/dev/null || true
find project_phoenix/ -name "*.swp" -type f -delete 2>/dev/null || true

echo "       Cleanup complete."
echo ""

# ─────────────────────────────────────────
# FINAL VERIFICATION
# ─────────────────────────────────────────
echo "============================================"
echo "  Project Phoenix Setup Complete!"
echo "============================================"
echo ""
echo "Final Directory Structure:"
echo ""
find project_phoenix/ | sort | sed 's|[^/]*/|  |g'
echo ""
echo "Summary:"
echo "   Source files   : $(find project_phoenix/src -type f | wc -l) files"
echo "   Config files   : $(find project_phoenix/config -type f | wc -l) files"
echo "   Backups        : $(find project_phoenix/backups -type f | wc -l) files"
echo "   Active logs    : $(find project_phoenix/logs -type f | wc -l) files"
echo "   Archives       : $(find project_phoenix/archives -type f | wc -l) archives"
echo ""
echo " Sarah Chen and the team are ready to roll!"
echo "   Next Lab: Log Investigator "

#!/bin/bash

# ==============================
# Project Phoenix - Day 1 Script
# System Assessment & Recon
# ==============================

# Output file
REPORT="system_assessment_report.txt"

echo "[+] Starting System Assessment..." > $REPORT
echo "========================================" >> $REPORT
echo "Timestamp: $(date)" >> $REPORT
echo "========================================" >> $REPORT

# ------------------------------
# 1. Identity Verification
# ------------------------------
echo -e "\n[1] Current User (whoami):" >> $REPORT
whoami >> $REPORT

# ------------------------------
# 2. System Information
# ------------------------------
echo -e "\n[2] System Information (uname -a):" >> $REPORT
uname -a >> $REPORT

# ------------------------------
# 3. Active Sessions
# ------------------------------
echo -e "\n[3] Logged-in Users (who):" >> $REPORT
who >> $REPORT

# ------------------------------
# 4. Access Control Check
# ------------------------------
echo -e "\n[4] User ID & Groups (id):" >> $REPORT
id >> $REPORT

# ------------------------------
# 5. Process Monitoring
# ------------------------------
echo -e "\n[5] Top Processes Snapshot:" >> $REPORT
top -b -n 1 | head -20 >> $REPORT

# ------------------------------
# 6. Disk Usage (Bonus)
# ------------------------------
echo -e "\n[6] Disk Usage:" >> $REPORT
df -h >> $REPORT

# ------------------------------
# 7. Memory Usage (Bonus)
# ------------------------------
echo -e "\n[7] Memory Usage:" >> $REPORT
free -h >> $REPORT

# ------------------------------
# Completion Message
# ------------------------------
echo -e "\n[+] Assessment Completed Successfully." >> $REPORT

echo "[+] Report saved as $REPORT"

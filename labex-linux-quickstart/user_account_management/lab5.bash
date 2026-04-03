#!/bin/bash
 
# ============================================================
# Linux User Account Management - Lab Practice Script
# Topic: User account creation, modification, and deletion
# Relevance: Blue Team / SOC - Account monitoring & auditing
# ============================================================
 
 
# ----------------------------
# 1. CREATE A NEW USER
# ----------------------------
# -m flag creates a home directory automatically
sudo useradd -m testuser
 
echo "[+] User 'testuser' created"
 
 
# ----------------------------
# 2. SET A PASSWORD
# ----------------------------
sudo passwd testuser
 
echo "[+] Password set for 'testuser'"
 
 
# ----------------------------
# 3. MODIFY USER PROPERTIES
# ----------------------------
 
# Change home directory
sudo usermod -d /home/newdir testuser
 
# Change default shell
sudo usermod -s /bin/bash testuser
 
echo "[+] Home directory and shell updated"
 
 
# ----------------------------
# 4. ADD USER TO A GROUP
# ----------------------------
# -aG = append to group (don't remove from existing groups)
sudo usermod -aG sudo testuser
 
echo "[+] 'testuser' added to sudo group"
 
 
# ----------------------------
# 5. LOCK AND UNLOCK ACCOUNT
# ----------------------------
 
# Lock the account
sudo usermod -L testuser
echo "[+] Account locked"
 
# Unlock the account
sudo usermod -U testuser
echo "[+] Account unlocked"
 
 
# ----------------------------
# 6. DELETE A USER
# ----------------------------
# -r flag removes the home directory as well
sudo userdel -r testuser
 
echo "[+] User 'testuser' deleted"
 
 
# ----------------------------
# KEY FILES TO KNOW
# ----------------------------
# /etc/passwd  → user account info (username, UID, shell, home dir)
# /etc/shadow  → hashed passwords
# /etc/group   → group memberships
 
# View all users:
# cat /etc/passwd
 
# View group memberships:
# cat /etc/group
 
 
# ----------------------------
# SOC/BLUE TEAM - AUDIT CHECKS
# ----------------------------
 
# Check for users with UID 0 (root-level) other than root — suspicious!
echo "[*] Users with UID 0:"
awk -F: '($3 == 0) {print $1}' /etc/passwd
 
# Check users with login shells (should only be real human accounts)
echo "[*] Users with login shells:"
grep -v '/nologin\|/false' /etc/passwd
 
# Check recent account activity
echo "[*] Recent auth log entries:"
sudo tail -20 /var/log/auth.log
 
# MITRE ATT&CK References:
# T1136 - Create Account: https://attack.mitre.org/techniques/T1136/
# T1078 - Valid Accounts:  https://attack.mitre.org/techniques/T1078/

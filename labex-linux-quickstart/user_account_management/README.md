# Lab 5 - Linux User Account Management
## Overview
This lab covers fundamental Linux user account management — creating, modifying, and deleting user accounts, managing groups, and controlling account access. These are core sysadmin skills with direct relevance to Blue Team/SOC work.

### Concepts Covered

/etc/passwd and /etc/shadow file structure
Home directories and default shells
User groups and permissions
Account locking/unlocking


## Commands Practiced
Create a new user
bashsudo useradd -m username
Set a password
bashsudo passwd username
Modify user properties (home directory & shell)
bashsudo usermod -d /new/home username
sudo usermod -s /bin/bash username
Add user to a group
bashsudo usermod -aG groupname username
Lock and unlock an account
bashsudo usermod -L username   # Lock
sudo usermod -U username   # Unlock
Delete a user
bashsudo userdel -r username   # -r removes home directory too

### Key Files
FilePurpose/etc/passwdStores user account info (username, UID, shell, home dir)/etc/shadowStores hashed passwords/etc/groupStores group memberships

## SOC/Blue Team Relevance
ScenarioWhy It MattersUnexpected user in /etc/passwdPossible backdoor account created by attacker
Service account with /bin/bash shellSuspicious — service accounts shouldn't have login shells
User added to sudo groupPrivilege escalation indicator
Account locked/unlocked unexpectedlyPotential IoC — check auth.log

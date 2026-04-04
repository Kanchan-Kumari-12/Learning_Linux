#  Project Phoenix — Fortress Guardian Lab

## Overview

**Lab Title:** Fortress Guardian — Securing the Infrastructure  
**Role:** Fortress Guardian / Security Administrator  
**Difficulty:** Intermediate → Advanced  
**Skills Covered:** `chmod`, `chown`, `chgrp`, `umask`, `setgid`, `ls -la`, permission octals

---

##  Objective

Project Phoenix's codebase and infrastructure are exposed. As the **Fortress Guardian**, your mission is to lock down file permissions, assign correct ownership, configure directory security, and set up collaborative workspaces — all while maintaining a balance between security and productivity.

---

##  Prerequisites

- Completed Lab 1: Digital Architect
- Completed Lab 2: Log Investigator
- Linux/Unix terminal (Ubuntu recommended)
- Basic understanding of Linux users and groups

---

##  Linux Permissions Crash Course

```
Permission String:  -rwxr-xr--
                    │├──┤├──┤├──┤
                    │ Owner Group Others
                    │
                    └─ File type: - (file), d (dir), l (link)

rwx = read(4) + write(2) + execute(1) = 7
r-x = read(4) + execute(1)            = 5
r-- = read(4)                         = 4
--- = no permissions                  = 0
```

### Common Permission Sets

| Octal | String | Use Case |
|-------|--------|----------|
| `700` | `rwx------` | Private scripts, SSH keys |
| `600` | `rw-------` | Private files, API keys |
| `644` | `rw-r--r--` | Public config, web files |
| `755` | `rwxr-xr-x` | Public directories, executables |
| `770` | `rwxrwx---` | Team shared directories |
| `640` | `rw-r-----` | Group-readable sensitive files |
| `400` | `r--------` | Read-only secrets (certs, keys) |

---

##  Lab Tasks

### Task 1 — Secure Sensitive Keys (`chmod 600`)
Lock down API keys, tokens, and secrets so only the owner can read/write them.

```bash
chmod 600 project_phoenix/config/prod/api_keys.conf
chmod 400 project_phoenix/config/prod/private.key   # Read-only
ls -la project_phoenix/config/prod/
```

### Task 2 — Ownership Management (`chown`, `chgrp`)
Assign files to the correct user and group. Sarah's team owns the src/, CTO owns prod config.

```bash
chown sarah:developers project_phoenix/src/
chown -R sarah:developers project_phoenix/src/
chgrp devops project_phoenix/config/prod/
ls -la project_phoenix/
```

### Task 3 — Directory Security (`chmod` on dirs)
Set appropriate directory permissions — world-readable for docs, restricted for config.

```bash
chmod 755 project_phoenix/docs/         # Everyone can read
chmod 750 project_phoenix/config/       # Owner + group only
chmod 700 project_phoenix/backups/      # Owner only
```

### Task 4 — SetGID on Collaborative Dirs (`chmod g+s`)
Configure setgid so new files in shared dirs automatically inherit the group — perfect for team workspaces.

```bash
chmod g+s project_phoenix/src/shared/
# OR using octal:
chmod 2770 project_phoenix/src/shared/

# Verify setgid is set (look for 's' in group execute bit):
ls -la project_phoenix/src/
# drwxrws--- = setgid active
```

### Task 5 — Full Collaborative Workspace Setup
Combine ownership + permissions + setgid for a production-ready team workspace.

```bash
mkdir -p project_phoenix/workspace/team
chown -R sarah:developers project_phoenix/workspace/
chmod 2770 project_phoenix/workspace/team/   # setgid + rwx for owner+group
chmod o-rwx project_phoenix/workspace/       # No access for others
```

---

##  Key Commands Reference

| Command | Example | Purpose |
|---------|---------|---------|
| `chmod` | `chmod 755 file` | Set permissions using octal |
| `chmod` | `chmod u+x file` | Add execute for owner |
| `chmod` | `chmod g+s dir` | Set setgid on directory |
| `chmod` | `chmod o-rwx dir` | Remove all access for others |
| `chmod -R` | `chmod -R 750 dir/` | Recursive permission change |
| `chown` | `chown user:group file` | Change owner and group |
| `chown -R` | `chown -R sarah:dev src/` | Recursive ownership change |
| `chgrp` | `chgrp devops config/` | Change group only |
| `ls -la` | `ls -la dir/` | View permissions + ownership |
| `stat` | `stat file` | Detailed file metadata |
| `umask` | `umask 027` | Set default permission mask |
| `id` | `id username` | View user's UID/GID/groups |

---

##  Special Permission Bits

| Bit | Octal | Symbol | Effect |
|-----|-------|--------|--------|
| SetUID | 4000 | `s` in owner exec | Run as file owner |
| SetGID | 2000 | `s` in group exec | Inherit group on new files |
| Sticky | 1000 | `t` in others exec | Only owner can delete (e.g. /tmp) |

```bash
# SetGID example
chmod 2770 shared_dir/    # = chmod g+s + 770

# Sticky bit example (like /tmp)
chmod 1777 public_dir/    # = chmod +t + 777
```

---

##  Security Checklist

- [ ] API keys and secrets: `600` (owner read/write only)
- [ ] Private keys/certs: `400` (owner read only)
- [ ] Source code dirs: `750` (owner+group, no others)
- [ ] Public docs: `755` (world-readable)
- [ ] Prod configs: `640` or `600`
- [ ] Team workspace: `2770` (setgid + owner+group rwx)
- [ ] Backups dir: `700` (owner only)
- [ ] Ownership assigned to correct user:group everywhere

---

##  Final Permission Map

```
project_phoenix/          drwxr-x---  sarah:phoenix
├── src/                  drwxrwx---  sarah:developers  (setgid)
│   ├── frontend/         drwxrwx---  sarah:developers
│   ├── backend/          drwxrwx---  sarah:developers
│   └── shared/           drwxrws---  sarah:developers  (setgid ← s)
├── config/               drwxr-x---  root:devops
│   ├── dev/              drwxr-x---  sarah:developers
│   ├── staging/          drwxr-x---  sarah:devops
│   └── prod/             drwx------  root:devops
│       ├── app.conf      -rw-r-----  root:devops       (640)
│       ├── api_keys.conf -rw-------  root:devops       (600)
│       └── private.key   -r--------  root:devops       (400)
├── backups/              drwx------  root:root         (700)
├── logs/                 drwxrwx---  sarah:developers
├── docs/                 drwxr-xr-x  sarah:phoenix     (755)
└── workspace/team/       drwxrws---  sarah:developers  (setgid)
```

---

##  Learning Outcomes

After completing this lab, you will be able to:
1. Read and write Linux permission strings and octals fluently
2. Apply `chmod` with both symbolic and octal notation
3. Assign and transfer file ownership using `chown` and `chgrp`
4. Configure setgid for automatic group inheritance in team dirs
5. Design a least-privilege permission model for a real project

---

##  Real-World SOC/Security Application

| Lab Skill | Real-World Equivalent |
|-----------|----------------------|
| `chmod 600` on keys | Protecting SSH keys, API tokens |
| `chown root:devops` | Privileged file ownership in prod |
| SetGID on shared dirs | CI/CD shared artifact directories |
| Sticky bit | `/tmp` and shared upload folders |
| Least-privilege model | Zero-trust access control design |
| `ls -la` audit | File permission auditing in DFIR |

---


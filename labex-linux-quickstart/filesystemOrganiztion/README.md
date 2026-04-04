# Project Phoenix — Linux File System Organization Lab

## Overview

**Lab Title:** Digital Architect — Project Phoenix Setup  
**Role:** System Administrator / Digital Architect  
**Difficulty:** Beginner → Intermediate  
**Skills Covered:** `mkdir`, `mv`, `cp`, `tar`, `rm`, `ls`, `find`

---

## Objective

Transform a chaotic development environment into a well-organized, production-ready Linux directory structure for **Project Phoenix** — a collaborative software development project.

---

##  Prerequisites

- Linux/Unix terminal (Ubuntu recommended)
- Basic command-line familiarity
- No sudo/root required

---

## Final Directory Structure

```
project_phoenix/
├── src/                   # Source code files
│   ├── frontend/
│   ├── backend/
│   └── utils/
├── config/                # Configuration files
│   ├── dev/
│   ├── staging/
│   └── prod/
├── backups/               # Config & data backups
│   └── configs/
├── logs/                  # Active log files
├── archives/              # Archived old logs (tar.gz)
├── docs/                  # Documentation
└── tests/                 # Test files
```

---

## Lab Tasks

### Task 1 — Build the Directory Structure
Create all required directories using `mkdir -p`.

### Task 2 — Organize Source Files
Move scattered source files into appropriate `src/` subdirectories using `mv`.

### Task 3 — Secure Configurations
Copy config files to `config/` and create backups in `backups/configs/` using `cp`.

### Task 4 — Archive Old Logs
Compress old log files into `.tar.gz` archives and move them to `archives/` using `tar`.

### Task 5 — Clean Up
Remove temporary files and verify the final structure using `rm` and `ls -R`.

---

## Key Commands Used

| Command | Purpose |
|--------|---------|
| `mkdir -p` | Create nested directories in one shot |
| `mv` | Move/rename files and directories |
| `cp -r` | Copy files/directories recursively |
| `tar -czf` | Create compressed `.tar.gz` archive |
| `tar -xzf` | Extract a `.tar.gz` archive |
| `rm -rf` | Remove files/directories forcefully |
| `ls -la` | List all files with details |
| `find . -name` | Search files by name |

---

## Success Criteria

- [ ] All directories created with correct hierarchy
- [ ] Source files organized into `src/` subdirectories
- [ ] Config files backed up to `backups/configs/`
- [ ] Old logs archived as `.tar.gz` in `archives/`
- [ ] No stray/temp files remaining in root
- [ ] `ls -R project_phoenix/` shows clean structure

---

##  Learning Outcomes

After completing this lab, you will be able to:
1. Design and implement a professional Linux directory structure
2. Safely move and copy files without data loss
3. Create and manage compressed archives for log rotation
4. Clean up system resources systematically
5. Apply these skills in real SOC/DevOps/SysAdmin environments

---

##  Real-World Application

These skills directly map to:
- **SOC Analyst** — Log management, evidence archiving, incident folder structure
- **DevOps/SysAdmin** — Server setup, deployment pipelines, backup scripts
- **DFIR** — Organizing collected artifacts during forensic investigation

---


# 🐧 Linux Terminal Fundamentals — LabEx Adventure Lab 1


## 📌 Overview

This is the first Linux lab completed on **LabEx**, covering essential terminal commands that form the foundation of working in any Linux-based environment. These skills are directly applicable to SOC analyst workflows, where the terminal is the primary workspace for log analysis, tool execution, and system investigation.

---

## 🎯 Objectives

By the end of this lab, the following skills were practiced:

- Opening and navigating the Linux terminal
- Printing output using `echo`
- Querying system time and date information
- Performing arithmetic operations in the terminal
- Generating ASCII art with `figlet`
- Maintaining a clean working environment

---

## 🛠️ Commands Covered

| # | Command | Purpose | SOC Use Case |
|---|---------|---------|--------------|
| 1 | `echo` | Print text or variables to stdout | Display script output, debug environment variables |
| 2 | `date` | Show current system date and time | Timestamp correlation in incident timelines |
| 3 | `ncal` | Display a calendar in the terminal | Cross-referencing dates during log analysis |
| 4 | `expr` | Perform arithmetic expressions | Quick calculations (e.g., time deltas, byte counts) |
| 5 | `figlet` | Render text as ASCII art | Terminal customization, banner generation in scripts |
| 6 | `clear` | Clear the terminal screen | Workspace hygiene during active investigations |

---

## 🧪 Commands & Usage

### 1. `echo` — Print to Terminal
```bash
echo "Hello, World!"
echo $HOME        # print environment variable
```

### 2. `date` — System Date & Time
```bash
date                          # current date and time
date +"%Y-%m-%d %H:%M:%S"    # formatted timestamp (useful for log work)
```

### 3. `ncal` — Calendar View
```bash
ncal          # current month
ncal 2025     # full year view
```

### 4. `expr` — Arithmetic Operations
```bash
expr 10 + 5
expr 100 / 4
expr 8 \* 3    # escape * to avoid shell glob expansion
```

### 5. `figlet` — ASCII Art Text
```bash
figlet "SOC Analyst"
figlet -f slant "Linux"    # alternate font
```

**Sample Output:**
```
 ____   ___   ____      _                _           _   
/ ___| / _ \ / ___|    / \   _ __   __ _| |_   _ ___| |_ 
\___ \| | | | |       / _ \ | '_ \ / _` | | | | / __| __|
 ___) | |_| | |___   / ___ \| | | | (_| | | |_| \__ \ |_ 
|____/ \___/ \____| /_/   \_\_| |_|\__,_|_|\__, |___/\__|
                                            |___/         
```

### 6. `clear` — Clean the Terminal
```bash
clear    # or press Ctrl + L
```

---

## 📚 Key Concepts Learned

- **Standard Output (stdout)** — How commands print results to the terminal
- **Environment Variables** — Accessible via `echo $VARIABLE`
- **Unix Timestamps & Formatting** — Critical for timeline reconstruction in incident response
- **Terminal Arithmetic** — Quick in-shell calculations without opening external tools
- **Workspace Discipline** — Keeping the terminal clean during investigations reduces cognitive load

---

## 🔗 SOC & Blue Team Relevance

> These may seem like simple commands — but terminal fluency is non-negotiable for any SOC analyst.

```
Incident Response  →  date, echo, clear (scripting & timeline work)
Log Analysis       →  echo, expr (parsing, filtering, quick math)
Threat Hunting     →  comfort in terminal = faster triage
Forensics          →  timestamp awareness via date formatting

---

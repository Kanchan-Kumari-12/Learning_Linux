
# 🖥️ Linux System Monitor

A lightweight Bash script that monitors CPU, memory, and disk usage in real time — with threshold-based alerts.

Built as part of my Linux scripting practice for Blue Team / SOC skill development.

---

## 📸 Demo

```
=== System Monitor - Fri Apr 10 10:15:00 UTC 2026 ===
--------------------------------
CPU  Usage : 12%
MEM  Usage : 45%
DISK Usage : 30%
--------------------------------
Next check in 5 seconds... (Ctrl+C to stop)
```

---

## ⚙️ Features

- Real-time monitoring of CPU, Memory, and Disk usage
- Configurable threshold values for each resource
- Instant alert when any resource exceeds its threshold
- Auto-refresh every 5 seconds
- Clean terminal output with timestamps

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| `bash` | Script language |
| `top` | CPU usage data |
| `free` | Memory usage data |
| `df` | Disk usage data |
| `awk` | Data parsing & formatting |

---


## 🧠 What I Learned

- Writing and structuring Bash functions
- Extracting system metrics using `top`, `free`, and `df`
- Parsing command output with `awk` and `cut`
- Handling integer comparisons in Bash (`-gt`, `-lt`)
- Converting float values to integers using `printf "%.0f"`
- Building infinite loops with `while true` and `sleep`

---

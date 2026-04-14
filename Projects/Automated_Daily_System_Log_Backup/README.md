
# Daily Log Backup using Cron Job

A automated backup system that archives daily log files using a cron job and tar command.

## About the Project

This project creates a scheduled cron job that automatically backs up log files from `/var/log/` directory into a compressed tar archive every day at 2:00 AM.

## Features

- Automated daily backup using cron job
- Compresses log files using tar and gzip
- Overwrites existing backup files (no duplicate files)
- Stores backup in a dedicated `/backup/logs/` directory

## Prerequisites

- Linux / Ubuntu system
- Terminal access
- sudo privileges

## Setup Instructions

1. Create backup directory
```bash
sudo mkdir -p /backup/logs
```

2. Test the tar command manually
```bash
sudo tar -czf /backup/logs/daily_backup.tar.gz /var/log/*.log
```

3. Verify backup file was created
```bash
ls -lh /backup/logs/
```

4. Open crontab editor
```bash
crontab -e
```

5. Add the following cron job
```
0 2 * * * sudo tar -czf /backup/logs/daily_backup.tar.gz /var/log/*.log
```

6. Verify cron job is set
```bash
crontab -l
```

## Cron Job Schedule

| Field   | Value | Meaning        |
|---------|-------|----------------|
| Minute  | 0     | At minute 0    |
| Hour    | 2     | At 2:00 AM     |
| Day     | *     | Every day      |
| Month   | *     | Every month    |
| Weekday | *     | Any day        |

## Backup Location

```
/backup/logs/daily_backup.tar.gz
```

## Tech Used

- **Cron** — Linux job scheduler
- **Tar** — Archive utility
- **Gzip** — Compression tool
- **Bash** — Shell commands

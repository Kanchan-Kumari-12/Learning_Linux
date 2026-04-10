#!/bin/bash

# ─── Thresholds ───────────────────────────────────────
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

# ─── CPU Usage ────────────────────────────────────────
get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.0f", $2}')
    echo "$cpu_usage"
}

# ─── Memory Usage ─────────────────────────────────────
get_mem_usage() {
    mem_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2*100}')
    echo "$mem_usage"
}

# ─── Disk Usage ───────────────────────────────────────
get_disk_usage() {
    disk_usage=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)
    echo "$disk_usage"
}

# ─── Alert Function ───────────────────────────────────
send_alert() {
    local resource=$1
    local usage=$2
    echo "  ALERT: $resource usage is at ${usage}% - Threshold exceeded!"
}

# ─── Main Loop ────────────────────────────────────────
while true; do
    clear
    echo "=== System Monitor - $(date) ==="
    echo "--------------------------------"

    cpu=$(get_cpu_usage)
    mem=$(get_mem_usage)
    disk=$(get_disk_usage)

    echo "CPU  Usage : ${cpu}%"
    echo "MEM  Usage : ${mem}%"
    echo "DISK Usage : ${disk}%"
    echo "--------------------------------"

    if [ "$cpu" -gt "$CPU_THRESHOLD" ]; then
        send_alert "CPU" "$cpu"
    fi

    if [ "$mem" -gt "$MEM_THRESHOLD" ]; then
        send_alert "MEMORY" "$mem"
    fi

    if [ "$disk" -gt "$DISK_THRESHOLD" ]; then
        send_alert "DISK" "$disk"
    fi

    echo "--------------------------------"
    echo "Next check in 5 seconds... (Ctrl+C to stop)"
    sleep 5
done

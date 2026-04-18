#!/bin/bash
LOG_FILE="./user_mgmt.log"
CSV_FILE="./users.csv"
SUCCESS=0
FAILED=0

log() {
    local level=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

if [[ $EUID -ne 0 ]]; then
    log "ERROR" "Script must be run as root (use sudo)"
    exit 1
fi

if [[ ! -f "$CSV_FILE" ]]; then
    log "ERROR" "CSV file not found: $CSV_FILE"
    exit 1
fi

log "INFO" "===== Batch User Management Started ====="

while IFS=',' read -r action username group shell comment; do

    action=$(echo "$action" | xargs)
    username=$(echo "$username" | xargs)
    group=$(echo "$group" | xargs)

    case "$action" in
        create)
            if ! getent group "$group" > /dev/null 2>&1; then
                groupadd "$group"
                log "INFO" "Group created: $group"
            fi

            if id "$username" &>/dev/null; then
                log "WARN" "User already exists, skipping: $username"
            else
                useradd -m -s "$shell" -G "$group" -c "$comment" "$username"
                if [[ $? -eq 0 ]]; then
                    log "INFO" "User created: $username | Group: $group"
                    ((SUCCESS++))
                else
                    log "ERROR" "Failed to create user: $username"
                    ((FAILED++))
                fi
            fi
            ;;

        delete)
            if id "$username" &>/dev/null; then
                userdel -r "$username" 2>/dev/null
                log "INFO" "User deleted: $username (home dir removed)"
                ((SUCCESS++))
            else
                log "WARN" "User not found for deletion: $username"
                ((FAILED++))
            fi
            ;;

        *)
            log "ERROR" "Unknown action '$action' for user: $username"
            ((FAILED++))
            ;;
    esac

done < <(tail -n +2 "$CSV_FILE") 

log "INFO" "===== Completed | Success: $SUCCESS | Failed: $FAILED ====="
EOF

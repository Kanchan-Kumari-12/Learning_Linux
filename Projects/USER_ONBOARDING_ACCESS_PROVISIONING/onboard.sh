#!/bin/bash

LOG_FILE="logs/onboard.log"
DRY_RUN=false

log(){
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [[ "$1" == "--dry-run" ]]; then
        DRY_RUN=true
        shift
fi

USERNAME=$1

if [[ -z "$USERNAME" ]]; then
        echo "USAGE: ./onboard.sh [--dry-run] <username>"
        exit 1
fi

if id "$USERNAME" &>/dev/null; then
        echo "ERROE: USER '$USERNAME' already exists."
        exit 1
fi

if [[ "$DRY_RUN" == true ]]; then
        log "[DRY-RUN] Would create user: $USERNAME"
else
        sudo useradd -m -s /bin/bash "$USERNAME"
        log "Created user: $USERNAME"
fi

if  [[ "$DRY_RUN" == true ]]; then
        log "[DRY-RUN] Would force password reset for: $USERNAME"
else
        sudo chage -d 0 "$USERNAME"
        log "Password reset forced for  $USERNAME"
fi

GROUP="soc-team"

if [[ "$DRY_RUN" == true ]]; then
    log "[DRY-RUN] Would add $USERNAME to group: $GROUP"
else
    sudo groupadd -f "$GROUP"   # group na ho toh create kar do
    sudo usermod -aG "$GROUP" "$USERNAME"
    log "Added $USERNAME to group: $GROUP"
fi

if [[ "$DRY_RUN" == true ]]; then
        log "[DRY-RUN] Would set permission 700 on /home/$USERNAME"
else
        sudo chmod 700 "/home/$USERNAME"
        log "Set permissions 700 on /home/$USERNAME"
fi

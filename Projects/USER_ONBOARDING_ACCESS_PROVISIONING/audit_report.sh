#!/bin/bash

LOG_FILE="logs/onboard.log"

echo "===== AUDIT REPORT ====="
echo "Generated: $(date)"
echo "========================"

echo "Total actions:"
cat "$LOG_FILE" | wc -l

echo "Real actions:"
grep -v "DRY-RUN" "$LOG_FILE" | wc -l

echo "DRY-RUN actions:"
grep "DRY-RUN" "$LOG_FILE" | wc -l

echo "Users created:"
grep "Created user" "$LOG_FILE" | awk '{print $NF}'

#!/bin/bash
UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LOWER="abcdefghijklmnopqrstuvwxyz"
DIGITS="0123456789"
SPECIAL="!@#$%^&*()_+-=[]{}|;:,.<>?"

read -p  "Enter Password length (8-64): " LENGTH

if [ [$LENGTH -lt 8 || $LENGTH -gt 64 ] ]; then
        echo "Error : Length must be between 8 and 64"
        exit 1
fi

ALL="$UPPER$LOWER$DIGIT$SPECIAL"
PASSWORD=""

for ((i=0; i<LENGTH; i++)); do
        RAND_INDEX=$((RANDOM %  ${#ALL} ))
        PASSWORD+="${ALL:$RAND_INDEX:1}"
done
echo ""
echo "Generated Password: $PASSWPRD"
echo ""

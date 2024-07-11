#!/bin/bash

# Variablen
THRESHOLD=80
EMAIL="levin.wiederkehr@edu.tbz.ch"
LOG_FILE="memory_log.log"

# Funktion zur Überprüfung des Speicherverbrauchs
check_memory() {
    local mem_usage=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
    
    if [ "$mem_usage" -ge "$THRESHOLD" ]; then
        echo "Hoher Speicherverbrauch: $mem_usage% am $(date)" | tee -a "$LOG_FILE"
        echo "Warnung: Hoher Speicherverbrauch ($mem_usage%) auf $(hostname) am $(date)" | mail -s "Hoher Speicherverbrauch Alarm" "$EMAIL"
    else
        echo "Speicherverbrauch normal: $mem_usage% am $(date)" | tee -a "$LOG_FILE"
    fi
}

# Hauptskript
while true; do
    check_memory
    sleep 60
done
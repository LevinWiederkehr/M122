#!/bin/bash

# Datei: task_scheduler.sh

# Variablen
TASK_FILE="tasks.txt"
LOG_FILE="task_scheduler.log"
declare -A TASKS
declare -A DEPENDENCIES

# Funktion zum Laden der Aufgaben aus der Datei
load_tasks() {
    while IFS="|" read -r id priority dependencies command; do
        id=$(echo $id | xargs)
        priority=$(echo $priority | xargs)
        dependencies=$(echo $dependencies | xargs)
        command=$(echo $command | xargs)

        TASKS[$id]="$priority|$dependencies|$command"

        if [ -n "$dependencies" ]; then
            IFS=',' read -r -a dep_array <<< "$dependencies"
            for dep in "${dep_array[@]}"; do
                DEPENDENCIES[$id]+="$dep "
            done
        fi
    done < <(grep -v "^#" $TASK_FILE)
}

# Funktion zum Ausführen einer Aufgabe
execute_task() {
    local id=$1
    local task="${TASKS[$id]}"
    local priority=$(echo $task | cut -d'|' -f1)
    local dependencies=$(echo $task | cut -d'|' -f2)
    local command=$(echo $task | cut -d'|' -f3)

    if [ -n "$dependencies" ]; then
        IFS=',' read -r -a dep_array <<< "$dependencies"
        for dep in "${dep_array[@]}"; do
            if [ -z "${TASKS_DONE[$dep]}" ]; then
                echo "Fehler: Abhängigkeit $dep für Aufgabe $id nicht erfüllt." | tee -a $LOG_FILE
                return 1
            fi
        done
    fi

    echo "Ausführen von Aufgabe $id: $command" | tee -a $LOG_FILE
    eval $command
    local status=$?

    if [ $status -eq 0 ]; then
        TASKS_DONE[$id]=1
        echo "Aufgabe $id erfolgreich abgeschlossen." | tee -a $LOG_FILE
    else
        echo "Fehler beim Ausführen von Aufgabe $id." | tee -a $LOG_FILE
    fi
}

# Funktion zum Ausführen der Aufgaben basierend auf Priorität und Abhängigkeiten
run_tasks() {
    for id in "${!TASKS[@]}"; do
        TASKS_SORTED+=("$id|${TASKS[$id]}")
    done

    IFS=$'\n' TASKS_SORTED=($(sort -t '|' -k2 -nr <<<"${TASKS_SORTED[*]}"))

    for task in "${TASKS_SORTED[@]}"; do
        local id=$(echo $task | cut -d'|' -f1)
        execute_task $id
    done
}

# Hauptskript
declare -A TASKS_DONE
load_tasks
run_tasks

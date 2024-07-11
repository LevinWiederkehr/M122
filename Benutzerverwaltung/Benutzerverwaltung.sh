#!/bin/bash

# Datei: user_management.sh

# Funktion zum Hinzufügen eines Benutzers
add_user() {
    local username=$1
    if id "$username" &>/dev/null; then
        echo "Benutzer $username existiert bereits."
    else
        sudo useradd -m "$username"
        echo "Benutzer $username wurde hinzugefügt."
    fi
}

# Funktion zum Entfernen eines Benutzers
remove_user() {
    local username=$1
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "Benutzer $username wurde entfernt."
    else
        echo "Benutzer $username existiert nicht."
    fi
}

# Funktion zum Anzeigen aller Benutzer
list_users() {
    echo "Liste aller Benutzer und deren Home-Verzeichnisse:"
    cut -d: -f1,6 /etc/passwd | tr ':' '\t'
}

# Hauptmenü
while true; do
    echo "Benutzerverwaltung"
    echo "1. Benutzer hinzufügen"
    echo "2. Benutzer entfernen"
    echo "3. Benutzer auflisten"
    echo "4. Beenden"
    read -p "Wählen Sie eine Option: " option

    case $option in
    1)
        read -p "Geben Sie den Benutzernamen ein: " username
        add_user "$username"
        ;;
    2)
        read -p "Geben Sie den Benutzernamen ein: " username
        remove_user "$username"
        ;;
    3)
        list_users
        ;;
    4)
        break
        ;;
    *)
        echo "Ungültige Option. Bitte erneut versuchen."
        ;;
    esac
done
#!/bin/bash

# Funktion zum Lesen und Transformieren der Daten
transform_data() {
    input_file=$1
    output_file=$2

    # CSV-Header hinzufügen
    echo "Lang;IBAN;Cdtr_AdrTp;Cdtr_Name;Cdtr_StrtNmOrAdrLine1;Cdtr_BldgNbOrAdrLine2;Cdtr_PstCd;Cdtr_TwnNm;Cdtr_Ctry" > "$output_file"

    # Variablen initialisieren
    lang="de"
    ctry="CH"
    
    # Felder initialisieren
    iban=""
    adr_tp=""
    name=""
    strt=""
    bldg_nb=""
    pstcd=""
    twn=""

    while IFS=';' read -r line
    do
        # Überprüfen, ob die Zeile mit "Herkunft" oder "Endkunde" beginnt und die relevanten Daten extrahieren
        if [[ $line == Herkunft* ]]; then
            IFS=';' read -r _ konto iban adr_tp name strt pstcd twn _ <<< "$line"
            echo "$lang;$iban;$adr_tp;$name;$strt;;$pstcd;$twn;$ctry" >> "$output_file"
        elif [[ $line == Endkunde* ]]; then
            IFS=';' read -r _ konto iban name strt pstcd twn <<< "$line"
            echo "$lang;$iban;;$name;$strt;;$pstcd;$twn;$ctry" >> "$output_file"
        fi
    done < "$input_file"
}

# Pfade zu den Input-Dateien
input_files=("x-ressourcen/rechnung24018.data" "x-ressourcen/rechnung24019.data")

# Pfad zur Output-Datei
output_file="output.csv"

# Temporäre Datei für die Zusammenführung der Daten
temp_file="temp_data.txt"

# Bereinigung der temporären Datei
> "$temp_file"

# Lesen und Zusammenführen der Daten aus den Input-Dateien
for input_file in "${input_files[@]}"
do
    cat "$input_file" >> "$temp_file"
done

# Transformiere die zusammengeführten Daten und speichere sie in der Output-Datei
transform_data "$temp_file" "$output_file"

# Lösche die temporäre Datei
rm "$temp_file"

echo "Die Daten wurden erfolgreich in die Datei $output_file transformiert."

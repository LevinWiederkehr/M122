#!/bin/bash

transform_data() {
input_file=$1
output_file=$2

echo "Lang;IBAN;Cdtr_AdrTp;Cdtr_Name;Cdtr_StrtNmOrAdrLine1;Cdtr_BldgNbOrAdrLine2;Cdtr_PstCd;Cdtr_TwnNm;Cdtr_Ctry" > "$output_file"

lang="de"
ctry="CH"

while IFS=';' read -r line
do
if [[ $line == Herkunft* ]];
then
IFS=';' read -r _ konto iban adr_tp name strt pstcd twn _ <<< "$line"
echo "$lang;$iban;$adr_tp;$name;$strt;;$pstcd;$twn;$ctry" >> "$output_file"
elif [[ $line == Endkunde* ]];
then
IFS=';' read -r _ konto iban name strt pstcd twn <<< "$line"
echo "$lang;$iban;;$name;$strt;;$pstcd;$twn;$ctry" >> "$output_file"
fi
done < "$input_file"
}

input_files=("rechnung24018.data" "rechnung24019.data")

output_file="output.csv"

temp_file="temp_data.txt"

> "$temp_file"

for input_file in "${input_files[@]}" 
do cat "$input_file" >> "$temp_file" 
done

transform_data "$temp_file" "$output_file"

rm "$temp_file"

echo "Die Daten wurden erfolgreich in die Datei $output_file transformiert."
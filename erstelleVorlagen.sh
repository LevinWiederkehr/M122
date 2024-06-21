#!/bin/bash

mkdir -p _templates

touch _templates/datei-1.txt
touch _templates/datei-2.pdf
touch _templates/datei-3.doc

mkdir -p _schulklassen

schueler_namen=(
	"Wiederkehr"
	"Gholamsakhi"
	"Schaerer"
	"Braendli"
	"Fuchs"
	"Burren"
	"Alasaad"
	"Neuhaus"
	"Marzo"
	"Siciliano"
	"Steffanizi"
	"Mueller"
)

for klasse in "M122-AP23d.txt" "M122-AP23c" "M122-AP23b"
do
	for name in "${schueler_namen[@]}"
	do
		echo $name >> "_schulklassen/$klasse"
	done
done


echo "Templates und Schulkassen-Dateien wurden erfolgreich erstellt"
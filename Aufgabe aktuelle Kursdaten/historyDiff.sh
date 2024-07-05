#!/bin/bash

# Datei mit historischen Werten
history_file="depot_history.csv"

# Berechnung der Differenzen in %
awk -F, 'NR==1 {prev_value=$2; next} {diff=($2-prev_value)/prev_value*100; print $1, diff "%"; prev_value=$2}' $history_file

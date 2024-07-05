#!/bin/bash

# Funktion zum Abrufen des Aktienkurses von Yahoo Finance
get_stock_price() {
    ticker=$1
    price=$(curl -s "https://query1.finance.yahoo.com/v7/finance/quote?symbols=$ticker" | jq -r '.quoteResponse.result[0].regularMarketPrice')
    echo $price
}

# Funktion zum Abrufen des USD/CHF-Wechselkurses von exchangerate-api.com
get_usd_chf_rate() {
    rate=$(curl -s "https://open.er-api.com/v6/latest/USD" | jq -r '.rates.CHF')
    echo $rate
}

# Funktion zum Abrufen des Bitcoin-Preises von CoinGecko
get_bitcoin_price() {
    price=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" | jq -r '.bitcoin.usd')
    echo $price
}

# Depot laden
depot_file="depot.csv"
IFS=","
total_value=0

# Abruf der aktuellen Kursdaten und Berechnung des Depotwerts
while read -r asset type quantity purchase_price
do
    case $type in
        Stock)
            case $asset in
                Novartis)
                    ticker="NVS"
                    ;;
                Nestle)
                    ticker="NSRGY"
                    ;;
                ABB)
                    ticker="ABB"
                    ;;
                Swisscom)
                    ticker="SCMWY"
                    ;;
            esac
            current_price=$(get_stock_price $ticker)
            asset_value=$(echo "$quantity * $current_price" | bc)
            ;;
        Currency)
            if [ "$asset" == "USD" ]; then
                usd_chf_rate=$(get_usd_chf_rate)
                asset_value=$(echo "$quantity * $usd_chf_rate" | bc)
            fi
            ;;
        Crypto)
            if [ "$asset" == "Bitcoin" ]; then
                bitcoin_price=$(get_bitcoin_price)
                asset_value=$(echo "$quantity * $bitcoin_price" | bc)
            fi
            ;;
    esac
    total_value=$(echo "$total_value + $asset_value" | bc)
done < <(tail -n +2 $depot_file)

# Zeitstempel hinzufügen und Ergebnis speichern
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "$timestamp,$total_value" >> depot_history.csv

echo "Depotwert am $timestamp: CHF $total_value"

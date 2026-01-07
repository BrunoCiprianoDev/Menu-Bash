#!/bin/bash

# Diretório deste script
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# util fica dois níveis acima
UTIL_DIR="$(cd "$BASE_DIR/../../util" && pwd)"

source "$UTIL_DIR/spinner.sh"

list_all_networks() {
    clear
    echo "==== Available WiFi Networks ===="
    echo

       # Coleta redes com spinner
       load_networks_with_spinner

    if ! command -v nmcli &>/dev/null; then
        echo "NetworkManager (nmcli) not installed."
        echo
        read -rp "Press Enter to return..."
        return
    fi

    # Cores
    GREEN_BG="\e[42m"
    BLACK_FG="\e[30m"
    RESET="\e[0m"

    nmcli -f IN-USE,SSID,SECURITY,SIGNAL device wifi list | while read -r line; do
        if [[ "$line" == \** ]]; then
            # Rede conectada
            printf "%b%s%b\n" "${GREEN_BG}${BLACK_FG}" "$line" "${RESET}"
        else
            echo "$line"
        fi
    done

    echo
    read -rp "Press Enter to return..."
}

   load_networks_with_spinner() {
       local tmpfile
       tmpfile=$(mktemp)

       nmcli -t -f IN-USE,SSID,SECURITY device wifi list >"$tmpfile" 2>/dev/null &
       local pid=$!

       spinner "$pid"
       wait "$pid"

       mapfile -t networks < <(grep -v '^:' "$tmpfile")
       rm -f "$tmpfile"
   }

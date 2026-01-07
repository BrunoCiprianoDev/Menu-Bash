#!/bin/bash

# Diretório deste script
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# util fica dois níveis acima
UTIL_DIR="$(cd "$BASE_DIR/../../util" && pwd)"

source "$UTIL_DIR/spinner.sh"
source "$UTIL_DIR/read_password.sh"

network_manager() {
    clear
    #!/bin/bash

    # Diretório deste script
    BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # util fica dois níveis acima
    UTIL_DIR="$(cd "$BASE_DIR/../../util" && pwd)"

    source "$UTIL_DIR/spinner.sh"

    network_manager() {
        clear

        if ! command -v nmcli &>/dev/null; then
            echo "NetworkManager (nmcli) not installed."
            read -rp "Press Enter to return..."
            return
        fi

        # Cores
        GREEN_BG="\e[42m"
        BLACK_FG="\e[30m"
        RED_FG="\e[31m"
        RESET="\e[0m"

        # Coleta redes com spinner
        load_networks_with_spinner

        local selected=0
        local back_index=${#networks[@]}

        while true; do
            clear
            echo "==== Select WiFi Network ===="
            echo "Use ↑ ↓ and Enter"
            echo

            for i in "${!networks[@]}"; do
                IFS=':' read -r in_use ssid security <<< "${networks[$i]}"

                prefix="  "
                color_start=""
                color_end=""

                # Rede conectada
                if [[ "$in_use" == "*" ]]; then
                    prefix="* "
                    color_start="${RED_FG}"
                    color_end="${RESET}"
                fi

                label="${prefix}${ssid} [${security}]"

                if [[ $i -eq $selected ]]; then
                    printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "$label" "${RESET}"
                else
                    printf "   %b%s%b\n" "$color_start" "$label" "$color_end"
                fi
            done

            # ---- Opção Back ----
            if [[ $selected -eq $back_index ]]; then
                printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "← Back" "${RESET}"
            else
                echo "   ← Back"
            fi

            read -rsn1 key
            case "$key" in
                $'\e')
                    read -rsn2 key
                    case "$key" in
                        '[A') ((selected--));;
                        '[B') ((selected++));;
                    esac
                    ((selected < 0)) && selected=$back_index
                    ((selected > $back_index)) && selected=0
                    ;;
                "")
                    # Back selecionado
                    if [[ $selected -eq $back_index ]]; then
                        return
                    fi

                    IFS=':' read -r _ ssid security <<< "${networks[$selected]}"
                    connect_to_wifi "$ssid" "$security"
                    return
                    ;;
                q)
                    return
                    ;;
            esac
        done
    }

    connect_to_wifi() {
        local ssid="$1"
        local security="$2"

        clear
        echo "==== Connect to WiFi ===="
        echo
        echo "Network: $ssid"
        echo "Security: $security"
        echo

        if [[ "$security" == "--" || -z "$security" ]]; then
            nmcli device wifi connect "$ssid" &>/tmp/wifi_connect.log &
        else
            read -rsp "Password: " password
            echo
            nmcli device wifi connect "$ssid" password "$password" &>/tmp/wifi_connect.log &

        fi

        local nmcli_pid=$!
        spinner "$nmcli_pid"
        wait "$nmcli_pid"
        local status=$?

        echo
        if [[ $status -eq 0 ]]; then
            echo "Connected successfully!"
        else
            echo "Failed to connect."
            tail -n 3 /tmp/wifi_connect.log
        fi

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

    disconnect_wifi() {
        clear
        echo "==== Disable WiFi ===="
        echo

        nmcli radio wifi off &>/dev/null

        if [[ $? -eq 0 ]]; then
            echo "WiFi disabled successfully."
        else
            echo "Failed to disable WiFi."
        fi

        echo
        read -rp "Press Enter to return..."
    }

    if ! command -v nmcli &>/dev/null; then
        echo "NetworkManager (nmcli) not installed."
        read -rp "Press Enter to return..."
        return
    fi

    # Cores
    GREEN_BG="\e[42m"
    BLACK_FG="\e[30m"
    RED_FG="\e[31m"
    RESET="\e[0m"

    # Coleta redes com spinner
    load_networks_with_spinner

    local selected=0
    local back_index=${#networks[@]}

    while true; do
        clear
        echo "==== Select WiFi Network ===="
        echo "Use ↑ ↓ and Enter"
        echo

        for i in "${!networks[@]}"; do
            IFS=':' read -r in_use ssid security <<< "${networks[$i]}"

            prefix="  "
            color_start=""
            color_end=""

            # Rede conectada
            if [[ "$in_use" == "*" ]]; then
                prefix="* "
                color_start="${RED_FG}"
                color_end="${RESET}"
            fi

            label="${prefix}${ssid} [${security}]"

            if [[ $i -eq $selected ]]; then
                printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "$label" "${RESET}"
            else
                printf "   %b%s%b\n" "$color_start" "$label" "$color_end"
            fi
        done

        # ---- Opção Back ----
        if [[ $selected -eq $back_index ]]; then
            printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "← Back" "${RESET}"
        else
            echo "   ← Back"
        fi

        read -rsn1 key
        case "$key" in
            $'\e')
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--));;
                    '[B') ((selected++));;
                esac
                ((selected < 0)) && selected=$back_index
                ((selected > $back_index)) && selected=0
                ;;
            "")
                # Back selecionado
                if [[ $selected -eq $back_index ]]; then
                    return
                fi

                IFS=':' read -r _ ssid security <<< "${networks[$selected]}"
                connect_to_wifi "$ssid" "$security"
                return
                ;;
            q)
                return
                ;;
        esac
    done
}
connect_to_wifi() {
    local ssid="$1"
    local security="$2"

    clear
    echo "==== Connect to WiFi ===="
    echo
    echo "Network: $ssid"
    echo "Security: $security"
    echo

    if [[ "$security" == "--" || -z "$security" ]]; then
        nmcli device wifi connect "$ssid" &>/tmp/wifi_connect.log &
    else
        read -rsp "Password: " password
        echo
        nmcli device wifi connect "$ssid" password "$password" &>/tmp/wifi_connect.log &
    fi

    local nmcli_pid=$!
    spinner "$nmcli_pid"
    wait "$nmcli_pid"
    local status=$?

    echo
    if [[ $status -eq 0 ]]; then
        echo "Connected successfully!"
    else
        echo "Failed to connect."
        tail -n 3 /tmp/wifi_connect.log
    fi

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

disconnect_wifi() {
    clear
    echo "==== Disable WiFi ===="
    echo

    nmcli radio wifi off &>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "WiFi disabled successfully."
    else
        echo "Failed to disable WiFi."
    fi

    echo
    read -rp "Press Enter to return..."
}

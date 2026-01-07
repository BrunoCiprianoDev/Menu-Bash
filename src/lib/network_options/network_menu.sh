#!/bin/bash

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -z "$CHECK_NETWORK_LOADED" ]] && {
    source "$LIB_DIR/check_network.sh"
    CHECK_NETWORK_LOADED=1
}

[[ -z "$LIST_NETWORKS_LOADED" ]] && {
    source "$LIB_DIR/list_all_networks.sh"
    LIST_NETWORKS_LOADED=1
}

[[ -z "$CONNECT_NETWORK_LOADED" ]] && {
    source "$LIB_DIR/network_manager.sh"
    CONNECT_NETWORK_LOADED=1
}

[[ -z "$DISABLE_WIFI_LOADED" ]] && {
    source "$LIB_DIR/disable_wifi.sh"
    DISABLE_WIFI_LOADED=1
}

[[ -z "$ENABLE_WIFI_LOADED" ]] && {
    source "$LIB_DIR/enable_wifi.sh"
    ENABLE_WIFI_LOADED=1
}

network_menu() {
    local options=(
        "Enable Wifi"
        "Disable Wifi"
        "Check Network"
        "List all Networks"
        "Network Manager"
        "← Back"
    )

    local selected=0

    while true; do
        clear
        echo "==== WiFi Network Manager ===="
        echo

        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf " \e[42m\e[30m %s \e[0m\n" "${options[$i]}"
            else
                echo "   ${options[$i]}"
            fi
        done

        read -rsn1 key
        case "$key" in
            $'\e')
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--));;
                    '[B') ((selected++));;
                esac
                ((selected < 0)) && selected=$((${#options[@]} - 1))
                ((selected >= ${#options[@]})) && selected=0
                ;;
            "")
                case $selected in
                    0) enable_wifi ;;
                    1) disable_wifi ;;
                    2) check_network ;;
                    3) list_all_networks ;;
                    4) network_manager ;;
                    5) break ;;
                esac
                ;;
        esac
    done
}

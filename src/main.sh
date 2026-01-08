#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/lib/battery.sh"
source "$BASE_DIR/lib/system_monitor.sh"
source "$BASE_DIR/lib/app_launcher.sh"
source "$BASE_DIR/lib/datetime/datetime_menu.sh"
source "$BASE_DIR/lib/network_options/network_menu.sh"

options=(
    "App launcher"
    "System status"
    "Battery status"
    "Network manager"
    "Set Date & Time"
    "Exit"
)

GREEN_BG="\e[42m"
BLACK_FG="\e[30m"
RESET="\e[0m"

hide_cursor() { tput civis; }
show_cursor() { tput cnorm; }
trap show_cursor EXIT
hide_cursor

draw_main_menu() {
    clear
    echo "========= Bash System Menu ========="
    echo "     Time: $(date '+%d-%m-%Y %H:%M:%S')"
    echo

    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "${options[$i]}" "${RESET}"
        else
            echo "   ${options[$i]}"
        fi
    done
}

render_main_menu() {
    selected=0

    while true; do
        draw_main_menu

        read -rsn1 key
        case "$key" in
            $'\e')
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--)) ;;
                    '[B') ((selected++)) ;;
                esac
                ((selected < 0)) && selected=$((${#options[@]} - 1))
                ((selected >= ${#options[@]})) && selected=0
                ;;
            "")
                case $selected in
                    0) app_launcher ;;
                    1) system_monitor ;;
                    2) battery_status ;;
                    3) network_menu ;;
                    4) datetime_menu ;;
                    5) clear; exit ;;
                esac
                ;;
        esac
    done
}

# MAIN - FUNCTION
render_main_menu

#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/lib/battery.sh"
source "$BASE_DIR/lib/system_monitor.sh"
source "$BASE_DIR/lib/network_options/network_menu.sh"

options=(
    "Battery status"
    "System status"
    "Network manager"
    "Exit"
)

selected=0

GREEN_BG="\e[42m"
BLACK_FG="\e[30m"
RESET="\e[0m"

hide_cursor() { tput civis; }
show_cursor() { tput cnorm; }
trap show_cursor EXIT
hide_cursor

draw_menu() {
    clear
    echo "==== Bash System Menu ===="
    echo

    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "${options[$i]}" "${RESET}"
        else
            echo "   ${options[$i]}"
        fi
    done
}

while true; do
    draw_menu

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
                0) battery_status ;;
                1) system_monitor ;;
                2) network_menu ;;
                3) clear; exit ;;
            esac
            ;;
    esac
done

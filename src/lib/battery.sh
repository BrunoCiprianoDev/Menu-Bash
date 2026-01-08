#!/bin/bash
# autor: @BrunoCiprianoDEv
# Este script fornece menus interativos para "upower"
# É necessário ter instalado 'upower' com: sudo apt install upower"
# para que tudo funcione corretametne.
#

battery_status() {
    clear
    echo "========================"
    echo "       ⚡ Battery"
    echo "========================"
    echo

    if ! command -v upower &>/dev/null; then
        echo "Install 'upower' for health info: sudo apt install upower"
        echo
        for bat in /sys/class/power_supply/BAT*; do
            capacity=$(cat "$bat/capacity")
            status=$(cat "$bat/status")

            bar_length=20
            filled=$(( capacity * bar_length / 100 ))
            empty=$(( bar_length - filled ))

            if (( capacity > 50 )); then color="\e[32m"
            elif (( capacity > 20 )); then color="\e[33m"
            else color="\e[31m"
            fi

            bar=$(printf "%0.s█" $(seq 1 $filled))
            bar+=$(printf "%0.s░" $(seq 1 $empty))

            echo -e "$(basename "$bat") [$status]"
            echo -e "Level:  [${color}${bar}\e[0m] $capacity%"
            echo
        done
    else

        for dev in $(upower -e | grep battery); do
            info=$(upower -i "$dev")
            name=$(echo "$info" | grep "model" | awk -F: '{print $2}' | xargs)
            status=$(echo "$info" | grep "state" | awk -F: '{print $2}' | xargs)
            capacity=$(echo "$info" | grep "percentage" | awk -F: '{print $2}' | xargs | sed 's/%//')
            health=$(echo "$info" | grep "capacity" | awk -F: '{print $2}' | xargs)

            bar_length=20
            filled=$(( capacity * bar_length / 100 ))
            empty=$(( bar_length - filled ))

            if (( capacity > 50 )); then color="\e[32m"
            elif (( capacity > 20 )); then color="\e[33m"
            else color="\e[31m"
            fi

            bar=$(printf "%0.s█" $(seq 1 $filled))
            bar+=$(printf "%0.s░" $(seq 1 $empty))

            echo -e "$name [$status]"
            echo -e "Level:  [${color}${bar}\e[0m] $capacity%"
            echo -e "Health: $health%"
            echo
        done
    fi

    read -rp "Press Enter to return..."
}

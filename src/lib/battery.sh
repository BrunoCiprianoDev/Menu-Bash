#!/bin/bash

battery_status() {
    clear
    echo "========================"
    echo "      🔋 Battery"
    echo "========================"
    echo

    if command -v acpi >/dev/null 2>&1; then
        acpi
    else
        for bat in /sys/class/power_supply/BAT*; do
            cap=$(cat "$bat/capacity")
            stat=$(cat "$bat/status")
            echo "$(basename "$bat"): $cap% ($stat)"
        done
    fi

    echo
    read -p "Press Enter to return..."
}

#!/bin/bash
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -z "$SET_DATETIME_LOADED" ]] && {
    source "$LIB_DIR/set_datetime.sh"
    SET_DATETIME_LOADED=1
}

[[ -z "$SET_TIMEZONE_LOADED" ]] && {
    source "$LIB_DIR/set_timezone.sh"
    SET_TIMEZONE_LOADED=1
}

[[ -z "$TOGGLE_NTP_LOADED" ]] && {
    source "$LIB_DIR/toggle_ntp.sh"
    TOGGLE_NTP_LOADED=1
}

datetime_menu() {
    local options=(
        "toggle_ntp"
        "Set Date & Time"
        "Set Timezone"
        "← Back"
    )

    local selected=0

    while true; do
        clear
        echo "==== Date Time Config ===="
        echo "Time: $(date '+%d-%m-%Y %H:%M:%S')"
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
                    0) toggle_ntp ;;
                    1) set_datetime ;;
                    2) set_timezone ;;
                    3) break
                esac
                ;;
        esac
    done
}

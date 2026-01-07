toggle_ntp() {
    # Pega o status atual (true ou false)
    status=$(timedatectl show -p NTP --value)

    local options=("Enable NTP sync" "Disable NTP sync" "← Back")
    local selected=0

    GREEN_BG="\e[42m"
    BLACK_FG="\e[30m"
    RESET="\e[0m"

    draw_menu() {
        clear
        echo "==== Automatic Date/Time Sync (NTP) ===="
        echo "Current status: $status"
        echo
        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "${options[$i]}" "${RESET}"
            else
                echo "   ${options[$i]}"
            fi
        done
        echo
        echo "Use ↑/↓ to navigate, Enter to select"
    }

    while true; do
        draw_menu
        read -rsn3 key
        case "$key" in
            $'\e[A') ((selected--)) ;;  # seta para cima
            $'\e[B') ((selected++)) ;;  # seta para baixo
            "")
                case $selected in
                    0)
                        sudo timedatectl set-ntp true
                        status="true"
                        echo "NTP synchronization enabled."
                        read -rp "Press Enter to continue..."
                        ;;
                    1)
                        sudo timedatectl set-ntp false
                        status="false"
                        echo "NTP synchronization disabled."
                        read -rp "Press Enter to continue..."
                        ;;
                    2) break ;;  # Back
                esac
                ;;
        esac

        # Ajusta limites do índice
        ((selected < 0)) && selected=$((${#options[@]} - 1))
        ((selected >= ${#options[@]})) && selected=0
    done
}

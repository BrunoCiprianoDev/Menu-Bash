system_actions_menu() {
    local actions=(
        "Poweroff"
        "Reboot"
        "Logout"
        "← Back"
    )

    local selected=0

    while true; do
        clear
        echo "==== System Actions ===="
        echo

        for i in "${!actions[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "${actions[$i]}" "${RESET}"
            else
                echo "   ${actions[$i]}"
            fi
        done
        echo
        echo "Use setas ↑ ↓ para navegar, ENTER para selecionar, ESC para voltar"

        read -rsn1 key
        case "$key" in
            $'\e')  # setas
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--)) ;;  # cima
                    '[B') ((selected++)) ;;  # baixo
                esac
                ((selected < 0)) && selected=$((${#actions[@]} - 1))
                ((selected >= ${#actions[@]})) && selected=0
                ;;
            "")
                case "${actions[$selected]}" in
                    "Poweroff") clear; sudo poweroff; break ;;
                    "Reboot") clear; sudo reboot; break ;;
                    "Logout") clear; i3-msg exit || pkill -KILL -u "$USER"; break ;;
                    "← Back") break ;;
                esac
                ;;
        esac
    done
}

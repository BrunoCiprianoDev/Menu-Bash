#!/bin/bash

LAUNCHER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -z "$LAUNCHER_DIR_LOADED" ]] && {
    source "../$LIB_DIR/main.sh"
    LAUNCHER_DIR_LOADED=1
}

app_launcher() {
    # Lista todos os executáveis no PATH
    mapfile -t all_apps < <(compgen -c | sort -u)
    if [[ ${#all_apps[@]} -eq 0 ]]; then
        echo "No executables found in PATH."
        read -rp "Press Enter to return..."
        return
    fi

    GREEN_BG="\e[42m"
    BLACK_FG="\e[30m"
    RESET="\e[0m"

    local selected=0
    local max_display=11   # mostra até 10 apps
    local filter=""

    draw_menu() {
        clear
        echo "==== App Launcher ===="
        echo "Filter: $filter"
        echo "Use ↑/↓ to navigate, Enter to launch, Backspace to erase"
        echo

        # Filtra apps pelo filtro
        if [[ -n "$filter" ]]; then
            filtered_apps=()
            for app in "${all_apps[@]}"; do
                [[ $app == *"$filter"* ]] && filtered_apps+=("$app")
            done
        else
            filtered_apps=("${all_apps[@]}")
        fi

        # Mostra até max_display apps
        display_count=$(( ${#filtered_apps[@]} < max_display ? ${#filtered_apps[@]} : max_display ))

        for i in $(seq 0 $((display_count-1))); do
            if [[ $i -eq $selected ]]; then
                printf " %b %s %b\n" "${GREEN_BG}${BLACK_FG}" "${filtered_apps[$i]}" "${RESET}"
            else
                echo "   ${filtered_apps[$i]}"
            fi
        done

        # Sempre mostra Back após os apps renderizados
        back_index=$display_count
        if [[ $selected -eq $back_index ]]; then
            printf " %b ← Back %b\n" "${GREEN_BG}${BLACK_FG}" "${RESET}"
        else
            echo "   ← Back"
        fi
    }

    while true; do
        draw_menu
         # echo "DEBUG: selected index = $selected"
         # echo "DEBUG: selected back_index = $back_index"
        read -rsn1 key
        case "$key" in
            $'\e')  # setas
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--)) ;;  # cima
                    '[B') ((selected++)) ;;  # baixo
                esac
                ;;
            "")  # Enter
                back_index=$display_count
                if [[ $selected -eq $back_index ]]; then
                    render_main_menu
                fi
                app_to_run="${filtered_apps[$selected]}"
                clear
                echo "Launching: $app_to_run ..."
                $app_to_run &>/dev/null &
                disown
                read -rp "Press Enter to return..."
                ;;
            $'\x7f')  # Backspace
                if [[ -n "$filter" ]]; then
                    filter="${filter%?}"
                    selected=0
                fi
                ;;
            *)  # qualquer outro caractere adiciona ao filtro
                filter+="$key"
                selected=0
                ;;
        esac

        # Ajusta limites (incluindo Back)
        back_index=$display_count
        ((selected < 0)) && selected=$back_index
        ((selected > back_index)) && selected=0
    done
}

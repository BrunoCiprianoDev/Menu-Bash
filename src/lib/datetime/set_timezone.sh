set_timezone() {
    # Pega todos os fusos horários disponíveis
    timezones=($(timedatectl list-timezones))
    selected=0
    total=${#timezones[@]}

    while true; do
        clear
        echo "==== Select Timezone ===="
        echo "Use ↑/↓ to move, Enter to select, q to cancel"
        echo

        start=$((selected - selected % 10))
        end=$((start + 10))
        [[ $end -gt $total ]] && end=$total

        for i in $(seq $start $((end-1))); do
            if [[ $i -eq $selected ]]; then
                printf " > %s <\n" "${timezones[$i]}"
            else
                echo "   ${timezones[$i]}"
            fi
        done

        read -rsn3 key
        case "$key" in
            $'\e[A') ((selected--));;
            $'\e[B') ((selected++));;
            "")
                sudo timedatectl set-timezone "${timezones[$selected]}"
                echo "Timezone set to ${timezones[$selected]}"
                read -rp "Press Enter to return to menu..."
                break
                ;;
            q) break ;;
        esac

        ((selected < 0)) && selected=0
        ((selected >= total)) && selected=$((total-1))
    done
}

set_datetime() {
    # Inicializa valores com a hora atual
    current_date=$(date '+%Y-%m-%d')
    current_time=$(date '+%H:%M:%S')

    year=$(echo $current_date | cut -d- -f1)
    month=$(echo $current_date | cut -d- -f2)
    day=$(echo $current_date | cut -d- -f3)

    hour=$(echo $current_time | cut -d: -f1)
    minute=$(echo $current_time | cut -d: -f2)
    second=$(echo $current_time | cut -d: -f3)

    fields=("year" "month" "day" "hour" "minute" "second")
    selected=0

    while true; do
        clear
        echo "==== Set Date and Time ===="
        echo
        # Mostra os campos, destacando o selecionado
        for i in "${!fields[@]}"; do
            field=${fields[$i]}
            value=${!field}
            if [[ $i -eq $selected ]]; then
                # destacando campo selecionado
                printf " [%s] " "$value"
            else
                printf "  %s  " "$value"
            fi
        done
        echo
        echo
        echo "Use ↑/↓ to change, ←/→ to move, Enter to confirm, q to cancel"

        # Captura tecla
        read -rsn3 key
        case "$key" in
            $'\e[A')  # seta para cima
                case $selected in
                    0) ((year++)) ;;
                    1) ((month++)); [[ $month -gt 12 ]] && month=1 ;;
                    2) ((day++)); [[ $day -gt 31 ]] && day=1 ;;
                    3) ((hour++)); [[ $hour -gt 23 ]] && hour=0 ;;
                    4) ((minute++)); [[ $minute -gt 59 ]] && minute=0 ;;
                    5) ((second++)); [[ $second -gt 59 ]] && second=0 ;;
                esac
                ;;
            $'\e[B')  # seta para baixo
                case $selected in
                    0) ((year--)) ;;
                    1) ((month--)); [[ $month -lt 1 ]] && month=12 ;;
                    2) ((day--)); [[ $day -lt 1 ]] && day=31 ;;
                    3) ((hour--)); [[ $hour -lt 0 ]] && hour=23 ;;
                    4) ((minute--)); [[ $minute -lt 0 ]] && minute=59 ;;
                    5) ((second--)); [[ $second -lt 0 ]] && second=59 ;;
                esac
                ;;
            $'\e[C')  # seta direita
                ((selected++))
                ((selected>5)) && selected=0
                ;;
            $'\e[D')  # seta esquerda
                ((selected--))
                ((selected<0)) && selected=5
                ;;
            "")  # Enter confirma
                sudo timedatectl set-time "$year-$month-$day $hour:$minute:$second"
                echo "Date and time updated!"
                read -rp "Press Enter to return to menu..."
                break
                ;;
            q)  # cancela
                break
                ;;
        esac
    done
}

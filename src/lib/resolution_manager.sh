#!/bin/bash
# screen_menu.sh
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ============================================
# autor: @BrunoCiprianoDEv
# Este script fornece menus interativos para:
#   - Selecionar saídas de vídeo conectadas
#   - Alterar a resolução de cada saída
# usando o utilitário 'xrandr'.
#
# Observações importantes:
#   - Funciona em qualquer ambiente gráfico baseado em X11
#     (i3, XFCE, LXDE, GNOME X11, KDE Plasma X11, etc.).
#   - Não funciona em Wayland (ex.: GNOME moderno no Wayland, Sway),
#     porque Wayland não usa Xorg/X11.
#   - Necessita que o comando `xrandr` esteja instalado.
# ============================================
screen_menu() {
    # Detectar todas as saídas conectadas
    local outputs=($(xrandr --query | grep " connected" | awk '{print $1}'))
    # Adicionar opção de voltar
    outputs+=("← Back")

    local selected_output=0

    while true; do
        clear
        echo "==== Screen Resolution Manager ===="
        echo

        for i in "${!outputs[@]}"; do
            if [[ $i -eq $selected_output ]]; then
                printf " \e[44m\e[37m %s \e[0m\n" "${outputs[$i]}"
            else
                echo "   ${outputs[$i]}"
            fi
        done
        echo
        echo "Press ENTER to select output, ESC to go back"

        read -rsn1 key
        case "$key" in
            $'\e')
                read -rsn2 key
                case "$key" in
                    '[A') ((selected_output--));;
                    '[B') ((selected_output++));;
                esac
                ((selected_output < 0)) && selected_output=$((${#outputs[@]} - 1))
                ((selected_output >= ${#outputs[@]})) && selected_output=0
                ;;
            "")
                # Se selecionou "← Back", sair do menu principal
                if [[ "${outputs[$selected_output]}" == "← Back" ]]; then
                    break
                fi
                # Selecionou saída, abrir menu de resoluções
                resolution_menu "${outputs[$selected_output]}"
                ;;
        esac
    done
}

resolution_menu() {
    local output="$1"

    # Pegar todas as resoluções suportadas para a saída
    local resolutions=($(xrandr --query | awk -v out="$output" '
        $1 == out {flag=1; next}
        /^[^ ]/ {flag=0}
        flag {gsub(/[+*]/,""); print $1}'))

    # Adicionar opção de voltar
    resolutions+=("← Back")

    local selected=0

    while true; do
        clear
        echo "==== Resolutions for $output ===="
        echo

        for i in "${!resolutions[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf " \e[42m\e[30m %s \e[0m\n" "${resolutions[$i]}"
            else
                echo "   ${resolutions[$i]}"
            fi
        done
        echo
        echo "Press ENTER to apply resolution, ESC to go back"

        read -rsn1 key
        case "$key" in
            $'\e')
                read -rsn2 key
                case "$key" in
                    '[A') ((selected--));;
                    '[B') ((selected++));;
                esac
                ((selected < 0)) && selected=$((${#resolutions[@]} - 1))
                ((selected >= ${#resolutions[@]})) && selected=0
                ;;
            "")
                # Se selecionou "← Back", sair do menu
                if [[ "${resolutions[$selected]}" == "← Back" ]]; then
                    break
                fi
                # Aplicar resolução selecionada
                xrandr --output "$output" --mode "${resolutions[$selected]}"
                ;;
        esac
    done
}

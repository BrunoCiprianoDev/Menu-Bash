#!/bin/bash

GREEN_BG="\e[42m"
BLACK_FG="\e[30m"
RESET="\e[0m"

hide_cursor() { tput civis; }
show_cursor() { tput cnorm; }
trap show_cursor EXIT

tui_init() {
    clear
    hide_cursor
}

tui_move() {
    tput cup "$1" "$2"
}

tui_clear_lines() {
    local start=$1
    local count=$2
    for ((i=0; i<count; i++)); do
        tui_move $((start + i)) 0
        tput el
    done
}

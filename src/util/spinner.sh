spinner() {
    local pid=$1
    local delay=0.1
    local spin='|/-\'
    local i=0

    tput civis
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\rConnecting... %c" "${spin:$i:1}"
        sleep "$delay"
    done
    tput cnorm
    printf "\r"
}

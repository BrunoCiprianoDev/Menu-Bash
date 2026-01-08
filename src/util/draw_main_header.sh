#
# Autor: @BrunoCiprianoDev
# Este trecho de código serve para renderizar, em forma de barras,
# o uso de VRAM, GPU e CPU. Resumindo, um monte de funcionalidades
# inúteis (porque basta chamar o htop); mas como fiquei quebrando
# a cabeça nisso por horas, NÃO VOU APAGAR.
#
#
cpu_status() {
    local cpu_idle cpu_usage

    cpu_idle=$(top -bn1 | awk '/Cpu\(s\)/ {print $8}' | cut -d. -f1)
    cpu_usage=$(( 100 - cpu_idle ))

    draw_bar "CPU" "$cpu_usage"
}

draw_bar() {
    local label="$1"
    local percent="$2"

    local bar_length=20
    local filled=$(( percent * bar_length / 100 ))
    local empty=$(( bar_length - filled ))

    if (( percent > 50 )); then color="\e[32m"
    elif (( percent > 20 )); then color="\e[33m"
    else color="\e[31m"
    fi

    local bar
    bar=$(printf "%0.s█" $(seq 1 $filled))
    bar+=$(printf "%0.s░" $(seq 1 $empty))

    printf "%-8s [${color}%s\e[0m] %3d%%\n" "$label" "$bar" "$percent"
}

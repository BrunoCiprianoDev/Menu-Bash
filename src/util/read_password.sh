read_password() {
    local password=""
    local char

    while IFS= read -rsn1 char; do
        # Se Enter, sai do loop
        if [[ "$char" == $'\n' || "$char" == $'\r' ]]; then
            break
        fi

        # Se Backspace
        if [[ "$char" == $'\177' ]]; then
            if [[ -n $password ]]; then
                password="${password%?}"
                printf "\b \b"
            fi
            continue
        fi

        # Qualquer outro caractere → adiciona e imprime *
        password+="$char"
        printf "*"
    done

    echo
    REPLY="$password"
}

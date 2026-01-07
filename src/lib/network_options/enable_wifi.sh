enable_wifi() {
    clear
    echo "==== Enable WiFi ===="
    echo

    nmcli radio wifi on &>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "WiFi enabled."
    else
        echo "Failed to enable WiFi."
    fi

    read -rp "Press Enter to return..."
}

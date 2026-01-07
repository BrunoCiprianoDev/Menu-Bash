disable_wifi() {
    clear
    echo "==== Disable WiFi ===="
    echo

    nmcli radio wifi off &>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "WiFi disabled successfully."
    else
        echo "Failed to disable WiFi."
    fi

    echo
    read -rp "Press Enter to return..."
}

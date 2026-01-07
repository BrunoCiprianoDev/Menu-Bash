check_network() {
    clear
    echo "==== Network Status ===="
    echo

    if ! command -v nmcli &>/dev/null; then
        echo "NetworkManager (nmcli) not installed."
        echo
        read -rp "Press Enter to return..."
        return
    fi

    local status
    status=$(nmcli -t -f DEVICE,TYPE,STATE device | grep -E 'wifi|ethernet')

    if [[ -z "$status" ]]; then
        echo "No network devices found."
    else
        echo "Device      Type       State"
        echo "-----------------------------"
        echo "$status" | while IFS=':' read -r dev type state; do
            printf "%-11s %-10s %s\n" "$dev" "$type" "$state"
        done
    fi

    echo
    read -rp "Press Enter to return..."
}

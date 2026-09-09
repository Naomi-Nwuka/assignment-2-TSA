#!/bin/bash

show_help() {
    echo "Diagnostic Tool"
    echo
    echo "Usage:"
    echo "  diagnostic system"
    echo "  diagnostic network <host>"
    echo "  diagnostic disk"
    echo "  diagnostic help"
}

show_system() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "Current User: $(whoami)"
    echo "Date and Time: $(date)"
    echo "Operating System:"
    cat /etc/os-release | grep '^PRETTY_NAME=' | cut -d= -f2- | tr -d '"'
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo
    echo "CPU:"
    lscpu | grep -E '^(Model name|CPU\(s\):)' | head -2
    echo
    echo "Memory:"
    free -h
    echo
    echo "Current Directory: $(pwd)"
}

show_network() {
    local host="$1"

    if [[ -z "$host" ]]; then
        echo "Error: hostname or IP address is required."
        return 2
    fi

    echo "=== Network Diagnostic ==="
    echo "Host: $host"

    echo
    echo "Resolved Address:"
    if ! getent hosts "$host"; then
        echo "Error: could not resoelve host."
        return 1
    fi

    echo
    echo "Connectivity:"
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        echo "Host is reachable."
    else
        echo "Host is not reachable."
        return 1
    fi

    echo
    echo "Network Interfaces:"
    ip addr
}

show_disk() {
    echo "=== Disk Information ==="
    df -h
}


# If no command-line argument was provided,
# start interactive mode.

if [[ $# -eq 0 ]]; then

echo " ===== Options ===== "
echo " system              "
echo " network <host>      "
echo " disk                "
echo " help                "
echo " =================== "


read -p "Enter valid option:" option host

case "$option" in
    system)
        show_system
        ;;
    network)
        show_network "$host"
        ;;
    disk)
        show_disk
        ;;
    help)
        show_help
        ;;
    *)
        echo "Error: invalid command: $option"
        echo
        show_help
        exit 2
        ;;

 esac

else

    # Command-line mode
    case "$1" in
        system)
            show_system
            ;;
        network)
            show_network "$2"
            exit $?
            ;;
        disk)
            show_disk
            ;;
        help)
            show_help
            ;;
        *)
            echo "Error: invalid command: $1"
            echo
            show_help
            exit 2
            ;;
    esac

fi



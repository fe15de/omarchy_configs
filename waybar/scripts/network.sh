#!/bin/bash
# Open Terminal and connect to network in a faster way
$TERMINAL -e bash -c '
    dev=$(iwctl device list | awk "/station/ {print \$2; exit}")
    if [ -z "$dev" ]; then
        echo "No Wi-Fi adapter found."
        sleep 3
        exit 1
    fi

    echo "Wi-Fi interface: $dev"
    echo
    echo "1) Connect to a network"
    echo "2) Disconnect from current network"
    echo
    read -p "Choose an option (1/2): " choice
    echo

    case "$choice" in
        1)
            echo "Scanning networks..."
            iwctl station "$dev" scan 
            sleep 1
            clear
            echo "Available networks:"
            iwctl station "$dev" get-networks
            echo
            read -p "Enter network name: " network
            if [ -z "$network" ]; then
                echo "No network entered."
                sleep 2
                exit 1
            fi
            read -s -p "Enter password: " password
            echo
            echo "Connecting to $network..."
            if [ -z "$password" ]; then
                iwctl --passphrase "" station "$dev" connect "$network"
            else
                iwctl --passphrase "$password" station "$dev" connect "$network"
            fi
            echo
            iwctl station "$dev" show
            ;;
        2)
            echo "Disconnecting from current network..."
            iwctl station "$dev" disconnect
            echo
            iwctl station "$dev" show
            ;;
        *)
            echo "Invalid option."
            sleep 2
            ;;
    esac
    
    exit 1
'

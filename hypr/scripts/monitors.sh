#!/bin/bash

handle_monitors() {
    if hyprctl monitors | grep -q "HDMI-A-1"; then
        # HDMI connected
        hyprctl keyword monitor "HDMI-A-1,preferred,auto,1"
        hyprctl keyword monitor "eDP-1,disable"
    else
         
        hyprctl keyword monitor "eDP-1,preferred,auto,1"
    fi
}


handle_monitors


socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | \
while read -r line; do
    if echo "$line" | grep -E "monitoradded|monitorremoved"; then
        handle_monitors
    fi
done

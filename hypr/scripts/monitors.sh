#!/bin/bash

move_workspaces() {
    local from="$1" to="$2"
    hyprctl workspaces -j | jq -r --arg mon "$from" '.[] | select(.monitor == $mon) | .id' | while read -r ws; do
        hyprctl dispatch moveworkspacetomonitor "$ws $to"
    done
}

handle_monitors() {
    if hyprctl monitors all | grep -q "HDMI-A-1"; then
        if hyprctl monitors | grep -q "eDP-1"; then
            # Laptop activa → cambiar a solo monitor externo
            hyprctl eval "hl.monitor({ output = 'HDMI-A-1', disabled = false, mode = 'preferred', position = 'auto', scale = 1 })"
            move_workspaces "eDP-1" "HDMI-A-1"
            hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = true })"
        else
            # Monitor externo activo → cambiar a solo laptop
            hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = false, mode = 'preferred', position = 'auto', scale = 1 })"
            move_workspaces "HDMI-A-1" "eDP-1"
            hyprctl eval "hl.monitor({ output = 'HDMI-A-1', disabled = true })"
        fi
    else
        # HDMI desconectado físicamente → forzar laptop
        move_workspaces "HDMI-A-1" "eDP-1"
        hyprctl eval "hl.monitor({ output = 'eDP-1', disabled = false, mode = 'preferred', position = 'auto', scale = 1 })"
    fi
}
handle_monitors

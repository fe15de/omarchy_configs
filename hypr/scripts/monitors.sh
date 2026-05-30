#!/bin/bash

handle_monitors() {
    if hyprctl monitors all | grep -q "HDMI-A-1"; then
        if hyprctl monitors | grep -q "eDP-1"; then
            # Laptop activa → cambiar a solo monitor externo
            hyprctl keyword monitor "HDMI-A-1,preferred,auto,1"
            hyprctl keyword monitor "eDP-1,disable"
        else
            # Monitor externo activo → cambiar a solo laptop
            hyprctl keyword monitor "eDP-1,preferred,auto,1"
            hyprctl keyword monitor "HDMI-A-1,disable"
        fi
    else
        # HDMI desconectado físicamente → forzar laptop
        hyprctl keyword monitor "eDP-1,preferred,auto,1"
    fi
}

handle_monitors

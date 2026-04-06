while true; do
    status=$(playerctl status 2>/dev/null)

    if [[ "$status" == "Playing" ]]; then
        hyprctl dispatch inhibit_idle on
    else
        hyprctl dispatch inhibit_idle off
    fi

    sleep 5
done

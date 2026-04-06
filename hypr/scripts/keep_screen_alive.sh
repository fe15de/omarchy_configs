while true; do
    win=$(hyprctl activewindow)

    if echo "$win" | grep -E "firefox|chrome|brave" >/dev/null && \
       echo "$win" | grep "fullscreen" >/dev/null; then
        hyprctl dispatch inhibit_idle on
    else
        hyprctl dispatch inhibit_idle off
    fi

    sleep 5
done

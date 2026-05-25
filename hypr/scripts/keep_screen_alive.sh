INHIBIT_PID=""

inhibit_idle() {
    if [ -z "$INHIBIT_PID" ]; then
        systemd-inhibit --what=idle --who="video-watch" --why="Browser is active" sleep infinity &
        INHIBIT_PID=$!
        echo "[+] Idle inhibited (PID: $INHIBIT_PID)"
    fi
}

release_idle() {
    if [ -n "$INHIBIT_PID" ]; then
        kill "$INHIBIT_PID" 2>/dev/null
        INHIBIT_PID=""
        echo "[-] Idle released"
    fi
}

trap release_idle EXIT INT TERM

echo "[*] Watching for Firefox/Brave..."

while true; do
    sleep 3

    win=$(hyprctl activewindow -j 2>/dev/null)

    is_browser=$(echo "$win" | grep -Ei '"class": "(firefox|brave-browser|brave)"')

    if [ -n "$is_browser" ]; then
        inhibit_idle
    else
        release_idle
    fi
done

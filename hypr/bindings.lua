-- Application bindings
o.bind("SUPER + ALT + RETURN", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new')

-- o.bind("SUPER + RETURN", "Terminal", 'uwsm app -- $TERMINAL --dir="$(omarchy-cmd-terminal-cwd)"')
-- o.bind("SUPER + SHIFT + F", "File manager", "uwsm app -- nautilus --new-window")
o.bind("SUPER + B", "Browser", "omarchy-launch-browser")
o.bind("SUPER + SHIFT + B", "Browser (private)", "omarchy-launch-browser --private")
o.bind("SUPER + S", "Music", "omarchy-launch-or-focus spotify")
o.bind("SUPER + C", "Editor", "code")
o.bind("SUPER + SHIFT + T", "Activity", "omarchy-launch-tui btop")
o.bind("SUPER + D", "Docker", "omarchy-launch-tui lazydocker")
o.bind("SUPER + SHIFT + M", "WhatsApp", 'omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"')
o.bind("SUPER + SHIFT + N", "Obsidian", 'omarchy-launch-or-focus obsidian "uwsm-app -- obsidian"')
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "HDMI connected", "bash ~/.config/hypr/scripts/monitors.sh")
o.bind("SUPER + SHIFT + SLASH", "Passwords", "uwsm app -- 1password")

o.bind("SUPER + SHIFT + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))

o.bind("SUPER + SHIFT + ALT + C", "Calendar", 'omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"')

-- o.bind("SUPER + SHIFT + Y", "YouTube", 'omarchy-launch-or-focus-webapp YouTube "https://youtube.com/"')

-- Switch to workspace
o.bind("CTRL + 1", "Switch to workspace 1", hl.dsp.focus({ workspace = "1" }))
o.bind("CTRL + 2", "Switch to workspace 2", hl.dsp.focus({ workspace = "2" }))
o.bind("CTRL + 3", "Switch to workspace 3", hl.dsp.focus({ workspace = "3" }))
o.bind("CTRL + 4", "Switch to workspace 4", hl.dsp.focus({ workspace = "4" }))
o.bind("CTRL + 5", "Switch to workspace 5", hl.dsp.focus({ workspace = "5" }))

o.bind("ALT + SHIFT + 1", "Switch to workspace 6", hl.dsp.focus({ workspace = "6" }))
o.bind("ALT + SHIFT + 2", "Switch to workspace 7", hl.dsp.focus({ workspace = "7" }))
o.bind("ALT + SHIFT + 3", "Switch to workspace 8", hl.dsp.focus({ workspace = "8" }))
o.bind("ALT + SHIFT + 4", "Switch to workspace 9", hl.dsp.focus({ workspace = "9" }))
o.bind("ALT + SHIFT + 5", "Switch to workspace 10", hl.dsp.focus({ workspace = "10" }))

-- Move window to workspace
o.bind("ALT + 1", "Move window to workspace 1", hl.dsp.window.move({ workspace = "1" }))
o.bind("ALT + 2", "Move window to workspace 2", hl.dsp.window.move({ workspace = "2" }))
o.bind("ALT + 3", "Move window to workspace 3", hl.dsp.window.move({ workspace = "3" }))
o.bind("ALT + 4", "Move window to workspace 4", hl.dsp.window.move({ workspace = "4" }))
o.bind("ALT + 5", "Move window to workspace 5", hl.dsp.window.move({ workspace = "5" }))
o.bind("ALT + 6", "Move window to workspace 6", hl.dsp.window.move({ workspace = "6" }))
o.bind("ALT + 7", "Move window to workspace 7", hl.dsp.window.move({ workspace = "7" }))
o.bind("ALT + 8", "Move window to workspace 8", hl.dsp.window.move({ workspace = "8" }))
o.bind("ALT + 9", "Move window to workspace 9", hl.dsp.window.move({ workspace = "9" }))
o.bind("ALT + 0", "Move window to workspace 10", hl.dsp.window.move({ workspace = "10" }))

-- Layout
o.bind("SUPER + SHIFT + J", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Menu
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Omarchy menu", 'omarchy-shell shell toggle fede.menu \'{"menu":"root"}\'')
-- Screenshot
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Screenshot of region", "omarchy-capture-screenshot")

-- Color picker
o.bind("ALT + C", "Color picker", "pkill hyprpicker || hyprpicker -a")

-- OCR
o.bind("CTRL + SHIFT + S", "Extract text (OCR) from screenshot", "omarchy-capture-text-extraction")

-- Screen recordings
o.bind("ALT + PRINT", "Screen record a region", "omarchy-cmd-screenrecord region")

o.bind("ALT + SHIFT + PRINT", "Screen record a region with audio", "omarchy-cmd-screenrecord region audio")

o.bind("CTRL + ALT + PRINT", "Screen record display", "omarchy-cmd-screenrecord output")

o.bind("CTRL + ALT + SHIFT + PRINT", "Screen record display with audio", "omarchy-cmd-screenrecord output audio")

-- Laptop keys
o.bind("SUPER + F5", "Increase brightness", "brightnessctl s 5%+")

o.bind("SUPER + SHIFT + F4", "Decrease brightness", "brightnessctl s 5%-")

o.bind("SUPER + SHIFT + F3", "Increase volume", "pactl set-sink-volume @DEFAULT_SINK@ +5%")

o.bind("SUPER + SHIFT + F2", "Decrease volume", "pactl set-sink-volume @DEFAULT_SINK@ -5%")

o.bind("F1", "Toggle mute", "pactl set-sink-mute @DEFAULT_SINK@ toggle")

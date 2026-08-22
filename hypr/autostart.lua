-- Extra autostart processes.
-- o.launch_on_start("my-service")
hl.on("hyprland.start", function()
	hl.exec_cmd("~/.config/hypr/scripts/monitors.sh")
	hl.exec_cmd("exec-start firefox")
	hl.exec_cmd("~/.config/hypr/scripts/keep_screen_alive.sh")
	hl.exec_cmd("~/.config/hypr/scripts/toggle.sh")
end)

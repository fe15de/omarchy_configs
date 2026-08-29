-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
-- hl.config({
-- 	windowrulev2 = {
-- 		"idleinhibit focus, class:^(firefox)$",
-- 		"idleinhibit focus, class:^(brave-browser)$",
-- 		"idleinhibit focus, class:^(brave)$",
-- 		"idleinhibit focus, class:^(mpv)$",
-- 	},
-- })
-- Removes fullscreen animation/blackscreen
hl.window_rule({ match = { class = "^(mpv)$" }, content = "none" })
hl.window_rule({ match = { title = ".*mpv.*" }, content = "none" })

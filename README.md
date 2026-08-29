# configs

Personal dotfiles for an [Omarchy](https://omarchy.org/) machine (Arch Linux +
Hyprland). Upstream: `git@github.com:fe15de/omarchy_configs.git`.

These are **plain copies** of files that live under `~/.config`, `~`, and
`~/.local/share/fonts`. There is no symlink farm, `stow`, or install script —
changes are copied between the live location and this repo by hand (or with the
`rsync` snippets [below](#applying--updating)), then committed.

## Layout

| Path in repo | Installs to | What it is |
|---|---|---|
| `.bashrc` | `~/.bashrc` | Sources Omarchy's bash rc, then personal exports/aliases (`p`, `t`/`ta`, `configs`, `coding`, `ripv6`/`aipv6`, node/pnpm/bun/cargo setup). |
| `hypr/` | `~/.config/hypr/` | Hyprland config in Omarchy's Lua layer. Personal overrides load *after* the Omarchy defaults. |
| `omarchy/` | `~/.config/omarchy/` | Omarchy shell (bar, menu, idle, lock) customisations and custom plugins. |
| `ghostty/` | `~/.config/ghostty/` | Ghostty terminal — JetBrainsMono Nerd Font, theme pulled from the current Omarchy theme. |
| `mpv/` | `~/.config/mpv/` | mpv `mpv.conf` + `input.conf`. |
| `nvim/` | `~/.config/nvim/` | Neovim, [LazyVim](https://github.com/LazyVim/LazyVim) starter with personal plugins/keymaps. |
| `fonts/` | `~/.local/share/fonts/` | Bundled typefaces: SF Pro Display, Helvetica, Futura, Steelfish, `omarchy.ttf`. Run `fc-cache -f` after copying. |
| `Lazy vim shortcuts.md` | — | Personal cheat-sheet, not deployed. |

### `hypr/`

- `hyprland.lua` — entry point; runs Omarchy's bootstrap, loads Omarchy defaults,
  then `require`s the files below. Also a couple of `mpv` window rules.
- `bindings.lua` — personal keybinds (`o.bind` / `hl.unbind`). Includes
  `SUPER + ALT + P` → the Project / display-mode menu, and
  `SUPER + SHIFT + P` → `scripts/monitors.sh`.
- `monitors.lua` — display setup. Currently the generic Omarchy catch-all plus
  the `omarchy_monitor_scale` / `omarchy_gdk_scale` knobs.
- `input.lua`, `looknfeel.lua`, `autostart.lua` — input, gaps/borders/animations,
  startup execs.
- `hyprlock.conf` — hyprlock settings. The active lock screen is now the
  `fede.lock` Quickshell plugin (see [`omarchy/`](#omarchy)), which still pulls
  its wallpaper from `imgs/`.
- `imgs/` — wallpapers and lock-screen images.
- `scripts/`
  - `projection-menu.sh` — applies a display mode (see [Project menu](#project--winp-display-switcher)).
  - `monitors.sh` — older toggle between "external only" and "laptop only".
  - `keep_screen_alive.sh`, `toggle.sh` — idle-inhibit helpers.

### `omarchy/`

- `shell.json` — bar layout (widgets per section), `centerAnchor`, idle lock
  timeout, enabled/disabled plugins.
- `shell.toml` — shell settings.
- `extensions/`
  - `omarchy-menu.jsonc` — extends the Omarchy menu. Adds the **Project**
    submenu (Extend / Duplicate / External only / Laptop only, with layout
    sub-options under Extend).
  - `menu.sh` — legacy bash-menu overrides (mostly unused now).
- `plugins/` — custom shell plugins, all **clones of stock Omarchy plugins**
  (prefix `fede.`) so they survive `omarchy update`. Each plugin dir has a
  `preview.png`:
  - `fede.clock` — Google Calendar in the bar. Ships its own `sync/` (a
    `gws`-based poller + `systemd` user timer); see [Calendar sync](#calendar-sync).
  - `fede.monitor` — clone of `omarchy.monitor` (the Display panel). Patched so
    disabling the laptop panel writes Omarchy's persistent
    `internal-monitor-disable` flag instead of a runtime-only `hyprctl` call,
    so it stays off across reloads and the clamshell reconciler.
  - `fede.lock` — clone of `omarchy.lock`, with `LockView.qml` fully
    redesigned. One left-aligned column: an oversized SF Pro Display clock, an
    accent hairline, the date in tracked uppercase, then a borderless password
    field that is just an underline (accent on focus, red + shake on a failed
    attempt, a pulse while checking). The wallpaper
    (`~/.config/hypr/imgs/wallpaper.jpg`) is kept but graded down under neutral
    scrims. Every dimension is a fraction of the surface, so the layout holds
    at any resolution; the PAM / fingerprint plumbing and the `Service.qml`
    contract are untouched.
  - `fede.audio`, `fede.menu`, `fede.workspaces` — styling / behaviour tweaks
    over their stock counterparts.
- `bar/ram_usage.bash` — command widget shown in the bar.
- `branding/` — `about.txt`, `screensaver.txt`.
- `backgrounds/`, `themed/`, `themes/` — theme assets. `themes/*` are **symlinks**
  (checked in as symlinks); they point at theme dirs outside the repo and will be
  broken on a fresh clone until the referenced themes exist.
- `hooks/` — Omarchy event hooks. Most are `.sample` (inactive);
  `post-update.d/setup-agent.hook` is live.
- `calendar-sync.json` — resolved paths written by the calendar-sync setup.
- `defaults/agent` — default AI agent for Omarchy (`claude`).

## Project / Win+P display switcher

A "second screen" chooser in the style of Windows' **Win+P**, rendered as a
native Omarchy menu.

- **Open:** `SUPER + ALT + P` (or `SUPER + SPACE` → search "project").
- **Menu definition:** the `projection*` entries in
  `omarchy/extensions/omarchy-menu.jsonc`.
- **Logic:** `hypr/scripts/projection-menu.sh <mode>`.

| Mode | Effect | Persisted via |
|---|---|---|
| Extend → Automatic / right / left / above / below | Both screens, with a chosen arrangement | `~/.local/state/omarchy/toggles/hypr/projection-layout.lua` (generated; reads the live shared scale so it never goes stale) |
| Duplicate | External mirrors the laptop | `internal-monitor-mirror.lua` (stock helper) |
| External screen only | Laptop panel off | `internal-monitor-disable.lua` (stock helper) |
| Laptop screen only | External(s) off | `projection-external-disable.lua` (generated) |

Every `*.lua` in `~/.local/state/omarchy/toggles/hypr/` is re-sourced by Hyprland
on each reload, which is what makes the choices stick.

## Calendar sync

`fede.clock` shows your next event in the bar. One-time setup:

1. Install the CLIs: `gws` (Google Workspace CLI) and `gcloud`
   (`google-cloud-cli` from the AUR).
2. Run `~/.config/omarchy/plugins/fede.clock/sync/setup` in a terminal. It
   creates a GCP project, enables the Calendar API, walks the four manual
   Console steps (consent screen, scope, publish, Desktop OAuth client), does the
   read-only login, and installs the `omarchy-calendar-sync` systemd user timer.
3. Events land in `~/.local/state/omarchy/calendar-events.json` every 5 minutes.
   Logs: `journalctl --user -u omarchy-calendar-sync -f`.

## Machine assumptions

Some files hardcode this laptop's outputs:

- Internal: `eDP-1` (1920×1200)
- External: `HDMI-A-1` (1920×1080)

`hypr/scripts/monitors.sh` names them directly; `projection-menu.sh` discovers
them (internal = `eDP|LVDS|DSI` prefix, external = anything else) so it is more
portable.

## Applying / updating

There is no automation — sync the trees you care about, then commit. From the
repo root:

```bash
# repo  ->  live (apply)
rsync -a hypr/      ~/.config/hypr/
rsync -a omarchy/   ~/.config/omarchy/
rsync -a ghostty/   ~/.config/ghostty/
rsync -a mpv/       ~/.config/mpv/
rsync -a nvim/      ~/.config/nvim/
rsync -a fonts/     ~/.local/share/fonts/ && fc-cache -f
cp .bashrc ~/.bashrc

# live  ->  repo (capture changes before committing)
rsync -a --delete ~/.config/hypr/    hypr/
rsync -a --delete ~/.config/omarchy/ omarchy/
cp ~/.bashrc .bashrc
```

After applying Hyprland changes: `hyprctl reload` then `hyprctl configerrors`.
After shell/menu changes: `omarchy restart shell` (or just save — `shell.json`,
the menu JSONC, and plugin code under `~/.config/omarchy/plugins/` hot-reload).

> Review `rsync --delete` output before running it against the live tree — it
> removes files that aren't in the repo.

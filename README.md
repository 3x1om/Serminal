# Serminal

Serminal is a terminal toolkit for Open Serialis with:

- Interactive terminal mode with custom prompt/shell settings
- Tabbed PTY terminal GUI (`serminal gui`) powered by GTK4 + VTE
- GUI-first startup command (`serminal start`, same as `serminal gui`)
- `.sh` and `.tssh` script execution
- Library imports in `.tssh` scripts (`@import <library_name>`)
- Local script library management
- Start menu and MIME integration for distro preinstall paths

## Quick start

```bash
chmod +x ./serminal
./serminal start
./serminal gui
```

## One-command install (deps + Serminal)

Clone + install in one command (Open Serialis and other distros supported by `scripts/install-system.sh` package-manager detection: `pacman`, `apt`, `dnf`, `zypper`):

```bash
git clone https://github.com/3x1om/Serminal.git && cd Serminal && sudo bash scripts/install-system.sh
```

GUI shortcuts:

- `Ctrl+Shift+T`: new tab
- `Ctrl+Shift+W`: close current tab
- `Ctrl+,`: open GUI settings

Manual dependency install (optional, CachyOS/Arch):

```bash
sudo pacman -S python-gobject gtk4 vte4 chafa fastfetch ttf-jetbrains-mono-nerd
```

Serminal automatically defaults `fastfetch` logo rendering to:
- `sixel` when VTE sixel support exists
- `chafa` otherwise

## Run scripts

```bash
./serminal run examples/hello.sh
./serminal run examples/hello.tssh
```

`.tssh` supports imports:

```bash
@import strings
say_hello "Open Serialis"
```

Library lookup order:

1. `<script_dir>/<name>.sh`
2. `<script_dir>/libs/<name>.sh`
3. `~/.local/share/serminal/libs/<name>.sh`

## Library management

```bash
./serminal lib create strings
./serminal lib list
./serminal lib install net ./my-net-lib.sh
./serminal lib remove strings
```

## Settings and customization

Show all settings:

```bash
./serminal settings show
```

Set prompt/shell/aliases:

```bash
./serminal settings set prompt "Serminal ❯ "
./serminal settings set shell zsh
./serminal settings set aliases.gs "git status"
```

GUI settings can be changed from the in-app `Settings` button or CLI:

```bash
./serminal settings set gui.theme openserialis
./serminal settings set gui.font "JetBrains Mono 11"
./serminal settings set gui.logo_mode auto
./serminal settings set gui.show_shortcuts true
./serminal settings set gui.animations true
```

Config file location:

- `~/.config/serminal/config.json`
- Fallback in restricted environments: `./.serminal/.config/serminal/config.json`

Optional override for both config + data roots:

```bash
SERMINAL_HOME=/some/path ./serminal shell
```

## Start menu + MIME install

Local (no root):

```bash
./serminal install-desktop
```

System-wide (for distro packaging, root required):

```bash
sudo ./serminal install-desktop --system
```

This installs:

- Desktop entry `serminal.desktop`
- MIME type `text/x-serminal-script` for `*.tssh`

## Packaging notes for Open Serialis

For preinstall in your distro image/package:

1. Install `serminal` to `/usr/bin/serminal`
2. Install `packaging/serminal.desktop` to `/usr/share/applications/`
3. Install `packaging/serminal.xml` to `/usr/share/mime/packages/`
4. Run:

```bash
update-desktop-database /usr/share/applications
update-mime-database /usr/share/mime
```

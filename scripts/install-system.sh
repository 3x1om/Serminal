#!/usr/bin/env bash
set -euo pipefail

install_first_available_pacman() {
  for pkg in "$@"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      pacman -S --needed --noconfirm "$pkg"
      return 0
    fi
  done
  return 1
}

install_runtime_deps() {
  if command -v pacman >/dev/null 2>&1; then
    # Open Serialis / CachyOS / Arch
    pacman -Sy --needed --noconfirm python-gobject gtk4 vte4 chafa fastfetch
    install_first_available_pacman \
      ttf-jetbrains-mono-nerd \
      ttf-firacode-nerd \
      ttf-cascadia-code-nerd \
      ttf-hack-nerd \
      nerd-fonts \
      || echo "warning: nerd font package not found in repos" >&2
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y python3-gi gir1.2-gtk-4.0 gir1.2-vte-2.91 chafa fastfetch fonts-jetbrains-mono
    return
  fi

  if command -v dnf >/dev/null 2>&1; then
    dnf install -y python3-gobject gtk4 vte291 chafa fastfetch jetbrains-mono-fonts
    return
  fi

  if command -v zypper >/dev/null 2>&1; then
    zypper --non-interactive install python3-gobject gtk4 typelib-1_0-Vte-2_91 chafa fastfetch jetbrains-mono-fonts
    return
  fi

  echo "warning: unsupported package manager, skipping runtime dependency install" >&2
}

install_runtime_deps

install -Dm755 serminal /usr/bin/serminal
install -Dm644 packaging/serminal.desktop /usr/share/applications/serminal.desktop
install -Dm644 packaging/serminal.xml /usr/share/mime/packages/serminal.xml

update-desktop-database /usr/share/applications || true
update-mime-database /usr/share/mime || true

echo "Installed Serminal system-wide."

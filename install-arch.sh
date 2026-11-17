#!/usr/bin/env bash

source /etc/os-release
os_name="$ID"

case "$os_name" in
arch | cachyos) ;;
*)
  echo "This installer is meant to run on Arch-based systems (Arch, CachyOS)."
  exit 1
  ;;
esac

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found. Are you really on Arch?"
  exit 1
fi

echo "WARN: This installer keeps TacoRice files in $HOME/.taco"
echo "To remove the rice, remove $HOME/.taco and its session file."

ask_yes_no() {
  local answer
  read -r -p "$1 [y/N]: " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

if ! ask_yes_no "Start installation?"; then
  echo "Okay, cancelled."
  exit 0
fi

# Prefer an AUR helper when a package is not in the official repos.
install_pkgs() {
  local missing=() pkg

  for pkg in "$@"; do
    pacman -Si "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    sudo pacman -S --needed --noconfirm "$@"
    return
  fi

  # Split into repo packages and anything that needs the AUR.
  local repo=() aur=()
  for pkg in "$@"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      repo+=("$pkg")
    else
      aur+=("$pkg")
    fi
  done

  [[ ${#repo[@]} -gt 0 ]] && sudo pacman -S --needed --noconfirm "${repo[@]}"

  if [[ ${#aur[@]} -gt 0 ]]; then
    local helper
    for helper in paru yay; do
      if command -v "$helper" >/dev/null 2>&1; then
        "$helper" -S --needed --noconfirm "${aur[@]}"
        return
      fi
    done

    echo "These packages are not in the official repos and no AUR helper (paru/yay) was found:"
    printf '  %s\n' "${aur[@]}"
    echo "Install them manually, then re-run this script."
  fi
}

if ask_yes_no "Install packages?"; then
  install_pkgs mako swaybg quickshell git neovim kitty wofi dolphin \
    grim slurp wl-clipboard brightnessctl playerctl wireplumber
fi

if ask_yes_no "Install Hyprland?"; then
  install_pkgs hyprland
fi

TACO_DIR="$HOME/.taco"

if [[ -d "$TACO_DIR" ]] && [[ -n "$(ls -A "$TACO_DIR" 2>/dev/null)" ]]; then
  echo "$TACO_DIR already exists and is not empty."
  read -r -p "Remove it and continue? [y/N] " answer

  case "$answer" in
  [yY] | [yY][eE][sS])
    rm -rf -- "$TACO_DIR"
    echo "Removed existing TacoRice directory."
    ;;
  *)
    echo "Installation cancelled."
    exit 1
    ;;
  esac
fi

if ask_yes_no "Get My rices?"; then
  mkdir -p ~/.taco/
  git clone --depth 1 https://github.com/taco-pepe/Dots ~/.taco/
fi

if ask_yes_no "Install Wayland session file?"; then
  sudo mkdir -p /usr/share/wayland-sessions

  sudo tee /usr/share/wayland-sessions/tacorice.desktop >/dev/null <<EOF
[Desktop Entry]
Name=TacoRice
Comment=TacoRice Hyprland session
Exec=/usr/bin/Hyprland --config $HOME/.taco/hypr/hyprland.lua
Type=Application
DesktopNames=Hyprland
EOF

  echo "TacoRice session installed!"
fi

#!/usr/bin/env bash

source /etc/os-release
os_name="$ID"

if [[ "$os_name" != "fedora" ]]; then
    echo "This installer is meant to run on Fedora systems (for now)."
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

if ask_yes_no "Install packages?"; then
    sudo dnf install mako swaybg quickshell git neovim kitty wofi dolphin grim slurp wl-clipboard -y 
fi

if ask_yes_no "Enable the Hyprland COPR repository?"; then
    sudo dnf copr enable ashbuk/Hyprland-Fedora
fi

if ask_yes_no "install hyprland?"; then
    sudo dnf install hyprland -y
fi

if ask_yes_no "Get My rices?"; then
    mkdir -p ~/.taco/ 
    git clone --depth 1 https://github.com/taco-pepe/Dots ~/.taco/
fi

if ask_yes_no "install wayland session file?"; then
    # lets get cooking jessy
    session_dir="$HOME/.local/share/wayland-sessions"
    mkdir -p "$session_dir"

    cat > "$session_dir/tacorice.desktop" <<EOF
      [Desktop Entry]
      Name=TacoRice
      Comment=TacoRice Hyprland session
      Exec=Hyprland --config $HOME/.taco/hypr/hyprland.lua
      Type=Application
      DesktopNames=Hyprland
    EOF

    echo "Session entry created at $session_dir/tacorice.desktop"
fi 

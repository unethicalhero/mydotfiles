#!/bin/bash
set -e

install_yay() {
  if ! command -v yay &> /dev/null; then
    echo "yay not found, installing yay..."

    sudo pacman -S --needed --noconfirm git base-devel

    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
  else
    echo "yay found, skipping installation"
  fi
}

initial_pacman_apps=(
  hyprland hyprlock hypridle hyprpaper hyprpolkitagent xdg-desktop-portal-hyprland
  wl-clipboard
  cliphist
  foot
  dunst
  fastfetch
  mpv
  btop
  nwg-look
  qt5ct
  qt6ct
  cava
)

initial_aur_apps=(
  tofi
  wlogout 
  xwaylandvideobridge 
  grimblast-git
  qimgv-git
)

optional_pacman_apps=(
  hyprsunset hyprpicker
  qutebrowser
  steam
  gamemode
  gamescope
  mangohud
)

optional_aur_apps=(
  hyprswitch 
  librewolf-bin ungoogled-chromium-bin 
  localsend-bin
  kew
)

install_yay

echo "Installing initial pacman packages..."
sudo pacman -Syu --needed --noconfirm "${initial_pacman_apps[@]}"

echo "Installing initial AUR packages..."
yay -S --needed --noconfirm "${initial_aur_apps[@]}"

echo
echo "Now let's decide which optional pacman packages to install."

for app in "${optional_pacman_apps[@]}"; do
  read -rp "Install $app? (y/N): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm "$app"
  else
    echo "Skipping $app"
  fi
done

echo
echo "Now let's decide which optional AUR packages to install."

for app in "${optional_aur_apps[@]}"; do
  read -rp "Install $app? (y/N): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    yay -S --needed --noconfirm "$app"
  else
    echo "Skipping $app"
  fi
done

echo "All selected apps installed!"


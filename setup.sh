#!/bin/sh
#   _    _____ _                 _ _____      
#  | |__|___ // |_ __   __ _  __| |___ /_   __   My Arch Setup Script
#  | '_ \ |_ \| | '_ \ / _` |/ _` | |_ \ \ / /   Pramurta Sinha (b31ngd3v)
#  | |_) |__) | | | | | (_| | (_| |___) \ V /    https://www.github.com/b31ngd3v
#  |_.__/____/|_|_| |_|\__, |\__,_|____/ \_/     contact@b31ngd3v.eu.org
#                      |___/                  

set -e

printf "WIFI SSID (leave it blank if you don't wanna use wifi): "
read -r SSID

stty -echo
printf "WIFI Password (leave it blank if you don't wanna use wifi): "
read -r PASS
printf "\n"
stty echo

ISAMDCPU=$( grep -c "AuthenticAMD" /proc/cpuinfo || true )
ISINTELCPU=$( grep -c "GenuineIntel" /proc/cpuinfo || true )

ISAMDGPU=$( lspci | grep -icE "(VGA|3D).*AMD" || true )
ISINTELGPU=$( lspci | grep -icE "(VGA|3D).*Intel" || true )
ISNVIDIAGPU=$( lspci | grep -icE "(VGA|3D).*NVIDIA" || true )

if [ "$ISAMDCPU" != "0" ]; then
    CPU="amd"
elif [ "$ISINTELCPU" != "0" ]; then
    CPU="intel"
else
    printf "Failed to identify the cpu brand! Exiting the script..." >&2
    printf "\n"
    exit 1
fi

if [ "$ISAMDGPU" != "0" ]; then
    GPUDRIVER="xf86-video-amdgpu"
elif [ "$ISINTELGPU" != "0" ]; then
    GPUDRIVER="xf86-video-intel"
elif [ "$ISNVIDIAGPU" != "0" ]; then
    GPUDRIVER="nvidia"
else
    printf "Failed to identify the gpu brand! Exiting the script..." >&2
    printf "\n"
    exit 1
fi

sudo dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
sudo chmod 600 /mnt/swapfile 
sudo mkswap /mnt/swapfile
echo '/mnt/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo swapon /mnt/swapfile

if [ "$SSID" != "" ]; then
    sudo nmcli d wifi connect "$SSID" password "$PASS"
fi

sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
sudo sed -i "s/^#Color$/Color\nILoveCandy/" /etc/pacman.conf

sudo pacman -Sy --noconfirm vim "$CPU-ucode" xorg-server "$GPUDRIVER" xorg-xinit brightnessctl btop git firefox xcompmgr xwallpaper xclip xdotool dmenu ttf-jetbrains-mono ttf-joypixels ttf-font-awesome wget imagemagick python-pip sxiv unclutter man-db mpv dunst sxhkd pulseaudio pamixer maim zsh neovim tmux ranger jq noto-fonts

if [ "$GPUDRIVER" = "nvidia" ]; then
    sudo pacman -S --noconfirm nvidia-utils
fi

git clone --no-checkout https://github.com/b31ngd3v/dotfiles.git "$HOME/tmp"
mv "$HOME/tmp/.git" "$HOME"
rmdir "$HOME/tmp"
(cd "$HOME" && git reset --hard HEAD)
rm -rf "$HOME/.git"
ln -sf "$HOME/.cache/wal/dunstrc" "$HOME/.config/dunst/dunstrc"
mkdir "$HOME/pix/ss"

git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
(cd /tmp/yay-bin && makepkg -si --noconfirm)
rm -rf /tmp/yay-bin

sudo pacman -Rdd --noconfirm libxft
yay -S --noconfirm libxft-bgra betterlockscreen zsh-fast-syntax-highlighting
sudo systemctl enable betterlockscreen@"$USER"

pip install pywal ueberzug

mkdir "$HOME/.local/src"

git clone https://github.com/b31ngd3v/dwm.git "$HOME/.local/src/dwm"
(cd "$HOME/.local/src/dwm" && sudo make clean install)

git clone https://github.com/b31ngd3v/dwmblocks.git "$HOME/.local/src/dwmblocks"
(cd "$HOME/.local/src/dwmblocks" && sudo make clean install)

git clone https://github.com/b31ngd3v/st.git "$HOME/.local/src/st"
(cd "$HOME/.local/src/st" && sudo make clean install)

echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null << CONF
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
EndSection
CONF

if [ "$ISAMDGPU" != "0" ]; then
    sudo tee /etc/X11/xorg.conf.d/20-amd-gpu.conf > /dev/null << CONF
Section "Device"
    Identifier  "AMD Graphics"
    Driver      "amdgpu"
    Option      "TearFree"  "true"
EndSection
CONF
elif [ "$ISINTELGPU" != "0" ]; then
    sudo tee /etc/X11/xorg.conf.d/20-intel-gpu.conf > /dev/null << CONF
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "TearFree"  "true"
EndSection
CONF
fi

yay -Sc --noconfirm
sudo chsh -s "$(which zsh)" "$USER"
rm ~/.bash*
rm setup.sh
sudo reboot

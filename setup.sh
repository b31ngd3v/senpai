#!/bin/sh
#   _    _____ _                 _ _____      
#  | |__|___ // |_ __   __ _  __| |___ /_   __   My Arch Setup Script
#  | '_ \ |_ \| | '_ \ / _` |/ _` | |_ \ \ / /   Pramurta Sinha (b31ngd3v)
#  | |_) |__) | | | | | (_| | (_| |___) \ V /    https://www.github.com/b31ngd3v
#  |_.__/____/|_|_| |_|\__, |\__,_|____/ \_/     contact@b31ngd3v.eu.org
#                      |___/                  

printf "WIFI SSID (leave it blank if you don't wanna use wifi): "
read -r SSID

stty -echo
printf "WIFI Password (leave it blank if you don't wanna use wifi): "
read -r PASS
printf "\n"
stty echo

ISAMDCPU=$( grep -c "AuthenticAMD" /proc/cpuinfo )
ISINTELCPU=$( grep -c "GenuineIntel" /proc/cpuinfo )

ISAMDGPU=$( lspci | grep -icE "(VGA|3D).*AMD" )
ISINTELGPU=$( lspci | grep -icE "(VGA|3D).*Intel" )
ISNVIDIAGPU=$( lspci | grep -icE "(VGA|3D).*NVIDIA" )

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

dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
chmod 600 /mnt/swapfile 
mkswap /mnt/swapfile
echo '/mnt/swapfile none swap sw 0 0' | tee -a /etc/fstab
swapon /mnt/swapfile

if [ "$SSID" != "" ]; then
    nmcli d wifi connect "$SSID" password "$PASS"
fi

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
sed -i "s/^#Color$/Color\nILoveCandy/" /etc/pacman.conf

sudo pacman -Sy --noconfirm vim "$CPU-ucode" xorg-server "$GPUDRIVER" xorg-xinit btop

if [ "$GPUDRIVER" = "nvidia" ]; then
    sudo pacman -S --noconfirm nvidia-utils
fi

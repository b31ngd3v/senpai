#!/bin/sh
#   _    _____ _                 _ _____      
#  | |__|___ // |_ __   __ _  __| |___ /_   __   My Arch Setup Script
#  | '_ \ |_ \| | '_ \ / _` |/ _` | |_ \ \ / /   Pramurta Sinha (b31ngd3v)
#  | |_) |__) | | | | | (_| | (_| |___) \ V /    https://www.github.com/b31ngd3v
#  |_.__/____/|_|_| |_|\__, |\__,_|____/ \_/     contact@b31ngd3v.eu.org
#                      |___/                  

set -e

dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
chmod 600 /mnt/swapfile 
mkswap /mnt/swapfile
echo '/mnt/swapfile none swap sw 0 0' | tee -a /etc/fstab
swapon /mnt/swapfile

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
sed -i "s/^#Color$/Color\nILoveCandy/" /etc/pacman.conf

pacman -Sy --noconfirm  networkmanager vim amd-ucode xorg-server xf86-video-amdgpu xorg-xinit btop
systemctl enable --now NetworkManager.service
nmcli d wifi connect M20 password zbaa8991

#!/bin/sh
#   _    _____ _                 _ _____      
#  | |__|___ // |_ __   __ _  __| |___ /_   __   My Arch Installation Script
#  | '_ \ |_ \| | '_ \ / _` |/ _` | |_ \ \ / /   Pramurta Sinha (b31ngd3v)
#  | |_) |__) | | | | | (_| | (_| |___) \ V /    https://www.github.com/b31ngd3v
#  |_.__/____/|_|_| |_|\__, |\__,_|____/ \_/     contact@b31ngd3v.eu.org
#                      |___/                  

set -e

timedatectl set-ntp true

LARGEST_PARTITION_SIZE=$(fdisk -l | grep "Disk.*GiB" | cut -d' ' -f3 | sort -nr | head -n1)
LARGEST_PARTITION=$(fdisk -l | grep "$LARGEST_PARTITION_SIZE GiB" | cut -d' ' -f2  | sed 's/.$//')
sgdisk -Z "$LARGEST_PARTITION"
sgdisk -n 1::+512MiB -t 1:ef00 -c 1:EFI "$LARGEST_PARTITION"
sgdisk -n 2 -c 2:ROOT "$LARGEST_PARTITION"
mkfs.fat -F32 "${LARGEST_PARTITION}1"
mkfs.ext4 "${LARGEST_PARTITION}2"
mount "${LARGEST_PARTITION}2" /mnt
mkdir /mnt/boot && mkdir /mnt/boot/EFI
mount "${LARGEST_PARTITION}1" /mnt/boot/EFI

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacstrap /mnt base base-devel linux linux-headers linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i "s/#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
export LANG="en_US.UTF-8"
echo "arch" > /mnt/etc/hostname
cat > /mnt/etc/hosts << HOSTS
127.0.0.1      localhost
::1            localhost
127.0.1.1      arch.localdomain     arch
HOSTS
(
echo lucifer
echo lucifer
) | arch-chroot /mnt passwd
arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
arch-chroot /mnt useradd -m -G wheel b31ngd3v
(
echo lucifer
echo lucifer
) | arch-chroot /mnt passwd b31ngd3v

arch-chroot /mnt pacman --noconfirm -Sy grub os-prober efibootmgr dosfstools mtools
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
arch-chroot /mnt sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
arch-chroot /mnt sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"/g' /etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

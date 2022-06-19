#!/bin/sh
#   _    _____ _                 _ _____      
#  | |__|___ // |_ __   __ _  __| |___ /_   __   My Arch Installation Script
#  | '_ \ |_ \| | '_ \ / _` |/ _` | |_ \ \ / /   Pramurta Sinha (b31ngd3v)
#  | |_) |__) | | | | | (_| | (_| |___) \ V /    https://www.github.com/b31ngd3v
#  |_.__/____/|_|_| |_|\__, |\__,_|____/ \_/     contact@b31ngd3v.eu.org
#                      |___/                  

set -e

printf "Set Hostname: "
read -r HOSTNAME
printf "Set Username: "
read -r USERNAME

stty -echo
printf "Set Password: "
read -r PASSWORD
printf "\n"
printf "Confirm Password: "
read -r CONFIRMPASSWORD
printf "\n"
stty echo

if [ "$PASSWORD" != "$CONFIRMPASSWORD" ]; then
    printf "Passwords didn't match! Exiting the script..." >&2
    printf "\n"
    exit 1
fi

printf "Would you like to use automatic partitioning? [y/N]: "
read -r AUTOPART

timedatectl set-ntp true

LARGEST_PARTITION_SIZE=$(fdisk -l | grep "Disk.*GiB" | cut -d' ' -f3 | sort -nr | head -n1)
LARGEST_PARTITION=$(fdisk -l | grep "$LARGEST_PARTITION_SIZE GiB" | cut -d' ' -f2  | sed 's/.$//')
if [ "$AUTOPART" = "y" ] || [ "$AUTOPART" = "Y" ] || [ "$AUTOPART" = "Yes" ] || [ "$AUTOPART" = "yes" ]; then
    sfdisk "$LARGEST_PARTITION" << EOF
label: gpt
name=EFI,size=512MB,type=uefi
name=ROOT,type=linux
EOF
else
    printf "Create two partitions:"
    printf "\n"
    printf "    1. %s1    EFI" "$LARGEST_PARTITION"
    printf "\n"
    printf "    2. %s2    Linux filesystem" "$LARGEST_PARTITION"
    printf "\n"
    fdisk "$LARGEST_PARTITION"
fi
echo "y" | mkfs.fat -F32 "${LARGEST_PARTITION}1"
echo "y" | mkfs.ext4 "${LARGEST_PARTITION}2"
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
echo "$HOSTNAME" > /mnt/etc/hostname
cat > /mnt/etc/hosts << HOSTS
127.0.0.1      localhost
::1            localhost
127.0.1.1      $HOSTNAME.localdomain	$HOSTNAME
HOSTS
(
echo "$PASSWORD"
echo "$PASSWORD"
) | arch-chroot /mnt passwd
arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
arch-chroot /mnt useradd -m -G wheel "$USERNAME"
(
echo "$PASSWORD"
echo "$PASSWORD"
) | arch-chroot /mnt passwd "$USERNAME"

arch-chroot /mnt pacman --noconfirm -Sy grub os-prober efibootmgr dosfstools mtools
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
arch-chroot /mnt sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
arch-chroot /mnt sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"/g' /etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

arch-chroot /mnt pacman -S --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager.service

cp setup.sh "/mnt/home/$USERNAME"
arch-chroot /mnt chown "$USERNAME" "/home/$USERNAME/setup.sh"
arch-chroot /mnt chmod +x "/home/$USERNAME/setup.sh"
echo "./setup.sh" >> "/mnt/home/$USERNAME/.bashrc"
arch-chroot /mnt chown "$USERNAME" "/home/$USERNAME/.bashrc"

umount -l /mnt
reboot

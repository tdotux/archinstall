#!/bin/bash

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nTIMEDADECTL"

sleep 2

echo -e "$(tput sgr0)\n\n"

timedatectl set-ntp true

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nUTILITARIOS"

sleep 2

echo -e "$(tput sgr0)\n\n"

pacman -S e2fsprogs dosfstools nano wget --noconfirm

echo -e "$(tput sgr0)\n\n"


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nTIPO DE SISTEMA"

sleep 2

PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
parted /dev/sda mklabel msdos -s
parted /dev/sda mkpart primary ext4 1MiB 100% -s
parted /dev/sda set 1 boot on
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt


else
echo -e "Sistema EFI"
parted /dev/sda mklabel gpt -s
parted /dev/sda mkpart primary fat32 1MiB 301MiB -s
parted /dev/sda set 1 esp on
parted /dev/sda mkpart primary ext4 301MiB 100% -s
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
fi

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nPACSTRAP"

sleep 2

echo -e "$(tput sgr0)\n\n"

pacstrap /mnt base e2fsprogs linux-zen linux-firmware


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nFSTAB"

echo -e "$(tput sgr0)\n\n"

genfstab -U /mnt > /mnt/etc/fstab


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nARCH-CHROOT GIT CLONE"

sleep 3

echo -e "$(tput sgr0)\n\n"



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nARCH-CHROOT PACMAN"

sleep 3

arch-chroot /mnt pacman -Syy git --noconfirm



arch-chroot /mnt git clone http://github.com/tdotux/archscript



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nARCH-CHROOT EXEC SCRIPT"

sleep 3

echo -e "$(tput sgr0)\n\n"


arch-chroot /mnt sh /archscript/pi-script.sh

sleep 3

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\nREINICIANDO EM"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n5"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n4"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n3"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n2"
sleep 1
echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n\n1"


reboot

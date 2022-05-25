#!/bin/bash

###AJUSTAR HORA AUTOMATICAMENTE

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nHORA AUTOMATICA\n"


timedatectl set-ntp true

echo -e "$(tput sgr0)\n\n"


###UTILITARIOS BASICOS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nUTILITARIOS BASICOS\n"


pacman -Sy nano pacman-contrib reflector sudo grub --noconfirm

echo -e "$(tput sgr0)\n\n"


###MIRRORS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nMIRRORS\n"


cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /etc/pacman.d/mirrorlist

echo -e "$(tput sgr0)\n\n"


###PARALLEL DOWNLOADS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nPARALLEL DOWNLOADS\n"


cp /etc/pacman.conf /etc/pacman.conf.bak && sudo sed -i '37c\ParallelDownloads = 16' /etc/pacman.conf && pacman -Syyyuuu --noconfirm

echo -e "$(tput sgr0)\n\n"


###MULTILIB

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nMULTILIB\n"


sed -i '93c\[multilib]' /etc/pacman.conf && sudo sed -i '94c\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf && pacman -Syyyuu --noconfirm

echo -e "$(tput sgr0)\n\n"


###FUSO HORARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nFUSO HORARIO\n"


ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc

echo -e "$(tput sgr0)\n\n"


###LOCALE

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nLOCALE\n"


mv /etc/locale.gen /etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /etc/locale.gen && locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /etc/locale.conf

echo -e "$(tput sgr0)\n\n"


###HOSTNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nHostname\n"

read -p "Digite o Hostname : " HOST
echo "$HOST" | sudo tee /etc/hostname

echo -e "$(tput sgr0)\n\n"



###HOSTS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nHOSTS\n"


echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOST.localdomain $HOST" | sudo tee /etc/hosts

echo -e "$(tput sgr0)\n\n"


###SENHA ROOT

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nSenha de Root\n"

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nDigite a Senha de Root\n"

passwd

echo -e "$(tput sgr0)\n\n"



###USERNAME

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nUsername\n"

read -p "Digite o Nome de Usuário : " USERNAME

useradd -m $USERNAME

echo -e "$(tput sgr0)\n\n"



###SENHA DO USUARIO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nSenha do Usuário\n"

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nDigite a Senha do Usuário\n"

passwd $USERNAME

echo -e "$(tput sgr0)\n\n"



###GRUPOS

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nGRUPOS\n"


groupadd -r autologin && groupadd -r sudo

usermod -G autologin,sudo,wheel,lp $USERNAME

echo -e "$(tput sgr0)\n\n"


###WHEEL

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nWHEEL\n"


cp /etc/sudoers /etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /etc/sudoers

echo -e "$(tput sgr0)\n\n"


###GRUB

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nGRUB\n"


PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
grub-install --target=i386-pc /dev/sda --force && grub-mkconfig -o /boot/grub/grub.cfg

else
echo -e "Sistema EFI"
pacman -S efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && grub-mkconfig -o /boot/grub/grub.cfg

fi

echo -e "$(tput sgr0)\n\n"


###DRIVER DE VIDEO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nDRIVER DE VIDEO\n"


if [  $(lspci | grep -c Radeon) = 1 ]; then
pacman -S xf86-video-amdgpu xf86-video-ati --noconfirm

elif [  $(lspci | grep -c Intel) = 1 ]; then
pacman -S xf86-video-intel --noconfirm

elif [  $(lspci | grep -c GeForce) = 1 ]; then
pacman -S xf86-video-nouveau --noconfirm

elif [  $(lspci | grep -c VMware) = 1 ]; then
pacman -S xf86-video-vmware xf86-input-vmmouse --noconfirm

fi

echo -e "$(tput sgr0)\n\n"


###PACOTES PADRÃO

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nPACOTES PADRAO\n"


pacman -S xorg-server xorg-xinit xterm linux-zen-headers networkmanager xarchiver tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

echo -e "$(tput sgr0)\n\n"


###INTERFACE GRÁFICA

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n#### INTERFACE GRÁFICA (DE) ####"


echo -e "\n1  - Budgie\n2  - Cinnamon\n3  - Deepin\n4  - GNOME\n5  - GNOME Flashback\n6  - KDE Plasma (X11)\n7  - KDE Plasma (Wayland)\n8  - LXDE\n9  - LXQt\n10 - MATE\n11 - XFCE\n"


read -p "Digite o Nº Correspondente à Interface Gráfica : " DE


echo -e "$(tput sgr0)\n\n"

if [ $DE = 1 ]; then
pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi



if [ $DE = 2 ]; then
pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi



if [ $DE = 3 ]; then
pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi



if [ $DE = 4 ]; then
pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
systemctl enable gdm NetworkManager
fi



if [ $DE = 5 ]; then
pacman -S gnome-flashback gnome-tweaks gnome-terminal gnome-system-monitor nautilus network-manager-applet gdm --noconfirm
systemctl enable gdm NetworkManager
fi



if [ $DE = 6 ]; then
pacman -S plasma konsole sddm dolphin spectacle kcalc plasma-nm plasma-pa --noconfirm
systemctl enable sddm NetworkManager
fi



if [ $DE = 7 ]; then
pacman -S plasma konsole sddm dolphin spectacle kcalc plasma-nm plasma-pa plasma-wayland-session --noconfirm
systemctl enable sddm NetworkManager
fi


if [ $DE = 8 ]; then
pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi


if [ $DE = 9 ]; then
pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
systemctl enable sddm NetworkManager
fi



if [ $DE = 10 ]; then
pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi



if [ $DE = 11 ]; then
pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
systemctl enable lightdm NetworkManager
fi

echo -e "$(tput sgr0)\n\n"


###USER DIRS UPDATE

echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\nXDG USER DIRS\n"


xdg-user-dirs-update

echo -e "$(tput sgr0)\n\n"


echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)\n####INSTALAÇÃO CONCLUÍDA!!!\n\nREINICIE SEU PC COM O COMANDO reboot\n\n"

echo -e "$(tput sgr0)\n\n"

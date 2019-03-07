#!/bin/bash

###### PERSONAL ####
##### ARCHLINUX ####
#### INSTALATION ###

#  #  #### #### ####
###   #     ##  #
#  #  ####  ##  #
#  #     #  ##  #
#  #  #### #### ####

#Verify if number of args are "not equal" 5
if [ $# -ne 5 ]; then
  echo "linux_partition efi_partition username password hostname=laptop/desktop/vm"
  exit 1
fi

#Verify if hostname is correct
if [ $5 != laptop ] && [ $5 != desktop ] && [ $5 != vm ]; then
  echo "hostname must be laptop/desktop/vm"
  exit 1
fi

LINUX_PARTITION=$1
EFI_PARTITION=$2
USERNAME=$3
PASSWORD=$4
HOSTNAME=$5
PACKAGE_LIST=""

echo -n "Updating the system clock..."
timedatectl set-ntp true
echo "done."

echo -n "Formatting the partition with the ext4 file system..."
echo y | mkfs.ext4 $LINUX_PARTITION
echo "done."

echo -n "Mounting linux partition..."
mount $LINUX_PARTITION /mnt
echo "done."

echo -n "Mounting EFI partition..."
mkdir /mnt/boot
mount $EFI_PARTITION /mnt/boot
echo "done."

case $HOSTNAME in

desktop)
  create_desktop_packages
  ;;
laptop)
  create_laptop_packages
  ;;
vm)
  create_vm_packages
  ;;

esac

echo -n "Installing packages..."
if [ "$HOSTNAME" == "desktop" ]; then
  pacstrap /mnt base base-devel ranger tldr iwd grub efibootmgr os-prober vim git nvidia nvidia-settings xorg rxvt-unicode dmenu i3lock perl-json-xs perl-anyevent-i3 i3-gaps i3status acpi alsa-utils sysstat i3blocks xorg-xinit flameshot rofi neofetch htop compton ntfs-3g rsync papirus-icon-theme arc-solid-gtk-theme ttf-inconsolata ttf-croscore noto-fonts
fi
if [ "$HOSTNAME" == "laptop" ]; then
  pacstrap /mnt base base-devel ranger tldr iwd grub efibootmgr os-prober vim git bbswitch bumblebee nvidia nvidia-settings xf86-video-intel xorg rxvt-unicode dmenu i3lock perl-json-xs perl-anyevent-i3 i3-gaps i3status acpi alsa-utils sysstat i3blocks xorg-xinit flameshot rofi neofetch htop compton ntfs-3g rsync papirus-icon-theme arc-solid-gtk-theme ttf-inconsolata ttf-croscore noto-fonts
fi
genfstab -U /mnt >>/mnt/etc/fstab
echo "done."

echo -n "chrooting..."

reboot

chroot_desktop() {

  cat <<EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $4; echo $4; } | passwd
useradd -m -G wheel $3
{ echo $4; echo $4; } | passwd $3
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo desktop >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$3/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $3 -R /home/$3/
EOF

}

chroot_laptop() {

  cat <<EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $4; echo $4; } | passwd
useradd -m -G wheel $3
{ echo $4; echo $4; } | passwd $3
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo laptop >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$3/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $3 -R /home/$3/

gpasswd -a $3 bumblebee
systemctl enable bumblebeed.service
EOF

}

chroot_vm() {

}

# start/enable iwd.service
# iwctl
# device list
# station interface scan
# station interface connect network_name
# device interface show

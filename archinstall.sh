#!/bin/bash

##### PERSONAL #####
#### ARCHLINUX #####
### INSTALATION ####

#  #  #### ###  ####
###   #     ##  #
#  #  ####  ##  #
#  #     #  ##  #
#  #  ####  ##  ####

HOSTNAME=$1
USERNAME=$2
PASSWORD=$3
LINUX_PARTITION=$4
EFI_PARTITION=$5
PACKAGE_LIST=""
ERROR_USAGE="usage hostname=laptop/desktop/vm username password linux_partition efi_partition"

main() {

  verify_args

  echo -n "Updating the system clock..."
  timedatectl set-ntp true
  echo "done."

  echo -n "Formatting the partition with the ext4 file system..."
  echo y | mkfs.ext4 $LINUX_PARTITION
  echo "done."

  echo -n "Mounting linux partition..."
  mount $LINUX_PARTITION /mnt
  echo "done."

  if [ $HOSTNAME != "vm" ]; then
    echo -n "Mounting EFI partition..."
    mkdir /mnt/boot
    mount $EFI_PARTITION /mnt/boot
    echo "done."
  fi

  case $HOSTNAME in
  desktop)
    #INSTALLING FOR DESKTOP
    create_desktop_package_list
    pacstrap /mnt $PACKAGE_LIST
    genfstab -U /mnt >>/mnt/etc/fstab
    chroot_desktop
    ;;
  laptop)
    #INSTALLING FOR LAPTOP
    create_laptop_package_list
    pacstrap /mnt $PACKAGE_LIST
    genfstab -U /mnt >>/mnt/etc/fstab
    chroot_laptop
    ;;
  vm)
    #INSTALLING FOR VM
    create_vm_package_list
    pacstrap /mnt $PACKAGE_LIST
    genfstab -U /mnt >>/mnt/etc/fstab
    chroot_vm
    ;;
  esac
}

verify_args() {

  if [ "$HOSTNAME" == "" ] ||
    [ "$USERNAME" == "" ] ||
    [ "$PASSWORD" == "" ] ||
    [ "$LINUX_PARTITION" == "" ]; then
    echo $ERROR_USAGE
    exit 1
  fi

  if [ "$HOSTNAME" != "desktop" ] &&
    [ "$HOSTNAME" != "laptop" ] &&
    [ "$HOSTNAME" != "vm" ]; then
    echo $ERROR_USAGE
    exit 1
  fi

  if [ "$EFI_PARTITION" == "" ] && [ "$HOSTNAME" != "vm" ]; then
    echo $ERROR_USAGE
    exit 1
  fi

  echo -e "\nhostname = $HOSTNAME"
  echo "username = $USERNAME"
  echo "password = $PASSWORD"
  echo "linux_partition = $LINUX_PARTITION"
  echo -e "efi_partition = $EFI_PARTITION\n"

  read -p "Continue (y/n)? " choice
  case $choice in
  y | Y) ;;
  n | N)
    exit 1
    ;;
  *)
    exit 1
    ;;
  esac
}

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

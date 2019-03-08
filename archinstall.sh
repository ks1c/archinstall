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

create_programs_package_list() {
  add_to_package_list dmenu
  add_to_package_list i3lock
  add_to_package_list i3status
  add_to_package_list perl-anyevent-i3
  add_to_package_list perl-json-xs
  add_to_package_list rxvt-unicode
  add_to_package_list i3-gaps
  add_to_package_list alsa-utils
  add_to_package_list i3blocks
  add_to_package_list rofi
  add_to_package_list ntfs-3g
  add_to_package_list rsync
  add_to_package_list htop
  add_to_package_list flameshot
  add_to_package_list compton
  add_to_package_list neofetch
  add_to_package_list ranger
  add_to_package_list tldr
  add_to_package_list vim
  add_to_package_list git
  add_to_package_list papirus-icon-theme
  add_to_package_list arc-solid-gtk-theme
  add_to_package_list ttf-inconsolata
  add_to_package_list ttf-croscore
  add_to_package_list noto-fonts
}

create_desktop_package_list() {
  add_to_package_list base
  add_to_package_list base-devel
  add_to_package_list linux-headers
  add_to_package_list broadcom-wl-dkms
  add_to_package_list grub
  add_to_package_list efibootmgr
  add_to_package_list os-prober
  add_to_package_list nvidia
  add_to_package_list nvidia-settings
  add_to_package_list xorg
  add_to_package_list xorg-xinit
  add_to_package_list iwd

  create_programs_package_list
}

create_laptop_package_list() {
  add_to_package_list base
  add_to_package_list base-devel
  add_to_package_list grub
  add_to_package_list efibootmgr
  add_to_package_list os-prober
  add_to_package_list bbswitch
  add_to_package_list bumblebee
  add_to_package_list nvidia
  add_to_package_list nvidia-settings
  add_to_package_list xf86-video-intel
  add_to_package_list xorg
  add_to_package_list xorg-xinit
  add_to_package_list iwd
  add_to_package_list acpi

  create_programs_package_list
}

create_vm_package_list() {

}

add_to_package_list() {
  PACKAGE_LIST=$PACKAGE_LIST" $1"
}

chroot_desktop() {
  cat <<EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $PASSWORD; echo $PASSWORD; } | passwd
useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo $HOSTNAME >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $USERNAME -R /home/$USERNAME/
EOF
}

chroot_laptop() {
  cat <<EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $PASSWORD; echo $PASSWORD; } | passwd
useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo $HOSTNAME >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $USERNAME -R /home/$USERNAME/

gpasswd -a $USERNAME bumblebee
systemctl enable bumblebeed.service
EOF
}

chroot_vm() {
  cat <<EOF | arch-chroot /mnt
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg
{ echo $PASSWORD; echo $PASSWORD; } | passwd
useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo $HOSTNAME >> /etc/hostname
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo pt_BR ISO-8859-1 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $USERNAME -R /home/$USERNAME/
EOF
}

main

# start/enable iwd.service
# iwctl
# device list
# station interface scan
# station interface connect network_name
# device interface show

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

  echo -n "Setting the keyboard..."
  loadkeys br-abnt2
  echo "done."

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

  update_mirrors

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
    umount $LINUX_PARTITION
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

update_mirrors() {
  CONTENT=$(cat /etc/pacman.d/mirrorlist)
  BRMIRRORS=$(awk '/## Brazil/{getline; print}' /etc/pacman.d/mirrorlist)
  echo "$BRMIRRORS" >/etc/pacman.d/mirrorlist
  echo "$CONTENT" >>/etc/pacman.d/mirrorlist
}

create_programs_package_list() {

  #Current shell
  add_to_package_list fish

  #Current terminal emulator
  add_to_package_list termite

  #Window manager and bar
  add_to_package_list dmenu
  add_to_package_list i3lock
  add_to_package_list perl-anyevent-i3
  add_to_package_list perl-json-xs
  add_to_package_list i3-gaps
  add_to_package_list alsa-utils
  add_to_package_list i3blocks

  #Appearance
  add_to_package_list xcursor-bluecurv
  add_to_package_list papirus-icon-theme
  add_to_package_list arc-solid-gtk-theme

  #Fonts
  add_to_package_list ttf-inconsolata
  add_to_package_list ttf-croscore
  add_to_package_list noto-fonts-emoji
  add_to_package_list awesome-terminal-fonts

  #General programs and tools
  add_to_package_list compton			# Screen compositor
  add_to_package_list xwallpaper		# X utility for setting wallpaper
  add_to_package_list libnotify
  add_to_package_list flameshot                 # Screen-shot capture tool
  add_to_package_list dunst
  add_to_package_list xdotool
  add_to_package_list telegram-desktop
  add_to_package_list when                      # Calendar
  add_to_package_list calc                      # Calculator
  add_to_package_list sxiv			# Simple X image viwer
  add_to_package_list ntfs-3g
  add_to_package_list rsync
  add_to_package_list htop
  add_to_package_list neofetch
  add_to_package_list vifm
  add_to_package_list tldr
  add_to_package_list neovim
  add_to_package_list git
  add_to_package_list polkit
  add_to_package_list imagemagick
  add_to_package_list scrot
  add_to_package_list pacman-contrib
  add_to_package_list ncdu
  add_to_package_list vnstat
  add_to_package_list firefox
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
  add_to_package_list base
  add_to_package_list base-devel
  add_to_package_list grub
  add_to_package_list os-prober
  add_to_package_list virtualbox-guest-modules-arch
  add_to_package_list virtualbox-guest-utils
  add_to_package_list xorg
  add_to_package_list xorg-xinit

  create_programs_package_list
}

add_to_package_list() {
  PACKAGE_LIST=$PACKAGE_LIST" $1"
}

chroot_desktop() {
  cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
echo $HOSTNAME > /etc/hostname
{ echo $PASSWORD; echo $PASSWORD; } | passwd

useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=archlinux
grub-mkconfig -o /boot/grub/grub.cfg

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
chown $USERNAME -R /home/$USERNAME/
EOF
}

chroot_laptop() {
  cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
echo $HOSTNAME > /etc/hostname
{ echo $PASSWORD; echo $PASSWORD; } | passwd

echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Identifier "system-keyboard"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'MatchIsKeyboard "on"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbLayout" "br"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbModel" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbVariant" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf

useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

grub-install --target=x87_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/#Color/Color/g' /etc/pacman.conf

gpasswd -a $USERNAME bumblebee
systemctl enable bumblebeed.service

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
bash /home/$USERNAME/scripts/autorice.sh $USERNAME $HOSTNAME
chown $USERNAME -R /home/$USERNAME/
chgrp $USERNAME -R /home/$USERNAME/

systemctl enable iwd.service
systemctl enable dhcpcd@wlp3s0.service
systemctl enable vnstat.service

EOF
}

chroot_vm() {
  cat <<EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Campo_Grande /etc/localtime
hwclock --systohc
echo pt_BR.UTF-8 UTF-8 >> /etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
echo $HOSTNAME > /etc/hostname
{ echo $PASSWORD; echo $PASSWORD; } | passwd

echo 'Section "InputClass"' > /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Identifier "system-keyboard"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'MatchIsKeyboard "on"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbLayout" "br"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbModel" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'Option "XkbVariant" "abnt2"' >> /etc/X11/xorg.conf.d/00-keyboard.conf
echo 'EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf

useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/#Color/Color/g' /etc/pacman.conf

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
bash /home/$USERNAME/scripts/autorice.sh $USERNAME $HOSTNAME
chown $USERNAME -R /home/$USERNAME/
chgrp $USERNAME -R /home/$USERNAME/

systemctl enable dhcpcd
systemctl enable vboxservice.service

exit
EOF
}

main

#pacman --noconfirm --needed -S $PACKAGE_LIST
#pacman --noconfirm --needed -S reflector
#reflector --sort rate --save /etc/pacman.d/mirrorlist -c "Brazil" -f 5 -l 5
# { echo 2; echo y; } | pacman -S virtualbox-guest-utils
# start/enable iwd.service
# iwctl
# device list
# station interface scan
# station interface connect network_name
# device interface show

#X11 errors and warnings

#keyboard
#keys above 255 or error, comment the lines in /usr/share/X11/xkb/symbols/inet example <I372> or XF86MonBrightnessCycle

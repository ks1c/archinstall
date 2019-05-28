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

  rm -rf /mnt/boot/ini*
  rm -rf /mnt/boot/vmlinuz-linux
  rm -rf /mnt/boot/grub
  rm -rf /mnt/boot/EFI/GRUB

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
  add_to_package_list fish			# Shell with completions and suggestions

  #Current terminal emulator
  add_to_package_list termite			# Terminal emulator

  #Window manager and bar
  add_to_package_list dmenu			# Program launcher and so much more
  add_to_package_list i3lock			# Lock screen
  add_to_package_list perl-anyevent-i3		# I3 dependency
  add_to_package_list perl-json-xs		# I3 dependency
  add_to_package_list i3-gaps 			# Tilling window manager
  add_to_package_list alsa-utils		# Controls volume
  add_to_package_list i3blocks			# Bar

  #Appearance
  add_to_package_list xcursor-bluecurve		# Mouse cursor theme
  add_to_package_list papirus-icon-theme	# Icon theme
  add_to_package_list arc-solid-gtk-theme	# Gtk theme

  #Fonts
  add_to_package_list ttf-inconsolata           # My monospace font of preference
  add_to_package_list ttf-croscore		# Google serif/sans fonts
  add_to_package_list noto-fonts-emoji		# Emoji fonts
  add_to_package_list awesome-terminal-fonts	# Symbols/glyphs for bars, etc
  add_to_package_list powerline-fonts		# Font for statusline in vim
  add_to_package_list noto-fonts		# Extra symbols used for statusline in vim

  #General programs and tools
  add_to_package_list compton			# Screen compositor
  add_to_package_list xwallpaper		# X utility for setting wallpaper
  add_to_package_list libnotify			# Send notifications
  add_to_package_list dunst			# Notification server
  add_to_package_list xdotool			# Fake keyboard/mouse input
  add_to_package_list xclip			# Clipboard manager
  add_to_package_list when                      # Calendar
  add_to_package_list calc                      # Calculator
  add_to_package_list sxiv			# Simple X image viwer
  add_to_package_list ntfs-3g			# MS NTFS implementation
  add_to_package_list exfat-utils		# Exfat implementation
  add_to_package_list rsync			# File transfer utility
  add_to_package_list htop			# System monitor
  add_to_package_list neofetch			# System fetch
  add_to_package_list vifm			# Terminal based file manager
  add_to_package_list ffmpegthumbnailer		# Video preview on file manager
  add_to_package_list lsd			# Cool ls replacement
  add_to_package_list tldr			# Summarizes man pages
  add_to_package_list neovim 			# Text editor
  add_to_package_list git			# Version control
  add_to_package_list polkit			# Controls system wide privileges
  add_to_package_list imagemagick		# Image manipulation tool
  add_to_package_list scrot			# Used in lock screen
  add_to_package_list pacman-contrib		# Used in checkupdates
  add_to_package_list ncdu			# Disk utility
  add_to_package_list vnstat			# Network traffic monitor
}

create_desktop_package_list() {
  add_to_package_list base
  add_to_package_list base-devel
  add_to_package_list linux-headers
  add_to_package_list grub
  add_to_package_list efibootmgr
  add_to_package_list os-prober
  add_to_package_list nvidia-dkms
  add_to_package_list nvidia-settings
  add_to_package_list broadcom-wl-dkms
  add_to_package_list xorg
  add_to_package_list xorg-xinit
  add_to_package_list dialog
  add_to_package_list wpa_supplicant

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
  add_to_package_list acpi
  add_to_package_list dialog
  add_to_package_list wpa_supplicant

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

grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/#Color/Color/g' /etc/pacman.conf

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
git clone https://aur.archlinux.org/yay.git
echo "exec /home/$USERNAME/scripts/autorice.sh -u=$USERNAME -h=$HOSTNAME --post-installation" \
> /home/$USERNAME/.bash_profile
chown $USERNAME -R /home/$USERNAME/
chgrp $USERNAME -R /home/$USERNAME/

systemctl enable vnstat.service

exit
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
echo $HOSTNAME > /etc/hostname
{ echo $PASSWORD; echo $PASSWORD; } | passwd

useradd -m -G wheel $USERNAME
{ echo $PASSWORD; echo $PASSWORD; } | passwd $USERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/#Color/Color/g' /etc/pacman.conf

gpasswd -a $USERNAME bumblebee
systemctl enable bumblebeed.service

cd /home/$USERNAME/
git clone http://github.com/ks1c/scripts
git clone http://github.com/ks1c/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
git clone https://aur.archlinux.org/yay.git
echo "exec /home/$USERNAME/scripts/autorice.sh -u=$USERNAME -h=$HOSTNAME --post-installation" \
> /home/$USERNAME/.bash_profile
chown $USERNAME -R /home/$USERNAME/
chgrp $USERNAME -R /home/$USERNAME/

systemctl enable vnstat.service

exit
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
git clone https://aur.archlinux.org/yay.git
git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
echo "exec /home/$USERNAME/scripts/autorice.sh -u=$USERNAME -h=$HOSTNAME --post-installation" \
> /home/$USERNAME/.bash_profile
chown $USERNAME -R /home/$USERNAME/
chgrp $USERNAME -R /home/$USERNAME/

systemctl enable dhcpcd.service
systemctl enable vboxservice.service

exit
EOF
}

main

#systemctl enable rngd.service
#keyboard
#keys above 255 or error, comment the lines in /usr/share/X11/xkb/symbols/inet example <I372> or XF86MonBrightnessCycle

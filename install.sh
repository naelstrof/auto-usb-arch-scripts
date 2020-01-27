#!/bin/bash

# init ---------------------------------------------------
# /dev/sdb
_drive=$1
_name=$2

# /dev/sdb2
_boot=${_drive}2
# EFI folder tends to require ~50mb
_bootsize=4G
# /dev/sdb3
_root=${_drive}3
# --------------------------------------------------------

# sanity checking ----------------------------------------
# exit on error
set -e
# make sure we're root
if [[ $EUID -ne 0 ]]; then
    echo "You must be a root user to run this." 2>&1
    exit 1
fi
# make sure drive exists
if [[ ! -b "${_drive}" ]]; then
    echo "Block device ${_drive} not found, or is not a block device!" 2>&1
    echo "Usage: ${0} /dev/sdX hostname" 2>&1
    exit 1
fi
# make sure _name exists
if [[ -z "${_name}" ]]; then
    echo "Usage: ${0} /dev/sdX hostname" 2>&1
    exit 1
fi 

if [[ -z "${_filetype}" ]]; then
    _filetype="ext4"
fi

# make sure specified drive isn't mounted anywhere
if [[ ! -z "$(cat /proc/mounts | grep ${_drive})" ]]; then
    echo "${_drive} must be unmounted before trying to run this!" 2>&1
    exit 1
fi
# make sure we have all our tools installed
if [[ -z "$( pacman -Q | grep dosfstools )" ]]; then
    pacman -S dosfstools --noconfirm
fi
if [[ -z "$( pacman -Q | grep exfat-utils )" ]]; then
    pacman -S exfat-utils --noconfirm
fi
if [[ -z "$( pacman -Q | grep exfat-utils )" ]]; then
    pacman -S exfat-utils --noconfirm
fi
if [[ -z "$( pacman -Q | grep arch-install-scripts )" ]]; then
    pacman -S arch-install-scripts --noconfirm
fi
# --------------------------------------------------------

# partition it -------------------------------------------
# We don't scriptify this so that user can get a warning that the drive is going bye-bye
parted ${_drive} mklabel gpt
# 1 grub_bios
parted --script ${_drive} -a optimal mkpart primary ext4 0M 5M
# 2 efi and /boot
parted --script ${_drive} -a optimal mkpart ESP fat32 5M ${_bootsize}
# 3 /
parted --script ${_drive} -a optimal mkpart primary ext4 ${_bootsize} 100%

parted --script ${_drive} set 1 bios_grub on
parted --script ${_drive} set 2 boot on
sync
# --------------------------------------------------------

# mkfs ---------------------------------------------------
# fat32 has no journaling I think
mkfs.vfat -F 32 -n BOOT ${_boot}
# -F forces mkfs to make a fs here
mkfs.ext4 -F -O ^has_journal ${_root}

sync

# --------------------------------------------------------

# mount it -----------------------------------------------
mount ${_root} -o noatime /mnt
mkdir /mnt/boot
mount ${_boot} /mnt/boot
# --------------------------------------------------------

# install it ---------------------------------------------
pacstrap -c /mnt base base-devel gnome grub xf86-video-intel xf86-video-nouveau xf86-video-ati xf86-input-synaptics vim efibootmgr intel-ucode networkmanager linux linux-headers linux-firmware mkinitcpio
# --------------------------------------------------------

# configure it -------------------------------------------
genfstab -pU /mnt >> /mnt/etc/fstab
#sed -i 's/relatime/compress=lzo,noatime,ssd/g' /mnt/etc/fstab
cp $(pwd)/configure.sh /mnt
cp $(pwd)/visudo_editor.sh /mnt
chmod +x /mnt/configure.sh
chmod +x /mnt/visudo_editor.sh
arch-chroot /mnt /configure.sh ${_drive} ${_name}
rm /mnt/configure.sh
rm /mnt/visudo_editor.sh
# --------------------------------------------------------

echo "All done! Attemping unmount..."

# finish up!
sync
umount ${_boot}
umount ${_root}
sync

echo "You may now remove the USB."

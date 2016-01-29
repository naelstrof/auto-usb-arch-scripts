#Arch Linux USB Automatic Install Script

These nifty scripts will install a working Arch Linux installation onto a USB with little to no intervention.

##Features

* It comes equipped with gnome, vim, video drivers, and synaptics.
* Configures a wheel user, and gives it sudo access.
* Works with EFI and BIOS systems.
* Disables autodetect for ramdisk generation.
* Disables filesystem journaling, and enables noatime for efficient SSD writes.
* Automatically enables GDM, and NetworkManager.
* Capable of ext4 and btrfs filesystem configuration.
* Configures a LZO compressed btrfs filesystem.
* Disables CoW for journal logs and limits their size to 8M.

## Issues

* Parted doesn't automatically align partitions optimally, non-issue for USB's afaik.

## Usage

``` bash
git clone git@github.com:naelstrof/auto-usb-arch-scripts.git
cd auto-usb-arch-scripts
sudo su
./install.sh /dev/sdb MyCoolComputerName [btrfs,ext4]
```

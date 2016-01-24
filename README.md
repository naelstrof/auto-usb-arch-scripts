#Arch Linux USB Automatic Install Script
---------------------------------------
These nifty scripts will install a working Arch Linux installation onto a USB with little to no intervention.

##Features

* It comes equipped with gnome, vim, video drivers, and synaptics.
* Configures a wheel user, and gives it sudo access.
* Works with EFI and BIOS systems.
* Disables autodetect for ramdisk generation.
* Disables journaling, and enables noatime for efficient SSD writes.
* Automatically enables GDM, and NetworkManager.

## Issues

* Parted doesn't automatically align partitions optimally, non-issue for USB's afaik.

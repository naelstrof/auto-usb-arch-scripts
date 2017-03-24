# Arch Linux USB Automatic Install Script

These nifty scripts will install a working Arch Linux installation onto a USB with little to no intervention.

## Features

* It comes equipped with gnome, vim, video drivers, and synaptics.
* Configures a wheel user, and gives it sudo access.
* Works with EFI and BIOS systems.
* Disables autodetect for ramdisk generation, so ramdisk is BIG but works on EVERYTHING.
* Disables filesystem journaling, and enables noatime for efficient SSD writes.
* Automatically enables GDM, and NetworkManager.

## Practical Usage

Get around security features on public computers by booting into your own linux installation.
Create a easy throw-away dual boot stick, as a rescue disk, or for quick school work.
Quickly manufacture multiple arch sticks with Dota 2 installed and have a portable lan-party at some public computers.

## Issues

* Parted doesn't automatically align partitions optimally, non-issue for USB's afaik.

## Prerequisites

There is no prerequisites, the script will automatically install any needed.

## Installation

**Make sure you follow instructions exactly!**
You can't just sudo the script, since it does some goofy piping and editor magic.

``` bash
git clone git@github.com:naelstrof/auto-usb-arch-scripts.git
cd auto-usb-arch-scripts
sudo su
./install.sh /dev/sdX MyCoolComputerName
```

You'll eventually be prompted for a username and password.

# Fedora on Pinebook

## Overview

This doesn't work. I am still trying to get it to work.

## Steps

```bash
ip addr
nmcli r wifi on
nmcli d wifi list
nmcli d wifi connect ************ password **********
sudo apt-get update
sudo apt install gnome-shell gnome-terminal gnome-tweaks gnome-session gdm3 xinit xserver-xorg
systemctl set-default graphical.target

systemctl set-default multi-user.target

sudo dnf install arm-image-installer

curl -kO <https://download.fedoraproject.org/pub/fedora-secondary/releases/31/Spins/aarch64/images/Fedora-Minimal-31-1.9.aarch64.raw.xz>

sudo arm-image-installer --addconsole --image=downloads/Fedora-Minimal-31-1.9.aarch64.raw.xz --resizefs --media=/dev/sdc

sudo chroot /media/*/<main_partition>

vi /etc/resolv.conf
```

```text
# Generated by NetworkManager

nameserver 8.8.8.8
nameserver 8.8.4.4
```

```bash
dnf grouplist -v

passwd

sudo dnf install @base-x

dnf install gnome-shell gnome-session

sudo dnf install gnome-terminal adobe-source-code-pro-fonts gnome-tweaks terminator

sudo dnf install uboot-images-armv8.noarch uboot-tools

```

### write uboot

```bash
echo "= Writing SPL ...."

dd if=$PREFIX/usr/share/uboot/$TARGET/spl.img of=$MEDIA seek=64; sync; sleep 5

echo "= Writing u-boot FIT image ...."

dd if=$PREFIX/usr/share/uboot/$TARGET/u-boot.itb of=$MEDIA seek=512; sync; sleep 5
```

### set console for Rockchips

```bash
SYSCON=ttyS2,115200

sudo dd if=idbloader.img of=/dev/mmcblkX bs=512 seek=64
```

## Write to EMMC

```bash
xzcat fedora-pinebookpro-gnome-0.8.img.xz | dd bs=4M of=/dev/mmcblkX iflag=fullblock oflag=direct status=progress; sync
```
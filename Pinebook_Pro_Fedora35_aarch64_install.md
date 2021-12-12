# Pinebook Pro Fedora 35 Install

This used to be tricky. It is no longer so. Just use the
[pinebook-pro-fedora-installer](https://github.com/bengtfredh/pinebook-pro-fedora-installer)
from Bengt.

## Instructions

Install Deps

```bash
sudo dnf install -y \
    bash \
    bsdtar \
    dialog \
    gawk \
    libarchive \
    openssl \
    polkit \
    qemu-user-static \
    util-linux \
    systemd-container \
    wget
```

You will also need the following:

- an empty SD/eMMC card (16GB+) plugged in not mounted.
- sudo priveledges

```bash
git clone https://github.com/bengtfredh/pinebook-pro-fedora-installer
cd pinebook-pro-fedora-installer
chmod +x fedora-installer
sudo bash ./fedora-installer https://fedora.uib.no/fedora/linux/releases/35/Workstation/aarch64/images/Fedora-Workstation-35-1.2.aarch64.raw.xz
```

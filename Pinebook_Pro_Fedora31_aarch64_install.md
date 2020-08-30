# Fedora 31 aarch64 Development Machine

## Install

```bash
curl -sL https://sourceforge.net/projects/opensuse-on-pinebookpro/files/Rel_2/fedora-pinebookpro-gnome-0.8.img.xz
```

```bash
xzcat fedora-pinebookpro-gnome-0.8.img.xz | dd bs=4M of=/dev/mmcblk<X> iflag=fullblock oflag=direct status=progress; sync
```

The root password is `linux`.

Instructions are here <https://sourceforge.net/projects/opensuse-on-pinebookpro/files/Rel_2/>

```bash
md5sum fedora-pinebookpro-gnome-0.8.img.xz
```

`454711034b4698c4312dd5f7b1dfcada  fedora-pinebookpro-gnome-0.8.img.xz`


## Sudo

```bash
sudo visudo
```

```bash
# Allow member of wheel to do stupid things
%wheel  ALL=(ALL)       NOPASSWD: ALL
```

```bash
sudo usermod -aG wheel $USER
```

```bash
sudo su -
export NEWUSER=<foo>
groupadd $NEWUSER
useradd -m -g $NEWUSER -G wheel -s /bin/bash -d /home/$NEWUSER $NEWUSER
passwd $NEWUSER
```

## Install basics

```bash
sudo dnf install -y \
    rpm-build \
    rpm-python \
    redhat-rpm-config \
    rpmdevtools \
    fakeroot \
    gcc \
    gcc-c++ \
    clang \
    make \
    cmake \
    vim-enhanced \
    bzip2-devel \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    readline \
    zlib-devel \
    unzip \
    zip \
    p7zip
```


## Install golang

```bash
curl -O https://dl.google.com/go/go1.14.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.14.linux-arm64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version
```

```bash
mkdir -p ~/go/{src,bin}
```

```bash
cat >> ~/.bashrc << EOF
# GO VARIABLES
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin
export PATH=\$PATH:/usr/local/go/bin

EOF
```

```bash
go get -u golang.org/x/tools/...
go get -u golang.org/x/lint/golint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.23.2
```

## Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

## Install Python Things

```bash
sudo dnf install -y python3-pyyaml \
    python3-devel \
    python3-pip \
    python3-jinja2  \
    python3-tools  \
    python3-virtualenvwrapper \
    python3-virtualenv \
    python3-pytest \
    python3-tox \
    python3-mock
```

## Install Docker


### Create a partition (optional)

```bash
lsblk
df -Th
swapoff /dev/mapper/fedora-swap
pvdisplay
lvdisplay
lvcreate -L75GB -n docker fedora
lsblk
mkdir /var/lib/docker
mkfs.ext4 /dev/mapper/fedora-docker
echo "/dev/mapper/fedora-docker /var/lib/docker       ext4	defaults        0 0" >> /etc/fstab
mount /var/lib/docker/
```

### Temporary workaround CgroupsV2

Not Working yet because image uses extlinux. Please Skip these steps until I have it working

vi /boot/extlinux/extlinux.conf

```bash
sudo vim /etc/default/grub
```

Append value of GRUB_CMDLINE_LINUX with systemd.unified_cgroup_hierarchy=0

```bash
sudo grub2-mkconfig > /boot/efi/EFI/fedora/grub.cfg
```

or

```bash
sudo grub2-mkconfig > /boot/grub2/grub.cfg
```

```bash
reboot
```

### Install Upstream

```bash
sudo dnf install -y moby-engine

sudo usermod -aG docker <user>
```

Open docker daemon to tcp connections (Optional) 

**USE AT OWN RISK** Insecure Silliness

```bash
sudo su -

mkdir /etc/docker

cat > /etc/docker/daemon.json << EOF
{
"debug": true,
"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]
}

EOF

sed -i 's~dockerd -H fd://~dockerd~g' /lib/systemd/system/docker.service

systemctl daemon-reload
```

End Insecure Silliness

```bash
sudo systemctl enable docker.service

sudo systemctl start docker.service

docker run hello-world
```

## Install Java

```bash
sudo dnf install -y java
```

## Add to the bottom of your .bashrc

```bash
# PYTHON Vars
export PYTHONSTARTUP=~/.pythonrc

source ~/.git-completion.bash
source ~/.screen-completion.bash

# GRADLE
export GRADLE_USER_HOME=~/.gradle

# JAVA
export JAVA_BIN=$(readlink -f $(which java))
export JAVA_HOME=${JAVA_BIN%%/bin/java}

# GO VARIABLES
export GOPATH=/home/$USER/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:/usr/local/bin/go/bin
```

## Add a .pythonrc

```bash
cat > .pythonrc << EOF
# enable syntax completion
try:
    import readline
except ImportError:
    print("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")

EOF
```

## Python Virtual env

```bash
mkdir -p ~/.virtualenvs
/usr/local/bin/python3.7 -m venv ~/.virtualenvs/foobar
source ~/.virtualenvs/foobar/bin/activate

pip install --upgrade pip setuptools pbr six setuptools wheel pkg_resources functools32
pip install --upgrade rfc3987 enum34 PyYAML stevedore jsonschema Jinja2  docker
pip install --upgrade autopep8 flake8 tox black isort pdbpp
```

## Python formater script

```bash
cat > ~/bin/format_python << EOF
#!/bin/bash
isort --atomic --apply --recursive "${@}"
black --line-length=120 "${@}"
flake8 --max-line-length=120 "${@}"

EOF

chmod +x ~/bin/format_python
```


## Remove Packagekit

```bash
sudo systemctl status packagekit

sudo systemctl stop packagekit

sudo systemctl mask packagekit

sudo dnf remove PackageKit*
```

```bash
sudo dnf install ostree gnome-initial-setup flatpak-libs efivar-libs appstream-data libxmlb fwupd
```

# Install Codium

```bash
sudo dnf install libXScrnSaver
```

```bash
curl -sLO https://github.com/VSCodium/vscodium/releases/download/1.42.1/VSCodium-linux-arm64-1.42.1.tar.gz
```

```bash
mkdir -p /usr/local/codium
```

```bash
sudo tar -C /usr/local/codium -xzvf VSCodium-linux-arm64-1.42.1.tar.gz
```

```bash
cd /usr/local/bin
sudo ln -sf ../codium/bin/codium .
```



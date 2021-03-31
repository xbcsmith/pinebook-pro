# Fedora 32 Pinebook Pro Dev Machine

## Create Image

Install deps

```bash
sudo dnf install  -y  \
    systemd-container \
    bash \
    wget \
    dialog \
    libarchive \
    qemu-user-static \ 
    openssl \
    gawk \
    polkit \
    dialog \
    bsdtar
```

**note:** on archlinux: binfmt-qemu-static

Clone and run the installer script

```bash
git clone https://github.com/bengtfredh/pinebook-pro-fedora-installer
cd pinebook-pro-fedora-installer
chmod +x fedora-installer
sudo bash ./fedora-installer
```

reboot

## Sudo

```bash
sudo visudo
```

```bash
%wheel  ALL=(ALL)       NOPASSWD: ALL # Allow member of wheel to do stupid things
```

## Remove Excess Packages

```bash
sudo rpm -e $(rpm -qa | grep libreoffice) unoconv
```

```bash
sudo dnf remove \
    gnome-maps \
    gnome-clocks \
    gnome-getting-started-docs \
    gnome-contacts \
    gnome-boxes \
    gnome-weather \
    gnome-software \
    totem
```

## Install basics

```bash
sudo dnf install -y \
    rpm-build \
    rpm-python3 \
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
    qemu \
    unzip \
    zip \
    p7zip
```

```bash
sudo dnf install -y \
   terminator \
   gnome-tweaks \
   tigervnc
```

## GO

```bash
export GOVERSION=1.16.2
export GOARCH=arm64
curl -kLO https://dl.google.com/go/go${GOVERSION}.linux-${GOARCH}.tar.gz
sudo rm -rfv /usr/local/go
sudo tar -C /usr/local/ -xvzf go${GOVERSION}.linux-${GOARCH}.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version
rm -v go${GOVERSION}.linux-${GOARCH}.tar.gz

mkdir -p ~/go/{src,bin}

cat >> ~/.bashrc << EOF
# GO VARIABLES
export GOPATH=\$HOME/go
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin

EOF

go clean -modcache

go get -u -v github.com/oklog/ulid/v2/cmd/ulid

go get -u -v golang.org/x/tools/...
go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v golang.org/x/lint/golint
go get -u -v github.com/fzipp/gocyclo
go get -u -v github.com/uudashr/gocognit/cmd/gocognit
go get -u -v github.com/go-critic/go-critic/cmd/gocritic
go get -u -v github.com/wadey/gocovmerge
go get -u -v github.com/axw/gocov/gocov
go get -u -v github.com/AlekSi/gocov-xml
go get -u -v github.com/tebeka/go2xunit
go get -u -v github.com/go-bindata/go-bindata/...
go get -u -v github.com/josephspurrier/goversioninfo/cmd/goversioninfo
go get -u -v github.com/golang/protobuf/protoc-gen-go

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.38.0

```

## Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

## Docker (optional)

```bash
sudo dnf install -y moby-engine
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

## Install Python Things

```bash
sudo dnf install -y \
    python3-devel \
    python3-pip \
    python3-jinja2  \
    python3-tools  \
    python3-virtualenvwrapper \
    python3-virtualenv \
    python3-pytest \
    python3-pyyaml \
    python3-ruamel-yaml-clib \
    python3-ruamel-yaml \
    python3-flake8 \
    python3-tox \
    python3-isort \
    python3-mock \
    black
```

## Install Java (optional)

```bash
sudo dnf install -y java
```

## NPM

```bash
sudo dnf install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo dnf install nodejs yarn
```

## Linter

```bash
npm install --save remark-cli remark-preset-lint-recommended markdownlint-cli prettier
npm install --save @commitlint/cli @commitlint/config-conventional
```

## Git Config

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor vim
git config --global pull.rebase true
```

```bash
git config --global alias.st status
git config --global alias.last "log -1 HEAD"
git config --global alias.br "branch -r"
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.unstage "reset HEAD --"
git config --global alias.b branch
git config --global alias.t "tag --list -n"
git config --global alias.cb "checkout -b"
git config --global alias.can "commit --amend --no-edit"
git config --global alias.lt "describe --tags"
git config --global alias.pl "pull --rebase --autostash"
```

## bashrc

Add to the bottom of your .bashrc

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

# RUST
export CARGOBIN=/home/bsmith/.cargo/bin
export PATH=$PATH:$CARGOBIN

# SNAPD
export PATH=$PATH:/home/bsmith/snap/bin

# NPM
export PATH=$PATH:/home/bsmith/node_modules/.bin
```

## pythonrc

Add a .pythonrc

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
python3 -m venv ~/.virtualenvs/foobar
source ~/.virtualenvs/foobar/bin/activate

pip install --upgrade pip setuptools
pip install --upgrade pbr six wheel pkg_resources functools32
pip install --upgrade rfc3987 PyYAML stevedore jsonschema Jinja2 docker
pip install --upgrade autopep8 flake8 tox black isort pdbpp
```

## Python format script

```bash
cat > ~/bin/format_python << EOF
#!/bin/bash
isort --atomic "${@}"
black --line-length=120 "${@}"
flake8 --max-line-length=120 "${@}"

EOF

chmod +x ~/bin/format_python
```

## Hack Sleep

```bash
sudo sed -i s/"#AllowHibernation=yes"/"AllowHibernation=no"/g /etc/systemd/sleep.conf

sudo sed -i s/"#SuspendState=mem standby freeze"/"SuspendState=mem"/g /etc/systemd/sleep.conf
```

## Atom IDE

```bash
sudo dnf install -y libXScrnSaver
```

```bash
curl -sLO https://github.com/xbcsmith/pinebook-pro/releases/download/v0.1.0/atom-1.48.0-1-aarch64.pkg.tar.xz
```

```bash
tar -xvf -C / atom-1.48.0-1-aarch64.pkg.tar.xz
```

```bash
cd /usr/local/bin && sudo ln -sf /usr/local/lib/atom/atom
```

```bash
# TODO make an rpm...

curl -kL -o atom_256.png https://github.com/atom/atom/raw/master/resources/app-icons/stable/png/256.png

echo "[Desktop Entry]" > atom.desktop
echo "Type=Application" >> atom.desktop
echo "Encoding=UTF-8" >> atom.desktop
echo "Name=atom" >> atom.desktop
echo "Comment=The hackable text editor" >> atom.desktop
echo "Exec=/usr/local/lib/atom/atom" >> atom.desktop
echo "Icon=atom.png" >> atom.desktop
echo "Categories=Development;IDE;TextEditor;Atom" >> atom.desktop
echo "Terminal=false" >> atom.desktop


sudo cp atom_256.png /usr/share/icons/atom.png
sudo cp atom.desktop /usr/share/applications/atom.desktop
```

## Nautilus

Edit default folders

```bash
sudo vim /etc/xdg/user-dirs.defaults
```

```bash
vim ~/.config/user-dirs.dirs
rm -rf Downloads/ Music/ Public/ Templates/ Videos/ Pictures/ Desktop/ Documents/
mkdir ~/downloads
```

or

```bash
sudo echo -en "DOWNLOAD=downloads\n" > /etc/xdg/user-dirs.defaults
echo -en "DOWNLOAD=downloads\n" > ~/.config/user-dirs.dirs
rm -rf Downloads/ Music/ Public/ Templates/ Videos/ Pictures/ Desktop/ Documents/
mkdir -p ~/downloads
```

## rpmfusion

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

```bash
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel lame vlc mplayer mpv
```

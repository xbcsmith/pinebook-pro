# Ubuntu 20.04 Dev Machine

- [Editor](#Editor)
- [Sudo](#sudo)
- [Update](#update)
- [Update /etc/issue](#update-etcissue)
- [Gnome](#gnome)
- [GO](#go)
- [Rust](#rust)
- [Docker](#docker)
- [Devel Pkgs](#devel-pkgs)
- [Python](#python)
- [Virtual Env](#virtual-env)
- [Nautilus](#nautilus)
- [VSCodium](#vscodium)
- [Git Aliases](#git-aliases)
- [Lint](#lint)
- [Pre Commit](#pre-commit)
- [Sound](#sound)
- [Sleep](#hack-sleep)

## Editor

_Always **vim**_

```bash
sudo update-alternatives --config editor
```

## Sudo

```bash
sudo visudo
```

```bash
%wheel  ALL=(ALL)       NOPASSWD: ALL # Allow member of wheel to do stupid things
```

```bash
sudo groupadd wheel
```

```bash
sudo usermod -aG sudo $USER
sudo usermod -aG wheel $USER
```

```bash
sudo su -
export NEWUSER=<foo>
groupadd $NEWUSER
useradd -m -g $NEWUSER -G wheel -s /bin/bash -d /home/$NEWUSER $NEWUSER
passwd $NEWUSER
```

## Update

```bash
sudo apt update
sudo apt upgrade
```

## Update /etc/issue

Display the IP address

```bash
echo -en "IP: \4\n" >> /etc/issue
```

## Gnome

```bash
sudo apt install vanilla-gnome-desktop
sudo apt install nautilus gnome-tweaks
```

## GO

```bash
export GOVERSION=1.14.6
curl -kLO https://dl.google.com/go/go${GOVERSION}.linux-arm64.tar.gz
sudo rm -rfv /usr/local/go
sudo tar -C /usr/local/ -xvzf go${GOVERSION}.linux-arm64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version
rm -v go${GOVERSION}.linux-arm64.tar.gz

mkdir -p ~/go/{src,bin}

cat >> ~/.bashrc << EOF
# GO VARIABLES
export GOPATH=\$HOME/go
export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin

EOF

go get github.com/oklog/ulid/cmd/ulid
go get -u golang.org/x/tools/...
go get -u golang.org/x/lint/golint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.27.0

## Most people don't need go-critic as it comes with golangci-lint
## I probably don't really need it locally either...
go get -v -u github.com/go-critic/go-critic/cmd/gocritic

```

## Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

## Docker

```bash
export ARM="arm64"
sudo apt remove docker docker-engine docker.io
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=${ARM}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
sudo apt update
sudo apt install docker-ce
```

### Expose port to world... seems safe

I use the RockPro64 as a remote docker host for arm64 containers
so it is convienent to be able to access it from my x86_64 box
without a direct ssh connection.

The following is not recomended.

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
sed -i 's~StartLimitInterval=60s~StartLimitInterval=60s\nIPForward=yes\n~g' /lib/systemd/system/docker.service
```

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker
```

```bash
docker run --rm -it hello-world
```

## Devel Pkgs

```bash
sudo apt -y update && sudo apt -y install \
    build-essential \
    devscripts \
    fakeroot \
    debhelper \
    dpkg-dev \
    automake \
    autotools-dev \
    autoconf \
    libtool \
    systemtap-sdt-dev \
    libssl-dev \
    m4 \
    bison \
    flex \
    opensp \
    xsltproc \
    gettext \
    libyaml-dev \
    unzip \
    wget \
    pkg-config \
    libguestfs-tools \
    zip

```

## Python

```bash
sudo apt -y update && sudo apt -y install \
    libpython3-dev \
    python3-dev \
    virtualenvwrapper \
    virtualenv \
    python3-mock \
    python3-venv \
    flake8 \
    isort \
    black \
    tox


```

### Virtual Env

```bash
mkdir -p ~/.virtualenvs
PYTHON3=$(which python3.8)
$PYTHON3 -m venv ~/.virtualenvs/foo
source ~/.virtualenvs/foo/bin/activate

pip install --upgrade pip setuptools pbr wheel pip pkg_resources docker
pip install --upgrade rfc3987 enum34 PyYAML stevedore jsonschema Jinja2
pip install --upgrade autopep8 flake8 tox black isort pdbpp
```

```bash
cp /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh ~/.virtualenvwrapper_lazy.sh
echo "source ~/.virtualenvwrapper_lazy.sh" >> .bashrc
```

## NPM

```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install nodejs yarn
```

## Nautilus

```bash
sudo vim /etc/xdg/user-dirs.defaults
```

```bash
vim ~/.config/user-dirs.dirs
rm -rf Downloads/ Music/ Public/ Templates/ Videos/ Pictures/ Desktop/ Documents/
mkdir ~/downloads
```

## VSCodium

<https://github.com/VSCodium/vscodium/releases>

<https://github.com/VSCodium/vscodium/releases/download/1.45.1/codium_1.45.1-1589539619_arm64.deb>

## Git Aliases

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
git config --global alias.pl "pull --rebase"
```

## Lint

```bash
sudo apt install yamllint shellcheck
npm install markdownlint-cli
npm install commitlint
```

## Pre-Commit

```bash
workon foo
pip install pre-commit
```

## Sound

Open alsamixer from terminal and turn up Headphone and Headphone Mixer
unmute `Left Headphone Mixer Left DAC` and `Right Headphone Mixer Right DAC`

```bash
alsamixer
```

Open a terminal. (The quickest way is the Ctrl-Alt-T shortcut.)
Type "alsamixer" and press the Enter key.
You will now see a user interface. In this user interface, you can do the following:

- Select your correct sound card using F6 and select F5 to see recording controls as well
- Move around with left and right arrow keys.
- Increase and decrease volume with up and down arrow keys.
- Increase and decrease volume for left/right channel individually with "Q", "E", "Z", and "C" keys.
- Mute/Unmute with the "M" key. An "MM" means muted, and "OO" means unmuted. Note that a bar can be 100% full but still be muted, so do check for this.
- Exit from alsamixer with the Esc key.

```bash
sudo apt install pulseaudio-module-bluetooth
sudo apt install acpid
```

Fix headphone/speaker sound

```bash  
git clone https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-audi  o.git
cd pinebookpro-audio
cat > install.sh << EOF
#!/usr/bin/env bash
export srcdir=$(pwd)
export pkgdir=""
  
source PKGBUILD
source pinebookpro-audio.install
  
package
post_upgrade

EOF

chod +x install.sh
sudo ./install.sh
```

## Hack Sleep

```bash
sudo sed -i s/"#AllowHibernation=yes"/"AllowHibernation=no"/g /etc/systemd/sleep.conf

sudo sed -i s/"#SuspendState=mem standby freeze"/"SuspendState=mem"/g /etc/systemd/sleep.conf
```

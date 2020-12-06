#!/usr/bin/env bash

sudo pacman --sync --refresh --noconfirm
sudo pacman -S git gcc make guile fakeroot binutils patch electron npm nodejs node-gyp semver pkg-config
sudo pacman -S vim

# curl -Lsk -O https://github.com/electron/electron/releases/download/v9.0.2/mksnapshot-v9.0.2-linux-arm64-x64.zip

# cd ./scripts/node_modules/
# mkdir -p electron-mksnapshot
# cd electron-mksnapshot/
# unzip ../../mksnapshot-v9.0.2-linux-arm64-x64.zip

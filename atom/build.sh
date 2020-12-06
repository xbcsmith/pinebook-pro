#!/usr/bin/env bash

pkgname=atom
pkgver=1.53.0
pkgrel=1
pkgdesc="The hackable text editor"
pkgdir="$(pwd)"
arch=('aarch64')
url="https://atom.io"
license=('MIT')
depends=('python3' 'npm' 'nodejs' 'node-gyp' 'semver')
makedepends=('git' 'pkg-config')
source=('git+https://github.com/atom/atom.git'
        'bootstrap.patch'
        'build.patch' )
sha256sums=('SKIP'
            'dd91183cf1e7e96fffc2da31b7dfc21406e274237c8935d967897d84666d5617'
            '8c8a8abe01b206b1edf2fa80a67b922c6305a09ef26233ec91fae61f706a1e67' )

prepare() {
    export LC_MESSAGES=POSIX
    export NPM_BIN_PATH=/usr/bin/npm
    echo "npm binpath: $NPM_BIN_PATH verison: $(/usr/bin/npm --version)"
    echo "node version: $(/usr/bin/node --version)"
    echo "node-gyp version: $(/usr/bin/node-gyp --version)"
    echo "git version: $(git --version)"
    ELECTRON_VERSION="$(/usr/lib/electron/electron --version)"
    echo "installed electron version (ELECTRON_VERSION): $ELECTRON_VERSION"

    ATOM_RESOURCE_PATH="${PWD}"

    cd "$pkgname"
    git checkout tags/v${pkgver}
    patch -Np1 -i ../../bootstrap.patch
    rm -rf ./script/node_modules
    ./script/bootstrap
}

build() {
    export LC_MESSAGES=POSIX
    export NPM_BIN_PATH=/usr/bin/npm

    cd "$pkgname"
    echo "delete node_modules then apply patch"
    rm -rf node_modules/github/node_modules
    rm -rf node_modules/github/node_modules.bak
    patch -Np1 -i ../../build.patch

    script/build
}

package() {
    cd "$pkgname"

    install -d -m 755 "${pkgdir}"/usr/local/lib/atom
    cp -r out/${pkgname}-${pkgver}-arm64/* "${pkgdir}/usr/local/lib/atom/"

    install -d -m 755 "${pkgdir}/usr/local/share/applications"
    echo "[Desktop Entry]" > "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Type=Application" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Encoding=UTF-8" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Name=${pkgname}" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Comment=${pkgdesc}" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Exec=/usr/local/lib/atom/atom" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Icon=${pkgname}.png" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Categories=Development;IDE;TextEditor;Atom" >> "${pkgdir}/usr/local/share/applications/atom.desktop"
    echo "Terminal=false" >> "${pkgdir}/usr/local/share/applications/atom.desktop"

    install -d -m 755 "${pkgdir}/usr/local/share/licenses/${pkgname}"
    install -m 644 "out/${pkgname}-${pkgver}-arm64/resources/LICENSE.md" "${pkgdir}/usr/local/share/licenses/${pkgname}/"
    install -m 644 "out/${pkgname}-${pkgver}-arm64/LICENSE" "${pkgdir}/usr/local/share/licenses/${pkgname}/"
    install -m 644 "out/${pkgname}-${pkgver}-arm64/LICENSES.chromium.html" "${pkgdir}/usr/local/share/licenses/${pkgname}/"
}

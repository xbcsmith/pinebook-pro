#!/usr/bin/env bash

pkgname=atom
pkgver=1.48.0
pkgrel=1
pkgdesc="The hackable text editor"
pkgdir=${1:-/usr/local/share/applications}

curl -kL -o atom_256.png https://github.com/atom/atom/raw/master/resources/app-icons/stable/png/256.png

echo "[Desktop Entry]" > "${pkgdir}/atom.desktop"
echo "Type=Application" >> "${pkgdir}/atom.desktop"
echo "Encoding=UTF-8" >> "${pkgdir}/atom.desktop"
echo "Name=${pkgname}" >> "${pkgdir}/atom.desktop"
echo "Comment=${pkgdesc}" >> "${pkgdir}/atom.desktop"
echo "Exec=/usr/local/lib/atom/atom" >> "${pkgdir}/atom.desktop"
echo "Icon=${pkgname}.png" >> "${pkgdir}/atom.desktop"
echo "Categories=Development;IDE;TextEditor;Atom" >> "${pkgdir}/atom.desktop"
echo "Terminal=false" >> "${pkgdir}/atom.desktop"


echo "sudo cp atom_256.png /usr/local/share/icons/atom.png"
echo "sudo cp atom.desktop /usr/local/share/applications/atom.desktop"

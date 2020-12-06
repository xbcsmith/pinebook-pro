# atom - text editor / IDE

Original Source [github.com/gophix/pinebook_pro](https://github.com/gophix/pinebook_pro)

Using the latest manjaro on a rockpro64

## installing atom

Install required packages

```
sudo pacman -Syu git gcc make guile fakeroot binutils patch electron npm nodejs node-gyp semver pkg-config
sudo pacman -Syu vim
```

### PKG-BUILD

Build and install with PKGBUILD script:

```
$ export LC_MESSAGES=POSIX
$ cd path/to/atom
$ makepkg                                               # ~70 min
$ sudo pacman -U atom-1.48.0-1-aarch64.pkg.tar.xz       # install atom
```

uninstall atom:

```
$ sudo pacman -R atom                                   # remove atom
```

### MANUAL BUILD

Before creating the PKGBUILD script the following steps were made to get atom up and running:

bootstrap:

```bash
export LC_MESSAGES=POSIX
git clone https://github.com/atom/atom.git --branch=v1.48.0
```

Commment out the mksnapshot sections of the  generating snapshot script
(script/lib/generate-startup-snapshot.js)

```bash
 console.log('Verifying if snapshot can be executed via `mksnapshot`');
 ...
 console.log('Generating startup blob with mksnapshot');
 ...
 console.log(`Moving generated startup blob into "${destinationPath}"`);
 ...
 });
};
```

Update some versions

```bash
vim atom/script/package.json
```

```json
{
    "electron-link": "0.4.2",  # "0.4.1"
    "fs-admin": "^0.13.0",     # "^0.12.0"
    "minidump": "0.19.0",      # "0.9.0"
}
```
```bash
vim atom/package.json
```
```json
{
    "vscode-ripgrep": "1.5.8",    # "^1.2.5",
}
```
```bash
export NPM_BIN_PATH=/usr/bin/npm
cd atom/
./script/bootstrap
```

build:

Update some packages

```json
  "dependencies": {
    "@babel/generator": "7.8.7",    # "7.8.0"
  }
```
```json
    "@babel/preset-env": "7.8.7",   # "7.8.2"
  "devDependencies": {
    "@babel/compat-data": "~7.8.0", # add
}
```

```bash
vim atom/node_modules/github/package.json

./script/build
```



### clean up

```
script/clean
npm cache clean --force
rm -rf ~/.npm
rm -rf ~/.node-gyp
rm -rf ~/.cache/node-gyp
rm -rf ~/.atom
rm -rf ~/.cache/electron
rm package-lock.json
sudo rm -rf /root/.npm
```

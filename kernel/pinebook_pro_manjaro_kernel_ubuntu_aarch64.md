# manjaro Kernel


## DEPS

sudo apt-get -y  install ncurses-dev make kernel-package build-essential git wget libssl-dev

## GCC

Use the Linaro Arm GCC

https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

```bash
curl -slfO https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-aarch64-aarch64-none-elf.tar.xz
```

hash=45605DD7D828569F5C13A13748ED8598363C25F5

https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-aarch64-aarch64-none-elf.tar.xz?revision=c9ba5750-3559-470e-bc91-a0eebfa4d36e&la=en&hash=45605DD7D828569F5C13A13748ED8598363C25F5

## Kernel

https://gitlab.manjaro.org/tsys/linux-pinebook-pro

```bash
export GITBRANCH=v5.6

mkdir -p src && cd scr
git clone --depth=1 --branch=$GITBRANCH https://gitlab.manjaro.org/tsys/linux-pinebook-pro.git
git clean -f && git reset --hard && git pull;
```


```bash
export KERNEL_SOURCE=~/arm64/manjaro_kernel/src/linux-pinebook-pro
export GCC_ARM64=~/arm64/manjaro_kernel/gcc/gcc-arm-9.2-2019.12-aarch64-aarch64-none-elf
export PATH=$GCC_ARM64/bin:$PATH
```


```bash
cd $KERNEL_SOURCE
make mrproper
cp .config ../../configs/xbcsmith.config
make oldconfig
# make menuconfig
```

```bash
make -j6 INITRD=yes KBUILD_IMAGE=arch/arm64/boot/Image bindeb-pkg
```



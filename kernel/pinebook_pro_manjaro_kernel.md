# manjaro Kernel

## GCC

Use the Linaro Arm GCC

https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

```bash
export WRKDIR=~/arm64/manjaro_kernel
pushd $WRKDIR
  curl -slfO https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-aarch64-aarch64-none-elf.tar.xz
  tar -xvf gcc-arm-9.2-2019.12-aarch64-aarch64-none-elf.tar.xz -O $WRKDIR/gcc
popd
```



## Kernel

https://gitlab.manjaro.org/tsys/linux-pinebook-pro

```bash
export KERNEL_SOURCE=~/arm64/manjaro_kernel/src/linux-pinebook-pro
export GITBRANCH=v5.6

mkdir -p $KERNEL_SOURCE
pushd $KERNEL_SOURCE
  git clone --depth=1 --branch=$GITBRANCH https://gitlab.manjaro.org/tsys/linux-pinebook-pro.git
  git clean -f && git reset --hard && git pull
popd
```

## VARS

```bash
export KERNEL_CONFIG="INITRD=yes KBUILD_IMAGE=arch/arm64/boot/Image"
export GCC_ARM64=~/arm64/manjaro_kernel/gcc
export NPROC=10
export TCPU=cortex-a72.cortex-a53
export TOPTS=+crypto+crc
export TARCH=armv8-a
```


```bash
pushd $KERNEL_SOURCE
  make mrproper
  cp ../../configs/xmixahhlx_5.6.config .config
  make oldconfig
# make menuconfig
  make -j $NPROC $KERNEL_CONFIG binrpm-pkg
popd
```



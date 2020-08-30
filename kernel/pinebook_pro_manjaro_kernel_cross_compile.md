# manjaro Kernel

## Cross Compile

## GCC

Use the Linaro Arm GCC

https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads

```bash
curl -slfO https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
curl -slfO https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz.asc
```

## Kernel

https://gitlab.manjaro.org/tsys/linux-pinebook-pro

```bash
export GITBRANCH=v5.6

mkdir -p src && cd scr
git clone --depth=1 --branch=$GITBRANCH https://gitlab.manjaro.org/tsys/linux-pinebook-pro.git
git clean -f && git reset --hard && git pull
```

## VARS

```bash
export KERNEL_SOURCE=~/arm64/manjaro_kernel/src/linux-pinebook-pro
export BUILD_CONFIG="ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-"
export KERNEL_CONFIG="INITRD=yes KBUILD_IMAGE=arch/arm64/boot/Image"
export GCC_ARM64=~/arm64/manjaro_kernel/gcc/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
export NPROC=10
export TCPU=cortex-a72.cortex-a53
export TOPTS=+crypto+crc
export TARCH=armv8-a
export PATH=$GCC_ARM64/bin:$PATH
```


```bash
cd $KERNEL_SOURCE
export KCFLAGS="-O2 -pipe -march=$TARCH$TOPTS -mcpu=$TCPU -mtune=$TCPU"
export KCPPFLAGS="-O2 -pipe -march=$TARCH$TOPTS -mcpu=$TCPU -mtune=$TCPU"
make $BUILD_CONFIG mrproper
cp .config ../../configs/xbcsmith.config
make $BUILD_CONFIG oldconfig
# make $BUILD_CONFIG menuconfig
```

```bash
KCFLAGS="-O2 -pipe -march=$TARCH$TOPTS -mcpu=$TCPU -mtune=$TCPU"  KCPPFLAGS="-O2 -pipe -march=$TARCH$TOPTS -mcpu=$TCPU -mtune=$TCPU" make -j $NPROC $BUILD_CONFIG $KERNEL_CONFIG binrpm-pkg
```


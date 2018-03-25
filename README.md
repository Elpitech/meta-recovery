# OpenEmbedded/Yocto layer for the Baikal-T(1) SoC

## Dependencies

- [openembedded-core](https://github.com/openembedded/openembedded-core)
  layer, with a matching branch (i.e. master of oe-core and master of
  meta-sourcery).
- [bitbake](https://github.com/openembedded/bitbake), with a matching branch.
- [meta-external-toolchain](https://github.com/T-platforms/yocto/meta-external-toolchain)
  with master branch
- [meta-baikal-t](https://github.com/T-platforms/yocto/meta-baikal-t)
  with master branch

## Usage & Instructions

- Add the layer and corresponding dependendant layers to yocto project 
  `BBLAYERS` in `conf/bblayers.conf`.

- Alter `conf/distro/include/tplatforms-sdk-sources.inc` to declare where
  the root SDK directory resides. As alternative user can export the
  quartet:
  `TPSDK_SYS` - SDK toolchain target prefix (i.e. mipsel-unknown-linux-gnu)
  `TPSDK_DIR` - path to the SDK root directory
  `TPSDK_SRC` - resource to fetch the kernel/u-boot code (sdk or git)
  `TPSDK_XTC` - resource to fetch the cross-toolchain (sdk or git)
  The SDK version is also declared there.

- General build settings can be customized in `conf/distro/include/formware.inc`
  Detailed description is in the file itself.

## Behavior

The layer can be used to create Baikal-T(1) recovery firmware, with custom
utilities included as well as Yocto SDK/eSDK for it equipped with either
pre-built toolchain or toolchain built from sources.

Recovery image is the image, which can be used both for hardware recovery
procedures and as initramfs system to mount and start rootfs from different
storages. As initramfs the image got traditional set of init-scripts, to
mount rootfs from predefined storage with pivot-rooting there. As one of the
case the root-device can be /dev/ram, which would be initramfs itself with
minimized but fully functional linux rootfs - recovery image.

Recovery image is based on busybox system extended by a set of utilities.
It got mtd-utils, i2c-tools, spi-utils, pciutils, sysfsutils to scan the
peripheral buses and perform a minimal check of their functionality.
External drives can be customized by hdparm, e2fsprogs and dosfstools.
Since most of the boards are supplied with hwmon and temperature sensors
lmsensors software is also included. Aside from limited busybox network
manager tools there are dropbear and ethtool utilities installed to the
image. If your board doesn't expose any traditional interfaces, you can use
serial console in conjuction with seterial and lrzsz to upload necessary
software. Finally you may won't to test the system stamina and functionality,
in this case there are rt-tests, whetstone, dhrystone, memtester, tinymembench
and libc-bench at your service.

As a result of the image build process, you'll find the
baikal-image-recovery.rom file in the buila/tmp/deploy/image/<machin>/
directory. SDK is supplied with flashrom utility, which can be burned to
the Baikal-T SPI-flash storage.

## Contributing

To contribute to this layer, please fork and submit pull requests to the
github [repository](https://github.com/T-Platforms/yocto/meta-recovery), or open
issues for any bugs you find, or feature requests you have.

## Maintainer

This layer is maintained by [T-platforms](https://www.t-platforms.ru/).
Please direct all support requests for this layer to the GitHub repository
issues interface. Optionally you can try to communicate with primary
developer: Serge Semin <fancer.lancer@gmail.com>

## To Do List

See [TODO.md](TODO.md).

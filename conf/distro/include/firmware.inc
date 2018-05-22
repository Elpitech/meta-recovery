###################################################################################################
#                                     Main software versions
###################################################################################################
# Next values of the default kernel/u-boot version will be used only if the meta isn't used within
# SDK, but if it is, then the version shall be determined right from the sources.
PREFERRED_VERSION_linux-baikal ?= "4.4%"
PREFERRED_VERSION_u-boot-baikal ?= "2014.10"
# Enable busybox as the main services provider for the recovery image. It shall consume less memory
# but give us enough basic functionality. If some busybox features intersects the utilities from
# RECOVERY_IMAGE_EXTRA_INSTALL they shall be alternated by update-alternatives tool, since obviously
# the real utility got greater abilities.
VIRTUAL-RUNTIME_dev_manager = "busybox-mdev"
VIRTUAL-RUNTIME_login_manager = "busybox"
VIRTUAL-RUNTIME_init_manager = "busybox"
VIRTUAL-RUNTIME_initscripts = "initscripts"
VIRTUAL-RUNTIME_base-utils = "busybox"
VIRTUAL-RUNTIME_base-utils-hwclock = "busybox-hwclock"
VIRTUAL-RUNTIME_syslog = "busybox-syslog"

###################################################################################################
#                                   U-boot environment settings
###################################################################################################
# Linux mtd-device to access the U-boot environment section used by
# fw_printenv/fw_setenv U-boot utils
UBOOT_ENV_MTD_FILE ?= "/dev/mtd1"

# Default values of U-boot environment variables. They can be redefined
# in the machine-specific conf-files if needed to be.
UBOOT_ENV_SIZE ?= "${@'${RECOVERY_ROM_ENVIRONMENT}'.split(':')[1]}"
UBOOT_ENV_BUILD_IMAGE ?= "T-platforms ${MACHINE} (${DISTRO} ${DISTRO_VERSION}) boot ROM image"
UBOOT_ENV_BUILD_VERSION ?= "${TPSDK_VERSION}"
UBOOT_ENV_CONSOLE ?= "${@'${SERIAL_CONSOLE}'.split(';')[1]}"
UBOOT_ENV_BAUDRATE ?= "${@'${SERIAL_CONSOLE}'.split(';')[0]}"
UBOOT_ENV_NUM_CORES ?= "2"
UBOOT_ENV_CPUFREQ ?= "900"
UBOOT_ENV_HOSTNAME ?= "${RECOVERY_HOSTNAME}"
UBOOT_ENV_KERNEL_FILE_NAME ?= "vmlinux.gz"
UBOOT_ENV_INITRD_FILE_NAME ?= "initramfs.gz"
UBOOT_ENV_FDT_FILE_NAME ?= "machine.dtb"
UBOOT_ENV_KERNEL_ADDR_LD ?= "${UBOOT_LOADADDRESS}"
UBOOT_ENV_INITRD_ADDR_LD ?= "0x86100000"
UBOOT_ENV_FDT_ADDR_LD ?= "0x86000000"
UBOOT_ENV_FITIMAGE_ADDR_FW ?= "${@format(int('${RECOVERY_ROM_BASE}', 16) + int('${RECOVERY_ROM_FITIMAGE}'.split(':')[0], 16), '#010x')}"
UBOOT_ENV_ETHADDR ?= "7a:72:6c:4a:7a:ee"
UBOOT_ENV_ETH1ADDR ?= "7a:72:6c:4a:7b:ee"
UBOOT_ENV_ETH2ADDR ?= "7a:72:6c:4a:7c:ee"

# U-boot menu/autoboot configuration. It will be translated to the system
# boot sequense in compliance with the specified kernel and rootfs sources
UBOOT_ENV_BOOTCMD ?= "bootmenu"
UBOOT_ENV_BOOTDELAY ?= "10"
UBOOT_ENV_BOOTMENU ?= "\
	rec_ram=1.  Boot recovery kernel and RFS;rom=/dev/ram;; \
	rec_sda1=2.  Boot recovery kernel to /dev/sda1;rom=/dev/sda1;; \
	rec_sdb1=3.  Boot recovery kernel to /dev/sdb1;rom=/dev/sdb1;; \
	sata_ram=4.  Boot kernel from SATA ext 0:1 to initrd;sata=/dev/ram;fs=ext;part=0:1;dir=/boot;; \
	sata_sda1=5.  Boot kernel from SATA ext 0:1 to /dev/sda1;sata=/dev/sda1;fs=ext;part=0:1;dir=/boot;; \
	usb_ram=6.  Boot kernel from USB fat 0:1 to initrd;usb=/dev/ram;fs=fat;part=0:1;dir=/boot;; \
	usb_sdb1=7.  Boot kernel from USB fat 0:1 to /dev/sdb1;usb=/dev/sdb1;fs=fat;part=0:1;dir=/boot;; \
	net_stat=8.  Boot kernel via TFTP (192.168.0.1) to initrd;tftp=/dev/ram;ip=192.168.0.2;srvip=192.168.0.1;gwip=192.168.0.1;; \
	net_dhcp=9.  Boot kernel via TFTP (dhcp) to initrd;tftp=/dev/ram;ip=dhcp;; \
	net_nfs=10. Boot kernel via NFS (dhcp) to initrd;nfs=/dev/ram;ip=dhcp;dir=/boot;; \
	reset=Reset board;reset\
"

###################################################################################################
#                                Kernel (FIT)image build settings
###################################################################################################
# By default the system builds kernel FIT and vmlinuz.bin images. Here you can add some additional
# ones, which will also be copied to the deploy directory, for instance "vmlinux vmlinux.gz vmlinuz".
# We also don't need to bundle device-trees in the kernel, since it is going to be added to the
# fitImage. Initramfs shall rely on devtmps. It can't consume more than 16MB.
KERNEL_EXTRA_IMAGETYPES ?= ""
KERNEL_DEVICETREE_BUNDLE ?= "0"
KERNEL_IMAGE_MAXSIZE ?= "16384"
KERNEL_USES_DEVFS ?= "1"

# Initramfs is used either as recovery rootfs image or to preload some kernel modules before
# the actual kernel is booted. Recovery initial ramdisk is based on the busybox with
# a set of additional utils to be able to test and fix possible system issues.
# We are building the cpio.gz image (other types can be appended, but only the default one is
# embedded to the fitImage) with size of maximum 32MB. The image can also be bundled into the
# kernel, but we don't do this since fitImage is going to be used.
INITRAMFS_EXTRA_FSTYPES ?= ""
INITRAMFS_IMAGE_BUNDLE ?= "0"
INITRAMFS_MAXSIZE ?= "32768"

# fitImage is described by specific dts-file automatically created by kernel-fitimage.bbclass
# class. In order to have the kernel successfully booted, we need to provide the kernel blob
# load address, entry point and some more information.
# NOTE 1. UBOOT_ENTRYPOINT will be redefined in accordance with the UBOOT_ENTRYSYMBOL address
# NOTE 2. I don't know what initrd entrypoint is for, so either comment it out or just set it to
# zero. Obviously initrd loadaddress is the fixed address to load the ramdisk.
# We also don't want to sign the fitImage by default.
UBOOT_LOADADDRESS ?= "0x80100000"
UBOOT_ENTRYPOINT ?= "0x808f3510"
UBOOT_ENTRYSYMBOL ?= "kernel_entry"
UBOOT_RD_LOADADDRESS ?= "00000000"
UBOOT_RD_ENTRYPOINT ?= "00000000"
UBOOT_SIGN_ENABLE ?= "1"

###################################################################################################
#                                     Recovery image settings
###################################################################################################
# Generic recovery image settings including root password, hostname and SPI-flash
# layout: ~ 1Mb for U-boot, 65Kb (fixed by U-boot Baikal configs) for environment
# and 15Mb for multiimage with kernel, initramfs and dtb's, which corresponds to:
# BOOTLOADER  u-boot.bin  0x00000000-0x000F0000
# ENVIRONMENT u-boot.env  0x000F0000-0x00100000
# FITIMAGE    fitImage    0x00100000-0x01000000
# All of these variables are mandatory to be defined, that's why they are declared
# with default assign operator

# Base address of the SPI-flash device mapped to the Baikal MMIO to have the
# firmware loaded stright from there
RECOVERY_ROM_BASE        ?= "0x9C000000"
# U-boot bootloader base address and size within SPI-flash memory. NOTE Bootloader
# should always be the first blob in the image
RECOVERY_ROM_BOOTLOADER  ?= "0x00000000:0x000F0000"
# U-boot environment image base address and size within SPI-flash memory. NOTE If
# you wanna change the image size you also need to alter the u-boo/include/configs/baikal_mips.h
RECOVERY_ROM_ENVIRONMENT ?= "0x000F0000:0x00010000"
# Kernel/initramfs/dtb multi-image base address and size within SPI-flash memory
RECOVERY_ROM_FITIMAGE    ?= "0x00100000:0x00F00000"
RECOVERY_PWD_ROOT ?= "tplatforms"
RECOVERY_HOSTNAME ?= "${MACHINE}"

# List of packages being installed along with basic recovery image busybox-utils. Most of
# functionality is built-in to the busybox binary, but if you want anything special, you
# can add the yocto package-name to this list. For instance, you may want to add the packages
# like iproute2, iptables, iputils, oprofile, strace, openocd, and so on, but be carefull
# to not exceed the image size limitations, since they can pull in some heavy denendencies.
# NOTE Drop mtd-utils package if you want to speed the build up, since it got heavy dependencies.
# There is still some mtd functionality embedded into the busybox binary.
RECOVERY_IMAGE_EXTRA_INSTALL ?= "dropbear ethtool mtd-utils u-boot-fw-utils hdparm parted e2fsprogs e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-badblocks e2fsprogs-resize2fs dosfstools pciutils setserial lrzsz i2c-tools spi-tools lmsensors-sensors sysfsutils recovery-image-info"
RECOVERY_IMAGE_TEST_BENCHES ?= "rt-tests whetstone dhrystone memtester tinymembench stressapptest libc-bench dbench tbench fio nbench-byte sysbench stress-ng"
# Glibc locales can be also added to the image, like en-gb or ru-ru. But you should note,
# that they are too heavy, ~2Mb each so I wouldn't do this.
RECOVERY_IMAGE_EXTRA_LINGUAS ?= ""

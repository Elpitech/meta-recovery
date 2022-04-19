###################################################################################################
#                                     Main software versions
###################################################################################################
# Next values of the default kernel/u-boot version will be used only if the meta isn't used within
# SDK, but if it is, then the version shall be determined right from the sources.
LINUX_KERNEL_TYPE ?= "standard"
PREFERRED_VERSION_linux-yocto ?= "4.4%"
PREFERRED_VERSION_u-boot ?= "2014.10"
# Enable busybox as the main services provider for the recovery image. It shall consume less memory
# but give us enough basic functionality. If some busybox features intersects the utilities from
# RECOVERY_IMAGE_EXTRA_INSTALL they shall be alternated by update-alternatives tool, since obviously
# the real utility got greater abilities.
VIRTUAL-RUNTIME_dev_manager = "busybox-mdev"
VIRTUAL-RUNTIME_login_manager = "busybox"
VIRTUAL-RUNTIME_init_manager = "busybox"
VIRTUAL-RUNTIME_initscripts = "initscripts modutils-initscripts init-ifupdown"
VIRTUAL-RUNTIME_base-utils = "busybox"
VIRTUAL-RUNTIME_base-utils-hwclock = "busybox-hwclock"
VIRTUAL-RUNTIME_syslog = "busybox-syslog"

###################################################################################################
#                                   U-boot environment settings
###################################################################################################
# Default values of U-boot environment variables. They can be redefined
# in the machine-specific conf-files if needed to be.
UBOOT_ENV_SIZE ?= "${@'${RECOVERY_ROM_ENVIRONMENT}'.split(':')[1]}"
UBOOT_ENV_BUILD_IMAGE ?= "Yocto ${MACHINE} ${DISTRO} ${DISTRO_VERSION}"
UBOOT_ENV_BUILD_VERSION ?= "${TPSDK_VERSION}"
UBOOT_ENV_CONSOLE ?= "${@'${SERIAL_CONSOLE}'.split()[1]}"
UBOOT_ENV_BAUDRATE ?= "${@'${SERIAL_CONSOLE}'.split()[0]}"
UBOOT_ENV_NUM_CORES ?= "2"
UBOOT_ENV_CPUFREQ ?= "850"
UBOOT_ENV_HOSTNAME ?= "${RECOVERY_HOSTNAME}"
UBOOT_ENV_VMLINUZ_FILE_NAME ?= "vmlinuz${@'-${KERNEL_IMAGE_SYMLINK_NAME}' if '${KERNEL_IMAGE_SYMLINK_NAME}' else ''}.bin"
UBOOT_ENV_VMLINUX_FILE_NAME ?= "vmlinux${@'-${KERNEL_IMAGE_SYMLINK_NAME}' if '${KERNEL_IMAGE_SYMLINK_NAME}' else ''}.bin"
UBOOT_ENV_FDT_FILE_NAME ?= "${@os.path.basename('${KERNEL_DEVICETREE}'.split()[0])}"
UBOOT_ENV_INITRD_FILE_NAME ?= "baikal-image-recovery-${MACHINE}.cpio.gz"
UBOOT_ENV_VMLINUZ_ADDR_LD ?= "${UBOOT_VMLINUZ_LOADADDRESS}"
UBOOT_ENV_VMLINUX_ADDR_LD ?= "${UBOOT_VMLINUX_LOADADDRESS}"
UBOOT_ENV_FDT_ADDR_LD ?= "${UBOOT_FDT_LOADADDRESS}"
UBOOT_ENV_INITRD_ADDR_LD ?= "${UBOOT_RD_LOADADDRESS}"
UBOOT_ENV_FITIMAGE_ADDR_FW ?= "${@format(int('${RECOVERY_ROM_BASE}', 16) + int('${RECOVERY_ROM_FITIMAGE}'.split(':')[0], 16), '#010x')}"
UBOOT_ENV_FITIMAGE_CONFIG ?= "${@'${KERNEL_DEVICETREE}'.split()[0]}"
UBOOT_ENV_FITIMAGE_VERIFY ?= "y"
UBOOT_ENV_ETHADDR ?= "7a:72:6c:4a:7a:ee"
UBOOT_ENV_ETH1ADDR ?= "7a:72:6c:4a:7b:ee"
UBOOT_ENV_ETH2ADDR ?= "7a:72:6c:4a:7c:ee"

# U-boot MTD configurations. They will be translated to the mtdparts/mtdids
# environment variables and passed to kernel if one supports it
UBOOT_ENV_MTDID ?= "boot_flash"
UBOOT_ENV_MTDPARTS ?= "bootloader;${@'${RECOVERY_ROM_BOOTLOADER}'.replace(':',';')};ro;; \
                       environment;${@'${RECOVERY_ROM_ENVIRONMENT}'.replace(':',';')};; \
                       information;${@'${RECOVERY_ROM_INFORMATION}'.replace(':',';')};ro;; \
                       fitimage;${@'${RECOVERY_ROM_FITIMAGE}'.replace(':',';')};ro;; \
                       firmware;0x0;${RECOVERY_ROM_SIZE}"

# U-boot menu/autoboot configuration. They will be translated to the system
# boot sequense in compliance with the specified kernel and rootfs sources
UBOOT_ENV_BOOTCMD ?= "run boot_rec_ram"
UBOOT_ENV_BOOTDELAY ?= "10"
UBOOT_ENV_BOOTUNITS ?= "\
	rec_ram=1.  Boot from flash to initrd;rom=initfs;; \
	rec_sda1=2.  Boot from flash to /dev/sda1 FS;rom=/dev/sda1;; \
	rec_sdb1=3.  Boot from flash to /dev/sdb1 FS;rom=/dev/sdb1;; \
	usb_ram=4.  Boot from USB 0:1 to initrd;usb=initfs;part=0:1;dir=/;; \
	usb_sda1=5.  Boot from USB 0:1 to /dev/sda1 FS;usb=/dev/sda1;part=0:1;dir=/boot;; \
	usb_sdb1=6.  Boot from USB 1:1 to /dev/sdb1 FS;usb=/dev/sdb1;part=1:1;dir=/boot;; \
	sata_ram=7.  Boot from SATA 0:1 to initrd;usb=initfs;part=0:1;dir=/;; \
	sata_sda1=8.  Boot from SATA 0:1 to /dev/sda1 FS;sata=/dev/sda1;part=0:1;dir=/boot;; \
	sata_sdb1=9.  Boot from SATA 1:1 to /dev/sdb1 FS;sata=/dev/sdb1;part=1:1;dir=/boot;; \
	net_stat=10. Boot via TFTP (192.168.0.2/192.168.0.1) to initrd;tftp=initfs;ip=192.168.0.2;srvip=192.168.0.1;; \
	net_dhcp=11. Boot via TFTP (dhcp/192.168.0.1) to initrd;tftp=initfs;ip=dhcp;srvip=192.168.0.1;; \
	net_nfs=12. Boot via NFS (dhcp/192.168.0.1) to initrd;nfs=initfs;ip=dhcp;srvip=192.168.0.1;dir=/boot;; \
	reset=Reset board;reset \
"
UBOOT_ENV_MENU_MAIN ?= "rec_ram;;rec_sda1;;rec_sdb1;;usb_ram;;usb_sda1;;usb_sdb1;; \
			sata_ram;;sata_sda1;;sata_sdb1;;net_stat;;net_dhcp;;net_nfs;;reset"

###################################################################################################
#                                Kernel (FIT)image build settings
###################################################################################################
# By default the system builds kernel FIT and vmlinuz.bin images. Here you can add some additional
# ones, which will also be copied to the deploy directory, for instance "vmlinux vmlinux.gz vmlinuz".
# We also don't need to bundle device-trees in the kernel, since it is going to be added to the
# fitImage. Initramfs shall rely on devtmps. It can't consume more than 16MB.
# FIT-image will be signed up by default.
KERNEL_EXTRA_IMAGETYPES ?= "vmlinux vmlinuz.bin vmlinux.bin"
KERNEL_DEVICETREE_BUNDLE ?= "0"
KERNEL_IMAGE_MAXSIZE ?= "16384"
KERNEL_USES_DEVFS ?= "1"
UBOOT_SIGN_ENABLE ?= "0"
UBOOT_SIGN_KEYNAME ?= "baikal"

# Initramfs is used either as recovery rootfs image or to preload some kernel modules before
# the actual kernel is booted. Recovery initial ramdisk is based on the busybox with
# a set of additional utils to be able to test and fix possible system issues.
# We are building the cpio.gz image (other types can be appended, but only the default one is
# embedded to the fitImage) with size of maximum 32MB. The image can also be bundled into the
# kernel, but we don't do this since fitImage is going to be used.
INITRAMFS_EXTRA_FSTYPES ?= ""
INITRAMFS_IMAGE_BUNDLE ?= "0"
INITRAMFS_MAXSIZE ?= "32768"

###################################################################################################
#                                     Recovery image settings
###################################################################################################
# Generic recovery image settings including root password, hostname and SPI-flash
# layout: ~ 1Mb for U-boot, 65Kb (fixed by U-boot Baikal configs) for environment
# and 15Mb for multiimage with kernel, initramfs and dtb's, which corresponds to:
# BOOTLOADER  u-boot.bin  0x00000000-0x000E0000
# ENVIRONMENT u-boot.env  0x000E0000-0x000F0000
# INFORMATION info.bin    0x000F0000-0x00100000
# FITIMAGE    fitImage    0x00100000-0x01000000
# All of these variables are mandatory to be defined, that's why they are declared
# with default assign operator

# Base address of the SPI-flash device mapped to the Baikal MMIO to have the
# firmware loaded stright from there
RECOVERY_ROM_BASE        ?= "0x9C000000"
RECOVERY_ROM_SIZE        ?= "16777216"
# U-boot bootloader base address and size within SPI-flash memory. NOTE Bootloader
# should always be the first blob in the image
RECOVERY_ROM_BOOTLOADER  ?= "0x00000000:0x000E0000"
# U-boot environment image base address and size within SPI-flash memory.
# NOTE If you wanna change the image size you also need to alter the file:
# u-boot/include/configs/baikal_<MATCHINE>.h
RECOVERY_ROM_ENVIRONMENT ?= "0x000E0000:0x00010000"
# Recovery image informational section
RECOVERY_ROM_INFORMATION ?= "0x000F0000:0x00010000"
# Kernel/initramfs/dtb multi-image base address and size within SPI-flash memory
RECOVERY_ROM_FITIMAGE    ?= "0x00100000:0x00F00000"
# Info-section magic-number. It will be set to recovery-image-info reader app
# so the image info and the app would be synchronized about the number.
RECOVERY_INFO_MAGIC      ?= "0xDEADBEEFBAADF00DULL"
# Kernel root-password and hostname
RECOVERY_PWD_ROOT ?= "tplatforms"
RECOVERY_HOSTNAME ?= "${MACHINE}"
# Recovery version (previous non-yocto version was 1.3.1)
RECOVERY_VERSION ?= "1.4.0"

# Linux mtd-device to access the U-boot environment section used by
# fw_printenv/fw_setenv U-boot utils
RECOVERY_MTD_UBOOT_ENV ?= "/dev/mtd1"
# Linux mtd-device to access the informational section of the image
RECOVERY_MTD_INFO ?= "/dev/mtd2"

# Default timezone settings
DEFAULT_TIMEZONE ?= "Europe/Moscow"

# List of packages being installed along with basic recovery image busybox-utils. Most of
# functionality is built-in to the busybox binary, but if you want anything special, you
# can add the yocto package-name to this list. For instance, you may want to add the packages
# like iproute2, iptables, iputils, oprofile, strace, openocd, and so on, but be carefull
# to not exceed the image size limitations, since they can pull in some heavy denendencies.
# NOTE Drop mtd-utils package if you want to speed the build up, since it got heavy dependencies.
# There is still some mtd functionality embedded into the busybox binary.
RECOVERY_IMAGE_EXTRA_INSTALL ?= "dropbear ethtool mtd-utils u-boot-fw-utils hdparm parted \
                                 e2fsprogs e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs \
                                 e2fsprogs-badblocks e2fsprogs-resize2fs dosfstools squashfs-tools \
                                 pciutils setserial lrzsz i2c-tools spi-tools lmsensors-sensors \
                                 sysfsutils cpufrequtils xxd recovery-image-info lsscsi \
                                 micropython micropython-lib"
RECOVERY_IMAGE_TEST_BENCHES ?= "serialcheck rt-tests whetstone dhrystone memtester tinymembench \
                                stressapptest libc-bench dbench tbench fio iozone3 nbench-byte \
                                sysbench stress-ng trace-cmd"
# Glibc locales can be also added to the image, like en-gb or ru-ru. But you should note,
# that they are too heavy, ~2Mb each so I wouldn't do this.
RECOVERY_IMAGE_EXTRA_LINGUAS ?= ""
# The kernel vmlinux image gets to be installed in case if any kernel module is built and
# installed to the recovery rootfs. It dramatically expandes the recovery image. Since we really
# don't need it being embedded into the recovery rootfs tree in any case we can freely remove
# the dependency here for the whole distro.
RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""

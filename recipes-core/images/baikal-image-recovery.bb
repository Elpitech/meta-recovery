SUMMARY = "Baikal-T SPI-flash recovery image"
DESCRIPTION = "Small image hidden in the Baikal-T SPI-flash memory device"
LICENSE = "MIT"

PV = "${TPSDK_VERSION}"
PR = "r${TPSDK_REVISION}"

# If kernel doesn't use devfs, the image.bbclass shall populate the /dev directory 
USE_DEVFS = "${KERNEL_USES_DEVFS}"
export IMAGE_BASENAME = "${MLPREFIX}${PN}"

# Build image just as initramfs requested. That's what recovery image after all:
# comprehensive initramfs image
IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_ROOTFS_SIZE = "${INITRAMFS_MAXSIZE}"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# Exclude anything declared by the distro/machine features and use just the packages
# needed by the recovery image basics including the 
IMAGE_FEATURES = ""

RECOVERY_IMAGE_EXTRA_INSTALL ??= ""
RECOVERY_IMAGE_TEST_BENCHES ??= ""
RECOVERY_IMAGE_EXTRA_LINGUAS ??= ""

# The image is going to have both initrd and recovery rootfs features. We explicitly set the
# PACKAGE_INSTALL list here so to exclude all the possible features declared by disro/machine
# configurations. Some extra packages can still be added within the firmware configuration
# header.
PACKAGE_INSTALL  = "initramfs-framework-base initramfs-module-mdev initramfs-module-e2fs initramfs-module-rootfs initramfs-module-debug"
PACKAGE_INSTALL += "initramfs-module-initfs"
PACKAGE_INSTALL += "${VIRTUAL-RUNTIME_init_manager} ${VIRTUAL-RUNTIME_login_manager} ${VIRTUAL-RUNTIME_initscripts} ${VIRTUAL-RUNTIME_dev_manager}"
PACKAGE_INSTALL += "${VIRTUAL-RUNTIME_base-utils} ${VIRTUAL-RUNTIME_syslog} ${VIRTUAL-RUNTIME_base-utils-hwclock}"
PACKAGE_INSTALL += "base-files tzdata"
PACKAGE_INSTALL += "netbase"
PACKAGE_INSTALL += "${RECOVERY_IMAGE_EXTRA_INSTALL} ${RECOVERY_IMAGE_TEST_BENCHES} ${ROOTFS_BOOTSTRAP_INSTALL}"

# Locales to be added to the image
# NOTE They are very heavy!
IMAGE_LINGUAS = "${RECOVERY_IMAGE_EXTRA_LINGUAS}"

inherit core-image image-info baikal-rom

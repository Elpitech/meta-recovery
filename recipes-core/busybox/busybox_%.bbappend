
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://archives.cfg \
            file://blockdev.cfg \
            file://cksum.cfg \
            file://console.cfg \
            file://dosfstools.cfg \
            file://e2fsprogs.cfg \
            file://e2fsprogs-tune2fs.cfg \
            file://e2fsprogs-mke2fs.cfg \
            file://fsync.cfg \
            file://ftp.cfg \
            file://hdparm.cfg \
            file://i2c-tools.cfg \
            file://iputils.cfg \
            file://lrzsz.cfg \
            file://modules.cfg \
            file://mount.cfg \
            file://mtd-utils.cfg \
            file://nice.cfg \
            file://pciutils.cfg \
            file://psutils.cfg \
            file://ramdisk.cfg \
            file://setserial.cfg \
            file://usbutils.cfg \
            file://watchdog.cfg \
            file://shadow"

DEPENDS += "openssl-native"

RECOVERY_PWD_ROOT ?= ""

do_install_append() {
    pw=""

    if [ "${RECOVERY_PWD_ROOT}" != "" ]; then
        pw=$(openssl passwd -1 ${RECOVERY_PWD_ROOT})
    fi

    sed -i -e "s,^root:[^:]*:,root:$pw:," ${WORKDIR}/shadow

    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/shadow ${D}${sysconfdir}
}

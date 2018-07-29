
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/files:"

SRC_URI += "file://generic.cfg \
            file://einit.cfg \
            file://login.cfg \
            file://archives.cfg \
            file://blockdev.cfg \
            file://killall5.cfg \
            file://iostat.cfg \
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
            file://fancy.cfg \
            file://env.cfg \
            file://comm.cfg \
            file://expand.cfg \
            file://split.cfg \
            file://sum.cfg \
            file://tac.cfg \
            file://fgconsole.cfg \
            file://kbd_mode.cfg \
            file://pipe_progress.cfg"

SRC_URI += "file://rcK \
            file://mdev-mount.sh \
            file://group \
            file://passwd \
            file://shadow \
            file://fstab"

DEPENDS += "openssl-native"

RECOVERY_PWD_ROOT ?= ""

do_install_append() {

    if [ "${RECOVERY_PWD_ROOT}" != "" ]; then
        pw=$(openssl passwd -1 ${RECOVERY_PWD_ROOT})
        sed -i -e "s,^root:[^:]*:,root:x:," ${WORKDIR}/group
        sed -i -e "s,^root:[^:]*:,root:x:," ${WORKDIR}/passwd
        sed -i -e "s,^root:[^:]*:,root:$pw:," ${WORKDIR}/shadow
    fi

    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/group ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/passwd ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/shadow ${D}${sysconfdir}

    # Discard auto-mount lines from inittab and install new fstab
    if grep "CONFIG_INIT=y" ${B}/.config && grep "CONFIG_FEATURE_USE_INITTAB=y" ${B}/.config; then
        sed -i -e "4,10s/.*/# &/" ${D}${sysconfdir}/inittab
        sed -i -e "17,18s/.*/# &/" ${D}${sysconfdir}/inittab
    fi
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}

    # No need to mount anything via mtab start script
    sed -i -e "2,7s/.*/# &/" ${D}${sysconfdir}/init.d/mdev
}

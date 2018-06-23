
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://initfs"

do_install_append() {
    # RAM-rootfs
    install -m 0755 ${WORKDIR}/initfs ${D}/init.d/00-initfs
}

PACKAGES += "initramfs-module-initfs"

SUMMARY_initramfs-module-initfs = "initramfs support to be rootfs"
RDEPENDS_initramfs-module-initfs = "${PN}-base"
FILES_initramfs-module-initfs = "/init.d/00-initfs"

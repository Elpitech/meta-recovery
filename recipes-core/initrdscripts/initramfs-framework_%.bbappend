
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://initfs \
            file://finish"

do_install:append() {
    # RAM-rootfs
    install -m 0755 ${WORKDIR}/initfs ${D}/init.d/00-initfs
}

PACKAGES += "initramfs-module-initfs"

SUMMARY:initramfs-module-initfs = "initramfs support to be rootfs"
RDEPENDS:initramfs-module-initfs = "${PN}-base"
FILES:initramfs-module-initfs = "/init.d/00-initfs"

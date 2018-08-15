KBRANCH = "${PV}.x-tp"
SRC_URI = "git://192.168.1.253/IT/T-Platforms/utils/flashrom.git;protocol=ssh;user=git;branch=${KBRANCH} \
           file://sst26.patch \
           file://0001-platform-Add-riscv-to-known-platforms.patch"
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

do_install_append_class-nativesdk() {
    mv ${D}${prefix}/sbin ${D}${sbindir}
}

BBCLASSEXTEND += "nativesdk"

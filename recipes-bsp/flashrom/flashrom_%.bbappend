TPSDK_REPO ?= "github.com"

KBRANCH = "${PV}.x-tp"
SRC_URI = "git://${TPSDK_REPO}/Elpitech/flashrom.git;protocol=ssh;user=git;branch=${KBRANCH} \
           file://sst26.patch \
           file://0001-platform-Add-riscv-to-known-platforms.patch"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

DEPENDS += "libftdi"

do_install_append_class-nativesdk() {
    mv ${D}${prefix}/sbin ${D}${sbindir}
}

BBCLASSEXTEND += "nativesdk"

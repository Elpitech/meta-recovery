SUMMARY = "ROM Flash Utility"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base"

TPSDK_REPO ?= "gitlab.elpitech.ru"
KBRANCH = "master"

PV = "1.0"

SRCREV = "AUTOINC"
SRC_URI = "git://${TPSDK_REPO}/baikal-t/btflash.git;protocol=ssh;user=git;branch=${KBRANCH}"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${CC} ${CFLAGS} ${LDFLAGS}"'

do_install() {
	oe_runmake install DESTDIR=${D}
}

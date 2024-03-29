SUMMARY = "FRU library and utils"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base"
TPSDK_REPO ?= "gitlab.elpitech.ru"
KBRANCH = "master"
SRCREV = "AUTOINC"
SRC_URI = "git://${TPSDK_REPO}/baikal-t/libmitxfru.git;protocol=ssh;user=git;branch=${KBRANCH} \
           file://Makefile.patch \
           file://setpass"

S = "${WORKDIR}/git"

FILES:${PN} = "/sbin/setpass /usr/bin/mitxfru-tool"

do_install() {
	oe_runmake install DESTDIR=${D}
	install -D -m 0755 ${WORKDIR}/setpass ${D}/sbin/setpass
}

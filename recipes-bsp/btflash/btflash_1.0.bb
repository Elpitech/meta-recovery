SUMMARY = "ROM Flash Utility"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base"

TPSDK_REPO ?= "gitlab.tpl"
KBRANCH = "master"

PV = "1.0"

SRCREV = "AUTOINC"
SRC_URI = "git://${TPSDK_REPO}/utils/btflash.git;protocol=ssh;user=git;branch=${KBRANCH} \
           file://Makefile.patch "

S = "${WORKDIR}/git"

do_install() {
	oe_runmake install DESTDIR=${D}
}

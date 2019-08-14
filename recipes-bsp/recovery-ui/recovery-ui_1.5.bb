SUMMARY = "Recovery User Interface Utility"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base"
DEPENDS = "ncurses zlib"
RDEPENDS_${PN} = "btflash dialog pv"

TPSDK_REPO ?= "gitlab.tpl"
KBRANCH = "master"

PV = "1.5"

FILES_${PN} = "${sysconfdir}/init.d/* ${bindir}/*"

SRCREV = "AUTOINC"
SRC_URI = "git://${TPSDK_REPO}/utils/recovery-ui.git;protocol=ssh;user=git;branch=${KBRANCH} \
           file://recovery-ui \
           file://btflash.sh \
           file://check-recovery.sh"

INITSCRIPT_NAME = "recovery-ui"
INITSCRIPT_PARAMS = "start 40 S ."

inherit update-rc.d

S = "${WORKDIR}/git"

do_compile() {
	case ${MACHINE} in
	mitx) BOARD=mitx4 ;;
	bn1bt1) BOARD=bn1bt1 ;;
	*) BOARD= ;;
	esac
	oe_runmake BOARD=$BOARD REC_VERSION=${PV}
}

do_install() {
	oe_runmake install DESTDIR=${D}
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/recovery-ui ${D}${sysconfdir}/init.d/recovery-ui
	install -m 0755 ${WORKDIR}/btflash.sh ${D}${bindir}
	install -m 0755 ${WORKDIR}/check-recovery.sh ${D}${bindir}
}

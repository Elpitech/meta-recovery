SUMMARY = "Serio wrapper for PS/2 keyboard over serial line"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://serkbd.c \
           file://keyboard.in"

S = "${WORKDIR}"

RECOVERY_SERIO_LINE ?= ""

INITSCRIPT_NAME = "keyboard"
INITSCRIPT_PARAMS = "start 04 S ."

inherit update-rc.d

do_compile() {
	if [ -z "${RECOVERY_SERIO_LINE}" ] ; then
		echo "RECOVERY_SERIO_LINE must be defined"
		exit 1
	fi
	${CC} ${CFLAGS} ${LDFLAGS} -o ${S}/serkbd ${S}/serkbd.c
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/serkbd ${D}${sbindir}/serkbd
	install -d ${D}${sysconfdir}/init.d
	sed -e "s/@@SERIO_LINE@@/${RECOVERY_SERIO_LINE}/" ${S}/keyboard.in > ${S}/keyboard
	install -m 0755 ${S}/keyboard ${D}${sysconfdir}/init.d/keyboard
}


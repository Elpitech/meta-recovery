
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RECOVERY_FONT ?= ""

SRC_URI += "file://rcS-default \
            file://mountall.sh \
            file://halt \
            file://reboot \
            file://urandom \
            file://bootmisc.sh \
            ${@["", "file://console"][(d.getVar('RECOVERY_FONT') != '')]} \
            ${@["", "file://getpass"][(d.getVar('RECOVERY_SETPASS') != '')]} \
            file://populate-volatile.sh"

HALTARGS = "-f"

do_install:append () {
	install -d ${D}${sysconfdir}/default
	install -m 0644 ${WORKDIR}/rcS-default ${D}${sysconfdir}/default/rcS

	if [ -n "${RECOVERY_FONT}" ] ; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/console ${D}${sysconfdir}/init.d/console
		update-rc.d -r ${D} console start 34 S .
		echo CONSOLEFONT="${RECOVERY_FONT}" >> ${D}${sysconfdir}/default/rcS
	fi
	if [ -n "${RECOVERY_SETPASS}" ] ; then
		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${WORKDIR}/getpass ${D}${sysconfdir}/init.d/getpass
		update-rc.d -r ${D} getpass start 10 S .
	fi

        # Create build-specific random seed
	dd if=/dev/urandom of=${WORKDIR}/random-seed count=1
	install -d ${D}${localstatedir}/lib/urandom/
	install -m 0777 ${WORKDIR}/random-seed ${D}${localstatedir}/lib/urandom/
}

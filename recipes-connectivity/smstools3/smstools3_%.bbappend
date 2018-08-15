
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://smsd.conf"

do_install () {
    install -d ${D}${bindir}
    install -m 755 ${S}/src/smsd "${D}${bindir}/smsd"

    install -m 755 ${S}/scripts/sendsms "${D}${bindir}/sendsms"
    install -m 755 ${S}/scripts/sms2html "${D}${bindir}/sms2html"
    install -m 755 ${S}/scripts/sms2unicode "${D}${bindir}/sms2unicode"
    install -m 755 ${S}/scripts/unicode2sms "${D}${bindir}/unicode2sms"

    install -d ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/smsd.conf "${D}${sysconfdir}/smsd.conf"

    install -d "${D}${localstatedir}/spool"
    install -d "${D}${localstatedir}/spool/sms"
    install -d "${D}${localstatedir}/spool/sms/incoming"
    install -d "${D}${localstatedir}/spool/sms/outgoing"
    install -d "${D}${localstatedir}/spool/sms/checked"

    install -d ${D}${sysconfdir}/init.d
    install -m 755 ${S}/scripts/sms3 "${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}"
    if [ "${VIRTUAL-RUNTIME_init_manager}" == "busybox" ]; then
        sed -i -e "s,^PSOPT=.*,PSOPT=''," ${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}
    fi
}

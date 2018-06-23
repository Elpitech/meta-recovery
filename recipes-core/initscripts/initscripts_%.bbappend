
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rcS-default \
            file://mountall.sh \
            file://urandom \
            file://bootmisc.sh \
            file://populate-volatile.sh"

do_install_append () {
	install -d ${D}${sysconfdir}/default
	install -m 0644 ${WORKDIR}/rcS-default ${D}${sysconfdir}/default/rcS

        # Create build-specific random seed
	dd if=/dev/urandom of=${WORKDIR}/random-seed count=1
	install -d ${D}${localstatedir}/lib/urandom/
	install -m 0777 ${WORKDIR}/random-seed ${D}${localstatedir}/lib/urandom/
}

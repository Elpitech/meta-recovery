SUMMARY = "Link-layer (layer 2) ping utility"
HOMEPAGE = "https://linkloop.sourceforge.io/"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SRC_URI = "git://github.com/fancer/linkloop.git \
           file://linkloopd"
SRCREV = "v${PV}"
S = "${WORKDIR}/git"

inherit autotools update-rc.d

INITSCRIPT_NAME = "linkloopd"

# Disable linkloop_reply server on boot for now
# INITSCRIPT_PARAMS = "defaults 20"
INITSCRIPT_PARAMS = "stop 10 0 1 6 ."

do_install:append () {
	install -d ${D}${sysconfdir}
	install -d ${D}${sysconfdir}/init.d

	sed -e 's,/etc,${sysconfdir},g' \
		-e 's,/usr/sbin,${sbindir},g' \
		-e 's,/var,${localstatedir},g' \
		-e 's,/usr/bin,${bindir},g' \
		-e 's,/usr,${prefix},g' ${WORKDIR}/linkloopd > ${D}${sysconfdir}/init.d/linkloopd
	chmod 755 ${D}${sysconfdir}/init.d/linkloopd
}

BBCLASSEXTEND += "native nativesdk"

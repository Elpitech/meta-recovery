
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://p5600.cfg"

BBCLASSEXTEND += "native"

do_install:append() {
    cp -f ${WORKDIR}/p5600.cfg ${D}${datadir}/openocd/scripts/target
}

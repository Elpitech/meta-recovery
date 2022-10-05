
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://interfaces"

do_install:append() {
    if [ -n "${RECOVERY_AUTO_INTERFACES}" ] ; then
        sed -i -e "s/auto.*/& ${RECOVERY_AUTO_INTERFACES}/" ${D}${sysconfdir}/network/interfaces
    fi
}

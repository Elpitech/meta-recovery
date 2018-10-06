SUMMARY = "Standalone management tools for SiliconLabs cp210x serial controllers"
HOMEPAGE = "https://github.com/fancer/smt-cp210x"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6d9d7e78eb4f127a22fd3d8b29cb7686"

# util-linux added to get libuuid
DEPENDS = "libusb1 util-linux"

SRC_URI = "git://github.com/fancer/smt-cp210x.git \
           file://cp2108_p234_rs485.configuration"
SRCREV = "AUTOINC"

S = "${WORKDIR}/git"

inherit cmake

BBCLASSEXTEND += "native nativesdk"

FILES_${PN} += "${sysconfdir}/smt/cp210x"
RDEPENDS_${PN} += "libusb1 util-linux-libuuid"

do_install_append() {
	install -d ${D}${sysconfdir}/smt/cp210x
	install -m 0644 ${WORKDIR}/cp2108_p234_rs485.configuration ${D}${sysconfdir}/smt/cp210x

	rm -rf ${D}${sysconfdir}/udev
}

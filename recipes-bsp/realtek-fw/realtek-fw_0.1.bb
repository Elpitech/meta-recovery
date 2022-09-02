SUMMARY = "Realtek firmware and utility"
LICENSE = "CLOSED"
SECTION = "base"

SRC_URI = "http://update.elpitech.ru/dists/tpsdk/${PN}-${PV}.tar.gz"
SRC_URI[md5sum] = "578abac1deb50de4c7ae6838e2e70aca"

REALTEK_FIRMWARE_BIN ?= "R_4838_ALC4040_ECS_Headset+LINEIN_V03_20190218.rfw"
FIRMWARE_BIN = "${REALTEK_FIRMWARE_BIN}"

FILES:${PN} = "/usr \
  /usr/lib \
  /usr/lib/realtek \
  /usr/lib/realtek/${FIRMWARE_BIN} \
  /usr/lib/realtek/rt_UAC_utility \
  /etc \
  /etc/init.d \
  /etc/init.d/realtek"

S = "${WORKDIR}/${PN}-${PV}"

INITSCRIPT_NAME = "realtek"
INITSCRIPT_PARAMS = "start 04 S ."

INSANE_SKIP:${PN} = "already-stripped"

inherit update-rc.d

do_install() {
	install -d ${D}${libdir}/realtek
	install -m 0755 ${S}/rt_UAC_utility ${D}${libdir}/realtek/rt_UAC_utility
	install -m 0644 ${S}/${FIRMWARE_BIN} ${D}${libdir}/realtek/${FIRMWARE_BIN}
	install -d ${D}${sysconfdir}/init.d
	sed -e "s/@@FIRMWARE_BIN@@/${FIRMWARE_BIN}/" ${S}/realtek.in > ${S}/realtek
	install -m 0755 ${S}/realtek ${D}${sysconfdir}/init.d/realtek
}

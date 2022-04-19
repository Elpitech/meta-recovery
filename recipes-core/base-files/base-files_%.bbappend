
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://issue \
            file://issue.net"

do_install:append() {
	printf "${RECOVERY_VERSION}" > ${D}${sysconfdir}/recovery-version
	chmod 644 ${D}${sysconfdir}/recovery-version
	printf "/dev/mtd1 0x0000 0x10000 0x1000" > ${D}${sysconfdir}/fw_env.config
	chmod 644 ${D}${sysconfdir}/fw_env.config
}

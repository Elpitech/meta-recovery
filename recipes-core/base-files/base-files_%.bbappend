
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://issue \
            file://issue.net"

do_install_append() {
	printf "${RECOVERY_VERSION}" > ${D}${sysconfdir}/recovery-version
	chmod 644 ${D}${sysconfdir}/recovery-version
}

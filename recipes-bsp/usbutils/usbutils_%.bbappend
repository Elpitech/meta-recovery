
inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} = "lsusb"
ALTERNATIVE_LINK_NAME[lsusb] = "${bindir}/lsusb"

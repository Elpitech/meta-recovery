
inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} = "i2cdetect i2cdump i2cget i2cset"
ALTERNATIVE_LINK_NAME[i2cdetect] = "${sbindir}/i2cdetect"
ALTERNATIVE_LINK_NAME[i2cdump] = "${sbindir}/i2cdump"
ALTERNATIVE_LINK_NAME[i2cget] = "${sbindir}/i2cget"
ALTERNATIVE_LINK_NAME[i2cset] = "${sbindir}/i2cset"

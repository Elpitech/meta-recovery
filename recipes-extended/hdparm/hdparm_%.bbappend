
inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} = "hdparm"
ALTERNATIVE_LINK_NAME[hdparm] = "${base_sbindir}/hdparm"

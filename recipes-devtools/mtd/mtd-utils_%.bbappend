
ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} += "flashcp flash_lock flash_unlock nandwrite nanddump"
ALTERNATIVE_LINK_NAME[flashcp] = "${sbindir}/flashcp"
ALTERNATIVE_LINK_NAME[flash_lock] = "${sbindir}/flash_lock"
ALTERNATIVE_LINK_NAME[flash_unlock] = "${sbindir}/flash_unlock"
ALTERNATIVE_LINK_NAME[nandwrite] = "${sbindir}/nandwrite"
ALTERNATIVE_LINK_NAME[nanddump] = "${sbindir}/nanddump"


inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} = "mkdosfs mkfs.vfat"
ALTERNATIVE_TARGET[mkdosfs] = "${sbindir}/mkdosfs"
ALTERNATIVE_LINK_NAME[mkdosfs] = "${base_sbindir}/mkdosfs"
ALTERNATIVE_TARGET[mkfs.vfat] = "${sbindir}/mkfs.vfat"
ALTERNATIVE_LINK_NAME[mkfs.vfat] = "${base_sbindir}/mkfs.vfat"

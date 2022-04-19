
ALTERNATIVE:${PN}-mke2fs += "mke2fs mkfs.ext2"
ALTERNATIVE_LINK_NAME[mke2fs] = "${base_sbindir}/mke2fs"
ALTERNATIVE_LINK_NAME[mkfs.ext2] = "${base_sbindir}/mkfs.ext2"

ALTERNATIVE:${PN}-tune2fs = "tune2fs"
ALTERNATIVE_LINK_NAME[tune2fs] = "${base_sbindir}/tune2fs"


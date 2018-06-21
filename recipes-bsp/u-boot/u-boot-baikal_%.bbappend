
inherit tpsdksrc

TPSDK_SUBDIR = "u-boot"

EXTRA_OEMAKE_append = " VERSION_APPEND=' / ${DISTRO} ${DISTRO_VERSION}'"

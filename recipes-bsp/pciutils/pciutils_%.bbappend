
inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE:${PN} = "lspci"
ALTERNATIVE_LINK_NAME[lspci] = "${bindir}/lspci"

BBCLASSEXTEND += "native nativesdk"

# Discard pciutils-ids, it breaks the native* builds
RDEPENDS:${PN}:remove:class-native = "${PN}-ids"

RDEPENDS:${PN}:remove:class-nativesdk = "${PN}-ids"

do_install:class-native () {
    oe_runmake DESTDIR=${D} install install-lib

    oe_multilib_header pci/config.h
}

do_install:class-nativesdk () {
    oe_runmake DESTDIR=${D} install install-lib

    oe_multilib_header pci/config.h
}


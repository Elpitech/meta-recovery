
inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE_${PN} = "lspci"
ALTERNATIVE_LINK_NAME[lspci] = "${bindir}/lspci"

BBCLASSEXTEND += "native nativesdk"

# Discard pciutils-ids, it breaks the native* builds
RDEPENDS_${PN}_remove_class-native = "${PN}-ids"

RDEPENDS_${PN}_remove_class-nativesdk = "${PN}-ids"

do_install_class-native () {
    oe_runmake DESTDIR=${D} install install-lib

    oe_multilib_header pci/config.h
}

do_install_class-nativesdk () {
    oe_runmake DESTDIR=${D} install install-lib

    oe_multilib_header pci/config.h
}


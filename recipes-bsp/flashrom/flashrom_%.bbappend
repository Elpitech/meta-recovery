DEPENDS += "libftdi"

do_install:append:class-nativesdk() {
    mv ${D}${prefix}/sbin ${D}${sbindir}
}

BBCLASSEXTEND += "nativesdk"

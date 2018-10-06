SUMMARY = "Make a hexdump or do the reverse"
HOMEPAGE = "https://github.com/fancer/xxd"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
DEPENDS = "coreutils-native"

SRC_URI = "git://github.com/fancer/xxd.git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND += "native nativesdk"

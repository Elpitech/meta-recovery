SUMMARY = "Standalone management tools for IDT 89HPESx PCIe switches"
HOMEPAGE = "https://github.com/T-Platforms/smt-89hpesX"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "git://192.168.1.253/IT/T-Platforms/utils/smt-89hpesX;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND += "native nativesdk"
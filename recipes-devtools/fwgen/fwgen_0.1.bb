SUMMARY = "Binary Firmware Generation Tool"
HOMEPAGE = "https://github.com/Elpitech/baikal-t-fwgen"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

TPSDK_REPO ?= "gitlab.elp"

SRC_URI = "git://${TPSDK_REPO}/utils/fwgen;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit cmake

BBCLASSEXTEND += "native nativesdk"

FILES_${PN} += "${sysconfdir}/fwgen"

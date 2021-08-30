SUMMARY = "Binary Firmware Generation Tool"
HOMEPAGE = "https://github.com/T-Platforms/fwgen"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

TPSDK_REPO ?= "github.com"

SRC_URI = "git://${TPSDK_REPO}/Elpitech/baikal-t-fwgen;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit cmake

BBCLASSEXTEND += "native nativesdk"

FILES_${PN} += "${sysconfdir}/fwgen"

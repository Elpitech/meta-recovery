SUMMARY = "Recovery Image information parser"
HOMEPAGE = "https://github.com/T-Platforms/recovery-image-info"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://192.168.1.253/IT/T-Platforms/sdk/rii;protocol=ssh;user=git"
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND += "native nativesdk"

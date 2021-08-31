SUMMARY = "T-platforms MRBT1 BMC pulse counter tools"
HOMEPAGE = "https://github.com/Elpitech/baikal-t-pulse-cntr"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

TPSDK_REPO ?= "gitlab.elp"

SRC_URI = "git://${TPSDK_REPO}/utils/pulse-cntr;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit cmake

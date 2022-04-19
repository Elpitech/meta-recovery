DESCRIPTION = "Drivers package for T-platforms CNC devices"
LICENSE = "GPLv2|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SECTION = "kernel"

inherit module

TPSDK_REPO ?= "gitlab.elpitech.ru"

SRC_URI = "git://${TPSDK_REPO}/baikal-t/cnc;protocol=ssh;user=git"
SRCREV = "AUTOINC"

S = "${WORKDIR}/git"

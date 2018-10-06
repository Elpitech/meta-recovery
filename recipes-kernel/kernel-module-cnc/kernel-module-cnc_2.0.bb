DESCRIPTION = "Drivers package for T-platforms CNC devices"
LICENSE = "GPLv2|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SECTION = "kernel"

DEPENDS = "virtual/kernel"

inherit module

SRC_URI = "git://192.168.1.253/IT/T-Platforms/sdk/cnc;protocol=ssh;user=git"
SRCREV = "AUTOINC"

S = "${WORKDIR}/git"

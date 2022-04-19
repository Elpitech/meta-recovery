SUMMARY = "Recovery Image information parser"
HOMEPAGE = "https://github.com/Elpitech/baikal-t-recovery-image-info"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "coreutils-native"

TPSDK_REPO ?= "gitlab.elpitech.ru"

SRC_URI = "git://${TPSDK_REPO}/utils/recovery-image-info;protocol=ssh;user=git"
SRCREV = "AUTOINC"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF:append = " RII_MAGIC=${IMAGE_INFO_MAGIC}"

EXTRA_OECONF:append:class-target = " RII_DEFAULT_NAME=${RECOVERY_MTD_INFO}"
EXTRA_OECONF:append:class-target = " RII_DEFAULT_ADDR=0x0U"

EXTRA_OECONF:append:class-nativesdk = " RII_DEFAULT_NAME=baikal-image-recovery-${ROM_SYMLINK_NAME}.rom"
EXTRA_OECONF:append:class-nativesdk = " RII_DEFAULT_ADDR=${@'${RECOVERY_ROM_INFORMATION}'.split(':')[0]}U"

BBCLASSEXTEND += "native nativesdk"

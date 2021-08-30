SUMMARY = "Recovery Image information parser"
HOMEPAGE = "https://github.com/T-Platforms/recovery-image-info"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "coreutils-native"

TPSDK_REPO ?= "github.com"

SRC_URI = "git://${TPSDK_REPO}/Elpitech/baikal-t-recovery-image-info;protocol=ssh;user=git"
SRCREV = "AUTOINC"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF_append = " RII_MAGIC=${IMAGE_INFO_MAGIC}"

EXTRA_OECONF_append_class-target = " RII_DEFAULT_NAME=${RECOVERY_MTD_INFO}"
EXTRA_OECONF_append_class-target = " RII_DEFAULT_ADDR=0x0U"

EXTRA_OECONF_append_class-nativesdk = " RII_DEFAULT_NAME=baikal-image-recovery-${ROM_SYMLINK_NAME}.rom"
EXTRA_OECONF_append_class-nativesdk = " RII_DEFAULT_ADDR=${@'${RECOVERY_ROM_INFORMATION}'.split(':')[0]}U"

BBCLASSEXTEND += "native nativesdk"

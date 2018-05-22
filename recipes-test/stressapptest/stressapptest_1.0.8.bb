SUMMARY = "A memory interface test"
HOMEPAGE = "https://github.com/stressapptest/stressapptest"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=55ea9d559f985fb4834317d8ed6b9e58"

DEPENDS = "libaio"

SRC_URI = "https://github.com/${BPN}/${BPN}/archive/v${PV}.tar.gz"
SRC_URI[md5sum] = "f1c266b6aa657273a36d9e68c5c5d052"
SRC_URI[sha256sum] = "b0432f39055166156ed04eb234f3c226b17a42f802a3f81d76ee999838e205df"

inherit autotools

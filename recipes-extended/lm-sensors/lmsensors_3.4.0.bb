SUMMARY = "A hardware health monitoring package for Linux"
DESCRIPTION = "Lm-sensors is a hardware health monitoring package for Linux. \
               It allows you to access information from temperature, voltage, \
               and fan speed sensors."
HOMEPAGE = "https://github.com/groeck/lm-sensors"
DEPENDS = "sysfsutils virtual/libiconv bison-native flex-native"
LICENSE = "GPLv2 & LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
                    file://COPYING.LGPL;md5=4fbd65380cdd255951079008b364516c"

PR = "r3"

SRC_URI = "https://github.com/groeck/lm-sensors/archive/${@'V${PV}'.replace('.','-')}.tar.gz"

SRC_URI[md5sum] = "1e9f117cbfa11be1955adc96df71eadb"
SRC_URI[sha256sum] = "e334c1c2b06f7290e3e66bdae330a5d36054701ffd47a5dde7a06f9a7402cb4e"

S = "${WORKDIR}/lm-sensors-${@'${PV}'.replace('.','-')}/"

EXTRA_OEMAKE = 'LINUX=${STAGING_KERNEL_DIR} EXLDFLAGS="${LDFLAGS}" \
		MACHINE=${TARGET_ARCH} PREFIX=${prefix} CC="${CC}" \
		AR="${AR}" MANDIR=${mandir}'

INSANE_SKIP_${PN} += "installed-vs-shipped"

do_compile() {
	oe_runmake user PROG_EXTRA=sensors
}

do_install() {
	oe_runmake user_install DESTDIR=${D}
}

PACKAGES =  "libsensors libsensors-dev libsensors-staticdev libsensors-dbg libsensors-doc"
PACKAGES =+ "lmsensors-sensors lmsensors-sensors-dbg lmsensors-sensors-doc"
PACKAGES =+ "lmsensors-scripts"

FILES_lmsensors-scripts  = "${bindir}/*.pl ${bindir}/ddcmon ${bindir}/sensors-conf-convert"
FILES_lmsensors-scripts += "${sbindir}/fancontrol* ${sbindir}/pwmconfig ${sbindir}/sensors-detect"
RDEPENDS_lmsensors-scripts += "lmsensors-sensors perl bash"
RDEPENDS_lmsensors-apps += "perl-module-strict perl-module-vars perl-module-warnings-register perl-module-warnings"
RDEPENDS_lmsensors-scripts += "perl-module-fcntl perl-module-exporter perl-module-xsloader perl-module-exporter-heavy perl-module-file-basename perl-module-constant"

FILES_lmsensors-sensors = "${bindir}/sensors ${sysconfdir}"
FILES_lmsensors-sensors-dbg += "${bindir}/.debug/sensors"
FILES_lmsensors-sensors-doc = "${mandir}/man1 ${mandir}/man5 ${mandir}/man8"
FILES_libsensors = "${libdir}/libsensors${SOLIBS}"
FILES_libsensors-dbg += "${libdir}/.debug"
FILES_libsensors-dev = "${libdir}/libsensors${SOLIBSDEV} ${includedir}"
FILES_libsensors-staticdev = "${libdir}/libsensors.a"
FILES_libsensors-doc = "${mandir}/man3"

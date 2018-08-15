PACKAGECONFIG_NUMA_mips = ""
PACKAGECONFIG_NUMA_mipsel = ""

do_install_append() {
    # Discard unused GNU-plot files
    rm -rf ${D}${datadir}/fio ${D}${bindir}/fio2gnuplot
}

# FILES_tbench = "${bindir}/tbench* ${prefix}/share/client.txt"
FILES:tbench = "${bindir}/tbench*"

do_install:append() {
    # Discard client.txt since it is too heavy (~26Mb)
    rm -rf ${D}${datadir}/client.txt
}

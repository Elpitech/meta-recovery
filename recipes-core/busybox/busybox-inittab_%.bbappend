
do_install:append() {
    if [ -f ${D}${sysconfdir}/inittab ]; then
        sed -i -e "4,11s/.*/# &/" ${D}${sysconfdir}/inittab
        sed -i -e "23,24s/.*/# &/" ${D}${sysconfdir}/inittab
    fi
}


do_install_append() {
    if [ -f ${D}${sysconfdir}/inittab ]; then
        sed -i -e "4,10s/.*/# &/" ${D}${sysconfdir}/inittab
        sed -i -e "17,18s/.*/# &/" ${D}${sysconfdir}/inittab
    fi
}

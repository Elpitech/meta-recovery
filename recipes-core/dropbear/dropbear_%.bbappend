
# Disable dropbear ssh-server initialization on boot
INITSCRIPT_PARAMS ?= "stop 10 0 1 6 ."

do_install:append() {
    if [ x"${DROPBEAR_ALLOW_ROOT}" = "xy" ] ; then
        rm -f ${D}/${sysconfdir}/default/dropbear
    fi
}


inherit update-alternatives

ALTERNATIVE_PRIORITY = "100"

ALTERNATIVE:${PN} = "setserial"
ALTERNATIVE_LINK_NAME[setserial] = "${base_bindir}/setserial"
ALTERNATIVE_TARGET[setserial] = "${bindir}/setserial"

inherit externalsrc

TPSDK_SUBDIR ?= ""

# Clean up the SRC_URI-related variables if T-platforms SDK mode is enabled, otherwise
# the externalsrc.bbclass will fetch it. Additionally the path must be passed to
# externalsrc.bbclass
EXTERNALSRC_tpsdksrc = "${TPSDK_DIR}/${TPSDK_SUBDIR}"
SRC_URI_tpsdksrc = ""
SRCREV_tpsdksrc = ""
S_tpsdksrc = ""

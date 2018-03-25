
TPSDK_SUBDIR = "kernel"

# We need to set source directory pointing to the kernel external source
# directory in case if externalsrc is used within tpsdksrc (it seems
# more like workaround though)
S_tpsdksrc = "${TPSDK_DIR}/${TPSDK_SUBDIR}"

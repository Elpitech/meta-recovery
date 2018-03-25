#
# Select toolchain mode of the project
#
# These settings shouldn't be touched, they are utilized to properly initialize
# the meta-external-toolchain layer, so it would either use toolchain supplied
# by TPSDK or download it via recipes uri.
#
TCMODE ?= "${@'external' if '${TPSDK_XTC}' == 'sdk' else 'default'}"
EXTERNAL_TARGET_SYS ?= "${TPSDK_SYS}"
EXTERNAL_TOOLCHAIN ?= "${TPSDK_XTOOLS_DIR}/${TPSDK_SYS}"
EXTERNAL_PROPAGATE_MODE = "1"

#
# Discard/Append some toolchain features
#
# We can't use floating point 64 feature within the precompiled toolchain, since
# its basic object haven't been compiled with one. Additionally we wanna have
# the msa feature being enabled while using the tools built by yocto.
#
TUNE_FEATURES_remove_tpsdkxtc = "fp64"
TUNE_FEATURES_append_tpgitxtc = " msa"

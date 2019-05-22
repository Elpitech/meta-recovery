# Subset of linux-firmware-radeon for Oland GPU

PACKAGES =+ "${PN}-radeon-oland"

radeon_fw_dir = "${nonarch_base_libdir}/firmware/radeon"
FILES_${PN}-radeon-oland = "${radeon_fw_dir}/oland_mc.bin \
                            ${radeon_fw_dir}/oland_smc.bin \
                            ${radeon_fw_dir}/oland_ce.bin \
                            ${radeon_fw_dir}/oland_pfp.bin \
                            ${radeon_fw_dir}/oland_me.bin \
                            ${radeon_fw_dir}/oland_rlc.bin \
                            ${radeon_fw_dir}/TAHITI_uvd.bin"


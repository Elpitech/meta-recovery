# Copyright (C) 2018, T-platforms, Inc.  All Rights Reserved
# Released under the GPLv2 license (see packages/COPYING)

# Creates a Baikal-T ROM-image informational section

#
# End result is:
#
# Binaty blob with common settings of the build system and utilities
# used to create the image

# External variables
# {IMAGE_INFO_MAGIC} - info-section magic number
# {IMAGE_INFO_DISTRO} - recovery distribution name
# {IMAGE_INFO_VERSION} - recovery distribution version
# {IMAGE_INFO_MACHINE} - target machine of the distribution
# {IMAGE_INFO_HOSTNAME} - host-name
# {IMAGE_INFO_UBOOT_VERSION} - U-boot version
# {IMAGE_INFO_KERNEL_VERSION} - Kernel version
# {IMAGE_INFO_COMPILER_VERSION} - compiler version
# {IMAGE_INFO_COMPILER_FEATURES} - list of compiler features
# {IMAGE_INFO_DATETIME} - date-time of the build
# {IMAGE_INFO_ROM_BASE} - ROM-image base address in RAM
# {IMAGE_INFO_ROM_SIZE} - ROM-image size (SPI-flash size)
# {IMAGE_INFO_BOOTLOADER_BASE} - bootloader section base address within the image
# {IMAGE_INFO_BOOTLOADER_SIZE} - bootloader section size
# {IMAGE_INFO_ENVIRONMENT_BASE} - u-boot environmant section base address
# {IMAGE_INFO_ENVIRONMENT_SIZE} - u-boot environment section size
# {IMAGE_INFO_INFORMATION_BASE} - informational section base address
# {IMAGE_INFO_INFORMATION_SIZE} - informational section size
# {IMAGE_INFO_FITIMAGE_BASE} - FIT-image section base address
# {IMAGE_INFO_FITIMAGE_SIZE} - FIT-image section size
# {IMAGE_INFO_FITIMAGE_SIGNED} - FIT-image signature flag 
# {IMAGE_INFO_SYSTEM_UTILS} - list of system utilities
# {IMAGE_INFO_EXTRA_UTILS} - list of extra programs
# {IMAGE_INFO_TEST_BENCHES} - list of test benches
# {IMAGE_INFO_EXTRA_LINGUAS} - list of additional locales

IMAGE_INFO_MAGIC ?= "${@'${RECOVERY_INFO_MAGIC}'.replace('U', '').replace('L', '')}"
IMAGE_INFO_DISTRO ?= "${DISTRO_NAME}"
IMAGE_INFO_VERSION ?= "${DISTRO_VERSION}"
IMAGE_INFO_MACHINE ?= "${MACHINE}"
IMAGE_INFO_HOSTNAME ?= "${RECOVERY_HOSTNAME}"
IMAGE_INFO_UBOOT_VERSION ?= "${PREFERRED_VERSION_u-boot-baikal}"
IMAGE_INFO_KERNEL_VERSION ?= "${PREFERRED_VERSION_linux-baikal}"
IMAGE_INFO_COMPILER_VERSION ?= "${GCCVERSION}"
IMAGE_INFO_COMPILER_FEATURES ?= "${TUNE_FEATURES}"
IMAGE_INFO_DATETIME ?= "${DATETIME}"
IMAGE_INFO_DATETIME[vardepsexclude] += "DATETIME"
IMAGE_INFO_ROM_BASE ?= "${RECOVERY_ROM_BASE}"
IMAGE_INFO_ROM_SIZE ?= "${RECOVERY_ROM_SIZE}"
IMAGE_INFO_BOOTLOADER_BASE ?= "${@'${RECOVERY_ROM_BOOTLOADER}'.split(':')[0]}"
IMAGE_INFO_BOOTLOADER_SIZE ?= "${@'${RECOVERY_ROM_BOOTLOADER}'.split(':')[1]}"
IMAGE_INFO_ENVIRONMENT_BASE ?= "${@'${RECOVERY_ROM_ENVIRONMENT}'.split(':')[0]}"
IMAGE_INFO_ENVIRONMENT_SIZE ?= "${@'${RECOVERY_ROM_ENVIRONMENT}'.split(':')[1]}"
IMAGE_INFO_INFORMATION_BASE ?= "${@'${RECOVERY_ROM_INFORMATION}'.split(':')[0]}"
IMAGE_INFO_INFORMATION_SIZE ?= "${@'${RECOVERY_ROM_INFORMATION}'.split(':')[1]}"
IMAGE_INFO_FITIMAGE_BASE ?= "${@'${RECOVERY_ROM_FITIMAGE}'.split(':')[0]}"
IMAGE_INFO_FITIMAGE_SIZE ?= "${@'${RECOVERY_ROM_FITIMAGE}'.split(':')[1]}"
IMAGE_INFO_FITIMAGE_SIGNED ?= "${UBOOT_SIGN_ENABLE}"
IMAGE_INFO_SYSTEM_UTILS ?= "base - ${VIRTUAL-RUNTIME_base-utils}, init - ${VIRTUAL-RUNTIME_init_manager}/${VIRTUAL-RUNTIME_initscripts}, login - ${VIRTUAL-RUNTIME_login_manager}, dev-manager - ${VIRTUAL-RUNTIME_dev_manager}, syslog - ${VIRTUAL-RUNTIME_syslog}"
IMAGE_INFO_EXTRA_UTILS ?= "${RECOVERY_IMAGE_EXTRA_INSTALL}"
IMAGE_INFO_TEST_BENCHES ?= "${RECOVERY_IMAGE_TEST_BENCHES}"
IMAGE_INFO_EXTRA_LINGUAS ?= "${RECOVERY_IMAGE_EXTRA_LINGUAS}"

IMAGE_INFO_DEPLOY_DIR = "${WORKDIR}/image-info"
IMAGE_INFO_BASE_NAME ??= "${PN}-${MACHINE}-${DATETIME}"
IMAGE_INFO_SYMLINK_NAME ??= "${PN}-${MACHINE}"
IMAGE_INFO_BASE_NAME[vardepsexclude] += "DATETIME"

DEPENDS_append = " coreutils-native xxd-native"

image_info_dump_int() {
    size="$1"
    data="$2"
    outfile="$3"

    if [ "$size" -eq "8" ]; then
        fmt="0: %.16x"
    elif [ "$size" -eq "4" ]; then
        fmt="0: %.8x"
    else
        fmt="0: %.2x"
    fi

    printf "$fmt" "$data" | xxd -r -g0 >> "$outfile"
}

image_info_dump_string() {
    size="$1"
    data="$2"
    outfile="$3"

    frame=$(expr $size - 1)

    data=$(echo -n "$data" | cut -c1-${frame})
    length=$(printf "%s" "$data" | wc -c)

    printf "%s" "$data" >> "$outfile"
    printf "%-$(expr ${frame} - ${length})s\0" "" | sed 's/ /\x00/g' >> "$outfile"
}

image_info_cook () {
    outfile=$1

    namelen="64"
    verslen="16"
    datelen="16"
    slistlen="128"
    llistlen="512"

    sections="int;8;${IMAGE_INFO_MAGIC};;\
              str;$namelen;${IMAGE_INFO_DISTRO};;\
              str;$verslen;${IMAGE_INFO_VERSION};;\
              str;$namelen;${IMAGE_INFO_MACHINE};;\
              str;$namelen;${IMAGE_INFO_HOSTNAME};;\
              str;$verslen;${IMAGE_INFO_UBOOT_VERSION};;\
              str;$verslen;${IMAGE_INFO_KERNEL_VERSION};;\
              str;$verslen;${IMAGE_INFO_COMPILER_VERSION};;\
              str;$slistlen;${IMAGE_INFO_COMPILER_FEATURES};;\
              str;$datelen;${IMAGE_INFO_DATETIME};;\
              int;4;${IMAGE_INFO_ROM_BASE};;\
              int;4;${IMAGE_INFO_ROM_SIZE};;\
              int;4;${IMAGE_INFO_BOOTLOADER_BASE};;\
              int;4;${IMAGE_INFO_BOOTLOADER_SIZE};;\
              int;4;${IMAGE_INFO_ENVIRONMENT_BASE};;\
              int;4;${IMAGE_INFO_ENVIRONMENT_SIZE};;\
              int;4;${IMAGE_INFO_INFORMATION_BASE};;\
              int;4;${IMAGE_INFO_INFORMATION_SIZE};;\
              int;4;${IMAGE_INFO_FITIMAGE_BASE};;\
              int;4;${IMAGE_INFO_FITIMAGE_SIZE};;\
              int;1;${IMAGE_INFO_FITIMAGE_SIGNED};;\
              str;$llistlen;${IMAGE_INFO_SYSTEM_UTILS};;\
              str;$llistlen;${IMAGE_INFO_EXTRA_UTILS};;\
              str;$llistlen;${IMAGE_INFO_TEST_BENCHES};;\
              str;$slistlen;${IMAGE_INFO_EXTRA_LINGUAS}"

    total="0"
    while [ -n "${sections}" ]; do
        # Retrieve current item to handle and check whether it's the last one in the sections list
        item=$(echo "${sections%%;;*}" | sed 's/^\s*//g;s/\s*$//g')
        sections=$(echo "${sections#*;;}" | sed 's/^\s*//g;s/\s*$//g')
        [ "${sections}" == "${item}" ] && sections=""

        # Retrieve section parameters
        type=$(printf "%s" "$item" | cut -d";" -f1)
        size=$(printf "%s" "$item" | cut -d";" -f2)
        data=$(printf "%s" "$item" | cut -d";" -f3)

        if [ "$type" == "int" ]; then
            image_info_dump_int "$size" "$data" "$outfile"
        else
            image_info_dump_string "$size" "$data" "$outfile"
        fi

        total=$(expr $total + $size)
    done

    crc=$(cksum $outfile | cut -d' ' -f1)
    image_info_dump_int "4" "$crc" "$outfile"
}

do_deploy_image_info() {
    image_info_cook "${IMAGE_INFO_DEPLOY_DIR}/${IMAGE_INFO_BASE_NAME}.bin"
    ln -sf "${IMAGE_INFO_BASE_NAME}.bin" "${IMAGE_INFO_DEPLOY_DIR}/${IMAGE_INFO_SYMLINK_NAME}.bin"
}
do_deploy_image_info[dirs] = "${IMAGE_INFO_DEPLOY_DIR}"
do_deploy_image_info[stamp-extra-info] = "${MACHINE}"
do_deploy_image_info[vardepsexclude] += "DATETIME"
SSTATETASKS += "do_deploy_image_info"
do_deploy_image_info[sstate-inputdirs] = "${IMAGE_INFO_DEPLOY_DIR}"
do_deploy_image_info[sstate-outputdirs] = "${DEPLOY_DIR_IMAGE}"
addtask do_deploy_image_info after do_image_complete before do_build

python do_image_info_setscene () {
    sstate_setscene(d)
}
addtask do_image_info_setscene

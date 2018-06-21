# Copyright (C) 2018, T-platforms, Inc.  All Rights Reserved
# Released under the GPLv2 license (see packages/COPYING)

# Creates a bootable image for Baikal-T SoC with kernel/dtbs/initramfs and
# U-boot bootloader with it environmant blob

#
# End result is:
#
# 1. A raw binary .rom image without any special filesystem containing
# U-boot FIT file with at least kernel and dtb, and bootloader with it
# environment binary file. It can be written to the Baikal-T SPI-boot-flash.

# Baikal-T SoC will then start by booting the U-boot bootloader as the image
# saved in the SPI-flash bottom address. U-boot menu will present a selectable
# items with different variants of booting. One of them is to load a kernel
# from flash and execute it. In this way the fitImage written to the rom-file
# will be loaded.

# External variables
# ${RECOVERY_ROM_SIZE} - size of the SPI-flash (it's 16MB and must be constant for now)
# ${RECOVERY_ROM_BASE} - physical base address of the SPI-flash within the SoC address space
# ${RECOVERY_ROM_BOOTLOADER} - bootloader section with base_address:size turple
# ${RECOVERY_ROM_ENVIRONMENT} - bootloader environment section turple
# ${RECOVERY_ROM_INFORMATION} - ROM-image informational section turple
# ${RECOVERY_ROM_FITIMAGE} - fitImage section turple

RECOVERY_ROM_BASE ?= "0x9C000000"
RECOVERY_ROM_SIZE ?= "16777216"
RECOVERY_ROM_BOOTLOADER  ?= "0x00000000:0x000E0000"
RECOVERY_ROM_ENVIRONMENT ?= "0x000E0000:0x00010000"
RECOVERY_ROM_INFORMATION ?= "0x000F0000:0x00010000"
RECOVERY_ROM_FITIMAGE    ?= "0x00100000:0x00F00000"

ROM_DEPLOY_DIR = "${WORKDIR}/image-rom"
ROM_BASE_NAME ??= "${PN}-${MACHINE}-${DATETIME}"
ROM_SYMLINK_NAME ??= "${PN}-${MACHINE}"
ROM_BASE_NAME[vardepsexclude] += "DATETIME"

ROM_BOOTLOADER_FILE = "${DEPLOY_DIR_IMAGE}/u-boot-${UBOOT_SYMLINK_NAME}.bin"
ROM_ENVIRONMENT_FILE = "${DEPLOY_DIR_IMAGE}/${UBOOT_ENV_SYMLINK_NAME}.bin"
ROM_INFORMATION_FILE = "${DEPLOY_DIR_IMAGE}/${IMAGE_INFO_SYMLINK_NAME}.bin"
ROM_FITIMAGE_INITRD_FILE = "${DEPLOY_DIR_IMAGE}/fitImage-initramfs-${FIT_IMAGE_SYMLINK_NAME}.bin"
ROM_FITIMAGE_KERNEL_FILE = "${DEPLOY_DIR_IMAGE}/fitImage-${FIT_IMAGE_SYMLINK_NAME}.bin"

baikal_image_dump_item() {
    name=$(printf "%s" "${1}" | cut -d":" -f1)
    position=$(printf "%s" "${1}" | cut -d":" -f2)
    partsize=$(printf "%s" "${1}" | cut -d":" -f3)
    infile=$(printf "%s" "${1}" | cut -d":" -f4)
    outfile="${2}"

    if [ ! -f "${infile}" ]; then
        bbfatal "Source file ${infile} of the section ${name} doesn't exist"
        return 1
    fi

    filesize=$(stat -c "%s" "${infile}")

    # Conver hex to decimals
    position=$(printf "%d" $position)
    partsize=$(printf "%d" $partsize)

    if [ "${filesize}" -gt "${partsize}" ]; then
        bbfatal "File size ${filesize} exceeds the section ${name} window ${partsize}"
        return 1
    fi

    # Dump the file to the section at certain position
    dd if="${infile}" of="${outfile}" bs=1 seek="${position}"

    # Append zeros to fill the section up
    dd if=/dev/zero of="${outfile}" bs=1 count=0 seek=$(expr $position + $partsize)

    echo ${partsize}
}

baikal_image_mkrom () {
    outfile=${1}

    sections="BOOTLOADER:${RECOVERY_ROM_BOOTLOADER}:${ROM_BOOTLOADER_FILE};;\
              ENVIRONMENT:${RECOVERY_ROM_ENVIRONMENT}:${ROM_ENVIRONMENT_FILE};;\
              INFORMATION:${RECOVERY_ROM_INFORMATION}:${ROM_INFORMATION_FILE}"

    if [ -f "${ROM_FITIMAGE_INITRD_FILE}" ]; then
        sections="${sections};;FITIMAGE:${RECOVERY_ROM_FITIMAGE}:${ROM_FITIMAGE_INITRD_FILE}"
    elif [ -f "${ROM_FITIMAGE_KERNEL_FILE}" ]; then
        bbnote "Using initramfs-less U-boot FIT image since one doesn't exist"
        sections="${sections};;FITIMAGE:${RECOVERY_ROM_FITIMAGE}:${ROM_FITIMAGE_KERNEL_FILE}"
    else
        bbfatal "FIT image doesn't exist"
    fi

    total="0"
    while [ -n "${sections}" ]; do
        # Retrieve current item to handle and check whether it's the last one in the sections list
        item=$(echo "${sections%%;;*}" | sed 's/^\s*//g;s/\s*$//g')
        sections=$(echo "${sections#*;;}" | sed 's/^\s*//g;s/\s*$//g')
        [ "${sections}" == "${item}" ] && sections=""

        itemsize=$(baikal_image_dump_item "${item}" "${outfile}")

        total=$(expr $total + $itemsize)
    done

    capacity=$(printf "%d" "${RECOVERY_ROM_SIZE}")

    # Make sure we haven't exceeded the device capacity
    if [ "${total}" -gt "${capacity}" ]; then
        bbfatal "Total rom-image sections size ${total} exceeds the device capacity ${capacity}"
        return
    fi

    # Pad the rest of the image with zeros
    dd if=/dev/zero of="${outfile}" bs=1 count=0 seek="${capacity}"
}

do_deploy_baikal_rom[depends] += "virtual/kernel:do_deploy \
                                  virtual/bootloader:do_deploy \
                                  "

do_deploy_baikal_rom() {
    baikal_image_mkrom "${ROM_DEPLOY_DIR}/${ROM_BASE_NAME}.rom"
    ln -sf "${ROM_BASE_NAME}.rom" "${ROM_DEPLOY_DIR}/${ROM_SYMLINK_NAME}.rom"
}
do_deploy_baikal_rom[dirs] = "${ROM_DEPLOY_DIR}"
do_deploy_baikal_rom[stamp-extra-info] = "${MACHINE}"
do_deploy_baikal_rom[vardepsexclude] += "DATETIME"
SSTATETASKS += "do_deploy_baikal_rom"
do_deploy_baikal_rom[sstate-inputdirs] = "${ROM_DEPLOY_DIR}"
do_deploy_baikal_rom[sstate-outputdirs] = "${DEPLOY_DIR_IMAGE}"
addtask do_deploy_baikal_rom after do_image_complete do_deploy_image_info before do_build

python do_baikal_rom_setscene () {
    sstate_setscene(d)
}
addtask do_baikal_rom_setscene

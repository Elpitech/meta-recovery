#
# T-platforms SDK version
#
# SDK version is statically set here so to have at least some value used
# by SDK-specific meta code.
#
TPSDK_VERSION ?= "2.0"
TPSDK_REVISION ?= "0"

#
# Yocto SDK settings
#
# SDK is suppose to run on x86_64 machines only, since pre-built toolchain
# got that cpu architecure..
# We need to set the common SDK parameters like its full name and default
# installation path. In addition we need to have flashrom and openocd
# natively installed, so the users could burn and debug the firmware.
# We also want the toolchain and debugger being included to the Extensible
# SDK by setting type to full in opposite to minimal. The kernel
# sources and headers, flashrom and openocd, static packages are included
# to the SDK as well.
#
SDKMACHINE = "x86_64"
SDK_VENDOR = "-tpsdk"
SDK_VERSION := "${TPSDK_VERSION}"
SDK_NAME = "${IMAGE_BASENAME}-${SDK_ARCH}-${TUNE_PKGARCH}"
SDKPATH = "/opt/${DISTRO}${SDK_VENDOR}/${SDK_VERSION}"
SDK_EXT_TYPE = "full"
#SDKIMAGE_FEATURES_append = " staticdev-pkg"
TOOLCHAIN_HOST_TASK_append = " nativesdk-flashrom nativesdk-openocd nativesdk-recovery-image-info"
TOOLCHAIN_TARGET_TASK_append = " kernel-devsrc"

#
# Default kernel/bootloader code source
#
# The setting is responsible for selecting the kernel and bootloader code
# source. When this BSP is used as part of archived distribution, it is supplied
# with locally fetched sources near the yocto directory, so there is no need
# to have it downloaded from remote resources. But for development and debug
# purpose they'd better to be fetched from corresponding repositories.
#
TPSDK_SYS ?= "mipsel-unknown-linux-gnu"
TPSDK_DIR ?= "/media/windows/WORKSPACE/IT/T-platforms/SFBT1/src/sdk"
TPSDK_SRC ?= "sdk"
TPSDK_XTC ?= "sdk"
TPSDK_KEYS_NAME ?= "baikal"
TPSDK_KERNEL_DIR ?= "${TPSDK_DIR}/kernel"
TPSDK_UBOOT_DIR ?= "${TPSDK_DIR}/u-boot"
TPSDK_KEYS_DIR ?= "${TPSDK_DIR}/keys"
TPSDK_XTOOLS_DIR ?= "${TPSDK_DIR}/x-tools"

#
# Validate the settings supplied in the section above
#
# We need to validate wether the sources are selected correctly, the SDK
# directory exists if locally sourced. If it does, then we'll determine
# the kernel and u-boot versions stright from makefiles.
#
python tpsdk_check_settings () {
    tpsdksrc = d.getVar("TPSDK_SRC", True)
    tpsdkxtc = d.getVar("TPSDK_XTC", True)

    if tpsdksrc == "sdk" or tpsdkxtc == "sdk":
        tpsdkdir = d.getVar("TPSDK_DIR", True)
        if not os.path.exists(tpsdkdir):
            bb.fatal("T-platforms SDK directory '%s' doesn't exist" % tpsdkdir)

    # Check T-platforms sources parameters and set corresponding override
    if tpsdksrc == "sdk":
        tpsdkdir = d.getVar("TPSDK_KERNEL_DIR", True)
        ver = tpsdk_get_src_version(d, tpsdkdir, "Makefile")
        d.setVar("PREFERRED_VERSION_linux-baikal", ver + r"%")

        tpsdkdir = d.getVar("TPSDK_UBOOT_DIR", True)
        ver = tpsdk_get_src_version(d, tpsdkdir, "Makefile")
        d.setVar("PREFERRED_VERSION_u-boot-baikal", ver)

        d.prependVar("DISTROOVERRIDES", "tpsdksrc:")

    elif tpsdksrc == "git":
        d.prependVar("DISTROOVERRIDES", "tpgitsrc:")

    else:
        bb.fatal("TPSDK_SRC value shall be one of {sdk,git}, but it is '%s'" % tpsdksrc)

    # Set T-platforms X-toolchain override settings
    if tpsdkxtc == "sdk":
        d.prependVar("DISTROOVERRIDES", "tpsdkxtc:")
    elif tpsdkxtc == "git":
        d.prependVar("DISTROOVERRIDES", "tpgitxtc:")
    else:
        bb.fatal("TPSDK_XTC value shall be one of {sdk,git}, but it is '%s'" % tpsdkxtc)
}
tpsdk_check_settings[eventmask] = "bb.event.ConfigParsed"
addhandler tpsdk_check_settings

def tpsdk_get_src_version (d, srcpath, file):
    import re

    srcpath = os.path.join(srcpath, file)
    if not os.path.exists(srcpath):
        bb.fatal("T-platforms source file '%s' doesn't exist" % srcpath)
        return None

    try:
        f = open(srcpath)
    except IOError:
        bb.fatal("Couldn't open file '%s'" % srcpath)
    else:
        with f:
            lines = f.readlines()

        f.close()

        for line in lines:
            m = re.match(r"^VERSION = (\d{1,})$", line)
            if m:
                ver = m.group(1)
                continue
            m = re.match(r"^PATCHLEVEL = (\d{1,})$", line)
            if m:
                patch = m.group(1)
                break
        if ver and patch:
            return "%s.%s" % (ver,patch)

    bb.fatal("Couldn't extract version from file %s" % srcpath)
    return None

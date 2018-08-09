#
# T-platforms SDK version
#
# SDK version is statically set here so to have at least some value used
# by SDK-specific meta code.
#
TPSDK_VERSION ?= "1.0"
TPSDK_REVISION ?= "0"
TPSDK_RCCYCLE ?= "0"

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

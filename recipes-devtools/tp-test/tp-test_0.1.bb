SUMMARY = "T-platforms Test Framework"
HOMEPAGE = "https://github.com/Elpitech/baikal-t-tp-test"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

TPSDK_REPO ?= "gitlab.elp"

SRC_URI = "git://${TPSDK_REPO}/utils/tp-test;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit cmake

PACKAGES =+ "tp-sample-test tp-xa1-msbt2-test tp-xa1-mrbt1-test tp-bc3bt1-mrbt1-test \
             tp-pci-test tp-usb-test tp-storage-test tp-eth-test \
             tp-flash-test tp-gpio-test tp-serial-test tp-rtc-test tp-sensors-test"

DEPENDS += "yaml-cpp"
RDEPENDS_${PN} += "yaml-cpp"

FILES_tp-sample-test = "${sysconfdir}/tp-test/Sample.yaml ${sysconfdir}/tp-test/cases/sample_*"
RDEPENDS_tp-sample-test += "${PN}"

FILES_tp-xa1-msbt2-test = "${sysconfdir}/tp-test/XA1-MSBT2.yaml"
RDEPENDS_tp-xa1-msbt2-test += "${PN} tp-pci-test tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                               tp-flash-test tp-serial-test tp-rtc-test tp-sensors-test"

FILES_tp-xa1-mrbt1-test = "${sysconfdir}/tp-test/XA1-MRBT1.yaml"
RDEPENDS_tp-xa1-mrbt1-test += "${PN} tp-pci-test tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                               tp-flash-test tp-sensors-test"

FILES_tp-bc3bt1-mrbt1-test = "${sysconfdir}/tp-test/BC3BT1-MRBT1.yaml"
RDEPENDS_tp-bc3bt1-mrbt1-test += "${PN} tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                                  tp-serial-test tp-rtc-test tp-sensors-test"

FILES_tp-pci-test = "${sysconfdir}/tp-test/lib/shell/pci.sh ${sysconfdir}/tp-test/cases/pci_*"
RDEPENDS_tp-pci-test += "${PN} pciutils"

FILES_tp-usb-test = "${sysconfdir}/tp-test/lib/shell/usb.sh ${sysconfdir}/tp-test/cases/usb_*"
RDEPENDS_tp-usb-test += "${PN}"

FILES_tp-storage-test = "${sysconfdir}/tp-test/lib/shell/storage.sh ${sysconfdir}/tp-test/cases/storage_*"
RDEPENDS_tp-storage-test += "${PN} lsscsi hdparm"

FILES_tp-eth-test = "${sysconfdir}/tp-test/lib/shell/eth.sh ${sysconfdir}/tp-test/cases/eth_*"
RDEPENDS_tp-eth-test += "${PN} ethtool linkloop"

FILES_tp-gpio-test = "${sysconfdir}/tp-test/lib/shell/gpio.sh ${sysconfdir}/tp-test/cases/gpio_*"
RDEPENDS_tp-gpio-test += "${PN}"

FILES_tp-flash-test = "${sysconfdir}/tp-test/lib/shell/flash.sh ${sysconfdir}/tp-test/cases/flash_*"
RDEPENDS_tp-flash-test += "${PN} mtd-utils"

FILES_tp-serial-test = "${sysconfdir}/tp-test/lib/shell/serial.sh ${sysconfdir}/tp-test/cases/serial_*"
RDEPENDS_tp-serial-test += "${PN}"

FILES_tp-rtc-test = "${sysconfdir}/tp-test/lib/shell/rtc.sh ${sysconfdir}/tp-test/cases/rtc_*"
RDEPENDS_tp-rtc-test += "${PN} ${VIRTUAL-RUNTIME_base-utils-hwclock}"

FILES_tp-sensors-test = "${sysconfdir}/tp-test/lib/shell/sensors.sh ${sysconfdir}/tp-test/cases/sensors_*"
RDEPENDS_tp-sensors-test += "${PN}"

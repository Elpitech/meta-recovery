SUMMARY = "T-platforms Test Framework"
HOMEPAGE = "https://github.com/Elpitech/baikal-t-tp-test"
LICENSE = "GPL-2.0|CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

TPSDK_REPO ?= "gitlab.elpitech.ru"

SRC_URI = "git://${TPSDK_REPO}/utils/tp-test;protocol=ssh;user=git"
SRCREV = "AUTOINC"
S = "${WORKDIR}/git"

inherit cmake

PACKAGES =+ "tp-sample-test tp-xa1-msbt2-test tp-xa1-mrbt1-test tp-bc3bt1-mrbt1-test \
             tp-pci-test tp-usb-test tp-storage-test tp-eth-test \
             tp-flash-test tp-gpio-test tp-serial-test tp-rtc-test tp-sensors-test"

DEPENDS += "yaml-cpp"
RDEPENDS:${PN} += "yaml-cpp"

FILES:tp-sample-test = "${sysconfdir}/tp-test/Sample.yaml ${sysconfdir}/tp-test/cases/sample_*"
RDEPENDS:tp-sample-test += "${PN}"

FILES:tp-xa1-msbt2-test = "${sysconfdir}/tp-test/XA1-MSBT2.yaml"
RDEPENDS:tp-xa1-msbt2-test += "${PN} tp-pci-test tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                               tp-flash-test tp-serial-test tp-rtc-test tp-sensors-test"

FILES:tp-xa1-mrbt1-test = "${sysconfdir}/tp-test/XA1-MRBT1.yaml"
RDEPENDS:tp-xa1-mrbt1-test += "${PN} tp-pci-test tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                               tp-flash-test tp-sensors-test"

FILES:tp-bc3bt1-mrbt1-test = "${sysconfdir}/tp-test/BC3BT1-MRBT1.yaml"
RDEPENDS:tp-bc3bt1-mrbt1-test += "${PN} tp-usb-test tp-storage-test tp-eth-test tp-gpio-test \
                                  tp-serial-test tp-rtc-test tp-sensors-test"

FILES:tp-pci-test = "${sysconfdir}/tp-test/lib/shell/pci.sh ${sysconfdir}/tp-test/cases/pci_*"
RDEPENDS:tp-pci-test += "${PN} pciutils"

FILES:tp-usb-test = "${sysconfdir}/tp-test/lib/shell/usb.sh ${sysconfdir}/tp-test/cases/usb_*"
RDEPENDS:tp-usb-test += "${PN}"

FILES:tp-storage-test = "${sysconfdir}/tp-test/lib/shell/storage.sh ${sysconfdir}/tp-test/cases/storage_*"
RDEPENDS:tp-storage-test += "${PN} lsscsi hdparm"

FILES:tp-eth-test = "${sysconfdir}/tp-test/lib/shell/eth.sh ${sysconfdir}/tp-test/cases/eth_*"
RDEPENDS:tp-eth-test += "${PN} ethtool linkloop"

FILES:tp-gpio-test = "${sysconfdir}/tp-test/lib/shell/gpio.sh ${sysconfdir}/tp-test/cases/gpio_*"
RDEPENDS:tp-gpio-test += "${PN}"

FILES:tp-flash-test = "${sysconfdir}/tp-test/lib/shell/flash.sh ${sysconfdir}/tp-test/cases/flash_*"
RDEPENDS:tp-flash-test += "${PN} mtd-utils"

FILES:tp-serial-test = "${sysconfdir}/tp-test/lib/shell/serial.sh ${sysconfdir}/tp-test/cases/serial_*"
RDEPENDS:tp-serial-test += "${PN}"

FILES:tp-rtc-test = "${sysconfdir}/tp-test/lib/shell/rtc.sh ${sysconfdir}/tp-test/cases/rtc_*"
RDEPENDS:tp-rtc-test += "${PN} ${VIRTUAL-RUNTIME_base-utils-hwclock}"

FILES:tp-sensors-test = "${sysconfdir}/tp-test/lib/shell/sensors.sh ${sysconfdir}/tp-test/cases/sensors_*"
RDEPENDS:tp-sensors-test += "${PN}"

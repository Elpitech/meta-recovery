
FILESEXTRAPATHS_prepend := "${THISDIR}/glibc:"

SRC_URI += "\
    file://0032-revert-localedef-check-LC_IDENTIFICATION-category-values-${PV}.patch \
"

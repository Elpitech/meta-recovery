
FILESEXTRAPATHS_prepend := "${THISDIR}/glibc:"

SRC_URI += "\
    file://0030-revert-localedef-check-LC_IDENTIFICATION-category-values.patch \
"

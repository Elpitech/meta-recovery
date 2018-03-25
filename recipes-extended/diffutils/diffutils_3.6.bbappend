# This shitty patch prevents diffutils from building with Baikal X-tools,
# which are based on the glibc 2.22
SRC_URI_remove = "file://0001-explicitly-disable-replacing-getopt.patch"

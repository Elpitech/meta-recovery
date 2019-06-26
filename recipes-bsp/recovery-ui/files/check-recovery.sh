#!/bin/sh

VAR_PREFIX="/var/run/recoveryui/"

[ $# -eq 2 ] || exit 1
MDEV=$1
MOUNTPOINT=$2
if [ "$MOUNTPOINT" == "/recovery" ] ; then
    subdir=int
else
    subdir=ext
fi

tarfile=""
if [ -e ${MOUNTPOINT}/recovery.tar ]; then
    tarfile="${MOUNTPOINT}/recovery.tar";
elif [ -e ${MOUNTPOINT}/test.tar ]; then
    tarfile="${MOUNTPOINT}/test.tar";
fi
if [ ! -z ${tarfile} ]; then
    echo "tar file found"
    cur=$(pwd)
    cd ${VAR_PREFIX}${subdir}
    ARC_RC_PATH=$(tar tvf ${tarfile} | sed -e "s| |\n|g" | grep recovery.rc)
    tar xvf ${tarfile} ${ARC_RC_PATH}
    if [ ! $? -eq 0 ]; then
         echo "Failed to extract recovery.rc"
    else
         ARC_LINE_PATH=$(tar tvf ${tarfile} | sed -e "s| |\n|g" | grep line)
         tar xvf ${tarfile} ${ARC_LINE_PATH}
         if [ ! $? -eq 0 ]; then
              echo "Failed to extract line"
         else
              echo "Extracted recovery.rc from ${tarfile}"
              printf "${tarfile}" > ${VAR_PREFIX}${subdir}/recovery-tar-path
              printf "${MDEV}" > ${VAR_PREFIX}${subdir}/recovery-mdev
         fi
    fi
    cd ${cur}
fi

if [ -e ${MOUNTPOINT}/update.rom ]; then
    echo "Recovery update.rom found"
    printf "${MOUNTPOINT}/update.rom" > ${VAR_PREFIX}update-rom-path
fi

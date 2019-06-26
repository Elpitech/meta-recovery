#!/bin/sh

ROM=$1
clear
cd ${VAR_PREFIX}
HOME=/etc/dialog/red dialog --colors --no-shadow --defaultno --backtitle '\Zb\Z0mITX ROM update\Zn' --yesno "\Zb\Z0DANGER!\nRewrite ROM ?\Zn" 12 40
ret=$?
if [ ! ${ret} -eq 0 ]; then
    clear
    exit 0
fi
clear
HOME=/etc/dialog/red dialog --colors --no-shadow --backtitle '\Zb\Z0mITX ROM update confirmation\Zn' --yesno "\Zb\Z0Cancel ROM rewrite?\Zn" 12 40
ret=$?
if [ ${ret} -eq 0 ]; then
    clear
    exit 0
fi
clear
echo "I: Flashing ${ROM}"
/usr/bin/btflash2 ${ROM}
RET=$?
if [ ${RET} -ne 0 ]; then
    echo "E: Failed to flash ${ROM}"
    read -n1 -r -p "Press any key to continue..." key
fi
echo "I: ${ROM} flashed"
sleep 2

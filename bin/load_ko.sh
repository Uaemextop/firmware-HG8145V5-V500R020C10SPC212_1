#!/bin/sh 

svrip=$1

cd /mnt/jffs2

echo "load oal.ko"
tftp -g $svrip -r oal.ko
echo "load oam.ko"
tftp -g $svrip -r oam.ko
echo "load plat.ko"
tftp -g $svrip -r plat.ko
echo "load sdt.ko"
tftp -g $svrip -r sdt.ko
echo "load frw.ko"
tftp -g $svrip -r frw.ko
echo "load hal.ko"
tftp -g $svrip -r hal.ko
echo "load dmac.ko"
tftp -g $svrip -r dmac.ko
echo "load hmac.ko"
tftp -g $svrip -r hmac.ko
echo "load wal.ko"
tftp -g $svrip -r wal.ko
echo "load alg.ko"
tftp -g $svrip -r alg.ko

echo "load cfg_ont_hisi.ini"
tftp -g $svrip -r cfg_ont_hisi.ini
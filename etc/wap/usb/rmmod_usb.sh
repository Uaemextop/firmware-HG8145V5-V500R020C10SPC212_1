#!/bin/sh
#添加lib的环境变量


rmmod nls_ascii
rmmod nls_cp437

#if [ -f /lib/modules/linux/kernel/fs/fuse/fuse.ko ]; then
    rmmod fuse
    rmmod overlayfs
    rmmod scsi_wait_scan
#fi

#if [ -f /lib/modules/linux/extra/drivers/usb/serial/usb_wwan.ko ]; then
#    rmmod usb_wwan
#fi
#
#if [ -f /lib/modules/linux/extra/drivers/usb/serial/option.ko ]; then
#    rmmod /lib/modules/linux/extra/drivers/usb/serial/option.ko
#fi
#
#if [ -f /lib/modules/linux/extra/drivers/net/usb/hw_cdc_driver.ko ]; then
#    rmmod hw_cdc_driver
#fi

if [ -f /lib/modules/wap/hw_iconv.ko ]; then
    rmmod nls_cp950
    rmmod nls_iso8859-1
    rmmod hw_iconv
fi	

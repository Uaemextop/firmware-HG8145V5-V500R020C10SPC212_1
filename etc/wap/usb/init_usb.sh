#!/bin/sh
#添加lib的环境变量

support_sd=`cat /var/board_cfg.txt | grep sd|cut -d ';' -f 9|cut -d '=' -f 2` 
support_lte=`cat /var/board_cfg.txt | grep lte|cut -d ';' -f 14|cut -d '=' -f 2`

echo "support_sd:$support_sd, lte:$support_lte"

ker_ver=$(cat /proc/version | cut -c15-17)
#echo "kernel version:$ker_ver"
if [ -f /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko ]; then
    echo "init usb ko"
    #注释掉的ko在mount后再加载
if [ "$ker_ver" = "4.4" ]; then
    insmod /lib/modules/linux/extra/drivers/scsi/scsi_mod.ko
    insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
    insmod /lib/modules/linux/extra/drivers/usb/common/usb-common.ko
    insmod /lib/modules/linux/kernel/drivers/net/mii.ko
else
    insmod /lib/modules/linux/kernel/drivers/scsi/scsi_mod.ko
    insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
    insmod /lib/modules/linux/extra/drivers/usb/usb-common.ko
fi
    insmod /lib/modules/linux/extra/drivers/usb/core/usbcore.ko
    insmod /lib/modules/linux/extra/drivers/usb/host/hiusb-sd511x.ko
    insmod /lib/modules/linux/extra/drivers/usb/host/ehci-hcd.ko
    insmod /lib/modules/linux/extra/drivers/usb/host/ehci-pci.ko
    insmod /lib/modules/linux/extra/drivers/usb/host/ohci-hcd.ko
    insmod /lib/modules/linux/extra/drivers/usb/host/xhci-hcd.ko    
if [ "$ker_ver" = "4.4" ]; then
    insmod /lib/modules/linux/extra/drivers/usb/host/xhci-plat-hcd.ko
fi
    insmod /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko
    if [ -f /lib/modules/linux/extra/drivers/usb/serial/usbserial.ko ]; then
	    insmod /lib/modules/linux/extra/drivers/usb/serial/usbserial.ko
    fi    

    insmod /lib/modules/linux/extra/drivers/usb/class/usblp.ko
    insmod /lib/modules/linux/extra/drivers/usb/class/cdc-acm.ko
    insmod /lib/modules/linux/extra/drivers/usb/serial/pl2303.ko
    insmod /lib/modules/linux/extra/drivers/usb/serial/cp210x.ko
    insmod /lib/modules/linux/extra/drivers/usb/serial/ch341.ko
    insmod /lib/modules/linux/extra/drivers/usb/serial/ftdi_sio.ko
    insmod /lib/modules/linux/extra/drivers/input/input-core.ko
    insmod /lib/modules/linux/extra/drivers/hid/hid.ko
    insmod /lib/modules/linux/extra/drivers/hid/usbhid/usbhid.ko	

    insmod /lib/modules/wap/hw_module_usb.ko
    insmod /lib/modules/wap/smp_usb.ko
fi

if [ $support_sd == Y ];then
	insmod /lib/modules/linux/extra/drivers/mmc/core/mmc_core.ko
	insmod /lib/modules/linux/extra/drivers/mmc/card/mmc_block.ko
	insmod /lib/modules/linux/extra/drivers/mmc/host/himciv100/himci.ko
	insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc.ko
	insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc-pltfm.ko
	insmod /lib/modules/linux/extra/drivers/mmc/host/dw_mmc-hisi.ko	    
    insmod /lib/modules/wap/hw_module_sd.ko
	insmod /lib/modules/wap/smp_sd.ko
fi

if [ $support_lte == Y ];then
    
    if [ -f /lib/modules/linux/extra/drivers/net/usb/hw_cdc_driver.ko ]; then
	    insmod /lib/modules/linux/extra/drivers/net/usb/hw_cdc_driver.ko
    fi    
    
    if [ -f /lib/modules/linux/extra/drivers/usb/serial/usb_wwan.ko ]; then
	    insmod /lib/modules/linux/extra/drivers/usb/serial/usb_wwan.ko
    fi      

    if [ -f /lib/modules/linux/extra/drivers/usb/serial/option.ko ]; then
        insmod /lib/modules/linux/extra/drivers/usb/serial/option.ko
    fi	
    
    insmod /lib/modules/wap/hw_module_datacard.ko
    insmod /lib/modules/wap/hw_module_datacard_chip.ko
fi

if [ -f /lib/modules/wap/hw_iconv.ko ]; then
    insmod /lib/modules/linux/kernel/fs/nls/nls_cp950.ko
    insmod /lib/modules/linux/kernel/fs/nls/nls_iso8859-1.ko
    insmod /lib/modules/wap/hw_iconv.ko
fi




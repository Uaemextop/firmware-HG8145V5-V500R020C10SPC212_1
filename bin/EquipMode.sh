#! /bin/sh

function standby_equip_mode
{
    feature_value=`GetFeature FT_SUPPORT_5182_DCOM`
    if [ $feature_value = 1 ] ; then
        if [ "$1" = "on" ]; then
            sndhlp 0 0x2000404F 0x4F 4 1 > /dev/null
        elif [ "$1" = "off" ]; then
            sndhlp 0 0x2000404F 0x4F 4 0 > /dev/null
        fi
    fi
}

if [ 1 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
    #如果支持FT_SUPPORT_5182_DCOM，执行以下操作
    standby_equip_mode $1

    if [ "$1" = "on" ]; then
		if [ -f /etc/wap/equip_new ] ; then
			echo "ERROR:: hardequip not support!"
			exit 1;
		fi
		    
		if [ -d /mnt/jffs2/equipment ]; then
			cp -f /bin/Equip.sh /mnt/jffs2/Equip.sh
		else
			echo "ERROR::/mnt/jffs2/equipment not exist!"
			exit 1;
		fi
    elif [ "$1" = "off" ]; then
        rm -f /mnt/jffs2/Equip.sh
        rm -f /mnt/jffs2/art.ko
        rm -f /mnt/jffs2/mdk_client.out
        rm -f /mnt/jffs2/equiptestmode
        rm -f /mnt/jffs2/equip_step
        rm -f /mnt/jffs2/threshold_value
		rm -f /mnt/jffs2/Equip_MU_UpGRD_Flag
		rm -f /mnt/jffs2/equip_portisolate
		rm -f /mnt/jffs2/equip_reload_power
		rm -f /mnt/jffs2/equip_transmit_power
        rm -f /mnt/jffs2/mu_status_info
        if [ -f /mnt/jffs2/customizepara.txt ]; then
            rm -f /mnt/jffs2/equip_ip_enable
        fi
        if [ -f /lib/modules/wap/hw_wifi_diagnose_ct.ko ]; then
            rm -f /mnt/jffs2/hw_hardinfo_spec
        fi
        if [ -f /mnt/jffs2/app/fpga_diag_left.bin ];then
            rm -rf /mnt/jffs2/app/fpga_diag_left.bin
            rm -rf /mnt/jffs2/app/fpga_diag_right.bin
            rm -rf /mnt/jffs2/app/fpga_dam_apm_pll.bin
            rm -rf /mnt/jffs2/app/fpga_diag_left_zg.bin
            rm -rf /mnt/jffs2/app/fpga_diag_right_zg.bin
        fi
    else
        echo "Input para wrong!"
        exit 1;
    fi
fi
sync
sleep 2
echo $1
exit 0

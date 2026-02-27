#!/bin/sh

var_equipment_file="/mnt/jffs2/equipment.tar.gz"
if [ -f $var_equipment_file ];then
	cd /mnt/jffs2
	tar -xzf $var_equipment_file 
	rm -f $var_equipment_file
    echo "<module>" > /mnt/jffs2/module_desc.xml
    echo '<moduleitem name="equipment" path="/mnt/jffs2/equipment"/>' >> /mnt/jffs2/module_desc.xml
    echo "</module>" >> /mnt/jffs2/module_desc.xml
    cp -f /mnt/jffs2/module_desc.xml /mnt/jffs2/module_desc_bak.xml
    chmod 644 /mnt/jffs2/module_desc.xml
    chmod 644 /mnt/jffs2/module_desc_bak.xml
	cd /
fi

if [ -f /mnt/jffs2/replace_celeno_ko ]; then
export cl2400_root=/var/cl2400_host_pkg/cl2400
else
export cl2400_root=/usr/lib/cl2400_host_pkg/cl2400
fi
export clr_install_dir_cl2400=$cl2400_root
export clr_cfg_dir_cl2400_24g=/var/cl2400_24g
export clr_cfg_dir_cl2400=/var/cl2400
export PATH=$PATH:$cl2400_root/bin:$cl2400_root/scripts
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$cl2400_root/lib

echo "equipment modify"
if [ -f /lib/modules/wap/hw_wifi_diagnose_ct.ko ];then
    echo "modify hw_hardinfo_spec"
	if [ ! -f /mnt/jffs2/hw_hardinfo_spec ];then
		echo 'spec.name="AMP_SPEC_SSID_NUM_MAX_BAND" spec.type="uint" spec.value="4"'>>/mnt/jffs2/hw_hardinfo_spec
	fi
fi

echo "" > /var/Equip.sh
[[ ! -f /mnt/jffs2/ProductLineMode ]] && echo "" > /mnt/jffs2/ProductLineMode
chown 3008:2002 /mnt/jffs2/ProductLineMode

if [ ! -f /mnt/jffs2/equip_ip_enable ]
then
    echo "" > /mnt/jffs2/equip_ip_enable
fi

#如果boardinfo是加密的，只能操作解密后的文件
txt_boardinfo=/mnt/jffs2/hw_boardinfo
txt_boardinfo_bak=/mnt/jffs2/hw_boardinfo.bak

if [ -f /var/decrypt_boardinfo ]; then
	txt_boardinfo=/var/decrypt_boardinfo
fi

if [ -f /var/decrypt_boardinfo.bak ]; then
	txt_boardinfo_bak=/var/decrypt_boardinfo.bak
fi

var_xpon_mode=`cat $txt_boardinfo |grep "0x00000001" |cut -d ";" -f 2 | cut -d "\"" -f 2 `
echo "xpon_mode:${var_xpon_mode}"

echo ${var_xpon_mode}>>/var/var_xpon_mode

echo "User init start......"
flashtype_v5=`cat /proc/mtd | grep "ubilayer" | wc -l`
echo "flashtype_v5 is $flashtype_v5"

if [ ! -f /bin/telnet ]; then
	if [ ! -f /mnt/jffs2/temp/telnet ]; then
		mkdir /mnt/jffs2/temp
		ln -sf /bin/busybox /mnt/jffs2/temp/telnet		
	fi
	export PATH=/mnt/jffs2/temp:$PATH
fi

# 挂在Tsdk到/var/目录下
function mount_sdk()
{
    ubi_dir=/sys/class/ubi
    for file in `ls $ubi_dir`
    do
        if [ -d $ubi_dir"/"$file ]; then
            if [ -f $ubi_dir"/"$file"/name" ]; then
                ubi_name=`cat $ubi_dir"/"$file"/name"`
                echo "ubi name is:$ubi_name"
                if [ $ubi_name == "apps" ] || [ $ubi_name == "app_system" ]; then
                    echo "sub_dir name:$file"
                    mkdir -p /mnt/jffs2/sdk_mnt
                    ontchown 3008:2002 /mnt/jffs2/sdk_mnt && ontchmod 770 /mnt/jffs2/sdk_mnt
                    mount -t ubifs -o sync /dev/$file /mnt/jffs2/sdk_mnt
                    break;
                fi
            fi
        fi
    done

    # 挂在Tsdk到/var/目录下
    if [ -d /mnt/jffs2/sdk_mnt ]; then
        echo "load tsdk start"
        loadsdkfs sdk
        echo "load tsdk end"
    fi
} 

echo "User init start......"
# load Tsdk
mount_sdk

if [ -d "/var/TsdkFs/lib/modules/hisi_sdk" ]; then
  sdk_pwd="/var/TsdkFs/lib/modules/hisi_sdk/"
else 
  sdk_pwd="/lib/modules/hisi_sdk/"
fi
if [ -d "/var/TsdkFs/etc/soc" ]; then
  phy_ponlink_pwd="/var/TsdkFs/etc/soc/"
else 
  phy_ponlink_pwd="/etc/soc/"
fi

# load hisi modules
if [ -f /mnt/jffs2/TranStar/hi_sysctl.ko ]; then
	  cd /mnt/jffs2/TranStar/
	  echo "Loading the Temp HISI SD511X modules: "
else
	  cd $sdk_pwd
	  echo "Loading the HISI SD511X modules: "
fi

if [ -f $sdk_pwd/hi_sal.ko ]; then
    insmod hi_sal.ko
fi

#如果有多芯片注册KO，则注册多芯片，否则注册单芯片
if [ -f /lib/modules/wap/hw_module_multichip.ko ]; then
    insmod hi_sysctl.ko g_chipnum=2
else
    insmod hi_sysctl.ko
fi

tempChipType1=`md 0x10100800 1`
tempChipType=`echo $tempChipType1 | sed 's/.*:: //' | sed 's/[0-9][0-9]00//' | cut -b 1-4`

if [ -f $sdk_pwd/hi_ecs.ko ]; then
    insmod hi_ecs.ko
else
    insmod hi_spi.ko
    insmod hi_mdio.ko
    insmod hi_gpio.ko
    insmod hi_dma.ko
    insmod hi_i2c.ko
    insmod hi_timer.ko
    insmod hi_uart.ko
fi
    insmod hi_ponlink.ko
    insmod hi_hilink.ko  #18v1v2的serdies

if [ $flashtype_v5 = 1 ]; then     
	if [ -e /mnt/jffs2/PhyPatch ]; then
		echo "phy patch path is /mnt/jffs2/PhyPatch/ "
		insmod hi_crg.ko pPhyPatchPath="/mnt/jffs2/PhyPatch/"
	else    
		insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_pwd g_pSerdesFirmwarePath=$phy_ponlink_pwd
	fi
	insmod hi_gemac.ko
	insmod hi_xgemac.ko
	insmod hi_pcs.ko
	insmod hi_dp.ko gemport_expand=1
else
    if [ -f $sdk_pwd/hi_crg.ko ]; then
        insmod hi_crg.ko pPhyPatchPath=$phy_ponlink_pwd g_pSerdesFirmwarePath=$phy_ponlink_pwd
        insmod hi_gemac.ko
        insmod hi_xgemac.ko
        insmod hi_pcs.ko
    fi
	if [ -e /mnt/jffs2/PhyPatch ]; then
		echo "phy patch path is /mnt/jffs2/PhyPatch/ "
		if [ $tempChipType -eq 5115 ]; then
			insmod hi_dp_5115.ko    pPhyPatchPath="/mnt/jffs2/PhyPatch/"
		else    
			insmod hi_dp.ko pPhyPatchPath="/mnt/jffs2/PhyPatch/"
		fi
	else
		if [ $tempChipType -eq 5115 ]; then
			insmod hi_dp_5115.ko    
		else    
			insmod hi_dp.ko
		fi
	fi
fi
    insmod hi_bridge.ko

	
#加载多芯片注册KO
if [ -f /lib/modules/wap/hw_module_multichip.ko ]; then
    insmod /lib/modules/wap/hw_module_multichip.ko
fi
	
    insmod /lib/modules/hisi_sdk/hi_pie.ko tx_chk=0
    insmod hi_ponlp.ko
	
if [ ! -f /mnt/jffs2/xpon_mode ]; then
   if [ ${var_xpon_mode} == "4" ]; then
        echo '1' > /mnt/jffs2/xpon_mode
   elif [ ${var_xpon_mode} == "12" ]; then
        echo '5' > /mnt/jffs2/xpon_mode
   else
        echo ${var_xpon_mode} > /mnt/jffs2/xpon_mode
   fi
fi

chown 3003:2002 /mnt/jffs2/xpon_mode && chmod 640 /mnt/jffs2/xpon_mode

if [ ${var_xpon_mode} == "4" ] || [ ${var_xpon_mode} == "12" ]; then
    pon_type_value=`cat /mnt/jffs2/xpon_mode`
else
    pon_type_value=${var_xpon_mode}
fi

#融合CPE需要同时启动gpon和xgpon，hw_module_ploam_proxy是否存在判断融合CPE
if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
    insmod hi_xgmac.ko
    insmod hi_gmac.ko
    insmod hi_gpon.ko
elif [ ${var_xpon_mode} == "5" ] || [ ${pon_type_value} == "5" ]; then	
	insmod hi_xgmac.ko
	insmod hi_xgpon.ko
    if [ $flashtype_v5 = 1 ]; then 	
        insmod hi_gpon.ko
    elif [ -f $sdk_pwd/hi_gpon.ko ]; then
        insmod hi_gpon.ko
    fi
elif [ ${var_xpon_mode} == "6" ] || [ ${pon_type_value} == "6" ]; then
	insmod hi_xemac.ko
	insmod hi_xepon.ko	
    if [ $flashtype_v5 = 1 ]; then 	
	insmod hi_epon.ko
    elif [ -f $sdk_pwd/hi_epon.ko ]; then
         insmod hi_epon.ko
     fi
elif [ ${var_xpon_mode} == "7" ]; then
	insmod hi_xemac.ko
	insmod hi_xepon.ko	
    if [ $flashtype_v5 = 1 ]; then
        insmod hi_epon.ko
    elif [ -f $sdk_pwd/hi_epon.ko ]; then
        insmod hi_epon.ko
     fi
elif [ ${var_xpon_mode} == "10" ]; then
	insmod hi_xgmac.ko
        insmod hi_xgpon.ko
    if [ $flashtype_v5 = 1 ]; then
        insmod hi_gpon.ko
    elif [ -f $sdk_pwd/hi_gpon.ko ]; then
        insmod hi_gpon.ko
     fi
elif [ ${var_xpon_mode} == "1" ] || [ ${pon_type_value} == "1" ]; then
        insmod hi_gmac.ko
        insmod hi_gpon.ko
elif [ ${var_xpon_mode} == "2" ] || [ ${pon_type_value} == "2" ]; then
        insmod hi_emac.ko
	insmod hi_epon.ko
else
    insmod hi_gmac.ko
    insmod hi_emac.ko
    insmod hi_gpon.ko
    insmod hi_epon.ko
fi

#特殊接口在此ko中初始化注册，仅限GPON产品加载
if [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ]; then
    insmod /lib/modules/hisi_sdk/hi_gpon_api_regist.ko
fi

if [ $tempChipType -eq 5115 ]; then
    insmod hi_l3_5115.ko
else    	
    insmod hi_l3.ko
fi    
    insmod hi_oam.ko	     

if [ $flashtype_v5 != 1 ]; then 	
    insmod hi_mdio.ko
fi

if [ -f $sdk_pwd/hi_ipsec.ko ]; then
    insmod $sdk_pwd/hi_ipsec.ko
fi

cd /
if [ -f /lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko ]; then
    insmod /lib/modules/hisi_cdk/libhs_sd5182_sdk_rtos.ko
fi
if [ -f /lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko ]; then
    insmod /lib/modules/hisi_cdk/libhs_sd5182_nse_rtos.ko
fi

if [ -f /mnt/jffs2/aging/request_mbist ] && [ ! -f /mnt/jffs2/aging/mbist_end ]; then
    echo " find request_mbist , no mbist_end , not imsmod np.ko "
else
if [ -f /lib/modules/hisi_cdk/hal_np.ko ];then
    insmod /lib/modules/hisi_cdk/hal_np.ko
fi
if [ -f /mnt/jffs2/hi_woe.ko ]; then
    insmod /mnt/jffs2/hi_woe.ko
else
if [ -f $sdk_pwd/hi_woe.ko ]; then
    insmod $sdk_pwd/hi_woe.ko
fi
fi
fi

# set lanmac 
getlanmac $HW_LANMAC_TEMP
if [ 0  -eq  $? ]; then
    read HW_BOARD_LANMAC < $HW_LANMAC_TEMP
    echo "ifconfig eth0 hw ether $HW_BOARD_LANMAC"
    ifconfig eth0 hw ether $HW_BOARD_LANMAC
fi

# delete temp lanmac file
if [ -f $HW_LANMAC_TEMP ]; then
    rm -f $HW_LANMAC_TEMP
fi



mkdir /var/tmp

echo "Loading the EchoLife WAP modules: LDSP"


insmod /lib/modules/wap/hw_module_common.ko
insmod /lib/modules/wap/hw_module_bus.ko
insmod /lib/modules/wap/hw_module_dev.ko
if [ -f /lib/modules/wap/hw_module_extgpio.ko ];then
    insmod /lib/modules/wap/hw_module_extgpio.ko
fi

if [ -f /lib/modules/wap/hw_module_cdk.ko ];then
    insmod /lib/modules/wap/hw_module_cdk.ko
fi
if [ -f /mnt/jffs2/defaultGroup.bin ]; then
    rm /mnt/jffs2/defaultGroup.bin
fi

# activate ethernet drivers
ifconfig lo up
ifconfig eth0 192.168.100.1 up
ifconfig eth0 mtu 1500


#判断硬件能力集，按需加载
soc_type=`cat /var/board_cfg.txt | grep bob_type|cut -d ';' -f 3|cut -d '=' -f 2`
bob_type=`cat /var/board_cfg.txt | grep bob_type|cut -d ';' -f 6|cut -d '=' -f 2`
slic_type=`cat /var/board_cfg.txt | grep board_id|cut -d ';' -f 4|cut -d '=' -f 2` 
ext_phy_type=`cat /var/board_cfg.txt | grep ext_phy_type|cut -d ';' -f 5|cut -d '=' -f 2`
support_usb=`cat /var/board_cfg.txt | grep usb|cut -d ';' -f 8|cut -d '=' -f 2` 
support_sd=`cat /var/board_cfg.txt | grep sd|cut -d ';' -f 9|cut -d '=' -f 2` 
support_rf=`cat /var/board_cfg.txt | grep rf|cut -d ';' -f 10|cut -d '=' -f 2` 
support_battery=`cat /var/board_cfg.txt | grep battery|cut -d ';' -f 11|cut -d '=' -f 2` 
support_iot=`cat /var/board_cfg.txt | grep iot|cut -d ';' -f 12|cut -d '=' -f 2` 
support_nfc=`cat /var/board_cfg.txt | grep nfc|cut -d ';' -f 13|cut -d '=' -f 2` 
support_lte=`cat /var/board_cfg.txt | grep lte|cut -d ';' -f 14|cut -d '=' -f 2`
pse_type=`cat /var/board_cfg.txt | grep pse_type|cut -d ';' -f 15|cut -d '=' -f 2`
support_rs485=`cat /var/board_cfg.txt | grep rs485|cut -d ';' -f 16|cut -d '=' -f 2`
ext_lsw_type=`cat /var/board_cfg.txt | grep ext_lsw_type|cut -d ';' -f 17|cut -d '=' -f 2`
support_motor=`cat /var/board_cfg.txt | grep motor|cut -d ';' -f 18|cut -d '=' -f 2`
support_pll=`cat /var/board_cfg.txt | grep pll|cut -d ';' -f 19|cut -d '=' -f 2`

echo "soc_type= $soc_type, bob_type= $bob_type, ext_phy_type= $ext_phy_type, ext_lsw_type= $ext_lsw_type, support_motor= $support_motor, support_pll= $support_pll"
echo "support_usb= $support_usb, support_sd= $support_sd, support_rf= $support_rf, support_battery= $support_battery, support_iot= $support_iot, support_nfc= $support_nfc, support_lte= $support_lte, pse_type=$pse_type"

SpecProc.sh
insmod /lib/modules/wap/hw_dm_pdt.ko
insmod /lib/modules/wap/hw_module_feature.ko
rm -rf /var/spec/

insmod /lib/modules/wap/hw_module_optic.ko

if [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
	insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
elif [ ${var_xpon_mode} == "1" ] || [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ]; then
	insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
elif [ ${var_xpon_mode} == "4" ]; then
    echo "adapt pon_mode : $pon_type_value"
    if [ ${pon_type_value} == "1" ]; then
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    else
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    fi
elif [ ${var_xpon_mode} == "12" ]; then
    echo "adapt pon_mode : $pon_type_value"
    if [ ${pon_type_value} == "5" ]; then
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
    else
        insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    fi
else
    insmod /lib/modules/wap/hw_ker_optic_chip_511x_epon.ko
    insmod /lib/modules/wap/hw_ker_optic_chip_511x_gpon.ko
fi
#V5 版本只做以下光phy
echo "borad cfg bob type is"$bob_type
if [ $bob_type == M02103 ] || [ $bob_type == HN5176 ] || [ $bob_type == UX5176 ]; then
    echo "G/E pon bob group"
    #M2013 Gpon/Epon光phy
    if [ -f /lib/modules/wap/hw_ker_optic_m02103.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_m02103.ko
    fi
    #HN5176 Gpon/Epon光phy
    if [ -f /lib/modules/wap/hw_ker_optic_hn5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_hn5176.ko
    fi
    #HU5176 Gpon/Epon光phy
    if [ -f /lib/modules/wap/hw_ker_optic_ux5176.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_ux5176.ko
    fi
elif [ $bob_type == SD5175v300 ] || [ $bob_type == GN7355 ] || [ $bob_type == HN517X ] || [ $bob_type == UX517X ]; then
    echo "XG/XE pon bob group"
    #SD5175不带MCU版本 XGpon/XEpon
    if [ -f /lib/modules/wap/hw_ker_optic_sd5175v300.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_sd5175v300.ko
    fi
    #GN7355带MCU版本 XGpon/XEpon
    if [ -f /lib/modules/wap/hw_ker_optic_sd5175.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_sd5175.ko
    fi

    #HN517X新芯片，这个必须要放在最后面，样片读不到chip，默认为HN5170!!!
    #HN5171/UX5171 XGSPON
    #HN5170/UX5170 XGPON
    if [ -f /lib/modules/wap/hw_ker_optic_517x.ko ]; then
        insmod /lib/modules/wap/hw_ker_optic_517x.ko
    fi
fi


if [ -f /lib/modules/wap/hw_ker_optic_gna4215.ko ]; then
    insmod /lib/modules/wap/hw_ker_optic_gna4215.ko
fi

# slave chip
if [ -f /lib/modules/wap/hal_module_slave_chip.ko ]; then
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hal_module_slave_chip.ko
    insmod /lib/modules/wap/hal_slave_chip_sd511x.ko
fi

# poe ko
if [ -f /lib/modules/wap/hw_module_poe.ko ]; then
    insmod /lib/modules/wap/hw_module_poe.ko
    if [ $pse_type == rtk8238 ]; then
        insmod /lib/modules/wap/hw_module_spi.ko
        insmod /lib/modules/wap/hw_ker_poe_rtk8238.ko
    fi
fi

if [ $support_battery == Y ];then
	insmod /lib/modules/wap/hw_module_uart.ko
fi

if [ $support_rf == Y ];then
  insmod /lib/modules/wap/hw_module_rf.ko
fi

if [ $support_rs485 == Y ]; then
    insmod /lib/modules/wap/hw_module_uart.ko
fi

# motor ko
if [ $support_motor == Y ]; then
    insmod /lib/modules/wap/hw_module_motor.ko
fi

# pll ko
if [ $support_pll == Y ]; then
    insmod /lib/modules/wap/hw_module_pll.ko
    insmod /lib/modules/wap/hw_ker_pll_au53x5.ko
    insmod /lib/modules/wap/hw_ker_pll_sa77xx.ko
    insmod /lib/modules/wap/hw_ker_pll_si53xx.ko
fi

tianyi_cut_128=`cat /proc/mtd | grep "exrootfs" | wc -l`

flashtype_v5=`cat /proc/mtd | grep "ubilayer" | wc -l`

if [ $tianyi_cut_128 = 1 ] && [ $flashtype_v5 = 1 ]; then
	echo "start load tianyi_cut ex rootfs"
	touch /var/tianyi_cut_128
fi

if [ -f /lib/modules/wap/hw_module_sec.ko ];then
    insmod /lib/modules/wap/hw_module_sec.ko
fi

# V5系列，均起loadexfs。
# 此处需要添加上V3的HS8145C
if [ $flashtype_v5 = 1 ] || [ $tianyi_cut_128 = 1 ]; then
	echo "load ex rootfs"
	touch /mnt/jffs2/dypack_debug
	mkdir /var/image
	loadexfs
fi

#产品侧DM加载之后就可以通过/proc/wap_proc/chip_attr文件获取芯片类型
#再根据芯片类型给kbox分配512k高端内存(只是网关产品才添加)
#var_soc_type_kbox_temp=5115H;var_soc_type_kbox=5115
var_soc_attr_kbox=`GetChipDes`
var_soc_type_kbox_temp=`echo $var_soc_attr_kbox | sed 's/.*\"SD//' | sed 's/V[0-9]*\"//' | tr -d '[\015]'`
var_soc_type_kbox=$(echo $var_soc_type_kbox_temp | cut -b 1-4)
echo 153600 > /sys/module/kbox/parameters/kbox_default_reg_size

if [ $var_soc_type_kbox -eq 5113 ]; then
    echo "0x9337F000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5115 ]; then
    echo "0x80880000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5116 ]; then
    if [ "$var_soc_type_kbox_temp" == "5116T" ] || [ "$var_soc_type_kbox_temp" == "5116H" ]; then
        echo "0x80880000 512K" > /proc/kbox/mem
    elif [ "$var_soc_type_kbox_temp" == "5116L" ]; then
        echo "0x80480000 512K" > /proc/kbox/mem
    elif [ "$var_soc_type_kbox_temp" == "5116S" ]; then
        echo "0x80080000 512K" > /proc/kbox/mem
    else
        echo "(!5116T/H/L/S)can not configure the kbox!!!"
    fi
elif [ $var_soc_type_kbox -eq 5117 ]; then
    echo "0x80880000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5118 ]; then
    echo "0x82080000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5182 ] ; then
	echo "0x81080000 512K" > /proc/kbox/mem
else
    echo "(!5113&&!5115&&!5116,7,8 &&!5182)can not configure the kbox!!!"
fi

# pcie use stronly order maps
if [ "$var_soc_type_kbox_temp" == "5116T" ]; then
    echo "base=0x40000000 size=0x20000000 type=4" > /proc/mtrc
fi

var_kbox_config=`cat /proc/kbox/mem`
echo "kbox config(Addr---Size)="$var_kbox_config

#打印进程快照，必须在kbox配置之后
insmod  /lib/modules/linux/mts/rtos_snapshot.ko log_size=164

cd /var
dlw 1 > lastsysinfo
var_size=`stat -c %s /var/lastsysinfo`
if [ $var_size -gt 1024 ]; then
    echo "save sys info"
    echo "=======kbox panic=======" >> lastsysinfo
    cat /proc/kbox/regions/panic >> lastsysinfo
    echo "=======kbox deadlock======" >> lastsysinfo
    cat /proc/kbox/regions/deadlock >> lastsysinfo
    echo "======kbox ks_0======" >> lastsysinfo
    cat /proc/kbox/regions/ks_0 >> lastsysinfo
    echo "=======kbox ks_1======" >> lastsysinfo
    cat /proc/kbox/regions/ks_1 >> lastsysinfo
    echo "=======kbox ks_main======" >> lastsysinfo
    cat /proc/kbox/regions/ks_main >> lastsysinfo

    tar -czf lastsysinfo.tar.gz lastsysinfo
fi
rm -rf lastsysinfo
cd /

if [ -f /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko ]; then
	insmod /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko
	insmod /lib/modules/wap/hw_module_acp.ko
fi

if [ $support_nfc == Y ];then
    insmod /lib/modules/wap/hw_module_nfc_st.ko
    insmod /lib/modules/wap/hw_module_nfc.ko
    insmod /lib/modules/wap/hw_module_nfc_nta5332.ko
fi
 
###外置phy处理
if [[ $ext_phy_type != "NONE" ]] ; then
    insmod /lib/modules/wap/hw_module_mdio.ko
    insmod /lib/modules/wap/hw_module_phy.ko
fi

###按配置加载外置phy chip ko
if [[ $(echo $ext_phy_type | grep "RTL8211")"NOEXIST" != "NOEXIST" ]] ; then
    insmod /lib/modules/wap/hal_extphy_rtl8211.ko
fi
if [[ $(echo $ext_phy_type | grep "YT8521")"NOEXIST" != "NOEXIST" ]] ; then
    insmod /lib/modules/wap/hal_extphy_yt8521.ko
fi
if [[ $(echo $ext_phy_type | grep "BCM84881")"NOEXIST" != "NOEXIST" ]] ; then
    insmod /lib/modules/wap/hw_ker_phy_bcm84881.ko
fi
if [[ $(echo $ext_phy_type | grep "RTL8226")"NOEXIST" != "NOEXIST" ]] ; then
    insmod /lib/modules/wap/hw_ker_phy_rtl8266.ko
fi
if [[ $(echo $ext_phy_type | grep "RTL8261")"NOEXIST" != "NOEXIST" ]] ; then
    insmod /lib/modules/wap/phy_sdk_rtl8261.ko
    insmod /lib/modules/wap/hal_extphy_rtl8261.ko
fi

if [ $ext_lsw_type == RTL8366 ];then
    insmod /lib/modules/wap/hw_module_extlsw.ko
    insmod /lib/modules/wap/hw_ker_eth_rtl8366.ko
fi

insmod /lib/modules/wap/hw_module_amp.ko
insmod /lib/modules/wap/hw_module_l2qos.ko

#融合CPE需要同时启动gploam和xgploam，hw_module_ploam_proxy.ko只有两个协议栈同时启动才需要，因此用来判断gploam和xgploam同时启动
if [ -f /lib/modules/wap/hw_module_ploam_proxy.ko ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_xgploam.ko
        insmod /lib/modules/wap/hw_module_ploam.ko
        insmod /lib/modules/wap/hw_module_ploam_proxy.ko
elif [ ${var_xpon_mode} == "4" ]; then
    if [ ${pon_type_value} == "1" ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_ploam.ko
    else
        insmod /lib/modules/wap/hw_module_emac.ko
        insmod /lib/modules/wap/hw_module_mpcp.ko
    fi
elif [ ${var_xpon_mode} == "12" ]; then
    if [ ${pon_type_value} == "5" ]; then
        insmod /lib/modules/wap/hw_module_gmac.ko
        insmod /lib/modules/wap/hw_module_xgploam.ko
    else
        insmod /lib/modules/wap/hw_module_emac.ko
        insmod /lib/modules/wap/hw_module_mpcp.ko
    fi
elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
	insmod /lib/modules/wap/hw_module_emac.ko
	insmod /lib/modules/wap/hw_module_mpcp.ko
else
	if [ -f /lib/modules/wap/hw_module_ppm.ko ];then
		insmod /lib/modules/wap/hw_module_ppm.ko
	fi
	
	insmod /lib/modules/wap/hw_module_gmac.ko
	if [ ${var_xpon_mode} == "5" ] || [ ${var_xpon_mode} == "10" ]; then	
		insmod /lib/modules/wap/hw_module_xgploam.ko
	else
		insmod /lib/modules/wap/hw_module_ploam.ko
	fi
fi

[ -f /lib/modules/linux/kernel/drivers/block/loop.ko ] && insmod lib/modules/linux/kernel/drivers/block/loop.ko

#判断/mnt/jffs2/customize_xml.tar.gz文件是否存在，存在解压
if [ -e /mnt/jffs2/customize_xml.tar.gz ]
then
    #解析customize_relation.cfg
    tar -xzf /mnt/jffs2/customize_xml.tar.gz -C /mnt/jffs2/ customize_xml/customize_relation.cfg  
fi

#HN8145XR 三大T合一bin
function china_allbin_process()
{
    local osgi_block=$1
    mkdir -p /mnt/jffs2/plug
    mount -t ubifs -o sync /$osgi_block /mnt/jffs2/plug
    if [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
        echo "mount_apps_ok" > "/mnt/jffs2/mount_apps_ok"
        umount /mnt/jffs2/plug
        mount -t ubifs -o sync $osgi_block /mnt/jffs2/plug
        if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
                echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
        fi
    fi
    mkdir -p /mnt/jffs2/plug/app
    rm -rf /mnt/jffs2/app
    [ ! -L /mnt/jffs2/app ] && ln -s /mnt/jffs2/plug/app /mnt/jffs2/app
}

#老的移动联通单板
function old_osgibin_process()
{
    local osgi_block=$1
    #老流程
    if [ -c "$osgi_block" ]; then
        if [ ! -d "/mnt/jffs2/app" ]; then
            mkdir /mnt/jffs2/app
        fi
        mount -t ubifs -o sync $osgi_block /mnt/jffs2/app
        if [ ! -f "/mnt/jffs2/mount_osgi_ok" ]; then
            echo "mount_ok" > "/mnt/jffs2/mount_osgi_ok"
            umount /mnt/jffs2/app
            mount -t ubifs -o sync $osgi_block /mnt/jffs2/app
            if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_osgi_ok" ]; then
                echo "Failed to mount app, reboot system" | ls -l /mnt/jffs2/app
                reboot
            fi
        fi
    fi
}

#通过特性开关来挂载opt
echo "@@@@@@ ctrg_support is $ctrg_support @@@@@@"
if [ $tianyi_cut_128 = 0 ]; then 
    if [ $ctrg_support = 1 ] ;then
        if [ $flashtype_v5 = 1 ];then
            apps_block=ubi0_12
        else
            apps_block=ubi0_16
        fi

        #挂载天翼网关要求的分区目录，framework1和framework2由中间件挂载，/opt/upt/apps
        mkdir -p /mnt/jffs2/plug
        mount -t ubifs -o sync /dev/$apps_block /mnt/jffs2/plug
        if [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
        	echo "mount_apps_ok" > "/mnt/jffs2/mount_apps_ok"
        	umount /mnt/jffs2/plug
        	mount -t ubifs -o sync /dev/$apps_block /mnt/jffs2/plug
        	if [  $? != 0  ] || [ ! -f "/mnt/jffs2/mount_apps_ok" ]; then
        		echo "Failed to mount apps, reboot system" | ls -l /mnt/jffs2
        		reboot
        	fi
        fi    
    
        mkdir -p /mnt/jffs2/plug/app
        mkdir -p /mnt/jffs2/plug/apps
        rm -rf /mnt/jffs2/app
        [ ! -L /mnt/jffs2/app ] && ln -s /mnt/jffs2/plug/app /mnt/jffs2/app

        #电信天翼网关挂载cgroup
        cgroot="/sys/fs/cgroup"
        subsys="blkio cpu cpuacct cpuset devices freezer memory net_cls net_prio ns perf_event"
        #subsys="blkio cpu cpuacct cpuset devices freezer memory"
        mount -t tmpfs cgroup_root "${cgroot}"
        for ss in $subsys; do
            mkdir -p "$cgroot/$ss"
            mount -t cgroup -o "$ss" "$ss" "$cgroot/$ss"
        done
        echo "ctrg cgroup mount done!"
     
        chmod 777 /mnt/jffs2/plug
        chmod 770 /mnt/jffs2/plug/app;chown osgi_proxy:osgi /mnt/jffs2/plug/app
        chmod 777 /mnt/jffs2/plug/apps
    else
        #判断是否是UBI的单板
        broad_not_ubi=`cat /proc/mtd | grep "bootpara" | wc -l`
        echo "broad_not_ubi is $broad_not_ubi"
        if [ $broad_not_ubi = 1 ];then
            osgi_block=/dev/ubi0_5
        else
            #判断是128M还是256M，UBI单板128M无app分区，256M有app分区
            broad_ubi_256=`cat /proc/mtd | grep "app_system" | wc -l`
            if [ $broad_ubi_256 = 1 ];then
                osgi_block=/dev/ubi0_10
            fi
        fi

        #三大T合一单板存在framework分区,为ubi_12
        osgi_hasframe=`cat /proc/mtd | grep "frameworkA" | wc -l`
        if [ $osgi_hasframe = 1 ]; then #HN8145XR  三大T合一bin，osgi_block需要挂载 到/dev/ubi0_12
            osgi_block=/dev/ubi0_12
            echo "osgi_block_ is: $osgi_block"
        fi
        osgi_hasframe=`cat /proc/mtd | grep "frameworkA" | wc -l`
        echo "osgi_hasframe is $osgi_hasframe"
        if [ $osgi_hasframe = 1 ]; then #HN8145XR  三大T合一bin，osgi_block需要挂载 到/dev/ubi0_12
            echo "china_allbin_process"
            china_allbin_process  $osgi_block
        else
            echo "old_osgibin_process"
            old_osgibin_process  $osgi_block
        fi
    fi
fi

loadsdkfs
chmod 640 /mnt/jffs2/kmc_store_A
chmod 640 /mnt/jffs2/kmc_store_B

. /usr/bin/init_topo_info.sh

ctrg_support=`GetFeature HW_SSMP_FEATURE_CTRG`
if [ $tianyi_cut_128 = 0 ]; then 
	if [ $ctrg_support = 1 ] ;then
		echo "start load ex rootfs"
		mkdir -p /var/image
		loadexfs
	fi
fi

if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ]
then
    pots_num=0
    usb_num=0
    ssid_num=0
fi
echo "pots_num="$pots_num
echo " usb_num="$usb_num
echo "hw_route="$hw_route
echo "   l3_ex="$l3_ex
echo "    ipv6="$ipv6
rm -f /var/topo.sh

mem_totalsize=`cat /proc/meminfo | grep MemTotal | cut -c11-22`
echo "Read MemInfo Des:"$mem_totalsize

# pots ko fpga依赖hw_ker_codec_pef31002.ko,后续要挪一下
if [ $pots_num -ne 0 ] || [ -f /lib/modules/wap/hw_module_fpga.ko ]
then
    insmod $sdk_pwd/hi_hw.ko
    insmod /lib/modules/wap/hw_module_highway.ko
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hw_module_codec.ko

    if [ $slic_type == SI32176 ]; then
        insmod /lib/modules/wap/codec_sdk_si3217x.ko
        insmod /lib/modules/wap/hw_ker_codec_si32176.ko
    elif [ $slic_type == PEF3201 ]; then
        insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
    elif [ $slic_type == PEF3100x ]; then
        insmod /lib/modules/wap/hw_ker_codec_pef31002.ko
    elif [ $slic_type == LE964x ]; then
        insmod /lib/modules/wap/codec_sdk_le964x.ko
        insmod /lib/modules/wap/hw_ker_codec_le964x.ko
    elif [ $slic_type == N68x38x ]; then
        insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
    elif [ $slic_type == AUTO_MATCH ]; then
        insmod /lib/modules/wap/codec_sdk_le964x.ko
        insmod /lib/modules/wap/hw_ker_codec_le964x.ko
        insmod /lib/modules/wap/hw_ker_codec_pef31002.ko

        #third coslic n68x38x
        if [ -f /lib/modules/wap/hw_ker_codec_n68x38x.ko ]; then
            insmod /lib/modules/wap/hw_ker_codec_n68x38x.ko
        fi
    else
        insmod /lib/modules/wap/hw_ker_codec_ve8910.ko
    fi
fi

# fpga ko
if [ -f /lib/modules/wap/hw_module_fpga.ko ]; then
    insmod $sdk_pwd/hi_tms.ko
    # hw_module_gmacdrv_olt 依赖hi_tms
    insmod /lib/modules/wap/hw_module_gmacdrv_olt.ko
    rm -f /var/fpga_load
    insmod /lib/modules/wap/hw_module_fpga.ko
    insmod /lib/modules/wap/hw_ker_fpga_xc7a100t.ko
fi

ker_ver=$(cat /proc/version | cut -c15-17)
#echo "kernel version:$ker_ver"
#if file is existed ,don't excute
if [ $usb_num -ne 0 ]
then
    if [ -f /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko ]; then
        cd /lib/modules/linux/
        #insmod ./kernel/fs/nls/nls_ascii.ko
        #insmod ./kernel/fs/nls/nls_cp437.ko
        #insmod ./kernel/fs/nls/nls_utf8.ko
        #insmod ./kernel/fs/nls/nls_cp936.ko
        #insmod ./kernel/fs/fat/fat.ko
        #insmod ./kernel/fs/fat/vfat.ko
        #insmod ./kernel/fs/fuse/fuse.ko
        #insmod ./kernel/fs/overlayfs/overlayfs.ko
        if [ "$ker_ver" = "4.4" ]; then
	    insmod /lib/modules/linux/extra/drivers/scsi/scsi_mod.ko
	    insmod ./kernel/drivers/scsi/scsi_wait_scan.ko	
	    insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
	    insmod /lib/modules/linux/extra/drivers/usb/common/usb-common.ko
        else
	    insmod /lib/modules/linux/kernel/drivers/scsi/scsi_mod.ko
        insmod ./kernel/drivers/scsi/scsi_wait_scan.ko	
	    insmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
	    insmod /lib/modules/linux/extra/drivers/usb/usb-common.ko
        fi
        insmod ./extra/drivers/usb/core/usbcore.ko
        insmod ./extra/drivers/usb/host/hiusb-sd511x.ko
        insmod ./extra/drivers/usb/host/ehci-hcd.ko
        insmod ./extra/drivers/usb/host/ehci-pci.ko
        insmod ./extra/drivers/usb/host/ohci-hcd.ko
        insmod ./extra/drivers/usb/host/xhci-hcd.ko    
	if [ "$ker_ver" = "4.4" ]; then
	    insmod ./extra/drivers/usb/host/xhci-plat-hcd.ko
	fi
        insmod ./extra/drivers/usb/storage/usb-storage.ko
        insmod ./extra/drivers/usb/class/usblp.ko
        insmod ./extra/drivers/usb/class/cdc-acm.ko
        insmod ./extra/drivers/usb/serial/usbserial.ko
        insmod ./extra/drivers/usb/serial/pl2303.ko
        insmod ./extra/drivers/usb/serial/cp210x.ko
        insmod ./extra/drivers/usb/serial/ch341.ko
        insmod ./extra/drivers/usb/serial/ftdi_sio.ko
        insmod ./extra/drivers/input/input-core.ko
        insmod ./extra/drivers/hid/hid.ko
        insmod ./extra/drivers/hid/usbhid/usbhid.ko
        insmod ./extra/drivers/usb/serial/usbserial.ko
        insmod ./extra/drivers/usb/serial/option.ko

        if [ -f /lib/modules/wap/hw_iconv.ko ]; then
            insmod ./kernel/fs/nls/nls_cp950.ko
            insmod ./kernel/fs/nls/nls_iso8859-1.ko
            insmod /lib/modules/wap/hw_iconv.ko
        fi	

        cd /
        insmod /lib/modules/wap/hw_module_usb.ko
        insmod /lib/modules/wap/smp_usb.ko		    
    fi
fi

if [ $support_sd == Y ];then
      cd /lib/modules/linux/
		    insmod ./extra/drivers/mmc/core/mmc_core.ko
		    insmod ./extra/drivers/mmc/card/mmc_block.ko
		    insmod ./extra/drivers/mmc/host/himciv100/himci.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc-pltfm.ko
		    insmod ./extra/drivers/mmc/host/dw_mmc-hisi.ko	    
      cd /

      insmod /lib/modules/wap/hw_module_sd.ko
	    insmod /lib/modules/wap/smp_sd.ko
fi

if [ $support_lte == Y ];then
		cd /lib/modules/linux/
	  	insmod ./extra/drivers/net/usb/hw_cdc_driver.ko
	  	insmod ./extra/drivers/usb/serial/usb_wwan.ko
	  cd /
		  
    insmod /lib/modules/wap/hw_module_datacard.ko
    insmod /lib/modules/wap/hw_module_datacard_chip.ko
fi

feature_dect=`GetFeature FT_LTE_SUPPORT`
if [ $feature_dect -eq 1 ] ;then
    if [ $usb_num -ne 0 ]
    then
        /etc/wap/usb/init_usb.sh
    fi
fi

# AMP_KO
insmod /lib/modules/wap/hw_amp.ko

if [ $support_iot == Y ];then
	insmod /lib/modules/wap/hw_module_uart.ko
	insmod /lib/modules/wap/hw_module_tty.ko
fi

# BBSP_l2_basic
echo "Loading BBSP L2 modules: "
insmod /lib/modules/linux/kernel/drivers/net/slip/slhc.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/ppp_generic.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppox.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppoe.ko
insmod /lib/modules/wap/commondata.ko
insmod /lib/modules/wap/sfwd.ko
insmod /lib/modules/wap/l2ffwd.ko
insmod /lib/modules/wap/btvfw.ko
insmod /lib/modules/wap/hw_bbsp_lswadp.ko
insmod /lib/modules/wap/hw_ptp.ko
insmod /lib/modules/wap/l2base.ko
insmod /lib/modules/wap/acl.ko
insmod /lib/modules/wap/cpu.ko
insmod /lib/modules/wap/hal_adpt_hisi.ko
insmod /lib/modules/wap/bbsp_l2_adpt.ko

# BBSP_l2_basic end


# BBSP_l2_extended
echo "Loading BBSP L2_extended modules: "
insmod /lib/modules/wap/l2ext.ko

# BBSP_l2_extended end
insmod /lib/modules/wap/qos_adpt.ko

# BBSP_l3_basic
echo "Loading BBSP L3_basic modules: "
insmod /lib/modules/wap/hw_ssp_gpl_ext.ko
[ -f /lib/modules/wap/hw_ssp_gpl_ext_add.ko ] && insmod /lib/modules/wap/hw_ssp_gpl_ext_add.ko

# 依赖hw_ssp_gpl_ext.ko
#insmod /lib/modules/wap/hw_module_wifi.ko
insmod /lib/modules/wap/hw_module_wifi_sniffer.ko
insmod /lib/modules/wap/hw_module_wifi_bsd.ko
insmod /lib/modules/wap/hw_module_wifi_drv.ko
insmod /lib/modules/wap/hw_module_wifi_log.ko
if [ -f /lib/modules/wap/hw_module_acs.ko ];then
    insmod /lib/modules/wap/hw_module_acs.ko
fi

if [ ! -e /mnt/jffs2/wifi_kernel_debug ]; then
	if [ -e /lib/modules/wap/cfg80211.ko ]; then
		insmod /lib/modules/wap/cfg80211.ko
	fi

	if [ -e /lib/modules/wap/mhi_core.ko ]; then
		insmod /lib/modules/wap/mhi_core.ko
	fi

	if [ -e /lib/modules/wap/mhi_controllers.ko ]; then
		insmod /lib/modules/wap/mhi_controllers.ko
	fi

	if [ -e /lib/modules/wap/qrtr.ko ]; then
		insmod /lib/modules/wap/qrtr.ko
	fi

	if [ -e /bin/qrtr-cfg ]; then
		qrtr-cfg 1
	fi

	if [ -e /bin/qrtr-ns ]; then
		qrtr-ns &
	fi

	if [ -e /lib/modules/wap/qrtr-mhi.ko ]; then
		insmod /lib/modules/wap/qrtr-mhi.ko
	fi

	if [ -e /lib/modules/wap/qmi_helpers.ko ]; then
		insmod /lib/modules/wap/qmi_helpers.ko
	fi

	if [ -e /lib/modules/wap/qmi_interface.ko ]; then
		insmod /lib/modules/wap/qmi_interface.ko
	fi

	if [ -e /lib/modules/wap/qcom_kern.ko ]; then
		insmod /lib/modules/wap/qcom_kern.ko
	fi

	if [ -e /lib/modules/wap/smem.ko ]; then
		insmod /lib/modules/wap/smem.ko
	fi

	if [ -e /lib/modules/wap/cnss2.ko ]; then
		insmod /lib/modules/wap/cnss2.ko bdf_pci0=0xA1 bdf_pci1=0xA0
	fi
fi

echo 16000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog

echo 1 > proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal 2>>/var/xcmdlog

iptables-restore -n < /etc/wap/sec_init

insmod /lib/modules/wap/hw_module_trigger.ko
insmod /lib/modules/wap/l3base.ko

#  load DSP modules
if [ $pots_num -ne 0 ]
then    
    echo "Loading DSP temporary modules: "
	feature_soft_dsp=`GetFeature VOICE_FT_SOFT_DSP`
    insmod /lib/modules/wap/hw_module_dopra.ko
	if [ $feature_soft_dsp = 1 ] ;then
		echo "Loading DSP 1 modules: "
		insmod /lib/modules/wap/hw_module_soft_dsp_sdk.ko
	else
	    echo "Loading DSP 2 modules: "
		insmod /lib/modules/wap/hw_module_dsp_sdk.ko
	fi
    insmod /lib/modules/wap/hw_module_dsp.ko
fi
#if file is existed ,don't excute

#add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
#enable ip forward
echo 1 > /proc/sys/net/ipv4/ip_forward
#disable rp filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#end of add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
# BBSP_l3_basic end

# BBSP_l3_extended
if [ $l3_ex -eq 0 ]
then    
    echo "NO L3_extended!"
else 
    echo "Loading BBSP L3_extended modules: "
	insmod /lib/modules/linux/kernel/net/ipv4/ip_tunnel.ko
    insmod /lib/modules/linux/kernel/net/ipv4/gre.ko
    insmod /lib/modules/linux/kernel/net/ipv4/ip_gre.ko
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/hw_module_conenat.ko
    insmod /lib/modules/wap/ffwd_adpt.ko
    insmod /lib/modules/wap/napt.ko


fi
# BBSP_l3_extended end

if [ -f /lib/modules/wap/np_adpt.ko ];then
    insmod /lib/modules/wap/np_adpt.ko
fi

if [ -f /lib/modules/wap/hal_adpt_hisi_np.ko ];then
    insmod /lib/modules/wap/hal_adpt_hisi_np.ko
fi

if [ $soc_type == SD5182H ]; then
    insmod /lib/modules/wap/hal_eth_sd518x.ko
    insmod /lib/modules/wap/hal_qos_sd518x.ko
    echo "insmod hal_eth_sd518x!"
    if [ ${var_xpon_mode} == "12" ]; then
        if [ ${pon_type_value} == "5" ]; then
            insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
            echo "insmod hw_module_gmac_sd518x!"
        else
            insmod /lib/modules/wap/hw_module_emac_sd518x.ko
            echo "insmod hw_module_emac_sd518x!"  
        fi
    elif [ ${var_xpon_mode} == "4" ]; then
        if [ ${pon_type_value} == "1" ]; then
            insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
            echo "insmod hw_module_gmac_sd518x!"
        else
            insmod /lib/modules/wap/hw_module_emac_sd518x.ko
            echo "insmod hw_module_emac_sd518x!"  
        fi
    elif [ ${var_xpon_mode} == "2" ] || [ ${var_xpon_mode} == "6" ] || [ ${var_xpon_mode} == "7" ]; then
        insmod /lib/modules/wap/hw_module_emac_sd518x.ko
        echo "insmod hw_module_emac_sd518x!"
    else
        insmod /lib/modules/wap/hw_module_gmac_sd518x.ko
        echo "insmod hw_module_gmac_sd518x!"
    fi
fi

if [ -f /mnt/jffs2/hi_np_wifi.ko ] && [ -f /mnt/jffs2/replace_ko ]; then
    insmod /mnt/jffs2/hi_np_wifi.ko g_rx_pkt_mode=1
    echo "hi_np_wifi.ko ... jffs2"
elif [ -f /var/WiFisdk/lib/modules/wap/hi_np_wifi.ko ]; then
    insmod /var/WiFisdk/lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1
    echo "hi_np_wifi.ko ... wifisdk"
elif [ -f /lib/modules/wap/hi_np_wifi.ko ]; then
    insmod /lib/modules/wap/hi_np_wifi.ko g_rx_pkt_mode=1
    echo "hi_np_wifi.ko ... "
fi

WifiAxInstallKo.sh &

#FPGA的bin需要拷贝进app目录下
if [ -f "/mnt/jffs2/fpga.tar.gz" ];then
    mkdir /var/fpga
    tar -zxf /mnt/jffs2/fpga.tar.gz -C /var/fpga
    cp -rf /var/fpga/* /mnt/jffs2/app
    rm -rf /var/fpga/
    rm -rf /mnt/jffs2/fpga.tar.gz
    sync
fi

# BBSP_hw_route
if [ $hw_route -eq 0 ]
then    
    echo "NO hw_rout!"
else 
    echo "Loading BBSP hw_rout modules: "
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/wap_ipv6.ko
fi

insmod /lib/modules/wap/bbsp_l3_adpt.ko
insmod /lib/modules/wap/ethoam.ko
insmod /lib/modules/wap/ethoam_adpt.ko
insmod /lib/modules/linux/kernel/net/llc/llc.ko
insmod /lib/modules/linux/kernel/net/802/stp.ko

# BBSP_hw_route end

if [ $ssid_num -ne 0 ]
then
    insmod /lib/modules/wap/wifi_fwd.ko
fi

#no need /mnt/jffs2/Cal.sh for calibrate, delete it	
[ -e /mnt/jffs2/Cal.sh ] && [ ! -e /bin/CalMode.sh ] && rm -rf /mnt/jffs2/Cal.sh
[ -d /mnt/jffs2/equipment/QCA ] && [ ! -e /bin/CalMode.sh ] && rm -rf /mnt/jffs2/equipment/QCA

#not savedata under equip mode
if [ $ssid_num -ne 0 ]
then
    echo > /var/notsavedata
fi

#add by zhaochao for ldsp_user
iLoop=0
echo -n "Start ldsp_user..."
if [ -e /bin/hw_ldsp_cfg ]
then
  hw_ldsp_cfg &
  while [ $iLoop -lt 50 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
  do
    echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
  
  if [ -e /var/hw_ldsp_tmp.txt ]
  then 
      rm -rf /var/hw_ldsp_tmp.txt
  fi
fi

if [ -e /bin/ldsp_xpon_auto ]
then
    su -s /bin/sh srv_amp -c ldsp_xpon_auto &
fi

iLoop=0
if [ -e /bin/hw_ldsp_cfg ]
then
  while [ $iLoop -lt 100 ] && [ ! -e /var/epon_up_mode.txt ] && [ ! -e /var/gpon_up_mode.txt ] && [ ! -e /var/ge_up_mode.txt ] && [ ! -e /var/wifi_up_mode.txt ] 
  do
    echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
fi

#mbist加载
insmod /lib/modules/wap/hw_module_mbist.ko

#打开3.10 R死锁检测softlockup，分配128K大小，OOM大小为64K
echo 128 > /proc/sys/kernel/softlockup_log_size
echo 64 > /proc/oom_extend/kbox_region_size
echo 1 > /proc/sys/kernel/watchdog
echo 2 500 > /proc/sys/kernel/watchdog_thresh

insmod /lib/modules/wap/hw_module_drv_event.ko

# install qtn wifi chip driver
cat /proc/bus/pci/devices | cut -f 2 | while read dev_id;
do
	if [ "$dev_id" == "1bb50008" ]; then
		echo "pci device id:$dev_id"
		insmod /lib/modules/wap/qdpc-host.ko
	fi
done

if [ -f /mnt/jffs2/Equip_MU_UpGRD_Flag ]
then
	rm -f /mnt/jffs2/Equip_MU_UpGRD_Flag
	start ssmp comm lsvd bbsp amp cms &
	ssmp &
	cms &
	lsvd &
	comm -l ssmp bbsp cms & 
	bbsp equip & 
	amp equip &

	while true; do 
	    sleep 1
	    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
	    if [ -f /var/ssmploadconfig ]; then
		    procmonitor & break
		fi
	done &
	while true;
	do
		sleep 1

		if [ -f /var/ssmploaddata ] ; then
			echo -n "Start mu..."
			mu &
			echo "Start flash aging test..."
			/mnt/jffs2/equipment/bin/aging &
			break;
		fi
	done &
	exit 0
fi

var_proc_name="ssmp bbsp amp ldspcli igmp cms "
var_proc_comm="-l bbsp ssmp wifi cms"

if [ $pots_num -ne 0 ]
then
    var_proc_name=$var_proc_name" voice"
fi

if [ -e /var/gpon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" omci"
fi

if [ -e /var/epon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" oam"
fi


if [ -f /bin/comm ]; then
	var_proc_name=$var_proc_name" comm lsvd"
fi

if [ -f /bin/clid ]; then
	var_proc_name=$var_proc_name" clid"
fi

usb_enble=`GetFeature HW_SSMP_FEATURE_USB`
usbsmart_enble=`GetFeature HW_SSMP_FEATURE_USBSMART`
if [ ! -f /lib/libhw_usb_mngt.so ];then
    usb_enble=0
	usbsmart_enble=0
fi 
if [ $usb_enble = 1 ] || [ $usbsmart_enble = 1 ];then
    var_proc_comm=$var_proc_comm" usb_mngt"
fi 

monitor_enble=`GetFeature FT_COLLECT_MONITOR_REPORT`
if [ -f /lib/libhw_cwmp_common.so ] && [ $monitor_enble = 1 ]; then
    var_proc_comm=$var_proc_comm" monitor"
fi

if [ -f /lib/libcli_userinfo.so ]; then
    var_proc_comm=$var_proc_comm" cliuserinfo"
fi

echo $var_proc_name

start $var_proc_name&

ssmp &
cms &
lsvd &

if [ -f /bin/comm ]; then
    echo "Start COMM..."
    comm $var_proc_comm &
fi

ldspcli equip &

bbsp equip &

amp equip &

if [ -e /var/gpon_up_mode.txt ]
then
    omci &
fi 

if [ -e /var/epon_up_mode.txt ]
then
    oam &
fi

core_num=`cat /proc/cpuinfo  | grep process  | wc -l`
echo "core_num $core_num"

if [ $ssid_num -ne 0 ]
then
    echo -n " Start WIFI..."

    # 大于2核将WIFI进程绑定在1核上，海思驱动的在大于2核的系统上
    # 从0,1核以外发消息会出现无响应问题
    if [ $core_num -ge 2 ];then
        taskset 1 wifi -d 0 -n 60 &
    else
        wifi -d 0 -n 60 &
    fi
fi

igmp &

if [ -f /bin/clid ]; then
	echo "Starting CLID..."
	clid frame&
fi

#if file is existed ,don't excute
if [ $pots_num -eq 0 ]
then    
	echo -n "Do not start VOICE..."
else 
    echo -n "Start VOICE ..."
	[ -f /bin/voice_h248 ] && voice_h248 equip&
	[ -f /bin/voice_sip ] && voice_sip equip&
	[ -f /bin/voice_h248sip ] && voice_h248sip equip&
fi

while true; do
    sleep 3
    if [ -f /var/ssmploaddata ] ; then
	wificli & break;
    fi
done &

while true; do 
    sleep 1
    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
    if [ -f /var/ssmploadconfig ]; then
	    procmonitor ssmp & break
	fi
done &

#启动双机通信进程
feature_LTE_support=`GetFeature FT_LTE_SUPPORT`
if [ $feature_LTE_support = 1 ]; then
    echo -n "Start devscom..."
    while true; do
            sleep 1
            if [ -f /var/ssmploaddata ]; then
                devscom &
                break;
            fi
    done &
fi

ctrg_support=`GetFeature HW_SSMP_FEATURE_CTRG`
#启动ctrg_m服务进程,仅组播升级时按需启动
if [ -e /bin/ctrg_m ] ;then
	while true; do sleep 20; 
		if [ -f /var/cleanmemflag ] ; then
			#天翼网关，增加dbus服务启动
			if [ $ctrg_support = 1 ]
			then
				mkdir -p /var/lib/dbus/
				dbus-uuidgen>>/var/lib/dbus/machine-id
				mkdir -p /var/run/dbus/ && chmod 755 /var/run/dbus/

				#挂载后, 先确保 system.conf 存在，再启动dbus-daemon
				if [ ! -f /opt/upt/apps/etc/dbus-1/system.conf ]
				then
					mkdir -p /opt/upt/apps/etc
					cp -rf /etc/dbus/dbus-1 /opt/upt/apps/etc/         
				fi

				if [ ! -f /etc/dbus-1/system.conf ]
				then
					echo "Error:not find system.conf"
				else
					dbus-daemon --system 
				fi

				if [ -f /usr/bin/lxc-create ]
				then
					mkdir -p /var/lib/lxc/
					mkdir -p /var/cache/lxc/
				fi				
				
				#用saf-huawei 启动framework
				if [ -f /mnt/jffs2/saftime ];then
					sleeptime=`cat /mnt/jffs2/saftime`
				else
					sleeptime=60
				fi	
				sleep $sleeptime
				echo "start ctrg saf-huawei"
    			#if [ $flashtype_v5 = 1 ]; then 
                #    saf-huawei service 5 6 14 
                #else
                #    saf-huawei service 17 18 19 
                #fi

				#天翼网关oom策略修改
				#0标识oom时不panic，默认值2
				echo 0 > /proc/sys/vm/panic_on_oom 
				#1标识oom时谁申请杀谁，默认值0
				echo 1 > /proc/sys/vm/oom_kill_allocating_task

				ctrg_m & break; 
			else
				break; 
			fi
		fi
	done &
fi

# After system up, drop the page cache.
while true; do sleep 30 ; echo 3 > /proc/sys/vm/drop_caches ; echo "Dropped the page cache."; break; done &
while true;
do
	sleep 4
	# FixedDevice/OneTrack#993
	# 宽带确认阶段三完成RPC注册，此处选取阶段4时启动mu
	if [ -f /var/bbsploaddata ] && [ -f /var/ssmploaddata ] ; then
		echo -n "Start mu..."
		mu& break;
	fi
done &

#系统启动后加载 诊断信息获取ko
if [ -f /lib/modules/wap/hw_module_diag.ko ]; then
    insmod /lib/modules/wap/hw_module_diag.ko
fi

#启动完成之后恢复打印级别为4
echo 4 > /proc/sys/kernel/printk

# Print system process status for debug.
ps

sleep 6

#skb内存池
feature_double_wlan=`GetFeature HW_AMP_FEATURE_DOUBLE_WLAN`
feature_11ac=`GetFeature HW_AMP_FEATURE_11AC`
if [ $feature_double_wlan = 1 ] || [ $feature_11ac = 1 ];then

	if [ -f /var/runinram ]; then
		echo "In MU Upgrade Mode, not need installed skpool!"
	else
		insmod /lib/modules/wap/skpool.ko
		echo "skpool installed ok!"
	fi
fi

while true; do
	sleep 2
	#SSMP启动完后后再启动老化进程
	if [ -f /var/ssmploadconfig ] ; then
		sleep 5
		echo "Start flash aging test..."
		/mnt/jffs2/equipment/bin/aging & break;
	fi
done &

##如果内存测试存在，拉起内存测试进程
if [ -e /bin/mbist_test ] ;then
	echo "Start DDR mbist test..."
	/bin/mbist_test &
fi

fttr_spt=`GetFeature FT_FTTR_MAIN_ONT`
if [ $fttr_spt == 1 ]; then
    echo -n "Start LINEOMCI..."
    if [ -f /lib/modules/wap/ethomci.ko ]; then
        insmod /lib/modules/wap/ethomci.ko
    fi
    while true; do
        sleep 1
        if [ -f /var/ssmploaddata ] && [ -f /var/fpga_load ] && [ -e /bin/lineomci ]; then
            /bin/lineomci &
            break;
        fi
    done &
fi

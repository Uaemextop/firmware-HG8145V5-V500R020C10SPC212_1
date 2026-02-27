#!/bin/sh
# 显示WiFi配置， 注意不要显示用户私密信息。

DisplayRT5392()
{
	echo "DisplayRT5392"
}

CollectBCM2G()
{
	echo "ifconfig -a"
	ifconfig -a

	echo "cat /var/wifi.txt"
	cat /var/wifi.txt | grep -v -e "psk" -e "key" -e "_pin="

	echo "wl rate"
	wl rate

	echo "wl country"
	wl country

	echo "wl frameburst"
	wl frameburst

	echo "wl chanspec"
	wl chanspec

	echo "wl -i wl0 assoc"
	wl -i wl0 assoc

	echo "wl -i wl0.1 assoc"
	wl -i wl0.1 assoc

	echo "wl -i wl0.2 assoc"
	wl -i wl0.2 assoc

	echo "wl -i wl0.3 assoc"
	wl -i wl0.3 assoc
	
	echo "wl counters"
	wl counters

	echo "pr_283"
	wl phyreg 0x283

	echo "pr_280"
	wl phyreg 0x280

	echo "pr_289"
	wl phyreg 0x289

	echo "wl interference"
	wl interference

	echo "wl nrate"
	wl nrate

	echo "wl dump rssi"
	wl dump rssi

	echo "wl phy_rssi_ant"
	wl phy_rssi_ant

	echo "wl counters"
	wl counters
	
	echo "wl curpower"
	wl curpower	
}

DisplayBCM()
{
    echo "DisplayBCM"  
    if [ "$1" = "performance" ];then  
        echo "======performance check items======="
        CollectBCM2G
    
	    echo "======assoc sta list=========="
	    wl  assoclist  
	    echo "======wme counters=========="
	    wl  wme_counters	 
	
	elif [ "$1" = "checkrate" ];then
	     echo "======check rate 1======"
	     wl nrate;wl rate;wl phy_rssi_ant;wl counters;
	     echo "======check rate 2======"
	     sleep 1
         wl nrate;wl rate;wl phy_rssi_ant;wl counters;
	     echo "======check rate 3======"
	     sleep 1
         wl nrate;wl rate;wl phy_rssi_ant;wl counters;
	     echo "======check rate 4======"
	     sleep 1
         wl nrate;wl rate;wl phy_rssi_ant;wl counters;
	     echo "======check rate 5======"
	     sleep 1
	     wl nrate;wl rate;wl phy_rssi_ant;wl counters;
	     echo "dump rssi"
	     wl dump rssi	

	elif [ "$1" = "sta_info" ];then
	    echo "======assoc sta list=========="
	    wl  assoclist 
	    echo "======sta info $2=========="
	    wl  sta_info $2	     	     
	elif [ "$1" = "clear" ];then
	     echo "clear-NULL-TODO"
	else 
		echo "ERROR::Command is not right!"
		echo "Usage:display wifi status [performance|checkrate|sta_info] {STA_MAC}"
	    exit 1
	fi
}



DisplayRTL8192()
{
echo "DisplayBCM2G"
} 

ExeCollectCmd()
{
	# $1 = wifi_id

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		DisplayRT5392 $2 $3
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		DisplayBCM $2  $3
		;;

	#bcm4331
	14e44331 )
		DisplayBCM $2 $3
		;;

	#bcm4360
	14e44360 )
		DisplayBCM $2 $3
		;;

	#rtl8192
	10ec818b )
		DisplayRTL8192 $2 $3
		;;
		
	* )
		;;
	esac

}

#if [ 1 -ne $# ]; 
#then
#    echo "Usage::display wifi status [para]"
#    return 1;	
#else

# read pci device id
cat /proc/bus/pci/devices | cut -f 2 | while read dev_id;
do
	if [ "$dev_id" != "" ]; then
	echo "pci device id:$dev_id"
	ExeCollectCmd $dev_id $1 $2
	fi
done

#fi
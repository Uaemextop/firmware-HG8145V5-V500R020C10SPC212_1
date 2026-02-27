#!/bin/sh
# 显示WiFi配置， 注意不要显示用户私密信息。

DisplayRT5392()
{
	echo "DisplayRT5392"
}


DisplayBCM()
{
    echo "show debug info"    
	nvram show | grep "dbg"
	echo "phy_watchdog "
	wl phy_watchdog
	if [ -e  /var/wifidebugon ];then
		echo "wifi config layer debug is on"
	else
		echo "wifi config layer debug is off"
	fi
	if [ "$1" = "info" ]; then
	   echo "show NAS Info"
	   cat /tmp/radius_dump_log
	fi
	
	
}



DisplayRTL8192()
{
echo "DisplayRTL8192"
} 

ExeCollectCmd()
{
	# $1 = wifi_id

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		DisplayRT5392 $2
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		DisplayBCM  $2
		;;

	#bcm4331
	14e44331 )
		DisplayBCM  $2
		;;

	#bcm4360
	14e44360 )
		DisplayBCM  $2
		;;

	#rtl8192
	10ec818b )
		DisplayRTL8192 $2
		;;
		
	* )
		;;
	esac

}

#if [ 1 -ne $# ]; 
#then
#    echo "Usage::display wifi config [para]"
#    return 1;	
#else

# read pci device id
cat /proc/bus/pci/devices | cut -f 2 | while read dev_id;
do
	if [ "$dev_id" != "" ]; then
	echo "pci device id:$dev_id"
	ExeCollectCmd $dev_id $1
	fi
done

#fi
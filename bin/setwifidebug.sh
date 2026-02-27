#!/bin/sh
# 显示WiFi配置， 注意不要显示用户私密信息。

DisplayRT5392()
{
	echo "DisplayRT5392"
}


DisplayBCM()
{
    echo "broadcom wifi debug $1 $2"    
    
    if [ "$1" != "eapd_dbg" ] && [ "$1" != "nas_dbg" ] && [ "$1" != "wps_dbg" ] && [ "$1" != "phy_watchdog" ] && [ "$1" != "nvram_dbg" ] && [ "$1" != "wifidebug" ];then
        echo "bad para1 $1"
        exit 1
    fi
	
	case $2 in	
	
	1 | on | enable )	
	   if [ "$1" = "wifidebug" ];then 
	      touch /var/wifidebugon
	   elif [ "$1" = "phy_watchdog" ];then 
	      wl phy_watchdog 1    
	   else
	      nvram set $1=1
	      nvram -c /var/wifi.txt commit
	   fi
	   #nvram set eapd_dbg=1
	   #nvram set nas_dbg=1
	   #nvram set wps_dbg=1
	   #nvram set nvram_dbg=1
	   #touch /var/wifidebugon
		;;	

	0 | off | disable )
	   if [ "$1" = "wifidebug" ];then 
	      rm -f /var/wifidebugon
	   elif [ "$1" = "phy_watchdog" ];then 
	      wl phy_watchdog 0 	      
	   else
	      nvram set $1=0
	      nvram -c /var/wifi.txt commit
	   fi	
	   #nvram set eapd_dbg=0
	   #nvram set nas_dbg=0
	   #nvram set wps_dbg=0
	   #nvram set nvram_dbg=0
	   #rm -f /var/wifidebugon
		;;	
		
    start )
       if [ "$1" != "eapd_dbg" ];then
          killall eapd
          eapd -c /var/wifi.txt         
       fi
       
       if [ "$1" != "nas_dbg" ];then
          killall nas
          nas -c /var/wifi.txt         
       fi
       
       if [ "$1" != "wps_dbg" ];then
          killall wps_monitor
          wps_monitor -c /var/wifi.txt      
       fi
       
       ;;
       
	* )
		echo "bad para 2:$2";;		
	esac
	
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
		DisplayBCM $2 $3
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
#    echo "Usage::display wifi config [para]"
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
#!/bin/sh
# 显示WiFi配置， 注意不要显示用户私密信息。

DisplayRT5392()
{
	echo "DisplayRT5392"
}


DisplayBCM()
{
    echo "DisplayBCM"    
	nvram show | grep -v -e "psk" -e "key"
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
		DisplayRT5392
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		DisplayBCM
		;;

	#bcm4331
	14e44331 )
		DisplayBCM
		;;

	#bcm4360
	14e44360 )
		DisplayBCM
		;;

	#rtl8192
	10ec818b )
		DisplayRTL8192
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
	ExeCollectCmd $dev_id
	fi
done

#fi
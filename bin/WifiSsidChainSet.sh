#! /bin/sh

bin_wl()
{
    /bin/wl $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	    
	    exit 1
	  fi 
}
BCM_WifiSsidSet()
{
	if [ "$2" = "" ];then
		/bin/wl -i wl$1 ssid ""
		exit 0
	else
		bin_wl -i wl$1 ssid "$2"
		exit 0
	fi
}

BCM_WifiChainSet()
{
	echo "wl -i wl$1 rxchain $2"
	/bin/wl -i wl$1 rxchain "$2"
	echo "wl -i wl$1 up"
	/bin/wl -i wl$1 up
	echo "wl -i wl$1 txchain $2"
	/bin/wl -i wl$1 txchain "$2"
	echo "wl -i wl$1 up"
	/bin/wl -i wl$1 up
	echo "wl -i wl$1 txpwr1 -1"
	/bin/wl -i wl$1 txpwr1 -1
	echo "wl -i wl$1 ssid"
	/bin/wl -i wl$1 ssid ""
	
	exit 0
}


	
# exe script according to wifi chip type
ExeWifiSsidChainSet()
{
	# $1 = wifi_id
	# $2 = wifi_frequency  0--2.4G/1--5G

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		echo "ERROR::Command isn't support!"
		;;
	
	#bcm43217  #bcm43217  #bcm4331   bcm4360
	14e443a9 | 14e4a8db | 14e44331 | 14e44360 )
		if [ "$3" = "SSID" ]; then
				BCM_WifiSsidSet $2 $4
		elif [ "$3" = "Chain" ]; then
				BCM_WifiChainSet $2 $4
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#rtl8192
	10ec818b )
		echo "ERROR::Command isn't support!"
		;;
		
	* )
	    echo "ERROR::input para is not right!"
			exit 1
		;;
	esac

}

#variable define
dev_id=""

# read pci device id
dev_id=`cat /proc/bus/pci/devices | cut -f 2 | grep 4360`

if [ "$dev_id" != "" ]; then
	if [ "$1" = "0" ]; then
		dev_id=`cat /proc/bus/pci/devices | cut -f 2 | grep 4331`
	elif [ "$1" = "1" ]; then
		dev_id=`cat /proc/bus/pci/devices | cut -f 2 | grep 4360`
	else
		echo "ERROR::input para is not right!"
		exit 1
	fi
else
	dev_id=`cat /proc/bus/pci/devices | cut -f 2`
fi

if [ "$dev_id" != "" ]; then
	if [ "$1" != "?" ]; then
		echo "pci device id:$dev_id"
		ExeWifiSsidChainSet $dev_id $1 $2 $3
	else
		echo "WifiSsidChainSet.sh {0-2G/1-5G} {SSID/Chain} [{ssid/chain}]"
	fi
fi

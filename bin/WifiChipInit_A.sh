#! /bin/sh

if [ "$1" != "0" -a "$1" != "1" -a "$1" != "11ac" -a "$1" != "?" ]; then
	echo "ERROR:Command is not right" && exit 1
fi

bin_wl()
{
    /bin/wl $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!" && exit 1
	  fi 
}

bin_iwpriv()
{
    /bin/iwpriv $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!" && exit 1
	  fi 
}

BCM43217_WifiChipInit()
{
	echo "wl ap 1" 
	/bin/wl ap 1
	echo "wl nphy_txpwrctrl 1" 	
	wl nphy_txpwrctrl 1 
	echo "wl phy_watchdog 0" 
	/bin/wl phy_watchdog 0
	echo "wl mpc 0"	
	/bin/wl mpc 0
	echo "wl down" 	
	/bin/wl down 
	echo "wl interference 0" 
	/bin/wl interference 0
	echo "wl ampdu 0" 	
	/bin/wl ampdu 0 
	echo "wl wsec 0" 
	/bin/wl wsec 0 
	echo "wl mimo_bw_cap 1" 
	/bin/wl mimo_bw_cap 1 
	echo "wl bi 65535" 
	/bin/wl bi 65535 
	echo "wl up" 
	/bin/wl up 
	echo "wl country ALL" 
	/bin/wl country ALL 
	echo "wl tempsense_disable 1" 
	/bin/wl tempsense_disable 1 

	exit 0
} 

BCM2G_5G_WifiChipInit()
{
	# $1 = wifi_frequency  0--2.4G/1--5G
	
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "killall -9 acsd"
	/bin/killall -9 acsd
	echo "wl -i wl$1 nphy_txpwrctrl 1"
	/bin/wl -i wl$1 nphy_txpwrctrl 1
	echo "wl -i wl$1 phy_watchdog 0"
	bin_wl -i wl$1 phy_watchdog 0
	echo "wl -i wl$1 mpc 0"
	bin_wl -i wl$1 mpc 0
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 interference 0"
	/bin/wl -i wl$1 interference 0
	echo "wl -i wl$1 mbss 0"
	bin_wl -i wl$1 mbss 0
	echo "wl -i wl$1 ampdu 0"
	bin_wl -i wl$1 ampdu 0
	echo "wl -i wl$1 wsec 0"
	bin_wl -i wl$1 wsec 0
	echo "wl -i wl$1 mimo_bw_cap 1"
	bin_wl -i wl$1 mimo_bw_cap 1
	echo "wl -i wl$1 bi 65535"
	bin_wl -i wl$1 bi 65535
	echo "wl -i wl$1 up"
	bin_wl -i wl$1 up
	echo "wl -i wl$1 country ALL"
	bin_wl -i wl$1 country ALL
	echo "wl -i wl$1 tempsense_disable 1"
	bin_wl -i wl$1 tempsense_disable 1
	echo "wl -i wl$1 pkteng_stop tx"
	bin_wl -i wl$1 pkteng_stop tx

	exit 0
}

BCM5G_11AC_WifiChipInit()
{
	echo "wl -i wl1 down"
	bin_wl -i wl1 down
	echo "wl -i wl1 vhtmode 1"
	bin_wl -i wl1 vhtmode 1
	echo "wl -i wl1 pkteng_stop rx"
	/bin/wl -i wl1 pkteng_stop rx
	echo "wl -i wl1 pkteng_stop tx"
	/bin/wl -i wl1 pkteng_stop tx
	echo "wl -i wl1 phy_watchdog 1"
	bin_wl -i wl1 phy_watchdog 1
	echo "wl -i wl1 mpc 0"
	bin_wl -i wl1 mpc 0
	echo "wl -i wl1 ssid """
	wl -i wl1 ssid ""
	echo "wl -i wl1 down"
	bin_wl -i wl1 down
	echo "wl -i wl1 country ALL"
	bin_wl -i wl1 country ALL
	echo "wl -i wl1 wsec 0"
	bin_wl -i wl1 wsec 0
	echo "wl -i wl1 stbc_tx 0"
	bin_wl -i wl1 stbc_tx 0
	echo "wl -i wl1 stbc_rx 1"
	bin_wl -i wl1 stbc_rx 1
	echo "wl -i wl1 spect 0"
	bin_wl -i wl1 spect 0
	echo "wl -i wl1 bw_cap 5g 7"
	bin_wl -i wl1 bw_cap 5g 7
	echo "wl -i wl1 mbss 0"
	bin_wl -i wl1 mbss 0
	echo "wl -i wl1 frameburst 0"
	bin_wl -i wl1 frameburst 0
	echo "wl -i wl1 ampdu 0"
	bin_wl -i wl1 ampdu 0
	echo "wl -i wl1 bi 65535"
	bin_wl -i wl1 bi 65535
	echo "wl -i wl1 phy_watchdog 1"
	bin_wl -i wl1 phy_watchdog 1
	echo "wl -i wl1 down"
	bin_wl -i wl1 down
	echo "wl -i wl1 spatial_policy 1"
	bin_wl -i wl1 spatial_policy 1
	echo "wl -i wl1 phy_watchdog 0"
	bin_wl -i wl1 phy_watchdog 0
	echo "wl -i wl1 band a"
	bin_wl -i wl1 band a

	exit 0
}

RTL8192_WifiChipInit()
{
	echo "iwpriv wlan$1 mp_stop"  
	bin_iwpriv wlan$1 mp_stop
	echo "ifconfig wlan$1 down"                   
	ifconfig wlan$1 down 
	echo "iwpriv wlan$1 set_mib mp_specific=1"                   
	bin_iwpriv wlan$1 set_mib mp_specific=1
	echo "iwpriv wlan$1 set_mib ther=0"    
	bin_iwpriv wlan$1 set_mib ther=0
	echo "ifconfig wlan$1 up"           
	ifconfig wlan$1 up 
	echo "iwpriv wlan$1 mp_start"                    
	bin_iwpriv wlan$1 mp_start 

	echo "success !"
	exit 0  
}


# exe script according to wifi chip type
ExeWifiChipInit()
{
	# $1 = wifi_id
	# $2 = wifi_frequency  0--2.4G/1--5G

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		echo "ERROR::Command is not support!"
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		if [ "$2" = "0" ];then
			BCM43217_WifiChipInit
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#bcm4331
	14e44331 )
		if [ "$2" = "0" ];then
			BCM2G_5G_WifiChipInit $2
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#bcm4360
	14e44360 )
		if [ "$2" = "1" ];then
			BCM2G_5G_WifiChipInit $2
		elif [ "$2" = "11ac" ]; then
			BCM5G_11AC_WifiChipInit
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#rtl8192
	10ec818b )
		if [ "$2" = "0" ];then
			RTL8192_WifiChipInit $2
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
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
	elif [ "$1" = "1" -o "$1" = "11ac" ]; then
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
		ExeWifiChipInit $dev_id $1
	else
		echo "WifiChipInit_A.sh {0-2G/1-5G/11ac}"
	fi
fi


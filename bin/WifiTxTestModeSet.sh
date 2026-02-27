#! /bin/sh

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

RT5392_WifiTxTestModeSet()
{
	echo "iwpriv ra0 set ATEDA=00:11:22:33:44:55"
	/bin/iwpriv ra0 set ATEDA=00:11:22:33:44:55
	echo "iwpriv ra0 set ATESA=00:aa:bb:cc:dd:ee"
    /bin/iwpriv ra0 set ATESA=00:aa:bb:cc:dd:ee
	echo "iwpriv ra0 set ATEBSSID=00:11:22:33:44:55"
    /bin/iwpriv ra0 set ATEBSSID=00:11:22:33:44:55
	echo "iwpriv ra0 set ATECHANNEL=$1"
	bin_iwpriv ra0 set ATECHANNEL=$1
	echo "iwpriv ra0 set ATETXMODE=$2"
	bin_iwpriv ra0 set ATETXMODE=$2
	echo "iwpriv ra0 set ATETXMCS=$3"
	bin_iwpriv ra0 set ATETXMCS=$3
	echo "iwpriv ra0 set ATETXBW=$4"
	bin_iwpriv ra0 set ATETXBW=$4
	echo "iwpriv ra0 set ATETXGI=$5"
	bin_iwpriv ra0 set ATETXGI=$5
	echo "iwpriv ra0 set ATETXPOW0=$6"
	bin_iwpriv ra0 set ATETXPOW0=$6
	echo "iwpriv ra0 set ATETXPOW1=$7"
	bin_iwpriv ra0 set ATETXPOW1=$7
	echo "iwpriv ra0 set ATETXFREQOFFSET=$8"
	bin_iwpriv ra0 set ATETXFREQOFFSET=$8
	echo "iwpriv ra0 set ATETXLEN=1024"
	/bin/iwpriv ra0 set ATETXLEN=1024
	echo "iwpriv ra0 set ATETXCNT=100000000"
	/bin/iwpriv ra0 set ATETXCNT=100000000
	echo "iwpriv ra0 set ATETXANT=$9"
	bin_iwpriv ra0 set ATETXANT=$9

	exit 0
	
}

BCM2G_WifiTxTestModeSet()
{
	echo "wl -i wl$1 pkteng_stop tx"
	bin_wl -i wl$1 pkteng_stop tx
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 rxchain 7"
	bin_wl -i wl$1 rxchain 7
	echo "wl -i wl$1 band b"
	bin_wl -i wl$1 band b
	echo "wl -i wl$1 mimo_txbw $2"
	bin_wl -i wl$1 mimo_txbw $2
	echo "wl -i wl$1 chanspec -c $3 -b 2 -w $4 -s $5"
	bin_wl -i wl$1 chanspec -c $3 -b 2 -w $4 -s $5
	 
	if [ $7 -eq 54 ];
		then 
		echo "wl -i wl$1 nrate $6 $7"
		bin_wl -i wl$1 nrate $6 $7
	elif [ $7 -eq 7 ];
		then
		echo "wl -i wl$1 nrate $6 $7 -s 0"
		bin_wl -i wl$1 nrate $6 $7 -s 0
	else
		echo "ERROR::input para is not right!" && exit 1
	fi
	
	echo "wl -i wl$1 rxchain $8"
	bin_wl -i wl$1 rxchain $8
	echo "wl -i wl$1 txchain $9"
	bin_wl -i wl$1 txchain $9
	echo "wl -i wl$1 up"
	bin_wl -i wl$1 up
	echo "wl -i wl$1 isup"
	bin_wl -i wl$1 isup
	echo "wl -i wl$1 txpwr1 -1"
	bin_wl -i wl$1 txpwr1 -1
	echo "wl -i wl$1 phy_forcecal 1"
	bin_wl -i wl$1 phy_forcecal 1
	echo "wl -i wl$1 ssid"
	/bin/wl -i wl$1 ssid ""
	
	exit 0

}

BCM5G_WifiTxTestModeSet_11AC()
{
	echo "wl -i wl1 pkteng_stop rx"
	/bin/wl -i wl1 pkteng_stop rx
	echo "wl -i wl1 pkteng_stop tx"
	/bin/wl -i wl1 pkteng_stop tx
	echo "wl -i wl1 mpc 0"
	bin_wl -i wl1 mpc 0
	echo "wl -i wl1 ssid """
	/bin/wl -i wl1 ssid ""
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
	echo "wl -i wl1 txcore -s 1 -c $1"
	bin_wl -i wl1 txcore -s 1 -c $1
	echo "wl -i wl1 phy_watchdog 0"
	bin_wl -i wl1 phy_watchdog 0
	echo "wl -i wl1 band a"
	bin_wl -i wl1 band a
	echo "wl -i wl1 chanspec $2"
	bin_wl -i wl1 chanspec $2
	echo "wl -i wl1 up"
	bin_wl -i wl1 up
	echo "wl -i wl1 phy_forcecal 1"
	bin_wl -i wl1 phy_forcecal 1
	echo "wl -i wl1 5g_rate $3 $4 -s 1 --ldpc -b $5"
	bin_wl -i wl1 5g_rate $3 $4 -s 1 --ldpc -b $5
	echo "wl -i wl1 phy_txpwrctrl 1"
	bin_wl -i wl1 phy_txpwrctrl 1
	echo "wl -i wl1 txpwr1 -1"
	bin_wl -i wl1 txpwr1 -1
	echo "wl -i wl1 mpc 0"
	bin_wl -i wl1 mpc 0
	echo "wl -i wl1 interference_override 0"
	bin_wl -i wl1 interference_override 0
	echo "wl -i wl1 ssid """
	/bin/wl -i wl1 ssid ""

	exit 0
}

BCM5G_WifiTxTestModeSet()
{
	echo "wl -i wl$1 pkteng_stop tx"
	bin_wl -i wl$1 pkteng_stop tx
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 rxchain 7"
	bin_wl -i wl$1 rxchain 7
	echo "wl -i wl$1 band auto"
	bin_wl -i wl$1 band auto
	echo "wl -i wl$1 mimo_txbw $2"
	bin_wl -i wl$1 mimo_txbw $2
	echo "wl -i wl$1 chanspec $3"
	bin_wl -i wl$1 chanspec $3
	
	if [ $5 -eq 54 ]; then
		echo "wl -i wl$1 nrate $4 $5"
		bin_wl -i wl$1 nrate $4 $5
	elif [ $5 -eq 7 ]; then
		echo "wl -i wl$1 nrate $4 $5 -s 0"
		bin_wl -i wl$1 nrate $4 $5 -s 0
	else 
		echo "ERROR::input para is not right!" && exit 1
	fi
	
	echo "wl -i wl$1 rxchain $6"
	bin_wl -i wl$1 rxchain $6
	echo "wl -i wl$1 txchain $7"
	bin_wl -i wl$1 txchain $7
	echo "wl -i wl$1 up"
	bin_wl -i wl$1 up
	echo "wl -i wl$1 isup"
	bin_wl -i wl$1 isup
	echo "wl -i wl$1 txpwr1 -1"
	bin_wl -i wl$1 txpwr1 -1
	echo "wl -i wl$1 phy_forcecal 1"
	bin_wl -i wl$1 phy_forcecal 1
	echo "wl -i wl$1 ssid"
	/bin/wl -i wl$1 ssid ""
	
	exit 0
}


RTL8192_WifiTxTestModeSet()
{
    # $1 = wifi_frequency  0--2.4G/1--5G
    # $2 = FreqOffSet
    # $3 = mp_rate
    # $4 = bandwidth
    # $5 = channel
    # $6 = txpower patha
    # $7 = txpower pathb
    # $8 = ant_tx
    
	echo "iwpriv wlan$1 mp_phypara xcap=$2"                  
	bin_iwpriv wlan$1 mp_phypara xcap=$2
	echo "iwpriv wlan$1 mp_rate $3"            
	bin_iwpriv wlan$1 mp_rate $3
	echo "iwpriv wlan$1 mp_bandwidth 40M=$4"                    
	bin_iwpriv wlan$1 mp_bandwidth 40M=$4
	echo "iwpriv wlan$1 mp_channel $5"            
	bin_iwpriv wlan$1 mp_channel $5
	echo "iwpriv wlan$1 mp_txpower patha=$6,pathb=$7"                  
	bin_iwpriv wlan$1 mp_txpower patha=$6,pathb=$7
	echo "iwpriv wlan$1 mp_ant_tx $8"   
	bin_iwpriv wlan$1 mp_ant_tx $8
	
	echo "success !"
	exit 0   
}


# exe script according to wifi chip type
ExeWifiTxTestModeSet()
{
	# $1 = wifi_id
	# $2 = wifi_frequency  0--2.4G/1--5G

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		if [ "$2" = "?" ]; then
			echo "WifiTxTestModeSet.sh {channel} {mode} {mcs} {bandWidth} {tx_gi} {power0} {power1} {FreqOffSet} {tx_ant}"
		else
			RT5392_WifiTxTestModeSet $2 $3 $4 $5 $6 $7 $8 $9 $10
		fi
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		echo "ERROR::Command is not support!"
		;;

	#bcm4331
	14e44331 )
		if [ "$2" = "?" ]; then
			echo "WifiTxTestModeSet.sh {MIMO_TXBW} {CHANSPEC_C} {CHANSPEC_W} {CHANSPEC_S} {NRATE_RM} {RXCHAIN} {TXCHAIN}"
		elif [ "$2" = "0" ]; then
			BCM2G_WifiTxTestModeSet $2 $3 $4 $5 $6 $7 $8 $9 $10
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#bcm4360
	14e44360 )
		if [ "$2" = "1" ];then
			if [ "$3" = "11ac" ]; then
				BCM5G_WifiTxTestModeSet_11AC $4 $5 $6 $7 $8
			else
				BCM5G_WifiTxTestModeSet $2 $3 $4 $5 $6 $7 $8 
			fi
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
		;;

	#rtl8192
	10ec818b )
		if [ "$2" = "?" ]; then
			echo "WifiTxTestModeSet.sh {0--2G/1--5G} {FreqOffSet} {mp_rate} {bandwidth} {channel} {txpower patha} {txpower pathb} {ant_tx}"
		elif [ "$2" = "0" ]; then
			RTL8192_WifiTxTestModeSet $2 $3 $4 $5 $6 $7 $8 $9
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
ExeWifiTxTestModeSet $dev_id $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
fi

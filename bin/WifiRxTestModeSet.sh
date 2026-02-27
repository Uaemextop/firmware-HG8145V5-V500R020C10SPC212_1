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

RT5392_WifiRxTestModeSet()
{
	echo "iwpriv ra0 set ATECHANNEL=$1"		
	bin_iwpriv ra0 set ATECHANNEL=$1
	echo "iwpriv ra0 set ResetCounter=$2"	
	bin_iwpriv ra0 set ResetCounter=$2
	echo "iwpriv ra0 set ATETXFREQOFFSET=$3"	
	bin_iwpriv ra0 set ATETXFREQOFFSET=$3
	echo "iwpriv ra0 set ATETXMODE=$4"	
	bin_iwpriv ra0 set ATETXMODE=$4
	echo "iwpriv ra0 set ATETXMCS=$5"	
	bin_iwpriv ra0 set ATETXMCS=$5
	echo "iwpriv ra0 set ATETXBW=$6"	
	bin_iwpriv ra0 set ATETXBW=$6
	echo "iwpriv ra0 set ATEFILTERENABLE=$7"	
	bin_iwpriv ra0 set ATEFILTERENABLE=$7
	echo "iwpriv ra0 set ATEFILTER=01:ef:4c:81:96:c1"	
	/bin/iwpriv ra0 set ATEFILTER=01:ef:4c:81:96:c1
	echo "iwpriv ra0 set ATERXANT=$8"	
	bin_iwpriv ra0 set ATERXANT=$8

	exit 0
}

BCM2G_WifiRxTestModeSet()
{
	# $1 = wifi_frequency  0--2.4G/1--5G
  
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 band b"
	bin_wl -i wl$1 band b
	echo "wl -i wl$1 mimo_txbw $2"
	bin_wl -i wl$1 mimo_txbw $2
	echo "wl -i wl$1 bi 65535"
	bin_wl -i wl$1 bi 65535
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
	echo "wl -i wl$1 join rftest imode infra"
	bin_wl -i wl$1 join rftest imode infra
	echo "wl -i wl$1 ssid"
	/bin/wl -i wl$1 ssid ""
	echo "wl -i wl$1 mac 00:ef:4c:81:96:c1"
	bin_wl -i wl$1 mac 00:ef:4c:81:96:c1
	echo "wl -i wl$1 macmode 2"
	bin_wl -i wl$1 macmode 2

	exit 0
}

BCM5G_WifiRxTestModeSet_11AC()
{
	echo "wl -i wl1 ap"
	bin_wl -i wl1 ap
	echo "wl -i wl1 ssid """
	/bin/wl -i wl1 ssid ""
	echo "wl -i wl1 down"
	bin_wl -i wl1 down
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

	exit 0
}

BCM5G_WifiRxTestModeSet()
{
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 down"
	bin_wl -i wl$1 down
	echo "wl -i wl$1 band auto"
	bin_wl -i wl$1 band auto
	echo "wl -i wl$1 mimo_txbw $2"
	bin_wl -i wl$1 mimo_txbw $2
	echo "wl -i wl$1 bi 65535"
	bin_wl -i wl$1 bi 65535
	echo "wl -i wl$1 chanspec $3"
	bin_wl -i wl$1 chanspec $3

	if [ $5 -eq 54 ];
		then
		echo "wl -i wl$1 nrate $4 $5"
		bin_wl -i wl$1 nrate $4 $5
	elif [ $5 -eq 7 ];
		then
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
	echo "wl -i wl$1 join rftest imode infra"
	bin_wl -i wl$1 join rftest imode infra
	echo "wl -i wl$1 ssid"
	/bin/wl -i wl$1 ssid ""
	echo "wl -i wl$1 mac 00:ef:4c:81:96:c1"
	bin_wl -i wl$1 mac 00:ef:4c:81:96:c1
	echo "wl -i wl$1 macmode 2"
	bin_wl -i wl$1 macmode 2

	exit 0
}

RTL8192_WifiRxTestModeSet()
{
	# $1 = wifi_frequency  0--2.4G/1--5G
    # $2 = xcap
    # $3 = mp_rate
    # $4 = bandwidth
    # $5 = channel
    # $6 = ant_tx
	
	echo "iwpriv wlan$1 mp_phypara xcap=$2"
	bin_iwpriv wlan$1 mp_phypara xcap=$2
	echo "iwpriv wlan$1 mp_rate $3"
	bin_iwpriv wlan$1 mp_rate $3
	echo "iwpriv wlan$1 mp_bandwidth 40M=$4"
	bin_iwpriv wlan$1 mp_bandwidth 40M=$4
	echo "iwpriv wlan$1 mp_channel $5"
	bin_iwpriv wlan$1 mp_channel $5
	echo "iwpriv wlan$1 mp_ant_rx $6"
	bin_iwpriv wlan$1 mp_ant_rx $6
	echo "iwpriv wlan$1 mp_arx filter_init"
	bin_iwpriv wlan$1 mp_arx filter_init
	echo "iwpriv wlan$1 mp_arx filter_DA=00:ef:4c:81:96:c1"
	bin_iwpriv wlan$1 mp_arx filter_DA=00:ef:4c:81:96:c1
	
	echo "success !"
	exit 0
}

# exe script according to wifi chip type
ExeWifiRxTestModeSet()
{
	# $1 = wifi_id
	# $2 = wifi_frequency  0--2.4G/1--5G

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		if [ "$2" = "?" ]; then
			echo "WifiRxTestModeSet.sh {channel} 0 {FreqOffSet} {mode} {mcs} {bandwidth} 1 {rx_ant}"
		else
			RT5392_WifiRxTestModeSet $2 $3 $4 $5 $6 $7 $8 $9
		fi
		;;
	
	#bcm43217
	14e443a9 | 14e4a8db )
		echo "ERROR::Command is not support!"
		;;

	#bcm4331
	14e44331 )
		if [ "$2" = "?" ]; then
			echo "WifiRxTestModeSet.sh {MIMO_TXBW} {CHANSPEC_C} {CHANSPEC_W} {CHANSPEC_S} {NRATE_RM} {RXCHAIN} {TXCHAIN}"
		elif [ "$2" = "0" ]; then 
			BCM2G_WifiRxTestModeSet $2 $3 $4 $5 $6 $7 $8 $9 $10
		else
			echo "ERROR::input para is not right!"
			exit 1					
		fi
		;;

	#bcm4360
	14e44360 )
		if [ "$2" = "1" ]; then
			if [ "$3" = "11ac" ]; then
				BCM5G_WifiRxTestModeSet_11AC $4 $5 $6 $7 $8
			else
				BCM5G_WifiRxTestModeSet $2 $3 $4 $5 $6 $7 $8
			fi
		else
			echo "ERROR::input para is not right!"
			exit 1				
		fi
		;;

	#rtl8192
	10ec818b )
		if [ "$2" = "?" ]; then
			echo "WifiRxTestModeSet.sh {0--2G/1--5G} {xcap} {mp_rate} {bandwidth} {channel} {ant_rx}"
		elif [ "$2" = "0" ]; then
			RTL8192_WifiRxTestModeSet $2 $3 $4 $5 $6 $7
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
ExeWifiRxTestModeSet $dev_id $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
fi

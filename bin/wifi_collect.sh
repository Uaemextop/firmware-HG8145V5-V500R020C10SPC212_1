#! /bin/sh

RunCmd()
{
	echo "$* :"
	$*
}

CollectWifiLog()
{
	echo -e "\r"
	RunCmd chipdebug wifi status channel band V
	sleep 1
	RunCmd chipdebug wifi status channel band W
	sleep 1
	RunCmd chipdebug wifi status channel band U

	collect_wifilog_list="config connect channel debug collision wpsstatus"
	collect_wifichip_list=$@

	for collect_wifichip_index in $collect_wifichip_list
	do
		for collect_wifilog_type in $collect_wifilog_list
		do
			RunCmd cat "/proc/wifilog/"${collect_wifilog_type}"/"${collect_wifichip_index}
			echo -e "\r"
		done
	done
	RunCmd cat "/proc/wifilog/log"
	RunCmd cat "/var/wifidebug"
}

CollectPktInfo()
{
	dev_list=$@
	dev_num=$#

	is_ssid_from_5=`echo $dev_list | grep "rai"``echo $dev_list | grep "wl1"`
	if [[ -z "$is_ssid_from_5" || $dev_num -gt 4 ]];then
		ssid_active_index=1
	else
		ssid_active_index=5
	fi

	ssid_list=""
	for dev_index in $dev_list
	do
		if [ $ssid_active_index -gt 8 ];then
			break
		fi

		ISUP=`ifconfig $dev_index | grep "RUNNING"`	
		if [ -z "$ISUP" ];then
			ssid_active_index=`expr $ssid_active_index + 1`
			continue
		fi 

		ssid_list="$ssid_list $ssid_active_index"
		ssid_active_index=`expr $ssid_active_index + 1`
	done

	for ssid_index in $ssid_list
	do
		RunCmd chipdebug wifi statistic ssid $ssid_index
		sleep 1
		echo -e "\r"
	done
}

CollectPktInfoMars()
{
	dev_list=$@
	ssid_active_index=1 

	ssid_list=""
	for dev_index in $dev_list
	do
		ISUP=`ifconfig $dev_index | grep "RUNNING"`	
		if [ -z "$ISUP" ];then
			ssid_active_index=`expr $ssid_active_index + 1`
			continue
		fi 

		ssid_list="$ssid_list $ssid_active_index"
		ssid_active_index=`expr $ssid_active_index + 1`
	done

	touch /var/mars_collect_sign
	echo "mars_collect_sign" > /var/mars_collect_sign
	mars_sch_log_path="/tmp/sch_log.txt"

	for ssid_index in $ssid_list
	do
		RunCmd chipdebug wifi statistic ssid $ssid_index
		sleep 4

		cat /proc/wifilog/cmdout/All

		if [ -f "$mars_sch_log_path" ];then
			cat /tmp/sch_log.txt
		fi

		echo -e "\r"
	done

	rm /var/mars_collect_sign
	echo "clearlog All "> /proc/wifilog/cmdout/All
}

CollectRT5392()
{
	RunCmd ifconfig -a
	
	RunCmd cat /var/RT2860AP.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
				
	RunCmd cat /proc/wifilog/channel/2G
				
	RunCmd cat /proc/wifilog/connect/2G
				
	RunCmd cat /proc/wifilog/config/2G
	
	RunCmd cat /proc/wifilog/cmdout/2G
	
	rt_devlist="ra0 ra1 ra2 ra3"
	
	for rt_dev in $rt_devlist
	do
		
		RunCmd iwpriv $rt_dev stat | grep -v Pin
		
		RunCmd iwpriv $rt_dev rf
		
		RunCmd iwpriv $rt_dev e2p
		
		echo "clearlog 2G "> /proc/wifilog/cmdout/All
		
		echo "iwpriv $rt_dev show stainfo:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show stainfo
		
		echo "iwpriv $rt_dev show stacountinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show stacountinfo
		
		echo "iwpriv $rt_dev show stasecinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show stasecinfo
		
		echo "iwpriv $rt_dev show bainfo:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show bainfo
		
		echo "iwpriv $rt_dev show TxRate:" >/proc/wifilog/cmdout/2G		
		iwpriv $rt_dev  show TxRate
		
		echo "iwpriv $rt_dev show FalseCCA:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show FalseCCA
		
		echo "iwpriv $rt_dev show CN:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show CN
		
		echo "iwpriv $rt_dev show UnicastRate:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show UnicastRate
		
		echo "iwpriv $rt_dev show Chanspec:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show Chanspec
		
		echo "iwpriv $rt_dev show Rssi:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show Rssi
		
		echo "iwpriv $rt_dev show FilterMac:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show FilterMac
		
		echo "iwpriv $rt_dev show FilterMacMode:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show FilterMacMode
		
		echo "iwpriv $rt_dev show peerinfo=$rt_dev:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show peerinfo=$rt_dev
		
		echo "iwpriv $rt_dev show FrameBurst:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show FrameBurst
		
		echo "iwpriv $rt_dev show BandWidth:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show BandWidth
		
		echo "iwpriv $rt_dev show pwrinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show pwrinfo
		
		echo "iwpriv $rt_dev show rateset:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show rateset
		
		echo "iwpriv $rt_dev show chanlist:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show chanlist
		
		echo "iwpriv $rt_dev show pwrpercent:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show pwrpercent
		
		echo "iwpriv $rt_dev show txwme:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show txwme
		
		echo "iwpriv $rt_dev show commonconfig:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show commonconfig
		
		echo "iwpriv $rt_dev show interfaceconfig:" >/proc/wifilog/cmdout/2G
		iwpriv $rt_dev show interfaceconfig
		
		cat /proc/wifilog/cmdout/2G
		echo "clearlog 2G "> /proc/wifilog/cmdout/All
		
		RunCmd iwconfig $rt_dev
	done
}


Mt76xxBssidConflictCheck()
{
    LogOut=$1
	
	shift
	
    mt76xx_devlist=$@
	
	for dev in $mt76xx_devlist
	do
	    ISUP=`ifconfig $dev | grep "RUNNING"`
		
		if [ -z "$ISUP" ];then
		
		    continue
		fi
		
	    APBSSID=`iwconfig $dev | grep "Access Point" | awk '{print $5}'`
		 
		echo "clearlog All "> /proc/wifilog/cmdout/All
			
		iwpriv $dev get_site_survey

		Conflict=`cat /proc/wifilog/cmdout/All | grep $APBSSID`
		
		if [ -z "$Conflict" ];then
		
		    APBSSID="$(echo $APBSSID | tr '[:upper:]' '[:lower:]')"
			
			Conflict=`cat /proc/wifilog/cmdout/All | grep $APBSSID`
		fi

		check=`echo "$Conflict" | grep "$APBSSID"`

		if [ -n "$check" ];then
		
		   currentTime=`date "+%Y-%m-%d %H:%M:%S"`	   
		   
		   APSSID=`iwconfig $dev | grep "ESSID" | awk -F ":" '{print $2}'`
		   
		   APSSID=`echo "$APSSID" | tr -d '"'`
		   
		   NeibSSID=`echo "$Conflict" | awk '{print $2}'`	

           NeibSSID=`echo "$NeibSSID" | tr -d '"'`		   
		   
		   NeibBSSID=$APBSSID
		   
		   echo -e "$currentTime\t$APSSID\t$APBSSID\t[BSSID conflict with:]\t$NeibSSID\t$NeibBSSID" > /proc/wifilog/collision/$LogOut
		fi
	done
	
	echo "clearlog All "> /proc/wifilog/cmdout/All	
}

CollectMT7603()
{
	RunCmd ifconfig -a
	
	SitesurveyDone="0"
	
	RunCmd cat /var/RT2860AP_7603.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
	
	RunCmd cat /proc/wifilog/cmdout/2G
	
	mt7603_devlist="ra0 ra1 ra2 ra3"
	
	for mt_dev in $mt7603_devlist
	do
		RunCmd iwpriv $mt_dev stat | grep -v Pin
		
		RunCmd iwpriv $mt_dev e2p
		
		echo "clearlog 2G "> /proc/wifilog/cmdout/All
		
		echo "iwpriv $mt_dev show stainfo:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show stainfo
		
		echo "iwpriv $mt_dev show stacountinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show stacountinfo
		
		echo "iwpriv $mt_dev show stasecinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show stasecinfo
		
		echo "iwpriv $mt_dev show bainfo:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show bainfo
		
		echo "iwpriv $mt_dev show TxRate:" >/proc/wifilog/cmdout/2G		
		iwpriv $mt_dev show TxRate
		
		echo "iwpriv $mt_dev show FalseCCA:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show FalseCCA
		
		echo "iwpriv $mt_dev show CN:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show CN
		
		echo "iwpriv $mt_dev show UnicastRate:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show UnicastRate
		
		echo "iwpriv $mt_dev show Chanspec:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show Chanspec
		
		echo "iwpriv $mt_dev show Rssi:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show Rssi
		
		echo "iwpriv $mt_dev show Assolist:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show Assolist
		
		echo "iwpriv $mt_dev show FilterMacMode:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show FilterMacMode
		
		echo "iwpriv $mt_dev show peerinfo=$mt_dev:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show peerinfo=$mt_dev
		
		echo "iwpriv $mt_dev show FrameBurst:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show FrameBurst
		
		echo "iwpriv $mt_dev show BandWidth:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show BandWidth
		
		echo "iwpriv $mt_dev show pwrinfo:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show pwrinfo
		
		echo "iwpriv $mt_dev show rateset:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show rateset
		
		echo "iwpriv $mt_dev show chanlist:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show chanlist
		
		echo "iwpriv $mt_dev show pwrpercent:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show pwrpercent
		
		echo "iwpriv $mt_dev show txwme:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show txwme
		
		echo "iwpriv $mt_dev show commonconfig:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show commonconfig
		
		echo "iwpriv $mt_dev show interfaceconfig:" >/proc/wifilog/cmdout/2G
		iwpriv $mt_dev show interfaceconfig
		
		cat /proc/wifilog/cmdout/2G
		echo "clearlog 2G "> /proc/wifilog/cmdout/All
		
		RunCmd iwconfig $mt_dev
		
		ISUP=`ifconfig $mt_dev | grep "RUNNING"`
		
		if [ -n "$ISUP" ];then
		
		    if [ $SitesurveyDone = "0" ];then
		       
			    iwpriv $mt_dev set SiteSurvey=1
				
				SitesurveyDone="1"
			fi
		fi
		
		Mt76xxBssidConflictCheck 2G $mt_dev
	done
	
	MT7603_WifiChip="2G"
	CollectWifiLog $MT7603_WifiChip
	CollectPktInfo $mt7603_devlist
}

CollectMT7612()
{
    SitesurveyDone="0"
	
	RunCmd cat /var/RT2860AP_7612.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
	
	RunCmd cat /proc/wifilog/cmdout/5G
	
	mt7612_devlist="rai0 rai1 rai2 rai3"
	
	for dev in $mt7612_devlist
	do
		RunCmd iwpriv $dev stat | grep -v Pin
		
		RunCmd iwpriv $dev rf
		
		RunCmd iwpriv $dev bbp
		
		RunCmd iwpriv $dev e2p
		
		echo "clearlog 5G "> /proc/wifilog/cmdout/All
		
		echo "iwpriv $dev show stainfo:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show stainfo
		
		echo "iwpriv $dev show stacountinfo:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show stacountinfo
		
		echo "iwpriv $dev show stasecinfo:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show stasecinfo
		
		echo "iwpriv $dev show bainfo:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show bainfo
		
		echo "iwpriv $dev  show TxRate:" >/proc/wifilog/cmdout/5G		
		iwpriv $dev show TxRate
		
		echo "iwpriv $dev show FalseCCA:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show FalseCCA
		
		echo "iwpriv $dev show CN:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show CN
		
		echo "iwpriv $dev show UnicastRate:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show UnicastRate
		
		echo "iwpriv $dev show Chanspec:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show Chanspec
		
		echo "iwpriv $dev show Rssi:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show Rssi
		
		echo "iwpriv $dev show FilterMac:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show FilterMac
		
		echo "iwpriv $dev show FilterMacMode:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show FilterMacMode
		
		echo "iwpriv $dev show peerinfo=$dev:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show peerinfo=$dev
		
		echo "iwpriv $dev show FrameBurst:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show FrameBurst
		
		echo "iwpriv $dev show BandWidth:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show BandWidth
		
		echo "iwpriv $dev show pwrinfo:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show pwrinfo
		
		echo "iwpriv $dev show rateset:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show rateset
		
		echo "iwpriv $dev show chanlist:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show chanlist
		
		echo "iwpriv $dev show pwrpercent:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show pwrpercent
		
		echo "iwpriv $dev show txwme:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show txwme
		
		echo "iwpriv $dev show commonconfig:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show commonconfig
		
		echo "iwpriv $dev show interfaceconfig:" >/proc/wifilog/cmdout/5G
		iwpriv $dev show interfaceconfig
		
		cat /proc/wifilog/cmdout/5G
		echo "clearlog 5G "> /proc/wifilog/cmdout/All
		
		RunCmd iwconfig $dev
		
		ISUP=`ifconfig $dev | grep "RUNNING"`
		
		if [ -n "$ISUP" ];then
		
		    if [ $SitesurveyDone = "0" ];then
		       
			    iwpriv $dev set SiteSurvey=1
				
				SitesurveyDone="1"
			fi
		fi
		
		Mt76xxBssidConflictCheck 5G $dev
	done
	
	MT7612_WifiChip="5G"
	CollectWifiLog $MT7612_WifiChip
	CollectPktInfo $mt7612_devlist
}

CollectMT7615()
{
	mt7615_devlist="ra0 ra1 ra2 ra3 rai0 rai1 rai2 rai3"

	SitesurveyDone2G="0"

	RunCmd cat /var/RT2860AP_2G.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v UUID

	SitesurveyDone5G="0"

	RunCmd cat /var/RT2860AP_5G.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v UUID
	
	for dev in $mt7615_devlist
	do
		if [ "$dev" = "ra0" ]||[ "$dev" = "ra1" ]||[ "$dev" = "ra2" ]||[ "$dev" = "ra3" ];then
		  
		   if [ $SitesurveyDone2G = "0" ];then
		       
			   iwpriv $dev set SiteSurvey=1
			   
			   SitesurveyDone2G="1"
		   fi
		   Mt76xxBssidConflictCheck 2G $dev
		   
		elif [ "$dev" = "rai0" ]||[ "$dev" = "rai1" ]||[ "$dev" = "rai2" ]||[ "$dev" = "rai3" ];then
		
		   if [ $SitesurveyDone5G = "0" ];then
		       
			   iwpriv $dev set SiteSurvey=1
			   
			   SitesurveyDone5G="1"
		   fi
		   Mt76xxBssidConflictCheck 5G $dev
		fi
	done
	
	MT7615_WifiChip="2G 5G"
	CollectWifiLog $MT7615_WifiChip
	CollectPktInfo $mt7615_devlist

	
	RunCmd cat /var/RT2860AP_2G.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
	
	RunCmd cat /var/RT2860AP_5G.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
	
	RunCmd cat /var/RT2860AP_dbdc.dat | grep -v [kK]ey | grep -v P[sS][kK][0-9] | grep -v Pin
	
	RunCmd cat /proc/wifilog/cmdout/2G
	
	RunCmd cat /proc/wifilog/cmdout/5G
	
	RunCmd iwpriv ra0 e2p
	
	echo "clearlog All "> /proc/wifilog/cmdout/All
	
	echo "iwpriv ra0 show stainfo:" >/proc/wifilog/cmdout/2G

	iwpriv ra0 show stainfo
	
	echo "iwpriv ra0 show pwrinfo:" >/proc/wifilog/cmdout/2G
			
        iwpriv ra0 show pwrinfo
	
	RunCmd cat /proc/wifilog/cmdout/2G
	
	for dev in $mt7615_devlist
	do
	    ISUP=`ifconfig $dev | grep "RUNNING"`
		
		if [ -n "$ISUP" ];then
		
			if [ $dev = ra0 ]||[ $dev = ra1 ]||[ $dev = ra2 ]||[ $dev = ra3 ];then
		    
				out="2G"
		
		    else
		
				out="5G"
		    fi
			
			RunCmd iwpriv $dev stat
			
			RunCmd iwpriv $dev rf
			
			echo "clearlog All "> /proc/wifilog/cmdout/All
			
			echo "iwpriv $dev show stacountinfo:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show stacountinfo
			
			echo "iwpriv $dev show bainfo:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show bainfo

			echo "iwpriv $dev  show TxRate:" >/proc/wifilog/cmdout/$out		
			iwpriv $dev show TxRate
			
			echo "iwpriv $dev show FalseCCA:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show FalseCCA
			
			echo "iwpriv $dev show UnicastRate:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show UnicastRate
			
			echo "iwpriv $dev show Chanspec:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show Chanspec
			
			echo "iwpriv $dev show Rssi:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show Rssi
			
			echo "iwpriv $dev show FilterMac:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show FilterMac
			
			echo "iwpriv $dev show FilterMacMode:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show FilterMacMode
			
			echo "iwpriv $dev show FrameBurst:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show FrameBurst
			
			echo "iwpriv $dev show BandWidth:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show BandWidth
			
			echo "iwpriv $dev show rateset:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show rateset
			
			echo "iwpriv $dev show chanlist:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show chanlist
			
			echo "iwpriv $dev show pwrpercent:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show pwrpercent
			
			echo "iwpriv $dev show txwme:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show txwme
			
			echo "iwpriv $dev show commonconfig:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show commonconfig
			
			echo "iwpriv $dev show interfaceconfig:" >/proc/wifilog/cmdout/$out
			iwpriv $dev show interfaceconfig
			
			cat /proc/wifilog/cmdout/$out
			
			echo "clearlog All "> /proc/wifilog/cmdout/All
			
			RunCmd iwconfig $dev
		fi
		
	done
}

QCAxxBssidConflictCheck()
{
    QCAxx_devlist=$@
	
	for dev in $QCAxx_devlist
	do
	    ISUP=`ifconfig $dev | grep "RUNNING"`
		
		if [ -z "$ISUP" ];then
		
		    continue
		fi
		
		if [ $dev = ath0 ]||[ $dev = ath1 ]||[ $dev = ath2 ]||[ $dev = ath3 ];then
		    
		    LogOut="2G"
		
		else
		
		    LogOut="5G"
		fi
		
	    APBSSID=`iwconfig $dev | grep "Access Point" | awk '{print $6}'`
		 
		wlanconfig $dev list ap > /var/QCAListAP
        
		APBSSID="$(echo $APBSSID | tr '[:upper:]' '[:lower:]')"
		
		Conflict=`cat /var/QCAListAP | grep $APBSSID`
      
		check=`echo "$Conflict" | grep "$APBSSID"`
		
		if [ -n "$check" ];then
		
		   currentTime=`date "+%Y-%m-%d %H:%M:%S"`	   
		   
		   APSSID=`iwconfig $dev | grep "ESSID" | awk -F ":" '{print $2}'`
		   
		   APSSID=`echo "$APSSID" | tr -d '"'`
		   
		   NeibSSID=`echo "$Conflict" |  awk '{sub(/^ */,"");sub(/ *$/,"")}1' | awk -F "," '{print $1}'`
           
           NeibSSID=`echo "$NeibSSID" | tr -d '"'`		   
		   
		   NeibBSSID=$APBSSID
		   
		   echo -e "$currentTime\t$APSSID\t$APBSSID\t[BSSID conflict with:]\t$NeibSSID\t$NeibBSSID" > /proc/wifilog/collision/$LogOut
		fi
	done
}
CollectQCA()
{
	RunCmd ifconfig -a
	QCA_devlist="ath0 ath1 ath2 ath3 ath4 ath5 ath6 ath7"
	QCA_devlist2="ath0 ath4"

	is_three_freq_product=`ifconfig -a | grep ath8`
	if [ -z "$is_three_freq_product" ];then        
		QCA_WifiChip="2G 5G"
	
		wifi_index_2g=wifi1
		wifi_index_5g=wifi0
	else       
		QCA_WifiChip="2G 5G 5G_STA"
	
		wifi_index_2g=wifi2
		wifi_index_5g=wifi0
		wifi_index_5g_sta=wifi1

		ifconfig | grep ath4
		if [ $? -eq 1 ];then
			QCA_devlist="ath0 ath1 ath2 ath3 ath8 ath9 ath10 ath11"
		fi
	fi
	
	if [ $wifi_collect_flag -ne 0 ];then
		return;
	fi
	
	wifi_collect_flag=1;
	
	for dev in $QCA_devlist
	do
		ifconfig $dev | grep UP
		if [ $? -eq 0 ];then
		
			QCAxxBssidConflictCheck $dev
			
			if [ $dev == ath0 ];then
				wifi_index=$wifi_index_2g
			elif [ $dev == ath4 ];then
				wifi_index=$wifi_index_5g
			elif [ $dev == ath8 ];then
				wifi_index=$wifi_index_5g_sta
			fi

			if [[ $dev == ath0 || $dev == ath4 || $dev == ath8 ]];then
				
				RunCmd iwpriv $dev get_countrycode
				
				RunCmd iwlist $dev ch
				
				RunCmd wlanconfig $dev list channel

				RunCmd iwpriv $dev get_mode
				
				RunCmd iwpriv $dev get_pureg
				
				RunCmd iwpriv $dev get_puren
				
				RunCmd iwlist $dev txpower
				
				RunCmd athstats -i $wifi_index
				
				RunCmd iwpriv $wifi_index get_burst
				
				RunCmd iwpriv $wifi_index get_burst_dur
			fi
			
			if [ $dev == ath4 ]||[ $dev == ath5 ]||[ $dev == ath6 ]||[ $dev == ath7 ]||[ $dev == ath8 ]||[ $dev == ath9 ]||[ $dev == ath10 ]||[ $dev == ath11 ];then
							
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 1
				
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 2				

				ProtectDmesgExe iwpriv $dev txrx_fw_stats 3
								
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 4
								
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 5
				
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 6
							
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 7
						
				ProtectDmesgExe iwpriv $dev txrx_fw_stats 8	
			
			fi
			
			RunCmd cat /var/hostapd-$dev.conf | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"

			RunCmd cat /tmp/hostapd_$dev.log

			RunCmd iwconfig $dev
			
			RunCmd iwpriv $dev get_shortgi
		
			RunCmd iwpriv $dev get_wmm
		
			RunCmd wlanconfig $dev list sta
			
			RunCmd iwpriv $dev get_maccmd
			
			RunCmd iwpriv $dev getmac
			
			RunCmd iwpriv $dev medump
			
			RunCmd apstats -R -v -i $dev
		fi
	done
	
	for dev2 in $QCA_devlist2
	do
		RunCmd wlanconfig $dev2 showatftable
	done
	
	CollectWifiLog $QCA_WifiChip
	CollectPktInfo $QCA_devlist
}

BCMxxBssidConflictCheck()
{
    LogOut=$1
	
	shift
	
    BCMxx_devlist=$@
	
	for dev in $BCMxx_devlist
	do
	    ISUP=`ifconfig $dev | grep "RUNNING"`
		
		if [ -z "$ISUP" ];then
		
		    continue
		fi

	    APBSSID=`cat /var/wifi.txt | grep $dev"_hwaddr" |awk -F "=" '{print $2}'`
		 
		wl -i $dev scanresults  | grep SSID > /var/BCMListAP1

		awk 'NF==2{printf "%s ", $2;next}1' /var/BCMListAP1 > /var/BCMListAP2
		
		Conflict=`cat /var/BCMListAP2 | grep $APBSSID`
      
		check=`echo "$Conflict" | grep "$APBSSID"`
		
		if [ -n "$check" ];then
		
		   currentTime=`date "+%Y-%m-%d %H:%M:%S"`	   
		   
		   APSSID=`cat /var/wifi.txt | grep $dev"_ssid" |awk -F "=" '{print $2}'`
		   
		   APSSID=`echo "$APSSID" | tr -d '"'`
		   
		   NeibSSID=`echo "$Conflict" |  awk '{sub(/^ */,"");sub(/ *$/,"")}1' | awk '{print $1}'`	

           NeibSSID=`echo "$NeibSSID" | tr -d '"'`	   
		   
		   NeibBSSID=$APBSSID
		   
		   echo -e "$currentTime\t$APSSID\t$APBSSID\t[BSSID conflict with:]\t$NeibSSID\t$NeibBSSID" > /proc/wifilog/collision/$LogOut
		fi
	done	
}

CollectBCM2G()
{
	RunCmd ifconfig -a

	RunCmd cat /var/wifi.txt | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN"
	
	RunCmd wl -i wl0 country

	RunCmd wl -i wl0 chanspec
	
	RunCmd wl -i wl0 curpower

	RunCmd wl -i wl0 frameburst
	
	RunCmd wl -i wl0 interference
	
	RunCmd wl -i wl0 dump rssi
	
	RunCmd wl -i wl0 phy_rssi_ant
	
	RunCmd wl -i wl0 counters
	
	RunCmd wl -i wl0 dump ampdu
	
	RunCmd wl -i wl0 wme_counters
	
	RunCmd wl -i wl0 pktq_stats
	
	RunCmd wl -i wl0 chanim_stats
	
	RunCmd wl -i wl0 phy_ed_thresh
	
	RunCmd wl -i wl0 nvram_dum
	
	RunCmd wl -i wl0 revinfo
	
	RunCmd wl -i wl0 cur_mcsset
	
	RunCmd wl -i wl0 wme_tx_params
	
	RunCmd wl -i wl0 chan_info
	
	RunCmd wl -i wl0 curpower
	
	bcm43217_devlist="wl0 wl0.1 wl0.2 wl0.3"
	
	for dev in $bcm43217_devlist
	do
		RunCmd wl -i $dev rate
		
		RunCmd wl -i $dev nrate
		
		RunCmd wl -i $dev mrate
		
		RunCmd wl -i $dev assoc
		
		RunCmd wl -i $dev assoclist
		
		RunCmd wl -i $dev interference_override
		
		RunCmd wl -i $dev wme_ac ap
		
		RunCmd wl -i $dev wme_ac sta
		
		stamac=`wl -i $dev assoclist`
		
		echo "wl -i $dev sta_info "
		
		if [ ! -n "$stamac" ]; then
			
			echo "NULL"
			
		else
		
			stamac=`echo $stamac | tr -d 'assoclist'`
			
			for sta in $stamac
			do
				wl -i $dev sta_info $sta
				
			done
	        fi 		
		BCMxxBssidConflictCheck 2G $dev
		
	done

	if [ `cat /proc/bus/pci/devices | cut -f 2 | wc -l` -eq 1 ];then
	
		RunCmd wl -i wl0.4 assoc
		
		RunCmd wl -i wl0.5 assoc
		
		RunCmd wl -i wl0.6 assoc
		
		RunCmd wl -i wl0.7 assoc
				
		RunCmd wl phyreg 0x283

		RunCmd wl phyreg 0x280

		RunCmd wl phyreg 0x289
		

	fi
	
	RunCmd cat /proc/wifilog/cmdout/2G
	
	BCM2G_WifiChip="2G"
	CollectWifiLog $BCM2G_WifiChip
	CollectPktInfo $bcm43217_devlist
}

CollectBCM5G()
{
	RunCmd cat /var/wifi.txt | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN"

	RunCmd wl -i wl1 country

	RunCmd wl -i wl1 chanspec
	
	RunCmd wl -i wl1 curpower

	RunCmd wl -i wl1 frameburst
	
	RunCmd wl -i wl1 interference
	
	RunCmd wl -i wl1 dump rssi
	
	RunCmd wl -i wl1 phy_rssi_ant
	
	RunCmd wl -i wl1 counters
	
	RunCmd wl -i wl1 dump ampdu
	
	RunCmd wl -i wl1 wme_counters
	
	RunCmd wl -i wl1 pktq_stats
	
	RunCmd wl -i wl1 chanim_stats
	
	RunCmd wl -i wl1 phy_ed_thresh
	
	RunCmd wl -i wl1 nvram_dum
	
	RunCmd wl -i wl1 revinfo
	
	RunCmd wl -i wl1 cur_mcsset
	
	RunCmd wl -i wl1 wme_tx_params
	
	RunCmd wl -i wl1 chan_info
	
	RunCmd wl -i wl1 curpower

	bcm4360_devlist="wl1 wl1.1 wl1.2 wl1.3"
	
	for dev in $bcm4360_devlist
	do
		RunCmd wl -i $dev rate
		
		RunCmd wl -i $dev nrate
		
		RunCmd wl -i $dev mrate
		
		RunCmd wl -i $dev assoc
		
		RunCmd wl -i $dev assoclist
		
		RunCmd wl -i $dev interference_override
		
		RunCmd wl -i $dev wme_ac ap
		
		RunCmd wl -i $dev wme_ac sta
		
		stamac=`wl -i $dev assoclist`
		
		echo "wl -i $dev sta_info "
		
		if [ ! -n "$stamac" ]; then
			
			echo "NULL"
			
		else
		
			stamac=`echo $stamac | tr -d 'assoclist'`
			
			for sta in $stamac
			do
				wl -i $dev sta_info $sta
				
			done
	        fi 
		BCMxxBssidConflictCheck 5G $dev
		
	done

	RunCmd cat /proc/wifilog/cmdout/5G
	
	BCM5G_WifiChip="5G"
	CollectWifiLog $BCM5G_WifiChip
	CollectPktInfo $bcm4360_devlist
}

ProtectDmesgExe()
{
	dmesg > /var/tmplog1.txt
	
	echo "QCA 5G BSSID Conflict Check:"
	cat /proc/wifilog/collision/5G
	RunCmd $*
	
    	dmesg > /var/tmplog2.txt
	
    	line=`cat /var/tmplog1.txt|wc -l`

    	awk -v va=$line 'NR > va {print i} {i=$0}' /var/tmplog2.txt
	
	rm /var/tmplog1.txt
	
	rm /var/tmplog2.txt
}

Collect()
{
	if [ $1 == 8192 ];then
		devlist="wlan0 wlan0-va0 wlan0-va1 wlan0-va2 wlan0-va3 wlan0-va4 wlan0-va5 wlan0-va6"
		wifichip="2G 2G_STA"
		dev="wlan0"
	else
		devlist="wlan1 wlan1-va0 wlan1-va1 wlan1-va2 wlan1-va3 wlan1-va4 wlan1-va5 wlan1-va6"
		wifichip="5G 5G_STA"
		dev="wlan1"
	fi
	
	RunCmd ifconfig -a

	# root ap info
	echo ""
	echo "[$dev.mib_rf]: "
	cat /proc/$dev/mib_rf
	
	echo "[wifi  log]: "
	cat /proc/wifilog/log
	
	# ssid info
	for dev in $devlist; do
		if [ -d /proc/$dev ]; then
			
			echo ""
			echo "[$dev.sta_info]: "
			cat /proc/$dev/sta_info
			
			echo ""
			echo "[$dev.mib_operation]: "
			cat /proc/$dev/mib_operation

			echo ""
			echo "[$dev.stats]: "
			cat /proc/$dev/stats
			
			echo ""
			echo "[$dev.mib_all]: "
			cat /proc/$dev/mib_all
		fi
	done

	CollectWifiLog $wifichip
	CollectPktInfo $devlist
}

QSRBssidConflictCheck()
{
    qsrbssidcheck.sh $1 > /var/qsrchecklog
	
	QSR_devlist="wifi0 wifi1 wifi2 wifi3"
	
	for dev in $QSR_devlist
	do
	    APSSID=`cat /var/qsrchecklog | grep "$dev::$dev"`
		
		if [ -n "$APSSID" ];then
		
			APSSID=`echo $APSSID | awk '{print $4}' | awk -F ":" '{print $2}'`
		
			APSSID=`echo "$APSSID" | tr -d '"'`
			
			APBSSID=`cat /var/qsrchecklog | grep "$dev::"`
			
			APBSSID=`echo "$APBSSID" | awk '{print $7}'`
			
			APBSSID="$(echo $APBSSID | tr '[:upper:]' '[:lower:]')"

			sed -i "/$dev/d" /var/qsrchecklog
			
			Conflict=`cat /var/qsrchecklog | grep $APBSSID`
			
			if [ -n "$Conflict" ];then
			
				NeibSSID=`echo "$Conflict" |  awk '{sub(/^ */,"");sub(/ *$/,"")}1' | awk '{print $1}'`	

				NeibSSID=`echo "$NeibSSID" | tr -d '"'`
				
				NeibBSSID=$APBSSID
				
				currentTime=`date "+%Y-%m-%d %H:%M:%S"`
				
				echo -e "$currentTime\t$APSSID\t$APBSSID\t[BSSID conflict with:]\t$NeibSSID\t$NeibBSSID" > /proc/wifilog/collision/5G
			fi	
		fi
	done
	
	rm -f /var/qsrchecklog
}

CollectQSR1000()
{
	#add route
	iptables -D OUTPUT_REJECT_VISIT_QTN -p tcp --dport 23 -d 192.168.$1.0/24 -j REJECT --reject-with icmp-net-unreachable
	echo "########$1"	
	(
	sleep 0.1
	echo 'root'
	sleep 0.1
	echo 'gather_info'
	sleep 65
	echo 'exit'
	) | telnet 192.168.$1.176
	
	#delete route
	iptables -A OUTPUT_REJECT_VISIT_QTN -p tcp --dport 23 -d 192.168.$1.0/24 -j REJECT --reject-with icmp-net-unreachable
	
	echo "QSR1000 is being finished!"
	echo "---------------------------------------"
	QSRBssidConflictCheck $1
	
	echo "QSR BSSID Conflict Check:"
	cat /proc/wifilog/collision/5G
}

CollectMars5v2()
{
	RunCmd iwpriv vap0 get_version
	RunCmd iwpriv Hisilicon0 get_chipid
	RunCmd iwpriv Hisilicon1 get_chipid
	RunCmd md5sum /etc/wap/FIRMWARE.bin
	RunCmd cat /proc/bus/pci/devices
	RunCmd ifconfig -a

	Mars_devlist="vap0 vap1 vap2 vap3 vap4 vap5 vap6 vap7 vap8 vap9"
	
	for dev in $Mars_devlist
	do
		ifconfig $dev | grep UP
		
		#$? mains the return state of last command
		if [ $? -eq 0 ]
		then					
			if [ $dev == vap0 ]
			then
				RunCmd iwpriv $dev getcountry				
				RunCmd iwpriv $dev get_channel				
				RunCmd iwpriv $dev get_mode				
				RunCmd iwpriv $dev get_txpower
				RunCmd iwpriv $dev get_rate_list
				RunCmd iwpriv $dev get_vap_cap
				RunCmd iwpriv $dev get_chan_list
				RunCmd iwpriv $dev get_pwr_ref
				if [ $1 == Hisi1151 ];then
					RunCmd hipriv.sh \"vap0 set_tx_pow show_log\"
					RunCmd cat /tmp/hal_pow_log.txt
				else
					RunCmd iwpriv $dev get_current_pwr
				fi
						
			fi

			if [ $dev == vap4 ];then
				
				RunCmd iwpriv $dev getcountry				
				RunCmd iwpriv $dev get_channel				
				RunCmd iwpriv $dev get_mode
				RunCmd iwpriv $dev get_txpower
				RunCmd iwpriv $dev get_rate_list
				RunCmd iwpriv $dev get_chan_list
				RunCmd iwpriv $dev get_pwr_ref
				if [ $1 == Hisi1151 ];then
					RunCmd hipriv.sh \"vap4 set_tx_pow show_log\"
					RunCmd cat /tmp/hal_pow_log.txt
				else
					RunCmd iwpriv $dev get_current_pwr
				fi
				
			fi
						
			RunCmd ifconfig $dev
			
			RunCmd iwpriv $dev get_essid			
			RunCmd iwpriv $dev get_shortgi
			RunCmd iwpriv $dev get_ssidhide
			RunCmd iwpriv $dev get_wmmswitch
			RunCmd iwpriv $dev get_usernum
			RunCmd iwpriv $dev get_uapsden
			RunCmd iwpriv $dev get_txbeamform
			RunCmd iwpriv $dev get_noforward
			RunCmd iwpriv $dev get_bintval
			RunCmd iwpriv $dev get_dtim_period
			RunCmd iwpriv $dev get_rts_th
			RunCmd iwpriv $dev get_frag_th
			RunCmd iwpriv $dev get_pmf
			RunCmd iwpriv $dev get_amsdu_on
			RunCmd iwpriv $dev get_ampdu_on
			RunCmd iwpriv $dev get_bcast_rate

			RunCmd hipriv.sh "$dev info"
			
			RunCmd cat /var/hostapd-$dev.conf | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
			RunCmd cat /tmp/hostapd_$dev.log
		fi
	done
	
	RunCmd cat /var/wpa_supplicant.conf
	RunCmd cat /var/wpa_supplicant-vap8.conf
	RunCmd cat /var/wpa_supplicant-vap9.conf
	RunCmd cat /tmp/up8.log
	RunCmd cat /tmp/up9.log
	RunCmd cat /proc/psta/rep
	RunCmd cat /tmp/vamp.log
	RunCmd cat /var/app_witp.conf
	echo "Collect modules_5v2.log"
	cat /mnt/jffs2/modules_5v2.log
	
	MARS_WifiChip="2G 5G 2G_STA 5G_STA"
	CollectWifiLog $MARS_WifiChip
	CollectPktInfoMars $Mars_devlist
}

CollectCeleno()
{
	RunCmd export PATH=$PATH:/usr/lib/cl2400_host_pkg/cl2400/bin
	RunCmd iw dev
	RunCmd ifconfig -a
	
	Celeno_devlist="wlan0_0 wlan0_1 wlan0_2 wlan0_3 wlan1_0 wlan1_1 wlan1_2 wlan1_3"
	
	for dev in $Celeno_devlist
	do
		ifconfig $dev | grep UP
		
		#$? mains the return state of last command
		if [ $? -eq 0 ]
		then					
			if [ $dev == wlan0_0 ]
			then
				RunCmd ifconfig $dev
				RunCmd cat /tmp/hostapd-wlan0_0.conf | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd cat /tmp/hostapd-wlan0_0.log | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd cat /var/CL2400_24g/CL2400.dat | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd iw $dev e2p get table
				RunCmd iw $dev cecli pwrdbg
			fi

			if [ $dev == wlan1_0 ];then
				
				RunCmd ifconfig $dev
				RunCmd cat /tmp/hostapd-wlan1_0.conf | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd cat /tmp/hostapd-wlan1_0.log | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd cat /var/cl2400/CL2400.dat | grep -v psk | grep -v key | grep -v "_pin=" | grep -v "PIN" | grep -v "passphrase" | grep -v "secret" | grep -v "uuid"
				RunCmd iw $dev e2p get table
				RunCmd iw $dev cecli pwrdbg
			fi
						
		fi
	done
	
	
	Celeno_WifiChip="2G 5G 2G_STA 5G_STA"
	CollectWifiLog $Celeno_WifiChip
	CollectPktInfoMars $Celeno_devlist
}

ScanHisiAlg()
{
	iwpriv vap0 alg "spectral_scan_en 1"
	sleep 0.2
	iwpriv vap0 alg "get_interf_type"
	sleep 0.2
	iwpriv vap4 alg "spectral_scan_en 1"
	sleep 0.2
	iwpriv vap4 alg "get_interf_type"
}

# exe script according to wifi chip type
ExeCollectCmd()
{
	# $1 = wifi_id

	case $1 in
	
	#ralink
	18143091 | 18145390 | 18145392 )
		CollectRT5392
		;;
		
	#mt7603
	14c37603 )
		CollectMT7603
		;;
		
	#mt7612
	14c37662 )
		CollectMT7612
		;;
	
	#mt7615
	14c37615 )
		CollectMT7615
		;;
		
	#bcm43217
	14e443a9 | 14e4a8db )
		CollectBCM2G
		;;

	#bcm4331
	14e44331 )
		CollectBCM2G
		;;

	#bcm4360
	14e44360 )
		CollectBCM5G
		;;
		
#AR9381/QCA9880/QCA9984/QCA9024
	168c0030 | 168c003c | 168c0046 | 17cb1104)
		CollectQCA
		;;
		
	#8192
	10ec818b | 10ec818c)
		Collect "8192"
		;;

	#8812
	10ecf812 )
		Collect "8812"
		;;

	#QSR1000 
	1bb50008 )
		#get host0 third part IP 
		ChangeIP=`ifconfig host0 | grep inet |grep -v inet6 | tr -s ' ' | cut -d '.' -f 3`
		echo "${ChangeIP}"

		CollectQSR1000 ${ChangeIP}
		;;
	
	#mars_5v2
	19e51151 )
		if [ 0 -eq $marstmp ]
		then  
			CollectMars5v2 "Hisi1151"
			marstmp=1
		fi
		;;
	
	59e70001 )
		if [ 0 -eq $marstmp ]
		then  
			CollectMars5v2 "Hisi1151"
			marstmp=1
		fi
		;;
	
	#1152
	19e51152 )
		if [ 0 -eq $marstmp ]
		then  
			CollectMars5v2 "Hisi1152"
			ScanHisiAlg
			marstmp=1
		fi
		;;
	
	#1152
	59e70002 )
		if [ 0 -eq $marstmp ]
		then  
			CollectMars5v2 "Hisi1152"
			ScanHisiAlg
			marstmp=1
		fi
		;;
	
	#celeno
	1d692440 | 1d692442)
		CollectCeleno
		;;
		
	* )
		;;
	esac

}

marstmp=0

# read pci device id
cat /proc/bus/pci/devices | cut -f 2 | while read dev_id;
do
	if [ "$dev_id" != "" ]; then
	echo "pci device id:$dev_id"
	ExeCollectCmd $dev_id
	fi
done


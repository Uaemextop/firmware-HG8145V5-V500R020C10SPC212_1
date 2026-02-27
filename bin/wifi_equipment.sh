#! /bin/sh

set +x

#wifi chip num 
slot_num=0

# wifi_equipment 使用方法
PrintOutUsage()
{
    echo "Usage:"
    echo "wifi_equipment.sh init chip {1|2|3(2.4G/5G/5G_HIGHBAND)}"
    echo "wifi_equipment.sh config chip {1|2|3(2.4G/5G/5G_HIGHBAND)} direction {tx|rx}  mode {11a | 11b | 11g | 11na | 11ng | 11ac} bw [20|40|80] ch {chValue} rate{ {1|2|... } | mcs {0~11}} ant {antValue} "
    echo "wifi_equipment.sh config chip {1|2|3(2.4G/5G/5G_HIGHBAND)} direction {tx|rx} switch {start|stop} "
    echo "wifi_equipment.sh test_power chip {1|2|3(2.4G/5G/5G_HIGHBAND)} direction {tx|rx} "
    echo "wifi_equipment.sh get_txpower chip {1|2|3(2.4G/5G/5G_HIGHBAND)} para {1|2|3} "
    echo "Example:"
    echo "./wifi_equipment.sh init chip 1"
    echo "./wifi_equipment.sh config chip 2 direction rx switch stop"
    echo "./wifi_equipment.sh config chip 1 direction tx mode 11b bw 20 ch 1 rate 1 ant 1"
    echo "./wifi_equipment.sh test_power chip 1 direction tx"
    echo "./wifi_equipment.sh get_txpower chip 1 para 1"
    
    exit 255 
}

#================================================================
# 各芯片公用函数

#Notice: 这个函数无法传递引号参数
RunCmd()
{
    echo "$* "
    $*
}

iwprivWrapper()
{
    echo "iwpriv " $*
    
    iwpriv $*  > /tmp/null_log
    returnCodeStr=$?
    
    if [ "$returnCodeStr"x != "0"x ]; then
        sucStr="fail!($returnCodeStr)"
    fi
}

HiPrivWrapper()
{
    echo hipriv.sh \"$*\"
    hipriv.sh "$*"  
}

#=================================================================
# HISI Mars5V2 芯片命令适配

wifi_chip_init_Mars5V2_2G()
{   
    hostapd_pids=`pidof hostapd`
	if [ "$hostapd_pids" != "" ];
	then
		RunCmd kill -15 $hostapd_pids
		RunCmd sleep 0.3
	fi
    HiPrivWrapper "Hisilicon0 start_priv 1"
    HiPrivWrapper 'vap0 2040bss_enable 0'
    HiPrivWrapper 'vap0 acs sw 0'
    HiPrivWrapper 'vap0 radartool enable 0'
    HiPrivWrapper 'vap0 alg_cfg anti_inf_imm_en 0'
    HiPrivWrapper 'vap0 alg_cfg anti_inf_unlock_en 0'
    RunCmd ifconfig vap0 down
    iwprivWrapper vap0 setcountry 99
    iwprivWrapper vap0 mode 11ng20
    iwprivWrapper vap0 channel 1
    iwprivWrapper vap0 dtim_period 3
    iwprivWrapper vap0 bintval 100
    HiPrivWrapper "vap0 essid HS8145V_HW_TEST_2G"
    RunCmd ifconfig vap0 hw ether 00:e0:52:22:22:14
    RunCmd ifconfig vap0 up
    HiPrivWrapper "vap0 dync_txpower_dbg 1"
    iwprivWrapper vap0 set_eqmode 1
}

wifi_chip_init_Mars5V2_5G()
{
    hostapd_pids=`pidof hostapd`
	if [ "$hostapd_pids" != "" ];
	then
		RunCmd kill -15 $hostapd_pids
		RunCmd sleep 0.3
	fi
	HiPrivWrapper "Hisilicon1 start_priv 1"
	HiPrivWrapper 'vap4 2040bss_enable 0'
	HiPrivWrapper 'vap4 acs sw 0'
	HiPrivWrapper 'vap4 radartool dfsenable 0'
	HiPrivWrapper 'vap4 radartool cacenable 0'
	HiPrivWrapper 'vap4 alg_cfg anti_inf_imm_en 0'
	HiPrivWrapper 'vap4 alg_cfg anti_inf_unlock_en 0'
	RunCmd ifconfig vap4 down
	iwprivWrapper vap4 setcountry 99
	iwprivWrapper vap4 mode 11na20
	iwprivWrapper vap4 channel 36
	iwprivWrapper vap4 dtim_period 3                
	iwprivWrapper vap4 bintval 100 
	HiPrivWrapper 'vap4 essid HS8145V_HW_TEST_5G'
	RunCmd ifconfig vap4 hw ether 00:e0:52:22:22:14
	RunCmd ifconfig vap4 up
	HiPrivWrapper "vap4 dync_txpower_dbg 1"
	iwprivWrapper vap4 set_eqmode 1
}

#传递参数 $* 为 "vap0 direction tx mode 11b bw 20 ch 1 rate 1 ant 1" 
wifi_chip_config_Mars5V2()
{
	vapStr=$1
	modeStrArg=$5
	modeStr=$5
	bwStr=${7}
	freqStr=${9}
	directionArg=$3
	directionChStr="txch"
	rateStr="rate"
	rateValueStr=${11}
	ant=${13}
	chMaskStr="0001"

	if [ "$directionArg"x != "tx"x ];then
    	directionChStr="rxch"
	fi

	if [ "$modeStrArg"x != "11a"x ] && [ "$modeStrArg"x != "11b"x ] && [ "$modeStrArg"x != "11g"x ];then
    	modeStr="$modeStr${bwStr}"
	fi

	if [ "$modeStrArg"x = "11ng"x ] || [ "$modeStrArg"x = "11na"x ]; then
    	rateStr="mcs"
	fi

	if [ "$modeStrArg"x = "11ac"x ]; then
    	rateStr="mcsac"
	fi

	if [ ${ant} != 0x1 ] && [ ${ant} != 1 ] && [ ${ant} != 0x01 ]; then
    	chMaskStr="0010"
	fi

	iwprivWrapper $vapStr mode $modeStr
	iwprivWrapper $vapStr bw $bwStr
	iwprivWrapper $vapStr freq $freqStr              
	iwprivWrapper $vapStr $rateStr $rateValueStr
	iwprivWrapper $vapStr $directionChStr $chMaskStr   
}

#./wifiequipment.sh config chip 1 direction tx mode 11b bw 20 ch 1 rate 1 ant 1
wifi_chip_config_Mars5V2_2G()
{    
    wifi_chip_config_Mars5V2 "vap0" $*  
}

wifi_chip_config_Mars5V2_5G()
{
    wifi_chip_config_Mars5V2 "vap4" $*
}

#$* ->  "vap0 direction tx switch start"
wifi_chip_action_Mars5V2()
{
    vapStr=$1
    direction=$3
    switch=$5
	directionStr="al_tx"
	startStr="1"

	if [ "$direction"x != "tx"x ];then
    	directionStr="al_rx"
	fi
	if [ "$switch"x != "start"x ];then
    	startStr="0"
	fi

	iwprivWrapper $vapStr $directionStr $startStr 
}

#./wifiequipment.sh config chip 1 direction tx switch start
wifi_chip_action_Mars5V2_2G()
{    
    wifi_chip_action_Mars5V2 "vap0" $*
}

wifi_chip_action_Mars5V2_5G()
{
    wifi_chip_action_Mars5V2 "vap4" $*
}

wifi_chip_test_power_Mars5V2_2G()
{
	iwprivWrapper vap0 mode 11g
	iwprivWrapper vap0 bw 20
	iwprivWrapper vap0 freq 3
	iwprivWrapper vap0 rate 6
	iwprivWrapper vap0 txch 0001
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
	iwprivWrapper vap0 freq 8
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
	iwprivWrapper vap0 freq 12
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
	iwprivWrapper vap0 txch 0010
	iwprivWrapper vap0 freq 3
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
	iwprivWrapper vap0 freq 8
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
	iwprivWrapper vap0 freq 12
	iwprivWrapper vap0 al_tx 1
	usleep 40000
	iwprivWrapper vap0 al_tx 0
}

# hisi test power 只对vap0有效
wifi_chip_test_power_Mars5V2_5G()
{
    wifi_chip_test_power_Mars5V2_2G $*
}

# ./wifi_equipment.sh get_txpower chip 1 para 1
wifi_chip_get_txpower_Mars5V2_2G()
{
	#传递参数$* 为"para 1" 
    para=$2
	
	if [ "$para" = "1" ];then
		cat /var/dync_cali_txpower | grep 2g | cut -d '=' -f 2 | cut -d ',' -f 1
	elif [ "$para" = "3" ];then
		cat /var/dync_cali_txpower | grep 2g | cut -d '=' -f 2
	fi
}

# ./wifi_equipment.sh get_txpower chip 2 para 1
wifi_chip_get_txpower_Mars5V2_5G()
{
    #传递参数$* 为"para 1" 
    para=$2
    
	if [ "$para" = "1" ];then
		cat /var/dync_cali_txpower | grep 5g | cut -d '=' -f 2 | cut -d ',' -f 1
	elif [ "$para" = "3" ];then
		cat /var/dync_cali_txpower | grep 5g | cut -d '=' -f 2
	fi
}

#=================================================================
# 高通 QCA 芯片命令适配

bin_tx99tool()
{
    /bin/tx99tool_bin $@
    echo "tx99tool_bin $@"
    result=$?
      if [ "$result" != "0" ];then
        echo "ERROR::input para is not right!"
        
        exit 1
      fi 
}

bin_athtestcmd()
{
    echo "athtestcmd $@"
    /bin/athtestcmd $@	    
    result=$?
    if [ "$result" != "0" ];then
        sucStr="fail!($result)"
    fi 
}

wifi_chip_init_AR9381_2G()
{
    echo "9381 init"
}

wifi_chip_init_QCA9984_2G()
{
	echo "9984 2G init"
}

wifi_chip_init_QCA_5G()
{
    echo "9984 init"
}

wifi_chip_init_QCA_5G_HIGHBAND()
{
    echo "9984 init"
}

#./wifiequipment.sh config chip 1 direction tx mode 11b bw 20 ch 1 rate 1 ant 1
wifi_chip_config_AR9381_2G()
{
	vapStr="wifi1"
	modeStr=$4
	modeInt=6
	bwStr=$6
	bwInt=0
	htextInt=0
	freInt=${8}
	rateValue=${10}
	antValue=${12}

	if [ 3 == $slot_num ];then
	    vapStr="wifi2"
	fi

	case "$modeStr" in
		11b )
		modeInt=1
		;;
		11g )
		modeInt=2
		;;
		11n )
		modeInt=6
		;;
		* )
		modeInt=6
		echo "Default 11n ht20"
		;;
	esac

	#ht40 ch1~6 phymode 11ng40+(9), ch7~13 phymode 11ng40-(10) 
	if [ ${bwStr} == 40 ];then
	    bwInt=2
		if [ ${freInt} -le 6 ];then
    		htextInt=1
    		modeInt=9
		else 
    		htextInt=2
    		modeInt=10
		fi
	fi

	#rate set MCS0~7, 11b:11M, 11g:54M
	if [ ${bwStr} == 20 ];then
		case ${rateValue} in
			0 | 1 | 2 | 3 )
			rateValue=`expr ${rateValue} + 1`
			rateValue=`expr $rateValue \* 6500`
			;;
			4 )
			rateValue=39000
			;;
			5 )
			rateValue=52000
			;;
			6 )
			rateValue=58500
			;;
			7 )
			rateValue=65000
			;;
			11 )
			rateValue=11000
			;;
			54 )
			rateValue=54000
			;;
			* )
			rateValue=${rateValue}
			echo "Set Rate ${rateValue}"
			;;
		esac
	else
		case ${rateValue} in
			0 | 1 | 2 | 3 )
			rateValue=`expr ${rateValue} + 1`
			rateValue=`expr $rateValue \* 13500`
			;;
			4 )
			rateValue=81000
			;;
			5 )
			rateValue=108000
			;;
			6 )
			rateValue=121500
			;;
			7 )
			rateValue=135000
			;;  
			* )
			rateValue=${rateValue}
			echo "Set Rate ${rateValue}"
			;;
		esac
	fi
		
	bin_tx99tool $vapStr set txmode $modeInt
	bin_tx99tool $vapStr set freq $freInt bandwidth $bwInt htext $htextInt       
	bin_tx99tool $vapStr set rate $rateValue
	bin_tx99tool $vapStr set txchain $antValue  
	bin_tx99tool $vapStr start  
}

wifi_chip_config_QCA9984_2G()
{	
	directionVal=$2 
	modeVal=$4
	bwVal=$6 
	chVal=$8 
	rateVal=$10 
	antVal=$12 	
		
	case "$modeVal" in
		11b )
		modeInt=0
		;;
		11g )
		modeInt=1
		;;
		11n )
		modeInt=2
		;;
		* )
		modeInt=2
		echo "Default 11n"
		;;
	esac
	
	#mode 11b:0, 11g:1, 11n:2
	if [ 20 == ${bwVal} ];then
		case $modeInt in
			0 )
			ModeSetVal="ht20"
			rateVal=3
			;;
			1 )
			ModeSetVal="ht20"
			rateVal=11
			;;
			2 )
			ModeSetVal="ht20"
			rateVal=`expr $rateVal + 12`	
			;;
		esac
	elif [ 40 == ${bwVal} ];then
		case $modeInt in
			0 )
			echo "11b not support HT40"
			exit 1 
			;;
			1 )
			echo "11g not support HT40"
			exit 1
			;;
			2 )
			ModeSetVal="ht40minus"
			rateVal=`expr $rateVal + 36`	
			;;
		esac
	else
		echo "bw not support"
		exit 1
	fi
		
	bin_athtestcmd --$directionVal tx99 --interface wifi1 --txfreq $chVal --txchain $antVal --txrate $rateVal --mode $ModeSetVal
}

#./wifiequipment.sh config chip 2 direction tx mode 11b bw 20 ch 1 rate 1 ant 1
wifi_chip_config_QCA()
{
	vapStr=$1
	txArg=$3
	modeArg=$5
	modeInt=0
	ModeStr="vht80_0"
	bwArg=$7
	bwInt=${8}
	bwDir=0
	Channel=${9}
	rateInput=${11}
	AntChoose=${13}
	RateValue=$rateInput

	#mode 11a:0, 11n:1 11ac:2
	case "$modeArg" in
		11a )
		modeInt=0
		;;
		11n )
		modeInt=1
		;;
		11ac )
		modeInt=2
		;;
		* )
		modeInt=2
		echo "Default 11ac"
		;;
	esac

	#ch36、44、52、60、100、108、116、124、132、140、149、157 Direction Plus
	#ch40、48、56、64、104、112、120、128、136、144、153、161 Direction Minus
	case ${Channel} in
		36 | 44 | 52 | 60 | 100 | 108 | 116 | 124 | 132 | 140 | 149 | 157 )
		bwDir=0
		;;
		* )
		bwDir=1
	esac

	#txmode: ht20、vht20、ht40plus、ht40minus、vht40plus、vht40minus、vht80_0、vht80_1、vht80_2、vht80_3
	if [ 20 == ${bwArg} ];then
		case $modeInt in
			0 )
			ModeStr="ht20"
			RateValue=11
			;;
			1 )
			ModeStr="ht20"
			RateValue=`expr $rateInput + 12`
			;;
			2 )
			ModeStr="vht20"
			RateValue=`expr $rateInput + 60`
			;;
			* )
			ModeStr="vht20"
			RateValue=$rateInput
			echo "Default vht20"
			;;
		esac
	elif [ 40 == ${bwArg} ];then
		if [ 1 == $modeInt ];then
			case $bwDir in
			0 )
			ModeStr="ht40plus"
			;;
			1 )
			ModeStr="ht40minus"
			;;
			* )
			echo "Wrong bandwidth"
			;;
			esac
			RateValue=`expr $rateInput + 36`
		else
			case $bwDir in
			0 )
			ModeStr="vht40plus"
			;;
			1 )
			ModeStr="vht40minus"
			;;
			* )
			echo "Wrong vht40 channel"
			;;
			esac
			RateValue=`expr $rateInput + 90`        
		fi  
	else
		case ${Channel} in
			36 | 52 | 100 | 116 | 132 | 149 )
			ModeStr="vht80_0"
			;;
			40 | 56 | 104 | 120 | 136 | 153 )
			ModeStr="vht80_1"
			;;
			44 | 60 | 108 | 124 | 140 | 157 )
			ModeStr="vht80_2"
			;;
			48 | 64 | 112 | 128 | 144 | 161 )
			ModeStr="vht80_3"
			;;
			* )
			echo "Wrong vht80 channel"
			esac
			RateValue=`expr $rateInput + 120`       
	fi

	bin_athtestcmd --$txArg tx99 --interface $vapStr --txfreq $Channel --txchain $AntChoose --txrate $RateValue --mode $ModeStr
}

wifi_chip_config_QCA_5G()
{
    wifi_chip_config_QCA "wifi0" $*
}

wifi_chip_config_QCA_5G_HIGHBAND()
{
    wifi_chip_config_QCA "wifi1" $*
}

#./wifiequipment.sh config chip 1 direction tx switch start
wifi_chip_action_AR9381_2G()
{
	vapStr="wifi1"
	startStr=$4
	
	if [ $slot_num == 3 ];then
		vapStr="wifi2"
	fi

	if [ "$startStr"x != "start"x ];then
    	bin_tx99tool $vapStr $startStr  
	fi
}

wifi_chip_action_QCA9984_2G()
{	
	vapStr="wifi1"
	direction=$2
	switch=$4

	if [ "$switch"x != "start"x ];then
		bin_athtestcmd --interface $vapStr --$direction off 
	fi	
}

wifi_chip_action_QCA_5G()
{
	vapStr="wifi0"
	direction=$2
	switch=$4

	if [ "$switch"x != "start"x ];then
		bin_athtestcmd --interface $vapStr --$direction off 
	fi
}

wifi_chip_action_QCA_5G_HIGHBAND()
{
	vapStr="wifi0"
	direction=$2
	switch=$4
	
	if [  $slot_num == 3 ];then
		vapStr="wifi1"
	fi

	if [ "$switch"x != "start"x ];then
		bin_athtestcmd --interface $vapStr --$direction off 
	fi
}

wifi_chip_get_txpower_AR9381_2G()
{
    echo "Qca not implmented get txpower"
}

wifi_chip_get_txpower_QCA9984_2G()
{
	echo "Qca not implmented get txpower"
}

wifi_chip_get_txpower_QCA_5G()
{
    echo "Qca not implmented get txpower"
}

wifi_chip_test_power_AR9381_2G()
{
    echo "Qca not implmented test power"
}

wifi_chip_test_power_QCA9984_2G()
{
    echo "Qca not implmented test power"
}

wifi_chip_test_power_QCA_5G()
{
    echo "Qca not implmented test power"
}

#===================================================

#wifi_equipment 命令框架
wifi_equip_do_cmd()
{
    cmd_func_str=$1
    chip_type=$2
    chip_band=$3
    
    shift 3   
    args=$*

    cmd_func="${cmd_func_str}_${chip_type}_${chip_band}"    
    
    if [ "$(type -t $cmd_func)" != "function"  -a "$(type -t $cmd_func)" != "$cmd_func" ] ; then
        echo "$cmd_func : Not support!"
        exit 255
    fi

    $cmd_func $args
  
    echo "success!"
}

#=========================================================

wifi_equipment_get_band_type()
{
    band=$1    
    chip_band=""   
    
    case $band in 
       1)
       chip_band="2G"
       ;;
    
       2)
       chip_band="5G"
       ;;
       
       3)
       chip_band="5G_HIGHBAND"
       ;;                          
    esac
    
    echo $chip_band
}

# $* ->  index  $arry_str
array_elment_get()
{
    index=$1
    shift 1
    echo ${!index} 
}

wifi_equipment_get_chip_type()
{
    band_arg=$1
    wifi_dev_list=""
    wifi_dev_num=0
    band_2g="NON"
    band_5g="NON"
    band_5g_high="NON"
    qca9984_cnt=0
        
    wifi_dev_list=`cat /proc/bus/pci/devices | cut -f 2`    
    
    for dev_id in $wifi_dev_list;
    do               
        case $dev_id in		
    	#AR9381
    	12d82304 | 168c0030 )
    		band_2g="AR9381"
    		;;
    		
    	#AR9984
    	168c0046 | 168c003c )    		
    		#三频
    		if [ "$band_5g" != "NON" ]; then
    		    band_5g_high="QCA"
    		fi    		
    		band_5g="QCA"
		if [ "$dev_id" = "168c0046" ]; then
			qca9984_cnt=$(($qca9984_cnt+1))
		fi 
    		;;    
    	#mars_5v2
    	19e51151 )
    		if [ "$band_2g" = "Mars5V2" ];then
    		    band_5g="Mars5V2"   #1151 双频
    		fi
    		band_2g="Mars5V2"    
    		;;
    	#hisi_wifi5
    	59e70001 )
    		if [ "$band_2g" = "Mars5V2" ];then
    		    band_5g="Mars5V2"   #1151 双频
    		fi
    		band_2g="Mars5V2"    
    		;;
    	#celeno
        1d692440 | 1d692400 )
            if [ "$dev_id" = "1d692440" ];then
                band_5g="cl2440"
            fi
			
			if [ "$dev_id" = "1d692400" ];then
                band_2g="cl2400"
            fi
            ;;
    	* )
    	   echo "$dev_id unknow!"
    	   exit 255
    	esac	            
    done  
		
    #QCA9984(2G)+QCA9984(5G)
    pcie_num=$(awk '$2 == "168c0030" || $2 == "168cabcd" || $2 == "168c003c" || $2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)
    if [ "$band_2g" = "NON" -a "$band_5g" = "QCA" -a $qca9984_cnt == 2 -a $pcie_num == 2 ]; then
        band_2g="QCA9984"
    fi

    #Just For 1151 Single 5G
    if [ "$band_arg" = "2" -a "$band_2g" = "Mars5V2" -a "$band_5g" = "NON" ]; then
        band_5g="Mars5V2"
        band_2g="NON"
    fi
    
    if [ "$band_arg" = "1" ];then
        echo "$band_2g" 
    elif [ "$band_arg" = "2" ];then 
        echo "$band_5g"  
    elif [ "$band_arg" = "3" ];then 
        echo "$band_5g_high"       
    else
        echo "NON"  
    fi      
}

#装备测试主函数
wifi_equipment_main()
{
    subcmd=$1
    chip_name=""
    chip_band=""
    chip_type="Mars5V2"
    band_arg="1"
               
    #跳过 subcmd 和 chip 参数
    shift 2    
    band_arg=$1
    
    #获取命令操作频段
    chip_band=$(wifi_equipment_get_band_type $band_arg)
    chip_type=$(wifi_equipment_get_chip_type $band_arg)
    
    
    #跳过 band 参数
    shift  
    args=$* 
    args_num=$#
    
    slot_num=$(awk '$2 == "168c0030" || $2 == "168cabcd" || $2 == "168c003c" || $2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)   
     
    
    case $subcmd in
	 "init")
	    wifi_equip_do_cmd "wifi_chip_init"  $chip_type $chip_band $args
		;;    	

	 "config")
	    if [ "$#" = "12" ];then 
    		wifi_equip_do_cmd "wifi_chip_config" $chip_type $chip_band $args
		elif [ "$#" = "4" ];then
    		wifi_equip_do_cmd "wifi_chip_action" $chip_type $chip_band $args     
        else
            PrintOutUsage
        fi		
		;;
		
	 "test_power")
		wifi_equip_do_cmd "wifi_chip_test_power" $chip_type $chip_band $args
		;;  
		  		
 	 "get_txpower")
		wifi_equip_do_cmd "wifi_chip_get_txpower" $chip_type $chip_band $args
		;;    
		
	  "help")
	  	PrintOutUsage
	  	;;
	  	 		   		
	  * )
	     echo "unknown command $subcmd"
	     PrintOutUsage
		;;
	esac    
}

# 脚本执行入口
wifi_equipment_main $*


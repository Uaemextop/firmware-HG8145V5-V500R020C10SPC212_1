#!/bin/sh
set +x
calblocknum=`cat /proc/mtd|grep wifi_paramA|cut -d":" -f1|cut -d"d" -f2`
if [ -z $calblocknum ]; then
	echo "wifi cal mtdblock no found !!" 
	exit
fi
echo "calblocknum: $calblocknum"

chip_num=0
slot_9381=0
slot_9984=0
slot_2G=0
slot_5G=1
slot_5G_low=0
slot_5G_high=1
chip_9984_2G=0

cd /mnt/jffs2/equipment/QCA
chmod +x nart.out
chmod +x Qcmbr

# $* ->  index  $arry_str
function array_elment_get()
{
    shift $1
    echo  $1
}

wifi_dev_list=`awk '$2 == "168c0030" || $2 == "168cabcd" || $2 == "168c003c" || $2 == "168c0046" || $2 == "19e51151" || $2 == "59e70001" {print $2}' < /proc/bus/pci/devices`
echo  $wifi_dev_list
dev1=$(array_elment_get 1 $wifi_dev_list)
dev2=$(array_elment_get 2 $wifi_dev_list)
dev3=$(array_elment_get 3 $wifi_dev_list)

#获取芯片个数
chip_num=$(awk '$2 == "168c0030" || $2 == "168cabcd" || $2 == "168c003c" || $2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)
echo "chip_num $chip_num"

#slot_9381：获取9381芯片所在行
slot_9381=$(awk '$2 == "168c0030" || $2 == "168cabcd" || $2 == "168c003c" || $2 == "168c0046" {print $2}' < /proc/bus/pci/devices | grep -En '168c0030|168cabcd' | cut -d ":" -f 1)
let slot_9381--
echo "slot_9381 $slot_9381"
slot_9984=$(awk '$2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)
echo "slot_9984 $slot_9984"

#打开wifi校准区写权限
chipdebug wifi debug openmtd

if [ $chip_num == 2 ];then	
	#9984_2G+9984_5G场景
	if [ $slot_9984 == 2 ];then
		slot_5G=0 
		slot_2G=1
		chip_9984_2G=1
	elif [ $slot_9381 == 0 ];then
		slot_2G=0
		slot_5G=1
	else
		slot_2G=1
		slot_5G=0	
	fi

	if [ "$1" = "1" ]; then
		echo "erase cali data"
		if [ "$2" = "2G" ]; then
			#2G 从0开始到16384 清除（=512*32）
			chipdebug wifi debug cleanmtd band b
		elif [ "$2" = "5G" ]; then
			#5G 从16384开始 清除（=512*32）
			chipdebug wifi debug cleanmtd band a
		else
			chipdebug wifi debug cleanmtd band a
			chipdebug wifi debug cleanmtd band b
		fi
	fi
	
	echo "slot_2G $slot_2G"
	echo "slot_5G $slot_5G"
elif [ $chip_num == 3 ];then
	if [ $slot_9381 == 0 ];then
		slot_2G=0
		slot_5G_low=1
		slot_5G_high=2
	elif [ $slot_9381 == 1 ];then
		slot_2G=1
		slot_5G_low=0
		slot_5G_high=2
	elif [ $slot_9381 == 2 ];then
		slot_2G=2
		slot_5G_low=0
		slot_5G_high=1
	else
		slot_2G=2
		slot_5G_low=0
		slot_5G_high=1
	fi

	if [ "$1" = "1" ]; then
		echo "erase cali data"
		if [ "$2" = "2G" ]; then
			chipdebug wifi debug cleanmtd band b
		elif [ "$2" = "5G" ]; then
			chipdebug wifi debug cleanmtd band a
		else
			chipdebug wifi debug cleanmtd band b
			chipdebug wifi debug cleanmtd band a
		fi
	fi
	
	echo "slot_2G $slot_2G"
	echo "slot_5G_low $slot_5G_low"
	echo "slot_5G_high $slot_5G_high"
else
	# HG8245W5 (2.4G hisi 1151, 5G QCA 9984)
	if [ "$dev1" = "168c0046" -a "$dev2" = "19e51151" ] || [ "$dev1" = "168c0046" -a "$dev2" = "59e70001" ];then
		# QCAbegintest 1 5G 或者QCAbegintest 1 才擦除；排除掉QCAbegintest 1 2G场景
		if [ "$1" = "1" -a "$2" = "5G" -o "$1" = "1" -a $# == 1 ]; then
			echo "erase cali data 0x4000"
			chipdebug wifi debug cleanmtd band a
		fi
		
		slot_5G=1
	elif [ "$dev1" = "19e51151" -a "$dev2" = "168c0046" ] || [ "$dev1" = "59e70001" -a "$dev2" = "168c0046" ];then
		if [ "$1" = "1" -a "$2" = "5G" -o "$1" = "1" -a $# == 1 ]; then
			echo "erase cali data 0x4000"
			chipdebug wifi debug cleanmtd band a
		fi
		
		slot_5G=0
	else
		echo "Not support"
	fi

	echo "slot_5G $slot_5G"
	
	#异构芯片场景置2，kill 2G进程的时候不做处理
	chip_9984_2G=2
	# chipnum +1，把海思2G芯片算进去
	let chip_num++
fi	

function KillProcessFor2G() {
	echo "KillProcessFor2G: $1"
	#9984_2G 对应pcie 1
	if [ $1 == 1 ]; then
		Qcmbr_id=$( ps | grep Qcmbr |grep "pcie 1"| grep -v "grep" | awk ' {if(NR==1)print $1}')
		echo "Qcmbr_id $Qcmbr_id"
		if [ "$Qcmbr_id" != "" ] 
		then
			kill -9 $Qcmbr_id
		fi
	elif [ $1 == 0 ]; then
		nart_id=$( ps | grep nart.out | grep -v "grep" | awk ' {if(NR==1)print $1}')
		echo "nart_id $nart_id"
		if [ "$nart_id" != "" ] 
		then
			kill -9 $nart_id
		fi
	fi
}

function KillProcessFor5G() {
	echo "KillProcessFor5G, $1, chip_num:$2"

	#9984+9984 5G对应pcie 0
	if [ $1 == 1 ]; then
		Qcmbr_id=$( ps | grep Qcmbr |grep "pcie 0"| grep -v "grep" | awk ' {if(NR==1)print $1}')
		echo "Qcmbr_id $Qcmbr_id"
		if [ "$Qcmbr_id" != "" ] 
		then
			kill -9 $Qcmbr_id
		fi
	else
		if [ $2 == 2 ];then
			Qcmbr_id_1=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==1)print $1}')
			echo "Qcmbr_id_1 $Qcmbr_id_1"

			if [ "$Qcmbr_id_1" != "" ]
			then
				kill -9 $Qcmbr_id_1
			fi		
		elif [ $2 == 3 ];then
			Qcmbr_id_1=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==1)print $1}')
			echo "Qcmbr_id_1 $Qcmbr_id_1"
			Qcmbr_id_2=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==2)print $1}')
			echo "Qcmbr_id_2 $Qcmbr_id_2"

			if [ "$Qcmbr_id_1" != "" ]
			then
				kill -9 $Qcmbr_id_1
			fi
		
			if [ "$Qcmbr_id_2" != "" ] 
			then
				kill -9 $Qcmbr_id_2
			fi
		fi 
	fi
}

function ProcessOperateFor2G() {
	echo "ProcessOperateFor2G: $1 ,$2 "

	#9984_2G=1, 跳过异构芯片=2场景	
	if [ $1 == 1 ]; then
		./Qcmbr -port 2390 -instance 0 -pcie $2 -interface wifi1 -console &
	elif [ $1 == 0 ]; then
		#11n芯片驱动运行环境准备
		[  ! -e /dev/dk0 ] && mknod /dev/dk0 c 63 0
		LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH

		./nart.out -port 2390 -instance 0 -pcie $2 -console &	
	fi
}

function ProcessOperateFor5G() {
	echo "ProcessOperateFor5G: $1 "
	./Qcmbr -port 2391 -instance 1 -pcie $1 -interface wifi0 -console &	
}

function ProcessOperateForTripl5G() {
	echo "ProcessOperateForTripl5G: $1  ,$2 "
	./Qcmbr -port 2391 -instance 1 -pcie $1 -interface wifi0 -console & 
	./Qcmbr -port 2392 -instance 2 -pcie $2 -interface wifi1 -console &
}

function Is2GProcessSuccess() {
	num=0
	echo "Is2GProcessSuccess: $#"
	proccess_finish="false"
	
	while [ $num -lt 5 ]
	do
		Qcmbr_id=$( ps | grep Qcmbr | grep -v "grep" | awk ' {print $1}' | head -n 1 )
		nart_id=$( ps | grep nart.out | grep -v "grep" | awk ' {print $1}' | head -n 1 )
		#9984_2G
		if [ $1 == 1 -a "$Qcmbr_id" != "" ];then
			proccess_finish="true"
		elif [ $1 == 0 -a "$nart_id" != "" ];then
			proccess_finish="true"
		else
			proccess_finish="false"
		fi
		
		if [ "$proccess_finish" = "true" ];then
			sleep 0.5
			echo "2G Success!"
			exit 0
		else
			let num++
		fi
	done
		
	if [ "$proccess_finish" = "false" ];then
		echo "Failure!"
	fi	
}

function Is5GProcessSuccess() {
	num=0
	echo "Is5GProcessSuccess: $#"
	
	if [ $2 == 2 ];then
		while [ $num -lt 5 ]
		do
			Qcmbr_id=$( ps | grep Qcmbr | grep -v "grep" | awk ' {print $1}' | head -n 1 )	
			if [ "$Qcmbr_id" != "" ]; then
				sleep 0.5
				echo "5G Success!"
				exit 0
			else
				let num++
			fi
		done
	elif [ $2 == 3 -o $1 == 1 ];then
		while [ $num -lt 5 ]
		do
			Qcmbr_id_1=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==1)print $1}')
			Qcmbr_id_2=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==2)print $1}')
			if [ "$Qcmbr_id_1" != "" -a "$Qcmbr_id_2" != "" ]; then
				sleep 0.5
				echo "5G Success!"
				exit 0
			else
				let num++
			fi
		done
	else
		echo "slot num error,not support"
	fi
}

function IsProcessSuccess() {
	num=0
	echo "IsProcessSuccess->para_num: $#, chip_num:$1, $2"
	proccess_finish="false"

	while [ $num -lt 5 ]
	do
		Qcmbr_id_1=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==1)print $1}')
		Qcmbr_id_2=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==2)print $1}')
		nart_id=$( ps | grep nart.out | grep -v "grep" | awk ' {if(NR==1)print $1}')	
		
		#1、双频：hisi + 9984 异构芯片场景
		if [ $1 == 2 -a $2 == 2 -a "$Qcmbr_id_1" != "" ]; then
			proccess_finish="true"
		#2、双频：9381 + 9984、9880场景
		elif [ $1 == 2 -a "$Qcmbr_id_1" != "" -a "$nart_id" != "" ];then		
			proccess_finish="true"
		#3、双频：9984 + 9984场景
		elif [ $1 == 2 -a "$Qcmbr_id_1" != "" -a "$Qcmbr_id_2" != "" ];then	
			proccess_finish="true"
		#3、三频：9381 + 9984 + 9984场景
		elif [ $1 == 3 -a "$Qcmbr_id_1" != "" -a "$Qcmbr_id_2" != "" -a "$nart_id" != "" ];then
			proccess_finish="true"
		else
			proccess_finish="false"
		fi

		if [ "$proccess_finish" = "true" ];then
			sleep 0.5
			echo ""
			echo Success!
			exit 0
		else
			num=$(($num+1))
		fi
	done

	if [ "$proccess_finish" = "false" ];then
		echo "Failure!"
	fi
}

function ProcessAccordChip() {
	echo "ProcessAccordChip start!"
	echo "chip_9984_2G: $chip_9984_2G"
	
	if [ $chip_9984_2G == 1 ];then
		chip_2g_num=$(awk '$2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)
		let chip_2g_num--
	else
		chip_2g_num=$(awk '$2 == "168c0030" || $2 == "168cabcd" {print $2}' < /proc/bus/pci/devices | wc -l)
	fi
	echo "chip_2g_num $chip_2g_num"

        chip_5g_num=$(awk '$2 == "168c003c" || $2 == "168c0046" {print $2}' < /proc/bus/pci/devices | wc -l)
	if [ $chip_9984_2G == 1 ];then
		let chip_5g_num--
	fi
	echo "chip_5g_num $chip_5g_num"

	[  ! -e /dev/caldata ] && ln -s /dev/mtdblock$calblocknum /dev/caldata
	
	#兼容之前不带2G/5G参数命令行
	if [ $1 == 0 ]; then
		KillProcessFor2G $chip_9984_2G
		KillProcessFor5G $chip_9984_2G $2
		
		ProcessOperateFor2G $chip_9984_2G $slot_2G
		if [ $2 == 2 ];then
			ProcessOperateFor5G $slot_5G
		elif [ $2 == 3 ];then		
			ProcessOperateForTripl5G $slot_5G_low $slot_5G_high
		fi
		
		IsProcessSuccess $2 $chip_9984_2G
	elif [ "$1" = "2G" ]; then
		echo "para: $1"
		if [ $chip_2g_num = 0 ]; then
			echo "chiptype is not qca"
			exit 0
		fi
		
		KillProcessFor2G $chip_9984_2G		
		ProcessOperateFor2G $chip_9984_2G $slot_2G
		
		Is2GProcessSuccess $chip_9984_2G
	elif [ "$1" = "5G" ]; then
		echo "para: $1"
		if [ $chip_5g_num = 0 ]; then
			echo "chiptype is not qca"
			exit 0
		fi
		
		KillProcessFor5G $chip_9984_2G $2
				
		if [ $2 == 2 ];then
			ProcessOperateFor5G $slot_5G
		elif [ $2 == 3 ];then		
			ProcessOperateForTripl5G $slot_5G_low $slot_5G_high
		fi
		
		Is5GProcessSuccess $chip_9984_2G $2
	fi

}

#命令格式
#1、QCAbegintest.sh 1 2G /QCAbegintest.sh 1 5G 
#2、QCAbegintest.sh 2G /QCAbegintest.sh 5G
#带参数1表示先擦除校准数据
if [ $# -gt 2 ]; then
	echo "ERROR::input para is not right!";
	exit 1;
else
	if [ "$1" = "1" ]; then
		#兼容之前不带2G/5G参数命令行
		if [ $# -eq 1 ]; then
			echo "para_num: $#"
			ProcessAccordChip 0 $chip_num
		else
			ProcessAccordChip $2 $chip_num
		fi
	else
		if [ $# == 0 ]; then
			echo "para_num: $#"
			ProcessAccordChip 0 $chip_num
		else
			ProcessAccordChip $1 $chip_num
		fi	 
	fi 
fi


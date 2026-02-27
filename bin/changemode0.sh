#!/bin/sh
#bin文件的路径
var_pack_temp_dir=/bin/
#脚本执行LOG的存放路径
var_config_log=/mnt/jffs2/portalguide_config_log.txt
wifi_uppara_batch_file=/var/ap_wifiguideconfig_up
wifi_downpara_batch_file=/var/ap_wifiguideconfig_down
var_notsavedata=/var/notsavedata
ais_change_mode=`GetFeature BBSP_AIS_MODE_CHANGE`
aisap_reuse_feature=`GetFeature FT_AIS_CPE_REUSE`
var_cycles=""
var_status=""
#echo采用的是追加模式，若文件不存在会报错，故先进行判断
HW_Script_CreateLogFile()
{    
	if [ ! -f "$var_config_log" ]
    then
        touch $var_config_log
    fi
}

HW_Script_CreateNotSaveDataFile()
{    
	if [ ! -f "$var_notsavedata" ]
    then
        touch $var_notsavedata
        chmod 666 $var_notsavedata
    fi
}

HW_Script_cfgtool_get_node_value()
{
    rm -rf /var/cfgtool_ret
    cfgtool gettofile $1 $2 $3
    if [ 0 -eq $? ]
    then
        if [ -f "/var/cfgtool_ret" ]
        then
            read $4 < /var/cfgtool_ret
        else
            echo  $2 $3 "cfgtool_ret is not exist" >> $var_upgrade_log
        fi
    fi
}

#判断一下，是否需要加密，该函数的第一个参数代表预配置是否需要加密
#para1 是否需要加密的标志 1：加密
#para2 要加密的ctree的路径
HW_Script_Encrypt()
{
    if [ $1 -eq 1 ]
    then
        gzip -f $2
        mv $2".gz" $2
        $var_pack_temp_dir/aescrypt2 0 $2 $2"_tmp"	
    fi
}   

HW_ChangeData4()
{
    var_IsXmlEncrypted=0
    # decrypt var_ctree          
    $var_pack_temp_dir/aescrypt2 1 $1 $1"_tmp"
    if [ 0 -ne $? ]
    then
	    echo $1" Is not Encrypted!" >> $var_config_log
	else
        echo $1" Is Encrypted!" >> $var_config_log
		var_IsXmlEncrypted=1		
        mv $1 $1".gz"
	    gunzip -f $1".gz"	    
    fi
		
	 echo "Start..." >> $var_config_log
    if [ $ais_change_mode = 1 ]; then
        cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1" "X_HW_VLAN" "10"
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement.IPInterface.IPInterfaceInstance.1" "IPInterfaceIPAddress" "192.168.1.1"
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement" "MinAddress" "192.168.1.100"
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement" "MaxAddress" "192.168.1.200"
    fi
	cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.X_HW_Mesh" "MeshMode" "0"

    if [ $aisap_reuse_feature = 1 ]; then
        cfgtool set $1 "InternetGatewayDevice.DeviceInfo" "X_AIS_reuseCPE_cycles" $var_cycles
        cfgtool set $1 "InternetGatewayDevice.DeviceInfo" "X_AIS_reuseCPE_status" $var_status
    fi

	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
}



HW_Script_ChangeCTree3()
{
    echo "begin change default ctree"   
	#通过脚本更改/mnt/jffs2/hw_ctree.xml文件
	if [ -f /mnt/jffs2/hw_ctree.xml ]
    then
		#对当前ctree做操作
        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree.xml	
		echo "begin to HW_ChangeDatalf!!!"
        HW_ChangeData4 /var/hw_ctree.xml
		cp -rf /var/hw_ctree.xml /mnt/jffs2/hw_ctree.xml
		echo "end to HW_ChangeDatalf!!!"		
    fi
	
}


GetCpeReusePara()
{
    var_IsXmlEncrypted=0
    # decrypt var_ctree
    $var_pack_temp_dir/aescrypt2 1 $1 $1"_tmp"
    if [ 0 -ne $? ]; then
        echo $1" Is not Encrypted!" >> $var_config_log
    else
        echo $1" Is Encrypted!" >> $var_config_log
        var_IsXmlEncrypted=1
        mv $1 $1".gz"
        gunzip -f $1".gz"
    fi

    var_AIS_reuseCPE_path="InternetGatewayDevice.DeviceInfo"
    HW_Script_cfgtool_get_node_value $1 $var_AIS_reuseCPE_path X_AIS_reuseCPE_cycles var_cycles
    HW_Script_cfgtool_get_node_value $1 $var_AIS_reuseCPE_path X_AIS_reuseCPE_status var_status

    # set var_node_guideflag 
    #encrypt var_ctree
    HW_Script_Encrypt $var_IsXmlEncrypted $1

    return 0
}

HW_Script_AISAP_GetCpeReusePara()
{
    #通过脚本从/var/ctree_for_aisap_reserve_reuse_node.xml文件中获取需要保留的关键参数值
    var_AISAP_REUSE_CTREE_FILE="/var/ctree_for_aisap_reserve_reuse_node.xml"
    if [ -f $var_AISAP_REUSE_CTREE_FILE ];then
        GetCpeReusePara $var_AISAP_REUSE_CTREE_FILE
        # /var/ctree_for_aisap_reserve_reuse_node.xml已用完，删掉
        rm -rf $var_AISAP_REUSE_CTREE_FILE
    fi
}

echo "begin to run script!!!"

HW_Script_CreateLogFile
	
HW_Script_CreateNotSaveDataFile

if [ $aisap_reuse_feature = 1 ]; then
    HW_Script_AISAP_GetCpeReusePara
fi

HW_Script_ChangeCTree3

echo "End execute:  " "`date \"+%Y-%m-%d%t%H:%M:%S\"`" >> $var_config_log

echo "end to run script!!!"


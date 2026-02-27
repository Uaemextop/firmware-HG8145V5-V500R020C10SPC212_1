#!/bin/sh
#bin文件的路径
var_pack_temp_dir=/bin/
#脚本执行LOG的存放路径
var_config_log=/mnt/jffs2/portalguide_config_log.txt
wifi_uppara_batch_file=/var/ap_wifiguideconfig_up
wifi_downpara_batch_file=/var/ap_wifiguideconfig_down
var_notsavedata=/var/notsavedata
ais_change_mode=`GetFeature BBSP_AIS_MODE_CHANGE`
ais_cpereuse_feature=`GetFeature FT_AIS_CPE_REUSE`
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

HW_ChangeData()
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

	cfgtool batch $1 $wifi_downpara_batch_file
	
	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
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


HW_ChangeData1()
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

	cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.X_HW_Mesh" "MeshMode" "1"
	
	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
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
        cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1" "X_HW_VLAN" ""
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement.IPInterface.IPInterfaceInstance.1" "IPInterfaceIPAddress" "192.168.10.1"
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement" "MinAddress" "192.168.10.100"
        cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.LANHostConfigManagement" "MaxAddress" "192.168.10.200"
    fi
	cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.X_HW_Mesh" "MeshMode" "2"
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "1"
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.2.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "1"
	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
}

HW_ChangeData7()
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

	cfgtool set $1 "InternetGatewayDevice.LANDevice.LANDeviceInstance.1.X_HW_Mesh" "MeshMode" "2"
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "0"
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.2.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "1"
	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
}

HW_ChangeData8()
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
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "1"
	cfgtool set $1 "InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.2.WANPPPConnection.WANPPPConnectionInstance.1" "Enable" "0"
	# set var_node_guideflag 
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	echo "Finish!"  >> $var_config_log
	
	return 0
}

HW_Script_ChangeCTree1()
{
    
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml ]
    then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml /var/hw_default_aisap_lan_rt.xml
		
        echo "begin to HW_ChangeData!!!"
        HW_ChangeData1 /var/hw_default_aisap_lan_rt.xml
        echo "end to HW_ChangeData!!!"		
	
        cp -rf /var/hw_default_aisap_lan_rt.xml /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml
        rm -rf /var/hw_default_aisap_lan_rt.xml	
    fi
	
}

HW_Script_ChangeCTree7()
{  
	if [ -f /mnt/jffs2/hw_ctree.xml ]
    then
		#对当前ctree做操作
		rm -rf /var/hw_ctree_temp.xml
        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree_temp.xml
		
        HW_ChangeData7 /var/hw_ctree_temp.xml

        cp -rf /var/hw_ctree_temp.xml /mnt/jffs2/hw_ctree.xml
    fi
	
}

HW_Script_ChangeCTree8()
{  
	if [ -f /mnt/jffs2/hw_ctree.xml ]
    then
		#对当前ctree做操作
		rm -rf /var/hw_ctree_temp.xml
        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree_temp.xml
		
        HW_ChangeData8 /var/hw_ctree_temp.xml

        cp -rf /var/hw_ctree_temp.xml /mnt/jffs2/hw_ctree.xml
    fi
	
}



HW_Script_ChangeCTree4()
{
    
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml ]
    then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml /var/hw_default_aisap_lan_rt.xml
		
        echo "begin to HW_ChangeData!!!"
        HW_ChangeData4 /var/hw_default_aisap_lan_rt.xml
        echo "end to HW_ChangeData!!!"		
	
        cp -rf /var/hw_default_aisap_lan_rt.xml /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml
        rm -rf /var/hw_default_aisap_lan_rt.xml	
    fi
	
}

HW_ChangeData2()
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
	var_ampwlanconfig_path="InternetGatewayDevice.LANDevice.LANDeviceInstance.1.X_HW_Mesh"
    var_meshmode=""
	HW_Script_cfgtool_get_node_value $1 $var_ampwlanconfig_path MeshMode var_meshmode
	echo $var_meshmode
	if [ "1" == $var_meshmode ]
	then
	    echo "mesh mode!!!"
        HW_Script_ChangeCTree1
    fi
    if [ "2" == $var_meshmode ]
	then
	    echo "mesh mode untagged!!!"
		HW_Script_ChangeCTree4
	fi
	echo "Finish!"  >> $var_config_log
	
	return 0
}


HW_Script_ChangeCTree3()
{
    echo "begin change default ctree"   
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/hw_ctree_bak.xml ]
    then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/hw_ctree_bak.xml /var/hw_ctree_bak.xml	
        echo "begin to HW_ChangeDatalf!!!"
        HW_ChangeData2 /var/hw_ctree_bak.xml
        echo "end to HW_ChangeDatalf!!!"		
    fi

}


HW_Script_ChangeCTree()
{
    
	#通过脚本更改/mnt/jffs2/hw_ctree.xml文件
	 if [ -f /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml ]
    then
		#对当前ctree做操作
        cp -rf /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml /var/hw_default_aisap_lan_ap.xml
		
		echo "begin to HW_ChangeData!!!"
        HW_ChangeData /var/hw_default_aisap_lan_ap.xml
		echo "end to HW_ChangeData!!!"		
	
        cp -rf /var/hw_default_aisap_lan_ap.xml /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml
		rm -rf /var/hw_default_aisap_lan_ap.xml	
    fi
	
}

SetDataToCTree()
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

    echo "Start..." >> $var_config_log

    cfgtool set $1 "InternetGatewayDevice.DeviceInfo" "X_AIS_reuseCPE_cycles" $2
    cfgtool set $1 "InternetGatewayDevice.DeviceInfo" "X_AIS_reuseCPE_status" $3

    # set var_node_guideflag 
    #encrypt var_ctree
    HW_Script_Encrypt $var_IsXmlEncrypted $1

    echo "Finish!"  >> $var_config_log

    return 0
}

HW_SetCpeReuseValueToCTree()
{
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml ]; then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml /var/hw_default_aisap_lan_rt.xml

        echo "begin to change rt mode ctree!!!"
        SetDataToCTree /var/hw_default_aisap_lan_rt.xml $1 $2
        echo "end to change rt mode ctree!!!"

        cp -rf /var/hw_default_aisap_lan_rt.xml /mnt/jffs2/customize_xml/hw_default_aisap_lan_rt.xml
        rm -rf /var/hw_default_aisap_lan_rt.xml
    fi

    if [ -f /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml ]; then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml /var/hw_default_aisap_lan_ap.xml

        echo "begin to change ap mode ctree!!!"
        SetDataToCTree /var/hw_default_aisap_lan_ap.xml $1 $2
        echo "end to change ap mode ctree!!!"

        cp -rf /var/hw_default_aisap_lan_ap.xml /mnt/jffs2/customize_xml/hw_default_aisap_lan_ap.xml
        rm -rf /var/hw_default_aisap_lan_ap.xml
    fi

}

HW_SaveCpeReusePara()
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
    echo "Start..." >> $var_config_log

    var_AIS_reuseCPE_path="InternetGatewayDevice.DeviceInfo"
    var_cycles=""
    HW_Script_cfgtool_get_node_value $1 $var_AIS_reuseCPE_path X_AIS_reuseCPE_cycles var_cycles

    var_status=""
    HW_Script_cfgtool_get_node_value $1 $var_AIS_reuseCPE_path X_AIS_reuseCPE_status var_status

    HW_SetCpeReuseValueToCTree $var_cycles $var_status

    echo "Finish!"  >> $var_config_log

    return 0
}

HW_Script_AISAP_SaveCpeReusePara()
{
 
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/hw_ctree.xml ]; then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/hw_ctree.xml /var/hw_ctree_aisap_reserve_reuse_node.xml
        echo "begin to HW_Script_AISAP_SaveCpeReusePara!!!"
        HW_SaveCpeReusePara /var/hw_ctree_aisap_reserve_reuse_node.xml
        echo "end to HW_Script_AISAP_SaveCpeReusePara!!!"
    fi
}

echo "begin to run script!!!"

HW_Script_CreateLogFile
	
echo "Begin execute:" "`date \"+%Y-%m-%d%t%H:%M:%S\"`" >> $var_config_log
if [ -f /var/execsh ] 
then
    HW_Script_CreateNotSaveDataFile

    HW_Script_ChangeCTree
fi
if [ -f /var/dealwithrtctree ] 
then
    HW_Script_CreateNotSaveDataFile

    HW_Script_ChangeCTree1
fi

if [ -f /var/RepToRTUntagged ] 
then
    HW_Script_CreateNotSaveDataFile

    HW_Script_ChangeCTree4
fi


if [ -f /var/stayrt ] 
then
    HW_Script_CreateNotSaveDataFile
    
    HW_Script_ChangeCTree3
fi

if [ $ais_cpereuse_feature = 1 ]; then
   HW_Script_CreateNotSaveDataFile

   HW_Script_AISAP_SaveCpeReusePara
fi

echo "End execute:  " "`date \"+%Y-%m-%d%t%H:%M:%S\"`" >> $var_config_log

echo "end to run script!!!"


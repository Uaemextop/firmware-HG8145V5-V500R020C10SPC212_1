#! /bin/sh

var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree_var=/var/hw_default_ctree.xml
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree_var=/var/hw_temp_ctree.xml
var_pack_temp_dir=/bin/
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"
var_ssid=""
var_wpa="" 
var_ssid5g=""
var_wpa5g="" 
var_pppoe_username=""

#set GPON SN 
HW_Set_GPON_SN_Passwd()
{
	if [ ! -f $var_boardinfo_file ]
	then
		return;
	fi

	cat $var_boardinfo_file | while read -r line;
	do
			obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
			obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		#对于合一包制作场景，打包/mnt/jffs2/gpon_chgpwd文件，则不会修改GPON PASSWORD
		if [ "0x00000003" == $obj_id ] && [ ! -f /mnt/jffs2/gpon_chgpwd ] ;then
                    echo "obj.id = \"0x00000003\" ; obj.value = \"123456\";"
		elif [ "0x00000004" == $obj_id ] && [ ! -f /mnt/jffs2/gpon_chgpwd ] ;then
                    echo "obj.id = \"0x00000004\" ; obj.value = \"313233343536\";"
		else
		    echo -E $line
		fi
	done  > $var_boardinfo_temp
	
	: > $var_boardinfo_file

	cat $var_boardinfo_temp >> $var_boardinfo_file
	rm -f $var_boardinfo_temp
	
	return 0
}

# check the customize file
HW_Script_CheckFileExist()
{
	if [ ! -f "$var_customize_file" ] ;then
	    echo "ERROR::customize file is not existed."
            return 1
	fi
	return 0
}

# read data from customize file
HW_Script_ReadDataFromFile()
{
	read -r var_ssid var_wpa var_ssid5g var_wpa5g var_pppoe_username < $var_customize_file
	
	return 0
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_ssid=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	var_node_ssid5g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd5g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1
	var_node_PPPOEWan=InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1

	# decrypt var_default_ctre
	cp -f $var_default_ctree $var_default_ctree_var
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree_var $var_temp_ctree_var
	mv -f $var_default_ctree_var $var_default_ctree_var".gz"
	gunzip -f $var_default_ctree_var".gz"

	#判断密码即可
	if [ ! -z $var_wpa ]
	then
		# set ssid 
		cfgtool set $var_default_ctree_var $var_node_ssid SSID "$var_ssid"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common ssid name!"
		    return 1
		fi

		# set wpa password
		cfgtool set $var_default_ctree_var $var_node_wpa_pwd PreSharedKey "$var_wpa"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common ssid wap password!"
		    return 1
		fi
	fi
	
	#判断密码即可
	if [ ! -z $var_wpa5g ]
	then
		# set ssid 
		cfgtool set $var_default_ctree_var $var_node_ssid5g SSID "$var_ssid5g"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common 5g ssid name!"
		    return 1
		fi

		# set wpa password
		cfgtool set $var_default_ctree_var $var_node_wpa_pwd5g PreSharedKey "$var_wpa5g"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common ssid 5g wap password!"
		    return 1
		fi
	fi
	   
	if [ ! -z $var_pppoe_username ]
	then
		#set PPPOE WAN username
		cfgtool set $var_default_ctree_var $var_node_PPPOEWan Username  "$var_pppoe_username"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set pppoe wan username!"
		    return 1
		fi
	fi
	
	#encrypt var_default_ctree
	gzip -f $var_default_ctree_var
	mv -f $var_default_ctree_var".gz" $var_default_ctree_var
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree_var $var_temp_ctree_var
	mv -f $var_default_ctree_var $var_default_ctree
	return
}

#
HW_Set_GPON_SN_Passwd

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#读取定制参数
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0


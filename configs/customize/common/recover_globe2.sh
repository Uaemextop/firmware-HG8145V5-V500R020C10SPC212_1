#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /var/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中
#customize.sh COMMON_WIFI XXX SSID WPA密码
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_temp_ctree.xml
var_default_ctree2=/mnt/jffs2/customize_xml/hw_default_ctree2.xml
var_temp_ctree2=/mnt/jffs2/customize_xml/hw_temp_ctree2.xml
var_pack_temp_dir=/bin/
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"
var_ProvisionCode="GLOBE"

var_ssid1=""
var_wpa1=""

var_ssid2=""
var_wpa2=""

#默认是不带wifi
var_has_wifi=0

#判断是否包含wifi
HW_Script_CheckHaveWIFI()
{	
	var_has_wifi=`cat /proc/wap_proc/pd_static_attr | grep -w wlan_num | grep -o \".*[0-9].*\" | grep -o "[0-9]"`  
}
 
HW_Check_Boardinfo()
{
	if [ -f $var_boardinfo_file ]; then
		return 0;
	else
		echo "ERROR::$var_boardinfo_file is not exist!"
		return 1;
	fi		
}

HW_Set_ProvisionCode()
{
    #ProvisionCode的ID为0x00000020
    #检查boardinfo是否存在
    HW_Check_Boardinfo
	if [ ! $? == 0 ]
	then
		echo "ERROR::Failed to Check Boardinfo!"
		return 1
	fi

	cat $var_boardinfo_file | while read -r line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
		if [ "0x00000020" == $obj_id ];then
		    obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
		    echo $line | sed 's/'\"$obj_value\"'/'\"$var_ProvisionCode\"'/g';
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
	if [ $var_has_wifi -ne 0 ]
	then
		read -r var_ssid1 var_wpa1 var_ssid2 var_wpa2 < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "Failed to read spec info!"
			return 1
		fi
	fi
	return
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_ssid2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1
	
	if [ $var_has_wifi -eq 0 ]
	then
		return
	fi
	
	# decrypt var_default_ctre
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv -f $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	
	# set ssid 
	cfgtool set $var_default_ctree $var_node_ssid1 SSID $var_ssid1
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid1 name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_node_ssid2 SSID $var_ssid2
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 name!"
	    return 1
	fi

	# set wpa password
	cfgtool set $var_default_ctree $var_node_wpa_pwd1 PreSharedKey $var_wpa1
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid1 wap password!"
	    return 1
	fi

	cfgtool set $var_default_ctree $var_node_wpa_pwd2 PreSharedKey $var_wpa2
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 wap password!"
	    return 1
	fi

	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv -f $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree

	# decrypt var_default_ctre2
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree2 $var_temp_ctree2
	mv -f $var_default_ctree2 $var_default_ctree2".gz"
	gunzip -f $var_default_ctree2".gz"

	# set ssid 1
	cfgtool set $var_default_ctree2 $var_node_ssid1 SSID $var_ssid1
	if [ 0 -ne $? ]
	then
	    echo "Failed to set var_default_ctree2 ssid1 name!"
	    return 1
	fi

	# set ssid 1 pwd
	cfgtool set $var_default_ctree2 $var_node_wpa_pwd1 PreSharedKey $var_wpa1
	if [ 0 -ne $? ]
	then
	    echo "Failed to set var_default_ctree2 ssid1 pwd!"
	    return 1
	fi
	# set ssid 2
    cfgtool set $var_default_ctree2 $var_node_ssid2 SSID $var_ssid2
	if [ 0 -ne $? ]
	then
	    echo "Failed to set var_default_ctree2 ssid2 name!"
	    return 1
	fi

	# set ssid2 pwd
	cfgtool set $var_default_ctree2 $var_node_wpa_pwd2 PreSharedKey $var_wpa2
	if [ 0 -ne $? ]
	then
	    echo "Failed to set var_default_ctree2 ssid2 pwd!"
	    return 1
	fi

	#encrypt var_default_ctree
	gzip -f $var_default_ctree2
	mv -f $var_default_ctree2".gz" $var_default_ctree2
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree2 $var_temp_ctree2

	return
}

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#检查是否包含wifi
HW_Script_CheckHaveWIFI

#
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

HW_Set_ProvisionCode

echo "set spec info OK!"

exit 0


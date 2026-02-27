#! /bin/sh

var_customize_file=/var/customizepara.txt

var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_temp_ctree.xml
var_pack_temp_dir=/bin/

var_ssid1=""
var_wpa1=""

var_ssid2=""
var_wpa2=""

var_web_user=""
var_web_pwd=""

#LANMAC写入PASSWORD中
var_hexponpwd=""
var_asciiponpwd=""
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"

#默认是不带wifi
var_has_wifi=0

#判断是否包含wifi
HW_Script_CheckHaveWIFI()
{	
	var_has_wifi=`cat /proc/wap_proc/pd_static_attr | grep -w wlan_num | grep -o \".*[0-9].*\" | grep -o "[0-9]"`  
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
		read -r var_ssid1 var_wpa1 var_ssid2 var_wpa2 var_web_user var_web_pwd < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "Failed to read spec info!"
			return 1
		fi
	fi
	return
}

HW_Set_GPON_Lanmac_Passwd()
{
	#对于合一包制作场景，打包/mnt/jffs2/gpon_chgpwd文件，则不会修改GPON PASSWORD
	if [ -f /mnt/jffs2/gpon_chgpwd ]
	then
		echo "No need to change PWD"
		return;
	fi

	if [ ! -f $var_boardinfo_file ]
	then
	    echo "ERROR::no hw_boardinfo"
	    return;
	fi

	var_lanmac=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000a)
	password_byte1=$(echo $var_lanmac | cut -d ":" -f 1 | cut -d "\"" -f 4)
	password_byte2=$(echo $var_lanmac | cut -d ":" -f 2)
	password_byte3=$(echo $var_lanmac | cut -d ":" -f 3)
	password_byte4=$(echo $var_lanmac | cut -d ":" -f 4)
	password_byte5=$(echo $var_lanmac | cut -d ":" -f 5)
	password_byte6=$(echo $var_lanmac | cut -d ":" -f 6 | cut -c 1-2)
	var_hexponpwd=$password_byte1$password_byte2$password_byte3$password_byte4$password_byte5$password_byte6
	#如果boardinfo中写0x00000003，则十六进制0x00会丢失，因此入参只写入0x00000004。
	#需要同时清空0x00000003，否则0x00000003有值时定制参数中传入pwd不会生效。
	cat $var_boardinfo_file | while read -r line;
	do
	    obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
	    obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
	    #对于合一包制作场景，打包/mnt/jffs2/gpon_chgpwd文件，则不会修改GPON PASSWORD
	    if [ $obj_id == "0x00000003" ] ;then
	        echo "obj.id = \"0x00000003\" ; obj.value = \"$var_asciiponpwd\";"
	    elif [ $obj_id == "0x00000004" ] ;then
	        echo "obj.id = \"0x00000004\" ; obj.value = \"$var_hexponpwd\";"
	    else
	        echo -E $line
	    fi
	done  > $var_boardinfo_temp
	
	: > $var_boardinfo_file
	cat $var_boardinfo_temp >> $var_boardinfo_file
	rm -f $var_boardinfo_temp
	
	return 0
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_ssid2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_web_user=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1
	var_node_web_pwd=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1
	
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
	
	#set web normal user
	cfgtool set $var_default_ctree $var_node_web_user UserName $var_web_user
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common web normal UserName!"
	    return 1
	fi

	#set web normal user password
	cfgtool set $var_default_ctree $var_node_web_pwd Password $var_web_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common web normal password!"
	    return 1
	fi	
	
	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv -f $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree	
	return
}

HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

HW_Script_CheckHaveWIFI

HW_Script_CheckHaveWIFI
[ ! $? == 0 ] && exit 1

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#PON认证
HW_Set_GPON_Lanmac_Passwd

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0


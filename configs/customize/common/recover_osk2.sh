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
var_pack_temp_dir=/bin/

var_ssid1=""
var_wpa1=""

var_ssid2=""
var_wpa2=""
 

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
	read -r var_userPwd var_ssid2g var_wpa2g var_ssid5g var_wpa5g var_ssidguest var_wpaguest < $var_customize_file
	if [ 0 -ne $? ]
	then
	    echo "Failed to read spec info!"
	    return 1
	fi
	return
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_web_pwd=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1
	var_node_ssid2g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd2g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_ssid5g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd5g=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_ssidguest=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2
	var_node_wpa_pwdguest=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2.PreSharedKey.PreSharedKeyInstance.1
	
	
	# decrypt var_default_ctre
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv -f $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	
	# set userwebpwd 
	cfgtool set $var_default_ctree $var_node_web_pwd Password $var_userPwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid1 name!"
	    return 1
	fi
	
	# set ssid 
	cfgtool set $var_default_ctree $var_node_ssid2g SSID $var_ssid2g
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2g name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_node_ssid5g SSID $var_ssid5g
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid5g name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_node_ssidguest SSID $var_ssidguest
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssidguest name!"
	    return 1
	fi
	
	# set wpa password
	cfgtool set $var_default_ctree $var_node_wpa_pwd2g PreSharedKey $var_wpa2g
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2g wap password!"
	    return 1
	fi
	
	
	cfgtool set $var_default_ctree $var_node_wpa_pwd5g PreSharedKey $var_wpa5g
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid5g wap password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_node_wpa_pwdguest PreSharedKey $var_wpaguest
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssidguest wap password!"
	    return 1
	fi
	
	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv -f $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree	
	return
}

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0


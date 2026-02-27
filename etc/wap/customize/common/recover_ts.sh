#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /var/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中

# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_specsn=""
var_userPwd=""
var_ssid=""
var_wpa="" 

var_pack_temp_dir=/bin/

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
	read -r var_ssid var_wpa var_pppoe_unm var_pppoe_pwd < $var_customize_file
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
	var_node_ssid=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1	
	var_pppoe_node=InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1
	var_tms_node=InternetGatewayDevice.ManagementServer

	acs_username_byte1=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 1)
	acs_username_byte2=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 2)
	acs_username_byte3=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 3)
	acs_username_byte4=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 4)
	acs_username_byte5=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 5)
	acs_username_byte6=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000f | tr A-Z a-z | cut -d "\"" -f 4 | cut -d ":" -f 6)
	var_acs_username=$acs_username_byte1$acs_username_byte2$acs_username_byte3"-"$acs_username_byte4$acs_username_byte5$acs_username_byte6

        # decrypt var_default_ctree
        $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv -f $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	# set ssid 
	cfgtool set $var_default_ctree $var_node_ssid SSID $var_ssid
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid name!"
	    return 1
	fi

	# set wpa password
	cfgtool set $var_default_ctree $var_node_wpa_pwd PreSharedKey $var_wpa
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid wap password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_pppoe_node Username $var_pppoe_unm
	if [ 0 -ne $? ]
	then
	    echo "Failed to set pppoe name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_pppoe_node Password $var_pppoe_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set pppoe password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_tms_node Username $var_acs_username
	if [ 0 -ne $? ]
	then
	    echo "Failed to set tr069 username!"
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


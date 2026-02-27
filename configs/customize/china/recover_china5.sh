#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /var/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中
#customize.sh COMMON_WIFI XXX SSID WPA密码
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_default_ctree_var=/var/hw_default_ctree.xml
var_temp_ctree_var=/var/hw_temp_ctree.xml
var_pack_temp_dir=/bin/

var_web_pwd=""

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
	read -r var_web_pwd < $var_customize_file
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

	cp -f $var_default_ctree $var_default_ctree_var
	# decrypt var_default_ctre
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree_var $var_temp_ctree_var
	mv -f $var_default_ctree_var $var_default_ctree_var".gz"
	gunzip -f $var_default_ctree_var".gz"

	cfgtool set $var_default_ctree_var $var_node_web_pwd Password $var_web_pwd
	if [ 0 -ne $? ]
	then
		echo "Failed to set web common user password!"
		return 1
	fi

	#设置普通用户出厂密码，没有就新增
	cfgtool gettofile $var_default_ctree_var $var_node_web_pwd "FactoryPassword"
	if [ 0 -eq $? ]
	then
		cfgtool set $var_default_ctree_var $var_node_web_pwd "FactoryPassword" $var_web_pwd
	else
		cfgtool add $var_default_ctree_var $var_node_web_pwd "FactoryPassword" $var_web_pwd
	fi

	#encrypt var_default_ctree
	gzip -f $var_default_ctree_var
	mv -f $var_default_ctree_var".gz" $var_default_ctree_var
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree_var $var_temp_ctree_var	
	mv -f $var_default_ctree_var $var_default_ctree
	return
}

HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0


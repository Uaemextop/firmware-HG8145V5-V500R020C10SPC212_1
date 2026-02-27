#! /bin/sh

#免预配制时专用，加快配置速度，ssid等参数会在启动时配置，无需此处配置。
CURRENT_DIR=$PWD
HW_WAP_TRUNK_ROOT=$CURRENT_DIR/..
HW_WAP_PLAT_ROOT=$HW_WAP_TRUNK_ROOT/WAP
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/var/customizepara.txt
var_specsn=""
var_userPwd=""
var_ssid=""
var_wpa="" 
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"

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
	read -r var_specsn var_userPwd var_ssid var_wpa < $var_customize_file
	if [ 0 -ne $? ]
	then
	    echo "Failed to read spec info!"
	    return 1
	fi
	return
}


HW_Script_SetSpecSn()
{	
	#/mnt/jffs2目录下的不是自己的文件不能通过sed -i命令操作，先将hw_boardinfo拷贝到var目录下操作
	cp -f $var_boardinfo_file $var_boardinfo_temp

	if [ $? -ne 0 ]; then
		echo "ERROR::Copy Boardinfo failed!"
		return 1
	fi

	echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000019\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000019\" ; obj.value = \"'$var_specsn'\"/g' -i

	#结束对临时hw_boardinfo的写入操作后，先将/mnt/jffs2/hw_boardinfo文件清空，再将var目录下的hw_boardinfo里面的内容写入/mnt/jffs2/hw_boardinfo
	: > $var_boardinfo_file

	cat $var_boardinfo_temp >> $var_boardinfo_file
	rm -f $var_boardinfo_temp
	return
}

# set customize data to file
HW_Script_SetDatToFile()
{
	#设置SpecSn的值到boardinfo
	HW_Script_SetSpecSn

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


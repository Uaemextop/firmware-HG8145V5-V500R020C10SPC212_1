#! /bin/sh

var_customize_path=/etc/wap/customize
#add by guotao 20161116 ,设置ap模式切换标识到boardinfo
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"
ap_support_mode_id=`cat /mnt/jffs2/hw_boardinfo |grep "0x00000042"`
var_customize_file=/var/customizepara.txt
var_pack_temp_dir=/bin/
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_boardinfo=/mnt/jffs2/hw_boardinfo

var_ssid1=""
var_wpa1=""

var_ssid2=""
var_wpa2=""
var_backhalssid=""
var_backhalssidwpa=""
var_typeword=""

GetDefTypeWord()
{
	#记录原始上行模式 
	while read line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

		if [ "0x00000035" == $obj_id ];then
		    obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
			var_typeword=$obj_value
			continue
		fi
	done < $var_boardinfo
	return
} 

GetDefTypeWord
[ ! $? == 0 ] && exit 1

#若boardinfo文件里不存在模式切换的id，则向boardinfo文件新增
if [ -z "$ap_support_mode_id" ]
then
	echo "obj.id = \"0x00000042\" ; obj.value = \"0\";" >> $var_boardinfo_file
fi

var_upport="0x0000000"`cat /proc/wap_proc/pd_static_attr | grep eth_num | awk -F "\"" '{print $2}'`
#HG8245W5产品默认上行模式为pon上行
var_is_supportponUpport=`GetFeature FT_AISAP_DEFAULT_PONUPPORT`

#/mnt/jffs2目录下的不是自己的文件不能通过sed -i命令操作，先将hw_boardinfo拷贝到var目录下操作
cp -f $var_boardinfo_file $var_boardinfo_temp

if [ $? -ne 0 ]; then
	echo "ERROR::Copy Boardinfo failed!"
	return 1
fi

if [ $var_is_supportponUpport -eq 0 ]
then
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"3\"/g' -i
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"'$var_upport'\"/g' -i
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"2\"/g' -i
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"'$var_upport'\"/g' -i
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000059\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000059\" ; obj.value = \"3\"/g' -i
else
    echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000061\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000061\" ; obj.value = \"0\"/g' -i
fi

if [ "ADAPT" != "$var_typeword" ];then
	echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000042\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000042\" ; obj.value = \"1\"/g' -i
fi

#结束对临时hw_boardinfo的写入操作后，先将/mnt/jffs2/hw_boardinfo文件清空，再将var目录下的hw_boardinfo里面的内容写入/mnt/jffs2/hw_boardinfo
: > $var_boardinfo_file

cat $var_boardinfo_temp >> $var_boardinfo_file
rm -f $var_boardinfo_temp

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
	read -r var_ssid1 var_wpa1 var_ssid2 var_wpa2 var_backhalssid var_backhalssidwpa < $var_customize_file
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
	var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	
	var_node_ssid2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1

	var_node_ssid8=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.9
	var_node_wpa_pwd8=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.9.PreSharedKey.PreSharedKeyInstance.1

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
	
	if [ -n "$var_backhalssid" ]; then 
		cfgtool set $var_default_ctree $var_node_ssid8 SSID $var_backhalssid
		if [ 0 -ne $? ]
		then
			echo "Failed to set backhaul ssid!"
			return 1
		fi
	fi
	if [ -n "$var_backhalssidwpa" ]; then 
		cfgtool set $var_default_ctree $var_node_wpa_pwd8 PreSharedKey $var_backhalssidwpa
		if [ 0 -ne $? ]
		then
			echo "Failed to set backhaul ssid pwd!"
			return 1
		fi
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




#! /bin/sh

#set CTCOM, Unicom or mobily spec parameters
#include bin and spec word
#include spec sn, common web username ssid password

# 定制信息文件
var_customize_file=/mnt/jffs2/customizepara.txt
var_customize_file_var_path=/var/customizepara_getcustomize.txt
var_customize_file_not_aes=/var/customizepara_getcustomize_not_aes.txt
var_jffs2_customize_txt_file=/mnt/jffs2/customize.txt
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara

var_binword=""
var_cfgword=""
var_customizeinfo=""
var_factory_file="/var/customizerealfinish"
var_customizedoingflagfile="/var/customizedoing"
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_file_tmp="/var/hw_boardinfo_tmp"
var_customizetarfile="/mnt/jffs2/customize_xml.tar.gz"
Customize_Script_GetBoardinfoFtWord()
{
	var_binword=""
	var_cfgword=""
	boardinfo_encrypt_support=`GetFeature FT_SUPPORT_BOARDINFO_ENCRYPT`
	if [ $boardinfo_encrypt_support = 1 ]; then
		decrypt_boardinfo -s $var_boardinfo_file -d $var_boardinfo_file_tmp
	else
		cp -f $var_boardinfo_file $var_boardinfo_file_tmp
	fi
	if [ ! -f "$var_boardinfo_file_tmp" ]
	then
		echo "ERROR::no customize info exist!"
		exit 1
	fi
	while read line;
	do			
	#脚本以"作为匹配，但是boardinfo中有些字段的值(例如snpassword)可以设置为"号，
	#因此不能以上面的模式匹配,改为根据obj.value将一个条目分为两个部分,
	#这种改法有一种限制obj.value不能为BinWord或者CfgWord的值，否则会匹配出错，
	#第一部分为obj_id,第二部分为obj_value，obj_id只读因此可以根据上面的模式匹配
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		if [ "0x0000001a" == $obj_id ];then
			obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
			var_binword=$obj_value;
		elif [ "0x0000001b" == $obj_id ];then
			obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
			var_cfgword=$obj_value;
		else 
			continue
		fi
	done < $var_boardinfo_file_tmp
	rm -f $var_boardinfo_file_tmp
}

if [ -f $var_customizedoingflagfile ]
then
	if [ ! -f $var_factory_file ]
	then
		echo "ERROR::customizing, please wait!"
		exit 1
	fi
	Customize_Script_GetBoardinfoFtWord
	read var_binword_tmp var_cfgword_tmp < /var/tmpbinftwordsave
	if [ "$var_binword_tmp" != "$var_binword" ] || [ "$var_cfgword_tmp" != "$var_cfgword" ]
	then
		echo "ERROR::board info not match"
		exit 1
	fi
fi

#get feature word
HW_Script_GetFtWord()
{
	if [ -f $var_jffs2_customize_txt_file ];then
	read var_binword var_cfgword < $var_jffs2_customize_txt_file
	else
		Customize_Script_GetBoardinfoFtWord
	return
	fi
}

# get customize info 
HW_Script_GetCustomizeInfo()
{
	if [ ! -f "$var_customize_file" ]
	then
		echo "ERROR::no customize info exist!"
		return 1
	fi
	
	# 考虑到如果之前用5个参数定制的jffs2下生成的是TelmexCusomizePara
	# 此处暂不修改
	if [ "TELMEX" == $var_cfgword ] && [ -f $var_customize_telmex ]
	then
		read var_customizeinfo < $var_customize_telmex
		if [ 0 -eq $? ]
		then
			return 0
		fi
	fi
	
	#判断是否已经加密
	var_is_en=0
	
	cp -f $var_customize_file $var_customize_file_var_path

	var_str=$(hexdump $var_customize_file_var_path | grep 0000000)
	var_first_four=$(echo $var_str | cut -b 9-12)
	var_last_four=$(echo $var_str | cut -b 14-17)

	if [ $var_first_four == 0001 ]; then
		if [ $var_last_four == 0000 ]; then
			var_is_en=1
			
		else
			var_is_en=0
		fi
	else
		var_is_en=0
	fi
	
	if [ $var_is_en == 1 ]; then
		aescrypt2 1 $var_customize_file_var_path $var_customize_file_not_aes
		
		#sprint the spec content
		read var_customizeinfo < $var_customize_file_var_path
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	
		#deal for read end
		rm -rf $var_customize_file_var_path
	else
		#sprint the spec content
		read var_customizeinfo < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	fi

	return
}

function Customize_Check_ChooseXml_Tar()
{
    CheckChooseXml.sh
    [ ! $? == 0 ] && echo "ERROR::customize check choose_xml.tar.gz fail!" && return 1
    return 0
}

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
#
HW_Script_GetFtWord
[ ! $? == 0 ] && exit 1

#
HW_Script_GetCustomizeInfo
[ ! $? == 0 ] && exit 1

#检查choose_xml.tar.gz是否完整
var_check_choose_xml_result=0
Customize_Check_ChooseXml_Tar
[ ! $? == 0 ] && var_check_choose_xml_result=1

#非装备模式下仅输出binword,cfgword,typeword，避免一键式收集时打印敏感信息
if [ -e "/var/Equip.sh" ]; then
	if [ -f "/mnt/jffs2/customize_name" ]; then
		var_customize_name=`cat /mnt/jffs2/customize_name`
		echo "$var_binword $var_cfgword#$var_customize_name# $var_customizeinfo" 
	else
		echo "$var_binword $var_cfgword $var_customizeinfo" 
	fi
else
	if [ -f "/mnt/jffs2/customize_name" ]; then
		var_customize_name=`cat /mnt/jffs2/customize_name`
		echo "$var_binword $var_cfgword#$var_customize_name#" 
	else
		echo "$var_binword $var_cfgword" 
	fi
fi

if [ $var_check_choose_xml_result -eq 1 ]; then
    exit 1;
fi

echo "success!"

exit 0 
fi


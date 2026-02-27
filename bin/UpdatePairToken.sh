#! /bin/sh

#bin文件的路径
var_pack_temp_dir=/bin/

#全局变量
var_paircode=""
var_newpaircode=$5

# 定制信息文件
var_jffs2_customize_txt_file=/mnt/jffs2/customize.txt
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_file_tmp="/var/hw_boardinfo_tmp"
var_binword=""
var_cfgword=""
var_cfg_ft_word=""
var_ssid1=""
var_ssid2=""
var_ssid1_pwd=""
var_ssid2_pwd=""
var_adminpwd=""

Customize_Script_GetBoardinfoFtWord()
{
	var_binword=""
	var_cfg_ft_word=""
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
			var_cfg_ft_word=$obj_value;
		else 
			continue
		fi
	done < $var_boardinfo_file_tmp
	rm -f $var_boardinfo_file_tmp
}

#get feature word
HW_Script_GetFtWord()
{
	if [ -f $var_jffs2_customize_txt_file ];then
		read var_binword var_cfgword < $var_jffs2_customize_txt_file
		var_cfg_ft_word=`echo $var_cfgword | tr a-z A-Z | cut -d : -f1 `
	else
		Customize_Script_GetBoardinfoFtWord
	fi
	return
}

HW_Script_SetDatToFile()
{
	#decrypt
	$var_pack_temp_dir/aescrypt2 1 $1 $1"_tmp"
	if [ 0 -ne $? ]
	then
		varIsEncrypted=0
	else
		varIsEncrypted=1
	fi

	if [ "$var_cfg_ft_word" = "TRIPLETAP6PAIR" ]; then
		read -r  var_ssid1 var_ssid1_pwd var_ssid2 var_ssid2_pwd var_adminpwd var_paircode < $1
	else
		read -r  var_ssid1 var_ssid2 var_paircode < $1
	fi

	if [ 0 -ne $? ]
	then
		echo "ERROR::Failed to read customizepara info!"
		return 1
	fi

	if [ "$var_cfg_ft_word" = "TRIPLETAP6PAIR" ]; then
		echo $var_ssid1 $var_ssid1_pwd $var_ssid2 $var_ssid2_pwd $var_adminpwd $var_newpaircode > $1
	else
		echo $var_ssid1 $var_ssid2 $var_newpaircode > $1
	fi

	#encrypt
	if [ $varIsEncrypted -ne 0 ]
	then
		$var_pack_temp_dir/aescrypt2 0 $1 $1"_tmp"
	fi

	return 0
}

HW_Script_ChangeCustomize()
{
	if [ "$var_newpaircode" = "" ]; then
		echo "ERROR::New paircode is empty!"
		return 1
	fi

	if [ -f /mnt/jffs2/customizepara.txt ]
	then
		#对当前customizepara.txt的操作拷贝到var目录下进行，以减少flash写入机会
		rm -rf /var/customizepara_temp.txt
		cp -rf /mnt/jffs2/customizepara.txt /var/customizepara_temp.txt

		HW_Script_SetDatToFile /var/customizepara_temp.txt
		if [ 0 -ne $? ]
		then
			return 1
		fi

		cp -rf /var/customizepara_temp.txt /mnt/jffs2/customizepara.txt
	fi
}

HW_Script_WritePairKeyToCTree()
{
	target_ctree="$1"
	var_ctree="/var/target_ctree.xml"
	var_temp_ctree="/var/target_ctree_tmp.xml"
	var_node_pairToken="InternetGatewayDevice.X_HW_APTokenService"

	cp $target_ctree $var_ctree

	# decrypt var_default_ctre
	$var_pack_temp_dir/aescrypt2 1 $var_ctree $var_temp_ctree
	mv -f $var_ctree $var_ctree".gz"
	gunzip -f $var_ctree".gz"

	cfgtool set $var_ctree $var_node_pairToken PairToken $2

	#encrypt var_ctree
	gzip -f $var_ctree
	mv -f $var_ctree".gz" $var_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_ctree $var_temp_ctree

	cp $var_ctree $target_ctree
}

HW_Script_GetFtWord
if [ "$var_cfg_ft_word" = "TRIPLETAP6PAIR" ]; then
	var_newpaircode=$8
fi

HW_Script_ChangeCustomize
[ ! $? == 0 ] && exit 1

#将配对码写入ctree
echo "" > /var/notsavedata
chmod 666 /var/notsavedata
var_fullnewpaircode="485541574549$var_newpaircode"
HW_Script_WritePairKeyToCTree "/mnt/jffs2/hw_default_ctree.xml" "$var_fullnewpaircode"
HW_Script_WritePairKeyToCTree "/mnt/jffs2/hw_ctree.xml" "$var_fullnewpaircode"

echo "success!" && exit 0
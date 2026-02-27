#! /bin/sh

var_customize_path=/etc/wap/customize/common

var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_batch_file=/tmp/batch_file
var_jffs2_boardinfo_file="/mnt/jffs2/hw_boardinfo"

#bin文件的路径
var_pack_temp_dir=/bin/

var_gCfgWord=""
type_word_v5="COMMON COMMON2 EUCOMMON EUCOMMON2 NACOMMON NACOMMON2 COMMONEBG COMMONEBG2 EUCOMMONEBG EUCOMMONEBG2 NACOMMONEBG NACOMMONEBG2 CLOSETELNET CLOSETELNETEBG CLOSETELNETEBG2 CHINA CHINAEBG COMMON3 COMMON5 COMMONEBG3 COMMONEBG5"

HW_Script_getCfgwordV5()
{
	#检查boardinfo是否存在，不存在则返回错误
    if [ ! -f $var_jffs2_boardinfo_file ]; then
		return 1;
	fi
	
	while read line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
		if [ "0x0000001b" == $obj_id ];then
			var_gCfgWord=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
		fi
	done < $var_jffs2_boardinfo_file

}
HW_Script_Cfgtool_Set()
{      
	echo "set $2 $3 $4" >> $var_batch_file   
}

#判断一下，是否需要加密，该函数的第一个参数代表预配置是否需要加密
#para1 是否需要加密的标志 1：加密
#para2 要加密的ctree的路径
HW_Script_Encrypt()
{
    if [ $1 -eq 1 ]
    then
        gzip -f $2
        mv $2".gz" $2
        $var_pack_temp_dir/aescrypt2 0 $2 $2"_tmp"	
    fi
}  
 
HW_Script_Cfg_Add_Clone()
{
	#当前实例可能被删除了，在此做一下判断
	cfgtool find $1 $2        
	if [ 0 -ne $? ]
	then		     
		cfgtool add $1 $2 "NULL"
		if [ 0 -ne $? ]
		then
			echo "add $2 fail" 
		fi
	fi
	
	if [ -f $3 ]
    then
        cfgtool clone $1 $2 $3
		if [ 0 -ne $? ]
		then
			echo "Failed to clone" $2 
		fi          
    else
        echo "$3 not exist !" 
    fi 
}

HW_ChangeData()
{
	var_IsXmlEncrypted=0
	rm -rf $var_batch_file
	
    # decrypt var_ctree          
    $var_pack_temp_dir/aescrypt2 1 $1 $1"_tmp"
    if [ 0 -ne $? ]
    then
	    echo $1" Is not Encrypted!"  
	else        
		var_IsXmlEncrypted=1		
        mv $1 $1".gz"
	    gunzip -f $1".gz"	    
    fi
		
	var_telmex_X_HW_IPv6="InternetGatewayDevice.X_HW_Security.Firewall"		
	var_COMMONV5_DOS="InternetGatewayDevice.X_HW_Security.Dosfilter"		
	var_COMMONV5_X_HW_Security="InternetGatewayDevice.X_HW_Security"		
	
	#新增X_HW_Security.Firewal节点
    HW_Script_Cfg_Add_Clone $1 $var_telmex_X_HW_IPv6 /etc/wap/hw_firewall_v5.xml
	
	#设置X_HW_Security.Dos节点	
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "SynFloodEn" "1"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "IcmpEchoReplyEn" "0"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "IcmpRedirectEn" "1"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "LandEn" "1"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "SmurfEn" "1"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "WinnukeEn" "1"
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_DOS "PingSweepEn" "0"
			
	HW_Script_Cfgtool_Set $1 $var_COMMONV5_X_HW_Security "X_HW_FirewallGeneralLevel" "4"
				
	cfgtool batch $1 $var_batch_file
	if [ 0 -ne $? ]
	then
		echo "Failed to set parameters!"
		return 1
	fi
	
	rm -rf $var_batch_file
	
	#encrypt var_ctree
	HW_Script_Encrypt $var_IsXmlEncrypted $1
	
	rm -rf /mnt/jffs2/script.tar.gz /mnt/jffs2/script/
		
	return 0
}

HW_Script_ChangeCTree()
{
    #通过脚本更改/mnt/jffs2/hw_default_ctree.xml文件
    if [ -f $var_default_ctree ]
    then
		#对当前ctree做操作
        cp -rf $var_default_ctree $var_temp_ctree
		
        HW_ChangeData $var_temp_ctree
	       
        cp -rf $var_temp_ctree $var_default_ctree
		rm -rf $var_temp_ctree	
    fi
}



$var_customize_path/recover_set_ssid2.sh

exit 0

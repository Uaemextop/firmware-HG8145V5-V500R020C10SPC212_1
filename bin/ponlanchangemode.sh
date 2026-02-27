#!/bin/sh
#bin文件的路径
var_pack_temp_dir=/bin/
#脚本执行LOG的存放路径
var_config_log=/mnt/jffs2/portalguide_config_log.txt
var_notsavedata=/var/notsavedata
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_boardinfo_file="/var/decrypt_boardinfo"
var_boardinfo=/mnt/jffs2/hw_boardinfo
var_boardinfo_tmp="/var/hw_boardinfo_tmp"
var_boardinfo_typeword=""
var_boardinfo_cfgword=""

#echo采用的是追加模式，若文件不存在会报错，故先进行判断
HW_Script_CreateLogFile()
{    
    if [ ! -f "$var_config_log" ]
    then
        touch $var_config_log
    fi
}

HW_Script_CreateNotSaveDataFile()
{    
	if [ ! -f "$var_notsavedata" ]
    then
        touch $var_notsavedata
    fi
}

GetboardinfoTypeWord()
{
    boardinfo_encrypt_support=`GetFeature FT_SUPPORT_BOARDINFO_ENCRYPT`
    if [ $boardinfo_encrypt_support = 1 ]; then
        cp -f $var_boardinfo_file $var_boardinfo_tmp
    else
        cp -f $var_boardinfo $var_boardinfo_tmp
    fi

    #记录boardinfo中的typeword 
    while read line;
    do
        obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
        obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`

        if [ "0x0000001b" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            var_boardinfo_cfgword=$obj_value;
        fi

        if [ "0x00000035" == $obj_id ];then
            obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
            var_boardinfo_typeword=$obj_value
            continue
        fi
    done < $var_boardinfo_tmp
    return
} 

HW_Script_ChangedefaultCTree()
{
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/hw_default_ctree.xml ]
    then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/hw_default_ctree.xml /var/hw_default_ctree_tmp.xml
        cp -rf /var/hw_default_ctree_tmp.xml /mnt/jffs2/hw_ctree.xml
        rm -rf /var/hw_default_ctree_tmp.xml
    fi
}

HW_Script_ChangedefaultCTree2()
{
    #通过脚本更改/mnt/jffs2/hw_ctree.xml文件
    if [ -f /mnt/jffs2/hw_default_ctree2.xml ]
    then
        #对当前ctree做操作
        cp -rf /mnt/jffs2/hw_default_ctree2.xml /var/hw_default_ctree2_tmp.xml
        cp -rf /var/hw_default_ctree2_tmp.xml /mnt/jffs2/hw_ctree.xml
        rm -rf /var/hw_default_ctree2_tmp.xml
    fi
}

HW_Script_ChangeData()
{
    GetboardinfoTypeWord

    if [ $var_boardinfo_cfgword == "MDSTARNET" ] ; then
        if [ "$var_boardinfo_typeword" = "LAN" ] ; then
            HW_Script_ChangedefaultCTree2
        else
            HW_Script_ChangedefaultCTree
        fi
    fi

    if [ $var_boardinfo_cfgword == "SCSCHOOL" ] ; then
        if [ "$var_boardinfo_typeword" = "LAN" ] ; then
            HW_Script_ChangedefaultCTree
        else
            HW_Script_ChangedefaultCTree2
        fi
    fi
}

echo "begin to run script!!!"

HW_Script_CreateLogFile
    
echo "Begin execute:" "`date \"+%Y-%m-%d%t%H:%M:%S\"`" >> $var_config_log

HW_Script_CreateNotSaveDataFile
HW_Script_ChangeData

echo "End execute:  " "`date \"+%Y-%m-%d%t%H:%M:%S\"`" >> $var_config_log

echo "end to run script!!!"


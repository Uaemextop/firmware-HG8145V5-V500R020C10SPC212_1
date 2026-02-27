#! /bin/sh

mnt_jffs2_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_jffs2_boardinfo_file="/var/hw_boardinfo_cust_tmp"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_input_para_file="/var/input_para"
var_tmp_para_file="/var/tmppara"
var_typeword=""
var_bin_ft_word=""
var_cfg_ft_word=""
var_cfg_ft_word_choose=""
var_cfg_word_orig=""
var_cfg_ft_word_save=""
var_is_ENBG=0
var_country_code=""
boardinfo_encrypt_support=`GetFeature FT_SUPPORT_BOARDINFO_ENCRYPT`

GetCustomizePara()
{
    if [ ! -f "$var_input_para_file" ] ;then
        echo "ERROR::input para file is not existed."
            return 1
    fi
    
    while read line;
    do
        var_input_para=$line
    done < $var_input_para_file

    if [ ! -f "$var_tmp_para_file" ] ;then
        echo "ERROR::tmp customize para file is not existed."
            return 1
    fi

    read -r var_bin_ft_word var_cfg_ft_word var_cfg_ft_word_choose var_cfg_word_orig var_cfg_ft_word_save var_is_ENBG < $var_tmp_para_file
    if [ 0 -ne $? ]
    then
        echo "Failed to read tmp customize para info!"
        return 1
    fi
    return
}

#设置typeword字段
HW_Customize_Set_CFGTypeFile()
{
    #后面会进行检查，再次不检查boardinfo是否存在
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000035\" ; obj.value = \"'$1'\"/g' -i
    return 0
}

HW_Set_TypeWord()
{
    if [ -f /mnt/jffs2/typeword ]; then
        read -r var_typeword < /mnt/jffs2/typeword
    fi

    if [ -z "$var_typeword" ]
    then
        HW_Customize_Set_CFGTypeFile ""
    else
        HW_Customize_Set_CFGTypeFile "$var_typeword"
    fi
    return 0
}

HW_Customize_Check_PCCWMacCheck()
{
    # 如果是PCCW，需要进行WLAN MAC的校验
    if [ "$var_cfg_ft_word" = "PCCW3MAC" ] || [ "$var_cfg_ft_word" = "PCCW3MACWIFI" ] \
      || [ "$var_cfg_ft_word" = "PCCW4MAC" ] || [ "$var_cfg_ft_word" = "PCCW4MACWIFI" ] \
      || [ "$var_cfg_ft_word" = "PCCW2" ] || [ "$var_cfg_ft_word" = "PCCW2WIFI" ] \
      || [ "$var_cfg_ft_word" = "PCCWSMART" ]
    then
        pccwmaccheck $var_input_para
        var_pccwresult=$?
    else
        var_pccwresult=0
    fi

    return 0
}

HW_Check_Boardinfo()
{
    if [ -f $mnt_jffs2_boardinfo_file ]; then
        return 0;
    else
        echo "ERROR::$mnt_jffs2_boardinfo_file is not exist!"
        return 1;
    fi
}

# Set Country Code To Boardinfo
HW_Script_SetCountryCodeToBoardinfo()
{        
    if [ "$var_cfg_ft_word_temp" = "TDE2" ] || [ "$var_cfg_ft_word_temp" = "TDESME2" ] \
    || [ "$var_cfg_ft_word_temp" = "BZTLF2" ] \
    || [ "$var_cfg_ft_word_temp" = "BZTLFNA2" ] \
    || [ "$var_cfg_ft_word_temp" = "BZTLFNB2" ]; then
    {
        if [ "$var_cfg_ft_word_temp" = "TDE2" ] || [ "$var_cfg_ft_word_temp" = "TDESME2" ]; then
            var_country_code=$var_typeword
        elif [ "$var_cfg_ft_word_temp" = "BZTLF2" ] || [ "$var_cfg_ft_word_temp" = "BZTLFNA2" ] || [ "$var_cfg_ft_word_temp" = "BZTLFNB2" ]; then
            var_country_code=BR
        fi

        echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000043\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000043\" ; obj.value = \"'$var_country_code'\"/g' -i
    }
    fi

    return
}

# Check these customization which pon authen parameters has been configured during customization.
SkipClearPonAuth()
{
    if [ "$var_cfg_ft_word_temp" = "BYTEL" ] || \
       [ "$var_cfg_ft_word_temp" = "AISSINGLE" ] || \
       [ "$var_cfg_ft_word_temp" = "BRAZCLARO" ] || \
       [ "$var_cfg_ft_word_temp" = "IRAQO3" ] || \
       [ "$var_cfg_ft_word_temp" = "TRUE" ] || \
       [ "$var_cfg_ft_word_temp" = "TRUERG" ] || \
       [ "$var_cfg_ft_word_temp" = "TRUEVIDEO" ] || \
       [ "$var_cfg_ft_word_temp" = "AMNET" ] || \
       [ "$var_cfg_ft_word_temp" = "TM2" ] || \
       [ "$var_cfg_ft_word_temp" = "CQCNCATV" ] ; then
        return 1
    fi

    return 0
}

# 恢复hw_boardinfo的eponkey、snpassword、eponpwd、loid到默认空配置
HW_Script_Clear_PonAuthInfo()
{
    # PON parameters should NOT been cleared, if these parameters has been configured during customization.
    SkipClearPonAuth
    if [ $? == 1 ] ; then
        return 0
    fi

    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000003\" ; obj.value = \".*\"/obj.id = \"0x00000003\" ; obj.value = \"\"/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000004\" ; obj.value = \".*\"/obj.id = \"0x00000004\" ; obj.value = \"\"/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000005\" ; obj.value = \".*\"/obj.id = \"0x00000005\" ; obj.value = \"\"/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000006\" ; obj.value = \".*\"/obj.id = \"0x00000006\" ; obj.value = \"\"/g' -i
    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000016\" ; obj.value = \".*\"/obj.id = \"0x00000016\" ; obj.value = \"\"/g' -i

    return 0
}

# 通过cfgtool设置程序特征字和配置特征字，这个操作在装备资源校验完成后执行
HW_Set_Feature_Word()
{
    #程序特征字的ID为0x0000001a，配置特征字的ID为0x0000001b,
    #这个是跟DM的代码保持一致的，产品平台存在强耦合，不能随意更改

    #判断配置特征字是否以WIFI结尾，如果是则删除
    var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`
    if [ "$var_bin_ft_word" = "CMCC" ] && [ "$var_cfg_ft_word_temp" != "CMCC_RMS2" ] ; then
        var_cfg_ft_word_cmcc="$var_cfg_ft_word_temp"
        var_cfg_ft_word_temp=`echo "$var_cfg_ft_word_cmcc" | sed 's/2$//g'`

    fi

    #如果是免预配置，电信定制为E8C E8C，联通定制为COMMON UNICOM
    if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] ; then
        if [ "$var_bin_ft_word" = "E8C" ] ; then
            var_cfg_ft_word_temp="E8C"
        fi

        if [ "$var_bin_ft_word" = "CMCC" ];then
            var_cfg_ft_word_temp="CMCC"
        fi
        
        if [ "$var_bin_ft_word" = "CMCC_RMS" ];then
            var_cfg_ft_word_temp="CMCC_RMS"
        fi

        if [ "$var_bin_ft_word" = "BZTLF2" ];then
            var_cfg_ft_word_temp="BZTLF2"
        fi

        if [ "$var_cfg_ft_word" = "CHOOSE_UNICOMBRI" ];then
            var_cfg_ft_word_temp="UNICOMBRI"
        fi
    fi

    if [ "$var_cfg_ft_word_temp" = "CMCC_RMS2" ] ; then
        var_cfg_ft_word_temp="CMCC_RMS"
    fi

    if [ "$var_cfg_ft_word_temp" = "UNICOM2" ] ; then
        var_cfg_ft_word_temp="UNICOM"
    fi

    if [ "$var_cfg_word_orig" = "SONET_HN8255Ws" ] || [ "$var_cfg_word_orig" = "JAPAN_HN8255Ws" ]
    then
        var_cfg_ft_word_temp=$var_cfg_word_orig
    fi

    #检查boardinfo是否存在
    HW_Check_Boardinfo
    if [ ! $? == 0 ]
    then
        echo "ERROR::Failed to Check Boardinfo!"
        return 1
    fi

    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001a\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001a\" ; obj.value = \"'$var_bin_ft_word'\"/g' -i

    echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001b\" ; obj.value = \"'$var_cfg_ft_word_temp'\"/g' -i
	echo $var_bin_ft_word $var_cfg_ft_word_temp > /var/tmpbinftwordsave
    #根据配置特征字后是否带_ENBG判断其是否为企业网ONT，企业网为@EN#Common&，其它运营商为@CN#Common&
    if [ 1 == $var_is_ENBG ];then
        echo $var_jffs2_boardinfo_file | xargs sed 's/^obj.id = \"0x0000003a\".*$/obj.id = \"0x0000003a\" ; obj.value = \"\@EN\#Common\&\";/g' -i
    else
        echo $var_jffs2_boardinfo_file | xargs sed 's/^obj.id = \"0x0000003a\".*$/obj.id = \"0x0000003a\" ; obj.value = \"\@CN\#Common\&\";/g' -i
    fi

    #保存程序特征字和配置特征字到文件/mnt/jffs2/customize.txt，getcustomize.sh从这个文件中读取，为了保证boardinfo能够完全写入，需要放在最后面
    echo $var_bin_ft_word $var_cfg_ft_word_save > $var_jffs2_customize_txt_file

    HW_Script_SetCountryCodeToBoardinfo

    HW_Script_Clear_PonAuthInfo

}

GetCustomizePara

#/mnt/jffs2目录下的不是自己的文件不能通过sed -i命令操作，先将hw_boardinfo拷贝到var目录下操作
cp -f $mnt_jffs2_boardinfo_file $var_jffs2_boardinfo_file

if [ $? -ne 0 ]; then
    echo "ERROR::Copy Boardinfo failed!"
    return 1
fi

HW_Set_TypeWord
if [ -f /mnt/jffs2/typeword_bak ]; then
    rm -f /mnt/jffs2/typeword_bak
fi

#pccw3mac pccw4mac定制中需进行wlanmac的校验
HW_Customize_Check_PCCWMacCheck $var_input_para
if [ 0 -eq $var_pccwresult ]
then
    HW_Set_Feature_Word
    if [ ! $? == 0 ]
    then
        echo "ERROR::Failed to set Feature Word!"
    return 1
fi
elif [ 1 -eq $var_pccwresult ]
then
    echo "ERROR::input para number is not enough!"
    return 1
elif [ 2 -eq $var_pccwresult ]
then
    echo "ERROR::SSIDMAC fail!"
    return 1
else
    echo "ERROR::customize fail!"
    return 1
fi

#结束对临时hw_boardinfo的写入操作后，先将/mnt/jffs2/hw_boardinfo文件清空，再将var目录下的hw_boardinfo里面的内容写入/mnt/jffs2/hw_boardinfo
: > $mnt_jffs2_boardinfo_file

cat $var_jffs2_boardinfo_file >> $mnt_jffs2_boardinfo_file
rm -f $var_jffs2_boardinfo_file

#boardinfo是加密的，在解密使用完后，拷贝到/var/下并通知DM进行加密
if [ $boardinfo_encrypt_support = 1 ]; then
    cp -f /mnt/jffs2/hw_boardinfo /var/decrypt_boardinfo
    cp -f /mnt/jffs2/hw_boardinfo /var/decrypt_boardinfo.bak
else
    cp -f /mnt/jffs2/hw_boardinfo /mnt/jffs2/hw_boardinfo.bak
fi

exit 0

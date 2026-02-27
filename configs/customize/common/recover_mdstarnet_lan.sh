#! /bin/sh
var_customize_path=/etc/wap/customize
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/var/hw_boardinfo_cust_tmp"
var_customize_file=/var/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree_var=/var/hw_default_ctree.xml
var_default_ctree2_var=/var/hw_default_ctree2.xml
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_default_ctree2=/mnt/jffs2/customize_xml/hw_default_ctree2.xml
var_pack_temp_dir=/bin/
var_batch_file=/tmp/batch_file
var_batch_file2=/tmp/batch_file2
var_temp_ctree_var=/var/hw_temp_ctree.xml
var_temp_ctree2_var=/var/hw_temp_ctree2.xml

var_ssid1=""
var_ssid2=""
var_ssid1pwd=""
var_ssid2pwd=""

#/mnt/jffs2目录下的不是自己的文件不能通过sed -i命令操作，先将hw_boardinfo拷贝到var目录下操作
cp -f $var_boardinfo_file $var_boardinfo_temp

if [ $? -ne 0 ]; then
    echo "ERROR::Copy Boardinfo failed!"
    return 1
fi

#MDSTARNET定制要求HG8145V5 LAN1口作为上行口
echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000001\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000001\" ; obj.value = \"3\"/g' -i
echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x00000039\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x00000039\" ; obj.value = \"0x00000001\"/g' -i
echo $var_boardinfo_temp | xargs sed 's/obj.id = \"0x0000003c\" ; obj.value = \"[a-zA-Z0-9_-]*\"/obj.id = \"0x0000003c\" ; obj.value = \"0x00000001\"/g' -i

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
    read -r var_ssid1 var_ssid1pwd var_ssid2 var_ssid2pwd < $var_customize_file
    if [ 0 -ne $? ]
    then
        echo "Failed to read spec info!"
        return 1
    fi
    return
}

HW_Script_Cfgtool_Set()
{
    echo "set $2 $3 $4" >> $var_batch_file
}
HW_Script_Cfgtool_Set2()
{
    echo "set $2 $3 $4" >> $var_batch_file2
}

# set customize data to file
HW_Script_SetDatToFile()
{
    var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
    var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
    var_node_ssid2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
    var_node_wpa_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1

    # decrypt var_default_ctre
    cp -f $var_default_ctree $var_default_ctree_var
    $var_pack_temp_dir/aescrypt2 1 $var_default_ctree_var $var_temp_ctree_var
    mv -f $var_default_ctree_var $var_default_ctree_var".gz"
    gunzip -f $var_default_ctree_var".gz"

    # decrypt var_default_ctre2
    cp -f $var_default_ctree2 $var_default_ctree2_var
    $var_pack_temp_dir/aescrypt2 1 $var_default_ctree2_var $var_temp_ctree2_var
    mv -f $var_default_ctree2_var $var_default_ctree2_var".gz"
    gunzip -f $var_default_ctree2_var".gz"

    HW_Script_Cfgtool_Set $var_default_ctree_var $var_node_ssid1 "SSID" $var_ssid1
    HW_Script_Cfgtool_Set $var_default_ctree_var $var_node_wpa_pwd1 "PreSharedKey" $var_ssid1pwd
    HW_Script_Cfgtool_Set $var_default_ctree_var $var_node_ssid2 "SSID" $var_ssid2
    HW_Script_Cfgtool_Set $var_default_ctree_var $var_node_wpa_pwd2 "PreSharedKey" $var_ssid2pwd


    HW_Script_Cfgtool_Set2 $var_default_ctree2_var $var_node_ssid1 "SSID" $var_ssid1
    HW_Script_Cfgtool_Set2 $var_default_ctree2_var $var_node_wpa_pwd1 "PreSharedKey" $var_ssid1pwd
    HW_Script_Cfgtool_Set2 $var_default_ctree2_var $var_node_ssid2 "SSID" $var_ssid2
    HW_Script_Cfgtool_Set2 $var_default_ctree2_var $var_node_wpa_pwd2 "PreSharedKey" $var_ssid2pwd


    cfgtool batch $var_default_ctree_var $var_batch_file
    if [ 0 -ne $? ]
    then
        echo "Failed to set parameters!"
        return 1
    fi

    cfgtool batch $var_default_ctree2_var $var_batch_file2
    if [ 0 -ne $? ]
    then
        echo "Failed to set parameters2!"
        return 1
    fi

    rm -rf $var_batch_file
    rm -rf $var_batch_file2

    #encrypt var_default_ctree
    gzip -f $var_default_ctree_var
    mv -f $var_default_ctree_var".gz" $var_default_ctree_var
    $var_pack_temp_dir/aescrypt2 0 $var_default_ctree_var $var_temp_ctree_var
    mv -f $var_default_ctree_var $var_default_ctree

    #encrypt var_default_ctree2
    gzip -f $var_default_ctree2_var
    mv -f $var_default_ctree2_var".gz" $var_default_ctree2_var
    $var_pack_temp_dir/aescrypt2 0 $var_default_ctree2_var $var_temp_ctree2_var
    mv -f $var_default_ctree2_var $var_default_ctree2
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


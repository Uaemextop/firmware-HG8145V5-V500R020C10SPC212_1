#! /bin/sh

pid=$$
ppid=`cat /proc/$pid/status | grep PPid | cut -d':' -f2`
ppid=${ppid:1}

comm=`cat /proc/$ppid/comm`

result=$(echo $comm | grep "customize_exec")
if [ "$result" == "" ]; then
    echo "father : $comm, customize_del_file check failed"
    return 1
fi

var_reg_info_file="/mnt/jffs2/RegStepDataInfo"
var_telnet_flag="/mnt/jffs2/ProductLineMode"
var_smartshowbssguide="/mnt/jffs2/smartshowbssguide"
var_smartshowuserguide="/mnt/jffs2/smartshowuserguide"
var_frameworkcheck_file="/mnt/jffs2/frameworkcheck"

# 删除UPNP增强标记文件
rm -rf /mnt/jffs2/UpnpExpandFirstInit
if [ -f /mnt/jffs2/vpn_route ] ; then
    rm -rf /mnt/jffs2/vpn_route
fi

# 删除dnsfilter hostlists文件
if [ -f /mnt/jffs2/dnsfilter_hostlist ] ; then
    rm -rf /mnt/jffs2/dnsfilter_hostlist
fi

# 删除第一次上线时记录文件
var_first_online_file="/mnt/jffs2/ontfirstonlinefile"
if [ -f $var_first_online_file ]
then
	rm -rf $var_first_online_file
fi

rm -f $var_reg_info_file
rm -f /mnt/jffs2/backup_ok

rm -f $var_telnet_flag
rm -f /mnt/jffs2/smooth_finish
rm -f /mnt/jffs2/equip_ip_enable
rm -f /mnt/jffs2/app/cplugin/cpluginstate
rm -rf /mnt/jffs2/app/cplugin/*
rm -f $var_smartshowbssguide
rm -rf $var_smartshowuserguide
rm -rf $var_frameworkcheck_file
rm -f /mnt/jffs2/first_start
if [ -f /mnt/jffs2/closecaptcha ]; then
    rm -f /mnt/jffs2/closecaptcha
fi

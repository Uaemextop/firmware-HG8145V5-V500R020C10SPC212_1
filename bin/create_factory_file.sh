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

version=`cat /etc/version`
echo $version > /mnt/jffs2/factory_file
chown 3008:2002 /mnt/jffs2/factory_file

#生成智能使用的定制标志文件，用于c插件启动时，重新恢复所有预置c插件
[[ -d /mnt/jffs2/app ]] && echo > /mnt/jffs2/app/customize_smt_flag

#生成 PDVDF定制 修改上行模式标志文件，用于判断是否能够修改 上行模式
echo "" > /mnt/jffs2/restore_manufacture_done
chown 3008:2002 /mnt/jffs2/restore_manufacture_done

#更换定制过程中生成的文件的属主
[[ -f /mnt/jffs2/customize_xml.tar.gz ]] && chown 3008:2002 /mnt/jffs2/customize_xml.tar.gz
[[ -d /mnt/jffs2/customize_xml ]] && chown 3008:2002 -R /mnt/jffs2/customize_xml
[[ -f /mnt/jffs2/choose_xml.tar.gz ]] && chown 3008:2002 /mnt/jffs2/choose_xml.tar.gz
[[ -d /mnt/jffs2/choose_xml ]] && chown 3008:2002 -R /mnt/jffs2/choose_xml
#定制过程中已委托ssmp去生成相关文件，此处再保障一下。生产装备定制流程下变更文件属主
[[ -f /mnt/jffs2/hw_default_ctree.xml ]] && chmod 660 /mnt/jffs2/hw_default_ctree.xml && chown 3008:2002 /mnt/jffs2/hw_default_ctree.xml
[[ -f /mnt/jffs2/hw_default_ctree2.xml ]] && chown 3008:2002 /mnt/jffs2/hw_default_ctree2.xml
[[ -f /mnt/jffs2/hw_ctree.xml ]] && chown 3008:2002 /mnt/jffs2/hw_ctree.xml
[[ -f /mnt/jffs2/ResolveFlag ]] && chown 3008:2002 /mnt/jffs2/ResolveFlag
[[ -f /mnt/jffs2/customize.txt ]] && chmod 660 /mnt/jffs2/customize.txt
[[ -f /mnt/jffs2/customizepara.txt ]] && chmod 660 /mnt/jffs2/customizepara.txt

if [ -f /mnt/jffs2/aplock ]; then
    chmod 664 /mnt/jffs2/aplock
fi

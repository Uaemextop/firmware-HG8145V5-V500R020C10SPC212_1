#! /bin/sh

# 定制信息文件
var_choose_files=/mnt/jffs2/choose/files
var_choose_xml_tar=/mnt/jffs2/choose_xml.tar.gz
var_choose_xml_check=/var/check_xml_tmp/
var_choose_xml_var=/var/check_xml_tmp/choose_xml/

# 不存在/mnt/jffs2/choose/files文件表示非choose版本，无需检测choose_xml.tar.gz完整性
if [ ! -f "$var_choose_files" ]
then
    exit 0
fi

if [ ! -f "$var_choose_xml_tar" ]
then
    echo "ERROR::/mnt/jffs2/choose_xml.tar.gz not exist."
    exit 1
fi

[[ -d $var_choose_xml_check ]] && rm -rf $var_choose_xml_check

mkdir $var_choose_xml_check
[ ! $? == 0 ] && exit 1

tar -xzf $var_choose_xml_tar -C $var_choose_xml_check
[ ! $? == 0 ] && [[ -d $var_choose_xml_check ]] && rm -rf $var_choose_xml_check && exit 1

Check_Choose_Xml_File()
{
    var_file_num=0
    var_cur_file_num=-1

    while read line
    do
        if [ $var_cur_file_num -eq -1 ]; then
            var_file_num=${line};
        else
            if [ ! -f ${var_choose_xml_var}${line} ]
            then
                echo ${var_choose_xml_var}${line}" not exist."
                return 1
            fi

            if [ ! -f ${var_choose_xml_var}${line}".crc" ]
            then
                echo ${var_choose_xml_var}${line}".crc not exist."
                return 1
            fi
            read var_file_crc < ${var_choose_xml_var}${line}".crc"
            var_cur_crc=`getfilecrc ${var_choose_xml_var}${line}`

            if [ "$var_cur_crc" != "$var_file_crc" ]; then
                echo ${var_choose_xml_var}${line}" File crc not match, file crc "${var_file_crc}", cur file crc "${var_cur_crc}
                return 1
            fi
        fi
        var_cur_file_num=$((++var_cur_file_num))
    done < $var_choose_files

    if [ ! $var_cur_file_num -eq $var_file_num ]; then
        echo "File num not match, file num "${var_file_num}", cur file num "${var_cur_file_num}
        return 1
    fi

    return 0
}

Check_Choose_Xml_File
[ ! $? == 0 ] && [[ -d $var_choose_xml_check ]] && rm -rf $var_choose_xml_check && exit 1

[[ -d $var_choose_xml_check ]] && rm -rf $var_choose_xml_check
exit 0

#!/bin/sh

var_tar_file=/mnt/jffs2/app/plugin_preload.tar.gz
var_ver_file=/mnt/jffs2/app/preload/version
var_tmp_dir=/var/tmp_preplugver
var_var_ver_file=$var_tmp_dir/plugin_preload/version
var_version=

if [ 0 -eq $# ]; then
	if [ -f $var_tar_file ]; then
		mkdir $var_tmp_dir 2&>/dev/null

		tar xzf $var_tar_file -C $var_tmp_dir 2&>/dev/null
		var_version=`cat $var_var_ver_file 2>/dev/null | tr -d ' \t\r\n'`

		rm -rf $var_tmp_dir
	elif [ -f $var_ver_file ]; then
		var_version=`cat $var_ver_file 2>/dev/null | tr -d ' \t\r\n'`
	else
		:
	fi

	var_pos_vrc=`expr "$var_version" : "V[0-9]\{1,3\}R[0-9]\{1,3\}C[0-9]\{1,3\}"`
	var_pos_spc=`expr "$var_version" : ".*SPC[0-9]\{1,3\}"`
	
	if [ $var_pos_spc -le 0 ]; then
		echo $var_version
		return 0
	fi

	var_len_spc=$(( $var_pos_spc - $var_pos_vrc ))
	
	var_vrc=${var_version::$var_pos_vrc}
	var_spc=${var_version:$var_pos_vrc:$var_len_spc}
	var_suff=${var_version:$var_pos_spc}
	
	if [ ${#var_suff} -le 11 ]; then
		var_suff=`echo ${var_suff::1} | tr -d [0-9]`
	elif [ ${#var_suff} -eq 12 ]; then
		if [ "X${var_suff::1}" = "XT" ]; then
			var_spc=${var_spc}T
		fi
		var_suff=`echo ${var_suff:1:1} | tr -d [0-9]`
	elif [ ${#var_suff} -gt 12 ]; then
		var_suff=${var_suff:$(( ${#var_suff} - 11 )):1}
		var_suff=`echo ${var_suff} | tr -d [0-9]`
	else
		:
	fi
	
	echo "version: $var_vrc$var_spc$var_suff"

    return 0;
else
    echo "ERROR::input para is not right!";
    return 1;
fi
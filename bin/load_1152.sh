#!/bin/sh
#GPON软转KO加载脚本

target=/mnt/jffs2

path_cfg=/etc/wap

path_ko=/lib/modules/wap

remote_list="wifi_debug.ko \
			hi1152_wifi.ko \
			hi1152_plat.ko \
			FIRMWARE.bin \
			cfg_device_hisi.ini"

local_list="/var/cfg_ont_hisi.ini \
			$path_cfg/wifi_cfg \
			$path_cfg/cfg_device_hisi.ini \
			$path_ko/FIRMWARE.bin \
			$path_ko/hi1152_plat.ko \
			$path_ko/hi1152_wifi.ko \
			$path_ko/wifi_debug.ko"

if [ $1 = "clear" ]; then
	rm *.ko
	echo "clear 1152 *.ko"
	rm *.ini
	echo "clear 1152 *.ini"
	rm wifi_cfg
	echo "clear wifi_cfg"
	rm FIRMWARE.bin
	echo "clear FIRMWARE.bin"
	rm $target/replace_ko
	echo "remove replace_ko"
	exit
elif [ $1 = "remote" ]; then
	echo "loading files start..."
	
	cp /var/cfg_ont_hisi.ini $target
	echo "copy /var/cfg_ont_hisi.ini to $target"
	cp /etc/wap/wifi_cfg $target
	echo "copy /etc/wap/wifi_cfg to $target"
	
	for file in $remote_list;
	do
		tftp -gr $file $2
		echo "load $file success"
	done
	
	echo "loading files end."
elif [ $1 = "local" ]; then
	echo "copy start..."
	
	for file in $local_list;
	do
		cp $file $target
		echo "copy $file to $target"
	done
	
	echo "copy end."
fi

touch $target/replace_ko
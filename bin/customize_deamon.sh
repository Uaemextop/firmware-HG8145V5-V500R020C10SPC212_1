#! /bin/sh

var_bin_word=$(echo $1 | tr a-z A-Z)
var_cfg_word=$(echo $2 | tr a-z A-Z)

#装备模式下不能进行定制
if [ -e /mnt/jffs2/Equip.sh ]; then
	echo "ERROR::Equip mode is on, customized command cannot be executed!"
	exit 1
fi

# 参数检测
if [ -z "$var_bin_word" ] || [ -z "$var_cfg_word" ]
	then
		echo "ERROR::The binfeature word and cfgword should not be null!"
        exit 1
fi

customize.sh $* > /var/customize_result.log &
cp /var/customize_result.log /mnt/jffs2/customize_result.log -f > /dev/null 2>&1

echo "success!" && exit 0

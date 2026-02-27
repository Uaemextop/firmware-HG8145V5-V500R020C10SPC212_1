#!/bin/sh
# cat 封装，只能读取/var、 /proc、 /tmp 目录下面的文件内容
if [ -f /mnt/jffs2/hw_iotboardtype ];then
	rm -f /mnt/jffs2/hw_iotboardtype
fi

if [ -f /mnt/jffs2/hw_iotimagetype ];then
	rm -f /mnt/jffs2/hw_iotimagetype
fi

if [ -f /mnt/jffs2/hw_iot0302code ];then
	rm -f /mnt/jffs2/hw_iot0302code
fi

if [ -f /mnt/jffs2/app/hw_iotboardtype ];then
	rm -f /mnt/jffs2/app/hw_iotboardtype
fi

if [ -f /mnt/jffs2/app/hw_iotimagetype ];then
	rm -f /mnt/jffs2/app/hw_iotimagetype
fi


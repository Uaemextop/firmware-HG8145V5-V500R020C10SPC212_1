#!/bin/sh
#打开dsp下行调试消息

if [ $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	echo "debug rtp stack {[0,65535]} {[0,65535]}"
	exit 1
fi

if [ $1 -ge 0 -a $1 -le 65535 ] && [ $2 -ge 0 -a $2 -le 65535 ]; 
then	
	sndhlp 0 0x2000e158 0x58 8 $1 $2
    exit 0
fi

echo "ERROR::input para is not right!"
echo "debug rtp stack {[0,65535]} {[0,65535]}"
exit 1
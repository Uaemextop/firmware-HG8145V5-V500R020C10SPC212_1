#!/bin/sh
#打开dsp下行调试消息

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	echo "debug dsp down msg {[0,1]}"
	exit 1
fi

if [ $1 -ge 0 -a $1 -le 1 ]; 
then	
	sndhlp 0 0x2000e125 0x25 4 $1
    exit 0
fi

echo "ERROR::input para is not right!"
echo "debug dsp down msg {[0,1]}"
exit 1
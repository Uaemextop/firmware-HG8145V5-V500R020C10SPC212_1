#!/bin/sh
#打开dsp下行调试消息

if [ $# -ne 2 ];
then
	echo "ERROR::input para is not right!"
	echo "debug sample mediastar {[0,7]} {[0,9]}"
	exit 1
fi

if [ $1 -ge 0 -a $1 -le 7 ] && [ $2 -ge 0 -a $2 -le 9 ]; 
then	
	sndhlp 0 0x2000e159 0x59 264 0 8 $1 $2
    exit 0
fi

echo "ERROR::input para is not right!"
echo "debug sample mediastar {[0,7]} {[0,9]}"
exit 1
#!/bin/sh
#打开dsp下行调试消息

if [ $# -ne 1 ];
then
	echo "ERROR::input para is not right!"
	echo "display dsp channel status {[0,3]}"
	exit 1
fi

if [ $1 -ge 0 -a $1 -le 3 ]; 
then	
	sndhlp 0 0x2000e12e 0x2e 12 0 0 $1
    exit 0
fi

echo "ERROR::input para is not right!"
echo "display dsp channel status {[0,3]}"
exit 1
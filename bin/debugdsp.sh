#!/bin/sh
#打开dsp调试消息

if [ $# -ne 3 ];
then
	echo "ERROR::input para is not right!"
	echo "debug dsp msg {[0,49]} {[0,3]} {[0,1]}"
	exit 1
fi

if [ $1 -ge 0 -a $1 -le 49 ] && [ $2 -ge 0 -a $2 -le 3 ] && [ $3 -ge 0 -a $3 -le 1 ]; 
then	
	sndhlp 0 0x20000000 0 12 $1 $2 $3
    exit 0
fi

echo "ERROR::input para is not right!"
echo "debug dsp msg {[0,49]} {[0,3]} {[0,1]}"
exit 1
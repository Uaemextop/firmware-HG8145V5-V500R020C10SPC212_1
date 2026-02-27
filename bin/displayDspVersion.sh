#!/bin/sh
#打开dsp下行调试消息

if [ 0 -eq $# ]; then
	sndhlp 0 0x2000e145 0x45 0 0 0;
    return 0;
else
    echo "ERROR::input para is not right!";
    return 1;
fi
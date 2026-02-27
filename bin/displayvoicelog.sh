#!/bin/sh
#≤Èø¥”Ô“Ùlog

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    return 1;
else
    rm -f /var/log_tmp_voicelog
    cp -f /proc/wap_proc/voice_log /var/log_tmp_voicelog
    ConvertLog2Dst /var/log_tmp_voicelog /var/log_tmp_voicelog1
    cat /var/log_tmp_voicelog1
    rm -f /var/log_tmp_voicelog1
    rm -f /var/log_tmp_voicelog
    return 0;
fi
#!/bin/sh
# cpu占用率超门限log文件
cpu_usage_log=/var/cpu_usage.log
# 若log文件没有超大，则继续记录log
record_sys_log()
{
    if [ -f $cpu_usage_log ]; then
        file_size=`ls -lt $cpu_usage_log | awk '{print $5}'`
        if [ $file_size -gt $((10 * 1024 * 1024)) ]; then
            return
        fi
    fi
    echo "************************************************" >> $cpu_usage_log
    date >> $cpu_usage_log
    echo "************************************************" >> $cpu_usage_log
    top -b -n 1 >> $cpu_usage_log
    wap.ssp.ps >> $cpu_usage_log
}
# 检测cpu占用率，若超门限记录log
check_cpu_usage()
{
    cpu_idle=`top -b -n 1 | grep 'idle' | grep -v grep | awk '{print $8}' | sed 's/\%//g'`
    cpu_used=`echo | awk "{print (100 - $cpu_idle) * 100}"`
    cpu_threshold=`echo | awk "{print $1 * 100}"`
    if [ $cpu_used -ge $cpu_threshold ]; then
        record_sys_log
    fi
}
# 第1个参数为检测时间间隔，默认10s
expr $1 + 0 &> /dev/null
if [ $? -eq 0 ]; then
    interval=$1
    if [ $interval -lt 1 ]; then
        interval=10
    fi
else
    interval=10
fi
# 第2个参数为cpu使用率门限，默认95%
expr $2 + 0 &> /dev/null
if [ $? -eq 0 ]; then
    threshold=$2
    if [ $threshold -lt 1 ] || [ $threshold -gt 100 ]; then
        threshold=95
    fi
else
    threshold=95
fi
# 删除已存在的log文件
if [ -f $cpu_usage_log ]; then
    rm $cpu_usage_log
fi
# 后台开始检测cpu占用率
while true; do
    check_cpu_usage $threshold
    sleep $interval
done &

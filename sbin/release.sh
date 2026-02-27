#!/bin/sh
# 清理所有业务进程，将系统初始化为开始状态，只保留KO

# killall dhcpc
killall -23 dhcpc
echo "Dhcp4 Release!"

#killall dhcp6c
killall -15 dhcp6c
echo "Dhcp6 Release!"

#killall pppd
killall -15 pppd
echo "pppd Terminal!"

if [ "$1" == "reboot" ]; then
    #killall ctrg_m
    killall -12 ctrg_m
    #echo "ctrg_m Terminal!"
fi

sleep 0.5

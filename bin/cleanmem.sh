#!/bin/sh

KillProcess()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -9 $pid
        fi
        echo "Done!"
}

KillProcessNormal()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -15 $pid
        fi
        echo "Done!"
}

KillProcessFivetimeNormal()
{
        count=0
        while [ $count -lt 5 ]; do
        #echo $count
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -15 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

KillProcessFivetime()
{
        count=0
        while [ $count -lt 5 ]; do
        #echo $count
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -9 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

CheckProcess()
{
        # kill vspa's watchdog
        KillProcessFivetime watchproc.sh

        # kill vspa
        KillProcessFivetime voice_h248sip
        #KillProcessFivetime vspa_sip
        KillProcessFivetime voice_sip

        # kill omci
        KillProcessFivetime omci

        # kill oam
        KillProcessFivetime oam

        # kill amp
        #KillProcessFivetime amp

        # kill smp_usb
        KillProcessFivetime smp_usb

        # kill hw_ldsp_user
        KillProcessFivetime hw_ldsp_user

        # kill dnsmasq
        KillProcessFivetime dnsmasq

        # kill dhcpd
        KillProcessFivetime dhcpd

        # kill dhcpc
        KillProcessFivetime dhcpc

        # kill upnpdmain
        KillProcessFivetime upnpdmain

        # kill hostapd
        KillProcessFivetime hostapd

        # kill apm
        KillProcessFivetime apm

        # kill igmp
        KillProcessFivetime igmp

        # kill ethoam
        KillProcessFivetime ethoam

        # kill bbsp
        #KillProcessFivetime bbsp

        # kill cwmp
        KillProcessFivetime cwmp

        # kill web
        KillProcessFivetime web

        # kill procmonitor
        KillProcessFivetimeNormal procmonitor
        
        KillProcessFivetimeNormal ldspcli
}

# close the kernel print
write_proc /proc/sys/kernel/printk 0

echo "=========================================="
echo "== Start clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps

echo "=========================================="

echo "Start kill process ! "

echo > /var/cleanmemflag
echo "***[echo > /var/cleanmemflag]***"

# kill procmonitor
KillProcessNormal procmonitor

# kill osgi_proxy java
touch /var/osgi_stop
KillProcess osgi_proxy
KillProcess java

# kill web
KillProcess web

# kill cwmp
KillProcess cwmp

# kill vspa's watchdog
KillProcess watchproc.sh

# kill vspa
killall voice_h248sip
KillProcess voice_h248sip
killall voice_sip
KillProcess voice_sip

# kill omci
KillProcess omci

# kill omci
KillProcess oam

# kill amp
#KillProcess amp

# kill smp_usb
KillProcess smp_usb

# kill hw_ldsp_user
KillProcess hw_ldsp_user

# kill dnsmasq
KillProcess dnsmasq

# kill dhcpd
KillProcess dhcpd

# kill apm
KillProcess apm

# kill igmp
KillProcess igmp

# kill ethoam
KillProcess ethoam

# kill bbsp
#KillProcess bbsp

KillProcess ldspcli

KillProcess aging

KillProcess radvd

KillProcess dhcp6s

#KillProcess wifi

KillProcess usb_mngt

KillProcess app_nlc

KillProcess app_acs

KillProcess app_sdt

KillProcess wificli

#bin6µ¥°åÉ¾³ýcmsºÍcommºÍlsvd
is_bin6_bin=$(GetFeature FT_WEB_MAINPAGE_CUT)
if [ "$is_bin6_bin" = "1" ];then
    KillProcess cms
    KillProcess comm
    KillProcess lsvd
fi

echo "Kill process done! "

# Drop page cache
echo -n "Start drop page cache ...... "
write_proc /proc/sys/vm/drop_caches 3
echo "Done!"

echo 1 > /proc/sys/vm/overcommit_memory

echo "=========================================="
echo "== End clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps


# Open the kernel print
while true; do sleep 10; write_proc /proc/sys/kernel/printk 4; break; done &
while true; do sleep 10; CheckProcess; break; done &

# return 0 to system for other application to get the status
return 0
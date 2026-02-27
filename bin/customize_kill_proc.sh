#! /bin/sh

#Java进程占用CPU过高，导致定制超时
procid="";

if [ -f /bin/osgi_proxy ] && [ ! -f /var/kill_java ]; then
    echo > /var/kill_java
    if [ ! -f /var/osgi_stop ]; then
        touch /var/osgi_stop
    fi

    procid=`pidof java`
    if [ "$procid" != "" ] ; then
        kill -9 $procid
    fi
fi

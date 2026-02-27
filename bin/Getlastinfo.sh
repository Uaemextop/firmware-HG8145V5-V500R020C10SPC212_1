#! /bin/sh

if [ -f /mnt/jffs2/lastsysinfo.tar.gz ]; then
    tar -zxvf /mnt/jffs2/lastsysinfo.tar.gz -C /var
    cat /var/lastsysinfo
    rm -rf /var/lastsysinfo
else
    if [ -f /var/lastsysinfo.tar.gz ]; then
        tar -zxvf /var/lastsysinfo.tar.gz -C /var
        cat /var/lastsysinfo
        rm -rf /var/lastsysinfo
    fi    
fi

exit 0

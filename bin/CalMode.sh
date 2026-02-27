#! /bin/sh

if [ 1 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
    if [ "$1" = "on" ]; then
       cp -f /bin/Cal.sh /mnt/jffs2/Cal.sh
    elif [ "$1" = "off" ]; then
         rm -f /mnt/jffs2/Cal.sh
    else
        echo "Input para wrong!"
        exit 1;
    fi
fi
sync
sleep 2
echo $1
exit 0

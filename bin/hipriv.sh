#!/bin/sh
#Usage: ./hipriv.sh "wlan0 create vap0"
write_proc /sys/hisys/hipriv "$1 "

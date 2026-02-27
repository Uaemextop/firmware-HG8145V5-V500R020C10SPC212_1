#! /bin/sh

	if [ $# -ne 0 ]; then
		echo "ERROR:Command is not right" && exit 1
	fi

	cat /proc/wlan0/sta_info	
	exit 0


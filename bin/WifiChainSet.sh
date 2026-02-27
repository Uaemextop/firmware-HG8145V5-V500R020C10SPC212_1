#! /bin/sh

	if [ $# -ne 1 ]; then
		echo "ERROR::input para is not right!" && exit 1
	fi
	
bin_wl()
{
    /bin/wl $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	    
	    exit 1
	  fi 
}
	
	echo "wl rxchain $1"
	bin_wl rxchain "$1"
	echo "wl up"
	/bin/wl up
	echo "wl txchain $1"
	bin_wl txchain "$1"
	echo "wl up"
	/bin/wl up
	echo "wl txpwr1 -1"
	/bin/wl txpwr1 -1
	echo "wl ssid"
	/bin/wl ssid ""
	
	exit 0
 

#! /bin/sh

bin_wl()
{
    /bin/wl $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	    
	    exit 1
	  fi 
}

	if [ $# -eq 0 ];then
		/bin/wl ssid ""
		exit 0
	elif [ $# -eq 1 ];then
		bin_wl ssid "$1"
		exit 0
	else
		echo "ERROR::input para is not right!"
		exit 1
	fi

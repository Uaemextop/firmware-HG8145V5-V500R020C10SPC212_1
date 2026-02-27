#! /bin/sh

paranum=9
id=`cat /proc/bus/pci/devices | cut -f2`
if [ "$id" == "18143091" -o "$id" == "18145390" -o "$id" == "18145392" ];then
	chipis5392="1"
else
	chipis5392=""
fi


wifidev=ra0
if [ "$chipis5392" == "" -a $1 == 2 ];then
	wifidev=rai0
fi

if [ $# -ne $paranum ]; then
	echo "ERROR::input para is not right!" $# $paranum && exit 1
fi

bin_iwpriv()
{
    /bin/iwpriv $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	    
	    exit 1
	  fi 
}

	echo "iwpriv $wifidev set ATEDA=00:11:22:33:44:55"
	/bin/iwpriv $wifidev set ATEDA=00:11:22:33:44:55
	echo "iwpriv $wifidev set ATESA=00:aa:bb:cc:dd:ee"
    /bin/iwpriv $wifidev set ATESA=00:aa:bb:cc:dd:ee
	echo "iwpriv $wifidev set ATEBSSID=00:11:22:33:44:55"
    /bin/iwpriv $wifidev set ATEBSSID=00:11:22:33:44:55
	if [ "$chipis5392" != "" ];then
		echo "iwpriv $wifidev set ATECHANNEL=$1"
		bin_iwpriv $wifidev set ATECHANNEL=$1
		echo "iwpriv $wifidev set ATETXMODE=$2"
		bin_iwpriv $wifidev set ATETXMODE=$2
		echo "iwpriv $wifidev set ATETXMCS=$3"
		bin_iwpriv $wifidev set ATETXMCS=$3
		echo "iwpriv $wifidev set ATETXBW=$4"
		bin_iwpriv $wifidev set ATETXBW=$4
		echo "iwpriv $wifidev set ATETXGI=$5"
		bin_iwpriv $wifidev set ATETXGI=$5
	    echo "iwpriv $wifidev set ATETXPOW0=$6"
	    bin_iwpriv $wifidev set ATETXPOW0=$6
	    echo "iwpriv $wifidev set ATETXPOW1=$7"
	    bin_iwpriv $wifidev set ATETXPOW1=$7
	    echo "iwpriv $wifidev set ATETXFREQOFFSET=$8"
	    bin_iwpriv $wifidev set ATETXFREQOFFSET=$8
	    echo "iwpriv $wifidev set ATETXLEN=1024"
	    /bin/iwpriv $wifidev set ATETXLEN=1024
	    echo "iwpriv $wifidev set ATETXCNT=100000000"
	    /bin/iwpriv $wifidev set ATETXCNT=100000000
	    echo "iwpriv $wifidev set ATETXANT=$9"
	    bin_iwpriv $wifidev set ATETXANT=$9
	else
		echo "iwpriv $wifidev set ATETXMODE=$2"
		bin_iwpriv $wifidev set ATETXMODE=$2
		echo "iwpriv $wifidev set ATETXMCS=$3"
		bin_iwpriv $wifidev set ATETXMCS=$3
		echo "iwpriv $wifidev set ATETXBW=$4"
		bin_iwpriv $wifidev set ATETXBW=$4
		echo "iwpriv $wifidev set ATETXGI=$5"
		bin_iwpriv $wifidev set ATETXGI=$5
	    echo "iwpriv $wifidev set ATETXLEN=$6"
	    bin_iwpriv $wifidev set ATETXLEN=$6
	    echo "iwpriv $wifidev set ATETXCNT=$7"
	    bin_iwpriv $wifidev set ATETXCNT=$7
		echo "iwpriv $wifidev set ATECHANNEL=$8"
		bin_iwpriv $wifidev set ATECHANNEL=$8
	    echo "iwpriv $wifidev set ATETXANT=$9"
	    bin_iwpriv $wifidev set ATETXANT=$9
	fi 

	exit 0
	

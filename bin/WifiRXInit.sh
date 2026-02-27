#! /bin/sh


num=8
id=`cat /proc/bus/pci/devices | cut -f2`
if [ "$id" == "18143091" -o "$id" == "18145390" -o "$id" == "18145392" ];then
	chipis5392="1"
else
	chipis5392=""
fi

if [ "$chipis5392" == "" ];then
    num=6
fi

if [ $# -ne $num ]; then
	echo "ERROR::input para is not right!" && exit 1
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

wifidev=ra0
if [ "$chipis5392" == "" -a $1 == 2 ];then
	wifidev=rai0
fi

if [ "$chipis5392" != "" ];then
	echo "iwpriv $wifidev set ATECHANNEL=$1"		
	bin_iwpriv $wifidev set ATECHANNEL=$1
    echo "iwpriv $wifidev set ResetCounter=$2"	
	bin_iwpriv $wifidev set ResetCounter=$2
	echo "iwpriv $wifidev set ATETXFREQOFFSET=$3"	
	bin_iwpriv $wifidev set ATETXFREQOFFSET=$3
	echo "iwpriv $wifidev set ATETXMODE=$4"	
	bin_iwpriv $wifidev set ATETXMODE=$4
	echo "iwpriv $wifidev set ATETXMCS=$5"	
	bin_iwpriv $wifidev set ATETXMCS=$5
	echo "iwpriv $wifidev set ATETXBW=$6"	
	bin_iwpriv $wifidev set ATETXBW=$6
	echo "iwpriv $wifidev set ATEFILTERENABLE=$7"	
	bin_iwpriv $wifidev set ATEFILTERENABLE=$7
	echo "iwpriv $wifidev set ATEFILTER=01:ef:4c:81:96:c1"	
	/bin/iwpriv $wifidev set ATEFILTER=01:ef:4c:81:96:c1
	echo "iwpriv $wifidev set ATERXANT=$8"	
	bin_iwpriv $wifidev set ATERXANT=$8
else
    echo "iwpriv $wifidev set ResetCounter=0"	
	/bin/iwpriv $wifidev set ResetCounter=0
	echo "iwpriv $wifidev set ATETXMODE=$2"	
	bin_iwpriv $wifidev set ATETXMODE=$2
	echo "iwpriv $wifidev set ATETXMCS=$3"	
	bin_iwpriv $wifidev set ATETXMCS=$3
	echo "iwpriv $wifidev set ATETXBW=$4"	
	bin_iwpriv $wifidev set ATETXBW=$4
	echo "iwpriv $wifidev set ATERXANT=$5"	
	bin_iwpriv $wifidev set ATERXANT=$5
	echo "iwpriv $wifidev set ATECHANNEL=$6"		
	bin_iwpriv $wifidev set ATECHANNEL=$6
fi
	exit 0
	

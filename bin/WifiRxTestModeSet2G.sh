#! /bin/sh

	if [ $# -ne 9 ]; then
		echo "ERROR::input para is not right!" && exit 1
	fi

bin_wl()
{
    /bin/wl $@
    result=$?
	  if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!" && exit 1
	  fi 
}

echo "wl -i wl$1 down"
bin_wl -i wl$1 down
echo "wl -i wl$1 down"
bin_wl -i wl$1 down
echo "wl -i wl$1 band b"
bin_wl -i wl$1 band b
echo "wl -i wl$1 mimo_txbw $2"
bin_wl -i wl$1 mimo_txbw $2
echo "wl -i wl$1 bi 65535"
bin_wl -i wl$1 bi 65535
echo "wl -i wl$1 chanspec -c $3 -b 2 -w $4 -s $5"
bin_wl -i wl$1 chanspec -c $3 -b 2 -w $4 -s $5

if [ $7 -eq 54 ];
 	then
	echo "wl -i wl$1 nrate $6 $7"
	bin_wl -i wl$1 nrate $6 $7
elif [ $7 -eq 7 ];
	then
	echo "wl -i wl$1 nrate $6 $7 -s 0"
	bin_wl -i wl$1 nrate $6 $7 -s 0
else
	echo "ERROR::input para is not right!" && exit 1
fi

echo "wl -i wl$1 rxchain $8"
bin_wl -i wl$1 rxchain $8
echo "wl -i wl$1 txchain $9"
bin_wl -i wl$1 txchain $9
echo "wl -i wl$1 up"
bin_wl -i wl$1 up
echo "wl -i wl$1 isup"
bin_wl -i wl$1 isup
echo "wl -i wl$1 join rftest imode infra"
bin_wl -i wl$1 join rftest imode infra
echo "wl -i wl$1 ssid"
/bin/wl -i wl$1 ssid ""
echo "wl -i wl$1 mac 00:ef:4c:81:96:c1"
bin_wl -i wl$1 mac 00:ef:4c:81:96:c1
echo "wl -i wl$1 macmode 2"
bin_wl -i wl$1 macmode 2

exit 0

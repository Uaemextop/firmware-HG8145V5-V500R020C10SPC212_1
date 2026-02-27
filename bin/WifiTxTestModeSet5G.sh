#! /bin/sh

	if [ $# -ne 7 ]; then
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

echo "wl -i wl$1 pkteng_stop tx"
bin_wl -i wl$1 pkteng_stop tx
echo "wl -i wl$1 down"
bin_wl -i wl$1 down
echo "wl -i wl$1 down"
bin_wl -i wl$1 down
echo "wl -i wl$1 rxchain 7"
bin_wl -i wl$1 rxchain 7
echo "wl -i wl$1 band auto"
bin_wl -i wl$1 band auto
echo "wl -i wl$1 mimo_txbw $2"
bin_wl -i wl$1 mimo_txbw $2
echo "wl -i wl$1 chanspec $3"
bin_wl -i wl$1 chanspec $3

if [ $5 -eq 54 ];
 	then
	echo "wl -i wl$1 nrate $4 $5"
	bin_wl -i wl$1 nrate $4 $5
elif [ $5 -eq 7 ];
	then
	echo "wl -i wl$1 nrate $4 $5 -s 0"
	bin_wl -i wl$1 nrate $4 $5 -s 0
else 
	echo "ERROR::input para is not right!" && exit 1
fi

echo "wl -i wl$1 rxchain $6"
bin_wl -i wl$1 rxchain $6
echo "wl -i wl$1 txchain $7"
bin_wl -i wl$1 txchain $7
echo "wl -i wl$1 up"
bin_wl -i wl$1 up
echo "wl -i wl$1 isup"
bin_wl -i wl$1 isup
echo "wl -i wl$1 txpwr1 -1"
bin_wl -i wl$1 txpwr1 -1
echo "wl -i wl$1 phy_forcecal 1"
bin_wl -i wl$1 phy_forcecal 1
echo "wl -i wl$1 ssid"
/bin/wl -i wl$1 ssid ""

exit 0

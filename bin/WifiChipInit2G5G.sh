#! /bin/sh

	if [ $# -ne 1 ]; then
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
echo "killall -9 acsd"
/bin/killall -9 acsd
echo "wl -i wl$1 nphy_txpwrctrl 1"
/bin/wl -i wl$1 nphy_txpwrctrl 1
echo "wl -i wl$1 phy_watchdog 0"
bin_wl -i wl$1 phy_watchdog 0
echo "wl -i wl$1 mpc 0"
bin_wl -i wl$1 mpc 0
echo "wl -i wl$1 down"
bin_wl -i wl$1 down
echo "wl -i wl$1 interference 0"
/bin/wl -i wl$1 interference 0
echo "wl -i wl$1 mbss 0"
bin_wl -i wl$1 mbss 0
echo "wl -i wl$1 ampdu 0"
bin_wl -i wl$1 ampdu 0
echo "wl -i wl$1 wsec 0"
bin_wl -i wl$1 wsec 0
echo "wl -i wl$1 mimo_bw_cap 1"
bin_wl -i wl$1 mimo_bw_cap 1
echo "wl -i wl$1 bi 65535"
bin_wl -i wl$1 bi 65535
echo "wl -i wl$1 up"
bin_wl -i wl$1 up
echo "wl -i wl$1 country ALL"
bin_wl -i wl$1 country ALL
echo "wl -i wl$1 tempsense_disable 1"
bin_wl -i wl$1 tempsense_disable 1
echo "wl -i wl$1 pkteng_stop tx"
bin_wl -i wl$1 pkteng_stop tx

exit 0

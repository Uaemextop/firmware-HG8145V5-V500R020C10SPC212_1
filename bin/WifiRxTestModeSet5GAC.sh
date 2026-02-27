#! /bin/sh

	if [ $# -ne 5 ]; then
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

echo "wl -i wl1 ap"
bin_wl -i wl1 ap
echo "wl -i wl1 ssid """
/bin/wl -i wl1 ssid ""
echo "wl -i wl1 down"
bin_wl -i wl1 down
echo "wl -i wl1 mpc 0"
bin_wl -i wl1 mpc 0
echo "wl -i wl1 ssid """
/bin/wl -i wl1 ssid ""
echo "wl -i wl1 down"
bin_wl -i wl1 down
echo "wl -i wl1 country ALL"
bin_wl -i wl1 country ALL
echo "wl -i wl1 wsec 0"
bin_wl -i wl1 wsec 0
echo "wl -i wl1 stbc_tx 0"
bin_wl -i wl1 stbc_tx 0
echo "wl -i wl1 stbc_rx 1"
bin_wl -i wl1 stbc_rx 1
echo "wl -i wl1 spect 0"
bin_wl -i wl1 spect 0
echo "wl -i wl1 bw_cap 5g 7"
bin_wl -i wl1 bw_cap 5g 7
echo "wl -i wl1 mbss 0"
bin_wl -i wl1 mbss 0
echo "wl -i wl1 frameburst 0"
bin_wl -i wl1 frameburst 0
echo "wl -i wl1 ampdu 0"
bin_wl -i wl1 ampdu 0
echo "wl -i wl1 bi 65535"
bin_wl -i wl1 bi 65535
echo "wl -i wl1 phy_watchdog 1"
bin_wl -i wl1 phy_watchdog 1
echo "wl -i wl1 down"
bin_wl -i wl1 down
echo "wl -i wl1 spatial_policy 1"
bin_wl -i wl1 spatial_policy 1
echo "wl -i wl1 txcore -s 1 -c $1"
bin_wl -i wl1 txcore -s 1 -c $1
echo "wl -i wl1 band a"
bin_wl -i wl1 band a
echo "wl -i wl1 chanspec $2"
bin_wl -i wl1 chanspec $2
echo "wl -i wl1 up"
bin_wl -i wl1 up
echo "wl -i wl1 phy_forcecal 1"
bin_wl -i wl1 phy_forcecal 1
echo "wl -i wl1 5g_rate $3 $4 -s 1 --ldpc -b $5"
bin_wl -i wl1 5g_rate $3 $4 -s 1 --ldpc -b $5

exit 0

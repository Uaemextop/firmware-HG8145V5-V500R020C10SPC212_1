#! /bin/sh

	if [ $# -ne 0 ]; then
		echo "ERROR:Command is not right" && exit 1
	fi

	echo "wl mpc 0"
	/bin/wl mpc 0
	echo "wl ssid"
	/bin/wl ssid ""
	echo "wl down"
	/bin/wl down
	echo "wl wsec 0"
	/bin/wl wsec 0
	echo "killall wps_monitor"
	killall wps_monitor
	echo "wl obss_coex 0"
	/bin/wl obss_coex 0
	echo "wl stbc_tx 0"
	/bin/wl stbc_tx 0
	echo "wl stbc_rx 1"
	/bin/wl stbc_rx 1
	echo "wl band auto"
	/bin/wl band auto
	echo "wl spect 0"
	/bin/wl spect 0
	echo "wl mimo_bw_cap 1"
	/bin/wl mimo_bw_cap 1
	echo "wl mbss 0"
	/bin/wl mbss 0
	echo "wl frameburst 0"
	/bin/wl frameburst 0
	echo "wl ampdu 0"
	/bin/wl ampdu 0
	echo "wl gmode auto"
	/bin/wl gmode auto
	echo "wl rxchain 3"
	/bin/wl rxchain 3
	echo "wl bi 65535"
	/bin/wl bi 65535
	echo "wl srl 1"
	/bin/wl srl 1
	echo "wl lrl 1"
	/bin/wl lrl 1
	echo "wl up"
	/bin/wl up
	sleep 0.5
	echo "wl stbc_tx 0"
	/bin/wl stbc_tx 0
	echo "wl stbc_rx 0"
	/bin/wl stbc_rx 0
	echo "wl tempsense_disable 1"
	/bin/wl tempsense_disable 1
	echo "wl interference_override 0"
	/bin/wl interference_override 0
	echo "wl txchain 3"
	/bin/wl txchain 3
	echo "wl phy_watchdog 0"
	/bin/wl phy_watchdog 0
	echo "wl sgi_tx 0"
	/bin/wl sgi_tx 0
	echo "wl ssid"
	/bin/wl ssid ""
	sleep 0.1
	echo "wl down"
	/bin/wl down
	echo "wl band auto"
	/bin/wl band auto

	exit 0


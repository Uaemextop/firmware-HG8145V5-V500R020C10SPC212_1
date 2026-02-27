#! /bin/sh

	if [ $# -ne 0 ]; then
		echo "ERROR:Command is not right" && exit 1
	fi

	echo "wl ap 1" 
	/bin/wl ap 1
	echo "wl nphy_txpwrctrl 1" 	
	wl nphy_txpwrctrl 1 
	echo "wl phy_watchdog 0" 
	/bin/wl phy_watchdog 0
	echo "wl mpc 0"	
	/bin/wl mpc 0
	echo "wl down" 	
	/bin/wl down 
	echo "wl interference 0" 
	/bin/wl interference 0
	echo "wl ampdu 0" 	
	/bin/wl ampdu 0 
	echo "wl wsec 0" 
	/bin/wl wsec 0 
	echo "wl mimo_bw_cap 1" 
	/bin/wl mimo_bw_cap 1 
	echo "wl bi 65535" 
	/bin/wl bi 65535 
	echo "wl up" 
	/bin/wl up 
	echo "wl country ALL" 
	/bin/wl country ALL 
	echo "wl tempsense_disable 1" 
	/bin/wl tempsense_disable 1 

	exit 0


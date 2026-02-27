#! /bin/sh

if [ $# -ne 1 ];
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 != "enable" -a $1 != "disable" ]; 
then	
	echo "ERROR::input para is not right!"
	exit 1
fi

if [ $1 == "enable" ];
then
	echo 3 > /sys/class/net/lan1/queues/rx-0/rps_cpus                                                                
	echo 3 > /sys/class/net/lan2/queues/rx-0/rps_cpus                                                                
	echo 3 > /sys/class/net/lan3/queues/rx-0/rps_cpus                                                                
	echo 3 > /sys/class/net/lan4/queues/rx-0/rps_cpus 
	#echo 0 > /sys/class/net/wl1/queues/rx-0/rps_cpus
	
	echo 1 > /sys/module/hw_ptp/parameters/rps
else
	echo 0 > /sys/class/net/lan1/queues/rx-0/rps_cpus                                                                
	echo 0 > /sys/class/net/lan2/queues/rx-0/rps_cpus                                                                
	echo 0 > /sys/class/net/lan3/queues/rx-0/rps_cpus                                                                
	echo 0 > /sys/class/net/lan4/queues/rx-0/rps_cpus 
	#echo 0 > /sys/class/net/wl1/queues/rx-0/rps_cpus
	
	echo 0 > /sys/module/hw_ptp/parameters/rps
fi

exit 0

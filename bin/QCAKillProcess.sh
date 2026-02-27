#!/bin/sh
Qcmbr_id_1=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==1)print $1}')
Qcmbr_id_2=$( ps | grep Qcmbr | grep -v "grep" | awk ' {if(NR==2)print $1}')
nart_id=$( ps | grep nart.out | grep -v "grep" | awk ' {if(NR==1)print $1}')
diag_id=$( ps | grep diag_socket_app | grep -v "grep" | awk ' {if(NR==1)print $1}')
ftm_id=$( ps | grep ftm | grep -v "grep" | awk ' {if(NR==1)print $1}')

echo "Qcmbr_id_1 $Qcmbr_id_1"
echo "Qcmbr_id_2 $Qcmbr_id_2"
echo "nart_id $nart_id"
echo "diag_id $diag_id"
echo "ftm_id $ftm_id"

if [ "$Qcmbr_id_1" != "" ] 
then
	kill -9 $Qcmbr_id_1
fi
if [ "$Qcmbr_id_2" != "" ] 
then
	kill -9 $Qcmbr_id_2
fi
if [ "$nart_id" != "" ] 
then
	kill -9 $nart_id
fi 
if [ "$diag_id" != "" ]
then
	kill -9 $diag_id
fi
if [ "$ftm_id" != "" ]
then
	kill -9 $ftm_id
fi

#关闭wifi校准区写权限
chipdebug wifi debug closemtd

echo "Success!"
exit 0

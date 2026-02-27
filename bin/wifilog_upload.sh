#!/bin/sh

if [ $# == 0 ];then
    echo "please input pc ip address"
    exit
fi

pcip=$1
kfile="kernel_log"
sdt_path="/tmp/bak"
regfile_path="/var"
califile_path="/var"
#echo $pcip
#echo $sdt_path
#echo $regfile_path

#kernel log upload
dmesg > $kfile
tftp -pl $kfile $pcip

#sdt log upload
cd $sdt_path
for file in wifi*
do
    echo "upload $file"
    tftp -pl $file $pcip
done

#reg file upload
cd $regfile_path
rm hal_*.txt
rm reg_file_num
echo 0 > /proc/sys/kernel/printk
hipriv.sh "Hisilicon0 get_all_regs"
sleep 1
echo "upload hal_all_reg_data_2g.txt"
tftp -pl hal_all_reg_data1.txt -r hal_all_reg_data_2g.txt $pcip
hipriv.sh "Hisilicon1 get_all_regs"
sleep 1
echo "upload hal_all_reg_data_5g.txt" 
tftp -pl hal_all_reg_data2.txt -r hal_all_reg_data_5g.txt $pcip

#cali data file upload
cd $califile_path
hipriv.sh "Hisilicon0 get_cali_data"
sleep 1
echo "tftp -pl hal_cali_data.txt $pcip"
tftp -pl hal_cali_data.txt $pcip


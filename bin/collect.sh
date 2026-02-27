#/bin/sh

workpath=/etc/wap/collect
HW_COLLECT_SSMPLIST=$workpath/ssmplist
HW_COLLECT_VOICELIST=$workpath/voicelist
HW_COLLECT_BBSPLIST=$workpath/bbsplist
HW_COLLECT_AMPLIST=$workpath/amplist
HW_COLLECT_LDSPLIST=$workpath/ldsplist
HW_COLLECT_SMARTLIST=$workpath/smartlist
HW_COLLECT_WLANLIST=$workpath/wlanlist
HW_COLLECT_ALLLIST=$workpath/alllist

if [ $# -gt 1 ]; then
    echo "ERROR::input para is not right!";
    exit 1;
elif [ $# -eq 1 ]; then
	SELECT=$1
else
	SELECT="all"
fi

CLI_MODE=$(cat /var/collectshflag)

if [ "$CLI_MODE" = "1" ]
then
    echo "Now ClientType Is TRANSCHNL, collect.sh can not be used in this ClientType."
    exit 1
fi

if [ -f /var/diacollectisrunning ]
then
    echo "diagnose collection process is existed now!"
    exit 1
fi

if [ "$LOCAL_TELNET" == "1" ]; then
    diag_src="com";
else
    diag_src="telnet";
fi

echo "local telnet flag is $LOCAL_TELNET, diag source is $diag_src"

if [ -p /var/collect_ctrl_fifo ]; then
        echo 1 > /var/collect_ctrl_fifo;
else
        echo !path "/var/console.log" > /proc/wap_proc/tty;
        echo !start > /proc/wap_proc/tty;
fi

#读取配置文件的数据信息，执行collect_exe命令
echo  "Begin to collect"
    case $SELECT in
        ssmp)
            SELECTITEMS=$HW_COLLECT_SSMPLIST
            ;;
        voice)
            SELECTITEMS=$HW_COLLECT_VOICELIST
            ;;
        bbsp)
            SELECTITEMS=$HW_COLLECT_BBSPLIST
            ;;
        amp)
            SELECTITEMS=$HW_COLLECT_AMPLIST
            ;;
        ldsp)
            SELECTITEMS=$HW_COLLECT_LDSPLIST
            ;;
        smart)
            SELECTITEMS=$HW_COLLECT_SMARTLIST
            ;;
        wlan)
            SELECTITEMS=$HW_COLLECT_WLANLIST
            ;;
        all)
            SELECTITEMS=$HW_COLLECT_ALLLIST
            ;;
        *)
            echo "ERROR::input para is not right!"
            exit 1
            ;;
    esac
    cat $SELECTITEMS | while read line
    do
        echo $line | grep -o "[^ ]\+\( \+[^ ]\+\)*"
        collect_exe $line $diag_src
    done

if [ -p /var/collect_ctrl_fifo ]; then
        echo 2 > /var/collect_ctrl_fifo;
else
        echo !stop > /proc/wap_proc/tty;
fi

if [ "$LOCAL_TELNET" != "1" ]; then
	cat /var/console.log 
fi

echo  "End to collect"

exit 0;

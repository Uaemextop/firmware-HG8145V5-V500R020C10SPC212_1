#! /bin/sh

login_user=`eval echo \`ps | grep "Get username"\` | cut -d " " -f 2`
if [ $login_user == "root" ]; then
    su -s  /bin/sh  srv_clid -c "customize_exec.sh $*"
    exit 0
fi

customize_exec.sh $*


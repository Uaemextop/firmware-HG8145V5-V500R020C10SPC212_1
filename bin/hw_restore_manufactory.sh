#! /bin/sh

login_user=`eval echo \`ps | grep "Get username"\` | cut -d " " -f 2`
if [ $login_user != "root" ]; then
	sudo hw_restore_manufactory_exec.sh
else
	hw_restore_manufactory_exec.sh
fi

#! /bin/sh

login_user=`eval echo \`ps | grep "Get username"\` | cut -d " " -f 2`
if [ $login_user != "root" ]; then
	pid=$$
	ppid=`cat /proc/$pid/status | grep PPid | cut -d':' -f2`
	ppid=${ppid:1}
	comm=`cat /proc/$ppid/comm`
	result=$(echo $comm | grep "customize_exec")
	if [ "$result" == "" ]; then
		echo "father : $comm, customize_del_file check failed"
		return 1
	fi
fi

mkdir /var/spec/
cp -rf /etc/wap/spec/encrypt_spec/* /var/spec/
aescrypt2 1 /var/spec/encrypt_spec.tar.gz /var/spec/encrypt_spec.tar.gz".bak"
cd /var/spec/
tar zxf encrypt_spec.tar.gz
chmod 755 /var/spec/
chmod 644 /var/spec/*
cd - > /dev/null


#! /bin/sh

var_version_file=/etc/version
var_version=""

#config print Version
if [ $# -ne 2 ]||[ $1 != "print" ]||[ $2 != "Version" ]; then
	echo "ERROR::input para is not right!"
	exit 1
fi

var_vrcsb=`cat $var_version_file`


var_vrcs=${var_vrcsb%B*}

#与网页上显示保持一致
var_version=`echo $var_vrcs | cut -b 1-2,5-`

var_oustr='<Version type="STRING" class="Read-only">'$var_version'</Version>'

echo  $var_oustr

exit 0 



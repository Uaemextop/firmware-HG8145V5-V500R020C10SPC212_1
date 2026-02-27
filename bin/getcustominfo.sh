#! /bin/sh

#get CTCOM or Union spec parameters
#include: custom information

#for custom information
customexist=0
oversion=""
cinfo=""
cinfo_default=""

ctree_ram="/var/hw_ctree.xml"
ctree_ram2="/var/hw_ctree2.xml"
ctree="/mnt/jffs2/hw_ctree.xml"
defaultctree="/mnt/jffs2/hw_default_ctree.xml"
defaultctreegz="/var/hw_ctree.xml.gz"
defaultctreegz2="/var/hw_ctree2.xml.gz"
var_pack_temp_dir=/bin/
temp_default_ctree="/var/hw_aestemp_default_ctree.xml"
temp2_default_ctree="/var/hw_aestemp2_default_ctree.xml"
var_factory_file="/var/customizerealfinish"
cmei_file="/mnt/jffs2/CMEI"

tmp_value=""

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
fi

#for function get_attribute_value
##function - get the attribute value
#$1:ctree name, $2:node name, $3:attribute name
get_attribute_value()
{	  
  cfgtool gettofile $1 $2 $3
  if [ 0 -ne $? ]
  then
  	echo "ERROR::Fail to get $3 value!"
  	return 1
  else
  	read tmp_value < /var/cfgtool_ret
  	if [ 0 -ne $? ]
  	then 
  		echo "ERROR::Failed to read $3 value!"
  		rm -f /var/cfgtool_ret
  		return 1
  	fi
  fi
  	
  rm -f /var/cfgtool_ret
  return 0
}

if [ -f $ctree ]
then 
	cp -f $ctree $ctree_ram
else
	echo "ERROR::Fail to get ctree!"
	exit 1
fi
	
$var_pack_temp_dir/aescrypt2 1 $ctree_ram $temp_default_ctree
mv -f $ctree_ram $defaultctreegz
gunzip -f $defaultctreegz

if [ 0 -ne $? ]
then
	mv -f $defaultctreegz $ctree_ram
fi

cinfo=`cat $ctree_ram | grep -o customInfo=\"[a-zA-Z0-9_]*\" | cut -d "\"" -f 2`
oversion=`cat $ctree_ram | grep -o originalVersion=\"[a-zA-Z0-9_]*\" | cut -d "\"" -f 2`
cmeiinfo=""
if [ -f $cmei_file ]
then
	cmeiinfo=`cat $cmei_file | tr a-z A-Z 0-9`
fi
	

rm -f $ctree_ram

if [ -f $var_factory_file ]
then
    cp -f $defaultctree $ctree_ram2

    $var_pack_temp_dir/aescrypt2 1 $ctree_ram2 $temp2_default_ctree
    mv -f $ctree_ram2 $defaultctreegz2
    gunzip -f $defaultctreegz2

    if [ 0 -ne $? ]
    then
        mv -f $defaultctreegz2 $ctree_ram2
    fi

    cinfo_default=`cat $ctree_ram2 | grep -o customInfo=\"[a-zA-Z0-9_]*\" | cut -d "\"" -f 2`
    rm -f $ctree_ram2

    if [ $cinfo != $cinfo_default ];then
        echo "ERROR::The customInfo and default_customInfo values are different!"
        exit 1
    fi
fi

##print the custom information
echo "originalVersion   =" "$oversion"
echo "customInfo        =" "$cinfo"
if [ ! -z "$cmeiinfo" ]; then
		echo "CMEI              =" "$cmeiinfo"
fi
echo ""	
echo "success!"

exit 0

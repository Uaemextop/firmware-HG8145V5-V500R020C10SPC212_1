#! /bin/sh

FILE_BOARTYPE=/mnt/jffs2/board_type
FILE_BOARDTYPE_CLASS=/var/productclass.cfg

GetSupportType()
{
	var_board_name=""
	if [ -f $FILE_BOARDTYPE_CLASS ]
	then 
		while read line;
		do
			board_type=`echo $line | sed 's/product="\(.*\)";\(.*\)/\1/g'`
			var_board_name=$var_board_name" "$board_type
		done < $FILE_BOARDTYPE_CLASS
	fi
	echo "support boardtype:" 
	echo "   "$var_board_name
}

PrintHelp()
{
	echo "boardtype.sh Usage:"
	echo "    -s to set custom boardtype."
	echo "    -g to get custom boardtype."
	echo "    -c to clean custom boardtype."
	echo "Example:"
	echo "    boardtype.sh -s HG8240R"
	echo "    boardtype.sh -g"
	echo "    boardtype.sh -c"
	GetSupportType
}

var_boardtype=0
var_boardid=0
var_pcbid=0
var_temp=`cat /var/board_cfg.txt | grep board_id|cut -d ';' -f 3|grep -oE SD51.*`

GetTypeByName_5115()
{		
    case $1  in	
	#5115S系列HG8310，HG8010C，HG8311，HG8110C,HG8310M,HG8010a
	HG8310 )
		var_boardtype=2013			
		;;
	HG8310M )
		var_boardtype=1011			
		;;
	HG8010a )
		var_boardtype=2011
		;;
	HG8010 )
		var_boardtype=2012
		;;
	HG8010C )
		var_boardtype=1022
		
		;;
	HG8311 )
		var_boardtype=2031
		;;
	HG8110F )
		var_boardtype=2032
		;;	
		
	#5115H系列HG8346R，HG8245C，HG8120F，HG8321R，HG8321，HG8120C，HG8240F，HG8342R，HG8342，HG8240C,HG8346M,HG8342M
	HG8346R )
		var_boardtype=3011
		if [ "$var_boardid" = "13" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3131
		fi
		;;
	HG8346R-256M )
		var_boardtype=3131
		;;	
	HG8245C )
		var_boardtype=3012
		if [ "$var_boardid" = "1" -a "$var_pcbid" = "0" ];then
		      var_boardtype=3061
		fi		   
		if [ "$var_boardid" = "6" ];then
		      var_boardtype=3061
		fi
		;;
  	HG8346R-RMS )
		var_boardtype=3062
		;;
	HG8321 )
		var_boardtype=3023
		;;
	HG8120C )
		var_boardtype=3024		
		if [ "$var_boardid" = "15" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3151
		fi
		;;
	HG8120A )
		var_boardtype=3025
		;;
	HG8120F )
		var_boardtype=3026
		;;			
	HG8240F )
		var_boardtype=3031
		;;
	HG8342R )
		var_boardtype=3032
		;;
	HG8342 )
		var_boardtype=3033
		;;
	HG8240C )
		var_boardtype=3034
		;;
	HG8346M )
		var_boardtype=3013
		if [ "$var_boardid" = "13" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3132
		fi
		;;
	HG8346M-256M )
		var_boardtype=3132
		;;	
	HG8342M )
		var_boardtype=3035
		;;
	HG8340 )
		var_boardtype=3052
		;;
	HG8340M )
		var_boardtype=3053
		;;
	HG8345R )
		var_boardtype=3001
		;;		
	HG8326R )
		var_boardtype=3071
		;;
		
  #5115T系列HG8240T  HG8045D	HG8245C2 HG8247H
	HG8240T )
		var_boardtype=4091
		;;
	HG8045D )
		var_boardtype=4331
		;;	
  	HG8245C2 )
		var_boardtype=4061
		;;
	HG8247H )
		var_boardtype=4011
		;;	
   	HG8045A )
		var_boardtype=4181
		;;
	HG8045H )
		var_boardtype=4182
		;;
	HG8145U )
		var_boardtype=4541
		;;
	EG8247H )
		var_boardtype=4012
		;;
	EG8242H )
		var_boardtype=4031
		;;
	EG8245H )
		var_boardtype=4211
		;;
	* )
		var_boardtype=0
		;;	
	esac

	return $var_boardtype
}


GetTypeByName_5116()
{
	case $1  in	
	
	#5116S系列HG8010H HG8010C HG8310 HG8310M	
	HG8010C )		
		if [ "$var_boardid" = "1" ];then
		    var_boardtype=5011
		fi		   
		if [ "$var_boardid" = "2" ];then
		    var_boardtype=5021
		fi		
		;;
	HG8310  )
		if [ "$var_boardid" = "1" ];then
		    var_boardtype=5012
		fi		   
	        if [ "$var_boardid" = "2" ];then
		    var_boardtype=5022
		fi
		if [ "$var_boardid" = "4" ];then
		    var_boardtype=5042
		fi		
		;;
	HG8310M )
		 if [ "$var_boardid" = "1" ];then
		      var_boardtype=5013
		 fi		   
		 if [ "$var_boardid" = "2" ];then
		      var_boardtype=5023
		 fi
		 if [ "$var_boardid" = "4" ];then
		      var_boardtype=5041
		 fi
                 #5116L
                 if [ "$var_boardid" = "9" ];then
                     var_boardtype=6091
                 fi
		;;
	HG8510 )	
		 if [ "$var_boardid" = "1" ];then
		      var_boardtype=5014
		 fi		   
		 if [ "$var_boardid" = "2" ];then
		      var_boardtype=5024
		 fi
		;;
	HG8010H )
	     var_boardtype=5043
		;;
	EG8010H )
		if [ "$var_boardid" = "4" ];then
			var_boardtype=5044
		fi
        	if [ "$var_boardid" = "9" ];then
			var_boardtype=12091
		fi
		;;
		  
	#5116L系列HG8110H	 HG8010Hv3
	HG8110H )		
		var_boardtype=6011
		;;
	HG8110F )		
		var_boardtype=6012
		;;
	HG8120F )		
		var_boardtype=6021
		;;
	HG8521 )		
		var_boardtype=6022
		;;	
	HG8010Hv3 )		
		if [ "$var_boardid" = "9" ];then
				var_boardtype=6092
		fi	
		if [ "$var_boardid" = "24" ];then
				var_boardtype=6181
		fi
		;;	
	#5116H系列 HG8346M HG8245A HG8342R HG8342M HG8345R HG8045A	HG8546M
	HG8346R )		
		var_boardtype=7031
		;;
	HG8346M )		
		var_boardtype=7032
		;;
	HG8342M )		
		var_boardtype=7041
		;;
	HG8542 )		
		var_boardtype=7042
		;;
	HG8240F )		
		var_boardtype=7043
		;;
	HG8345R )		
		var_boardtype=7051
		;;
	HG8342R-RMS )	
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=7044
		 fi		   
		if [ "$var_boardid" = "14" ];then
		      var_boardtype=7141
		 fi		   		;;
	HG8321R-RMS )	
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=7021
		 fi		   
		 if [ "$var_boardid" = "9" ];then
		      var_boardtype=7091
		 fi
		;;
		HG8540 )		
		var_boardtype=7061
		;;
	HG8040F )		
		if [ "$var_boardid" = "6" ];then
			#5116H系列HG8040F
			var_boardtype=7062
		fi		   
		if [ "$var_boardid" = "10" ];then
			#5116T系列HG8040F
			var_boardtype=9101
		fi
		;;
	HG8540M )		
		if [ "$var_boardid" = "6" ];then
			#5116H系列HG8540M
			var_boardtype=7063
		fi		   
		if [ "$var_boardid" = "10" ];then
			#5116T系列HG8540M
			var_boardtype=9102
		fi
		;;
	HG8541M )		
		var_boardtype=7291
		;;		
	HG8121C )		
		var_boardtype=7081
		;;
	HG8120H )		
		var_boardtype=7092
		;;
	HG8145A )		
		var_boardtype=7131
		;;
	HG8546M-RMS )
		if [ "$var_boardid" = "13" ];then
		      var_boardtype=7132
		fi
		if [ "$var_boardid" = "48" ];then
		      var_boardtype=7482
		fi		
		;;
	HG8120C )		
		var_boardtype=7022
		;;
	HG8540M-RMS )		
		var_boardtype=7451
		;;	
	EG8040F )		
		var_boardtype=7454
		;;	
	HG8541M-RMS )		
		var_boardtype=7461
		;;	
    HG8546M )		
		var_boardtype=7481
		;;		
	HG8145C )		
		if [ "$var_boardid" = "23" ];then
		      var_boardtype=7231
		fi		   
		;;
    HG8145C-f )		
		if [ "$var_boardid" = "23" ];then
		      var_boardtype=7232
		fi		   
		;;
	HS8325R )		
		var_boardtype=7501
		;;	
	EG8120 )		
		var_boardtype=7094
		;;			
	#5116T_PLUS系列HG8247W HS8546V2  HG8240T
	HG8247W )
		if [ "$var_boardid" = "46" ];then
		      var_boardtype=9461
		fi		   
		;;
	EG8245H )		
		var_boardtype=9031
		;;
	EG8240H )		
		var_boardtype=9041
		;;	
	EG8247W )		
		var_boardtype=9462
		;;		
	EG8040H )		
		var_boardtype=9061
		;;	
	EG8045H )		
		var_boardtype=9071
		;;
	HG8145V )		
		var_boardtype=9451
		;;
	HS8145V )		
		var_boardtype=9321
		;;
	EG8245Q2 )		
		var_boardtype=9351
		;;	
	HS8247W )		
		var_boardtype=9463
		;;
	HS8546V2 )		
		var_boardtype=9391
		;;
	HG8240T )		
		var_boardtype=9042
		;;		
	esac

	return $var_boardtype
}
GetTypeByName_5117()
{		
    case $1  in	
	
	#5117H系列CA8011V
	CA8011V )
		if [ "$var_boardid" = "7" ];then
		      var_boardtype=10071
		fi
		;;
	#5117P系列HS8346V5
	HS8346V5 )
		if [ "$var_boardid" = "32" ];then
		      var_boardtype=13321
		fi
	    if [ "$var_boardid" = "39" ];then
		      var_boardtype=13391
		fi
	    if [ "$var_boardid" = "41" ];then
		      var_boardtype=13411
		fi
        if [ "$var_boardid" = "65" ];then
		      var_boardtype=13651
		fi
		if [ "$var_boardid" = "46" ];then
			  var_boardtype=13461
		fi
		if [ "$var_boardid" = "122" ];then
			  var_boardtype=131221
		fi
		;;
	HG8145V5 )
	    if [ "$var_boardid" = "41" ];then
		      var_boardtype=13413
		fi
		if [ "$var_boardid" = "65" ];then
		      var_boardtype=13653
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131251
		fi
		;;
	# 5117P系列HS8346V5
	999#HS8346V5 )
		if [ "$var_boardid" = "41" ];then
			var_boardtype=13412
		fi
		if [ "$var_boardid" = "65" ];then
			var_boardtype=13652
		fi
		;;	
	HG8145V5-20 )
		if [ "$var_boardid" = "37" ];then
		      var_boardtype=13372
		fi
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131263
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13695
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131255
		fi
		;;
	EG8245H5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13011
		fi
		;;
	HG8245H5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13012
		fi
		;;
	HG8245H6 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=13013
		fi
		;;
	EG8247H5 )
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=13021
		fi
		;;
    HG8240T5 )
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=13031
		fi
		;;
	EG8240H5 )
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=13032
		fi
		;;	
    HG8245Q5 )
		if [ "$var_boardid" = "33" ];then
		      var_boardtype=13331
		fi
		;;
	HG8247Q5 )
		if [ "$var_boardid" = "34" ];then
		      var_boardtype=13341
		fi
		;;
	EG8145V5 )
		if [ "$var_boardid" = "35" ];then
		      var_boardtype=13351
		fi
                if [ "$var_boardid" = "37" ];then
		      var_boardtype=13371
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13691
		fi
		if [ "$var_boardid" = "70" ];then
		      var_boardtype=13701
		fi
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131261
		fi
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131361
		fi
		if [ "$var_boardid" = "66" ];then
		      var_boardtype=131364
		fi
		;;
	EG8145V5-V2 )
		if [ "$var_boardid" = "125" ];then
		      var_boardtype=131362
		fi
		if [ "$var_boardid" = "66" ];then
		      var_boardtype=131363
		fi
		;;
	TELMEX_HG8145V5 )
		if [ "$var_boardid" = "126" ];then
		      var_boardtype=131262
		fi
		;;
    EG8245W5 )
		if [ "$var_boardid" = "43" ];then
		      var_boardtype=13431
		fi
		;;
	HG8145V5-PRO )
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13692
		fi
		if [ "$var_boardid" = "37" ];then
		var_boardtype=13374
		fi
		;;
	HS8145V5 )
		if [ "$var_boardid" = "36" ];then
		      var_boardtype=13361
		fi
	    if [ "$var_boardid" = "40" ];then
		      var_boardtype=13401
		fi
		if [ "$var_boardid" = "42" ];then
		      var_boardtype=13421
		fi
        if [ "$var_boardid" = "68" ];then
		      var_boardtype=13681
		fi
		if [ "$var_boardid" = "37" ];then
		      var_boardtype=13373
		fi
		if [ "$var_boardid" = "69" ];then
		      var_boardtype=13693
		fi
		;;
    EG8040H5 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13041
		fi
		;;
    HG8040H6 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13014
		fi
		;;
	EG8040C )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13042
		fi
		;;
	EG8040C-S )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=13043
		fi
		;;
	RT-GM-2 )
		if [ "$var_boardid" = "67" ];then
		      var_boardtype=13671
		fi
		;;
	EG8245W5-6T )
		if [ "$var_boardid" = "67" ];then
		      var_boardtype=13673
		fi
		;;
	WA8021V5-PRO )
		if [ "$var_boardid" = "109" ];then
		      var_boardtype=131091
		fi
		;;
	EG8145X6 )
		if [ "$var_boardid" = "99" ];then
		      var_boardtype=13991
		fi
		if [ "$var_boardid" = "98" ];then
		      var_boardtype=13993
		fi
		;;
	EG8147X6 )
		if [ "$var_boardid" = "117" ];then
		      var_boardtype=131171
		fi
		if [ "$var_boardid" = "68" ];then
		      var_boardtype=131173
		fi
		;;
    T623 )
        if [ "$var_boardid" = "117" ];then
              var_boardtype=131172
        fi
        ;;
	A623 )
		if [ "$var_boardid" = "112" ];then
		      var_boardtype=131121
		fi
		;;
	#5117M/5117L系列HS8145C5
	HS8145C5 )
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=15011
		fi
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=12021
		fi
	    if [ "$var_boardid" = "6" ];then
		      var_boardtype=12061
		fi
		;;
	HG8040F5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15004
		fi
		;;
	EG8040F5-S )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15007
		fi
		;;		
	HG8120L5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15005
		fi
		;;
	HG8245Hv5 )
		if [ "$var_boardid" = "10" ];then
		      var_boardtype=12101
		fi
		;;
    EG8141A5 )
		if [ "$var_boardid" = "10" ];then
		      var_boardtype=12102
		fi
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=15047
		fi
		;;
	HG8141A5 )
		if [ "$var_boardid" = "4" ];then
		      var_boardtype=15048
		fi
		;;
	#5117L系列
	HS8545M5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15001
		fi
		if [ "$var_boardid" = "2" ];then
		      var_boardtype=15022
		fi
		if [ "$var_boardid" = "3" ];then
		      var_boardtype=15032
		fi
		;;
	EG8012H5 )
		if [ "$var_boardid" = "3" ];then
			  var_boardtype=15031
		fi
		;;
	EG6145A5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15003
		fi
		;;
	EG8143A5 )
		if [ "$var_boardid" = "2" ];then
			  var_boardtype=15006
		fi
		;;
	HG8010Hv6 )
		if [ "$var_boardid" = "1" ];then
			  var_boardtype=15013
		fi
		;;
    EG8010Hv6 )
        if [ "$var_boardid" = "1" ];then
              var_boardtype=15014
        fi
        ;;
    #5117P系列HS8546X6
	HS8546X6 )
		if [ "$var_boardid" = "98" ];then
			  var_boardtype=13984
		fi
		if [ "$var_boardid" = "76" ];then
			  var_boardtype=13765
		fi
		if [ "$var_boardid" = "79" ];then
			  var_boardtype=13796
		fi
		;;
	#5117V系列
	Game-RT-X )
		if [ "$var_boardid" = "11" ];then
			  var_boardtype=14111
		fi
		;;
	K654p )
		if [ "$var_boardid" = "11" ];then
		      var_boardtype=14112
		fi
		;;
    HG8245W5-6T-V1 )
        if [ "$var_boardid" = "67" ];then 
            var_boardtype=13674 
        fi
        ;;
    EG8245W5-8T )
        if [ "$var_boardid" = "11" ];then
            var_boardtype=14113
        fi
        ;;
	HG8546M5 )
		if [ "$var_boardid" = "0" ];then
		      var_boardtype=15002
		fi
		;;
	999#HG8245X6 )
		if [ "$var_boardid" = "29" ];then
		      var_boardtype=14294
		fi
		;;
	K662R )
		if [ "$var_boardid" = "106" ];then
		      var_boardtype=131061
		fi
		;;
	K662c )
		if [ "$var_boardid" = "131061" ];then
		      var_boardtype=106
		fi
		;;
	K662m )
		if [ "$var_boardid" = "114" ];then
		      var_boardtype=131141
		fi
		if [ "$var_boardid" = "115" ];then
		      var_boardtype=131151
		fi
		;;
	K662u )
		if [ "$var_boardid" = "114" ];then
		      var_boardtype=131142
		fi
		if [ "$var_boardid" = "115" ];then
		      var_boardtype=131152
		fi
		;;
	esac

	return $var_boardtype
}

GetTypeByName_5118()
{		
    case $1  in	
	
	#5118V2系列HN8541M
	HN8541M )
		if [ "$var_boardid" = "50" ];then
		      var_boardtype=11181
		fi
		;;
	HN8140 )
		if [ "$var_boardid" = "50" ];then
		      var_boardtype=11502
		fi
		;;
	HN8255Ws )		
		var_boardtype=11201
		;;
	MA5875-8E8P )
		if [ "$var_boardid" = "12" ];then
		      var_boardtype=11121
		fi
		;;
	esac

	return $var_boardtype
}

GetTypeByName_5182()
{
	case $1  in
	#5182H系列
	HN8546V5 )
		if [ "$var_boardid" = "8" ];then
		      var_boardtype=81
		fi
		if [ "$var_boardid" = "40" ];then
		      var_boardtype=401
		fi
		;;
	P622EF )
		if [ "$var_boardid" = "15" ];then 
			  var_boardtype=603 
		fi
		;;
	B610-4E )
		if [ "$var_boardid" = "7" ];then 
			  var_boardtype=71 
		fi
		;;
	P502E )
		if [ "$var_boardid" = "1" ];then
			  var_boardtype=16011
		fi
		;;
	P603E )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16231
		fi
		;;
	P603E-S )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16232
		fi
		;;
	P613E-S )
		if [ "$var_boardid" = "23" ];then
			  var_boardtype=16233
		fi
		;;
	P612E-S )
		if [ "$var_boardid" = "19" ];then
			  var_boardtype=16191
		fi
		;;
	HN8546X6 )
		if [ "$var_boardid" = "46" ];then 
			  var_boardtype=461 
		fi
		if [ "$var_boardid" = "54" ];then 
			  var_boardtype=542
		fi
		if [ "$var_boardid" = "82" ];then 
			  var_boardtype=823
		fi
		;;
	P803E )
		if [ "$var_boardid" = "9" ];then 
			  var_boardtype=16091 
		fi
		;;
	V854-C3 )
		if [ "$var_boardid" = "34" ];then 
			  var_boardtype=342
		fi
		;;
	EN8145X6 )
		if [ "$var_boardid" = "70" ];then 
			  var_boardtype=16701
		fi
		;;
	T620W-90 )
		if [ "$var_boardid" = "1271" ];then 
			  var_boardtype=162471 
		fi
		;;
	V662m )
		if [ "$var_boardid" = "110" ];then 
			  var_boardtype=161102 
		fi
		if [ "$var_boardid" = "18" ];then 
			  var_boardtype=16181 
		fi
		;;
	V862m )
		if [ "$var_boardid" = "42" ];then 
			  var_boardtype=16422 
		fi
		if [ "$var_boardid" = "26" ];then 
			  var_boardtype=16261 
		fi
		;;
	HG8245X6-8Ne )
		if [ "$var_boardid" = "98" ];then 
			  var_boardtype=16981
		fi
		;;
	EG8245X6-8N )
		if [ "$var_boardid" = "98" ];then 
			  var_boardtype=16982
		fi
		;;
	HN8145XR-u1 )
		if [ "$var_boardid" = "10" ];then 
			  var_boardtype=1011
		fi
		;;
	#5182S系列
	MA5671B )
		if [ "$var_boardid" = "0" ];then 
			  var_boardtype=2001 
		fi
		;;
	C610L )
		if [ "$var_boardid" = "61" ];then 
			  var_boardtype=16611 
		fi
		;;
	V852R-m1 )
		if [ "$var_boardid" = "44" ];then 
			  var_boardtype=16441 
		fi
		;;
	S800E-M )
		if [ "$var_boardid" = "1" ];then 
			  var_boardtype=2014 
		fi
		;;
	HN8010Ts )
		if [ "$var_boardid" = "2" ];then 
			  var_boardtype=17021 
		fi
		;;
	esac

	return $var_boardtype
}
GetTypeByName()
{
	if [ $var_temp == SD5116H -o $var_temp == SD5116S -o $var_temp == SD5116L -o $var_temp == SD5116T -o $var_temp == SD5116T_PLUS ]
	then
		    GetTypeByName_5116 $1
	    elif [ $var_temp == SD5117H -o $var_temp == SD5117P -o $var_temp == SD5117P1 -o $var_temp == SD5117M -o $var_temp == SD5117L -o $var_temp == SD5117V ];then
		    GetTypeByName_5117 $1
		elif [ $var_temp == SD5118 -o $var_temp == SD5118V2 ];then
			GetTypeByName_5118 $1
	elif [ $var_temp == SD5182H -o $var_temp == SD5182S ];then
		GetTypeByName_5182 $1
	else
		GetTypeByName_5115 $1
	fi
		
	return $var_boardtype
}

EchoNameByBoardtype_5115()
{
	case $1  in
		
	#5115S系列HG8310，HG8010C，HG8311，HG8110C,HG8310M,HG8010a
	2013 )
		var_boardname=HG8310
		;;
	1021 )
		var_boardname=HG8310
		;;
	1011 )
		var_boardname=HG8310M
		;;
	2011 )
		var_boardname=HG8010a
		;;
	1022 )
		var_boardname=HG8010C
		;;
	2031 )
		var_boardname=HG8311
		;;
	2032 )
		var_boardname=HG8110F
		;;
	
	2012 )
		var_boardname=HG8010
		;;
		
	#5115H系列HG8346R，HG8245C，HG8120F，HG8321R，HG8321，HG8120C，HG8240F，HG8342R，HG8342，HG8240C,HG8346M,HG8342M
	3011 )
		var_boardname=HG8346R
		;;
	3012 )
		var_boardname=HG8245C
		;;
	3025 )
		var_boardname=HG8120A
		;;
	3023 )
		var_boardname=HG8321
		;;
	3024 )
		var_boardname=HG8120C
		;;
	3026 )
		var_boardname=HG8120F
		;;		
	3031 )
		var_boardname=HG8240F
		;;
	3032 )
		var_boardname=HG8342R
		;;
	3033 )
		var_boardname=HG8342
		;;
	3034 )
		var_boardname=HG8240C
		;;
	3013 )
		var_boardname=HG8346M
		;;
	3035 )
		var_boardname=HG8342M
		;;
	3052 )
		var_boardname=HG8340
		;;
	3053 )
		var_boardname=HG8340M
		;;		
	3061 )
		var_boardname=HG8245C
		;;
	3062 )		
		var_boardname=HG8346R-RMS
		;;			
	3001 )
		var_boardname=HG8345R
		;;		
	3071 )
		var_boardname=HG8326R
		;;		
	3131 )
		var_boardname=HG8346R
		;;		
	3132 )
		var_boardname=HG8346M
		;;
	3151 )
		var_boardname=HG8120C
		;;
		
	#5115T系列HG8245C2 HG8240T HG8045D HG8247H
	4011 )
		var_boardname=HG8247H
		;;
	4061 )
		var_boardname=HG8245C2
		;;
	4091 )
		var_boardname=HG8240T
		;;
	4331 )
		var_boardname=HG8045D
		;;	
	4181 )
		var_boardname=HG8045A
		;;
	4182 )
		var_boardname=HG8045H
		;;
	4541 )
		var_boardname=HG8145U
		;;
	4012 )
		var_boardname=EG8247H
		;;
	4031 )
		var_boardname=EG8242H
		;;	
	4211 )
		var_boardname=EG8245H
		;;			
	* )
		var_boardname=unknown
		;;
	esac

	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5116()
{
	case $1  in	
		
	#5116S系列HG8010C HG8310 HG8310M HG8010H
	5011 )
		var_boardname=HG8010C
		;;
	5021 )
		var_boardname=HG8010C
		;;
	5012 )
		var_boardname=HG8310
		;;
	5022 )
		var_boardname=HG8310
		;;
	5013 )
		var_boardname=HG8310M
		;;
	5023 )
		var_boardname=HG8310M
		;;
	5014 )
		var_boardname=HG8510
		;;
	5024 )
		var_boardname=HG8510
		;;
	5041 )
		var_boardname=HG8310M
		;;
	5042 )
		var_boardname=HG8310
		;;			
	5043 )
		var_boardname=HG8010H
		;;	
	5044 )
		var_boardname=EG8010H
		;;	
		
	#5116L系列HG8110H	
	6011 )		
		var_boardname=HG8110H
		;;
	6012 )		
		var_boardname=HG8110F
		;;
	6021 )		
		var_boardname=HG8120F
		;;
	6022 )		
		var_boardname=HG8521
		;;	
	6091 )		
		var_boardname=HG8310M
		;;
	6092 )		
		var_boardname=HG8010Hv3
		;;
	6181 )		
		var_boardname=HG8010Hv3
		;;	
	12091 )
		var_boardname=EG8010H
		;;
			
	#5116H系列HG8346R HG8346M HG8245A HG8342M HG8345R HG8546M
	7031 )		
		var_boardname=HG8346R
		;;	
	7032 )		
		var_boardname=HG8346M
		;;
	7041 )		
		var_boardname=HG8342M
		;;
	7042 )		
		var_boardname=HG8542
		;;
	7043 )		
		var_boardname=HG8240F
		;;
	7051 )		
		var_boardname=HG8345R
		;;
	7061 )		
		var_boardname=HG8540
		;;
	7062 )		
		var_boardname=HG8040F
		;;
	7063 )		
		var_boardname=HG8540M
		;;
	7291 )		
		var_boardname=HG8541M
		;;		
	7021 )		
		var_boardname=HG8321R-RMS
		;;
	7022 )		
		var_boardname=HG8120C
		;;		
	7091 )		
		var_boardname=HG8321R-RMS
		;;
	7092 )		
		var_boardname=HG8120H
		;;
	7044 )		
		var_boardname=HG8342R-RMS
		;;
	7141 )		
		var_boardname=HG8342R-RMS
		;;
	7081 )		
		var_boardname=HG8121C
		;;
	7131 )		
		var_boardname=HG8145A
		;;
	7132 )		
		var_boardname=HG8546M-RMS
		;;		
	7231 )		
		var_boardname=HG8145C
		;;	
	7232 )		
		var_boardname=HG8145C-f
		;;	
	7451 )		
		var_boardname=HG8540M-RMS
		;;
	7461 )		
		var_boardname=HG8541M-RMS
		;;
	7481 )		
		var_boardname=HG8546M
		;;
	7482 )		
		var_boardname=HG8546M-RMS
		;;
	7501 )		
		var_boardname=HS8325R
		;;
	7454 )		
		var_boardname=EG8040F
		;;
	7094 )		
		var_boardname=EG8120
		;;
	
	#5116T系列HG8040F HG8540M
	9101 )		
		var_boardname=HG8040F
		;;
	9102 )		
		var_boardname=HG8540M
		;;
		
	#5116T_PLUS系列HG8247W HG8240T
	9461 )		
		var_boardname=HG8247W
		;;	
	9041 )		
		var_boardname=EG8240H
		;;	
	9031 )		
		var_boardname=EG8245H
		;;
	9462 )		
		var_boardname=EG8247W
		;;	
	9061 )		
		var_boardname=EG8040H
		;;
	9071 )		
		var_boardname=EG8045H
		;;
	9451 )		
		var_boardname=HG8145V
		;;
	9321 )		
		var_boardname=HS8145V
		;;	
	9351 )		
		var_boardname=EG8245Q2
		;;	
    9463 )		
		var_boardname=HS8247W
		;;	
	9391 )		
		var_boardname=HS8546V2
		;;
	9042 )		
		var_boardname=HG8240T
		;;		
	* )
		var_boardname=unknown
		;;
	esac

	echo "custom board name is $var_boardname"
}
EchoNameByBoardtype_5117()
{		
    case $1  in	

	10071 )		
		var_boardname=CA8011V
		;;	
	13321 )		
		var_boardname=HS8346V5
		;;
	13372 )		
		var_boardname=HG8145V5-20
		;;
	131263 )
		var_boardname=HG8145V5-20
		;;
	13695 )
		var_boardname=HG8145V5-20
		;;
	131255 )
		var_boardname=HG8145V5-20
		;;
	13011 )		
		var_boardname=EG8245H5
		;;	
	13012 )		
		var_boardname=HG8245H5
		;;
	13013 )
		var_boardname=HG8245H6
		;;
	13021 )		
		var_boardname=EG8247H5
		;;
	13031 )		
		var_boardname=HG8240T5
		;;    
    13032 )		
		var_boardname=EG8240H5
		;;   		
    13331 )		
		var_boardname=HG8245Q5
		;;	
	13341 )		
		var_boardname=HG8247Q5
		;;
	13351 )		
		var_boardname=EG8145V5
		;;
	13371 )		
		var_boardname=EG8145V5
		;;
	13691 )		
		var_boardname=EG8145V5
		;;
	13692 )		
		var_boardname=HG8145V5-PRO
		;;
	13374 )		
		var_boardname=HG8145V5-PRO
		;;
	13701 )		
		var_boardname=EG8145V5
		;;
	131261 )		
		var_boardname=EG8145V5
		;;
	131361 )
		var_boardname=EG8145V5
		;;
	131362 )
		var_boardname=EG8145V5-V2
		;;
	131363 )
		var_boardname=EG8145V5-V2
		;;
	131262 )		
		var_boardname=TELMEX_HG8145V5
		;;
	13431 )
		var_boardname=EG8245W5
		;;
	13391 )		
		var_boardname=HS8346V5
		;;	
	13411 )		
		var_boardname=HS8346V5
		;;	
	13651 | 13461 )		
		var_boardname=HS8346V5
		;;	
	13412 )		
		var_boardname=999#HS8346V5
		;;	
	13652 )		
		var_boardname=999#HS8346V5
		;;
	13361 )		
		var_boardname=HS8145V5
		;;
	13401 )		
		var_boardname=HS8145V5
		;;	
	13421 )		
		var_boardname=HS8145V5
		;;	
	13681 )		
		var_boardname=HS8145V5
		;;	
	13373 )
		var_boardname=HS8145V5
		;;
	13693 )
		var_boardname=HS8145V5
		;;
	14294 )
		var_boardname=999#HG8245X6
		;;
	12021 )		
		var_boardname=HS8145C5
		;;	
	12061 )		
		var_boardname=HS8145C5
		;;
	15011 )		
		var_boardname=HS8145C5
		;;
	15004 )		
		var_boardname=HG8040F5
		;;	
	15005 )		
		var_boardname=HG8120L5
		;;		
	15007 )
		var_boardname=EG8040F5-S
		;;
	12101 )		
		var_boardname=HG8245Hv5
		;;		
    12102 )		
		var_boardname=EG8141A5
		;;	
    15047 )
		var_boardname=EG8141A5
		;;
    15048 )
		var_boardname=HG8141A5
		;;
    13041 )
		var_boardname=EG8040H5
		;;
    13014 )
		var_boardname=HG8040H6
		;;
    13042 )
		var_boardname=EG8040C
		;;
	13043 )
		var_boardname=EG8040C-S
		;;
	15001 )
		var_boardname=HS8545M5
		;;
	15003 )
		var_boardname=EG6145A5
		;;
	15006 )
		var_boardname=EG8143A5
		;;
	15013 )
		var_boardname=HG8010Hv6
		;;
    15014 )
        var_boardname=EG8010Hv6
        ;;
	15032 )
		var_boardname=HS8545M5
		;;
    13984 | 13765 | 13796)
		var_boardname=HS8546X6
		;;
	13671 )
		var_boardname=RT-GM-2
		;;
	13673 )
		var_boardname=EG8245W5-6T
		;;
    13674 )
		var_boardname=HG8245W5-6T-V1
		;;
	14111 )
		var_boardname=Game-RT-X
		;;
	14112 )
		var_boardname=K654p
		;;	
    15022 )
        var_boardname=HS8545M5
        ;;
    14113 )
        var_boardname=EG8245W5-8T
        ;;
	131091 )		
		var_boardname=WA8021V5-PRO
		;;
	13991 )
		var_boardname=EG8145X6
		;;
	13993 )
		var_boardname=EG8145X6
		;;
	131171 )		
		var_boardname=EG8147X6
		;;
	131173 )
		var_boardname=EG8147X6
		;;
    131172 )		
        var_boardname=T623
        ;;
    131121 )
        var_boardname=A623
        ;;
	15002 )
		var_boardname=HG8546M5
		;;
	15031 )
		var_boardname=EG8012H5
		;;
	106 )		
		var_boardname=K662c
		;;
	131061 )
		var_boardname=K662R
		;;
	131141 | 131151 )
		var_boardname=K662m
		;;
	131142 | 131152 )
		var_boardname=K662u
		;;
	131221 )
		var_boardname=HS8346V5
		;;
	13413 )
		var_boardname=HG8145V5
		;;
	13653 )
		var_boardname=HG8145V5
		;;
	131251 )
		var_boardname=HG8145V5
		;;
	esac

	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5118()
{		
    case $1  in	
	
	#5118V2系列HN8541M
	11181 )		
		var_boardname=HN8541M
		;;
	11502 )		
		var_boardname=HN8140
		;;
	11201 )		
		var_boardname=HN8255Ws
		;;
	11121 )		
		var_boardname=MA5875-8E8P
		;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5182()
{		
    case $1 in
	81 )
		var_boardname=HN8546V5
		;;
	401 )
		var_boardname=HN8546V5
		;;
	603 )
		var_boardname=P622EF
		;;
	71 )
		var_boardname=B610-4E
		;;
	16011 )
		var_boardname=P502E
		;;
	16231 )
		var_boardname=P603E
		;;
	16232 )
		var_boardname=P603E-S
		;;
	16233 )
		var_boardname=P613E-S
		;;
	16191 )
		var_boardname=P612E-S
		;;
	461 | 542 | 823)
		var_boardname=HN8546X6
		;;
	16091 )
		var_boardname=P803E
		;;
	342 )
		var_boardname=V854-C3
		;;
	16701 )
		var_boardname=EN8145X6
		;;
	2001 )
		var_boardname=MA5671B
		;;
	17021 )
		var_boardname=HN8010Ts
		;;
	162471 )
		var_boardname=T620W-90
		;;
	161102 )
		var_boardname=V662m
		;;
	16181 )
		var_boardname=V662m
		;;
	16422  )
		var_boardname=V862m
		;;
	16261  )
		var_boardname=V862m
		;;
	16611 )
		var_boardname=C610L
		;;
	16981 )
		var_boardname=HG8245X6-8Ne
		;;
	16982 )
		var_boardname=EG8245X6-8N
		;;
	16441 )
		var_boardname=V852R-m1
		;;
	1011 )
		var_boardname=HN8145XR-u1
		;;
	2014 )
		var_boardname=S800E-M
		;;
	esac
	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype()
{	
	if [ $var_temp == SD5116H -o $var_temp == SD5116S -o $var_temp == SD5116L -o $var_temp == SD5116T -o $var_temp == SD5116T_PLUS ]
		then
		    EchoNameByBoardtype_5116 $1
			echo "EchoNameByBoardtype_5116 $1"
	    elif [ $var_temp == SD5117H -o $var_temp == SD5117P -o $var_temp == SD5117P1 -o $var_temp == SD5117M -o $var_temp == SD5117L -o $var_temp == SD5117V ];then
		    EchoNameByBoardtype_5117 $1
			echo "EchoNameByBoardtype_5117 $1"
		elif [ $var_temp == SD5118 -o $var_temp == SD5118V2 ];then
			EchoNameByBoardtype_5118 $1
			echo "EchoNameByBoardtype_5118 $1"
	elif [ $var_temp == SD5182H -o $var_temp == SD5182S ];then
		EchoNameByBoardtype_5182 $1
	        echo "EchoNameByBoardtype_5182 $1"
	else
		EchoNameByBoardtype_5115 $1
		echo "EchoNameByBoardtype_5115 $1"
	fi

}

var_cmd=$1

case $1  in
	-s )
		if [ $# -ne 2 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		var_boardid=`cat /var/board_cfg.txt | grep board_id | cut -d';' -f 1 | grep -oE [0-9]*`
		var_pcbid=`cat /var/board_cfg.txt | grep pcb_id | cut -d';' -f 2 | grep -oE [0-9]*`
		
		GetTypeByName $2
		if [ $var_boardtype -eq 0 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi

		#标定校验
		if [ -f $FILE_BOARDTYPE_CLASS ]
		then
			var_flag=`cat $FILE_BOARDTYPE_CLASS | grep \"$var_boardtype\"`
			if [ -z "$var_flag" ]
			then
				echo "cannot board to type $2!" && exit 0
			else
				echo "$var_boardtype" > $FILE_BOARTYPE
				login_user=`eval echo \`ps | grep "Get username"\` | cut -d " " -f 2`
				if [ "$login_user" == "root" ]; then
					chown 3030:2002 $FILE_BOARTYPE
					chmod 660 $FILE_BOARTYPE
				fi
				sync
				echo "success!" && exit 0
			fi
		else
			echo "cannot board to type $2!" && exit 0
		fi
		;;
	-g )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		
	    if [ -f $FILE_BOARTYPE ] ; then
			EchoNameByBoardtype "$(cat $FILE_BOARTYPE)" && exit 0
		else
			echo "ERROR::no custom board name!" && exit 0
		fi	
		;;
	-c )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		
		rm -f $FILE_BOARTYPE
		sync
		echo "success!" && exit 0
		;;
	-h )
	        PrintHelp && exit 0
		;;	
	* )
		echo "ERROR::input para is not right!"
		exit 1
		;;
	esac

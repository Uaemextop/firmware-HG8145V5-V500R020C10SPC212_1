<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<meta http-equiv="Pragma" content="no-cache" />
<link href="/Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet"/>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<style type="text/css">
#first{
	background-color:white;
	height:25px;
	text-align: center;
	color: red;
	position:absolute;
	width: 380px;
	top: 312px;
}
</style>
<script language="JavaScript" type="text/javascript">

function Registration(domain, Condition)
{
	this.domain = domain;
	this.Condition = Condition;
}            

function stLanHostInfo(domain,ipaddr)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
}

var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var timer;
var tryTimes = 0;
var tryTimesMax = 15;
var isOntOnline = 0;
var IpAddress = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress,stLanHostInfo);%>;
var Br0IpAddr = IpAddress[0].ipaddr
var loadedcolor='orange';
var unloadedcolor='white';
var bordercolor='orange';
var barheight=15;
var barwidth=360;
var ns4=(document.layers)?true:false;
var ie4=(document.all)?true:false;
var PBouter;
var PBdone;
var PBbckgnd;
var txt='';

if(ns4)
{
	txt+='<table border=0 cellpadding=0 cellspacing=0><tr><td>';
	txt+='<ilayer name="PBouter" visibility="hide" height="'+barheight+'" width="'+barwidth+'">';
	txt+='<layer width="'+barwidth+'" height="'+barheight+'" bgcolor="'+bordercolor+'" top="0" left="0"></layer>';
	txt+='<layer width="'+(barwidth-2)+'" height="'+(barheight-2)+'" bgcolor="'+unloadedcolor+'" top="1" left="1"></layer>';
	txt+='<layer name="PBdone" width="'+(barwidth-2)+'" height="'+(barheight-2)+'" bgcolor="'+loadedcolor+'" top="1" left="1"></layer>';
	txt+='</ilayer>';
	txt+='</td></tr></table>';
}
else
{
	txt+='<div id="PBouter" style="position:relative; visibility:hidden; background-color:'+bordercolor+'; width:'+barwidth+'px; height:'+barheight+'px;">';
	txt+='<div style="position:absolute; top:1px; left:1px; width:'+(barwidth-2)+'px; height:'+(barheight-2)+'px; background-color:'+unloadedcolor+'; font-size:1px;"></div>';
	txt+='<div id="PBdone" style="position:absolute; top:1px; left:1px; width:0px; height:'+(barheight-2)+'px; background-color:'+loadedcolor+'; font-size:1px;"></div>';
	txt+='</div>';
}

function resizeEl(id,t,r,b,l)
{
	if(ns4)
	{
		id.clip.left=l;
		id.clip.top=t;
		id.clip.right=r;
		id.clip.bottom=b;
	}
	else
	{
		id.style.width=r+'px';
	}
}

function getOntOnlineStatus()
{
  $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "/asp/ontOnlineStatus.asp",
            success : function(data) {
               	isOntOnline = data;
            }
        });
}

function checkOnline()   
{
	tryTimes++;
	getOntOnlineStatus();
	AuthProgress();
}  

function setPrograss(status, width)
{
	PBouter=(ns4)?findlayer('PBouter',document):(ie4)?document.all['PBouter']:document.getElementById('PBouter');
  	PBdone=(ns4)?PBouter.document.layers['PBdone']:(ie4)?document.all['PBdone']:document.getElementById('PBdone');
	if(ns4)
	{
		if (1 == status)
		{
			PBouter.visibility="show";
		}
		else
		{
			PBouter.visibility="hide";
		}
	}
	else
	{
		if (1 == status)
		{
			PBouter.style.visibility="visible";
		}
		else
		{
			PBouter.style.visibility="hidden";
		}
	}
	
	resizeEl(PBdone, 0, width, barheight-2, 0);
}

function getElementById(sId)
{
	if (document.getElementById)
	{
		return document.getElementById(sId);	
	}
	else if (document.all)
	{
		return document.all(sId);
	}
	else if (document.layers)
	{
		return document.layers[sId];
	}
	else
	{
		return null;
	}
}

function getElementByName(sId)
{   
	if (document.getElementsByName)
	{
		var element = document.getElementsByName(sId);
		
		if (element.length == 0)
		{
			return null;
		}
		else if (element.length == 1)
		{
			return 	element[0];
		}
		
		return element;		
	}
}

function getElement(sId)
{
	 var ele = getElementByName(sId); 
	 if (ele == null)
	 {
		 return getElementById(sId);
	 }
	 return ele;
}

function setDisplay (sId, sh)
{
    var status;
    if (sh > 0) 
	{
        status = "";
    }
    else 
	{
        status = "none";
    }

	getElement(sId).style.display = status;
}

function LoadFrame()
{
	getOntOnlineStatus();
	AuthProgress();
}

function AuthProgress()
{
	var PrograssNum = 24*tryTimes;
	var percentNum = 6*tryTimes + "%";
	
	if( (6*tryTimes > 100)
	   || (PrograssNum > 360 ) )
	{
		window.location="/pccw";
	}
	
	setPrograss(1,PrograssNum);
	document.getElementById('percent').innerHTML= percentNum;
	
	if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
	{
        if("1" == isOntOnline)
		{
			setPrograss(1,360);
			document.getElementById('percent').innerHTML="100%";
			document.getElementById("regResult").innerHTML = "Authenticated successfully.";
			tryTimes = 0;
			setDisplay("buttonTry",0);
			clearTimeout(timer);
		}
		else if(tryTimesMax <= tryTimes)
		{
			setPrograss(0,360);
			tryTimes = 0;
			document.getElementById('percent').innerHTML= '';
			document.getElementById("regResult").innerHTML = "Registration timeout.Please check the password and try again.";
			clearTimeout(timer);
		}
		else
		{
			timer = setTimeout('checkOnline()', 6000); 
			document.getElementById("regResult").innerHTML = "Registering,please wait...";
		}
	}
}

function JumpTo()
{
	window.location="/pccw";
}

</script>
</head>
<body onLoad="LoadFrame();"> 
<div id="main_wrapper"> 
  <table border="0" cellpadding="0" cellspacing="0" width="100%"> 
    <tr> 
      <td align="center" height="210" valign="bottom"> <table border="0" cellpadding="1" cellspacing="1" width="50%"> 
          <tr> 
            <td align="right"><A href="login.asp"><FONT color="#0000FF">Return to login page</FONT></A></td> 
          </tr> 
        </table> 
        <table border="0" cellpadding="0" cellspacing="0" width="30%"> 
          <tr> 
            <td align="center" width="36%"> <img height="75" src="/images/logo.gif" width="70" alt=""> </td> 
            <td class="hg_logo" width="64%" id="hg_logo"> <script language="JavaScript" type="text/javascript">
					document.write(ProductName);
				</script> </td> 
          </tr> 
        </table> 
        <table border="0" cellpadding="0" cellspacing="0" height="79" width="50%"> 
          <TR> 
            <TD colspan="2" align="center"> <div id="prograss"><span id="percent" style="font-size:12px;"></span></div></TD> 
          </TR> 
          <TR> 
            <TD colspan="2" align="center"> <script language="JavaScript" type="text/javascript">
					document.write(txt);
					</script> </TD> 
          </TR> 
          <TR> 
            <TD align="middle" colSpan="2" height="9"></TD> 
          </TR> 
          <TR height="8"> 
            <TD colspan="2" align="center"><span id="regResult" style="font-size:14px;"> </span></TD> 
          </TR> 
          <TR> 
            <TD align="middle" colSpan="2" height="20"></TD> 
          </TR> 
        </table></td> 
    </tr> 
    <tr> 
      <td align="center" height="65"> <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="64" width="40%"> 
          <tr> 
            <TD height="20" align="center"><span id="regResult" style="font-size:14px;"> 
              <input name="buttonTry" id="buttonTry"  type="button" class="submit" onClick="JumpTo();" value="Try again"/> 
              </span></TD> 
          </tr> 
          <tr> 
            <TD height="20" align="center"></TD> 
          </TR> 
        </table></td> 
    </tr> 
    <tr> 
      <td class="info_text" height="25" id="footer">Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved. </td> 
    </tr> 
    <tr> 
      <td align="center"> <table border="0" cellpadding="0" cellspacing="0" height="300" width="490" style="background: url('/images/pic.jpg') no-repeat center;"> 
          <tr> 
            <td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none"> 
                <table border="0" cellpadding="0" cellspacing="5" height="33" width="99%"> 
                  <tr> 
                    <td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;"> 
                      <div id="DivErrPage"></div> 
                      </span> </td> 
                  </tr> 
                </table> 
              </div></td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
</div> 
</body>
</html>

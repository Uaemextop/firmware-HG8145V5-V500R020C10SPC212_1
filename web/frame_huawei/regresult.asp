<html>
<head>
<title>Register</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<style type="text/css">
.input_time {border:0px; }
* {margin:0;padding:0;}

body {
	margin:0 auto;
	padding: 0px;
	border-width: 0px;
	text-align: center;
	vertical-align: center;
	margin-left: auto;
	margin-right: auto;
	margin-top: 80px;
	width: 955px;
	height: 600px;
}

.submit {
	background: #fefefe url(../images/button_bg.gif) center repeat-x;
	font: 12px Arial;
	color: #000;
	height: 21px;
	border: #c8c8c8 1px solid;
	padding-left: 5px;
	padding-right: 5px;
}

</style>

<script language="JavaScript" type="text/javascript">
var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';

function stResultInfo(domain, LOID, State)
{
	this.LOID = LOID;
	this.State = State;
}  

function WANIP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG)
{
  this.domain 	= domain;
  this.ConnectionStatus 	= ConnectionStatus;	
		
  if(ConnectionType == 'IP_Bridged')
  {
  	this.ExternalIPAddress	= '';
  }
  else
  {
    this.ExternalIPAddress	= ExternalIPAddress;
  }
  
  this.X_HW_SERVICELIST = X_HW_SERVICELIST;
  this.X_HW_TR069FLAG = X_HW_TR069FLAG;
	
}

function WANPPP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG)
{
  this.domain	= domain;
  this.ConnectionStatus	= ConnectionStatus;	
	
  if (ConnectionType == 'PPPoE_Bridged')
  {  
  	this.ExternalIPAddress	= '';
  }
  else
  {
    this.ExternalIPAddress= ExternalIPAddress;
  }	 
  this.X_HW_SERVICELIST = X_HW_SERVICELIST;
  this.X_HW_TR069FLAG = X_HW_TR069FLAG;
}

var opticInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic.RxPower);%>';      
var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_RegistInfo, LOID|State, stResultInfo);%>;
if(null != stResultInfos && null != stResultInfos[0])
{
	var Infos = stResultInfos[0];
}
else
{
	var stResultInfos = new Array(new stResultInfo("InternetGatewayDevice.X_HW_RegistInfo","","0"),null);
	var Infos = stResultInfos[0];
}

if (Infos.State != 5 && Infos.State != 4)
{
	Infos.State = 0;
}

var InfosBak = Infos;
var ProvisionInfo = null;

var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},ConnectionStatus||ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANIP);%>;
var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionStatus|ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANPPP);%>;
var Wan = new Array();

var stOnlineStatusInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>';
var IsOntOnline = stOnlineStatusInfo;
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var loadedcolor='#0081cc' ;   
var unloadedcolor='#ededed';     
var bordercolor='#ededed';     
var barheight=15;             
var barwidth=600;              
var acsUrl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.ManagementServer.URL);%>';
var opticMode = '<%HW_WEB_GetOpticMode();%>'
var opticType = '<%HW_WEB_GetOpticType();%>';

var timer;
var CheckDetailInfo = 1;
var StartCheckStatus = 0;
var RefreshCount = 0;
var RefreshStop = 0;
var isExistUserChoice = 1;
var CurBinMode = '<%HW_WEB_GetBinMode();%>';
var RefreshNum = 0;
var CheckOnlineCnt = 0;
var ResultTemp = '';


if (Infos.LOID.length == 0)
{
	window.location="/register.asp";
}
else if (parseInt(Infos.State) == 5)
{
	window.location="/regsuccess.asp";
}

function LoidRegResultLog(RegResult)
{	
	if (ResultTemp != RegResult)
	{
		$.ajax({
			type : "POST",
			async : false,
			cache : false,
			url : "LoidRegResultLog.cgi?&RequestFile=regresult.asp",
			data: "RegResult="+RegResult,
			success : function(data) {
			}
		});

		ResultTemp = RegResult;
	}
}

function CheckWanInfo()
{
	for (i=0, j=0; WanIp.length > 1 && j < WanIp.length - 1; i++,j++)
	{
	  	if("1" == WanIp[j].X_HW_TR069FLAG)
	  	{
	    	i--;
	    	continue;
	  	}
	  	Wan[i]= WanIp[j];
	  	
		if ((Wan[i].ConnectionStatus=="Connected") && (-1 != Wan[i].X_HW_SERVICELIST.indexOf("TR069")))
	  	{
	  		CheckDetailInfo = 0;
	  	}
	}
	
	for (j=0; WanPpp.length > 1 && j<WanPpp.length - 1; i++,j++)
	{
	  	if("1" == WanPpp[j].X_HW_TR069FLAG)
	  	{
	    	i--;
	    	continue;
	  	}
	  	Wan[i]= WanPpp[j];

		if ((Wan[i].ConnectionStatus=="Connected") && (-1 != Wan[i].X_HW_SERVICELIST.indexOf("TR069")))
	  	{
	  		CheckDetailInfo = 0;
	  	}
	}
}

function resizeEl(id,top,right,bottom,left)
{
	if(ns4)
	{
		id.clip.left=left;
		id.clip.top=top;
		id.clip.right=right;
		id.clip.bottom=bottom
	}
	else
	{
		id.style.width=right+'px';
	}
}

function FreshCountDel()  
{
	if (RefreshCount)
	{
		RefreshCount--;
	}
	
	RefreshStop = 0;
	RefreshNum = 0;
}

function myrefresh()   
{
	RefreshStop++;
	if (RefreshStop > 120)
	{
		return;
	}

	if (RefreshCount)
	{
		RefreshNum++;
		if (RefreshNum > 4)
		{
			RefreshCount=0;
			RefreshNum=0;
			LoadFrameInfo(2000);
			return;
		}
		
		if (((RefreshNum - 1) % 2 ) == 0)
		{
			LoadFrameInfo(1000);
		}
		else
		{
			setRefreshInterval(1000);
		}
		return;
	}
	
	RefreshCount++;
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		timeout : 4000,
		url : "/asp/GetOpticRxPower.asp",
		success : function(data) {
			try{
				var tmpopticInfo = '"' + data + '"';
				opticInfo = eval(tmpopticInfo);
			}catch(e){
				opticInfo = data;
			}
			FreshCountDel();
		}
	});
	
	RefreshCount++;
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		timeout : 4000,
		url : "asp/GetONTonlineStat.asp",
		success : function(data) {
			try{
				var tmponline = '"' + data + '"';
				IsOntOnline = eval(tmponline);
			}catch(e){
				IsOntOnline = data;
			}
			
			FreshCountDel();
		}
	});
	
	if (1 == IsOntOnline)
	{
		if (1 == CheckDetailInfo)
		{
			RefreshCount++;
			$.ajax({
				type : "POST",
				async : true,
				cache : false,
				timeout : 4000,
				url : "asp/GetRegWanIp.asp",
				success : function(data) {
					WanIp = eval(data);
					FreshCountDel();
				}
			});
		
			RefreshCount++;
			$.ajax({
				type : "POST",
				async : true,
				cache : false,
				timeout : 4000,
				url : "asp/GetRegWanPpp.asp",
				success : function(data) {
					WanPpp = eval(data);
					FreshCountDel();
				}
			});
			
			CheckWanInfo();
		}
		
		if ((1 < StartCheckStatus) && (0 == CheckDetailInfo))
		{		
			RefreshCount++;
			$.ajax({
				type : "POST",
				async : true,
				cache : false,
				timeout : 4000,
				url : "asp/GetRegResult.asp",
				success : function(data) {
					Infos = eval(data);

					if (parseInt(Infos.Status) != parseInt(InfosBak.Status)) {
							Infos.Result = InfosBak.Result;
					}
					
					InfosBak = Infos;
					FreshCountDel();
				}
			});
			
		}
	}
	else
	{
		CheckDetailInfo = 1;
	}
	
	LoadFrameInfo(2000);
}  

function SetCookie(cookiename, cookievalue)
{
    var expires = (SetCookie.arguments.length > 2) ? SetCookie.arguments[2] : null;
    var domain = (SetCookie.arguments.length > 4) ? SetCookie.arguments[4] : null;
    var secure = (SetCookie.arguments.length > 5) ? SetCookie.arguments[5] : false;

    var cookiepath = "/";
    if (expires != null) {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + (expires * 1000));
    }
    document.cookie = cookiename + "=" + escape (cookievalue) +((expires == null) ? "" : ("; expires="+ expdate.toGMTString()))
    +((cookiepath == null) ? "" : ("; cookiepath=" + cookiepath)) +((domain == null) ? "" : ("; domain=" + domain))
    +((secure == true) ? "; secure" : "");
}

function GetCookieVal(offset)
{
	var cookievalstr = document.cookie.indexOf (";", offset);
	if (cookievalstr == -1)
	cookievalstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, cookievalstr));
}

function GetCookie(name)
{
	var cookiename = name + "=";
	var cookienamelen = cookiename.length;
	var cookielen = document.cookie.length;
	var i = 0;
	while (i < cookielen)
	{
	var j = i + cookienamelen;
	if (document.cookie.substring(i, j) == cookiename)
	return GetCookieVal(j);
	i = document.cookie.indexOf(" ", i) + 1;
	if (i == 0) break;
	}
	return null;
}

function GetDateTimeDiff()
{
	lStartTime = GetCookie('lStartTime');
    if (lStartTime == null || lStartTime == "")
    {
        SetCookie("lStartTime", new Date());
        return '1';
    }
	var CurrentTime = new Date();
	var PrevTime = new Date(GetCookie("lStartTime"));
 	return parseInt((CurrentTime.getTime()-PrevTime.getTime())/1000);
}

function GetStepStatus()
{
	StepStatus = GetCookie('StepStatus');
    if (StepStatus == null || StepStatus == "" || (StepStatus < '0' || StepStatus > '7'))
    {
        SetCookie("StepStatus", "0");
        return '0';
    }
    return StepStatus;
}


function IsOpticPowerLow()
{

	if (opticMode == 0)
	{ 
		if (opticType == 1) /* GPON */
		{ 
			return opticInfo < -27;/* CLASS B+: (-27,-8) */
		}
		else if(opticType == 2)
		{ 
			return opticInfo < -30;/* CLASS C+: (-30,-8) */
		}
	}
	else if (opticMode == 1) /* EPON */	
	{ 
		if(opticType == 0)
		{ 
			return opticInfo < -24;/*PX20:  (-24,-3)*/
		}
		else if(opticType == 1)
		{
			return opticInfo < -27;/*PX20+: (-27,-3)*/
		}
	}
    return opticInfo < -27;
}

function GetAcsUrlAddress()
{
	var aclUrlTmp1 = acsUrl.split('//');
	if(aclUrlTmp1.length > 1)
	{
		var aclUrlTmp2 = aclUrlTmp1[1].split(':');
		return(aclUrlTmp2[0]);
	}
	return aclUrlTmp1[0];
}

function StartRegStatus()
{
	document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds";
	document.getElementById("regResult").innerHTML = "Registering to the OLT.";
}

function setRefreshInterval(time)
{

	timer = setTimeout('myrefresh()', time); 
	
	return;
}


function IsOpticalNomal()
{
	return opticInfo != "--";
}


function mystep()   
{
	if (1 != IsOntOnline)
	{
		CheckOnlineCnt = 0;
	    SetCookie("StepStatus","3");
		return;
	}
	
	if(CheckOnlineCnt < 6)
	{
		CheckOnlineCnt++;
		return;
	}
	
	CheckOnlineCnt = 0;
	StartCheckStatus++;

	document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds" ;
	document.getElementById("regResult").innerHTML = "Obtaining IP address of management channel.";

    SetCookie("StepStatus","2");
}


function setTipsBeforeITMSResult()
{
	document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds" ;

	if (!IsOpticalNomal())
    {
		var htmlDes = "Fail to Register to the OLT.<br/>Please check the optical signal and the LOID.";
		document.getElementById("regResult").innerHTML = htmlDes;

		LoidRegResultLog("OLT_Fail");

		if (GetDateTimeDiff() > 300) {
			clearTimeout(timer);
		}

		SetCookie("StepStatus","4");
	}
    else if(GetStepStatus() == '0')
    {
	    if (GetDateTimeDiff() > 300)
		{
			document.getElementById("regResult").innerHTML = "Fail to Register to the OLT.<br/>Please check the optical signal and the LOID.";

			LoidRegResultLog("OLT_Fail");
			clearTimeout(timer);
		}
		else
		{
	        StartRegStatus();
	        mystep();
	    }
    }
    else if(GetStepStatus() == '2')
	{
		if (1 != IsOntOnline)
		{		
			SetCookie("StepStatus","0");
			StartRegStatus();
	        mystep();
			return;
		}		
		StartCheckStatus++;
			
		if( GetDateTimeDiff() > 300 )
		{
			var htmlDes = "Fail to connect to ACS.<br/>Please contact the ACS administrator to check causes of the failure."
			document.getElementById("regResult").innerHTML = htmlDes;

			LoidRegResultLog("RMS_NoIP");
			clearTimeout(timer);
		}
		else
		{
			if (0 == Wan.length)
			{
				document.getElementById("regResult").innerHTML = "Obtaining IP address of management channel.";
			}
			else
			{
				for (i = 0;i < Wan.length;i++)
				{
						if( Wan[i].ConnectionStatus=="Connected" && ((Wan[i].X_HW_SERVICELIST == "TR069") ||(Wan[i].X_HW_SERVICELIST == "TR069_VOIP")||(Wan[i].X_HW_SERVICELIST == "TR069_INTERNET")||(Wan[i].X_HW_SERVICELIST == "TR069_VOIP_INTERNET")) )
						{
							document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds" ;
							var htmlDes = "Begins to register on the ACS.";
							document.getElementById("regResult").innerHTML = htmlDes;
							break;
						}
						else
						{
							document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds" ;
							document.getElementById("regResult").innerHTML = "Obtaining IP address of management channel.";
						}
				}
			}
		}
	}
    else if(GetStepStatus() == '3')
	{
		if (GetDateTimeDiff() > 300)
		{
			document.getElementById("regResult").innerHTML = "Fail to Register to the OLT.<br/>Please check the optical signal and the LOID.";

			LoidRegResultLog("OLT_Fail");
			clearTimeout(timer);
		}
		else
		{
			StartRegStatus();
			CheckOnlineCnt = 0;
			SetCookie("StepStatus","0");
		}
	}
	else
	{
		if(GetStepStatus() == '4')
		{
			SetCookie("lStartTime",new Date());
		}
		StartRegStatus();
		SetCookie("StepStatus","0");
	}
}

function LoadFrameInfo(time)
{
	/* 启动超时定时器 */
	setRefreshInterval(time);

	if (Infos != null)
	{
		StartCheckStatus++;
		document.getElementById('percent').innerHTML="Total time: "+GetDateTimeDiff()+" seconds" ;
		
		if (parseInt(Infos.State) == 4)
		{   
			var htmlDes = "Registration successful. Service is being distributed."
			document.getElementById("regResult").innerHTML = htmlDes;
		}
		else if (parseInt(Infos.State) == 103)
		{
			var htmlDes = "Failed to register to the ACS.<br/>Please contact the ACS administrator to check causes of the failure."
			document.getElementById("regResult").innerHTML = htmlDes;
			clearTimeout(timer);
		}
		else if (parseInt(Infos.State) == 5)
		{
			var htmlDes = "Registration successful. Service distribution successful."
			document.getElementById("regResult").innerHTML = htmlDes;
			LoidRegResultLog("ACS_RegSuccess");
			clearTimeout(timer);
		}
		else if (parseInt(Infos.State) == 104)
		{
			var htmlDes = "Failed to Service distribution.<br/>Please contact the ACS administrator to check causes of the failure."
			document.getElementById("regResult").innerHTML = htmlDes;
			LoidRegResultLog("ACS_RegFail");
			clearTimeout(timer);
		}
		else if (parseInt(Infos.State) == 105)
		{
			var htmlDes = "Activation timeout."
			document.getElementById("regResult").innerHTML = htmlDes;
			LoidRegResultLog("ACS_RegFail");
			clearTimeout(timer);
		}
		else
		{
		    setTipsBeforeITMSResult();
			return;
		}
		
	}
	else
	{
		setTipsBeforeITMSResult();
		return;
	}
}

function JumpTo()
{
	clearTimeout(timer);    

	if ((parseInt(Infos.State) == 5) && (Infos.LOID.length != 0))
	{
		window.location="/login.asp";
	}	
	else
	{
		window.location="/register.asp";
	}
}

function LoadFrame()
{
	CheckWanInfo();
	LoadFrameInfo(2000);
}	
</script>
</head>
<body onLoad="LoadFrame();"> 

	<div align="center"  id="RegisterModule" class="module" style="display:;position:relative;width:600px;height:205px;background-color:#f2f2f2;border-radius:10px;margin:auto;"> 
		<TABLE> 
				<TR> 
					<TD colspan="2" align="center">
						<div id="prograss" style="padding-top:30px;padding-bottom:15px;">
							<span id="percent" style="font-size:15px;font-weight:bold;color:#5c5d55;"></span>
						</div>
					</TD> 
				</TR> 
				
				<TR height="8"> 
					<TD  align="center" style="padding-top:15px;">
						<span id="regResult" style="font-size:15px;font-weight:bold;"></span>
					</TD> 
				</TR> 
				<TR>
					<TD  align="center" style="padding-top:30px;">
						<input type="button" class="submit" value="Return" onclick="JumpTo();"/>
					</TD>
				</TR><TR></TR>
			</TABLE> 
		</TABLE>
	</div> 

</body>
</html>

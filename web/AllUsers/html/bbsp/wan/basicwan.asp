<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style>
    .Select
    {
        width:157px;  
    }
</style>
</head>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/ontstate.asp"></script>
<script language="javascript" src="<%HW_WEB_CleanCache_Resource(wanlanguage.html);%>"></script>
<script language="javascript" src="../common/wanaddressacquire.asp"></script>

<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/<%HW_WEB_DeepCleanCache_Resource(wan_list_info.asp);%>"></script>
<script language="javascript" src="../common/<%HW_WEB_DeepCleanCache_Resource(wan_list.asp);%>"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(wan_servicelist.js);%>"></script>
<script language="javascript" src="../common/wan_pageparse.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/wan/wan.cus);%>"></script>
<script language="JavaScript" type="text/javascript">
function BasicWanPPP(domain,Enable,Username,Password,X_HW_VLAN,X_HW_SERVICELIST,ConnectionType,ConnectionTrigger,ConnectionStatus,ExternalIPAddress,LastConnectionError)
{
	this.domain             = domain;
	this.Enable             = Enable;
	this.Username           = Username;	
	this.X_HW_VLAN          = X_HW_VLAN;
	this.X_HW_SERVICELIST   = X_HW_SERVICELIST;
	this.ConnectionType     = ConnectionType;
	this.Password           = Password;
	this.ConnectionTrigger = ConnectionTrigger;
	this.ConnectionStatus  = ConnectionStatus;
	this.IPv4IPAddress     = ExternalIPAddress;
	this.LastConnectionError     = LastConnectionError;
}

function BasicWanIPOE(domain,ExternalIPAddress,SubnetMask,DefaultGateway,X_HW_VLAN,X_HW_SERVICELIST,ConnectionStatus,AddressingType)
{
	this.domain             = domain;
	this.ExternalIPAddress  = ExternalIPAddress;	
	this.SubnetMask         = SubnetMask;
	this.DefaultGateway     = DefaultGateway;
	this.X_HW_VLAN          = X_HW_VLAN;
	this.X_HW_SERVICELIST   = X_HW_SERVICELIST;
	this.ConnectionStatus   = ConnectionStatus;
	this.AddressingType     = AddressingType;
}

 
function PingResultClass(domain, FailureCount, SuccessCount)
{
    this.domain = domain;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
} 

function ONTInfo(domain,ONTID,Status)
{
	this.domain         = domain;
	this.ONTID          = ONTID;
	this.Status         = Status;
}

function stLine(Domain, DirectoryNumber,Enable,Status)
{
    this.Domain = Domain;
	
	if(DirectoryNumber != null)
    {
    	this.DirectoryNumber = DirectoryNumber.toString().replace(/&apos;/g,"\'"); 
        
    }
    else
    {
      this.DirectoryNumber = DirectoryNumber;
    }

    if (Enable.toLowerCase() == 'enabled')
    {
        this.Enable = 1;
    }
    else
    {
        this.Enable = 0;
    }     
	
	
	if (Status.toLowerCase() == 'up')
    {
        this.Status = 1;
    }
    else
    {
        this.Status = 0;
    }
}

var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;
var ontInfo = ontInfos[0];
var PPPWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|Username|Password|X_HW_VLAN|X_HW_SERVICELIST|ConnectionType|ConnectionTrigger|ConnectionStatus|ExternalIPAddress|LastConnectionError,BasicWanPPP);%>;
var IPWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},ExternalIPAddress|SubnetMask|DefaultGateway|X_HW_VLAN|X_HW_SERVICELIST|ConnectionStatus|AddressingType,BasicWanIPOE);%>;
var StartPingFlag = 0;
var PingResult = new PingResultClass("InternetGatewayDevice.IPPingDiagnostics","0","0");
var ConnectWanInfo = new Array();
var g_getpingtimer = 0;
var g_needsetpppwaninfo = 1;
var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i},DirectoryNumber|Enable|Status,stLine);%>;
var connectFlag = '<%HW_WEB_GetConnectionFlag();%>';
var pppoeUserName = '<%HW_WEB_GetSPEC(SPEC_GLOBE_DEFAULT_PPPOE_USERNAME.STRING);%>';

function IsPonOnline()
{
	if (ontPonMode.toUpperCase() != 'GPON' && ontPonMode.toUpperCase() != 'EPON') return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5')  return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5AUTH')  return true;
	if (ontPonMode.toUpperCase() == 'EPON' && ontEPONInfo.Status.toUpperCase() == 'ONLINE') return true;
	return false;
}

function CheckWanInfo()
{
	var i = 0;
	var j = 0;
	for (i=0, j=0; IPWanList.length > 1 && j < IPWanList.length - 1; j++)
	{
		if (IPWanList[j].ConnectionStatus=="Connected" 
			&& (IPWanList[j].X_HW_SERVICELIST.toString().toUpperCase().indexOf("INTERNET") >= 0))
	  	{
	  		ConnectWanInfo[i]= IPWanList[j];
			i++;
	  	}		
	}
	
	for (j=0; PPPWanList.length > 1 && j< PPPWanList.length - 1; j++)
	{	  	
	  	if (PPPWanList[j].ConnectionStatus=="Connected"
			&& (PPPWanList[j].X_HW_SERVICELIST.toString().toUpperCase().indexOf("INTERNET") >= 0))
	  	{
			ConnectWanInfo[i]= PPPWanList[j];
			i++;
	  	}			  
	}
}

function GetInternetRoutePPPWan()
{
	if(PPPWanList.length <= 1)
	{
		return -1;
	}
		
	for(var index = 0; index < PPPWanList.length - 1; index++)
	{
		if((PPPWanList[index].X_HW_SERVICELIST.toString().toUpperCase().indexOf("INTERNET") >= 0)
		&&(PPPWanList[index].ConnectionType.toString().toUpperCase().indexOf("ROUTED") >= 0))
		{
			
			return index ;
		}
	}
	
	return -1;
}

var  PPPWanIndex = GetInternetRoutePPPWan();

function GetVOIPIPWan()
{
	if(IPWanList.length <= 1)
	{
		return -1;
	}
	
	if(-1 == PPPWanIndex)
	{
		return -1;
	}
		
		
	for(var index = 0; index < IPWanList.length - 1; index++)
	{
		if(IPWanList[index].X_HW_SERVICELIST.toString().toUpperCase().indexOf("VOIP") >= 0)
		{
			if(IPWanList[index].domain.split(".")[2] == PPPWanList[PPPWanIndex].domain.split(".")[2])
			{
				return index ;
			}
		}
	}
	
	return -1;
}

function StartPingDiagnose()
{	
	var IPAddress = "8.8.8.8";		
	for (i = 0;i < ConnectWanInfo.length;i++)
    {
    	if((ConnectWanInfo[i].X_HW_SERVICELIST.indexOf("INTERNET") != -1))
    	{
    		WanName = ConnectWanInfo[i].domain;
    		break;
        }
    }
    
    var DSCP = 0;
    var PingData;
    StartPingFlag = 1;
    PingResult.SuccessCount = 0;
    PingResult.FailureCount = 0;
    
    PingData = "x.Host=" + IPAddress + "&x.DiagnosticsState=Requested" + "&x.NumberOfRepetitions=1" + "&x.DSCP=" + DSCP
    if (WanName != "")
    {
    	PingData += "&x.Interface=" + WanName; 
    } 
      
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		data : PingData,
		url : "ping.cgi?x=InternetGatewayDevice.IPPingDiagnostics",
		success : function(data) 
		{
			;
		}
	});
}

function GetPingInternetStatus()
{
	if (0 < StartPingFlag)
	{
		$.ajax({
			type : "POST",
			async : true,
			cache : false,
			timeout : 4000,
			url : "../common/GetRegPingResult.asp",
			success : function(data) {
				PingResult = eval(data);
			}
		});		
		
		if (0 != PingResult.SuccessCount || 0 != PingResult.FailureCount)
		{
			clearInterval(g_getpingtimer);
			PingResultAction();
		}
	}
}

function DisableDataWan(ctrFlag)
{
	setDisable('UserName',ctrFlag);
	setDisable('Password',ctrFlag);
	setDisable("VlanId", ctrFlag);	
}

function DisableVOIPWan(ctrFlag)
{
	setDisable('IPv4IPAddress',ctrFlag);
	setDisable('IPv4SubnetMask',ctrFlag);
	setDisable('IPv4DefaultGateway',ctrFlag);
	setDisable("VlanIdVoip", ctrFlag);	
}

function HideBasicWanInfo()
{
	setDisplay("UserNameRow", 0);
	setDisplay("PasswordRow", 0);
	setDisplay("IPv4IPAddressRow", 0);
	setDisplay("IPv4SubnetMaskRow", 0);
	setDisplay("IPv4DefaultGatewayRow", 0);
	setDisplay("VlanIdRow", 0);
	setDisplay("VlanIdVoipRow", 0);
}

function DisplayDataWanInfo()
{
	setDisplay("UserNameRow", 1);
	setDisplay("PasswordRow", 1);
	setDisplay("VlanIdRow", 1);
}

function DisplayVOIPWanInfo()
{
	setDisplay("IPv4IPAddressRow", 1);
	setDisplay("IPv4SubnetMaskRow", 1);
	setDisplay("IPv4DefaultGatewayRow", 1);
	setDisplay("VlanIdVoipRow", 1);
}

function IsPPPLinkIsOK()
{
	if(PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase() == "CONNECTED" )
	{
		return true;
	}
	if(PPPWanList[PPPWanIndex].LastConnectionError == "ERROR_AUTHENTICATION_FAILURE" )
	{
		return true;
	}
	return false;
}

function IsVoiceRegtSucc()
{
	for(var index = 0; index < AllLine.length - 1; index++)
	{
		if(1 == AllLine[index].Status.toString().toUpperCase())
		{
			return true;
		}
	}
	
	return false;
}

function OnChangewWanServiceUI(Obj)
{
	var  IPWanIndex = GetVOIPIPWan();
	
	var ConnectionObj = document.getElementById("ServiceList");
	
	HideBasicWanInfo();
	
	if(undefined != Obj)
	{
		g_needsetpppwaninfo = 1;
	}
	
	if(Languages['DataService'] == ConnectionObj.value)
	{
		DisplayDataWanInfo();
		
		DisableDataWan(0);
		
		setText("ButtonApply", Languages["Connect"]);	
		
		if(-1 == PPPWanIndex)
		{
			setDisable('ServiceList',1);
			setDisable('ButtonApply',1);	
			DisableDataWan(1);
			return ;
		}
		
		if(1 == g_needsetpppwaninfo)
		{
			setSelect("ServiceList", Languages['DataService']);
			setText('UserName',PPPWanList[PPPWanIndex].Username);
			setText('Password',PPPWanList[PPPWanIndex].Password);
			setText('VlanId',PPPWanList[PPPWanIndex].X_HW_VLAN);
			g_needsetpppwaninfo = 0;
		}
		
		if(!IsPonOnline())
		{	
			setDisable('ButtonApply',1);
			DisableDataWan(1);
			return ;
		}
		
		if(IsPonOnline()
		   && PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase() != "CONNECTED")  
		{
			if(0 == PPPWanList[PPPWanIndex].Enable)
			{
				if(connectFlag == '1')
				{
					setDisable('ButtonApply', 0);
				    DisableDataWan(0);
				}
				else
				{
				    setDisable('ButtonApply', 0);
					DisableDataWan(1);
				}
				
				return ;
			}
			
			if((PPPWanList[PPPWanIndex].Username != pppoeUserName) && (IsPPPLinkIsOK() == true))
			{
				setDisable('ButtonApply',1);
				DisableDataWan(1);
				return ;
			}
			else
			{
				setDisable('ButtonApply',0);
				DisableDataWan(0);
				return ;
			}

		}
		
		setDisable('ButtonApply',0);
		
		if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			DisableDataWan(1);
			setText("ButtonApply", Languages["DisConnect"]);
			PingResultAction();			
		}

		return;
	}
	
	if(Languages['VoiceService'] == ConnectionObj.value)
	{
		DisplayVOIPWanInfo();
		
		setText("ButtonApply", Languages["Connect"]);	
		
		if("CONNECTED" == IPWanList[IPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			setText("ButtonApply", Languages["DisConnect"]);
		}
		
		DisableVOIPWan(1);
		setDisable("ButtonApply", 1);
		
		if(-1 == IPWanIndex)
		{			
			return;
		}
		
		
		setText('IPv4IPAddress',IPWanList[IPWanIndex].ExternalIPAddress);
		setText('IPv4SubnetMask',IPWanList[IPWanIndex].SubnetMask);
		setText('IPv4DefaultGateway',IPWanList[IPWanIndex].DefaultGateway);
		setText('VlanIdVoip',IPWanList[IPWanIndex].X_HW_VLAN);
		
		if("STATIC" != IPWanList[IPWanIndex].AddressingType.toString().toUpperCase())
		{	
			return;
		}
		
		if(!IsPonOnline())
		{	
			DisableVOIPWan(1);
			setDisable("ButtonApply", 1);
			return ;
		}
		
		if((false == IsVoiceRegtSucc())&&(-1 != PPPWanIndex)&&
			("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase()))
		{
			DisableVOIPWan(0);
			setDisable("ButtonApply", 0);	
			PingResultAction();
			return;
		}
		else if(true == IsVoiceRegtSucc())
		{	
			setDisable("ButtonApply", 0);
			if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
			{
				PingResultAction();
			}
			return;
		}

	}
}

function CheckDataWanInfo()
{
	if ((getValue('UserName') != '') && (isValidAscii(getValue('UserName')) != ''))        
	{
		AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + isValidAscii(getValue('UserName')) + '".');          
		return false;       
	}
	
	if ((getValue('Password') != '') && (isValidAscii(getValue('Password')) != ''))         
	{  
		AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + isValidAscii(getValue('Password')) + '".');         
		return false;       
	}
	
	return true;	
}

function CheckVOIPWanInfo()
{
    if(getValue('IPv4SubnetMask') == '')
    {
        AlertMsg("SubMaskInput");
        return false;
    }	
	
    if (isValidIpAddress(getValue('IPv4IPAddress')) == false || isAbcIpAddress(getValue('IPv4IPAddress')) == false)
    {
         AlertMsg("IPAddressInvalid");
         return false;
    }
	
    if (isValidSubnetMask(getValue('IPv4SubnetMask')) == false )
    {
        AlertMsg("SubMaskInvalid");
        return false;
    }
	
	if ((getValue('IPv4DefaultGateway') != '') && (isValidIpAddress(getValue('IPv4DefaultGateway')) == false || isAbcIpAddress(getValue('IPv4DefaultGateway')) == false))
    {
         AlertMsg("WanGateWayInvalid");
         return false;
    }
	
	if((getValue('IPv4DefaultGateway') != '') && false==isSameSubNet(getValue('IPv4IPAddress'), getValue('IPv4SubnetMask'), getValue('IPv4DefaultGateway'), getValue('IPv4SubnetMask')))
    {
        AlertMsg("IPAddressNotInGateWay");
        return false;
    }
	
	for (var iIP=0; iIP < PPPWanList.length -1; iIP++)
	{
		
		if (PPPWanList[iIP].domain != IPWanList[GetVOIPIPWan()].domain && PPPWanList[iIP].IPv4IPAddress == IPWanList[GetVOIPIPWan()].IPv4IPAddress)
		{
			AlertMsg("IPAddressIsUserd");
			return false;
		}
	} 
	
	for (var iIP=0; iIP < IPWanList.length - 1; iIP++)
	{
		if (IPWanList[iIP].domain != IPWanList[GetVOIPIPWan()].domain && IPWanList[iIP].IPv4IPAddress == IPWanList[GetVOIPIPWan()].IPv4IPAddress)
		{
			AlertMsg("IPAddressIsUserd");
			return false;
		}
	} 
	
	return true;
}

function OnApply()
{
	var Form = new webSubmitForm();
	
	var WanServiceList = getElementById('ServiceList').value; 
	var url = '';
	var IPWanIndex = GetVOIPIPWan();
		
	if(Languages['DataService'] == WanServiceList)
	{
		var errmsg="";
		errmsg=checkVlanID(getValue('VlanId'),"VlanId");
		if(""!=errmsg)
		{
		AlertEx(errmsg);
		return false;
		}
		
		if(false == CheckDataWanInfo())
		{
			return ;
		}
		
		Form.addParameter('x.Username', getValue('UserName'));
		Form.addParameter('x.Password', getValue('Password'));
		Form.addParameter('x.X_HW_VLAN', getValue('VlanId'));

		var keepFieldOpen = 0;
		if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			if(PingResult.SuccessCount == 0)
			{
				keepFieldOpen = 1;
			}
			
			Form.addParameter('x.Enable', 0);
		}
		else
		{
			Form.addParameter('x.Enable', 1);
		}
		
		url= PPPWanList[PPPWanIndex].domain;
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
		Form.setAction('set.cgi?x=' +  url + '&RequestFile=html/bbsp/wan/basicwan.asp');
		
		Form.submit();
		
		if(keepFieldOpen == 1)
		{
			$.ajax({
				type : "POST",
				async : false,
				cache : false,
				url : '/createWanFlag.cgi?1=1&RequestFile=html/bbsp/wan/basicwan.asp',
				data:'&Parainfo='+'0',
				success : function(data) {
				;
				}
			});
		}
		else
		{
			$.ajax({
				type : "POST",
				async : false,
				cache : false,
				url : '/deleteWanFlag.cgi?1=1&RequestFile=html/bbsp/wan/basicwan.asp',
				data:'&Parainfo='+'0',
				success : function(data) {
				;
				}
			});
		}
		
		setDisable('ButtonApply' ,1);
	}
	
	if(Languages['VoiceService'] == WanServiceList)
	{
		var errmsg="";
		errmsg=checkVlanID(getValue('VlanIdVoip'),"VlanId");
		if(""!=errmsg)
		{
			AlertEx(errmsg);
			return false;
		}
	
		if(false == CheckVOIPWanInfo())
		{
			return;
		}
		var str = "";				
		var action = '';
		action = 'set.cgi?' +'x='+IPWanList[IPWanIndex].domain;
		
		str ='x.ExternalIPAddress='+getValue('IPv4IPAddress');
		
		str= str+'&x.SubnetMask='+getValue('IPv4SubnetMask');
		
		str= str+'&x.DefaultGateway='+getValue('IPv4DefaultGateway');
		
		str=str+'&x.X_HW_VLAN='+getValue('VlanIdVoip');
		
		Form.addParameter('x.X_HW_VLAN', getValue('VlanIdVoip'));
		
		if("CONNECTED" == IPWanList[IPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			str=str+'&x.Enable=0';
		}
		else
		{
			str=str+'&x.Enable=1';
			
			
		}
		
		str=str+'&x.X_HW_Token='+getValue('onttoken');
		
		setDisable('ButtonApply',1);
		$.ajax({
			type : "POST",
			async : false,
			cache : false,
			data : str,
			url :  action + '&RequestFile=html/bbsp/wan/basicwan.asp',
			error:function(XMLHttpRequest, textStatus, errorThrown) 
			{
				if(XMLHttpRequest.status == 404)
				{
				}
			}
		});	
		
		clearInterval(g_getpingtimer);
		
		setTimeout('RefreshWanInfo()', 3000); 		
		setTimeout('LoadFrame()', 8000); 
	}
}

function PingResultAction()
{
	if(parseInt(PingResult.SuccessCount) > 0)
	{
		DisableDataWan(1);
		setDisable('ButtonApply',0);
		if(IsVoiceRegtSucc() == true)
		{
			DisableVOIPWan(1);
		}
		else
		{
			DisableVOIPWan(0);
		}
	}
	else if(0 < StartPingFlag)
	{
		var ConnectionObj = document.getElementById("ServiceList");
		DisableDataWan(0);
		DisableVOIPWan(1);
		setDisable('ButtonApply',0);
		if((IsVoiceRegtSucc() == false) && (Languages['VoiceService'] == ConnectionObj.value))
		{
			setDisable("ButtonApply", 1);
		}
	}
}

function RefreshWanInfo()
{
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		timeout : 4000,
		url : "../common/GetRegWanIp.asp",
		success : function(data) {
			IPWanList = eval(data);
		}
	});	
		
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		timeout : 4000,
		url : "../common/GetRegWanPpp.asp",
		success : function(data) {
			PPPWanList = eval(data);
		}
	});
}

function LoadFrame()
{
	var IsInternetWanOK = false;
	
	CheckWanInfo();
	OnChangewWanServiceUI();
	for (i = 0;i < ConnectWanInfo.length;i++)
    {
    	if((ConnectWanInfo[i].X_HW_SERVICELIST.indexOf("INTERNET") != -1))
    	{
    		IsInternetWanOK = true;
        }
    }
	
	if(true != IsInternetWanOK)
	{
		RefreshWanInfo();
		setTimeout("LoadFrame()",6000);
	}
	
	if(true == IsInternetWanOK)
	{
		StartPingDiagnose();
		g_getpingtimer = setInterval('GetPingInternetStatus()', 1000); 
	}
	
}
</script>
<body  id="wanbody" onLoad="LoadFrame();"  class = "mainbody">
<div id="PromptPane2" style="display:none;">
</div>
<form id="ConfigForm">
<div class="PageTitle_title" id = "BasicInfoBar"><script>document.write(Languages['WanService']);</script></div>
<div class="PageTitle_content"><script>document.write(Languages['Basicwaninfo']);</script></div>
<table id="ConfigPanel"  width="100%" cellspacing="1" cellpadding="0" > 
<li   id="ServiceList"               RealType="DropDownList"       DescRef="ConnectionName"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.ServiceList"        InitValue="[{TextRef:'DataService',Value:'Data Service'},{TextRef:'VoiceService',Value:'Voice Service'}]" ClickFuncApp="onchange=OnChangewWanServiceUI"/>
<li   id="UserName"                  RealType="TextBox"            DescRef="IPv4UserName"              RemarkRef="IPv4UserNameHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.UserName"           InitValue="Empty"   MaxLength="64"/>
<li   id="Password"                  RealType="TextBox"            DescRef="IPv4Password"              RemarkRef="IPv4PasswordHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.Password"           InitValue="Empty"   MaxLength="64"/>
<li   id="IPv4IPAddress"             RealType="TextBox"            DescRef="IPv4IPAddress"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4IPAddress"      Elementclass="TextBoxLtr"   InitValue="Empty"/>
<li   id="IPv4SubnetMask"            RealType="TextBox"            DescRef="IPv4SubnetMask"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4SubnetMask"     Elementclass="TextBoxLtr"   InitValue="Empty"/>
<li   id="IPv4DefaultGateway"        RealType="TextBox"            DescRef="IPv4DefaultGateway"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="d.IPv4Gateway"        Elementclass="TextBoxLtr"   InitValue="Empty"/>
<li   id="VlanId"                    RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanId"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.VlanId"             InitValue="Empty"/>
<li   id="VlanIdVoip"                RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanId"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.VlanId"             InitValue="Empty"/>
</table>
<script>
var WanConfigFormList = [];
var dir_style = ("ARABIC" == LoginRequestLanguage.toUpperCase()) ? "rtl" : "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm",null);
HWParsePageControlByID("ConfigForm", TableClass, Languages, null);

ParsePageSpec();
</script>
<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td width="25%">
        </td>
        <td class="table_submit" style="padding-left: 5px">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <input id="ButtonApply"  type="button" value="OK" onclick="javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px" />
        </td>
    </tr>
</table>
<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
</table> 
<script>
	if(-1 == PPPWanIndex)
	{
		setText("ButtonApply", Languages["Connect"]);	
	}
	else
	{	
		if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			setText("ButtonApply", Languages["DisConnect"]);
		}
		else
		{
			setText("ButtonApply", Languages["Connect"]);		
		}
	}
</script>

</form>
<script>
	ParseBindTextByTagName(guideinternet_language, "span", 1);
	ParseBindTextByTagName(guideinternet_language, "input", 2);
</script>
</body>
</html>
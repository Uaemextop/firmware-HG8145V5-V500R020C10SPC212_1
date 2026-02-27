<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<style>
.uriclass
{ 
	word-break:break-all;
	min-width:30px;
}

.regnameclass
{ 
	word-break:break-all;
}
</style>
<script language="JavaScript" src='../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="/html/amp/common/wlan_list.asp"></script>
<script language="javascript" src="/html/bbsp/common/managemode.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list.asp"></script>
<script language="javascript" src="/html/bbsp/common/ontstate.asp"></script> 
<script language="javascript" src="/html/bbsp/common/wanaddressacquire.asp"></script> 
<title>General</title>
<script language="JavaScript" type="text/javascript">

function stOpticInfo(domain,transOpticPower,revOpticPower,voltage,temperature,bias,rfRxPower,rfOutputPower)
{
    this.domain = domain;
    this.transOpticPower = transOpticPower;
    this.revOpticPower = revOpticPower;
    this.voltage = voltage;
    this.temperature = temperature;
    this.bias = bias;
    this.rfRxPower = rfRxPower;
    this.rfOutputPower = rfOutputPower;
}

var opticType = '<%HW_WEB_GetOpticType();%>';
var opticPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.SMP.APM.ChipStatus.Optical);%>';
var status = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptTxMode.TxMode);%>';
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var ontXGMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.XG_AccessMode);%>';
var opticStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptStaus.status);%>';
var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower|Voltage|Temperature|Bias|RfRxPower|RfOutputPower, stOpticInfo);%>; 
var opticInfo = opticInfos[0];
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var SigProtol = '<%HW_WEB_GetSigProtol();%>';
var VoipSupport = '<%HW_WEB_GetFeatureSupport(HW_VSPA_FEATURE_VOIP);%>';

function stWlan(domain,enable,name,ssid,BeaconType,BasicEncrypt,BasicAuth,WPAEncrypt,WPAAuth,IEEE11iEncrypt,IEEE11iAuth,WPAand11iEncrypt,WPAand11iAuth,Channel,LowerLayers)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
    this.BeaconType = BeaconType;    
    this.BasicAuth = BasicAuth;
	this.BasicEncrypt = BasicEncrypt;    
    this.WPAAuth = WPAAuth;
	this.WPAEncrypt = WPAEncrypt;    
    this.IEEE11iAuth = IEEE11iAuth;
	this.IEEE11iEncrypt = IEEE11iEncrypt;
	this.WPAand11iAuth = WPAand11iAuth;
	this.WPAand11iEncrypt = WPAand11iEncrypt;
	this.Channel = Channel;	
	this.LowerLayers = LowerLayers;
}

var WlanInfo = new Array();
WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Enable|Name|SSID|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|Channel|LowerLayers,stWlan);%>;  
var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';
var AssociatedDevice = new stAssociatedDevice("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");

var WlanMap = new Array();

for (var i = 0; i < WlanInfo.length-1; i++)
{
    var index = getWlanPortNumber(WlanInfo[i].name);
	WlanMap[i] = new stIndexMapping(i, index);
}

if (WlanMap.length >= 2)
{
    for (var i = 0; i < WlanMap.length-1; i++)
    {
        for( var j =0; j < WlanMap.length-i-1; j++)
        {
            if (WlanMap[j+1].portIndex < WlanMap[j].portIndex)
            {
                var middle = WlanMap[j+1];
                WlanMap[j+1] = WlanMap[j];
                WlanMap[j] = middle;
            }
        }
    }
}

function LoadFrame()
{
    if(IsWlanAvailable())
    {
        setDisplay("DivStaInfo", 1);
    }

    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++)
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        b.innerHTML = status_optinfo_language[b.getAttribute("BindText")];
    }
}

function stLine(Domain, DirectoryNumber, PhyReferenceList, Status, CallState,RegisterError)
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
	
	this.PhyReferenceList = PhyReferenceList;
    this.Status = Status;
    this.CallState = CallState;
    this.RegisterError = RegisterError;
}

function stLineURI(Domain, URI)
{
	this.Domain = Domain;
	if(URI != null)
    {
        this.URI = URI.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.URI = URI;
    }

}


var AllLineURI = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,URI,stLineURI);%>;
var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i},DirectoryNumber|PhyReferenceList|Status|CallState|X_HW_LastRegisterError,stLine);%>;
var AllCodeAndReason = '<%HW_WEB_GetVspRegReason();%>';
var SplitCodeReason = AllCodeAndReason.split("|");

var OutputCodeReason = new Array();

for ( var m = 0; m < AllLine.length - 1; m++ )
{
	if ( m + 1 > SplitCodeReason.length )
	{
		OutputCodeReason[m] = '--';
	}
	else
	{
		if ( ( AllLine[m].RegisterError == 'ERROR_REGISTRATION_AUTH_FAIL' )
		     || ( AllLine[m].RegisterError == 'ERROR_REGISTRATION_TIME_OUT' )
			 || ( AllLine[m].RegisterError == 'ERROR_ERROR_RESPONSE_RETURNED_BY_CORENET' ) )
		{
			OutputCodeReason[m] = SplitCodeReason[m];
		}
		else
		{
			OutputCodeReason[m] = '--';
		}		
	}
}

function stAuth(Domain, AuthUserName)
{
    this.Domain = Domain;
	if(AuthUserName != null)
    {
        this.AuthUserName = AuthUserName.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.AuthUserName = AuthUserName;
    }
    
    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}

var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,AuthUserName,stAuth);%>;
var Auth = new Array();
for (var i = 0; i < AllAuth.length-1; i++) 
    Auth[i] = AllAuth[i];

var User = new Array();

function stUser(Domain, UserId)
{
    this.Domain = Domain;
    this.UserId = UserId;
}

for (var i = 0; i < AllLine.length - 1; i++)
{
    User[i] = new stUser();
    User[i].UserId = AllLine[i].DirectoryNumber;
}

function ShowTab(index, URI, AuthUserName, PhyReferenceList, Status,CallState,RegisterError,ErrorCode)
{
	this.index = index;
	this.URI = URI;
	this.AuthUserName = AuthUserName;
	this.PhyReferenceList = PhyReferenceList;
	this.Status = Status;
	this.CallState = CallState;
	this.RegisterError = RegisterError;
	this.ErrorCode = ErrorCode;
}

function stInterfaceState(Domain, X_HW_InterfaceState)
{
    this.Domain = Domain;
    this.X_HW_InterfaceState = X_HW_InterfaceState;
}

var InterfaceState = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1,X_HW_InterfaceState,stInterfaceState);%>;

function stLine(Domain, DirectoryNumber, PhyReferenceList,Status, CallState,RegisterError)
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
     
	this.PhyReferenceList = PhyReferenceList;
    this.Status = Status;
    this.CallState = CallState;
    this.RegisterError = RegisterError;
}

var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i},DirectoryNumber|PhyReferenceList|Status|CallState|X_HW_LastRegisterError,stLine);%>;

function stH248LineName(Domain, LineName)
{
    this.Domain = Domain;
	if(LineName != null)
    {
        this.LineName = LineName.toString().replace(/&apos;/g,"\'");
    }
    else
    {
        this.LineName = LineName;
    }
}

var AllH248LineName = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.X_HW_H248,LineName,stH248LineName);%>;

var User = new Array();

function stUser(Domain, UserId)
{
    this.Domain = Domain;
    this.UserId = UserId;
}
      
for (var i = 0; i < AllLine.length - 1; i++)
{
    User[i] = new stUser();
    User[i].UserId = AllH248LineName[i].LineName;
}

function GetInterfaceState()
{
	if ( InterfaceState[0].X_HW_InterfaceState == 'Closed' )
	{
		return h248status['vspa_state_closed'];
    }
    else if ( InterfaceState[0].X_HW_InterfaceState == 'Closing' )
    {
		return h248status['vspa_state_closing'];
    }
    else if ( InterfaceState[0].X_HW_InterfaceState == 'Inservice' )
    {
		return h248status['vspa_state_inserv'];
	}
	else if ( InterfaceState[0].X_HW_InterfaceState == 'Restarting' )
	{
		return h248status['vspa_state_restarting'];
	}
    else if ( InterfaceState[0].X_HW_InterfaceState == 'Graceful Closed' )
    {
		return h248status['vspa_state_grace'];
    }
    else if ( InterfaceState[0].X_HW_InterfaceState == 'MGC Disconnected' )
    {
		return h248status['vspa_state_discon'];
    }
    else if ( InterfaceState[0].X_HW_InterfaceState == 'MGC Switching' )
    {
       return h248status['vspa_state_switch'];
    }
    else
    {
       return '--';
    }
} 

function ShowTab(index, UserId, TelNo, PhyReferenceList, Status,CallState,InterfaceState,RegisterError)
{
	this.index = index;
	this.UserId = UserId;
	this.TelNo = TelNo;
	this.PhyReferenceList = PhyReferenceList;
	this.Status = Status;
	this.CallState = CallState;
	this.InterfaceState = InterfaceState;
	this.RegisterError = RegisterError;
}

function ChangeLanguageWanStatus(WanStatus)
{
	if ("DISCONNECTED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_disconnected'];
	}
	else if ("CONNECTED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_connected'];
	}
	else if ("UNCONFIGURED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_unconfigured'];
	}
	else
	{
		return WanStatus;
	}
}

var ClickWanType = "";

function selectLineipv4(id)
{	
	ClickWanType = "IPV4";
	selectLine(id);
}

</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">
<div id="ont_info_head" class="func_title"><SCRIPT>document.write(status_optinfo_language["amp_optinfo_ontinfo"]);</SCRIPT></div>
<table id="optic_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all">
  <tr >  
    <td class="tableTopTitle width_per35">&nbsp;</td>
    <td class="tableTopTitle" BindText='amp_optinfo_cur'></td>
    <td id="ref_head" class="tableTopTitle" BindText='amp_optinfo_ref'></td>    
  </tr >
  <tr id="optic_status_tr"> 
    <td class="table_title width_per35" BindText='amp_optic_status'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript"> 
            if(status == '')
            {
                  document.write(status_optinfo_language['amp_optic_unknown']);
            }
            else
            {
                if (opticStatus == 1)
 
                {
                    document.write(status_optinfo_language['amp_optic_none']);
                }
                else
                {
                    if ('OFF' == opticPower)
                    {
                        document.write(status_optinfo_language['amp_optic_disable']);
                    }
                    else
                    {
                        if ('enable' == status)
                        {
                            document.write(status_optinfo_language['amp_optic_fault']);
                        }
                        else
                        {
                            document.write(status_optinfo_language['amp_optic_auto']);
                        }
                    }
                }
            } 
             </script> </td>
    <td id="ref_status" class="table_right" BindText='amp_optic_ref'></td>
  </tr >
  <tr> 
    <td class="width_per35 table_title" BindText='amp_optic_txpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                    document.write(opticInfo.transOpticPower+' dBm');
                  }
                </script> </td>
    <td id="ref_tx" class="table_right">
    <script language="javascript" type="text/javascript">
    if (ontXGMode == '10g-gpon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10g']);
    }
    else if (ontXGMode == 'Asymmetric 10g-epon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10eas']);
    }
    else if (ontXGMode == 'Symmetric 10g-epon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10es']);
    }
    else if (ontXGMode == 'ge')
    {
    	document.write(status_optinfo_language['amp_optic_txref_ge']);
    }
	else
	{
    	document.write(status_optinfo_language['amp_optic_txref']);
    }
    </script>
    </td>
  </tr>
  <tr > 
    <td class="width_per35 table_title" BindText='amp_optic_rxpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                    document.write(opticInfo.revOpticPower+' dBm');
                  }
                </script> </td>
    <td id="ref_rx" class="table_right"><script language="javascript" type="text/javascript">
                if ((ontPonMode == 'gpon' || ontPonMode == 'GPON'))
                {
                    if (ontXGMode == 'gpon')
                    {
                    
	                    if (opticType == 2)
	                    {
	                        document.write(status_optinfo_language['amp_optic_classc_plus_rxrefg']);
	                    }
	                    else
	                    {
	                        document.write(status_optinfo_language['amp_optic_rxrefg']);
	                    }
                    }
                    else
                    {
                    	document.write(status_optinfo_language['amp_optic_rxref_10g']);
                    }
                }
                else if ((ontPonMode == 'epon' || ontPonMode == 'EPON'))
                {
                    if (ontXGMode == 'epon')
                    {
                    	document.write(status_optinfo_language['amp_optic_rxrefe']);
                    }
                    else
                    {
                    	document.write(status_optinfo_language['amp_optic_rxref_10e']);
                    }
                }
				else
				{
				    document.write(status_optinfo_language['amp_optic_rxref_ge']);
				}
    </script></td>
  </tr>
</table>


<div class="func_spread"></div>



<script type="text/javascript" language="javascript">
	document.write('<div  id="IPTable" style="overflow-x:auto;overflow-y:hidden;width:100%;">');
</script>
<table class="tabal_bg width_per100"  cellspacing="1" id="IPv4Panel"> 
  <tr class="head_title"> 
     <script type="text/javascript" language="javascript">
		document.write('<td class="align_left" colspan="5" >'+ waninfo_language['bbsp_ipv4info']+ '</td>');
	 </script>
  </tr> 
  <tr class="head_title"> 
	<script type="text/javascript" language="javascript">
		document.write('<td>'+waninfo_language['bbsp_wanname']+'</td>');
		document.write('<td>'+waninfo_language['bbsp_linkstate']+'</td>');
		document.write('<td>'+waninfo_language['bbsp_ip']+'</td>');
		document.write('<td>'+waninfo_language['bbsp_vlanpri']+'</td>');
		document.write('<td>'+waninfo_language['bbsp_con']+'</td>');
	</script>
  </tr> 
	<script type="text/javascript" language="javascript">
	
	function replaceSpace(str)
	{

		if(str.indexOf(" ")!=-1)
		{
			str=str.replace(/ /g,"&#160;");
		}
		return str;
	}

	function AddTimeUnit(time,timeunit)
	{
		if(time.toString().length == 0||(time == "--"))
			return time;
		else
			return time.toString() +" "+ timeunit;
	}
	
	function convertDHCPLeaseTimeRemaining(DHCPLeaseTimeRemaining)
	{
		if('0' == DHCPLeaseTimeRemaining || '' == DHCPLeaseTimeRemaining)
		{
		   return "";
		}
		else
		{
		   return DHCPLeaseTimeRemaining;
		}
	}

	function GetStaticRouteInfo(string)
	{
	     if (typeof(string) != "undefined") { 
		  document.getElementById("StaticRoute").innerHTML = string;
	     }
	}
	
	function GetOption121(wanindex)
	{
		var Option121Info="";
		
		$.ajax({
			type : "POST",
			async : true,
			cache : false,
			timeout : 2000,
			url : "globeoption121.cgi?WANNAME=wan"+wanindex,
			success : function(data) {
			res = data.split("\n");
			GetStaticRouteInfo(res[1]);
			},
			complete: function (XHR, TS) { 
			
				Option121Info=null;
				
				XHR = null;
		  }			
		});	
	}

	function DisplayIPv4WanDetail(WanIndex)
	{
		var CurrentWan = GetWanList()[WanIndex]; 
		document.getElementById("WanDetail").style.display = ""; 

		document.getElementById("MacAddress").innerHTML = CurrentWan.MACAddress;	
		document.getElementById("wanpriority").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? waninfo_language['bbsp_wanpriority'] : waninfo_language['bbsp_wandefaultpri'];
		
		if ( 0 == parseInt(CurrentWan.VlanId,10) )
		{
			if(("Connected" == CurrentWan.Status) && ('' != CurrentWan.IPv4IPAddress) )
			{
				document.getElementById("Vlan").innerHTML = "";
				document.getElementById("Priority").innerHTML = "";
				document.getElementById("PriorityPolicy").innerHTML = "";
			}
			else
			{
				document.getElementById("Vlan").innerHTML = "--";
				document.getElementById("Priority").innerHTML = "--";
				document.getElementById("PriorityPolicy").innerHTML = "--";
			}
		}
		else
		{
			document.getElementById("Vlan").innerHTML = CurrentWan.VlanId;
			document.getElementById("Priority").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? CurrentWan.Priority : CurrentWan.DefaultPriority;
			document.getElementById("PriorityPolicy").innerHTML = waninfo_language[CurrentWan.PriorityPolicy];
		}
		
		if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
		{
			document.getElementById("IPAddressMode").innerHTML = "--";
		}
		else
		{
			document.getElementById("IPAddressMode").innerHTML = CurrentWan.IPv4AddressMode;
		}

		if( 'IP_Routed' == CurrentWan.Mode )
		{
			document.getElementById("NatSwitchRow").style.display = "";
			document.getElementById("NatSwitch").innerHTML = CurrentWan.IPv4NATEnable == "1" ? waninfo_language['bbsp_enable']: waninfo_language['bbsp_disable'];
			document.getElementById("IpAdressRow").style.display = "";
			document.getElementById("GateWayRow").style.display = "";
			document.getElementById("DnsServerRow").style.display = "";
			
			if(("Connected" == CurrentWan.Status ) && ('' != CurrentWan.IPv4IPAddress) )
			{
				document.getElementById("IpAdress").innerHTML = CurrentWan.IPv4IPAddress + "/" + CurrentWan.IPv4SubnetMask;
				document.getElementById("GateWay").innerHTML = CurrentWan.IPv4Gateway;
				
				var DnsSplitCharacter = ("" == CurrentWan.IPv4SecondaryDNS) ? " " : ",";
				document.getElementById("DnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + DnsSplitCharacter +CurrentWan.IPv4SecondaryDNS;
			}
			else
			{
				document.getElementById("IpAdress").innerHTML = "--";
				document.getElementById("GateWay").innerHTML = "--";
				document.getElementById("DnsServer").innerHTML = "--";
			} 
		
			if('IPoE' == CurrentWan.EncapMode)
			{
				document.getElementById("BrasNameRow").style.display = "none";
				document.getElementById("PPPUsernameRow").style.display = "none";
				document.getElementById("PPPPasswordRow").style.display = "none";
				if ("STATIC" == CurrentWan.IPv4AddressMode.toUpperCase())
				{
					document.getElementById("LeaseTimeRow").style.display = "none";
					document.getElementById("LeaseTimeRemainingRow").style.display = "none";
					document.getElementById("NtpServerRow").style.display = "none";
					document.getElementById("STimeRow").style.display = "none";
					document.getElementById("SipServerRow").style.display = "none";
					document.getElementById("StaticRouteRow").style.display = "none";
					document.getElementById("VenderInfoRow").style.display = "none";
				}
				else
				{
					document.getElementById("LeaseTimeRow").style.display = "";
					document.getElementById("LeaseTimeRemainingRow").style.display = "";
					document.getElementById("NtpServerRow").style.display = "";
					document.getElementById("STimeRow").style.display = "";
					document.getElementById("SipServerRow").style.display = "";
					document.getElementById("StaticRouteRow").style.display = "";
					document.getElementById("VenderInfoRow").style.display = "";
				}
				
				if("Connected" == CurrentWan.Status)
				{
					document.getElementById("LeaseTime").innerHTML = AddTimeUnit(CurrentWan.DHCPLeaseTime,waninfo_language['bbsp_timeunit']);
					document.getElementById("LeaseTimeRemaining").innerHTML = AddTimeUnit(convertDHCPLeaseTimeRemaining(CurrentWan.DHCPLeaseTimeRemaining),waninfo_language['bbsp_timeunit']);
					document.getElementById("NtpServer").innerHTML = CurrentWan.NTPServer;
					document.getElementById("STime").innerHTML = CurrentWan.TimeZoneInfo;
					document.getElementById("SipServer").innerHTML = CurrentWan.SIPServer;
					
					document.getElementById("StaticRoute").innerHTML = "";
					if ("DHCP" == CurrentWan.IPv4AddressMode.toUpperCase())
					{
						GetOption121(CurrentWan.MacId);
					}
					else
					{
						document.getElementById("StaticRoute").innerHTML = CurrentWan.StaticRouteInfo;
					}					
					IPv4VendorId = CurrentWan.IPv4VendorId;
					document.getElementById("VenderInfo").innerHTML = replaceSpace(GetStringContent(IPv4VendorId,16));
					document.getElementById("VenderInfo").title = IPv4VendorId;
				}
				else
				{
					document.getElementById("LeaseTime").innerHTML = "--";
					document.getElementById("LeaseTimeRemaining").innerHTML = "--";
					document.getElementById("NtpServer").innerHTML = "--";
					document.getElementById("STime").innerHTML = "--";
					document.getElementById("SipServer").innerHTML = "--";
					document.getElementById("StaticRoute").innerHTML = "--";
					document.getElementById("VenderInfo").innerHTML = "--";
				}
				if ( bin4board_nonvoice() == true )
				{
					document.getElementById("SipServerRow").style.display = "none";
				}
			}
			else
			{
				document.getElementById("BrasNameRow").style.display = "";
				document.getElementById("LeaseTimeRow").style.display = "none";
				document.getElementById("LeaseTimeRemainingRow").style.display = "none";
				document.getElementById("NtpServerRow").style.display = "none";
				document.getElementById("STimeRow").style.display = "none";
				document.getElementById("SipServerRow").style.display = "none";
				document.getElementById("StaticRouteRow").style.display = "none";
				document.getElementById("VenderInfoRow").style.display = "none";
				document.getElementById("PPPUsernameRow").style.display = "";
				document.getElementById("PPPPasswordRow").style.display = "";
				document.getElementById("PPPUsername").innerHTML = CurrentWan.UserName;
				document.getElementById("PPPPassword").innerHTML = "***";
				if("Connected" == CurrentWan.Status)
				{
					document.getElementById("BrasName").innerHTML = CurrentWan.PPPoEACName;
				}
				else
				{
					document.getElementById("BrasName").innerHTML = "--";
				}
			}
		}
		else
		{
			document.getElementById("NatSwitchRow").style.display = "none";
			document.getElementById("IpAdressRow").style.display = "none";
			document.getElementById("GateWayRow").style.display = "none";
			document.getElementById("DnsServerRow").style.display = "none";
			document.getElementById("BrasNameRow").style.display = "none";
			document.getElementById("LeaseTimeRow").style.display = "none";
			document.getElementById("LeaseTimeRemainingRow").style.display = "none";
			document.getElementById("NtpServerRow").style.display = "none";
			document.getElementById("STimeRow").style.display = "none";
			document.getElementById("SipServerRow").style.display = "none";
			document.getElementById("StaticRouteRow").style.display = "none";
			document.getElementById("VenderInfoRow").style.display = "none";
			document.getElementById("PPPUsernameRow").style.display = "none";
			document.getElementById("PPPPasswordRow").style.display = "none";
		} 
	}
	
	function setControl(WanIndex,id)
	{	
		var pos = "record_ipv4_";
		if( id != pos + WanIndex)
		{
			return;
		}
		var CurrentWan = GetWanList()[WanIndex]; 
		if ("1" == CurrentWan.IPv4Enable)
		{
			DisplayIPv4WanDetail(WanIndex);
		}
	}

	var IPv4WanCount = 0;
    
	for (i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		if (CurrentWan.IPv4Enable != "1")
		{
			continue;
		}
		IPv4WanCount ++;
	
		document.write('<TR id="record_ipv4_' + i + '" onclick="selectLineipv4(this.id);" class="table_title">');

		document.write('<td align="center">'+CurrentWan.Name+'</td>');

        if (GetOntState()!='ONLINE')
        {
            document.write('<td align="center">'+ChangeLanguageWanStatus('Disconnected')+'</td>');
        }
        else
        {
            if ("UNCONFIGURED" == CurrentWan.Status.toUpperCase())
            {
                document.write('<td align="center">'+ChangeLanguageWanStatus('Disconnected')+'</td>');
            }
            else
            {
                document.write('<td align="center">'+ChangeLanguageWanStatus(CurrentWan.Status)+'</td>');
            }
        }
		
		if((CurrentWan.Status=="Connected") && (CurrentWan.IPv4IPAddress != '') && (CurrentWan.Mode == 'IP_Routed'))
		{
			document.write('<td align="center">'+CurrentWan.IPv4IPAddress + '</td>');
		}
		else
		{
			document.write('<td align="center">--</td>');
		}
		
		if ( 0 != parseInt(CurrentWan.VlanId,10) )
		{	
			var pri = ('Specified' == CurrentWan.PriorityPolicy) ? CurrentWan.Priority : CurrentWan.DefaultPriority ;
			document.write('<td align="center">'+CurrentWan.VlanId+'/'+pri+'</td>');
		}
		else
		{
			document.write('<td align="center">'+'-/-'+'</td>');
		}
		

		if (NeedAddConnectButton(CurrentWan) == true && CurrentWan.Enable == "1")
		{
				var btText = CurrentWan.ConnectionControl == "1" ? waninfo_language['bbsp_discon']: waninfo_language['bbsp_con'];
				var ctrFlag = CurrentWan.ConnectionControl == "1" ? "0": "1";
				document.write("<td align='center'><a style='color:blue' onclick = 'OnConnectionControlButtonIraqO3(this,"+i+","+ctrFlag+")' RecordId = '"+i+"' href='#'>"+btText+"</a></td>");
		}
		else
		{
			var innerText = CurrentWan.Enable == "1" ? "AlwaysOn":"AlwaysOn";
			if (CurrentWan.ConnectionTrigger == "OnDemand")
			{
				innerText = waninfo_language['bbsp_needcon'];
			}
			else if (CurrentWan.ConnectionTrigger == "Manual")
			{
				innerText = waninfo_language['bbsp_Manual'];
			}
			document.write("<td align=\"center\">"+innerText+"</td>");
		}
	
	
		
		document.write('</tr>');
	}
	if(0 == IPv4WanCount)
	{
		document.write("<tr class= \"tabal_center01\">");
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write("</tr>");
	}
	</script> 
</table> 

<div  align='center' style="display:none" id="WanDetail">
<table class="tabal_bg width_per100"  cellspacing="1" > 
  <tr class="head_title align_left"> 
	<script type="text/javascript" language="javascript">
		document.write('<td colspan="5">'+waninfo_language['bbsp_wandetailinfo']+'</td>');
	</script>
  </tr> 

  <tr class="table_title align_left">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanmacaddress']+'</td>');
	</script>
    <td  width="70%" id="MacAddress"></td>
  </tr>
  <tr class="table_title align_left" id="VlanRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanvlan']+'</td>');
	</script>
    <td  width="70%" id="Vlan"></td>
 </tr>
  <tr class="table_title align_left" id="PriorityPolicyRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanpripolicy']+'</td>');
	</script>
    <td  width="70%" id="PriorityPolicy"></td>
  </tr> 
  </tr>
  <tr class="table_title align_left" id="PriorityRow">
    <td  width="30%" id='wanpriority'></td>
    <td  width="70%" id="Priority"></td>
  </tr>
  <tr class="table_title align_left" id="NatSwitchRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wannat']+'</td>');
	</script>	
    <td  width="70%" id="NatSwitch"></td>
  </tr>
  <tr class="table_title align_left" id="IPAddressModeRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_ipmode1']+'</td>');
	</script>	
    <td  width="70%" id="IPAddressMode"></td>
  </tr>
   <tr class="table_title align_left"  id="PPPUsernameRow">
    <td  width="30%"><script>document.write(Languages['IPv4UserName']);</script></td>
    <td  width="70%" id="PPPUsername"></td>
  </tr>
  <tr class="table_title align_left"  id="PPPPasswordRow">
    <td  width="30%"><script>document.write(Languages['IPv4Password']);</script></td>
    <td  width="70%" id="PPPPassword"></td>
  </tr>
  <tr class="table_title align_left" id="IpAdressRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanip']+'</td>');
	</script>	
    <td  width="70%" id="IpAdress"></td>
  </tr>
  <tr class="table_title align_left" id="GateWayRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wangateway']+'</td>');
	</script>
    <td  width="70%" id="GateWay"></td>
  </tr>
  <tr class="table_title align_left" id="DnsServerRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wandns']+'</td>');
	</script>
    <td  width="70%" id="DnsServer"></td>
  </tr>
  
  <tr class="table_title align_left" id="BrasNameRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanbras']+'</td>');
	</script>
    <td  width="70%" id="BrasName"></td>
  </tr>
  
  <tr class="table_title align_left" id="LeaseTimeRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanlease']+'</td>');
	</script>
    <td  width="70%" id="LeaseTime"></td>
  </tr>
  <tr class="table_title align_left" id="LeaseTimeRemainingRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanlease_remaining']+'</td>');
	</script>
    <td  width="70%" id="LeaseTimeRemaining"></td>
  </tr>
  <tr class="table_title align_left" id="NtpServerRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanntp']+'</td>');
	</script>
    <td  width="70%" id="NtpServer"></td>
  </tr>
  <tr class="table_title align_left" id="STimeRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanstime']+'</td>');
	</script>
    <td  width="70%" id="STime"></td>
  </tr>
  <tr class="table_title align_left" id="SipServerRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wansip']+'</td>');
	</script>
    <td  width="70%" id="SipServer"></td>
  </tr>
  <tr class="table_title align_left" id="StaticRouteRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wansroute']+'</td>');
	</script>
    <td  width="70%" id="StaticRoute"></td>
  </tr>
  <tr class="table_title align_left"  id="VenderInfoRow">
	<script type="text/javascript" language="javascript">
		document.write('<td width="30%">'+waninfo_language['bbsp_wanvendor']+'</td>');
	</script>
    <td  width="70%" id="VenderInfo"></td>
  </tr>
</table>
</div>
<div class="func_spread"></div>

<div id="DivStaInfo">
<div id="ApplyBthSTA">
	<div class="func_title">
	    <SCRIPT>document.write(status_wlaninfo_language["amp_stainfo_title"]);</SCRIPT>
	</div>

	<input id="btn_sta_query" name="btnCheck" type="button" value="" class="NewDelbuttoncss">
	<script>
        document.getElementById('btn_sta_query').value = status_wlaninfo_language['amp_stainfo_query'];
	</script>
	<div class="button_spread"></div>
</div>

<div id="DivStaQueryInfo_Table_Container" style="overflow:auto;overflow-y:hidden;">
<script language="javascript">
  $(document).ready(function () {
        var viewModel = {
            $DivStaInfo: $('#DivStaInfo'),
            $btn_sta_query: $('#btn_sta_query'),
            $StaInfoTable: $('#wlan_stainfo_table'),
            
             appendStaInfo: function(record) {

			 var TbHtml = '';

			 var STATShowableFlag = 1;
  			 var STAShowButtonFlag = 0;
  			 var STAColumnNum = 12;
			 var STAArray = new Array();
  			 var STAConfiglistInfo = new Array(
			 			new stTableTileInfo("amp_stainfo_macadd","align_center","AssociatedDeviceMACAddress",false),
  						new stTableTileInfo("amp_wlanstat_name","align_center","ssidname",false),
  						new stTableTileInfo("amp_stainfo_uptime","align_center","X_HW_Uptime",false),
  						new stTableTileInfo("amp_stainfo_txrate","align_center","X_HW_TxRate",false),
  						new stTableTileInfo("amp_stainfo_rxrate","align_center","X_HW_RxRate",false),
  						new stTableTileInfo("amp_stainfo_rssi","align_center","X_HW_RSSI",false),
  						new stTableTileInfo("amp_stainfo_noise","align_center","X_HW_Noise",false),
  						new stTableTileInfo("amp_stainfo_snr","align_center","X_HW_SNR",false),
  						new stTableTileInfo("amp_stainfo_sigqua","align_center","X_HW_SingalQuality",false),
  						new stTableTileInfo("amp_stainfo_working_mode","align_center","X_HW_WorkingMode",0==isStaWorkingModeShow),
  						new stTableTileInfo("amp_stainfo_wmm_status","align_center","X_HW_WMMStatus",0==isStaWorkingModeShow),
  						new stTableTileInfo("amp_stainfo_ps_mode","align_center","X_HW_PSMode",0==isStaWorkingModeShow),null);

	          var ssidstart = 0;
	          var ssidend   = SsidPerBand - 1;

            for (i = 0; i < record.length - 1; i++)
            {
                var ssid = getWlanInstFromDomain(record[i].domain);  

                for (j = 0; j < WlanInfo.length - 1; j++)
                {
                    var ret = WlanInfo[j].domain.indexOf("InternetGatewayDevice.LANDevice.1.WLANConfiguration."+ssid);
                    if (ret == 0)
                    {
                        var wlanInst = getWlanInstFromDomain(WlanInfo[j].domain);
                        if (1 == isSsidForIsp(wlanInst))
                        {
                            continue;
                        }	

                        var athindex = getWlanPortNumber(WlanInfo[j].name);
                        if (( athindex >= ssidstart )&&( athindex <= ssidend ))
                        {
                            record[i].ssidname = WlanInfo[j].ssid;
							viewModel.convertStaDataToHtml(record[i]);
				   			STAArray.push(record[i]);
                        }
                    }
                }
            }            

			if(STAArray.length != 0)
            	STAArray.push(null);
			
            var _write = document.write;
			document.write = function( str )
			{
			    TbHtml += str;
			}

			HWShowTableListByType(STATShowableFlag, "wlan_stainfo_table", STAShowButtonFlag, STAColumnNum, STAArray, STAConfiglistInfo, status_wlaninfo_language, null);
			$('#DivStaQueryInfo_Table_Container').html(TbHtml);
			document.write = _write;

			fixIETableScroll("DivStaQueryInfo_Table_Container", "wlan_stainfo_table");
			
			},
            processEmptyValue: function(record) {
          	if(!record || typeof record != 'object') return ;
          	
          	for(var pKey in record) {
          		record[pKey] = record[pKey] || '--';
          		}
          		
          	return record;
          },
            convertStaDataToHtml: function(record) {
            	
       			record = viewModel.processEmptyValue(record);
          		if(!record) return "";
          		
          		if( record.X_HW_RSSI < -80 )
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level1'];  
			        }
			        if(( record.X_HW_RSSI >= -80 )&&( record.X_HW_RSSI <= -75 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level2'];  
			        }
			        if(( record.X_HW_RSSI > -75 )&&( record.X_HW_RSSI <= -69 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level3'];  
			        }
			        if(( record.X_HW_RSSI > -69 )&&( record.X_HW_RSSI <= -63 ))
			        {
			            record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level4'];  
			        }
			        if( record.X_HW_RSSI > -63 )
			        {
			           record.X_HW_RSSI += status_wlaninfo_language['amp_stainfo_level5'];  
			        }
					
				if( 1 == record.X_HW_WMMStatus )
				{
					record.X_HW_WMMStatus = status_wlaninfo_language['amp_stainfo_wmm_on'];
				}
				else if( 0 == record.X_HW_WMMStatus )
				{
					record.X_HW_WMMStatus = status_wlaninfo_language['amp_stainfo_wmm_off'];
				}
				else
				{
					record.X_HW_WMMStatus = '--';
				}
				
				if( 1 == record.X_HW_PSMode )
				{
					record.X_HW_PSMode = status_wlaninfo_language['amp_stainfo_ps_on'];
				}
				else if( 0 == record.X_HW_PSMode )
				{
					record.X_HW_PSMode = status_wlaninfo_language['amp_stainfo_ps_off'];
				}
				else
				{
					record.X_HW_PSMode = '--';
				}
    	  
          		record.AssociatedDeviceMACAddress = record.AssociatedDeviceMACAddress.toUpperCase();
				record.ssidname = GetSSIDStringContent(record.ssidname,32);
          	}
        };

		viewModel.$btn_sta_query.click(function(){
			    
				if (wlanEnbl == 0)
		        {
		            return;
		        }

				viewModel.$btn_sta_query.attr('disabled', 'disabled');

           		$.ajax({
					type : "post",
					async : true,
					url : "html/amp/wlaninfo/getassociateddeviceinfo.asp",
					success : function(data) {	
					
					AssociatedDevice = eval(data);	

					viewModel.appendStaInfo(AssociatedDevice);	

					viewModel.$btn_sta_query.removeAttr('disabled');
					}		
				});
			});

		viewModel.appendStaInfo(new Array());
    }); 

</script>
</div>
</div>


<div class="func_spread"></div>

<div id="ont_info_head" class="func_title">
<script>if (1 == VoipSupport ){document.write(sipstatus["v01"]);}</script>
</div>

<script language="JavaScript" type="text/JavaScript">
var i = 0;
var ShowableFlag = 0;
var ShowButtonFlag = 0;

if ("SIP" == SigProtol )
{
	ShowableFlag = 1;
}

var ColumnNum = 8;
var VoipArray = new Array();
var ConfiglistInfo = new Array(
		new stTableTileInfo("vspa_seq","align_center ","index",false),
		new stTableTileInfo("vspa_uri","uriclass align_center","URI",CfgMode.toUpperCase() == 'PTVDF'),
		new stTableTileInfo("vspa_username","regnameclass align_center","AuthUserName",false),
		new stTableTileInfo("vspa_assopots","align_center","PhyReferenceList",false),
		new stTableTileInfo("vspa_userstat","align_center","Status",false),
		new stTableTileInfo("vspa_callstat","align_center","CallState",false),
		new stTableTileInfo("vspa_errorstat","regnameclass align_center","RegisterError",false),
		new stTableTileInfo("vspa_regcodereason","align_center","ErrorCode",false),null);

if(AllLine.length - 1 == 0)
{
	var VoipShowTab = new ShowTab();
	VoipShowTab.index = "--";
	VoipShowTab.URI = "--";
	VoipShowTab.AuthUserName = "--";
	VoipShowTab.PhyReferenceList = "--";
	VoipShowTab.Status = "--"; 
	VoipShowTab.CallState = "--"; 
	VoipShowTab.RegisterError = "--"; 
	VoipShowTab.ErrorCode = "--"; 
}

else
{
	for (i = 0; i < AllLine.length - 1; i++)
	{
		var VoipShowTab = new ShowTab();
		VoipShowTab.index = i + 1;
		
		if(CfgMode.toUpperCase() != 'PTVDF')
		{
			if (AllLineURI[i].URI == "")
			{
				VoipShowTab.URI = "--";
			}
			else
			{
				VoipShowTab.URI = AllLineURI[i].URI;
			}
		}
		
		
		if (User[i].UserId == "")
		{
			 if( Auth[i].AuthUserName.indexOf(":") >= 0)
			 {
				var Authpart = Auth[i].AuthUserName.split(':');
				var k1 = Authpart[1];
				var k2 = k1.split('@');
				var k3 = k2[0];
				if (k3 == "")
				{   
					VoipShowTab.AuthUserName = "--";
				}
				else
				{    
					VoipShowTab.AuthUserName = k3;
				}
			 }
			 else
			 {
				 var Authpart = Auth[i].AuthUserName.split('@');
				 var k = Authpart[0];
				if (k == "")
				{    
					VoipShowTab.AuthUserName = "--";
				}
				else
				{   
					VoipShowTab.AuthUserName = k; 
				}
			 }
		}
		else
		{
			 if( User[i].UserId.indexOf(":") >= 0)
			 {
				 var UserId = User[i].UserId.split(':');
				 var k1 = UserId[1];
				var k2 = k1.split('@');
				var k3 = k2[0];
				if (k3 == "")
				{    
					VoipShowTab.AuthUserName = "--";
				}
				else
				{    
					VoipShowTab.AuthUserName = k3;
				}
			 }
			 else
			 {
				 var UserId = User[i].UserId.split('@');
				 var k = UserId[0];
				if (k == "")
				{ 
					VoipShowTab.AuthUserName = "--";   
				}
				else
				{    
					VoipShowTab.AuthUserName = k; 
				}
			 }
		}   
		
		if (AllLine[i].PhyReferenceList == "")
		{    
			VoipShowTab.PhyReferenceList = "--";
		}
		else
		{    
			VoipShowTab.PhyReferenceList = AllLine[i].PhyReferenceList;
		}
		
 		if ( AllLine[i].Status == 'Up' )
		{
			VoipShowTab.Status = sipstatus['vspa_status_succ'];
		}
		else if ( AllLine[i].Status == 'Initializing' )
		{    
			VoipShowTab.Status = sipstatus['vspa_status_ini'];
		}
		else if ( AllLine[i].Status == 'Registering' )
		{    
			VoipShowTab.Status = sipstatus['vspa_status_reg'];
		}
		else if ( AllLine[i].Status == 'Unregistering' )
		{  
	    	VoipShowTab.Status = sipstatus['vspa_status_unreg'];
		}
		else if ( AllLine[i].Status == 'Quiescent' )
		{    
			VoipShowTab.Status = sipstatus['vspa_status_qui'];
		}
		else if ( AllLine[i].Status == 'Disabled' )
		{
			VoipShowTab.Status = sipstatus['vspa_status_disa'];    
		}
		else if ( AllLine[i].Status == 'Error' )
		{
			VoipShowTab.Status = sipstatus['vspa_status_err'];    
		}
		else if ( AllLine[i].Status == 'Testing' )
		{
			VoipShowTab.Status = sipstatus['vspa_status_test'];    
		}
		else
		{
			VoipShowTab.Status = "--";  
		}
		
		if ( AllLine[i].CallState == 'Idle' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_idle']; 
		}
		else if ( AllLine[i].CallState == 'Calling' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_cal']; 
		}
		else if ( AllLine[i].CallState == 'Ringing' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_ring'];
		}
		else if ( AllLine[i].CallState == 'Connecting' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_con']; 
		}
		else if ( AllLine[i].CallState == 'InCall' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_incall']; 
		}
		else if ( AllLine[i].CallState == 'Hold' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_hold'];    
		}
		else if ( AllLine[i].CallState == 'Disconnecting' )
		{
			VoipShowTab.CallState = sipstatus['vspa_callstat_dis'];    
		}
		else
		{
			VoipShowTab.CallState = "--";    
		}		

		if ( AllLine[i].RegisterError == '-' )
		{
			VoipShowTab.RegisterError = "--";    
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ONU_OFFLINE' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_onuoffine'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_NOT_CONFIGURED' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_wannotconfigured'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_IP_NOT_OBTAINED' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_wannotobtained'];
			
		}
		else if ( AllLine[i].RegisterError == 'ERROR_CORENET_ADDRESS_INCORRECT' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_mgcincorrect'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_VOICESERVICE_DISABLED' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_voicedisabled'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_CONFIGURED' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_usernotconfigured'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_BOUND_TO_POTS' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_usernotboundport'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_POTS_DISABLED_BY_OLT' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_portdisabledOLT'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_DISABLED' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_userdisable'];
		}
        else if ( AllLine[i].RegisterError == 'ERROR_USER_CONFLICT' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_userconflict'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_AUTH_FAIL' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_regauthfails'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_TIME_OUT' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_regtimesout'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ERROR_RESPONSE_RETURNED_BY_CORENET' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_mgcerrorresponse'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_UNKNOWN' )
		{
			VoipShowTab.RegisterError = sipstatus['vspa_errorstate_unknownerror'];
		}
		else
		{
			VoipShowTab.RegisterError = "--";
		}
		
		VoipShowTab.ErrorCode = OutputCodeReason[i];		
		VoipArray.push(VoipShowTab);
	}
}
VoipArray.push(null);
HWShowTableListByType(ShowableFlag, "tdVoipInfo", ShowButtonFlag, ColumnNum, VoipArray, ConfiglistInfo, sipstatus, null);
</script>

<script language="JavaScript" type="text/JavaScript">
var i = 0;
var ShowableFlag = 0;
var ShowButtonFlag = 0;
if ("H248" == SigProtol || "H.248" == SigProtol)
{
	ShowableFlag = 1;
}
var ColumnNum = 8;
var VoipArray = new Array();
var ConfiglistInfo = new Array(
new stTableTileInfo("vspa_seq","align_center","index",false),
new stTableTileInfo("vspa_linename","align_center","UserId",false),
new stTableTileInfo("vspa_telno","align_center","TelNo",false),
new stTableTileInfo("vspa_assopots","align_center","PhyReferenceList",false),
new stTableTileInfo("vspa_userstat","align_center","Status",false),
new stTableTileInfo("vspa_callstat","align_center","CallState",false),
new stTableTileInfo("vspa_interfacestatu","align_center","InterfaceState",false),
new stTableTileInfo("vspa_errorstat","align_center","RegisterError",false),null);

if (AllLine.length - 1 == 0)
{
	var VoipShowTab = new ShowTab();
	
	VoipShowTab.index = "----";
	VoipShowTab.UserId = "----"; 
	VoipShowTab.TelNo = "----";
	VoipShowTab.PhyReferenceList = "----";
	VoipShowTab.Status = "----";
	VoipShowTab.CallState = "----";
	VoipShowTab.InterfaceState = GetInterfaceState();
	VoipShowTab.RegisterError = "----";

}
else
{
	for (i = 0; i < AllLine.length - 1; i++)
	{
		var VoipShowTab = new ShowTab();
		VoipShowTab.index = i + 1;		
				
		if ( User[i].UserId == "")
		{	
			VoipShowTab.UserId = "--";
		}
		else
		{  
			VoipShowTab.UserId = User[i].UserId;         
		}
		
		VoipShowTab.TelNo = "--";
		
		VoipShowTab.PhyReferenceList = AllLine[i].PhyReferenceList;

		if ( AllLine[i].Status == 'Up' )
		{
			VoipShowTab.Status = h248status['vspa_state_up'];
		}
		else if ( AllLine[i].Status == 'Initializing' )
		{
			VoipShowTab.Status = h248status['vspa_state_ini'];
		}
		else if ( AllLine[i].Status == 'Registering' )
		{
			VoipShowTab.Status = h248status['vspa_state_reg'];
		}
		else if ( AllLine[i].Status == 'Unregistering' )
		{
			VoipShowTab.Status = h248status['vspa_state_unreg'];
		}
		else if ( AllLine[i].Status == 'Error' )
		{
			VoipShowTab.Status = h248status['vspa_state_err'];
		}
		else if ( AllLine[i].Status == 'Testing' )
		{
			VoipShowTab.Status = h248status['vspa_state_test'];
		}		
		else if ( AllLine[i].Status == 'Quiescent' )
		{
			VoipShowTab.Status = h248status['vspa_state_quies'];
		}
		else if ( AllLine[i].Status == 'Disabled' )
		{
			VoipShowTab.Status = h248status['vspa_state_disable'];
		}
		else
		{
			VoipShowTab.Status = "--";
		}
		
		if ( AllLine[i].CallState == 'Idle' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_idle'];
		}
		else if ( AllLine[i].CallState == 'Calling' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_call'];
		}
		else if ( AllLine[i].CallState == 'Ringing' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_ring'];
		}
		else if ( AllLine[i].CallState == 'Connecting' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_con'];
		}
		else if ( AllLine[i].CallState == 'InCall' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_incall'];
		}
		else if ( AllLine[i].CallState == 'Hold' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_hold'];
		}
		else if ( AllLine[i].CallState == 'Disconnecting' )
		{
			VoipShowTab.CallState = h248status['vspa_calstate_discon'];
		}
		else
		{
			VoipShowTab.CallState = "--";
		}
		
		VoipShowTab.InterfaceState = GetInterfaceState();
				
		if ( AllLine[i].RegisterError == '-' )
		{
			VoipShowTab.RegisterError = "--";
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ONU_OFFLINE' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_onuoffine'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_NOT_CONFIGURED' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_wannotconfigured'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_IP_NOT_OBTAINED' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_wannotobtained'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_CORENET_ADDRESS_INCORRECT' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_mgcincorrect'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_VOICESERVICE_DISABLED' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_voicedisabled'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_CONFIGURED' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_usernotconfigured'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_BOUND_TO_POTS' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_usernotboundport'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_POTS_DISABLED_BY_OLT' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_portdisabledOLT'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_DISABLED' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_userdisable'];
		}
        else if ( AllLine[i].RegisterError == 'ERROR_USER_CONFLICT' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_userconflict'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_AUTH_FAIL' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_regauthfails'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_TIME_OUT' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_regtimesout'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ERROR_RESPONSE_RETURNED_BY_CORENET' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_mgcerrorresponse'];
		}
		else if ( AllLine[i].RegisterError == 'ERROR_UNKNOWN' )
		{
			VoipShowTab.RegisterError = h248status['vspa_errorstate_unknownerror'];
		}
		else
		{
			VoipShowTab.RegisterError = "--";
		}   
			
	VoipArray.push(VoipShowTab);	
	
	}
}
VoipArray.push(null);

HWShowTableListByType(ShowableFlag, "tdVoipInfo", ShowButtonFlag, ColumnNum, VoipArray, ConfiglistInfo, h248status, null);

</script>

<br></br>
</body>
</html>

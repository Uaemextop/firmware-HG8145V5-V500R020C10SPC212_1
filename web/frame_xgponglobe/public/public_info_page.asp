<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7">
<style type="text/CSS">
#dsltd_19, #dsltd_20{
  word-wrap: break-word;
  width: 658px;
  display: block;
  padding-right: 2px;
  line-height: 40px;
}
.uriclass
{ 
	word-break:break-all;
	min-width:30px;
}
.regnameclass
{ 
	word-break:break-all;
	width:110px;
}
</style>
<link rel="stylesheet"  href='../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link href="../Cuscss/<%HW_WEB_GetCusSource(infopage.css);%>" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../resource/<%HW_WEB_Resource(jsdiff.js);%>"></script>
<script language="JavaScript" src="../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" src='../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="/html/bbsp/common/managemode.asp"></script>
<script language="JavaScript" src="/html/ssmp/deviceinfo/deviceinfo.cus"></script>
<script language="javascript" src="/html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list.asp"></script>
<script language="javascript" src="/html/amp/common/wlan_list.asp"></script>
<script language="javascript" src="/html/bbsp/common/ontstate.asp"></script> 
<script language="javascript" src="/html/bbsp/common/wanaddressacquire.asp"></script> 
<script language="javascript" src="/html/bbsp/common/lanuserinfo.asp"></script>

<script language="javascript" src="/html/bbsp/common/ontstate.asp"></script>
<script language="javascript" src="/html/bbsp/common/wanipv6state.asp"></script>
<script language="javascript" src="/html/bbsp/common/wanaddressacquire.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_control.asp"></script>

<script>

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var TELMEX = false;
var IPv4VendorId="--"
var PackageList =  "";
var ponPackage = "";
document.title = ProductName;
if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

function PONPackageInfo(domain,PacketsSent,PacketsReceived)
{
	this.PacketsSent=PacketsSent;
	this.PacketsReceived=PacketsReceived;
}

function dhcpmainst(domain,enable,MainDNS)
{
	this.domain     = domain;
	this.enable     = enable;
	if(MainDNS == "")
	{
		this.MainPriDNS = "";
		this.MainSecDNS = "";
	}
	else
	{
		var MainDnss    = MainDNS.split(',');
		this.MainPriDNS = MainDnss[0];
		this.MainSecDNS  = MainDnss[1];
		if (MainDnss.length <=1)
		{
			this.MainSecDNS = "";
		}
	}
}

function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

var MainDhcpRange = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaMainDhcpPool,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|X_HW_DNSList,dhcpmainst);%>;
var dhcpmain = MainDhcpRange[0];
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var LanHostInfo = LanHostInfos[0];
var curUserType = '<%HW_WEB_GetUserType();%>';
var curCfgMode ='<%HW_WEB_GetCfgMode();%>';

function GetIPv4PPPoeError(CurrentWan)
{
	var errStr = "";
	if (GetOntState()!= "ONLINE")
	{
		errStr = waninfo_language['bbsp_wanerror_offline'];
		return errStr;
	}

	if (CurrentWan.Enable == "0")
	{
		errStr = waninfo_language['bbsp_wanerror_disable'];
		return errStr;
	}

	if((CurrentWan.ConnectionTrigger == "Manual") && (CurrentWan.ConnectionControl == "0"))
	{
	   errStr = waninfo_language['bbsp_wanerror_nodial'];
	   return errStr;
	}

	if (CurrentWan.Status.toUpperCase() == "UNCONFIGURED")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	if (CurrentWan.IPv4Enable == "1" && CurrentWan.IPv6Enable == "1")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	switch(CurrentWan.LastConnErr)
	{
		case "ERROR_NOT_ENABLED_FOR_INTERNET":
			errStr = waninfo_language['bbsp_wanerror_neg'];
			break;

		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass'];
			break;

		case "ERROR_ISP_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_srvdown'];
			break;

		case "ERROR_ISP_TIME_OUT":
			errStr = waninfo_language['bbsp_wanerror_timeout'];
			break;

		case "ERROR_IDLE_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_notraffic'];
			break;

		default:
			errStr = waninfo_language['bbsp_wanerror_noaddress'];
			break;
	}

	return errStr;

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
		else if ("CONNECTING" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_connecting'];
	}
	else
	{
		return WanStatus;
	}
}

function ChangeLanguageWanIPv4AddressMode(IPv4AddressMode)
{
	if( 'PPPOE' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['PPPoE'];
	}
	else if( 'DHCP' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['DHCP'];
	}
	else if( 'STATIC' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['Static'];
	}
	else if( 'AUTO' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['Auto'];
	}
	else
	{
		return IPv4AddressMode;
	}
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
</script>
<script language="JavaScript" type="text/javascript">
var curLoginUserType = "<%HW_WEB_GetUserType();%>";
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var PageInfo = '<%HW_WEB_GetCurUserName();%>';

function GetRandCnt() { return '<%HW_WEB_GetRandCnt();%>'; }

function MD5(str) { return hex_md5(str); }

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

var AllLineURI = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,URI,stLineURI);USER=3%>';
var AllLine = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i},DirectoryNumber|PhyReferenceList|Status|CallState|X_HW_LastRegisterError,stLine);USER=3%>';
var AllCodeAndReason = '<%HW_WEB_GetVspRegReason();%>';
var SplitCodeReason = AllCodeAndReason.split("|");

var OutputCodeReason = new Array();

if("null" == PageInfo && (0 == AllLine.length || 0 == AllLineH248.length))
{
	var IsHideVoip = true;
}

else
{
	var IsHideVoip = false;
}

if(IsHideVoip == false)
{
	var AllLineURI = eval(AllLineURI);
	var AllLine = eval(AllLine);

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

var AllAuth = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,AuthUserName,stAuth);USER=3%>';
var Auth = new Array();

if(IsHideVoip == false)
{
	var AllAuth = eval(AllAuth);
	for (var i = 0; i < AllAuth.length-1; i++) 
		Auth[i] = AllAuth[i];
}

var User = new Array();

function stUser(Domain, UserId)
{
    this.Domain = Domain;
    this.UserId = UserId;
}

if(IsHideVoip == false)
{
	for (var i = 0; i < AllLine.length - 1; i++)
	{
		User[i] = new stUser();
		User[i].UserId = AllLine[i].DirectoryNumber;
	}
}

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';

function stInterfaceState(Domain, X_HW_InterfaceState)
{
    this.Domain = Domain;
    this.X_HW_InterfaceState = X_HW_InterfaceState;
}

var InterfaceState = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1,X_HW_InterfaceState,stInterfaceState);USER=3%>';

function stLineH248(Domain, DirectoryNumber, PhyReferenceList,Status, CallState,RegisterError)
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

var AllLineH248 = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i},DirectoryNumber|PhyReferenceList|Status|CallState|X_HW_LastRegisterError,stLineH248);USER=3%>';

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

var AllH248LineName = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.X_HW_H248,LineName,stH248LineName);USER=3%>';

var UserH248 = new Array();

function stUserH248(Domain, UserId)
{
    this.Domain = Domain;
    this.UserId = UserId;
}

if("null" == PageInfo && (0 == AllLine.length || 0 == AllLineH248.length))
{
	var IsHideVoip = true;
}
else
{
	var IsHideVoip = false;
	var InterfaceState = eval(InterfaceState);   	
}

if(IsHideVoip == false)
{
	var AllLineH248 = eval(AllLineH248);      
	var AllH248LineName = eval(AllH248LineName);   
	for (var i = 0; i < AllLineH248.length - 1; i++)
	{
		UserH248[i] = new stUserH248();
		UserH248[i].UserId = AllH248LineName[i].LineName;
	}
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

function stDeviceInfo(domain,SerialNumber,HardwareVersion,SoftwareVersion,ModelName,VendorID,ReleaseTime,Mac,Description,ManufactureInfo)
{
	this.domain 			= domain;
	this.SerialNumber 		= SerialNumber;
	this.HardwareVersion 	= HardwareVersion;		
	this.SoftwareVersion 	= SoftwareVersion;
	this.ModelName 		    = ModelName;
	this.VendorID			= VendorID;
	this.ReleaseTime 		= ReleaseTime;
	this.Mac				= Mac;
    this.Description        = Description;
	this.ManufactureInfo	= ManufactureInfo;
}	

function ONTInfo(domain,ONTID,Status)
{
	this.domain 		= domain;
	this.ONTID			= ONTID;
	this.Status			= Status;
}

function isFirst8VisibleChar(sn)
{    
    if (
         ((sn.charAt(0) >= '2')&&(sn.charAt(0) <= '7'))
         &&((sn.charAt(2) >= '2')&&(sn.charAt(2) <= '7'))
         &&((sn.charAt(4) >= '2')&&(sn.charAt(4) <= '7'))
         &&((sn.charAt(6) >= '2')&&(sn.charAt(6) <= '7'))
       )
    {
        if ( 
             ((sn.charAt(0) == '7')&&(sn.charAt(1) == 'F'))
             ||((sn.charAt(2) == '7')&&(sn.charAt(3) == 'F'))
             ||((sn.charAt(4) == '7')&&(sn.charAt(5) == 'F'))
             ||((sn.charAt(6) == '7')&&(sn.charAt(7) == 'F'))
           )
        {            
            return false;
        }       
        return true;
    }
    return false;
}

function getMinus(a)
{
	if ( a > '9' )
	{
		if ( (a >= 'A') && (a <= 'F') )  
		{
			return 55;
		}
		else
		{
			return 87;  
		}		  
    }
    else
    {
        return 48;
    }
}

function ComBinVersionAndTime(Version, Time)
{
	return Version + "_" + Time.substr(2, 2) + Time.substr(5, 2);
}

function conv16to12Sn(SerialNum)
{
    var charVid = "";
	var hexVid = "";
	var vssd = "";
	var i;

    hexVid = SerialNum.substr(0,8);
	vssd = SerialNum.substr(8,8);
	
	for(i=0; i<8; i+=2)
	{
		charVid += String.fromCharCode("0x"+hexVid.substr(i, 2));
	}

	return charVid+vssd;
}

function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

function dhcpmainst0(domain,enable)
{
	this.domain 	= domain;
	this.enable		= enable;
}

function stOpticInfo(domain,transOpticPower,revOpticPower,voltage,temperature,bias)
{
    this.domain = domain;
	this.transOpticPower = transOpticPower;
	this.revOpticPower = revOpticPower;
	this.voltage = voltage;
	this.temperature = temperature;
	this.bias = bias;
}

var ShowType = '<%HW_WEB_GetCurAuthType();%>';
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var LockTime = '<%HW_WEB_GetLockTime();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var errVerificationCode = '<%HW_WEB_GetCheckCodeResult();%>';
var locklefttimerhandle;
var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;
var ontEPONInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT,Ontid|State,ONTInfo);%>;
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufactureInfo, stDeviceInfo);%>; 
var ontInfo = ontInfos[0];
var ontEPONInfo = ontEPONInfos[0];
var deviceInfo = deviceInfos[0];

var showCPUnMemUsed = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_SHOWCPUMEM);%>';
var cpuUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_CpuUsed);%>%';
var memUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_MemUsed);%>%';
var customizeDes = '<%HW_WEB_GetCustomizeDesc();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var LanHostInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var LanHostInfo = LanHostInfos[0];
var dev_uptime = '<%HW_WEB_GetOsUpTime();%>';
var SN = deviceInfo.SerialNumber;	
var sn = deviceInfo.SerialNumber; 
var minus = 0;			
var temp1 = 0;
var temp2 = 0;
var ParentalFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PARENTAL_CONTROL);%>'; 
var systemdsttime = '<%HW_WEB_GetSystemTime();%>'; 
function ParseSystemTime(SystemTime)
{
	if(SystemTime == "")
	{
	  SystemTime = "1970-01-01 01:01";
	}
	
	document.getElementById('td14_2').innerHTML = htmlencode(SystemTime);
}

var MainDhcpRange0 = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable,dhcpmainst0);%>';  
var status = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptTxMode.TxMode);%>';
var opticStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptStaus.status);%>';
var opticPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.SMP.APM.ChipStatus.Optical);%>';
var ontPonRFNum = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.RF.RfPortNum);%>';
var ontPonCATVRXPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.WANDevice.X_GponInterafceConfig.CATVRXPower);%>';
var ontPonRFOutputPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.WANDevice.X_GponInterafceConfig.RFOutputPower);%>';
var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower|Voltage|Temperature|Bias, stOpticInfo);%>; 
var opticInfo = opticInfos[0];
var opticType = '<%HW_WEB_GetOpticType();%>';

var IPv4VendorId="--"
var ClickWanType = "";

if (isFirst8VisibleChar(sn) == true)  
{
    SN = deviceInfo.SerialNumber + ' ' + '(' + conv16to12Sn(deviceInfo.SerialNumber) + ')';          
}


function selectLineipv4(id)
{	
	ClickWanType = "IPV4";
	selectLine(id);
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

function stSignalingProtocol(Domain, SignalingProtocol)
{
    this.Domain = Domain;
    this.SignalingProtocol = SignalingProtocol;
}

var AllSignal = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}, SignalingProtocol, stSignalingProtocol);%>;

function SetUptime()
{
	dev_uptime++;
	var second = parseInt(dev_uptime);
	var dd = parseInt(second/(3600*24));
	var hh = parseInt((second%(3600*24))/3600);
	var mm = parseInt((second%3600)/60);
	var ss = parseInt(second%60);
	var strtime = "";

	if (dd <= 1)
	{
		strtime += dd + GetLanguageDesc("s020f");
	}
	else
	{
		strtime += dd + GetLanguageDesc("s0213");
	}

	if (hh <= 1)
	{
		strtime += hh + GetLanguageDesc("s0210");
	}
	else
	{
		strtime += hh + GetLanguageDesc("s0214");
	}

	if (mm <= 1)
	{
		strtime += mm + GetLanguageDesc("s0211");
	}
	else
	{
		strtime += mm + GetLanguageDesc("s0215");
	}

	if (ss <= 1)
	{
		strtime += ss + GetLanguageDesc("s0212");
	}
	else
	{
		strtime += ss + GetLanguageDesc("s0216");
	}
	getElById("ShowTime").innerHTML = strtime;
}

function LoadFrame()
{  
	SetUptime();
	setInterval("SetUptime();", 1000);
	
	if ( showCPUnMemUsed != 1 )
	{
		document.getElementById('ShowCpuInfo').style.display="none";
		document.getElementById('ShowMemInfo').style.display="none";
	}
	
	if(ontPonMode.toUpperCase() == 'EPON')
	{
		document.getElementById('OntId').style.display="none";
	}
	
	var opticTable = document.getElementById("optic_status_table");	
	if (opticTable != null)
	{  	
		var opticAllTds = opticTable.getElementsByTagName("td");
		for (var i = 0; i <opticAllTds.length ; i++) 
		{
			var b = opticAllTds[i];
			if(b.getAttribute("BindText") == null)
			{
				continue;
			}
			b.innerHTML = status_optinfo_language[b.getAttribute("BindText")];
		}	
	}
	
    var wanTable = document.getElementById("IPv4Panel");
    if (wanTable != null)
	{  		
		var wanAllTds = wanTable.getElementsByTagName("td");
		for (var i = 0; i <wanAllTds.length ; i++) 
		{
			var b = wanAllTds[i];
			if(b.getAttribute("BindText") == null)
			{
				continue;
			}
			b.innerHTML = waninfo_language[b.getAttribute("BindText")];
		}
	}
	
    var wanTable = document.getElementById("WanDetail");
    if (wanTable != null)
	{  		
		var wanAllTds = wanTable.getElementsByTagName("td");
		for (var i = 0; i <wanAllTds.length ; i++) 
		{
			var b = wanAllTds[i];
			if(b.getAttribute("BindText") == null)
			{
				continue;
			}
			b.innerHTML = waninfo_language[b.getAttribute("BindText")];
		}
	}
	
	if(false == IsHideVoip)
	{
		var voipTable = document.getElementById("voip_info_table");	
		if (voipTable != null)
		{
			var voipAllTds = voipTable.getElementsByTagName("td");
			for (var i = 0; i <voipAllTds.length ; i++) 
			{
				var b = voipAllTds[i];
				if(b.getAttribute("BindText") == null)
				{
					continue;
				}
				b.innerHTML = sipstatus[b.getAttribute("BindText")];
			}
		}	
		var voip248Table = document.getElementById("voip_info_table_h248");	
		if (voip248Table != null)
		{
			var voipAllTds = voip248Table.getElementsByTagName("td");
			for (var i = 0; i <voipAllTds.length ; i++) 
			{
				var b = voipAllTds[i];
				if(b.getAttribute("BindText") == null)
				{
					continue;
				}
				b.innerHTML = h248status[b.getAttribute("BindText")];
			}
		}	
		
		setDisplay('ont_voip_info', 1);  
		setDisplay('ont_voip_info_tail', 1);  
		
		
		if("H248" == AllSignal[0].SignalingProtocol || "H.248" == AllSignal[0].SignalingProtocol)
		{   

			setDisplay('ConfigFormSIP', 0);
			setDisplay('ConfigFormH248', 1);   
		}
		else
		{

			setDisplay('ConfigFormSIP', 1);
			setDisplay('ConfigFormH248', 0);  
		}
	}	
    if (curLoginUserType == "0")
    {
        setDisplay('resetButton',1);
    }
    else
    {
        setDisplay('resetButton',1);
    }	
}
function GetLanguageDesc(Name)
{
    return DevInfoDes[Name];
}

function refreshpage()
{
	window.location.replace("/");
}

/* 设置div显示和影藏 */
function setDivShowHide(OptType,DivId) 
{
	var Type = OptType == "hide" ? "none" : "block";
	document.getElementById(DivId).style.display=Type; 
}

/* 设置底层遮罩显示和影藏 */
function setBaseMaskShowHide(OptType) 
{
	var Type = OptType == "hide" ? "none" : "block";
	var  e = document.getElementById('BaseMask');
	e.style.display = Type; 
}

function setTextValue (sId, sValue)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return false;
	}
  if(null != sValue)
	{
		sValue = sValue.toString().replace(/&nbsp;/g," ");
		sValue = sValue.toString().replace(/&quot;/g,"\"");
		sValue = sValue.toString().replace(/&gt;/g,">");
		sValue = sValue.toString().replace(/&lt;/g,"<");
		sValue = sValue.toString().replace(/&#39;/g, "\'");
		sValue = sValue.toString().replace(/&#40;/g, "\(");
		sValue = sValue.toString().replace(/&#41;/g, "\)");
		sValue = sValue.toString().replace(/&amp;/g,"&");
	}

	item.value = sValue;
	return true;
}


function showlogininfo()
{
	setBaseMaskShowHide(null);
	setDivShowHide(null, "LoginInfoUi");
	document.getElementById('txt_Username').focus();
	init();
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum) || parseInt(LoginTimes, 10) > 0)
	{
		setDivShowHide(null, "LoginInfoUiErr");
		setErrorStatus();
	}
}

function SubmitLogin() {
	var Username = document.getElementById('txt_Username');
	var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;

	if (appName == "Microsoft Internet Explorer")
	{
		var versionNumber = version.split(" ")[3];
		if (parseInt(versionNumber.split(";")[0]) < 6)
		{
			alert("We cannot support the IE version which is lower than 6.0.");
			return false;
		}
	}

	if (Username.value == "") {
		alert("User Name is a required field.");
		Username.focus();
		return false;
	}

	if (Password.value == "") {
		alert("Password is a required field.");
		Password.focus();
		return false;
	}

	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date = new Date();
		date.setTime(date.getTime() - 10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
	}
	var cnt;
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/asp/GetRandCount.asp',
		success : function(data) {
			cnt = data;
		}
	});
	var Form = new webSubmitForm();
	var cookie2 = "Cookie=body:" + "Language:english" + ":" + "id=-1;path=/";
	Form.addParameter('UserName', Username.value);
	Form.addParameter('PassWord', base64encode(Password.value));
	document.cookie = cookie2;
	Username.disabled = true;
	Password.disabled = true;
	
	Form.addParameter('x.X_HW_Token', cnt);
	Form.setAction('/login.cgi');
	Form.submit();
	
	return true;
}

function init() {
	if (document.addEventListener) {
		document.addEventListener("keypress", onHandleKeyDown, false);
	} else {
		document.onkeypress = onHandleKeyDown;
	}
}

function onHandleKeyDown(event) {
	var e = event || window.event;
	var code = e.charCode || e.keyCode;

	if (code == 13) {
		SubmitLogin();
		if (window.event)
		{
		    window.event.keyCode = 0;
		    window.event.returnValue = false;    
		}
		else
		{
		    return false;   
		}
	}
}

function CancleLogin()
{
	setBaseMaskShowHide("hide");
	setDivShowHide("hide", 'LoginInfoUi');
	setTextValue("txt_Username", "");
	setTextValue("txt_Password", "");
}

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}

	if(LockLeftTime == 1)
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
	}
	else
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
	}

	SetDivValue("LoginInfoUiErr", errhtml);
	LockLeftTime = LockLeftTime - 1;
}
function FormatDigit(Number)
{
	if (Number < 10)
	{
		return ('0' + Number);
	}
	else
	{
		return Number;
	}
}
function PPPOnlineTimeShow()
{
	var PPPOnlineTimeShowFlag = 0;
	for (var i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		
		if(('PPPoE' != CurrentWan.EncapMode)
		 || (CurrentWan.IPv4Enable != "1")
		 || !(CurrentWan.ServiceList.indexOf("INTERNET") >= 0))
		{ 
			continue;
		}

		PPPOnlineTimeShowFlag = 1;	
		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = CurrentWan.Uptime%60;
		minutes = Math.floor( CurrentWan.Uptime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;
		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			document.getElementById("td15_2").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("td15_2").innerHTML = "--";
		}	
		break;			
	}
	
	if ( 1 != PPPOnlineTimeShowFlag)
	{
		document.getElementById("td15_2").innerHTML = "--";
	}
}

function OntOnlineTimeShow()
{
	var OntOnlineTimeShowFlag = 0;
	for (var i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		if((CurrentWan.IPv4Enable != "1")|| !(CurrentWan.ServiceList.indexOf("INTERNET") >= 0))
		{ 
			continue;
		}
		OntOnlineTimeShowFlag = 1;	
		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = CurrentWan.Uptime%60;
		minutes = Math.floor( CurrentWan.Uptime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;
		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			document.getElementById("td16_2").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("td16_2").innerHTML = "--";
		}	
		break;			
	}
	if ( 1 != OntOnlineTimeShowFlag)
	{
		document.getElementById("td16_2").innerHTML = "--";
	}
}
function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		var errhtml = 'Too many retrials.';
		SetDivValue("LoginInfoUiErr", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('loginbutton',1);
		setDisable('canclebutton',1);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
		SetDivValue("LoginInfoUiErr", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('loginbutton',1);
		setDisable('canclebutton',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
		var errhtml = 'Incorrect User Name/Password combination. Please try again.';
		SetDivValue("LoginInfoUiErr", errhtml);
	}
	else
	{
		setDivShowHide("hide", "LoginInfoUiErr");
	}
}
</script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var curLoginUserType = "<%HW_WEB_GetUserType();%>";
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var var_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
function stLine(Domain, DirectoryNumber, PhyReferenceList, Status, CallState,RegisterError)
{
    this.Domain = Domain;
    this.DirectoryNumber = DirectoryNumber;
	this.PhyReferenceList = PhyReferenceList;
    this.Status = Status;
    this.CallState = CallState;
    this.RegisterError = RegisterError;
}
function stLineURI(Domain, URI)
{
	this.Domain = Domain;
    this.URI = URI;
}
function setControl()
{
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
    this.AuthUserName = AuthUserName;
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
function Reboot()
{
    if(ConfirmEx(sipstatus['vspa_restartalert'])) 
    {               
        var Form = new webSubmitForm();
        Form.addParameter('x.X_HW_Reset',1);   
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('set.cgi?x=' + 'InternetGatewayDevice.Services.VoiceService.1'
                        + '&RequestFile=html/voip/status/voipmaintain.asp');
        setDisable('btnReboot',1);
        Form.submit();        
    }
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
</script>
</head>
<script language="javascript">
if(ShowType == "null" || ShowType == "")
{
	infopagehead = '<body class="mainbodynoauth" onLoad="LoadFrame();" style="margin-top:0px;">'; 
}
else
{
	infopagehead = '<body class="mainbody" onLoad="LoadFrame();">'; 
}

document.write(infopagehead);
</script>
	<div id="BaseMask" style="position:fixed;"></div>
	<div class="globe_logo">
		<div class="log_img" style=" width: 241px;height: 96px; float: left;">
			<img style="width:241px; height:96px;" src="../../../images/globe_logo.jpg"/>
		</div>
		<div  id="onauthinfo" style="float:right; height:40px; margin-top: 30px;">
			<input type="button" id="refreshpage"  class="ApplyButtoncss buttonwidth_100px"  onClick="refreshpage();"   value="Refresh">
			<input type="button" id="showlogininfo" class="CancleButtonCss buttonwidth_100px" onClick="showlogininfo();" value="Setup">
		</div>
	</div>
	<div style="clear:both; clear: both; width: 100%; background-image:url(../images/head_bottom.jpg); margin-bottom: 20px; height: 20px; display: inline-block;"></div>

	<div id="LoginInfoUi">
		<div id="loginuser" class="contentItemlogin" style="padding-top:40px;">
			<div class="labelBoxlogin"><span id="account">User Name  :  </span></div>
			<div class="contenboxlogin"><input type="text" id="txt_Username" name="txt_Username" class="logininputcss" /></div>
		</div>
		<div id="loginpwd" class="contentItemlogin">
			<div class="labelBoxlogin"><span id="Password">Password  :  </span></div>
			<div class="contenboxlogin"><input type="password" autocomplete="off" id="txt_Password" name="txt_Password" class="logininputcss" /></div>
		</div>
		<div id="LoginInfoUiButton">
			<div class="labelBoxlogin"></div>
			<div class="contenboxlogin">
				<div style="float:left;"><button id="loginbutton" class="ApplyButtoncss info_100px" style="height:34px; margin-left: 4px;" onclick="SubmitLogin();" value="Login">Login</button></div>
				<div style="padding-left:20px; float:left;"><button id="canclebutton" class="CancleButtonCss info_100px" style="height:34px;" onclick="CancleLogin();" value="Cancle">Cancel</button></div>
			</div>
		</div>
		<div id="LoginInfoUiErr"></div>
	</div>
	<div class="container" style="height:auto; overflow: hidden;">
	<table id="ont_device_info">
		<tr> 
			<td class="tabal_head" colspan="11" style="font-size:16px;">Device Info</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="deviceinfo_table" name="deviceinfo_table">
		<tr> 
			<td class="table_title width_diff11" id="td1_1" style="width:30%">
			<script language="javascript">
				document.write(DevInfoDes['s0202']);
			</script> 
			</td> 
			<td class="table_right" id="td1_2">
			<script language="javascript">
				document.write(deviceInfo.ModelName);
			</script> 
		</td> 
	</tr>

	<tr id="tr2"> 
		<td  class="table_title" id="td2_1">
			<script language="javascript">
				document.write(DevInfoDes['s0203']);
			</script> 		
		</td> 
		<td class="table_right align_left" id="td2_2" dir="ltr">
			<script language="javascript">
				document.write(deviceInfo.Description);
			</script> 
		</td> 
	</tr> 

	<tr id="tr4"> 
		<td  class="table_title" id="td4_1">
			<script language="javascript">
				document.write(DevInfoDes['s0204']);
			</script> 		
		</td> 
		<td class="table_right" id="td4_2"> 
			<script language="javascript">
				document.write(deviceInfo.HardwareVersion);
			</script> 
		</td> 
	</tr> 

	<tr  id="tr5"> 
	<td class="table_title" id="td5_1">
			<script language="javascript">
				document.write(DevInfoDes['s0205']);
			</script> 	
	</td> 
	<td class="table_right" id="td5_2"> <script language="javascript">
	if ('GDCU' == CfgMode.toUpperCase())
	{
		var VersionAndTime = ComBinVersionAndTime(deviceInfo.SoftwareVersion, deviceInfo.ReleaseTime);
		document.write(VersionAndTime);
	}
	else
	{
		document.write(deviceInfo.SoftwareVersion);
	}
	</script> </td> 
	</tr> 

	<tr  id="tr6"> 
	<td class="table_title" id="td6_1">
		<script language="javascript">
			document.write(DevInfoDes['s0217']);
		</script> 
	</td> 
	<td class="table_right" id="td6_2"> <script language="javascript">
		document.write(deviceInfo.ManufactureInfo);
	</script> </td> 
	</tr> 

	<tr id="ShowCpuInfo">
	<td class="table_title" id="td9_1">
		<script language="javascript">
			document.write(DevInfoDes['s0208']);
		</script> 	
	</td>
	<td class="table_right" id="td9_2">
	<script type="text/javascript" language="javascript">
	if (cpuUsed != null)
	{
		document.write(cpuUsed);
	}
	else
	{
		document.write('');
	}
	</script>
	</td>
	</tr>

	<tr id="ShowMemInfo">
	<td class="table_title" id="td10_1">
		<script language="javascript">
			document.write(DevInfoDes['s0209']);
		</script> 	
	</td>
	<td class="table_right" id="td10_2">
	<script type="text/javascript" language="javascript">
	if (memUsed != null)
	{
		document.write(memUsed);
	}
	else
	{
		document.write('');
	}
	</script>
	</td>
	</tr>

	<tr id="ShowTimeInfo">
	<td class="table_title" id="td10_1">
		<script language="javascript">
			document.write(DevInfoDes['s020e']);
		</script> 	
	</td>
	<td class="table_right" id="ShowTime">
	</td>
	</tr>

	<tr id="ShowCustomizeDes">
	<td class="table_title" id="td13_1">
		<script language="javascript">
			document.write(DevInfoDes['s0225']);
		</script> 		
	</td>
	<td class="table_right" id="td13_2">
	<script type="text/javascript" language="javascript">
	if (customizeDes != null)
	{
		document.write(customizeDes);
	}
	else
	{
		document.write('');
	}
	</script>
	</td>
	</tr>
	<tr id="currenttime">
	<td class="table_title" id="td14_1">
		<script language="javascript">
			document.write(DevInfoDes['s0226']);
		</script> 		
	</td>
	<td class="table_right" id="td14_2"></td>
	</tr>
	<tr id="Ipv4PPPUpTime">
	<td class="table_title" id="td15_1">
		<script language="javascript">
			document.write(DevInfoDes['s0229']);
		</script> 		
	</td>
	<td class="table_right" id="td15_2">
	<script type="text/javascript" language="javascript">
	setDisplay('Ipv4PPPUpTime', 0);
	if('GLOBE2' == CfgMode.toUpperCase())
	{
		setDisplay('Ipv4PPPUpTime', 1);
		PPPOnlineTimeShow();
	}
	</script>
	</td>
	</tr>
	<tr id="ont_online_time">
	<td class="table_title" id="td16_1">
		<script language="javascript">
			document.write("Ont Online Duration (dd:hh:mm:ss):");
		</script> 		
	</td>
	<td class="table_right" id="td16_2">
	<script type="text/javascript" language="javascript">
	setDisplay('ont_online_time', 0);
	if('GLOBE2' == CfgMode.toUpperCase())
	{
		setDisplay('ont_online_time', 1);
		OntOnlineTimeShow();
	}
	</script>
	</td>
	</tr>
</table> 

<table width="100%" height="5"> 
<tr> 
<td></td> 
</tr> 
</table> 
<table id="ont_lan_info">
    <tr> 
        <td class="tabal_head" colspan="11" style="font-size:16px;">LAN Info</td>
    </tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="lanInfo">
<tr> 
<td class="table_title" style="width: 30%;">IP Address:</td> 
<td class="table_right" id="ethIpAddress">
<script language="javascript">
document.write(LanHostInfo.ipaddr);
</script>
</td> 
</tr>
<tr> 
<td class="table_title">Subnet Mask:</td> 
<td class="table_right" id="ethSubnetMask">
<script language="javascript">
document.write(LanHostInfo.subnetmask);
</script>
</td> 
</tr>
<tr> 
<td class="table_title">DHCP Server:</td> 
<td class="table_right" id="dhcpSrvState">
<script language="javascript">
MainDhcpRange0 = eval(MainDhcpRange0);
if ( 1 == MainDhcpRange0[0].enable )
{
	document.write("Enabled");
}
else
{
    document.write("Disabled");
}
</script>
</td> 
</tr>
</table> 

<script type="text/javascript">

	
if (ParentalFlag==1)
{
	document.getElementById('currenttime').style.display="";
}
else
{
	document.getElementById('currenttime').style.display="none";
}
ParseSystemTime(systemdsttime);

if(ShowType == "null" || ShowType == "")
{
    //显示刷新和登陆按钮
	setDivShowHide("null", 'onauthinfo');
	
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum) || parseInt(LoginTimes, 10) > 0)
	{
		showlogininfo();
	}
}
</script>

<script type="text/javascript">
var timer = [];

// 节点值是按0.1DB定义的，网页显示的时候要除以10
function convertDBData(value)
{
	var result = (value / 10);
	
	if (result!=0 && result.toString().indexOf(".")<0)
	{
		result = result + ".0";
	}

	return result;

}

function ONTInfo(domain,Status,TXPower,RXPower,TransceiverTemperature,SupplyVoltage,BiasCurrent)
{
	this.domain                     =   domain;
    this.Status						=	Status;
	this.TXPower	         		=	TXPower;
	this.RXPower					=	RXPower;
	this.TransceiverTemperature		=	TransceiverTemperature;
	this.SupplyVoltage				=	SupplyVoltage;
	this.BiasCurrent				=	BiasCurrent;

}

var ONTInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.X_GponInterafceConfig,Status|TXPower|RXPower|TransceiverTemperature|SupplyVoltage|BiasCurrent,ONTInfo);%>;

</script>

<table width="100%" height="5"> 
<tbody><tr> 
<td></td> 
</tr> 
</tbody></table>

<table id="ont_device_info">
    <tr> 
        <td class="tabal_head" colspan="11" style="font-size:16px;">ONT Information</td>
    </tr>
</table>
<form id="OntInfoForm" name="OntInfoForm">
<table id="OntFormPanel" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="deviceinfo_table" name="deviceinfo_table" style="padding:0;">
<li id="onttd_1" RealType="HtmlText" DescRef="sONT1000" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
<li id="onttd_2" RealType="HtmlText" DescRef="sONT1001" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
<li id="onttd_3" RealType="HtmlText" DescRef="sONT1002" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
<li id="onttd_4" RealType="HtmlText" DescRef="sONT1003" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
<li id="onttd_5" RealType="HtmlText" DescRef="sONT1004" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
<li id="onttd_6" RealType="HtmlText" DescRef="sONT1005" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="sONT1000" InitValue="Empty" />
</table>
<script>
var TableClass = new stTableClass("table_title width_per30", "table_right align_left","ltr");
HWParsePageControlByID("OntInfoForm",TableClass,DevInfoDes,null);
document.getElementById('onttd_1').innerHTML = htmlencode(ONTInfos[0].Status);
document.getElementById('onttd_2').innerHTML = htmlencode(ONTInfos[0].TXPower)+' '+status_optinfo_language['amp_optic_dBm'];
document.getElementById('onttd_3').innerHTML = htmlencode(ONTInfos[0].RXPower)+' '+status_optinfo_language['amp_optic_dBm'];
document.getElementById('onttd_4').innerHTML = htmlencode(ONTInfos[0].TransceiverTemperature)+' '+'℃';
document.getElementById('onttd_5').innerHTML = htmlencode(ONTInfos[0].SupplyVoltage)+' '+status_optinfo_language['amp_optic_mV'];
document.getElementById('onttd_6').innerHTML = htmlencode(ONTInfos[0].BiasCurrent)+' '+status_optinfo_language['amp_optic_mA'];

</script>
<script language="JavaScript" type="text/javascript">


function GetLanguageDesc(Name)
{
	return DevInfoDes[Name];
}
</script>
</form>





<script>
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
var IsTDE2Mode   = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var SingtelMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SINGTEL);%>';

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sys_com_eng_display = 0;
if (curLanguage.toUpperCase() == 'CHINESE')
{
		var CommonFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_COMMON);%>';
		if( (curUserType == sysUserType) || (1 == CommonFlag) )
		{
			sys_com_eng_display = 1;
		}
}
else
{
	sys_com_eng_display = 1;
}


if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

function PONPackageInfo(domain,PacketsSent,PacketsReceived)
{
	this.PacketsSent=PacketsSent;
	this.PacketsReceived=PacketsReceived;
}

function dhcpmainst(domain,enable,MainDNS)
{
	this.domain     = domain;
	this.enable     = enable;
	if(MainDNS == "")
	{
		this.MainPriDNS = "";
		this.MainSecDNS = "";
	}
	else
	{
		var MainDnss    = MainDNS.split(',');
		this.MainPriDNS = MainDnss[0];
		this.MainSecDNS  = MainDnss[1];
		if (MainDnss.length <=1)
		{
			this.MainSecDNS = "";
		}
	}
}

function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

var TELMEX = false;
var IPv4VendorId="--"
var PackageList =  "";
var ponPackage = "";

var MainDhcpRange = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaMainDhcpPool,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|X_HW_DNSList,dhcpmainst);%>;
var dhcpmain = MainDhcpRange[0];
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var LanHostInfo = LanHostInfos[0];
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curCfgMode ='<%HW_WEB_GetCfgMode();%>';
function IsRDSGatewayUser()
{
		return false;
}
function IsSonetUser()
{
	if((SonetFlag == '1')
	   && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsSingtelUser()
{
	if (SingtelMode == '1' && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsPtvdfUser()
{
	if(('PTVDF' == curCfgMode.toUpperCase() || 'PTVDF2' == curCfgMode.toUpperCase())&& curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

var ClickWanType = "";
function selectLineipv4(id)
{
	ClickWanType = "IPV4";
	selectLine(id);
}

function selectLineipv6(id)
{
	ClickWanType = "IPV6";
	selectLine(id);
}

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++)
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = waninfo_language[b.getAttribute("BindText")];
	}
}
function PPPLastErrTrans(ErrCode)
{
	var errStr = "";
	switch(ErrCode)
	{
		case 'ERROR_USER_DISCONNECT':
		  errStr = waninfo_language['Telmex_UserDisconn_err'];
		  break;
		case 'ERROR_ISP_DISCONNECT':
		  errStr = waninfo_language['Telmex_ISPDisconn_err'];
		  break;
	  case 'ERROR_IDLE_DISCONNECT':
		errStr = waninfo_language['Telmex_IdleDisconn_err'];
		  break;
		case 'ERROR_AUTHENTICATION_FAILURE':
		  errStr = waninfo_language['Telmex_AuthFailuer_err'];
		  break;
		default:
		  errStr = waninfo_language['Telmex_ConnTimeout_err'];
		  break;
	}
	return errStr;
}

function GetIPv4PPPoeError(CurrentWan)
{
	var errStr = "";
	if (GetOntState()!= "ONLINE")
	{
		errStr = waninfo_language['bbsp_wanerror_offline'];
		return errStr;
	}

	if (CurrentWan.Enable == "0")
	{
		errStr = waninfo_language['bbsp_wanerror_disable'];
		return errStr;
	}

	if((CurrentWan.ConnectionTrigger == "Manual") && (CurrentWan.ConnectionControl == "0"))
	{
	   errStr = waninfo_language['bbsp_wanerror_nodial'];
	   return errStr;
	}

	if (CurrentWan.Status.toUpperCase() == "UNCONFIGURED")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	if (CurrentWan.IPv4Enable == "1" && CurrentWan.IPv6Enable == "1")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	switch(CurrentWan.LastConnErr)
	{
		case "ERROR_NOT_ENABLED_FOR_INTERNET":
			errStr = waninfo_language['bbsp_wanerror_neg'];
			break;

		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass'];
			break;

		case "ERROR_ISP_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_srvdown'];
			break;

		case "ERROR_ISP_TIME_OUT":
			errStr = waninfo_language['bbsp_wanerror_timeout'];
			break;

		case "ERROR_IDLE_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_notraffic'];
			break;

		default:
			errStr = waninfo_language['bbsp_wanerror_noaddress'];
			break;
	}

	return errStr;

}


function IsDisplayIPv6DialCode(Origin, lla, gua)
{

	if (lla != "")
	{
		return false;
	}

	return true;
}

function GetIPv6PPPoeError(CurrentWan, lla, gua)
{
	var errStr = "";

	if (GetOntState()!= "ONLINE")
	{
		errStr = waninfo_language['bbsp_wanerror_offline'];
		return errStr;
	}

	if (CurrentWan.Enable == "0")
	{
		errStr = waninfo_language['bbsp_wanerror_disable'];
		return errStr;
	}

	if (CurrentWan.IPv4Enable == "1" && CurrentWan.IPv6Enable == "1")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	switch(CurrentWan.LastConnErr)
	{
		case "ERROR_NOT_ENABLED_FOR_INTERNET":
			errStr = waninfo_language['bbsp_wanerror_neg'];
			break;

		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass'];
			break;

		case "ERROR_ISP_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_srvdown'];
			break;

		case "ERROR_ISP_TIME_OUT":
			errStr = waninfo_language['bbsp_wanerror_timeout'];
			break;

		case "ERROR_IDLE_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_notraffic'];
			break;

		default:
			errStr = waninfo_language['bbsp_wanerror_noaddress'];
			break;
	}

	return errStr;

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
		else if ("CONNECTING" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_connecting'];
	}
	else
	{
		return WanStatus;
	}
}

function ChangeLanguageWanIPv4AddressMode(IPv4AddressMode)
{
	if( 'PPPOE' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['PPPoE'];
	}
	else if( 'DHCP' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['DHCP'];
	}
	else if( 'STATIC' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['Static'];
	}
	else if( 'AUTO' == IPv4AddressMode.toUpperCase() )
	{
		return Languages['Auto'];
	}
	else
	{
		return IPv4AddressMode;
	}
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

function IsExistIPv6WAN()
{
	var IPv6WanCount = 0;
	for (var i = 0; i < GetWanList().length; i++)
	{
		if (GetWanList()[i].IPv6Enable != "1")
		{
			continue;
		}
		IPv6WanCount++;
	}
	
	return (IPv6WanCount > 0) ? true : false; 	

}

function IsSupportIPv6WANInfo()
{
	if(IsPtvdfUser())
	{
		var IPProtoVersion = GetIPProtVerMode();
		if(1 == IPProtoVersion)
		{
			return false;
		}
		else
		{
			return IsExistIPv6WAN();
		}
	}
	else
	{
		return IsExistIPv6WAN();
	}
}

</script>

<table width="100%" height="5"> 
<tr> 
<td></td> 
</tr> 
</table> 
<div id="IPTable" class="ie7-padding" style="overflow-x:auto;overflow-y:hidden;width:100%;">
<table width="100%" border="0" cellpadding="0" cellspacing="0"> 
<tr><td class="func_title" BindText="bbsp_ipv4info" style="padding: 0px 0px 2px 0px;"></td></tr></table>  

<table class="tabal_bg width_per100"  cellspacing="1" id="IPv4Panel">
  <tr class="head_title">
   <script type="text/javascript" language="javascript">
			document.write('<td>'+waninfo_language['bbsp_wanname']+'</td>');
	</script>
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_ip'></td>
		<script type="text/javascript" language="javascript">
		if(false == IsSonetUser() && false == IsRDSGatewayUser() && false == IsPtvdfUser() && false == IsSingtelUser())
		{
			document.write('<td>'+waninfo_language['bbsp_vlanpri']+'</td>');
		}
	  </script>
	<script type="text/javascript" language="javascript">
		if (false == IsRDSGatewayUser() && false == IsSingtelUser())
		{
			document.write('<td>'+waninfo_language['bbsp_con']+'</td>');
		}
		</script>
	<script type="text/javascript" language="javascript">
		if('GLOBE2' == curCfgMode.toUpperCase())
		{
			document.write('<td>'+waninfo_language['bbsp_wandialcode']+'</td>');
		}
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


	function FormatDigit(Number)
	{
		if (Number < 10)
		{
			return ('0' + Number);
		}
		else
		{
			return Number;
		}
	}

	function DisplayIPv6WanDetail(WanIndex)
	{
		var CurrentWan = GetWanList()[WanIndex];
		var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
		var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
		var AddressList = GetIPv6AddressList(CurrentWan.MacId);
		var AcquireHtml = "";
		var AddressHtml = "";
		var AddressStatusHtml = "";
		var AddressPreferredTimeHtml = "";
		var AddressValidTimeHtml = "";
		var AddressValidTimeRemainingHtml="";

		for (var m = 0; m < AddressList.length; m++)
		{
			if (AddressList[m].Origin.toUpperCase() != "LINKLOCAL")
			{
				if (CurrentWan.Enable == "1")
				{
					if(AddressHtml == '')
						AddressHtml += AddressList[m].IPAddress;
					else
						AddressHtml += "<br>" + AddressList[m].IPAddress;

					if(AddressStatusHtml == '')
						AddressStatusHtml += AddressList[m].IPAddressStatus;
					else
						AddressStatusHtml += "<br>" +  AddressList[m].IPAddressStatus;

					if(AddressPreferredTimeHtml == '')
						AddressPreferredTimeHtml += AddressList[m].PreferredTime;
					else
						AddressPreferredTimeHtml += "<br>" +  AddressList[m].PreferredTime;

					if(AddressValidTimeHtml == '')
						AddressValidTimeHtml += AddressList[m].ValidTime;
					else
						AddressValidTimeHtml += "<br>" +  AddressList[m].ValidTime;

					if(AddressValidTimeRemainingHtml == '')
					{
						AddressValidTimeRemainingHtml += convertDHCPLeaseTimeRemaining(AddressList[m].ValidTimeRemaining);
					}
					else
					{
						AddressValidTimeRemainingHtml += "<br>" +  convertDHCPLeaseTimeRemaining(AddressList[m].ValidTimeRemaining);
					}
				}
			}
		}

		setDisplay("IPv6WanDetail",1);
		setDisplay("ipv6InformationForm",1);
		setDisplay("V6PPPUsernameRow",0);
		setDisplay("V6PPPPasswordRow",0);
				
		document.getElementById("IPv6MacAddress").innerHTML = CurrentWan.MACAddress;		
		document.getElementById("IPv6PriorityPolicy").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? waninfo_language['bbsp_wanpriority'] : waninfo_language['bbsp_wandefaultpri'];

		if ( 0 == parseInt(CurrentWan.VlanId,10) )
		{
			if((ipv6Wan.ConnectionStatus.toUpperCase()=="CONNECTED") && (CurrentWan.Mode == 'IP_Routed') )
			{
				document.getElementById("IPv6Vlan").innerHTML = "";
				document.getElementById("IPv6Priority").innerHTML = "";
				document.getElementById("IPv6PriorityPolicy").innerHTML = "";
			}
			else
			{
				document.getElementById("IPv6Vlan").innerHTML = "--";
				document.getElementById("IPv6Priority").innerHTML = "--";
				document.getElementById("IPv6PriorityPolicy").innerHTML = "--";
			}
		}
		else
		{
			document.getElementById("IPv6Vlan").innerHTML = CurrentWan.VlanId;
			document.getElementById("IPv6Priority").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? CurrentWan.Priority : CurrentWan.DefaultPriority;
			document.getElementById("IPv6PriorityPolicy").innerHTML = waninfo_language[CurrentWan.PriorityPolicy];
		}

		if(true == IsSonetUser())
		{
			setDisplay("IPv6VlanRow",0);
			setDisplay("IPv6PriorityPolicyRow",0);
			setDisplay("IPv6PriorityRow",0);
		}
		
		if('IP_Routed' == CurrentWan.Mode)
		{
			setDisplay("IPv6GateWayRow",1);
			setDisplay("IPv6DnsServerRow",1);
			setDisplay("IPv6PrefixRow",1);
			setDisplay("IPv6PrefixModeRow",1);
			setDisplay("IPv6PrefixPreferredTimeRow",1);
			setDisplay("IPv6PrefixVaildTimeRow",1);
			setDisplay("IPv6PrefixVaildTimeRemainingRow",1);
			setDisplay("IPv6IpAddressRow",1);
			setDisplay("IPv6IpAccessModeRow",1);
			setDisplay("Ipv6IpStateRow",1);
			setDisplay("IPv6PreferredTimeRow",1);
			setDisplay("IPv6VaildTimeRow",1);
			setDisplay("IPv6VaildTimeRemainingRow",1);
			setDisplay("IPv6DsliteAftrnameRow",1);
			setDisplay("IPv6DslitePeerAddressRow",1);
			

			if(true == IsSonetUser())
			{
			    setDisplay("IPv6IpAddressRow",0);
				setDisplay("IPv6IpAccessModeRow",0);
				setDisplay("Ipv6IpStateRow",0);
				setDisplay("IPv6PreferredTimeRow",0);
				setDisplay("IPv6VaildTimeRow",0);
				setDisplay("IPv6GateWayRow",0);
				setDisplay("IPv6DsliteAftrnameRow",0);
				setDisplay("IPv6VaildTimeRemainingRow",0);
				setDisplay("IPv6DslitePeerAddressRow",0);
			}

			var PrefixList = GetIPv6PrefixList(CurrentWan.MacId);
			var Prefix = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].Prefix:'') :(PrefixList[0].Prefix));
			Prefix = (CurrentWan.Enable == "1") ? Prefix : "";

			var PrefixAcquire = GetIPv6PrefixAcquireInfo(CurrentWan.domain);
			PrefixAcquire = ((PrefixAcquire==null) ? '' : PrefixAcquire.Origin);
			document.getElementById("IPv6PrefixMode").innerHTML = PrefixAcquire;

            if (1 == IsTDE2Mode)
            {
                switch (AddressAcquire.Origin)
                {
                    case "AutoConfigured":
                        AcquireHtml = "SLAAC";
                        break;
                    case "DHCPv6":
                        AcquireHtml = "DHCPv6";
                        break;
                    case "Static":
                        AcquireHtml = "Static";
                        break;
                    case "None":
                        AcquireHtml = "Unnumbered";
                        break;
                    default:
                        AcquireHtml = "SLAAC";
                        break;
                }
            }
            else
            {
			    AcquireHtml = AddressAcquire.Origin;
            }



			document.getElementById("IPv6IpAccessMode").innerHTML = AcquireHtml;

			var PrefixPreferredTime = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].PreferredTime:'') :(PrefixList[0].PreferredTime));
			PrefixPreferredTime = ((CurrentWan.Enable == "1") && (Prefix.length != 0))? PrefixPreferredTime : "";

			var PrefixValidTime = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].ValidTime:'') :(PrefixList[0].ValidTime));
			PrefixValidTime = ((CurrentWan.Enable == "1") && (Prefix.length != 0)) ? PrefixValidTime : "";

			var PrefixValidTimeRemaining = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].ValidTimeRemaining:'') :(PrefixList[0].ValidTimeRemaining));
			PrefixValidTimeRemaining = ((CurrentWan.Enable == "1") && (Prefix.length != 0)) ? PrefixValidTimeRemaining : "";
			PrefixValidTimeRemaining = convertDHCPLeaseTimeRemaining(PrefixValidTimeRemaining);

			if("CONNECTED" == ipv6Wan.ConnectionStatus.toUpperCase() )
			{
				document.getElementById("IPv6GateWay").innerHTML = ipv6Wan.DefaultRouterAddress;
				document.getElementById("IPv6DnsServer").innerHTML = ipv6Wan.DNSServers;
				document.getElementById("IPv6PreferredTime").innerHTML = AddTimeUnit(AddressPreferredTimeHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6VaildTime").innerHTML = AddTimeUnit(AddressValidTimeHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6VaildTimeRemaining").innerHTML = AddTimeUnit(AddressValidTimeRemainingHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6Prefix").innerHTML = Prefix;
				document.getElementById("IPv6PrefixPreferredTime").innerHTML = AddTimeUnit(PrefixPreferredTime,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6PrefixVaildTime").innerHTML = AddTimeUnit(PrefixValidTime,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6PrefixVaildTimeRemaining").innerHTML = AddTimeUnit(PrefixValidTimeRemaining,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6IpAddress").innerHTML = AddressHtml;
				document.getElementById("Ipv6IpState").innerHTML = AddressStatusHtml;
				document.getElementById("IPv6DsliteAftrname").innerHTML = CurrentWan.IPv6AFTRName;
				document.getElementById("IPv6DslitePeerAddress").innerHTML = ipv6Wan.AFTRPeerAddr;

			}
			else
			{
				document.getElementById("IPv6GateWay").innerHTML = "--";
				document.getElementById("IPv6DnsServer").innerHTML = "--";
				document.getElementById("IPv6PreferredTime").innerHTML = "--";
				document.getElementById("IPv6VaildTime").innerHTML = "--";
				document.getElementById("IPv6Prefix").innerHTML = "--";
				document.getElementById("IPv6PrefixPreferredTime").innerHTML = "--";
				document.getElementById("IPv6PrefixVaildTime").innerHTML = "--";
				document.getElementById("IPv6PrefixVaildTimeRemaining").innerHTML = "--";
				document.getElementById("IPv6IpAddress").innerHTML = "--";
				document.getElementById("Ipv6IpState").innerHTML = "--";
				document.getElementById("IPv6DsliteAftrname").innerHTML = "--";
				document.getElementById("IPv6DslitePeerAddress").innerHTML = "--";
		  }

		  if('IPoE' == CurrentWan.EncapMode)
		  {
			  setDisplay("IPv6DialCodeRow",0);
		  }
		  else
		  {
			  var lla = "";
			  var gua = "";
			  for (var m = 0; m < AddressList.length; m++)
			  {
					if (AddressList[m].Origin.toUpperCase() != "LINKLOCAL")
					{
						gua = AddressList[m].IPAddress;
					}
					else
					{
						lla = AddressList[m].IPAddress;
					}
			  }

			  if (IsDisplayIPv6DialCode(AddressAcquire.Origin, lla, gua) == false)
			  {
				  setDisplay("IPv6DialCodeRow",0);
			  }
			  else
			  {
				  setDisplay("IPv6DialCodeRow",1)

				  var error = GetIPv6PPPoeError(CurrentWan, lla, gua);
				  document.getElementById("IPv6DialCode").innerHTML = error;
			  }
			  
			  if('GLOBE2' == curCfgMode.toUpperCase())
			  {
				  setDisplay("V6PPPUsernameRow",1);
				  setDisplay("V6PPPPasswordRow",1);
				  document.getElementById("V6PPPUsername").innerHTML = CurrentWan.UserName;
				  document.getElementById("V6PPPPassword").innerHTML = "***";
			  }
		  }

		  if (true == TELMEX)
		  {
			  setDisplay("IPv6DialCodeRow",0);
		  }

		}
		else
		{	
			setDisplay("IPv6GateWayRow",0);
			setDisplay("IPv6DnsServerRow",0);
			setDisplay("IPv6PrefixRow",0);
			setDisplay("IPv6PrefixModeRow",0);
			setDisplay("IPv6PrefixPreferredTimeRow",0);
			setDisplay("IPv6PrefixVaildTimeRow",0);
			setDisplay("IPv6PrefixVaildTimeRemainingRow",0);
			setDisplay("IPv6IpAddressRow",0);
			setDisplay("IPv6IpAccessModeRow",0);
			setDisplay("Ipv6IpStateRow",0);
			setDisplay("IPv6PreferredTimeRow",0);
			setDisplay("IPv6VaildTimeRow",0);
			setDisplay("IPv6DsliteAftrnameRow",0);
			setDisplay("IPv6VaildTimeRemainingRow",0);
			setDisplay("IPv6DslitePeerAddressRow",0);
			setDisplay("IPv6DialCodeRow",0);
		}
		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = ipv6Wan.V6UpTime%60;
		minutes = Math.floor(ipv6Wan.V6UpTime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;

		setDisplay("V6UpTimeRow",1);

		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			 document.getElementById("V6UpTime").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("V6UpTime").innerHTML = "--";
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
			data : "x.X_HW_Token="+getValue('onttoken'),
			url : "option121.cgi?WANNAME=wan"+wanindex,
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
		setDisplay("ipv4InformationForm",1);
		
		document.getElementById("MacAddress").innerHTML = CurrentWan.MACAddress;
		setText("MacAddress",CurrentWan.MACAddress);
		
		document.getElementById("PriorityColleft").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? waninfo_language['bbsp_wanpriority'] : waninfo_language['bbsp_wandefaultpri'];
				
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

		setDisplay("RDModeRow", 0);
		setDisplay("RDPrefixRow", 0);
		setDisplay("RDPrefixLenthRow", 0);
		setDisplay("RDBrAddrRow", 0);
		setDisplay("RDIpv4MaskLenthRow", 0);
		setDisplay("V4PPPUsernameRow",0);
		setDisplay("V4PPPPasswordRow",0);

		if(true == IsSonetUser())
		{		
			setDisplay("VlanRow",0);
			setDisplay("PriorityRow",0);
			setDisplay("PriorityPolicyRow",0);
		}
		
		if (true == IsSingtelUser())
		{
			setDisplay("VlanRow",0);
			setDisplay("PriorityRow",0);
			setDisplay("PriorityPolicyRow",0);			
		}
		
		if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
		{
			document.getElementById("IPAddressMode").innerHTML = "--";
		}
		else
		{
			document.getElementById("IPAddressMode").innerHTML = ChangeLanguageWanIPv4AddressMode(CurrentWan.IPv4AddressMode);
		}	
		
		if( 'IP_Routed' == CurrentWan.Mode )
		{
			document.getElementById("NatSwitch").innerHTML = CurrentWan.IPv4NATEnable == "1" ? waninfo_language['bbsp_enable']: waninfo_language['bbsp_disable'];
			
			setDisplay("NatSwitchRow",1);
			setDisplay("IpAdressRow",1);
			setDisplay("GateWayRow",1);
			if(true == TELMEX)
			{
				setDisplay("DnsServerRow",0);
				setDisplay("PriDnsServerRow",1);
				setDisplay("SecDnsServerRow",1);
			}
			else
			{
				setDisplay("DnsServerRow",1);
				setDisplay("PriDnsServerRow",0);
				setDisplay("SecDnsServerRow",0);
			}			
			
			var servicetypeIsMatch = (-1 != CurrentWan.ServiceList.indexOf("INTERNET")) || (-1 != CurrentWan.ServiceList.indexOf("IPTV")) || (-1 != CurrentWan.ServiceList.indexOf("OTHER"));
			if( (1 == CurrentWan.IPv4Enable) && (0 == CurrentWan.IPv6Enable) &&
				(true == servicetypeIsMatch)&&(true == Is6RdSupported()))
			{
				setDisplay("RDModeRow", 1);
				document.getElementById("RDMode").innerHTML = CurrentWan.RdMode;
				if (1 == CurrentWan.Enable6Rd)
				{
					setDisplay("RDPrefixRow", 1);
					setDisplay("RDPrefixLenthRow", 1);
					setDisplay("RDBrAddrRow", 1);
					setDisplay("RDIpv4MaskLenthRow", 1);
					document.getElementById("RDPrefix").innerHTML = CurrentWan.RdPrefix;
					document.getElementById("RDPrefixLenth").innerHTML = CurrentWan.RdPrefixLen;
					document.getElementById("RDBrAddr").innerHTML = CurrentWan.RdBRIPv4Address;
					document.getElementById("RDIpv4MaskLenth").innerHTML = CurrentWan.RdIPv4MaskLen;					
				}
			}

			if(("Connected" == CurrentWan.Status ) && ('' != CurrentWan.IPv4IPAddress) )
			{
				document.getElementById("IpAdress").innerHTML = CurrentWan.IPv4IPAddress + "/" + CurrentWan.IPv4SubnetMask;
				if (CurrentWan.IPv4Gateway != '')
                {
    				document.getElementById("GateWay").innerHTML = CurrentWan.IPv4Gateway;
                }
                else
                {
    				document.getElementById("GateWay").innerHTML = "--";                    
                }
				
				var DnsSplitCharacter = ("" == CurrentWan.IPv4SecondaryDNS) ? " " : ",";
				if((true == TELMEX) && (dhcpmain.enable == 1))
				{
					if(((dhcpmain.MainPriDNS == "") && (dhcpmain.MainSecDNS == ""))
					|| (dhcpmain.MainPriDNS == LanHostInfo.ipaddr) || (dhcpmain.MainSecDNS == LanHostInfo.ipaddr))
					{
						document.getElementById("PriDnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS;
						document.getElementById("SecDnsServer").innerHTML = CurrentWan.IPv4SecondaryDNS;

					}
					else
					{
						document.getElementById("PriDnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + '<br>' + '<font color="red">' + waninfo_language['bbsp_waninfo_dnsser'] + '</font>';
						document.getElementById("SecDnsServer").innerHTML = CurrentWan.IPv4SecondaryDNS + '<br>' + '<font color="red">' + waninfo_language['bbsp_waninfo_dnsser'] + '</font>';
					}
				}
				else
				{
					if(true == TELMEX)
					{
						document.getElementById("PriDnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS;
						document.getElementById("SecDnsServer").innerHTML = CurrentWan.IPv4SecondaryDNS;
					}
					else
					{
						document.getElementById("DnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + DnsSplitCharacter +CurrentWan.IPv4SecondaryDNS;
					}
				}
			}
			else
			{
				document.getElementById("IpAdress").innerHTML = "--";
				document.getElementById("GateWay").innerHTML = "--";
				if(true == TELMEX)
				{
					document.getElementById("PriDnsServer").innerHTML = "--";
					document.getElementById("SecDnsServer").innerHTML = "--";
				}
				else
				{
					document.getElementById("DnsServer").innerHTML = "--";
				}
			}

			if('IPoE' == CurrentWan.EncapMode)
			{
				setDisplay("BrasNameRow",0);
				setDisplay("DialCodeRow",0);
				
				if (("STATIC" == CurrentWan.IPv4AddressMode.toUpperCase()) || ("AUTO" == CurrentWan.IPv4AddressMode.toUpperCase()))
				{
					setDisplay("LeaseTimeRow",0);
					setDisplay("LeaseTimeRemainingRow",0);
					setDisplay("NtpServerRow",0);
					setDisplay("STimeRow",0);
					setDisplay("SipServerRow",0);
					setDisplay("StaticRouteRow",0);
					setDisplay("VenderInfoRow",0);
				}
				else
				{
					setDisplay("LeaseTimeRow",1);
					setDisplay("LeaseTimeRemainingRow",1);
					setDisplay("NtpServerRow",1);
					setDisplay("STimeRow",1);
					setDisplay("SipServerRow",1);
					setDisplay("StaticRouteRow",1);
					setDisplay("VenderInfoRow",1);
				}

				if(true == IsSonetUser())
				{
					setDisplay("SipServerRow",0);
					setDisplay("StaticRouteRow",0);
					setDisplay("VenderInfoRow",0);
				}
				
				if (true == IsSingtelUser())
				{
					setDisplay("SipServerRow",0);
					setDisplay("StaticRouteRow",0);
					setDisplay("VenderInfoRow",0);
					setDisplay("NtpServerRow",0);				
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
					    if (false == IsSingtelUser())
					    {
    						GetOption121(CurrentWan.MacId);
						}
					}
					else
					{
						document.getElementById("StaticRoute").innerHTML = CurrentWan.StaticRouteInfo;
					}
					IPv4VendorId = CurrentWan.IPv4VendorId;
					setNoEncodeInnerHtmlValue("VenderInfo", replaceSpace(GetStringContent(htmlencode(IPv4VendorId),16)));
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
					setDisplay("SipServerRow",0);
				}
			}
			else
			{			
				setDisplay("BrasNameRow",1);
				setDisplay("LeaseTimeRow",0);
				setDisplay("LeaseTimeRemainingRow",0);
				setDisplay("NtpServerRow",0);
				setDisplay("STimeRow",0);
				setDisplay("SipServerRow",0);
				setDisplay("StaticRouteRow",0);
				setDisplay("VenderInfoRow",0);			
				
				if("Connected" == CurrentWan.Status)
				{
					document.getElementById("BrasName").innerHTML = CurrentWan.PPPoEACName;
										
					setDisplay("DialCodeRow",0);
				}
				else
				{				
					setDisplay("DialCodeRow",1);
					
					var error = GetIPv4PPPoeError(CurrentWan);
					
					document.getElementById("DialCode").innerHTML = error;
					document.getElementById("BrasName").innerHTML = "--";
				}

				if (true == TELMEX)
				{
					setDisplay("DialCodeRow",0);
				}
				
				if('GLOBE2' == curCfgMode.toUpperCase())
				{
					setDisplay("V4PPPUsernameRow",1);
					setDisplay("V4PPPPasswordRow",1);
					document.getElementById("V4PPPUsername").innerHTML = CurrentWan.UserName;
					document.getElementById("V4PPPPassword").innerHTML = "***";
				}
			}
		}
		else
		{				
			setDisplay("NatSwitchRow",0);
			setDisplay("IpAdressRow",0);
			setDisplay("GateWayRow",0);
			setDisplay("DnsServerRow",0);
			setDisplay("BrasNameRow",0);
			setDisplay("LeaseTimeRow",0);
			setDisplay("LeaseTimeRemainingRow",0);
			setDisplay("NtpServerRow",0);
			setDisplay("STimeRow",0);
			setDisplay("SipServerRow",0);
			setDisplay("StaticRouteRow",0);
			setDisplay("VenderInfoRow",0);
			setDisplay("DialCodeRow",0);
		}


		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = CurrentWan.Uptime%60;
		minutes = Math.floor( CurrentWan.Uptime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;

		setDisplay("V4UpTimeRow",1);

		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			document.getElementById("V4UpTime").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("V4UpTime").innerHTML = "--";
		}
	}

	function setControl(WanIndex)
	{
		if (true == IsPtvdfUser())
		{
			return;
		}
		var CurrentWan = GetWanList()[WanIndex];
		var ProtocolType = GetProtocolType(CurrentWan.IPv4Enable, CurrentWan.IPv6Enable);
		if ("IPv4" == ProtocolType)
		{
			DisplayIPv4WanDetail(WanIndex);
		}
		else if ("IPv6" == ProtocolType)
		{
			DisplayIPv6WanDetail(WanIndex);
		}
		else if ("IPv4/IPv6" == ProtocolType)
		{
			if ("IPV4" == ClickWanType)
			{
				DisplayIPv4WanDetail(WanIndex);
			}
			else if ("IPV6" == ClickWanType)
			{
				DisplayIPv6WanDetail(WanIndex);
			}
		}
	}

	var IPv4WanCount = 0;
	var IPv6WanCount = 0;
	var IPv6WanRdsCount = 0;
	for (var i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		if ((CurrentWan.IPv4Enable != "1") ||
			((GetCfgMode().PTVDF == 1) && (IsAdminUser() == false) && (MobileBackupWanSwitch == 0) && (CurrentWan.Name.toUpperCase().indexOf("MOBILE") >=0)))
		{
			continue;
		}
		IPv4WanCount ++;

		document.write('<TR id="record_' + i + '" onclick="selectLineipv4(this.id);" class="tabal_01" align="center">');
		if (false == IsRDSGatewayUser())
		{
			document.write('<td class="restrict_dir_ltr">'+htmlencode(CurrentWan.Name)+'</td>');
		}

		if (true == IsRadioWanSupported(CurrentWan))
		{
			document.write('<td>'+ChangeLanguageWanStatus(CurrentWan.Status)+'</td>');  
		}
		else if (GetOntState()!='ONLINE')
		{
			document.write('<td>'+ChangeLanguageWanStatus('Disconnected')+'</td>');
		}
		else
		{
			if ("UNCONFIGURED" == CurrentWan.Status.toUpperCase())
			{
				document.write('<td>'+ChangeLanguageWanStatus('Disconnected')+'</td>');
			}
			else
			{
				document.write('<td>'+ChangeLanguageWanStatus(CurrentWan.Status)+'</td>');
			}
		}

		if((CurrentWan.Status=="Connected") && (CurrentWan.IPv4IPAddress != '') && (CurrentWan.Mode == 'IP_Routed'))
		{
			document.write('<td>'+CurrentWan.IPv4IPAddress + '</td>');
		}
		else
		{
			document.write('<td align="center">--</td>');
		}

		if(false == IsSonetUser() && false == IsRDSGatewayUser() && false == IsPtvdfUser() && false == IsSingtelUser())
		{
			if ( 0 != parseInt(CurrentWan.VlanId,10) )
			{
				var pri = ('Specified' == CurrentWan.PriorityPolicy) ? CurrentWan.Priority : CurrentWan.DefaultPriority ;
				document.write('<td>'+CurrentWan.VlanId+'/'+pri+'</td>');
			}
			else
			{
				document.write('<td>'+'-/-'+'</td>');
			}
		}


		if (false == IsRDSGatewayUser() && false == IsSingtelUser())
		{
			if (NeedAddConnectButton(CurrentWan) == true && CurrentWan.Enable == "1")
			{

				var btText = CurrentWan.ConnectionControl == "1" ? waninfo_language['bbsp_discon']: waninfo_language['bbsp_con'];
				var ctrFlag = CurrentWan.ConnectionControl == "1" ? "0": "1";
				document.write("<td align='center'><a style='color:blue' onclick = 'OnConnectionControlButtonGlobe(this,"+i+","+ctrFlag+")' RecordId = '"+i+"' href='#'>"+btText+"</a></td>");
			}
			else
			{
				var innerText = CurrentWan.Enable == "1" ? waninfo_language['bbsp_AlwaysOn']:waninfo_language['bbsp_AlwaysOn'];
				if(true == IsRadioWanSupported(CurrentWan))
				{
					if(CurrentWan.TriggerMode == "OnDemand")
					{
						innerText = waninfo_language['bbsp_needcon'];
					}
				}
				else
				{
					if (CurrentWan.ConnectionTrigger == "OnDemand")
					{
						innerText = waninfo_language['bbsp_needcon'];
					}
					else if (CurrentWan.ConnectionTrigger == "Manual")
					{
						innerText = waninfo_language['bbsp_Manual'];
					}
				}
				document.write("<td>"+innerText+"</td>");
			}
	 	}
		if('GLOBE2' == curCfgMode.toUpperCase())
		{
			if( 'IP_Routed' == CurrentWan.Mode )
			{
				if('IPoE' == CurrentWan.EncapMode)
				{
					document.write('<td>--</td>');
				}
				else
				{
					var error = GetIPv4PPPoeError(CurrentWan);
					if("Connected" == CurrentWan.Status)
					{	
						document.write('<td>--</td>');
					}
					else
					{				
						document.write('<td>'+error+'</td>');
					}
				}
			}
			else
			{
				document.write('<td>--</td>');
			}			
		}
		document.write('</tr>');
	}
	if(0 == IPv4WanCount)
	{
		document.write("<tr class= \"tabal_01\" align=\"center\">");
		if(false == IsRDSGatewayUser())
		{
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
		}
		
		if (false == IsSonetUser() && false == IsRDSGatewayUser() && false == IsPtvdfUser())
		{
			document.write('<td >'+'--'+'</td>');
		}
		
		if (false == IsSingtelUser())
		{
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');	
		}		
		if('GLOBE2' == curCfgMode.toUpperCase())	
		{
			document.write('<td >'+'--'+'</td>');
		}
		
		document.write("</tr>");
	}
	</script>
</table>

<div align='center' style="display:none" id="WanDetail"> 
<div class="list_table_spread"></div>
<form id="ipv4InformationForm" name="ipv4InformationForm">
<table id="ipv4InformationFormPanel" class="tabal_bg width_per100"  cellspacing="1" >
<li id="WanDetailTitle" RealType="HorizonBar" DescRef="bbsp_wandetailinfo" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="MacAddress" RealType="HtmlText" DescRef="bbsp_wanmacaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="MacAddress" InitValue="Empty"/> 
<li id="Vlan" RealType="HtmlText" DescRef="bbsp_wanvlan" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Vlan" InitValue="Empty"/> 
<li id="PriorityPolicy" RealType="HtmlText" DescRef="bbsp_wanpripolicy" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PriorityPolicy" InitValue="Empty"/> 
<li id="Priority" RealType="HtmlText" DescRef="bbsp_wanpriority" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Priority" InitValue="Empty"/> 

<li id="NatSwitch" RealType="HtmlText" DescRef="bbsp_wannat" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NatSwitch" InitValue="Empty"/>
<li id="IPAddressMode" RealType="HtmlText" DescRef="bbsp_ipmode1" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>  
<li id="V4PPPUsername" RealType="HtmlText" DescRef="" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>  
<li id="V4PPPPassword" RealType="HtmlText" DescRef="" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>  
<li id="IpAdress" RealType="HtmlText" DescRef="bbsp_wanip" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IpAdress" InitValue="Empty"/> 
<li id="GateWay" RealType="HtmlText" DescRef="bbsp_wangateway" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="GateWay" InitValue="Empty"/> 
<li id="DnsServer" RealType="HtmlText" DescRef="bbsp_wandns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="DnsServer" InitValue="Empty"/> 
<li id="PriDnsServer" RealType="HtmlText" DescRef="bbsp_wanpridns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="SecDnsServer" RealType="HtmlText" DescRef="bbsp_wansecdns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="BrasName" RealType="HtmlText" DescRef="bbsp_wanbras" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="BrasName" InitValue="Empty"/> 
<li id="DialCode" RealType="HtmlText" DescRef="bbsp_wandialcode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="DialCode" InitValue="Empty"/> 
<li id="LeaseTime" RealType="HtmlText" DescRef="bbsp_wanlease" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="LeaseTime" InitValue="Empty"/> 
<li id="LeaseTimeRemaining" RealType="HtmlText" DescRef="bbsp_wanlease_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="LeaseTimeRemaining" InitValue="Empty"/> 
<li id="NtpServer" RealType="HtmlText" DescRef="bbsp_wanntp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NtpServer" InitValue="Empty"/> 
<li id="STime" RealType="HtmlText" DescRef="bbsp_wanstime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="STime" InitValue="Empty"/> 
<li id="SipServer" RealType="HtmlText" DescRef="bbsp_wansip" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="SipServer" InitValue="Empty"/> 
<li id="StaticRoute" RealType="HtmlText" DescRef="bbsp_wansroute" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="StaticRoute" InitValue="Empty"/> 
<li id="VenderInfo" RealType="HtmlText" DescRef="bbsp_wanvendor" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="VenderInfo"  Elementclass="restrict_dir_ltr" InitValue="Empty"/> 
<li id="RDMode" RealType="HtmlText" DescRef="Des6RDMode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDMode" InitValue="Empty"/> 
<li id="RDPrefix" RealType="HtmlText" DescRef="Des6RDPrefix" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDPrefix" InitValue="Empty"/> 
<li id="RDPrefixLenth" RealType="HtmlText" DescRef="Des6RDPrefixLenth" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDPrefixLenth" InitValue="Empty"/> 
<li id="RDBrAddr" RealType="HtmlText" DescRef="Des6RDBrAddr" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDBrAddr" InitValue="Empty"/> 
<li id="RDIpv4MaskLenth" RealType="HtmlText" DescRef="Des6RDIpv4MaskLenth" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDIpv4MaskLenth" InitValue="Empty"/> 
<li id="V4UpTime" RealType="HtmlText" DescRef="uptime_tips" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="V4UpTime" InitValue="Empty"/> 
</table>

<script>
var TableClass = new stTableClass("align_left width_per30", "align_left width_per70", "ltr");
var Ipv4WanInfoFormList = new Array();
	Ipv4WanInfoFormList = HWGetLiIdListByForm("ipv4InformationForm",null);
	HWParsePageControlByID("ipv4InformationForm",TableClass,waninfo_language,null);
	var Ipv4WaninfoArray = new Array();
	
	HWSetTableByLiIdList(Ipv4WanInfoFormList,Ipv4WaninfoArray,null);
	document.getElementById("V4PPPUsernameColleft").innerHTML = Languages['IPv4UserName'];
	document.getElementById("V4PPPPasswordColleft").innerHTML = Languages['IPv4Password'];
</script>
</form>
</div>

<div id="IPv6TitleInfoBar">
<table width="100%" height="5"> 
<tbody><tr> 
<td></td> 
</tr> 
</tbody></table>
<table width="100%" border="0" cellpadding="0" cellspacing="0"> 
<tr><td class="func_title" BindText="bbsp_inv6info" style="padding: 0px 0px 2px 0px;"></td>
  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</tr></table>  
</div>
<table class="tabal_bg width_per100" cellspacing="1"  id="IPv6PrefixPanelRds" style="display:none">
  <tr class="head_title">
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_ipmode'></td>
	<td BindText = 'bbsp_prefixmaskmode'></td>
	<td BindText = 'bbsp_ip'></td>
	<td BindText = 'bbsp_ipstate'></td>
  </tr>
  <script type="text/javascript" language="javascript">

		for (var i = 0;i < GetWanList().length;i++)
		{
			var CurrentWan = GetWanList()[i];
			var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
				var AddressList = GetIPv6AddressList(CurrentWan.MacId);

			if (CurrentWan.IPv6Enable != "1")
			{
				continue;
			}

			IPv6WanRdsCount++;

			var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
			if (ipv6Wan == null)
			{
				continue;
			}

			document.write('<tr id="ipv6recordRds_' + i + '"  class="tabal_01" align="center">');
			document.write('<td>'+ChangeLanguageWanStatus(ipv6Wan.ConnectionStatus)+'</td>');

			var PrefixAcquire = GetIPv6PrefixAcquireInfo(CurrentWan.domain);
			PrefixAcquire = ((PrefixAcquire==null) ? '' : PrefixAcquire.Origin);
			PrefixAcquire = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? '--' : PrefixAcquire;

			var AcquireHtml = "";
			var AddressHtml = "";
			var AddressStatusHtml = "";
			for (var m = 0; m < AddressList.length; m++)
			{
				 AcquireHtml += (AddressList[m].Origin == ""?AddressAcquire.Origin:AddressList[m].Origin) +"<br>";
				 if (CurrentWan.Enable == "1")
				 {
					 AddressHtml += AddressList[m].IPAddress+"<br>";
					 AddressStatusHtml += AddressList[m].IPAddressStatus +"<br>";
				 }
			}

			if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
			{
				AcquireHtml = "--<br>";
				AddressHtml = "--<br>";
				AddressStatusHtml = "--<br>";
			}

			document.write('<td>'+AcquireHtml+'</td>');
			document.write('<td>'+PrefixAcquire+'</td>');
			document.write('<td>'+AddressHtml+'</td>');
			document.write('<td>'+AddressStatusHtml+'</td>');

			document.write('</tr>');
		}

	if( 0 == IPv6WanRdsCount)
		{
			document.write("<tr class= \"tabal_01\" align=\"center\">");
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write("</tr>");
		}
		</script>
</table>
<table class="tabal_bg width_per100" cellspacing="1"  id="IPv6PrefixPanel">
  <tr class="head_title">
	<td BindText = 'bbsp_wanname'></td>
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_prefixmask'></td>
	<script type="text/javascript" language="javascript">
	if (false == IsSonetUser())
	{
		document.write('<td>'+waninfo_language['bbsp_ip']+'</td>');
	}
	if(false == IsSonetUser() && false == IsPtvdfUser())
	{
		document.write('<td>'+waninfo_language['bbsp_vlanpri']+'</td>');
	}
	if('GLOBE2' == curCfgMode.toUpperCase())
	{
		document.write('<td>'+waninfo_language['bbsp_wandialcode']+'</td>');
	}
	</script>
  </tr>
  <script type="text/javascript" language="javascript">

		for (var i = 0;i < GetWanList().length;i++)
		{
			var CurrentWan = GetWanList()[i];

			if (CurrentWan.IPv6Enable != "1")
			{
				continue;
			}

			IPv6WanCount++;

			var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
			if (ipv6Wan == null)
			{
				continue;
			}

			document.write('<tr id="ipv6record_' + i + '" onclick="selectLineipv6(this.id);" class="tabal_01" align="center">');
			document.write('<td class="restrict_dir_ltr">'+htmlencode(CurrentWan.Name)+'</td>');
			document.write('<td>'+ChangeLanguageWanStatus(ipv6Wan.ConnectionStatus)+'</td>');


			var PrefixList = GetIPv6PrefixList(CurrentWan.MacId)
			var Prefix = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].Prefix:'') :(PrefixList[0].Prefix));
			Prefix = (CurrentWan.Enable == "1") ? Prefix : "";
			Prefix = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? '--' : Prefix;
			if(ipv6Wan.ConnectionStatus.toUpperCase()=="CONNECTED")
			{
				document.write('<td class="restrict_dir_ltr">'+Prefix+ '</td>');
			}
			else
			{
				document.write('<td>'+'--'+ '</td>');
			}
			
			var AddressHtml = "";
			var AddressList = GetIPv6AddressList(CurrentWan.MacId);
			for (var m = 0; m < AddressList.length; m++)
			{
				 if (CurrentWan.Enable == "1")
				 {
					 AddressHtml += (AddressList[m].IPAddress == ""?"--":AddressList[m].IPAddress)+"<br>";
				 }
			}

			if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0 || AddressList.length < 1)
			{
				AddressHtml = "--<br>";
			}
			
			if (false == IsSonetUser())
			{
				document.write('<td class="restrict_dir_ltr">'+AddressHtml+'</td>');
			}
			if(false == IsSonetUser() && false == IsPtvdfUser())
			{
				if (0 != parseInt(CurrentWan.VlanId,10))
				{
					var pri = ('Specified' == CurrentWan.PriorityPolicy) ? CurrentWan.Priority : CurrentWan.DefaultPriority ;
					document.write('<td>'+CurrentWan.VlanId+'/'+pri+'</td>');
				}
				else
				{
					document.write('<td>'+'-/-'+'</td>');
				}
			}
			if('GLOBE2' == curCfgMode.toUpperCase())
			{	
				if('IP_Routed' == CurrentWan.Mode)
				{ 
					if('IPoE' == CurrentWan.EncapMode)
					{
						document.write('<td>--</td>');
					}
					else
					{
						var lla = "";
						var gua = "";
						var AddressList = GetIPv6AddressList(CurrentWan.MacId);
						for (var m = 0; m < AddressList.length; m++)
						{
							if (AddressList[m].Origin.toUpperCase() != "LINKLOCAL")
							{
								gua = AddressList[m].IPAddress;
							}
							else
							{
								lla = AddressList[m].IPAddress;
							}
						}
						var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
						if (IsDisplayIPv6DialCode(AddressAcquire.Origin, lla, gua) == false)
						{	
							document.write('<td>--</td>');
						}
						else
						{ 
							var error = GetIPv6PPPoeError(CurrentWan, lla, gua);
							document.write('<td>' + error + '</td>')
						}
					}
				}
				else
				{
					document.write('<td>--</td>');
				}
			}			

			document.write('</tr>');
		}

		if( 0 == IPv6WanCount)
		{
			document.write("<tr class= \"tabal_01\" align=\"center\">");
			if(false == IsSonetUser() && false == IsPtvdfUser())
			{
				document.write('<td >'+'--'+'</td>');
			}
			if (false == IsSonetUser())
			{
				document.write('<td >'+'--'+'</td>');
			}
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			if('GLOBE2' == curCfgMode.toUpperCase())	
			{
				document.write('<td >'+'--'+'</td>');
			}			
			document.write("</tr>");
		}
		</script>
</table>

<div  align='center' style="display:none" id="IPv6WanDetail">
<div class="list_table_spread"></div>
<form id="ipv6InformationForm" name="ipv6InformationForm">
<table id="ipv6InformationFormPanel" class="tabal_bg width_per100"  cellspacing="1">
<li id="IPv6WanDetailTitle" RealType="HorizonBar" DescRef="bbsp_wandetailinfo" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="IPv6MacAddress" RealType="HtmlText" DescRef="bbsp_wanmacaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6MacAddress" InitValue="Empty"/> 
<li id="IPv6Vlan" RealType="HtmlText" DescRef="bbsp_wanvlan" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Vlan" InitValue="Empty"/> 
<li id="IPv6PriorityPolicy" RealType="HtmlText" DescRef="bbsp_wanpripolicy" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PriorityPolicy" InitValue="Empty"/> 
<li id="IPv6Priority" RealType="HtmlText" DescRef="bbsp_wanpriority" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Priority" InitValue="Empty"/> 

<li id="V6PPPUsername" RealType="HtmlText" DescRef="" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="V6PPPPassword" RealType="HtmlText" DescRef="" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="IPv6DnsServer" RealType="HtmlText" DescRef="bbsp_wandns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DnsServer"  Elementclass="restrict_dir_ltr"  InitValue="Empty"/> 
<li id="IPv6Prefix" RealType="HtmlText" DescRef="bbsp_ipv6prefix" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Prefix" Elementclass="restrict_dir_ltr" InitValue="Empty"/> 
<li id="IPv6PrefixMode" RealType="HtmlText" DescRef="bbsp_ipv6prefixmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixMode" InitValue="Empty"/> 
<li id="IPv6PrefixPreferredTime" RealType="HtmlText" DescRef="bbsp_prefixpreferredtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixPreferredTime" InitValue="Empty"/> 
<li id="IPv6PrefixVaildTime" RealType="HtmlText" DescRef="bbsp_prefixvaildtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixVaildTime" InitValue="Empty"/> 
<li id="IPv6PrefixVaildTimeRemaining" RealType="HtmlText" DescRef="bbsp_prefixvaild_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixVaildTimeRemaining" InitValue="Empty"/> 
<li id="IPv6IpAddress" RealType="HtmlText" DescRef="bbsp_ipv6ipaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6IpAddress" Elementclass="restrict_dir_ltr" InitValue="Empty"/> 
<li id="IPv6IpAccessMode" RealType="HtmlText" DescRef="bbsp_ipacmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6IpAccessMode" InitValue="Empty"/> 
<li id="Ipv6IpState" RealType="HtmlText" DescRef="bbsp_ipv6ipstate" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Ipv6IpState" InitValue="Empty"/> 
<li id="IPv6PreferredTime" RealType="HtmlText" DescRef="bbsp_ippreferredtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PreferredTime" InitValue="Empty"/> 
<li id="IPv6VaildTime" RealType="HtmlText" DescRef="bbsp_ipvaildtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6VaildTime" InitValue="Empty"/> 
<li id="IPv6VaildTimeRemaining" RealType="HtmlText" DescRef="bbsp_ipvaildtime_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6VaildTimeRemaining" InitValue="Empty"/> 
<li id="IPv6GateWay" RealType="HtmlText" DescRef="bbsp_ipv6_default_route" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6GateWay" Elementclass="restrict_dir_ltr" InitValue="Empty"/> 
<li id="IPv6DsliteAftrname" RealType="HtmlText" DescRef="bbsp_dsliteaftrname" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DsliteAftrname" InitValue="Empty"/> 
<li id="IPv6DslitePeerAddress" RealType="HtmlText" DescRef="bbsp_dslitepeeraddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DslitePeerAddress" Elementclass="restrict_dir_ltr" InitValue="Empty"/> 
<li id="IPv6DialCode" RealType="HtmlText" DescRef="bbsp_wandialcode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DialCode" InitValue="Empty"/> 
<li id="V6UpTime" RealType="HtmlText" DescRef="uptime_tips" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="V6UpTime" InitValue="Empty"/> 

</table>
<script>
var TableClassTwo = new stTableClass("align_left width_per30", "align_left width_per70", "ltr");
var Ipv6WanInfoFormList = new Array();
	Ipv6WanInfoFormList = HWGetLiIdListByForm("ipv6InformationForm",null);
	HWParsePageControlByID("ipv6InformationForm",TableClassTwo,waninfo_language,null);
	document.getElementById("V6PPPUsernameColleft").innerHTML = Languages['IPv4UserName'];
	document.getElementById("V6PPPPasswordColleft").innerHTML = Languages['IPv4Password'];
</script>
</form>
</div>
</div>

<script>
	if ((GetFeatureInfo().IPv6 == "0") || (true == bin5board()) || (false == IsSupportIPv6WANInfo()))
	{
		setDisplay("IPv6TitleInfoBar", "0");
		setDisplay("IPv6PrefixPanel", "0");
	}
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:8px;"> 
<tr><td class="func_title" style="padding-bottom:2px;">User Device Information</td></tr>
</table>  
<table width="100%" class='tabal_bg' border="0" align="center" cellpadding="0" cellspacing="1" id='devlist' style="margin-bottom:0px">
	<tr class="head_title">
		<script type="text/javascript">
			document.write('<td class="width_per15">'+userdevinfo_language['bbsp_hostname']+'</td>');
			document.write('<td class="width_per15">'+userdevinfo_language['bbsp_ip']+'</td>');
			document.write('<td class="width_per15">'+userdevinfo_language['bbsp_mac']+'</td>');
			document.write('<td class="width_per5">'+userdevinfo_language['bbsp_devstate']+'</td>');
			document.write('<td class="width_per5">'+userdevinfo_language['bbsp_interface']+'</td>');
			document.write('<td class="width_per20">'+userdevinfo_language['bbsp_onlinetime']+'</td>');
			document.write('<td class="width_per15">'+userdevinfo_language['bbsp_leasetime']+'</td>');			
		</script>
	</tr>	
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:8px;"> 
<tr><td class="func_title" style="padding-bottom:2px;">VoIP Information</td></tr>
</table>  






<form id="ConfigFormSIP" >
<table id="voip_info_table" name="voip_info_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all;">            
			<tr class="head_title">
            <script type="text/javascript">
            
			document.write('<td class="width_per5">'+sipstatus['vspa_seq']+'</td>');
			document.write('<td class="width_per15">'+sipstatus['vspa_uri']+'</td>');
			document.write('<td class="width_per15">'+sipstatus['vspa_username']+'</td>');
			document.write('<td class="width_per10">'+sipstatus['vspa_assopots']+'</td>');
			document.write('<td class="width_per15">'+sipstatus['vspa_userstat']+'</td>');
			document.write('<td class="width_per7">'+sipstatus['vspa_callstat']+'</td>');
			document.write('<td class="width_per20">'+sipstatus['vspa_errorstat']+'</td>');	
			document.write('<td class="width_per10">'+sipstatus['vspa_regcodereason']+'</td>');	
            if (AllLine.length > 0 && AllLine.length - 1 == 0)
{
                var html = '';
                
                html += '<tr class="table_right">';
                html += '<td class="align_center">--</td>'
                       + '<td class="align_center">--</td>'
                       + '<td class="align_center">--</td>'
                       + '<td class="align_center">--</td>'  
                       + '<td class="align_center">--</td>'
                       + '<td class="align_center">--</td>' 
					   + '<td class="align_center">--</td>'  
                    html += '<td class="align_center">--</td>'
                html += '</tr>';     
                document.write(html);
}
            else if(AllLine.length > 1)
{
	for (i = 0; i < AllLine.length - 1; i++)
	{
                    var html = '';
                       
                    document.write('<tr class=\"table_right\">');
                    document.write('<td class=\"align_center\">' + (i+1) + '</td>');
					
			if (AllLineURI[i].URI == "")
			{
							document.write('<td class=\"align_center\">' + '--' + '</td>');
			}
			else
			{
							document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + AllLineURI[i].URI + '</td>');
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
                                document.write('<td class=\"align_center\">' + '--' + '</td>');
				}
				else
				{    
                                document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + k3 + '</td>');
				}
			 }
			 else
			 {
				 var Authpart = Auth[i].AuthUserName.split('@');
				 var k = Authpart[0];
				if (k == "")
				{    
                                document.write('<td class=\"align_center\">' + '--' + '</td>');
				}
				else
				{   
                                document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + k + '</td>');
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
                                document.write('<td class=\"align_center\">' + '--' + '</td>');
				}
				else
				{    
                                document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + k3 + '</td>');
				}
			 }
			 else
			 {
				 var UserId = User[i].UserId.split('@');
				 var k = UserId[0];
				if (k == "")
				{ 
                                document.write('<td class=\"align_center\">' + '--' + '</td>');
				}
				else
				{    
                                document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + k + '</td>');
				}
			 }
		}   
		if (AllLine[i].PhyReferenceList == "")
		{    
                        document.write('<td class=\"align_center\">' + '--' + '</td>');
		}
		else
		{    
                        document.write('<td class=\"align_center\" style=\"word-wrap:break-word; overflow:hidden;\">' + AllLine[i].PhyReferenceList + '</td>');
		}
 		if ( AllLine[i].Status == 'Up' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_succ'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Initializing' )
		{    
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_ini'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Registering' )
		{    
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_reg'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Unregistering' )
		{  
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_unreg'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Quiescent' )
		{    
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_qui'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Disabled' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_disa'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Error' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_err'] + '</td>');
		}
		else if ( AllLine[i].Status == 'Testing' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_status_test'] + '</td>');
		}
		else
		{
                        document.write('<td class=\"align_center\">' + '--' + '</td>');
		}
		if ( AllLine[i].CallState == 'Idle' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_idle'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'Calling' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_cal'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'Ringing' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_ring'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'Connecting' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_con'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'InCall' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_incall'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'Hold' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_hold'] + '</td>');
		}
		else if ( AllLine[i].CallState == 'Disconnecting' )
		{
                        document.write('<td class=\"align_center\">' + sipstatus['vspa_callstat_dis'] + '</td>');
		}
		else
		{
                        document.write('<td class=\"align_center\">' + '--' + '</td>');
		}		
		if ( AllLine[i].RegisterError == '-' )
		{
                                
                                document.write('<td class=\"align_center\">--</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ONU_OFFLINE' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_onuoffine'] + '</td>');
			}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_NOT_CONFIGURED' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_wannotconfigured'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_WAN_IP_NOT_OBTAINED' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_wannotobtained'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_CORENET_ADDRESS_INCORRECT' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_mgcincorrect'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_VOICESERVICE_DISABLED' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_voicedisabled'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_CONFIGURED' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_usernotconfigured'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_NOT_BOUND_TO_POTS' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_usernotboundport'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_POTS_DISABLED_BY_OLT' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_portdisabledOLT'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_USER_DISABLED' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_userdisable'] + '</td>');
		}
        else if ( AllLine[i].RegisterError == 'ERROR_USER_CONFLICT' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_userconflict'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_AUTH_FAIL' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_regauthfails'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_REGISTRATION_TIME_OUT' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_regtimesout'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_ERROR_RESPONSE_RETURNED_BY_CORENET' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_mgcerrorresponse'] + '</td>');
		}
		else if ( AllLine[i].RegisterError == 'ERROR_UNKNOWN' )
		{
                                document.write('<td class=\"align_center\">'+ sipstatus['vspa_errorstate_unknownerror'] + '</td>');
		}
		else
		{
                                document.write('<td class=\"align_center\">--</td>');
		}
							document.write('<td class="align_center">' + OutputCodeReason[i] + '</td>');

                    document.write("</tr>");                   
                    document.write(html);
	}
}
			else
			{
				;
			}
</script>
            </tr>      
</table>
</form>
<div class="title_spread"></div>
<div class="title_spread"></div>
<div class="title_spread"></div>

<script language="JavaScript" type="text/javascript">
var MAX_DEV_TYPE=10;
var MAX_HOST_TYPE=10;
var appName = navigator.appName;
var DHCPLeaseTimes = new Array();
var UserDevices = new Array();
var UserDevicesTemp = new Array();

var ipaddress = "";
var macaddress = "";
var porttype = "";
var portid   = "";
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

var SpecDevTypeNum = 6;


function GetRemainLeaseTime(ipaddr, macaddr)
{
	for (var i = 0; i < DHCPLeaseTimes.length - 1; i++)
	{
		if ((ipaddr == DHCPLeaseTimes[i].ip) && (macaddr == DHCPLeaseTimes[i].mac))
		{
			return DHCPLeaseTimes[i].remaintime;
		}
	}
	
	return -1;
}



function appendstr(str)
{
	return str;
}
function showlistcontrol(UserDevicesInfo)
{
	var outputlist = "";
	var RecordCount = UserDevicesInfo.length;
	
	if( 0 == RecordCount )
	{
		outputlist = outputlist + appendstr("<tr class=\"tabal_01 align_center\">");
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr("</tr>");

		$("#devlist").append(outputlist);
		return;
	}

	for(var i = 0; i < RecordCount; i++)   
	{
		if (UserDevicesInfo[i].Port.toUpperCase().indexOf("SSID") >=0)
		{	
			var ssidindex = UserDevicesInfo[i].Port;	
			ssidindex = ssidindex.charAt(ssidindex.length-1);
			if (1 == isSsidForIsp(ssidindex) || 1 == IsRDSGatewayUserSsid(ssidindex))
			{
				continue;
			}
		}
		
		var hostport = '';
		if( "LAN0" == UserDevicesInfo[i].Port.toUpperCase() || "SSID0" == UserDevicesInfo[i].Port.toUpperCase())
		{
			hostport = "--";
		}
		else
		{
			hostport = UserDevicesInfo[i].Port.toUpperCase();
		}
		
		outputlist = outputlist + appendstr("<tr class=\"tabal_01 align_center\" >");
		if(('--' == UserDevicesInfo[i].HostName) && ("1" == GetCfgMode().TELMEX))
		{
		    outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+ htmlencode(UserDevicesInfo[i].MacAddr) +'</td>');
		}
		else
		{
		    outputlist = outputlist + appendstr('<td class="width_per15" title="' + htmlencode(UserDevicesInfo[i].HostName) + '" nowrap>'+GetStringContent(UserDevicesInfo[i].HostName, MAX_HOST_TYPE) +'</td>');
		}
		
		
		outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+htmlencode(UserDevicesInfo[i].IpAddr)+'</td>');
		outputlist = outputlist + appendstr('<td class="width_per15" nowrap>'+htmlencode(UserDevicesInfo[i].MacAddr)+'</td>');
		outputlist = outputlist + appendstr('<td class="width_per5" nowrap>'+userdevinfo_language[UserDevicesInfo[i].DevStatus] +'</td>');		
		outputlist = outputlist + appendstr('<td class="width_per5" nowrap>'+htmlencode(hostport)+'</td>');

		
		var unit_h = (parseInt(UserDevicesInfo[i].Time.split(":")[0],10) > 1) ? userdevinfo_language['bbsp_hours'] : userdevinfo_language['bbsp_hour'];
		var unit_m = (parseInt(UserDevicesInfo[i].Time.split(":")[1],10) > 1) ? userdevinfo_language['bbsp_mins'] : userdevinfo_language['bbsp_min'];
		var time = '';
		if ('ONLINE' != UserDevicesInfo[i].DevStatus.toUpperCase())
		{
			time = '--';
		}
		else
		{
			time = UserDevicesInfo[i].Time.split(":")[0] + unit_h + UserDevicesInfo[i].Time.split(":")[1] + unit_m;
		}		
		outputlist = outputlist + appendstr('<td class="width_per20" nowrap>'+htmlencode(time) +'</td>');
		
		var leasetime = '';
		if ('DHCP' == UserDevicesInfo[i].IpType)
		{
			var remainleasetime = GetRemainLeaseTime(UserDevicesInfo[i].IpAddr, UserDevicesInfo[i].MacAddr);
			if (remainleasetime > 0)
			{
				leasetime = remainleasetime + userdevinfo_language['bbsp_second'];
			}
			else
			{
				leasetime = '--';
			}
		}
		else
		{
			leasetime = '--';
		}				
		outputlist = outputlist + appendstr('<td class="width_per10" nowrap>'+htmlencode(leasetime)  +'</td>');
	}

	$("#devlist").append(outputlist);
}

function SortDevByIP(devlist, num)
{
	if (num < 2)
	{
		return devlist;
	}
	
	var IpList = new Array();
	var InstList = new Array();
	var DevNewList = new Array();
	for(var i = 0; i < num; i++)
	{
		IpList[i] = devlist[i].IpAddr;
		InstList[i] = devlist[i].instid;
	}  
	
	for(var j = 0; j < num - 1; j++)   
	{
		for(var i = 0; i < num - 1 - j; i++)
		{
			var ip1 = IpAddress2DecNum(IpList[i]);
			var ip2 = IpAddress2DecNum(IpList[i+1]);
			var temp = '';
			if (ip1 > ip2)
			{
				temp = InstList[i];
				InstList[i] = InstList[i+1];
				InstList[i+1] = temp;
			}
		}   
	}
	
	for(var i = 0; i < num; i++)
	{
		for(var j = 0; j < num; j++)
		{
			if (InstList[i] == devlist[j].instid)
			{
				DevNewList.push(devlist[j]);
			}
		}
	}
	
	return DevNewList;
}

function SortUserDevice(UserDevicesInfo)
{
	if (0 == RecordCount)
	{
		return UserDevicesInfo;
	}
	
	var List1 = new Array();
	var List2 = new Array();
	var DevOnlineList = new Array();
	var DevOfflineList = new Array();
	var UserDevNewList = new Array();
	var RecordCount = UserDevicesInfo.length - 1;
	var OnlineNum = 0;
	var OfflineNum = 0;
	
	for(var i = 0; i < RecordCount; i++)   
	{
		if ('ONLINE' == UserDevicesInfo[i].DevStatus.toUpperCase())
		{
			List1.push(UserDevicesInfo[i]);
			OnlineNum++;
		}
		else
		{
			List2.push(UserDevicesInfo[i]);
			OfflineNum++;
		}
	}
	
	DevOnlineList = SortDevByIP(List1,OnlineNum);
	DevOfflineList = SortDevByIP(List2,OfflineNum);
	
	if ((0 == OnlineNum) && (0 < OfflineNum))
	{
		return DevOfflineList;
	}	
	else if ((0 == OfflineNum) && (0 < OnlineNum))
	{
		return DevOnlineList;
	}
	else
	{
		for(var i = 0; i < OnlineNum; i++)
		{
			UserDevNewList.push(DevOnlineList[i]);
		}		
		for(var j = 0; j < OfflineNum; j++)
		{
			UserDevNewList.push(DevOfflineList[j]);
		}
		return UserDevNewList;
	}
}
</script>
<script> 
	 ParseBindTextByTagName(userdevinfo_language, "td",    1);
	 ParseBindTextByTagName(DevInfoDes, "td",   1);
	 ParseBindTextByTagName(waninfo_language, "td",   1);
    GetLanUserInfo(function(para1, para2)
	{
		UserDevicesTemp = para2;
		UserDevices = SortUserDevice(UserDevicesTemp);	
		DHCPLeaseTimes = para1;
		showlistcontrol(UserDevices);
	});
	
</script> 
</div>
</body>
</html>

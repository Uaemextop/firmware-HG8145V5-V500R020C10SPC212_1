<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link href="Cuscss/<%HW_WEB_GetCusSource(infopage.css);%>" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(jsdiff.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="/html/bbsp/common/managemode.asp"></script>
<script language="JavaScript" src="/html/ssmp/deviceinfo/deviceinfo.cus"></script>
<script language="javascript" src="/html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list.asp"></script>
<script language="javascript" src="/html/bbsp/common/ontstate.asp"></script> 
<script language="javascript" src="/html/bbsp/common/wanaddressacquire.asp"></script> 
<script>
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
var SingtelMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SINGTEL);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var TELMEX = false;
var IPv4VendorId="--"
var PackageList =  "";
var ponPackage = "";

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

if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
	PackageList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetPonPackageStat, InternetGatewayDevice.WANDevice.{i}.X_HW_PonInterface.Stats,PacketsSent|PacketsReceived,PONPackageInfo);%>;
	ponPackage = PackageList[0];
}
else
{
	TELMEX = false;
}

var MainDhcpRange = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaMainDhcpPool,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|X_HW_DNSList,dhcpmainst);%>;
var dhcpmain = MainDhcpRange[0];
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var LanHostInfo = LanHostInfos[0];
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curCfgMode ='<%HW_WEB_GetCfgMode();%>';
function IsRDSGatewayUser()
{
	if('RDSGATEWAY' == curCfgMode.toUpperCase() && curUserType != sysUserType)
	{
		return true;
	}
	else
	{
		return false;
	}
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
var IsPTVDF = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_PTVDF);%>';

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

	var cnt = GetRandCnt();
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
		<div class="log_img" style=" width: 320px;height: 95px; float: left;">
			<img style="width:320px; height:95px;" src="../../../images/globe_logo.jpg"/>
		</div>
		<div  id="onauthinfo" style="float:right; height:40px; margin-top: 30px;">
			<input type="button" id="refreshpage"  class="ApplyButtoncss buttonwidth_100px"  onClick="refreshpage();"   value="Refresh">
			<input type="button" id="showlogininfo" class="CancleButtonCss buttonwidth_100px" onClick="showlogininfo();" value="Setup">
		</div>
	</div>
	<div style="clear:both; clear: both; width: 100%; border: 2px solid #A5A4A4; box-shadow: 1px 3px 7px #B3B3B3; margin-bottom: 20px; display: inline-block;"></div>

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

	<table id="ont_device_info">
		<tr> 
			<td class="tabal_head" colspan="11" style="font-size:16px;">Device Info</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="deviceinfo_table" name="deviceinfo_table">
		<tr> 
			<td class="table_title width_diff11" id="td1_1" BindText="s0202"></td> 
			<td class="table_right" id="td1_2">
			<script language="javascript">
			document.write(deviceInfo.ModelName);
			</script> 
		</td> 
	</tr>

	<tr id="tr2"> 
		<td  class="table_title" id="td2_1" BindText="s0203"></td> 
		<td class="table_right align_left" id="td2_2" dir="ltr">
			<script language="javascript">
			document.write(deviceInfo.Description);
			</script> 
		</td> 
	</tr> 

	<tr id="tr4"> 
		<td  class="table_title" id="td4_1" BindText="s0204"></td> 
		<td class="table_right" id="td4_2"> 
			<script language="javascript">
			document.write(deviceInfo.HardwareVersion);
			</script> 
		</td> 
	</tr> 

	<tr  id="tr5"> 
	<td class="table_title" id="td5_1" BindText="s0205"></td> 
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
	<td class="table_title" id="td6_1" BindText="s0217"></td> 
	<td class="table_right" id="td6_2"> <script language="javascript">
	document.write(deviceInfo.ManufactureInfo);
	</script> </td> 
	</tr> 

	<tr id="ShowCpuInfo">
	<td class="table_title" id="td9_1" BindText="s0208"></td>
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
	<td class="table_title" id="td10_1" BindText="s0209"></td>
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
	<td class="table_title" id="td10_1" BindText="s020e"></td>
	<td class="table_right" id="ShowTime">
	</td>
	</tr>

	<tr id="ShowCustomizeDes">
	<td class="table_title" id="td13_1" BindText="s0225"></td>
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
	<td class="table_title" id="td14_1" BindText="s0226"></td>
	<td class="table_right" id="td14_2"></td>
	</tr>
	<tr id="Ipv4PPPUpTime">
	<td class="table_title" id="td15_1" BindText="s0229"></td>
	<td class="table_right" id="td15_2">
	<script type="text/javascript" language="javascript">
	setDisplay('Ipv4PPPUpTime', 0);
	if('GLOBE' == CfgMode.toUpperCase())
	{
		setDisplay('Ipv4PPPUpTime', 1);
		PPPOnlineTimeShow();
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
<td class="table_title">IP Address:</td> 
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

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-top:8px;"> 
<tr><td class="func_title" style="padding-bottom:2px;">Connected Clients</td></tr>
</table>  

<table class="tabal_bg width_per100"  cellspacing="1" id="IPv4Panel">
  <tr class="head_title">
   <script type="text/javascript" language="javascript">
		if (false == IsRDSGatewayUser())
		{
			document.write('<td>'+waninfo_language['bbsp_wanname']+'</td>');
		}
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



	function DisplayIPv4WanDetail(WanIndex)
	{
		var CurrentWan = GetWanList()[WanIndex];
		document.getElementById("WanDetail").style.display = "";
		setDisplay("ipv4InformationForm",1);
		
		if (GetCfgMode().BJUNICOM == "1")
		{
			CurrentWan.MACAddress = ConvertMac(CurrentWan.MACAddress);
		}
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
				
				if('GLOBE' == curCfgMode.toUpperCase())
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

		document.write('<TR id="record_' + i + '" class="tabal_01" align="center">');
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
				document.write("<td align='center'><a style='color:blue' onclick = 'OnConnectionControlButton(this,"+i+","+ctrFlag+")' RecordId = '"+i+"' href='#'>"+btText+"</a></td>");
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
		document.write("</tr>");
	}
	</script>
</table>



<table width="100%" height="5"> 
<tr> 
<td><input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td> 
</tr> 
</table> 


<script type="text/javascript">
var deviceTable = document.getElementById("deviceinfo_table");	
if (deviceTable != null)
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i < all.length; i++)
	{
		var b = all[i];
		var c = b.getAttribute("BindText");
		if(c == null)
		{
			continue;
		}
		b.innerHTML = DevInfoDes[c];
	}
}
	
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

function DSLInfo(domain,Status,UpstreamCurrRate,DownstreamCurrRate,UpstreamMaxRate,DownstreamMaxRate,UpstreamNoiseMargin,DownstreamNoiseMargin,StandardUsed,UpstreamAttenuation,DownstreamAttenuation,UpstreamPower,DownstreamPower,ShowtimeStart)
{
	this.domain   = domain;
    this.Status					=	Status;
	this.UpstreamCurrRate		=	UpstreamCurrRate;
	this.DownstreamCurrRate		=	DownstreamCurrRate;
	this.UpstreamMaxRate		=	UpstreamMaxRate;
	this.DownstreamMaxRate		=	DownstreamMaxRate;
	this.UpstreamNoiseMargin	=	convertDBData(UpstreamNoiseMargin);
	this.DownstreamNoiseMargin	=	convertDBData(DownstreamNoiseMargin);
	this.StandardUsed			=	StandardUsed;
	this.UpstreamAttenuation	=	convertDBData(UpstreamAttenuation);
	this.DownstreamAttenuation	=	convertDBData(DownstreamAttenuation);
	this.UpstreamPower			=	convertDBData(UpstreamPower);
	this.DownstreamPower		=	convertDBData(DownstreamPower);
	this.ShowtimeStart			=	ShowtimeStart;
}

var DSLInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANDSLInterfaceConfig,Status|UpstreamCurrRate|DownstreamCurrRate|UpstreamMaxRate|DownstreamMaxRate|UpstreamNoiseMargin|DownstreamNoiseMargin|StandardUsed|UpstreamAttenuation|DownstreamAttenuation|UpstreamPower|DownstreamPower|ShowtimeStart,DSLInfo);%>;

function SetUpSyncStatus()
{
	var status = GetLanguageDesc("sDSL_unknown");
    if ("Up" == DSLInfos[0].Status) 
    {
        status = GetLanguageDesc("sDSL_up");
    } 
    else if ("NoSignal" == DSLInfos[0].Status) 
    {
        status = GetLanguageDesc("sDSL_nosignal");
    } 
    else if ("Initializing" == DSLInfos[0].Status) 
    {
        status = GetLanguageDesc("sDSL_init");
    } 
    else if ("EstablishingLink" == DSLInfos[0].Status) 
    {
        status = GetLanguageDesc("sDSL_establish");
    }
       
	document.getElementById('dsltd_1').innerHTML = htmlencode(status);
}

function SetUpConnStatus()
{
	var connStatus = "";
	if (DSLInfos[0].Status=="Up")
	{
		connStatus = GetLanguageDesc("sDSL_showtime");
	}
	else
	{
		connStatus = GetLanguageDesc("sDSL_idle");	
	}
	document.getElementById('dsltd_2').innerHTML = htmlencode(connStatus);
}

function SetUpDSLShowTime()
{
	var second = parseInt(DSLInfos[0].ShowtimeStart);
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
	
	document.getElementById('dsltd_14').innerHTML = htmlencode(strtime);
}

</script>

<table id="ont_device_info">
    <tr> 
        <td class="tabal_head" colspan="11" style="font-size:16px;">DSL Information</td>
    </tr>
</table>
<form id="DslInfoForm" name="DslInfoForm">
<table id="DslFormPanel" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="deviceinfo_table" name="deviceinfo_table" style="padding:0;">
<li id="dsltd_1" RealType="HtmlText" DescRef="sDSL1000" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_1" InitValue="Empty" />
<li id="dsltd_2" RealType="HtmlText" DescRef="sDSL1001" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_2" InitValue="Empty" />
<li id="dsltd_3" RealType="HtmlText" DescRef="sDSL1002" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_3" InitValue="Empty" />
<li id="dsltd_4" RealType="HtmlText" DescRef="sDSL1003" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_4" InitValue="Empty" />
<li id="dsltd_5" RealType="HtmlText" DescRef="sDSL1004" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_5" InitValue="Empty" />
<li id="dsltd_6" RealType="HtmlText" DescRef="sDSL1005" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_6" InitValue="Empty" />
<li id="dsltd_7" RealType="HtmlText" DescRef="sDSL1006" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_7" InitValue="Empty" />
<li id="dsltd_8" RealType="HtmlText" DescRef="sDSL1007" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_8" InitValue="Empty" />
<li id="dsltd_9" RealType="HtmlText" DescRef="sDSL1008" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_9" InitValue="Empty" />
<li id="dsltd_10" RealType="HtmlText" DescRef="sDSL1009" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_10" InitValue="Empty" />
<li id="dsltd_11" RealType="HtmlText" DescRef="sDSL1010" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_11" InitValue="Empty" />
<li id="dsltd_12" RealType="HtmlText" DescRef="sDSL1011" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_12" InitValue="Empty" />
<li id="dsltd_13" RealType="HtmlText" DescRef="sDSL1012" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_13" InitValue="Empty" />
<li id="dsltd_14" RealType="HtmlText" DescRef="sDSL1013" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="dsltd_14" InitValue="Empty" />
</table>
<script>
var TableClass = new stTableClass("table_title width_per40", "table_right align_left","ltr");

HWParsePageControlByID("DslInfoForm",TableClass,DevInfoDes,null);
SetUpSyncStatus();
SetUpConnStatus();
document.getElementById('dsltd_3').innerHTML = htmlencode(DSLInfos[0].UpstreamCurrRate);
document.getElementById('dsltd_4').innerHTML = htmlencode(DSLInfos[0].DownstreamCurrRate);
document.getElementById('dsltd_5').innerHTML = htmlencode(DSLInfos[0].UpstreamMaxRate);
document.getElementById('dsltd_6').innerHTML = htmlencode(DSLInfos[0].DownstreamMaxRate);
document.getElementById('dsltd_7').innerHTML = htmlencode(DSLInfos[0].UpstreamNoiseMargin);
document.getElementById('dsltd_8').innerHTML = htmlencode(DSLInfos[0].DownstreamNoiseMargin);
document.getElementById('dsltd_9').innerHTML = htmlencode(DSLInfos[0].StandardUsed);
document.getElementById('dsltd_10').innerHTML = htmlencode(DSLInfos[0].UpstreamAttenuation);
document.getElementById('dsltd_11').innerHTML = htmlencode(DSLInfos[0].DownstreamAttenuation);
document.getElementById('dsltd_12').innerHTML = htmlencode(DSLInfos[0].UpstreamPower);
document.getElementById('dsltd_13').innerHTML = htmlencode(DSLInfos[0].DownstreamPower);
SetUpDSLShowTime();
</script>
<script language="JavaScript" type="text/javascript">


function GetLanguageDesc(Name)
{
	return DevInfoDes[Name];
}
</script>
</form>
</body>
</html>

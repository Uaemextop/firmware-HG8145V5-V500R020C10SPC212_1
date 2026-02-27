<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title></title>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("softgretitle", GetDescFormArrayById(softgre_language, "bbsp_title"), GetDescFormArrayById(softgre_language, "bbsp_gre_title"), false);
</script> 

<script language="javascript">
var GreTunelList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_GRETunnel.{i},Enable|RemoteAddress|X_HW_KeepaliveIntervals|X_HW_RetryIntervals|EgressInterface,GreTunelItem);%>; 
var IngressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_GRETunnel.1.IngressInterface.{i},VLANID,IngressItem);%>;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var IsTedata = '<%HW_WEB_GetFeatureSupport(HW_FT_FEATURE_DTEDATA);%>';

function stIspSsid(domain, SSID_IDX,UpRateLimit,DownRateLimit,SSID)
{
    this.domain = domain;
    this.SSID_IDX = SSID_IDX;
	this.UpRateLimit = UpRateLimit;
	this.DownRateLimit = DownRateLimit;
	this.SSID = SSID;
}

var IspSsidList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i}, SSID_IDX|UpRateLimit|DownRateLimit|SSID, stIspSsid);%>;

function stWlan(domain,name,enable,ssid,wlHide,DeviceNum,wmmEnable,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,WPARekey,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable, LowerLayers,
                X_HW_WAPIEncryptionModes,X_HW_WAPIAuthenticationMode,X_HW_WAPIServer,X_HW_WAPIPort, X_HW_WPSConfigurated, UAPSDEnable, IsolationEnable,SecondaryRadiusServerIPAddr,SecondaryRadiusServerPort)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.wlHide = wlHide;
    this.DeviceNum = DeviceNum;
    this.wmmEnable = wmmEnable;
    this.BeaconType = BeaconType;
    this.BasicEncryptionModes = BasicEncryptionModes;
    this.BasicAuthenticationMode = BasicAuthenticationMode;
    this.KeyIndex = KeyIndex;
    this.EncypBit = EncryptionLevel;
    this.WPAEncryptionModes = WPAEncryptionModes;
    this.WPAAuthenticationMode = WPAAuthenticationMode;
    this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
    this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
    this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;
    this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
    this.WPARekey = WPARekey;
    this.RadiusServer = RadiusServer;
    this.RadiusPort = RadiusPort;
    this.RadiusKey = RadiusKey;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.LowerLayers = LowerLayers;
    this.X_HW_WAPIEncryptionModes = X_HW_WAPIEncryptionModes;
    this.X_HW_WAPIAuthenticationMode = X_HW_WAPIAuthenticationMode;
    this.X_HW_WAPIServer = X_HW_WAPIServer;
    this.X_HW_WAPIPort = X_HW_WAPIPort;
    this.X_HW_WPSConfigurated = X_HW_WPSConfigurated;
    this.UAPSDEnable = UAPSDEnable;
    this.IsolationEnable = IsolationEnable;
	this.SecondaryRadiusServerIPAddr = SecondaryRadiusServerIPAddr;
    this.SecondaryRadiusServerPort = SecondaryRadiusServerPort;
}

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable|LowerLayers|X_HW_WAPIEncryptionModes|X_HW_WAPIAuthenticationMode|X_HW_WAPIServer|X_HW_WAPIPort|X_HW_WPSConfigurated|UAPSDEnable|IsolationEnable|SecondaryRadiusServerIPAddr|SecondaryRadiusServerPort,stWlan);%>;

var Wlan = new Array();

var wlanArrLen = WlanArr.length - 1;
for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

function IsIspSsid(wlanInst)
{
    for (var i = 0; i < IspSsidList.length - 1; i++)
    {
        if (wlanInst == IspSsidList[i].SSID_IDX)
        {
            return true;        
        }
    }

    return false;
}

function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.substr(domain.lastIndexOf('.') + 1));
    }
}


function IsWlanInstExist(wlaninst)
{
	for (var loop = 0; loop < Wlan.length; loop++)
	{
		if(wlaninst == getInstIdByDomain(Wlan[loop].domain))
		{
			return true;  
		}
	}
	return false;  
}

function GetWlanInfo(wlaninst)
{
	for (var loop = 0; loop < Wlan.length; loop++)
	{
		if(wlaninst == getInstIdByDomain(Wlan[loop].domain))
		{
			return loop;  
		}
	}
}

function SetFreeSSID(wlaninst)
{
	var loop;
	var radio = "2G";
	
	if(wlaninst > 4)
	{
		radio = "5G";
	}
	
	if((true == IsIspSsid(wlaninst)) &&(true ==  IsWlanInstExist(wlaninst)))
	{
		loop = GetWlanInfo(wlaninst);
		setCheck('FreeEnable'+radio,Wlan[loop].enable);
		setText("FreeSsid"+radio, Wlan[loop].ssid);
	}
	else
	{
		setCheck('FreeEnable'+radio,0);
		setText("FreeSsid"+radio, "");
	}
}

function SetEAPSSID(wlaninst)
{
	var loop;
	var radio = "2G";
	
	if(wlaninst > 4)
	{
		radio = "5G";
	}
	
	if((true == IsIspSsid(wlaninst)) &&(true ==  IsWlanInstExist(wlaninst)))
	{
		loop = GetWlanInfo(wlaninst);
		setCheck('EAPEnable'+radio,Wlan[loop].enable);
		setText("EAPSsid"+radio, Wlan[loop].ssid);
		setText("RadiusIP1"+radio, Wlan[loop].RadiusServer);
		setText("RadiusPort1"+radio, Wlan[loop].RadiusPort);
		setText("RadiusIP2"+radio, Wlan[loop].SecondaryRadiusServerIPAddr);
		setText("RadiusPort2"+radio, Wlan[loop].SecondaryRadiusServerPort);
	}
	else
	{
		setCheck('EAPEnable'+radio,0);
		setText("EAPSsid"+radio, "");
		setText("RadiusIP1"+radio, "");
		setText("RadiusPort1"+radio, "");
		setText("RadiusIP2"+radio, "");
		setText("RadiusPort2"+radio, "");
	}
}

function DteDataCustomize()
{
	if ('DTEDATA2WIFI' != CfgMode.toUpperCase())
	{
		return;
	}
	
	setDisable("FreeEnable2G", 1);
	setDisable("FreeSsid2G", 1);
	setDisable('EAPEnable2G',1);
	setDisable("EAPSsid2G", 1);
	setDisable("RadiusIP12G", 1);
	setDisable("RadiusPort12G",1);
	setDisable("RadiusIP22G", 1);
	setDisable("RadiusPort22G",1);
	
	setDisable("FreeEnable5G", 1);
	setDisable("FreeSsid5G", 1);
	setDisable('EAPEnable5G',1);
	setDisable("EAPSsid5G", 1);
	setDisable("RadiusIP15G", 1);
	setDisable("RadiusPort15G",1);
	setDisable("RadiusIP25G", 1);
	setDisable("RadiusPort25G",1);
	
	setDisable("FreeVlanId2G", 1);
	setDisable("EAPVlanId2G",1);
	setDisable("FreeVlanId5G", 1);
	setDisable("EAPVlanId5G",1);
}

function SetWlanInfo()
{
	SetFreeSSID(3);
	SetEAPSSID(4);
	SetFreeSSID(7);
	SetEAPSSID(8);	
}

function GreTunelItem(_Domain, _Enable, _RemoteAddress, _KeepAliveIntervals, _RetryIntervals, _EgressInterface)
{
	this.Domain = _Domain;
	this.Enable = _Enable;
	var remoteAdrList = _RemoteAddress.split(",");
	if (remoteAdrList.length >= 2)
	{
		this.WlanGateWay = remoteAdrList[0];
		this.WlanGateWayBackup = remoteAdrList[1];
	}
	else
	{
		this.WlanGateWay = remoteAdrList[0];
		this.WlanGateWayBackup = "";
	}
	
    this.KeepAliveIntervals = _KeepAliveIntervals;
    this.RetryIntervals = _RetryIntervals;
	this.EgressInterface = _EgressInterface;
}

function IngressItem(domain, VLANID)
{
	this.domain = domain;
	this.VLANID = VLANID;
}

function GetWanInfoByDomain(Domain)
{
	for (var i = 0; i < WanList.length;i++)
    {
	    if (WanList[i].domain == Domain)
		{
			return (domainTowanname(WanList[i].domain));
		}
    }
	
    return Domain;
}

function SetGREInfo() {

	var GreTunel = new Array();
	var Ingress = new Array();
	if (GreTunelList == undefined || GreTunelList == "")
	{
		GreTunel.Enable = 0;
		GreTunel.WlanGateWay = "";
		GreTunel.WlanGateWayBackup = "";
		GreTunel.KeepAliveIntervals = "";
		GreTunel.RetryIntervals = "";
		GreTunel.EgressInterface = "";
	}
	else
	{
		GreTunel.Enable = GreTunelList[0].Enable;
		GreTunel.WlanGateWay = GreTunelList[0].WlanGateWay;
		GreTunel.WlanGateWayBackup = GreTunelList[0].WlanGateWayBackup;
		GreTunel.KeepAliveIntervals = GreTunelList[0].KeepAliveIntervals;
		GreTunel.RetryIntervals = GreTunelList[0].RetryIntervals;
		GreTunel.EgressInterface = GreTunelList[0].EgressInterface;
	}

	if (IngressList == undefined || IngressList == "")
	{
		Ingress.vlan3 = "";
		Ingress.vlan4 = "";
		Ingress.vlan7 = "";
		Ingress.vlan8 = "";
	}
	else
	{
		Ingress.vlan3 = IngressList[0].VLANID;
		Ingress.vlan4 = IngressList[1].VLANID;
		Ingress.vlan7 = IngressList[2].VLANID;
		Ingress.vlan8 = IngressList[3].VLANID;
	}
	
	var waninfo = GetWanInfoByDomain(GreTunel.EgressInterface);

	setCheck("VlanSwitch", GreTunel.Enable);
	setText("WlanGateWay", GreTunel.WlanGateWay);
	setText("WlanGateWayBackup", GreTunel.WlanGateWayBackup);
	setText("KeepAliveIntervals", GreTunel.KeepAliveIntervals);
	setText("RetryIntervals", GreTunel.RetryIntervals);
	setText("FreeVlanId2G", Ingress.vlan3);
	setText("EAPVlanId2G", Ingress.vlan4);
	setText("FreeVlanId5G", Ingress.vlan7);
	setText("EAPVlanId5G", Ingress.vlan8);
	
	if (waninfo == "")
	{
		setSelect("EgressInterface", "");
	}
	else
	{
		setSelect("EgressInterface", waninfo);
	}
}

function GetEnableString(Enable)
{
    if (Enable == 1 || Enable == "1")
    {
        return softgre_language['bbsp_enable'];
    }
    return softgre_language['bbsp_disable'];
}

function CheckWanOkFunction(item)
{
	if (IsTedata == 1)
	{
		var AtmGreWan = "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.4.WANPPPConnection.1";
		var GeGreWan = "InternetGatewayDevice.WANDevice.3.WANConnectionDevice.1.WANPPPConnection.2";
		var PtmGreWan = "InternetGatewayDevice.WANDevice.2.WANConnectionDevice.1.WANPPPConnection.2";
		if (item.domain == AtmGreWan || item.domain == GeGreWan || item.domain == PtmGreWan)
		{
			return true;
		}
	}
	else
	{
		if (item.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
		{
			return false;
		}
		
		if (item.ServiceList.toUpperCase().indexOf("INTERNET") >= 0)
		{
			return true;
		}
		if (item.ServiceList.toUpperCase().indexOf("IPTV") >= 0)
		{
			return true;
		}
	}
	return false;
}

function InitWanListControlWanname(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
	
	var Option = document.createElement("Option");
	Option.value = "";
	Option.innerText = "Auto";
	Option.text = "Auto";
	Control.appendChild(Option);

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}

function LoadFrame()
{
	InitWanListControlWanname("EgressInterface", CheckWanOkFunction);
	SetGREInfo();
	SetWlanInfo();
	
	if ('DTEDATA2WIFI' == CfgMode.toUpperCase())
	{
		setDisable("VlanSwitch", 1);
		setDisable("WlanGateWay", 1);
		setDisable("WlanGateWayBackup", 1);
		setDisable("KeepAliveIntervals", 1);
		setDisable("RetryIntervals", 1);
		setDisable("EgressInterface", 1);
		setDisplay("table_button", 0);
	}
	else 
	{
		setDisable("VlanSwitch", 0);
		setDisable("WlanGateWay", 0);
		setDisable("WlanGateWayBackup", 0);
		setDisable("KeepAliveIntervals", 0);
		setDisable("RetryIntervals", 0);
		setDisable("EgressInterface", 0);
		setDisplay("table_button", 1);
	}
	
	DteDataCustomize();
}

function WlanForm()
{
	Form.addParameter('y3.Enable', getValue("FreeEnable2G"));
	Form.addParameter('y3.SSID', getValue("FreeSsid2G"));
	Form.addParameter('y4.Enable', getValue("EAPEnable2G"));
	Form.addParameter('y4.SSID', getValue("EAPSsid2G"));
	Form.addParameter('y4.RadiusServer', getValue("RadiusIP12G"));
	Form.addParameter('y4.RadiusPort', getValue("RadiusPort12G"));
	Form.addParameter('y4.SecondaryRadiusServerIPAddr', getValue("RadiusIP22G"));
	Form.addParameter('y4.SecondaryRadiusServerPort', getValue("RadiusPort22G"));
	Form.addParameter('y7.Enable', getValue("FreeEnable5G"));
	Form.addParameter('y7.SSID', getValue("FreeSsid5G"));
	Form.addParameter('y8.Enable', getValue("EAPEnable5G"));
	Form.addParameter('y8.SSID', getValue("EAPSsid5G"));
	Form.addParameter('y8.RadiusServer', getValue("RadiusIP15G"));
	Form.addParameter('y8.RadiusPort', getValue("RadiusPort15G"));
	Form.addParameter('y8.SecondaryRadiusServerIPAddr', getValue("RadiusIP25G"));
	Form.addParameter('y8.SecondaryRadiusServerPort', getValue("RadiusPort25G"));
}

function OnApply()
{
	var Form = new webSubmitForm();
	var RequestFile = "html/bbsp/softgre/softgre.asp";
	var  waninterface = "";
	var WlanGateWayBackup = getValue("WlanGateWayBackup");
	var waninfo = GetWanInfoByWanName(getValue("EgressInterface"));
	if (undefined != waninfo.domain)
	{
		waninterface  = waninfo.domain;
	}
	
	Form.addParameter('x.Enable', getCheckVal("VlanSwitch"));

	if (WlanGateWayBackup != "")
	{
		Form.addParameter('x.RemoteAddress', getValue("WlanGateWay")+","+getValue("WlanGateWayBackup"));
	}
	else
	{
		Form.addParameter('x.RemoteAddress', getValue("WlanGateWay"));
	}
	Form.addParameter('x.KeepAliveIntervals', getValue("KeepAliveIntervals"));
	Form.addParameter('x.RetryIntervals', getValue("RetryIntervals"));
	Form.addParameter('x.EgressInterface', waninterface);
	
	WlanForm();
	
	WlanUrl = '&y3=InternetGatewayDevice.LANDevice.1.WLANConfiguration.3'+
			  '&y4=InternetGatewayDevice.LANDevice.1.WLANConfiguration.4'+
			  '&y7=InternetGatewayDevice.LANDevice.1.WLANConfiguration.7'+
			  '&y8=InternetGatewayDevice.LANDevice.1.WLANConfiguration.8';
	
	url = 'set.cgi?x=InternetGatewayDevice.X_HW_GRETunnel.1'
		+ WlanUrl +'&RequestFile=' + RequestFile;
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	setDisable('Apply',1);
	Form.setAction(url);
	Form.submit();
}

function OnCancel()
{
	SetGREInfo();
	SetWlanInfo();
}

</script> 

<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
</script>

<form id="TableConfigInfo"> 
	<div class="list_table_spread"></div>
	<div id="GreTunelTitle" class="func_title" BindText="FONConfiguration"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="VlanSwitch" 			RealType="CheckBox" 		DescRef="Enable" 				RemarkRef="Empty" 	ErrorMsgRef="Empty" 	Require="FALSE" 	BindField="x.Enable" 	InitValue="Empty" />
		<li   id="WlanGateWay" 			RealType="TextBox" 			DescRef="WlanGateWay"  			RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField="x.WlanGateWay"  			Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="WlanGateWayBackup" 	RealType="TextBox" 			DescRef="WlanGateWayBackup"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField="x.WlanGateWayBackup"  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="KeepAliveIntervals" 	RealType="TextBox" 			DescRef="KeepAliveIntervals"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField="x.KeepAliveIntervals"  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RetryIntervals" 		RealType="TextBox" 			DescRef="RetryIntervals"  		RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField="x.RetryIntervals"  		Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="EgressInterface"   	RealType="DropDownList"   	DescRef="EgressInterface"  		RemarkRef="Empty"  	ErrorMsgRef="Empty"  	Require="FALSE" 	BindField="x.EgressInterface" 		Elementclass="width_254px"  InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		var formid_hide_id = null;
		HWParsePageControlByID("TableConfigInfo", TableClass, softgre_language, formid_hide_id);
	</script>
</form> 
<form id="free2G">
	<div class="list_table_spread"></div>
	<div id="FrequencyBand2G" class="func_title" BindText="FrequencyBand2G"></div>
	<div id="FonFreeSsidSettings" class="func_title" BindText="FonFreeSsidSettings"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="FreeEnable2G" 			RealType="CheckBox" 		DescRef="EnableSsid" 				RemarkRef="Empty" 	ErrorMsgRef="Empty" 	Require="FALSE" 	BindField="" 	InitValue="Empty" />
		<li   id="FreeSsid2G" 			RealType="TextBox" 			DescRef="FreeSsid"  			RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  			Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="FreeVlanId2G" 	        RealType="TextBox" 			DescRef="VlanId"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("free2G", null);
		var formid_hide_id = null;
		HWParsePageControlByID("free2G", TableClass, softgre_language, formid_hide_id);
	</script>	
</form>
<form id="eap2G">
	<div id="FonEAPSsidSettings" class="func_title" BindText="FonEAPSsidSettings"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="EAPEnable2G" 			RealType="CheckBox" 		DescRef="EnableSsid" 				RemarkRef="Empty" 	ErrorMsgRef="Empty" 	Require="FALSE" 	BindField="" 	InitValue="Empty" />
		<li   id="EAPSsid2G" 			RealType="TextBox" 			DescRef="FreeSsid"  			RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  			Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="EAPVlanId2G" 			RealType="TextBox" 			DescRef="VlanId"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusIP12G" 			RealType="TextBox" 			DescRef="RadiusIP1"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusPort12G" 			RealType="TextBox" 			DescRef="RadiusPort1"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusIP22G" 			RealType="TextBox" 			DescRef="RadiusIP2"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusPort22G" 			RealType="TextBox" 			DescRef="RadiusPort2"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("eap2G", null);
		var formid_hide_id = null;
		HWParsePageControlByID("eap2G", TableClass, softgre_language, formid_hide_id);
	</script>
</form>
<form id="free5G">
	<div class="list_table_spread"></div>
	<div id="FrequencyBand5G" class="func_title" BindText="FrequencyBand5G"></div>
	<div id="FonFreeSsidSettings" class="func_title" BindText="FonFreeSsidSettings"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="FreeEnable5G" 			RealType="CheckBox" 		DescRef="EnableSsid" 				RemarkRef="Empty" 	ErrorMsgRef="Empty" 	Require="FALSE" 	BindField="" 	InitValue="Empty" />
		<li   id="FreeSsid5G" 			RealType="TextBox" 			DescRef="FreeSsid"  			RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  			Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="FreeVlanId5G" 	        RealType="TextBox" 			DescRef="VlanId"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("free5G", null);
		var formid_hide_id = null;
		HWParsePageControlByID("free5G", TableClass, softgre_language, formid_hide_id);
	</script>
</form>
<form id="eap5G">
	<div id="FonEAPSsidSettings" class="func_title" BindText="FonEAPSsidSettings"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li   id="EAPEnable5G" 			RealType="CheckBox" 		DescRef="EnableSsid" 				RemarkRef="Empty" 	ErrorMsgRef="Empty" 	Require="FALSE" 	BindField="" 	InitValue="Empty" />
		<li   id="EAPSsid5G" 			RealType="TextBox" 			DescRef="FreeSsid"  			RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  			Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="EAPVlanId5G" 			RealType="TextBox" 			DescRef="VlanId"  		RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusIP15G" 			RealType="TextBox" 			DescRef="RadiusIP1"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusPort15G" 			RealType="TextBox" 			DescRef="RadiusPort1"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusIP25G" 			RealType="TextBox" 			DescRef="RadiusIP2"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RadiusPort25G" 			RealType="TextBox" 			DescRef="RadiusPort2"  	RemarkRef="Empty" 	ErrorMsgRef="Empty"    	Require="FALSE"     BindField=""  	Elementclass="width_254px"  InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("eap5G", null);
		var formid_hide_id = null;
		HWParsePageControlByID("eap5G", TableClass, softgre_language, formid_hide_id);
	</script>
</form>
<table id="table_button" width="100%"  cellspacing="1" class="table_button"> 
  <tr> 
	<td class="width_per15"></td> 
	<td class="table_submit pad_left5p">
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		<button id='Apply' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(softgre_language['bbsp_app']);</script></button>
		<button id='Cancel' type=button onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(softgre_language['bbsp_cancel']);</script></button> 
	</td> 
  </tr> 
</table> 
<script>
ParseBindTextByTagName(softgre_language, "div",   1);
</script> 
</body>
</html>

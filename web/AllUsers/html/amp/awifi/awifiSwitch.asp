<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<title>awifi switch</title>
<script language="JavaScript" type="text/javascript">


var aWiFiSSID2GInst = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AWiFi_SSID.SSID2GINST);%>';



function stWlanWifi(domain, enable, ssid)
{
    this.domain = domain;
    this.enable = enable;
    this.ssid = ssid;
}

var aSsidInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, Enable|SSID, stWlanWifi);%>;

for (i=0; i < aSsidInfo.length; i++)
{
	if(aSsidInfo[i]==null)
	{
		aWiFiInst = i;
		continue;
	}
	else
	{
		if (aSsidInfo[i].ssid.substring(0,5)  =="aWiFi")
		{
			aWiFiInst = i;
			break;
		}
	}
}

var aWifiInfo = aSsidInfo[aWiFiInst];

if (null == aWifiInfo)
{
    aWifiInfo = new stWlanWifi("", "0", "aWiFi-");
}

function stWlan(domain,name,ssid)
{
    this.domain = domain;
    this.name = name;
    this.ssid = ssid;
}

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|SSID,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

var AddFlag = (aWifiInfo.domain  == '') ? true: false;

function getaWiFiSSID(aWiFiSSID)
{
	aWiFiSSID = getValue('fixaWiFi') + getValue('fixLine')+ getValue('inpAwifiSsid');
	return aWiFiSSID;
}


function awifiSwitch()
{ 
	var bSwitch = getCheckVal('ckawifiSwitch');
	
	if(bSwitch)
	{
		setDisable('inpAwifiSsid', 0);
	}
	else
	{
		setDisable('inpAwifiSsid', 1);
	}
	
	setDisable('btnSaveConf', 0);
}



function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.substr(domain.lastIndexOf('.') + 1));    
    }
}


function CheckForm(type)
{   
    with(document.getElementById("tblServer"))
    {     
        var newAwifiName = getaWiFiSSID();  
   
		for (i = 0; i < Wlan.length; i++)
		{
			if (aWiFiSSID2GInst != getInstIdByDomain(Wlan[i].domain))
			{
				if (Wlan[i].ssid == newAwifiName)
				{
					AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
					return false;
				}
				else
				{
					continue;
				}
			}
		}
    }

    return true;
}

function AddSubmitParam(SubmitForm, type)
{  
	var url;
    var newAwifiName;
	var bSwitch = getCheckVal('ckawifiSwitch');
    newAwifiName = getaWiFiSSID();
	
	if (isValidAscii(newAwifiName) != '')
	{
		AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + newAwifiName + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(newAwifiName));
		return false;
	}
	
	SubmitForm.addParameter('x.SSID', newAwifiName);
	
	if (AddFlag == true)
	{
		SubmitForm.addParameter('x.LowerLayers', node2G);
		url = 'add.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration'
								   + '&RequestFile=html/amp/awifi/awifiSwitch.asp';  
		
	}
	else
	{
		SubmitForm.addParameter('x.Enable', bSwitch);
		url = 'set.cgi?x=InternetGatewayDevice.LANDevice.1.WLANConfiguration.' + aWiFiSSID2GInst;
		if (newAwifiName == aWifiInfo.ssid)
		{
			url	+= '&RequestFile=html/amp/awifi/awifiSwitch.asp';
		}
		else
		{
			url	+= '&y=InternetGatewayDevice.X_HW_DEBUG.aWiFi&RequestFile=html/amp/awifi/awifiSwitch.asp';
		}
	}
	
	SubmitForm.setAction(url);
    
	
    setDisable('ckawifiSwitch', 1);
    setDisable('inpAwifiSsid', 1);
    setDisable('btnSaveConf', 0);
}

function Submit1(type)
{
	if (CheckForm(type) == true)
	{
		var Form = new webSubmitForm();
		if(AddSubmitParam(Form,type) != false){
			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			Form.submit();
			DisableRepeatSubmit();
		}
	}
}

function LoadFrame()
{
    setCheck('ckawifiSwitch', aWifiInfo.enable);
    setText('inpAwifiSsid', aWifiInfo.ssid.substring(6,aWifiInfo.ssid.length));

    if (aWifiInfo.enable == false)
    {
        setDisable('inpAwifiSsid', 1);
		setDisable('btnSaveConf', 0);
    }
}


</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<table id="tblServer" width="100%" border="0" cellspacing="0" cellpadding="0" class="tabal_noborder_bg">	
	<tr id="trPortalServerAddr"> 
	<td class="table_title" width="25%"  align="left"> aWiFi无线网络启用 </td>
	<td > <input type="checkbox" name="ckawifiSwitch" id="ckawifiSwitch"   onClick='awifiSwitch();' > </td>
	<td ></td>
	</tr>
	<tr id="trPortalServerPort"> 
	<td class="table_title" width="25%"  align="left"> WiFi名称 </td>
	<td width="1%"> <input type="input" name="fixaWiFi" id="fixaWiFi"  maxlength="5" value="aWiFi" style="width: 40px;" disabled="disabled"></td>
	<td width="1%"> <input type="input" name="fixLine" id="fixLine"  maxlength="1" value="-" style="width: 5px;border: 0;background: white;" disabled="disabled"></td>
	<td > <input type="input" name="inpAwifiSsid" id="inpAwifiSsid"  maxlength="26"> </td>
	<td ></td>
	</tr>
	<tr id="trSpace"> 
	<td  class="height_10p"> </td>
	</tr>
	<tr >
	<td class="height_10p">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<input type="button" name="btnSaveConf" id="btnSaveConf" value="保存" onclick="Submit1();" />
	</td>
	<td ></td>
	<td ></td>
	</tr>
</table>
</body>
</html>

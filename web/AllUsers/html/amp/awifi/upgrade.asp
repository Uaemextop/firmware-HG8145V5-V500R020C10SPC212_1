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
<title>awifi configuration</title>
<script language="JavaScript" type="text/javascript">

function stUpdate(domain,SmartWifiVersion,Manufacture,UpdateRequestServer,UpdateKey,VersionReportServer,CityCode)
{  
    this.domain   = domain;
    this.SmartWifiVersion = SmartWifiVersion;
	this.Manufacture = Manufacture;
	this.UpdateRequestServer  = UpdateRequestServer;
	this.UpdateKey  = UpdateKey;
	this.VersionReportServer  = VersionReportServer;
	this.CityCode  = CityCode;
}

function stDeviceInfo(domain,ModelName)
{
	this.domain             = domain;
	this.ModelName          = ModelName;
}

var UpdateInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AwifiManage,SmartWifiVersion|Manufacture|UpdateRequestServer|UpdateKey|VersionReportServer|CityCode,stUpdate);%>;
var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo,ModelName, stDeviceInfo);%>;
var UpdateInfo = UpdateInfos[0];
var deviceInfo = deviceInfos[0];

function ltrim(str)
{ 
 return str.replace(/(^\s*)|(\s*$)/g,""); 
}

function AddHttpHead(addval)
{
	if ((0 != addval.indexOf("http://")) && ("" != addval))
	{
		addval = 'http://' + addval;
	}
	
	return ltrim(addval);
}

function CheckForm(type)
{   
	with(document.getElementById("tblServer"))
	{		
		if (txtUpgradeReqServerAddr.value == '')
		{
			AlertEx("请输入升级请求服务器地址。");
			Acsurl_text.focus();
			return false;
		}
		
		if (txtUpgradeKey.value == '')
		{
			AlertEx("请输入key。"); 
			Acsurl_text.focus();
			return false;
		}
		
		if (txtUpgradeReportServerAddr.value == '')
		{
			AlertEx("请输入版本上报服务器地址。"); 
			Acsurl_text.focus();
			return false;
		}		
		if (txtCityCode.value == '')
		{
			AlertEx("请输入城市编码。"); 
			Acsurl_text.focus();
			return false;
		}	        
	}
	return true;
}

function AddSubmitParam(SubmitForm,type)
{  
	var Addr;
	Addr = AddHttpHead(getValue('txtUpgradeReqServerAddr')); 	
    SubmitForm.addParameter('x.UpdateRequestServer',Addr);
    SubmitForm.addParameter('x.UpdateKey',getValue('txtUpgradeKey'));
	
	Addr = AddHttpHead(getValue('txtUpgradeReportServerAddr'));
	SubmitForm.addParameter('x.VersionReportServer',Addr);
	
    SubmitForm.addParameter('x.CityCode',getValue('txtCityCode'));

  
    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.X_HW_AwifiManage' + '&RequestFile=html/amp/awifi/upgrade.asp');
                         
    setDisable('btnServerConf',1);
}

function LoadFrame()
{
	setText("txtGatewayVersion",UpdateInfo.SmartWifiVersion);
	setText("txtDeviceModule",deviceInfo.ModelName);
	setText("txtVendorName",UpdateInfo.Manufacture);
	setText("txtUpgradeReqServerAddr",UpdateInfo.UpdateRequestServer);
	setText("txtUpgradeKey",UpdateInfo.UpdateKey);
	setText("txtUpgradeReportServerAddr",UpdateInfo.VersionReportServer);
	setText("txtCityCode",UpdateInfo.CityCode);
}
</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<table id="tblServer" width="100%" border="0" cellspacing="0" cellpadding="0" class="tabal_noborder_bg">
	<tr > 
	<td class="table_title" width="25%" align="left"> 版本号 </td>
	<td ><input type="text" name="txtGatewayVersion" id="txtGatewayVersion"  maxlength="32" disabled> </td>
	<td ></td>
	</tr>
	<tr > 
	<td class="table_title" width="25%" align="left"> 设备型号 </td>
	<td > <input type="text" name="txtDeviceModule" id="txtDeviceModule"  maxlength="32" disabled> </td>
	<td ></td>
	</tr>
	<tr > 
	<td class="table_title" align="left"> 供应商 </td>
	<td > <input type="text" name="txtVendorName" id="txtVendorName"  maxlength="32" disabled> </td>
	<td ></td>
	</tr>
	<tr > 
	<td class="table_title" align="left"> 升级请求服务器 </td>
	<td > <input type="text" name="txtUpgradeReqServerAddr" id="txtUpgradeReqServerAddr"  maxlength="256" > </td>
	<td ></td>
	</tr>
	<tr > 
	<td  class="table_title" align="left"> key </td>
	<td > <input type="text" name="txtUpgradeKey" id="txtUpgradeKey"  maxlength="128"> </td>
	<td ></td>
	</tr>
	<tr > 
	<td  class="table_title" align="left"> 版本上报服务器 </td>
	<td > <input type="text" name="txtUpgradeReportServerAddr" id="txtUpgradeReportServerAddr"  maxlength="256"> </td>
	<td ></td>
	</tr>
	<tr > 
	<td class="table_title" align="left"> 城市编码 </td>
	<td > <input type="text" name="txtCityCode" id="txtCityCode"  maxlength="32"> </td>
	<td ></td>
	</tr>
	<tr id="trSpace"> 
	<td  class="height_10p"> </td>
	</tr>
	<tr >
	<td class="height_10p">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<input type="button" name="btnServerConf" id="btnServerConf" value="保存" onclick="Submit();" />
	</td>
	<td ></td>
	<td ></td>
	</tr>
</table>

</body>

</html>

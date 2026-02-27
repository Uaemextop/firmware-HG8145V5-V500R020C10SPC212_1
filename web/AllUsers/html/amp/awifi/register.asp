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
<title>awifi register</title>
<script language="JavaScript" type="text/javascript">

function stRegPara(domain,AwifiEnable,DeviceType,SmartWifiVersion,RegisterServer,RegisterPort,RegisterUrl,GateWayMac,GateWayIP,GatewayPort)
{  
    this.domain   = domain;
	this.AwifiEnable = AwifiEnable;
	this.DeviceType = DeviceType;
    this.SmartWifiVersion = SmartWifiVersion;
	this.RegisterServer = RegisterServer;
	this.RegisterPort = RegisterPort;
	this.RegisterUrl = RegisterUrl;
    this.GateWayMac  = GateWayMac;
	this.GateWayIP = GateWayIP;
	this.GatewayPort  = GatewayPort;
}

var RegParas = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AwifiManage,AwifiEnable|DeviceType|SmartWifiVersion|RegisterServer|RegisterPort|RegisterUrl|GateWayMac|GateWayIP|GatewayPort,stRegPara);%>;
var RegInfos = RegParas[0];

function ltrim(str)
{ 
 return str.replace(/(^\s*)|(\s*$)/g,""); 
}

function AddHttpHead(addval)
{
	if ((0 != addval.indexOf("https://")) && (0 != addval.indexOf("http://")))
	{
		addval = 'http://' + addval;
	}
	
	return ltrim(addval);
}

function getRegUrl()
{
	var regUrl = AddHttpHead(RegInfos.RegisterServer);
	regUrl += ":"+RegInfos.RegisterPort;
	regUrl += RegInfos.RegisterUrl + "register.htm";
	regUrl += "?gw_address=" + RegInfos.GateWayIP;
	regUrl += "&gw_port=" + RegInfos.GatewayPort;
	regUrl += "&gw_id=" + RegInfos.DeviceType;
	regUrl += "&gw_mac=" + RegInfos.GateWayMac;
	regUrl += "&soft_ver=" + RegInfos.SmartWifiVersion;
	
	return regUrl;
}

function LoadFrame()
{	
	if ("1" == RegInfos.AwifiEnable)
	{
		document.getElementById('btnDevRegister').value = '已启用';
		document.getElementById('textDescription').innerHTML = '已成功启用个性化站点。';
		setDisable('btnDevRegister',1);
	}	
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<table id="tblDevRegister" width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
				<td class="title_common" id="textDescription"> 将跳转至爱WiFi新设备激活管理平台，将商户Portal页绑定上架 </td>				
                </tr>
            </table>
        </td>
    </tr>
	<tr >
	<td class="height_10p">
	</td>
	</tr>
	<tr >
	<td class="height_10p">
	<input type="button" name="btnDevRegister" id="btnDevRegister" value="启用个性化站点" onclick="window.open(getRegUrl());" />
	</td>
	</tr>
</table>
</body>
</html>

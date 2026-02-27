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
<title>awifi default</title>
<script language="JavaScript" type="text/javascript">

function stSpecSrvInfo(domain,DefaultRegisterServer,DefaultRegisterPort,DefaultAuthServer,DefaultAuthPort,PortalServer,PortalPort)
{  
    this.domain   = domain;
    this.DefaultRegisterServer  = DefaultRegisterServer;
	this.DefaultRegisterPort = DefaultRegisterPort;
	this.DefaultAuthServer  = DefaultAuthServer;
	this.DefaultAuthPort  = DefaultAuthPort;
	this.PortalServer  =PortalServer;
	this.PortalPort  =PortalPort;
}

var AwifiManage = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AwifiManage,DefaultRegisterServer|DefaultRegisterPort|DefaultAuthServer|DefaultAuthPort|PortalServer|PortalPort,stSpecSrvInfo);%>;
var specSrvInfo = AwifiManage[0];


function LoadFrame()
{
	setText("txtRegServerAddr",specSrvInfo.DefaultRegisterServer);
	setText("txtRegServerPort",specSrvInfo.DefaultRegisterPort);
	setText("txtAuthServerAddr",specSrvInfo.DefaultAuthServer);
	setText("txtAuthServerPort",specSrvInfo.DefaultAuthPort);
	setText("txtPortalServerAddr",specSrvInfo.PortalServer);
	setText("txtPortalServerPort",specSrvInfo.PortalPort);
}

function ltrim(str)
{ 
 return str.replace(/(^\s*)|(\s*$)/g,""); 
}

function isValidMldPort(port) 
{ 
   if (!isInteger(port) || port < 0 || port > 65535)
   {
       return false;
   }
   
   return true;
}

function CheckForm(type)
{   
	with(document.getElementById("tblServer"))
    {		
		if (!isValidMldPort(txtRegServerPort.value))
		{
			AlertEx('注册端口无效。');
			txtRegServerPort.focus();
			return false;
		}
		
		if (!isValidMldPort(txtAuthServerPort.value))
		{
			AlertEx('认证端口无效。');
			txtAuthServerPort.focus();
			return false;
		}
		
		if (!isValidMldPort(txtPortalServerPort.value))
		{
			AlertEx('Portal端口无效。');
			txtPortalServerPort.focus();
			return false;
		}
		
		if (txtRegServerAddr.value == '')
        {
            AlertEx("请输入注册服务器地址。");
            txtRegServerAddr.focus();
            return false;
        }
		
		if (txtAuthServerAddr.value == '')
        {
            AlertEx("请输入认证服务器地址。"); 
            txtAuthServerAddr.focus();
            return false;
        }
		
		if (txtPortalServerAddr.value == '')
        {
            AlertEx("请输入Portal服务器地址。"); 
            txtPortalServerAddr.focus();
            return false;
        }		        
	}
	return true;
}



function AddSubmitParam(SubmitForm,type)
{  
	var Addr;
	
	Addr = ltrim(getValue('txtRegServerAddr')); 	
    SubmitForm.addParameter('x.DefaultRegisterServer',Addr);
	
    SubmitForm.addParameter('x.DefaultRegisterPort',getValue('txtRegServerPort'));
	
	Addr = ltrim(getValue('txtAuthServerAddr'));
	
	SubmitForm.addParameter('x.DefaultAuthServer',Addr);
    SubmitForm.addParameter('x.DefaultAuthPort',getValue('txtAuthServerPort'));

	Addr = ltrim(getValue('txtPortalServerAddr'));
	SubmitForm.addParameter('x.PortalServer',Addr);
	
    SubmitForm.addParameter('x.PortalPort',getValue('txtPortalServerPort'));
  
    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.X_HW_AwifiManage&y=InternetGatewayDevice.X_HW_DEBUG.aWiFi' + '&RequestFile=html/amp/awifi/default.asp');
                         
    setDisable('btnServerConf',1);
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<table id="tblServer" width="100%" border="0" cellspacing="0" cellpadding="0" class="tabal_noborder_bg">
	<tr id="trRegServerAddr"> 
	<td class="table_title" width="25%" align="left"> 注册服务器 </td>
	<td > <input type="text" name="txtRegServerAddr" id="txtRegServerAddr"  maxlength="256"> </td>
	<td ></td>
	</tr>
	<tr id="trRegServerPort"> 
	<td class="table_title" align="left"> 注册端口 </td>
	<td > <input type="text" name="txtRegServerPort" id="txtRegServerPort"  maxlength="5"> </td>
	<td ></td>
	</tr>
	<tr id="trAuthServerAddr"> 
	<td class="table_title" align="left"> 认证服务器 </td>
	<td > <input type="text" name="txtAuthServerAddr" id="txtAuthServerAddr"  maxlength="256"> </td>
	<td ></td>
	</tr>
	<tr id="trAuthServerPort"> 
	<td class="table_title" align="left"> 认证端口 </td>
	<td > <input type="text" name="txtAuthServerPort" id="txtAuthServerPort"  maxlength="5"> </td>
	<td ></td>
	</tr>
	<tr id="trPortalServerAddr"> 
	<td class="table_title" align="left"> Portal服务器 </td>
	<td > <input type="text" name="txtPortalServerAddr" id="txtPortalServerAddr"  maxlength="256"> </td>
	<td ></td>
	</tr>
	<tr id="trPortalServerPort"> 
	<td class="table_title" align="left"> Portal端口 </td>
	<td > <input type="text" name="txtPortalServerPort" id="txtPortalServerPort"  maxlength="5"> </td>
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

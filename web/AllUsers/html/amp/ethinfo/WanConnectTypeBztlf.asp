<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(gateway.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>" language="JavaScript"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="Javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>

<script language="JavaScript" type="text/javascript">
function LoadFrame()
{
	var selectObj=document.getElementById("wan_mode");  
	selectObj.options[selectObj.length] = new Option(cfg_wanconnect_tdevivo_language['amp_wannect_gpon'],"GPON");  
}

</script>
</head>
<body  class="iframebody"  style="text-align: left;" onLoad="LoadFrame();">

<div class="title_spread"></div>
<form>
<table class = "setupWifiTable" cellSpacing = "0" cellPadding = "0">
<thead>
	<tr>
		<th colspan = "2" BindText="amp_wanconnect_physical_connection"></th>
	</tr>
</thead>
<tbody>
	<tr>
		<td class = "firstChild" BindText="amp_wanconnect_link_type"></td>
		<td>
			<select name = "wan_mode" id = "wan_mode">		
			</select>
		</td>
	</tr>
	<tr>
		<td class = "strong red" colspan = "2">
		<span BindText="amp_wanconnect_warning_part1"></span></br>
		<span BindText="amp_wanconnect_warning_part2"></span>
		</td>
	</tr>
</tbody>
</table>
<script>
	ParseBindTextByTagName(cfg_wanconnect_tdevivo_language, "div",  1);
	ParseBindTextByTagName(cfg_wanconnect_tdevivo_language, "td",  1);
	ParseBindTextByTagName(cfg_wanconnect_tdevivo_language, "span",  1);
	ParseBindTextByTagName(cfg_wanconnect_tdevivo_language, "input", 2);
	ParseBindTextByTagName(cfg_wanconnect_tdevivo_language, "th", 1);
</script>
</form>
</body>
</html>

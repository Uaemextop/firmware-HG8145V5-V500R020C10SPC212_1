<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="./refreshTime.asp"></script>
<title>wireless basic configure</title>
<script language="JavaScript" type="text/javascript">

function stWlanShare(domain,userid,enableuserid)
{
    this.domain = domain;
    this.userid = userid;
    this.enableuserid = enableuserid;
}

var IspSsidList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i},UserId|EnableUserId,stWlanShare);%>;

function LoadFrame()
{
	if(IspSsidList.length < 2)
	{
		setDisplay('promptinfo', 1);
		setDisplay('table_space_1', 0);
		setDisplay('table_space_2', 0);
		setDisplay('table_space_3', 0);
		setDisplay('table_space_4', 0);
		
		return ;
	}

	setCheck("txtUserIDEnable",IspSsidList[0].enableuserid);
	setText("txtUserID",IspSsidList[0].userid);
}

function ApplySubmit()
{  
	var Form = new webSubmitForm();
	
    Form.addParameter('x.EnableUserId',getCheckVal('txtUserIDEnable'));
	Form.addParameter('x.UserId',getValue('txtUserID'));
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.1' + '&RequestFile=html/amp/wlanbasic/wlanShare.asp');
	
    Form.submit();
    setDisable('Save_button',1);
}

function Cancel_buttonValue()
{
	LoadFrame();
}

</script>
</head>

<body onLoad="LoadFrame();" class="mainbody">
<table id="promptinfo" width="100%" border="0" cellspacing="0" cellpadding="0" class="tabal_noborder_bg" style="display:none">
	<tr> <td height="5"></td> </tr>
  	<tr> <td class="table_head" width="100%">当前不存在共享SSID，请先新建一个。</td> </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id = "table_space_1">
  	<tr> <td class="table_head" width="100%">WLAN 共享配置</td> </tr>
	<tr> <td height="5"></td> </tr>
    <tr>
		<td class="title_common">
			<script language="JavaScript">
			document.write("说明：可启用/禁用共享业务以及设置共享账号。");
			</script>
			<label id="Title_wlan_common_set_lable" class="title_common">					
			</label>                    
		</td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="table_space_2">
    <tr ><td class="height15p"></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabal_noborder_bg" id="table_space_3" >
	<tr>
	  <td class="table_left width_per25">使能共享标识：&nbsp;</td>
	  <td class="table_right" id="TdHide">
		<input type='checkbox' id='txtUserIDEnable' name='txtUserIDEnable' value="OFF"><span class="gray"> </span></td>
	</tr>
	<tr id="trAuthServerAddr"> 
		<td class="table_left width_per25" align="left">用户标识：&nbsp;  </td>
		<td > <input type="text" name="txtUserID" id="txtUserID"  style="width:123px" maxlength="32">
		<td ></td>
	</tr>
	<tr id="trSpace"> 
		<td class="height_10p"> </td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0"  id="table_space_4">
  <tr><td>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
	  <tr align="right">
		<td class="table_submit width_per25"></td>
		<td class="table_submit">
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button id="Save_button" name="Save_button" type="button" class="submit" onClick="ApplySubmit();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_sure']);</script></button>
		  <button id="Cancel_button" name="Cancel_button" type="button" class="submit" onClick="Cancel_buttonValue();"><script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script></button>
		</td>
	  </tr>
	</table>
	</td> 
  </tr>
</table>

</body>
<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd --></html>

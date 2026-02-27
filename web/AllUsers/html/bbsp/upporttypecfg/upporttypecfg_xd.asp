<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title>Uplink Mode</title>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var tr069wanNum = 0;
var CurrentUpMode = '<%HW_WEB_GetUpMode();%>';
var UplinkMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.UplinkMode);%>';
var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.6.WANConnectionDevice.{i}.WANIPConnection.{i},ConnectionStatus|ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG|AddressingType,WANIP);%>;
var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.6.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionStatus|ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANPPP);%>;
var WanListXD = WanIp.concat(WanPpp);
function WANIP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG,AddressingType)
{
    this.domain     = domain;
    this.ConnectionStatus   = ConnectionStatus; 
        
    if(ConnectionType == 'IP_Bridged')
    {
    this.ExternalIPAddress  = '--';
    }
    else
    {
    this.ExternalIPAddress  = ExternalIPAddress;
    }
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
    this.X_HW_TR069FLAG = X_HW_TR069FLAG;
    this.WanType = AddressingType;
}

function WANPPP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG)
{
    this.domain = domain;
    this.ConnectionStatus   = ConnectionStatus; 

    if (ConnectionType == 'PPPoE_Bridged')
    {  
    this.ExternalIPAddress  = '--';   
    }
    else
    {
    this.ExternalIPAddress= ExternalIPAddress;
    }    
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
    this.X_HW_TR069FLAG = X_HW_TR069FLAG;
    this.WanType = 'PPPoE';
}

function LoadFrame()
{	
    setSelect('UpModeList', UplinkMode);
}

for (var i=0;i<WanListXD.length;i++) {
	if (WanListXD[i] == null){
		continue;
	}
	else {
		if(WanListXD[i].X_HW_SERVICELIST == "TR069") {
			tr069wanNum++;
		}
	}
}
 

function SubmitForm()
{
	if ( CurrentUpMode == 3) {
		if (tr069wanNum == 0) {
			alert("Currently no PON TR069 WAN,please add one first!")
			return;
		}
	}
    var Form = new webSubmitForm();

    if(ConfirmEx(upmodecfg_language["upmodecfg_confirm"]) == false)
    {
        return;
    }

    Form.addParameter('x.UplinkMode', getValue('UpModeList'));
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo'+ '&RequestFile=html/bbsp/upporttypecfg/upporttypecfg.asp');
    Form.submit();
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("upmodecfgtitle", GetDescFormArrayById(upmodecfg_language, "bbsp_mune"), GetDescFormArrayById(upmodecfg_language, ""), false);
	document.getElementById("upmodecfgtitle_content").innerHTML = upmodecfg_language['bbsp_upmodecfg_title'];
</script>
<div class="title_spread"></div>

<form id="UpModeCfgForm" name="UpModeCfgForm">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
		<li id="UpModeList"  RealType="DropDownList" DescRef="upmodecfg_mode"   RemarkRef="Empty"   ErrorMsgRef="Empty"  Require="FALSE"   BindField="Empty"  InitValue="[{TextRef:'GPON',Value:'GPON'},{TextRef:'DSL',Value:'DSL'}]"/>
    </table>
	<script>
		var TableClass = new stTableClass("width_per40", "width_per60", "ltr");
		var UpModeCfgFormList = new Array();
		UpModeCfgFormList = HWGetLiIdListByForm("UpModeCfgForm",null);
        HWParsePageControlByID("UpModeCfgForm",TableClass,upmodecfg_language,null);
    </script>
</form>

<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(upmodecfg_language['upmodecfg_app']);</script></button>
  </td>
  </tr>
</table>

</body>
</html>

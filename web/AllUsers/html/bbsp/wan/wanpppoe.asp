<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
</head>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/ontstate.asp"></script>
<script language="javascript" src="<%HW_WEB_CleanCache_Resource(wanlanguage.html);%>"></script>
<script language="javascript" src="../common/wanaddressacquire.asp"></script>

<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/<%HW_WEB_DeepCleanCache_Resource(wan_list_info.asp);%>"></script>
<script language="javascript" src="../common/<%HW_WEB_DeepCleanCache_Resource(wan_list.asp);%>"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(wan_servicelist.js);%>"></script>
<script language="javascript" src="../common/wan_pageparse.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/wan/wan.cus);%>"></script>
<script language="JavaScript" type="text/javascript">

var g_tr069interwan_status = 0;
var g_tr069interwan_name="";
function BasicWanPPP(domain,Username,Password,X_HW_SERVICELIST,ConnectionStatus,ConnectionType)
{
	this.domain             = domain;
	this.Username           = Username;	
	this.X_HW_SERVICELIST   = X_HW_SERVICELIST;
	this.Password           = Password;
	this.ConnectionStatus   = ConnectionStatus;
	this.ConnectionType     = ConnectionType;
}

var PPPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Username|Password|X_HW_SERVICELIST|ConnectionStatus|ConnectionType,BasicWanPPP);%>;

function GetTR069InternetPPPWan()
{
	if(PPPWanList.length <= 1)
	{
		return -1;
	}
		
	for(var index = 0; index < PPPWanList.length - 1; index++)
	{
		if((PPPWanList[index].X_HW_SERVICELIST.toString().toUpperCase().indexOf("INTERNET") >= 0)
		&&(PPPWanList[index].ConnectionType.toString().toUpperCase().indexOf("ROUTED") >= 0))
		{
			return index ;
		}
	}
	
	return -1;
}

function DisableDataWan(ctrFlag)
{
	setDisable('UserName',ctrFlag);
	setDisable('Password',ctrFlag);
}

function DisplayDataWanInfo()
{
	setDisplay("UserNameRow", 1);
	setDisplay("PasswordRow", 1);
}

function OnChangewWanServiceUI(Obj)
{
	g_tr069interwan_status = 0;
	var  PPPWanIndex = GetTR069InternetPPPWan();	
	
	DisplayDataWanInfo();
	DisableDataWan(0);
	setText("ButtonApply", Languages['Connect']);	
	
	if(-1 == PPPWanIndex)
	{
		setDisable('ServiceList',1);
		setDisable('ButtonApply',1);
		DisableDataWan(1);
		g_tr069interwan_status = 0;
		return ;
	}
	
	g_tr069interwan_name = PPPWanList[PPPWanIndex].Username;
	setText('UserName',PPPWanList[PPPWanIndex].Username);
	setText('Password',"********************************");
	
	setDisable('ButtonApply',0);
	
	if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
	{
		g_tr069interwan_status = 1;
		setText("ButtonApply", Languages['DisConnect']);						
		DisableDataWan(1);
	}

}

function CheckDataWanInfo()
{
	if ((getValue('UserName') != '') && (isValidAscii(getValue('UserName')) != ''))        
	{
		AlertEx(Languages['IPv4UserName'] + Languages['Hasvalidch'] + isValidAscii(getValue('UserName')) + '".');          
		return false;       
	}
	
	if ((getValue('Password') != '') && (isValidAscii(getValue('Password')) != ''))         
	{  
		AlertEx(Languages['IPv4Password'] + Languages['Hasvalidch'] + isValidAscii(getValue('Password')) + '".');         
		return false;       
	}
	
	return true;	
}

function OnApply()
{
	var Form = new webSubmitForm();
	
	var url = '';
	var PPPWanIndex = GetTR069InternetPPPWan();
	var PPPWanDomainArr = new Array('a','b','c','d','e','f','g','h');
	var urlAction = "";
	
	if(false == CheckDataWanInfo())
	{
		return ;
	}
	
	for(var index = 0; index < PPPWanList.length - 1; index++)
	{
		if(PPPWanList[index].ConnectionType.toString().toUpperCase().indexOf("ROUTED") < 0)
		{
			continue;
		}
		
		if(g_tr069interwan_name != getValue('UserName'))
		{
			Form.addParameter(PPPWanDomainArr[index] + '.Username', getValue('UserName'));
		}
		
		if("********************************" != getValue('Password'))
		{
			Form.addParameter(PPPWanDomainArr[index] + '.Password', getValue('Password'));
		}
		
		if(1 == g_tr069interwan_status)
		{
			Form.addParameter(PPPWanDomainArr[index] + '.Enable', 0);
		}
		else
		{
			Form.addParameter(PPPWanDomainArr[index] + '.Enable', 1);
		}
		
		urlAction = urlAction + PPPWanDomainArr[index] + '=' + PPPWanList[index].domain + '&';
	}
		
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	Form.setAction('set.cgi?' +  urlAction  + 'RequestFile=html/bbsp/wan/wanpppoe.asp');
	
	Form.submit();
	
	setDisable('ButtonApply' ,1);
}

function LoadFrame()
{
	OnChangewWanServiceUI();
}
</script>
<body  id="wanbody" onLoad="LoadFrame();"  class = "mainbody">
<div id="PromptPane2" style="display:none;">
</div>
<form id="ConfigForm">
<div class="PageTitle_title" id = "BasicInfoBar"><script>document.write(Languages['PPPOECount']);</script></div>
<div class="PageTitle_content"><script>document.write(Languages['PPPOECountInfo']);</script></div>
<table id="ConfigPanel"  width="100%" cellspacing="1" cellpadding="0"> 
<li   id="UserName"                  RealType="TextBox"            DescRef="IPv4UserName"              RemarkRef="IPv4UserNameHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.UserName"           InitValue="Empty"   MaxLength="64"/>
<li   id="Password"                  RealType="TextBox"            DescRef="IPv4Password"              RemarkRef="IPv4PasswordHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.Password"           InitValue="Empty"   MaxLength="64"/>
<script>
var WanConfigFormList = [];
var dir_style = ("ARABIC" == LoginRequestLanguage.toUpperCase()) ? "rtl" : "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm",WanReload);
HWParsePageControlByID("ConfigForm", TableClass, Languages, WanReload);

ParsePageSpec();
</script>
<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td width="25%">
        </td>
        <td class="table_submit" style="padding-left: 5px">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <input id="ButtonApply"  type="button" value="OK" onclick="javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px" />
        </td>
    </tr>
</table>
<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
</table> 
<script>
    var  PPPWanIndex = GetTR069InternetPPPWan();
	if(-1 == PPPWanIndex)
	{
		setText("ButtonApply", Languages['Connect']);	
	}
	else
	{	
		if("CONNECTED" == PPPWanList[PPPWanIndex].ConnectionStatus.toString().toUpperCase())
		{
			setText("ButtonApply", Languages['DisConnect']);
		}
		else
		{
			setText("ButtonApply", Languages['Connect']);		
		}
	}
</script>

</form>

<script>
	ParseBindTextByTagName(guideinternet_language, "span", 1);
	ParseBindTextByTagName(guideinternet_language, "input", 2);
</script>
</body>
</html>
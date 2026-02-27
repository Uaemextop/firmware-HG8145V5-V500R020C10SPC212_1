<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_extended.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../frame.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var TopoInfo = GetTopoInfo();
var Wan = GetWanList();
var curWandomain = "";
var curEnterStyle = "";
var RouteStatus = '<%HW_WEB_GetRouteStatus();%>';
var stbport = '<%HW_WEB_GetSTBPort();%>';
var CurrentBin = '<%HW_WEB_GetBinMode();%>';
var TianYiFlag = '<%HW_WEB_GetFeatureSupport(FT_AMP_ETH_INFO_TIANYI);%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';

var LineDirectoryNumber1 = '';
var LineDirectoryNumber2 = '';
var SipAuthName1 = '';
var SipAuthName2 = '';
var SipAuthPassword1 = '';
var SipAuthPassword2 = '';

function stPhyInterface(Domain, InterfaceID )
{
    this.Domain = Domain;
}
var AllPhyInterface = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i},InterfaceID,stPhyInterface);%>;

function stLine(Domain, DirectoryNumber, Enable, PhyReferenceList )
{
    this.Domain = Domain;
    this.DirectoryNumber = DirectoryNumber;
    this.PhyReferenceList = PhyReferenceList;

    if (Enable.toLowerCase() == 'enabled')
    {
        this.Enable = 1;
    }
    else
    {
        this.Enable = 0;
    }     
	
    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}
var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i},DirectoryNumber|Enable|PhyReferenceList,stLine);%>;

function stAuth(Domain, AuthUserName, AuthPassword, URI)
{
    this.Domain = Domain;
    this.AuthUserName = AuthUserName;    
	this.AuthPassword = AuthPassword;
	this.URI = URI;   

    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}
var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP,AuthUserName|AuthPassword|URI,stAuth);%>;

LineDirectoryNumber1 = AllLine[0].DirectoryNumber;
SipAuthName1 = AllAuth[0].AuthUserName;
SipAuthPassword1 = AllAuth[0].AuthPassword;
if (AllPhyInterface.length == 3)
{
	LineDirectoryNumber2 = AllLine[1].DirectoryNumber;
	SipAuthName2 = AllAuth[1].AuthUserName;
	SipAuthPassword2 = AllAuth[1].AuthPassword;
}

function stAclInfo(domain,HttpWanEnable)
{
    this.domain = domain;
    this.HttpWanEnable = HttpWanEnable;
}
var aclinfo = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecAclInfos, InternetGatewayDevice.X_HW_Security.AclServices,HTTPWanEnable,stAclInfo);%>;  
var HttpWan = aclinfo[0];

if(window.location.href.indexOf("cnt_cfgwizard.asp?") > 0)
{
	var currentUrl = window.location.href;
	var tempId = (currentUrl.split("?"))[1];
	if(tempId != "")
	{
		curEnterStyle = "Link";
	}
}
else
{
	curEnterStyle = "Direct";
}
	

function IsWlanAvailable()
{
	if(1 == '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function GetFirstInternetWan()
{
	for(var i = 0; i < Wan.length; i++)
	{
		if(Wan[i].ServiceList.indexOf("INTERNET") >= 0  && 'PPPoE' == Wan[i].EncapMode && 'IP_ROUTED' == Wan[i].Mode.toString().toUpperCase()) 
		{
			return Wan[i];
		}
	}
	return false;
}

function GetCurrentInternetWan()
{
	var curUrl = window.location.href;
	var curMacId = (curUrl.split("?"))[1];
	var Wan = GetWanList();
	for(var i = 0; i < Wan.length; i++)
	{
		if (Wan[i].MacId == curMacId )
		{
		    return Wan[i];
		}
	}
	return false;
}

function HideAll()
{
	setDisplay('wizard1', 0);
	setDisplay('wizard2', 0);
	setDisplay('wizard4', 0);
}

function stNormalUserInfo(UserName, ModifyPasswordFlag)
{
    this.UserName = UserName;
    this.ModifyPasswordFlag = ModifyPasswordFlag;	
}

var UserInfo = <%HW_WEB_GetNormalUserInfo(stNormalUserInfo);%>;
var sptUserName = UserInfo[0].UserName;

var curUserType = '<%HW_WEB_GetUserType();%>';
var ConfigFlag = '<%HW_WEB_GetGuideFlag();%>';

function InitWlanCfg()
{
	var WlanSSID1 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID);%>';
	var psk1 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1.PreSharedKey);%>';
	setText('Wizard_text02_text',WlanSSID1);
	setText('Wizard_password02_password',psk1);
	
	if (1 == DoubleFreqFlag)
	{
		var WlanSSID2 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.SSID);%>';
		var psk2 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.PreSharedKey.1.PreSharedKey);%>';
		setText('Wizard_text02_text_5g',WlanSSID2);
		setText('Wizard_password02_password_5g',psk2);
	}
	
}

function LoadFrame()
{
	HideAll();
	setDisplay('wizard1', 1);
	
	if (1 == DoubleFreqFlag)
	{
		setDisplay('wlanconfig_detail_5g', 1);
	}
	if (('CNT' == CfgMode.toUpperCase()) || ('CNT2' == CfgMode.toUpperCase()))
	{
		if ((parseInt(ConfigFlag.split("#")[0], 10)) || (parseInt(ConfigFlag.split("#")[1], 10)))
		{
			window.location="/index.asp";
		}
	}
	
	if (GetFirstInternetWan() == false)
	{
		return;
	}
	else
	{
		setText('Wizard_text01_text',GetFirstInternetWan().UserName);
		setText('Wizard_password01_password', GetFirstInternetWan().Password);
	}
	
	InitWlanCfg();
	setText('Wizard_telephone_username', AllLine[0].DirectoryNumber);
	setText('Wizard_telephone_author_username', AllAuth[0].AuthUserName);
	setText('Wizard_telephone_password', AllAuth[0].AuthPassword);
}


function InternetWanAddPara(Form)
{
	var UserName = getValue('Wizard_text01_text');
	var Password = getValue('Wizard_password01_password');
	
		if("Direct" == curEnterStyle)
		{	
			if(GetFirstInternetWan() != false)
			{
				curWandomain = GetFirstInternetWan().domain;
				Form.addParameter('y.Username',UserName);
				Form.addParameter('y.Password',Password);
			}	
		}
		else
		{
			curWandomain = GetCurrentInternetWan().domain;
			if("IP_ROUTED" == GetCurrentInternetWan().Mode.toString().toUpperCase())
			{
				Form.addParameter('y.Username',UserName);
				Form.addParameter('y.Password',Password);
			}
			else
			{
				Form.addParameter('y.ConnectionType',"IP_Routed");
				Form.addParameter('y.Username',UserName);
				Form.addParameter('y.Password',Password);
			}
		}
	
}

function ltrim(str)
{ 
 return str.replace(/(^\s*)/g,""); 
}

function CheckInternet()
{
	var UserName = getValue('Wizard_text01_text');
	var Password = getValue('Wizard_password01_password');

	if ((UserName != '') && (isValidAscii(UserName) != ''))        
	{  
		AlertEx('Cuenta de ancho de banda' + ' contiene caracteres no válidos "' + isValidAscii(UserName) + '".');          
		return false;       
	}
	
	if ((Password != '') && (isValidAscii(Password) != ''))      
	{  
		AlertEx('Contraseña de ancho de banda' + ' contiene caracteres no válidos "' + isValidAscii(Password) + '".');          
		return false;       
	}
	return true;
}

function CheckSsid()
{
	var ssid;
	ssid = ltrim(getValue('Wizard_text02_text'));
	
	if (ssid == '')
    {
        AlertEx(cfg_wlancfgother_language['amp_empty_ssid']);
        return false;
    }

    if (ssid.length > 32)
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
        return false;
    }

    if (isValidAscii(ssid) != '')
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
        return false;
    }

	return true;
}

function checkValidVoipInfo()
{
	var LineIndex = getSelectVal('Wizard_telephone_port');
	
	if (LineIndex == 1)
	{
		
		LineDirectoryNumber1 = getValue('Wizard_telephone_username');
		SipAuthName1 = getValue('Wizard_telephone_author_username');
		SipAuthPassword1 = getValue('Wizard_telephone_password');
	}
	
	if (LineIndex == 2)
	{
		LineDirectoryNumber2 = getValue('Wizard_telephone_username');
		SipAuthName2 = getValue('Wizard_telephone_author_username');
		SipAuthPassword2 = getValue('Wizard_telephone_password');
	}
	
    var DirecNumber1 = ltrim(LineDirectoryNumber1);
	var DirecNumber2 = ltrim(LineDirectoryNumber2);
	var AuthName1 = ltrim(SipAuthName1);
	var AuthName2 = ltrim(SipAuthName2);
	var AuthPassword1 = ltrim(SipAuthPassword1);
	var AuthPassword2 = ltrim(SipAuthPassword2);
	var vspa_cantexceed = 'no puede superar ';
	var vspa_characters = ' caracteres.';
	var vspa_hasvalidch = 'contiene caracteres no válidos: "';
	var vspa_end = '.';
	
	if (DirecNumber1.length >= 64 )
	{
		AlertEx('Usuario de registro ' + vspa_cantexceed  + DirecNumber1.length  + vspa_characters);
        return false;
	}
	
    if (isValidAscii(DirecNumber1) != '')
    {
        AlertEx('Usuario de registro ' + vspa_hasvalidch + isValidAscii(DirecNumber1) + vspa_end);
        return false;
    }
	
	if (DirecNumber2.length >= 64 )
	{
		AlertEx('Usuario de registro ' + vspa_cantexceed + DirecNumber2.length  + vspa_characters);
        return false;
	}
	
    if (isValidAscii(DirecNumber2) != '')
    {
        AlertEx('Usuario de registro ' + vspa_hasvalidch + isValidAscii(DirecNumber2) + vspa_end);
        return false;
    }
	
	if (AuthName1.length >= 64 )
	{
		AlertEx('Usuario de autenticatión ' + vspa_cantexceed  + AuthName1.length  + vspa_characters);
        return false;
	}
	
    if (isValidAscii(AuthName1) != '')
    {
        AlertEx('Usuario de autenticatión ' + vspa_hasvalidch + isValidAscii(AuthName1) + vspa_end);
        return false;
    }
	
	if (AuthName2.length >= 64 )
	{
		AlertEx('Usuario de autenticatión ' + vspa_cantexceed  + AuthName2.length  + vspa_characters);
        return false;
	}
	
    if (isValidAscii(AuthName2) != '')
    {
        AlertEx('Usuario de autenticatión ' + vspa_hasvalidch + isValidAscii(val) + vspa_end);
        return false;
    }
	
	if (AuthPassword1.length >= 64 )
	{
		if (AuthPassword1 != '****************************************************************')
		{
			AlertEx('Clave ' + vspa_cantexceed + AuthPassword1.length + vspa_characters);
			return false;
		}
	}
	
    if (isValidAscii(AuthPassword1) != '')
    {
        AlertEx('Clave ' + vspa_hasvalidch + isValidAscii(AuthPassword1) + vspa_end);
        return false;
    }
	
	if (AuthPassword2.length >= 64 )
	{
		if (AuthPassword2 != '****************************************************************')
		{
			AlertEx('Clave ' + vspa_cantexceed + uthPassword2.length + vspa_characters);
			return false;
		}		
	}
	
    if (isValidAscii(AuthPassword2) != '')
    {
        AlertEx('Clave ' + vspa_hasvalidch + isValidAscii(AuthPassword2) + vspa_end);
        return false;
    }
     
    return true;
}

function OnChangeFun_Port()
{
	var LineIndex = getSelectVal('Wizard_telephone_port');
	var LineDirectoryNumber;
	var SipAuthName;
	var SipAuthPassword;
	
	if (LineIndex == 1)
	{
		
		LineDirectoryNumber2 = getValue('Wizard_telephone_username');
		LineDirectoryNumber = LineDirectoryNumber1;

		SipAuthName2 = getValue('Wizard_telephone_author_username');
		SipAuthName = SipAuthName1;

		SipAuthPassword2 = getValue('Wizard_telephone_password');
		SipAuthPassword = SipAuthPassword1;
		
	}
	if (LineIndex == 2)
	{
		LineDirectoryNumber1 = getValue('Wizard_telephone_username');
		LineDirectoryNumber = LineDirectoryNumber2;
		
		SipAuthName1 = getValue('Wizard_telephone_author_username');
		SipAuthName = SipAuthName2;
		
		SipAuthPassword1 = getValue('Wizard_telephone_password');
		SipAuthPassword = SipAuthPassword2;

	}
	
	setText('Wizard_telephone_username', LineDirectoryNumber);
	setText('Wizard_telephone_author_username', SipAuthName);
	setText('Wizard_telephone_password', SipAuthPassword);

	$(".wizard4").load(location.href+" .wizard4");
	
}

function AddVoipFormPara(Form)
{
	Form.addParameter('vl1.DirectoryNumber',LineDirectoryNumber1);
	Form.addParameter('vs1.AuthUserName',SipAuthName1);
	if (SipAuthPassword1 != '****************************************************************')
    {
        Form.addParameter('vs1.AuthPassword',SipAuthPassword1); 
    }
	
	if((LineDirectoryNumber1 != '')||(SipAuthName1 != ''))
	{
		Form.addParameter('vl1.Enable','Enabled'); 
	}
	
	if (AllPhyInterface.length == 3)
	{
		Form.addParameter('vl2.DirectoryNumber',LineDirectoryNumber2);
		Form.addParameter('vs2.AuthUserName',SipAuthName2);
		if (SipAuthPassword2 != '****************************************************************')
		{
			Form.addParameter('vs2.AuthPassword',SipAuthPassword2);
		}
		
		if((LineDirectoryNumber2 != '')||(SipAuthName2 != ''))
		{
			Form.addParameter('vl2.Enable','Enabled'); 
		}
	}
	
	
}

function CheckPsk()
{
	var value = getValue('Wizard_password02_password');
	
	if (value == '')
	{
		AlertEx(cfg_wlancfgother_language['amp_empty_para']);
		return false;
	}

	if (isValidWPAPskKey(value) == false)
	{
		AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
		return false;
	}

	return true;
}

function WlanAddFormPara(Form)
{
	Form.addParameter('p.SSID', ltrim(getValue('Wizard_text02_text')));
	Form.addParameter('q.PreSharedKey', getValue('Wizard_password02_password'));
	
	if (1 == DoubleFreqFlag)
	{
		Form.addParameter('m.SSID', ltrim(getValue('Wizard_text02_text_5g')));
		Form.addParameter('n.PreSharedKey', getValue('Wizard_password02_password_5g'));
	}
}

function NextStep1()
{
	
	if (false == CheckInternet())
	{
		return;
	}
	HideAll();
	setDisplay('wizard2',1);
	setDisplay('Wizard_button2_1_button',1);
	setDisplay('Wizard_button2_2_button',1);
	
}

function OnStep2()
{
	HideAll();
	setDisplay('wizard1',1);
}

function NextStep2()
{
	if (false == CheckSsid())
	{
		return;
	}

	if (false == CheckPsk())
	{
		return;
	}
	
	HideAll();
	setDisplay('wizard4',1);
	
}

function OnStep3()
{
	HideAll();
	setDisplay('wizard2',1);
		
}


function OnfinishStep()
{
	if (false == checkValidVoipInfo())
	{
		return ;
	}
	
	SetDoneGuideFlag();
	SetData();
}

function SetDoneGuideFlag()
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/smartguide.cgi?1=1&RequestFile=html/ssmp/cfgguide/cnt_cfgwizard.asp',
		data:'Parainfo='+'1',
		success : function(data) {
			;
		}
	});
	
}

function SetData()
{
	var Form = new webSubmitForm();
	var cgi_type = 'set.cgi?';
	var url = '';
	url_new = '';
	
	AddVoipFormPara(Form);
	var voip_url = '&vl1=InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.1'
				  +'&vs1=InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.1.SIP';
	if (AllPhyInterface.length == 3)
	{
		cgi_type = 'complex.cgi?';
		voip_url += '&vl2=InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.2'
		  +'&vs2=InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.2.SIP';
	}
	url_new += cgi_type;		
	url += voip_url;

	if("Ignore" != InternetWanAddPara(Form))
	{
		url +='&y='+curWandomain;
	}
	
	if (true == IsWlanAvailable())
	{
		WlanAddFormPara(Form);
		url += '&p=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1' + '&q=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1';
		
		if (1 == DoubleFreqFlag)
		{
			url += '&m=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5' + '&n=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.PreSharedKey.1'
		}
	}


	url += '&RequestFile=html/ssmp/cfgguide/cnt_cfgwizard.asp';
	url_new += url;
	Form.setAction(url_new);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
	
}

</script>


<style type="text/css">

.mainbody_guide { 
    margin: 0px;
    padding: 0px;
    border-width: 0px;
    text-align: left;
    vertical-align: top;
    margin-left: auto;
    margin-right: auto;
    margin-top: 100px;
    list-style: none;
    width: 800px;
    height: 600px;
}

.wizard { 
	background-color: #d9d9d9;
    padding-top: 80px;
    padding-right: 80px;
    padding-bottom: 80px;
    padding-left: 80px;
	border-top-left-radius: 0px;
    border-top-right-radius: 0px;
    border-bottom-right-radius: 0px;
    border-bottom-left-radius: 0px;
    border-style: solid;
	border-top-color: #d9d9d9;	
    border-right-color: #d9d9d9;
    border-bottom-color: #d9d9d9;
    border-left-color: #d9d9d9;
}

.table_right_new{
    padding-left: 5px;
    height: 30px;
    line-height: 24px;
	font-size: 16px;
	font-weight: bold;
	font-family: -webkit-pictograph;
}

.table_left_new{
	font-size: 16px;
	font-weight: bold;
	font-family: -webkit-pictograph;
}

.table_submit_new{
    padding-left: 5px;
    height: 30px;
    line-height: 24px;
    padding-bottom: 5px;
    padding-top: 5px;
	background-color: #d9d9d9;	
}

.table_head_new{
	font-size: 16px;
	font-weight: bold;
	height: 35px;
}

.input_new{
    font-size: 16px;

}

.menu_new{
    font-size: 16px;
    border-radius: 5px;
    border-style: ridge;
}

.hg_title
{
	float: left;
    height: 70px;
    width: 656px;
    background: url(../../../images/banner_bg.gif) repeat-x center;
	font-size: 30px; 
	font-weight: bold;
	margin-top: 0px;
}

.table_new{
	border-spacing: 0px;
	width:144px; 
	height:70px;
}	

.hg_logo_new{
	width:144px; 
	height:70px;
}

.blue_line{
	width:800px;
	height:4px;
	background-color:#00A0E4;
}

</style>


</head>
<body class="mainbody_guide" onLoad="LoadFrame();">

<table  class="table_new" border="0" cellspacing="0" cellpadding="0" id="head">
<tr>
<td id="hg_logo_new" class="hg_logo_new">
<img src="../../../images/banner_logo_cnt.gif" alt="" style="margin-top:0px; ">
</td>
<td id="hg_title" class="hg_title" >
	<script language="JavaScript" type="text/javascript">
		document.write(ProductName);
	</script>					
</td>
</tr>
</table>

<div id="blue_line" class="blue_line" > </div>
				
<div id="wizard" class="wizard" >
<div id="wizard1" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr >
<td class="height_15px">
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="wizard1_title">
  	<tr>
		<td class="table_head_new" width="100%">
		<label id="Title_wizard1_lable">INTERNET :</label>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="Wizard1Panel" > 
	<tr>
	<td class="table_left_new width_25p" style="width:60px;">Usuario:</td> 
	<td class="table_right_new width_75p"> <input class="input_new" type="text" id="Wizard_text01_text" maxlength="63"> </td> 
  </tr>
  <tr>
	<td class="table_left_new width_25p" >Clave:</td> 
	<td class="table_right_new width_75p"> <input class="input_new" type="password" id="Wizard_password01_password" maxlength="63" > </td> 
  </tr>              
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="wizard1_table2"> 
  <tr align="right"> 
	<td class="table_submit_new">
	 <input class="menu_new" id="Wizard_button1_2_button" type="button" onClick="NextStep1();"  value="Siguiente"> 
	<td>
  </tr>         
</table>

</div>

<div id="wizard2" style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td class="table_head_new" width="100%">
		<label id="Title_wizard2_lable">WLAN:</label>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
		<td class="height_15px"></td>
	</tr>
</table>

<table id="wlanconfig_detail" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<script>
			if (1 == DoubleFreqFlag)
			{
				document.write('<td class="table_left_new" style="width:86px;">SSID_2.4G:</td>');
			}
			else
			{
				document.write('<td class="table_left_new" style="width:50px;">SSID:</td>');
			}
		</script>
		<td class="table_right_new">
			<input class="input_new" type="text" name="Wizard_text02_text" id="Wizard_text02_text" maxlength="32">
		</td>
	</tr>
	
	<tr>
		<td class="table_left_new">Clave<script>if (1 == DoubleFreqFlag){document.write("_2.4G");}</script>:</td>
		<td class="table_right_new">
			<input class="input_new" type='password' id='Wizard_password02_password' name='Wizard_password02_password' maxlength='64' class="amp_font"  onchange="" />
		</td>
	</tr>
</table>
<table id="wlanconfig_detail_5g" width="100%" border="0" cellspacing="0" cellpadding="0" style="display:none">
	<tr>
		<td class="table_left_new" style="width:86px;">SSID_5G:</td>
		<td class="table_right_new">
			<input class="input_new" type="text" name="Wizard_text02_text_5g" id="Wizard_text02_text_5g" maxlength="32">
		</td>
	</tr>
	<tr>
		<td class="table_left_new">Clave_5G:</td>
		<td class="table_right_new">
			<input class="input_new" type='password' id='Wizard_password02_password_5g' name='Wizard_password02_password_5g' maxlength='64' class="amp_font"  onchange="" />
		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr align="right">
		<td class="table_submit_new">
		<input class="menu_new" name="Wizard_button2_1_button" id="Wizard_button2_1_button" type="button" onClick="OnStep2();"  value="Anterior"> 
      	<input class="menu_new" name="Wizard_button2_2_button" id="Wizard_button2_2_button" type="button" onClick="NextStep2();"  value="Siguiente"> 
		</td>
	</tr>
</table>
</div>

<div id="wizard4" style="display:none"> 
<table id="table_changepassword" width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td class="table_head_new" width="100%"><label id = "Title_wizard4_lable">TELEFONIA:</label></td> 
</tr>
<tr>
<td class="height_15px"></td> 
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="table_left_new width_25p" style="width:180px;">Usuario de registro:</td> 
		<td class="table_right_new width_75p"> <input class="input_new" type="text" id="Wizard_telephone_username" maxlength="63"> </td> 
	</tr>
	<tr>
		<td class="table_left_new width_25p">Puertos POTs asociados:</td> 
		<td class="table_right_new width_75p">
			<select class="input_new" type="text" id="Wizard_telephone_port" maxlength="63" onChange="OnChangeFun_Port()"> 
				<script language="JavaScript" type="text/javascript">
				var k;
				for (k = 1; k < AllPhyInterface.length; k++)
				{
					document.write('<option value="' + k + '">' + k + '</option>');
				}
                                                         
           </script>
			</select>
		</td> 
		
	</tr>
	<tr>
		<td class="table_left_new width_25p">Usuario de autenticatión:</td> 
		<td class="table_right_new width_75p"> <input class="input_new" type="text" id="Wizard_telephone_author_username" maxlength="63"> </td> 
	</tr>
	<tr>
		<td class="table_left_new width_25p">Clave:</td> 
		<td class="table_right_new width_75p"> <input class="input_new" type="password" id="Wizard_telephone_password" maxlength="63"> </td> 
	</tr>
</table>
<table width="100%" height="40" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
  <td>
  </td> 
  </tr> 
</table> 
<table width="100%" border="0" cellspacing="1" cellpadding="0" > 
  <tr> 
    <td align="right"> 
	  <input class="menu_new" name="MdyPwdApply" id="Wizard_button3_1_button" type="button" onClick="OnStep3();"  value="Anterior"> 
      <input class="menu_new" name="MdyPwdcancel" id="Wizard_button3_2_button" type="button" onClick="OnfinishStep();"  value="Aceptar"> 
	</td> 
  </tr> 
</table> 
</div>


</div>
<script>

var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = CfgguideLgeDes[c];
}

var all = document.getElementsByTagName("input");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.value = CfgguideLgeDes[c];
}
</script>
<div style="display:none;">
<iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="../../../refresh.asp" width="100%"></iframe> 
	</div>
</body>
</html>

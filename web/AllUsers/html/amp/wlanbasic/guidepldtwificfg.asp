<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>

<title>WiFi Configuration</title>
<script language="JavaScript" type="text/javascript">

var isFireFox4 = 0;
if (navigator.userAgent.toLowerCase().indexOf('firefox/4.0') > 0)
{
    isFireFox4 = 1;
}

var enbl2G = 0;
var enbl5G = 0;
var wlan1 = null;
var wlan5 = null;
var IsSplit = 1;

var wlan5_exist = false;
var wifipwdLenArr = new Array("pwd_2g_wifipwd", "pwd_5g_wifipwd");
var wifipwdTextArr = new Array("txt_2g_wifipwd","txt_5g_wifipwd");
var wifi2g_enable;
var wifi5g_enable;
var psk1 = "";
var psk5 = "";
var urlNew = "";
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var wifiPasswordMask='<%HW_WEB_GetWlanPsdMask();%>';
var WlanTransmitPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.TransmitPower);%>';
var WlanTransmitPower5g = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.TransmitPower);%>';
var RadioEnable0  = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.1.Enable);%>;
var RadioEnable1  = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.2.Enable);%>;
var upModeType = '<%HW_WEB_GetUpLinkModeByNode();%>';
var upModeTypeDesk = '<%HW_WEB_WiFiUpLinkStatus();%>';
var IsSplit = 1;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var APType ='<%HW_WEB_GetApMode();%>'; 
var Language = '<%HW_WEB_GetCurrentLanguage();%>';
var hilinkRoll = '<%HW_WEB_GetHilinkRole();%>';
var hilinkStart = '<%HW_WEB_GetFeatureSupport(FEATURE_HILINK_START);%>';
var trimssidFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_NOT_TRIM_SSID);%>';
var isVideoRetrans = '<%HW_WEB_GetFeatureSupport(FT_WLAN_VIDEO_TRANS);%>';
var pskPsdModFlag2G = false;
var pskPsdModFlag5G = false;
var pskPsdModFlagSplit = false;
var typeWord='<%HW_WEB_GetTypeWordMode();%>';

function stModifyUserInfo(domain,UserName,UserLevel,Enable)
{
    this.domain = domain;
    this.UserName = UserName;
    this.UserLevel = UserLevel;
    this.Enable = Enable;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel|Enable, stModifyUserInfo);%>;
var Ssid1 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID);FT=HW_FT_FEATURE_PLDT%>';
var Ssid2 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.SSID);FT=HW_FT_FEATURE_PLDT%>';
var IsDoubleWifi = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);FT=HW_FT_FEATURE_PLDT%>';
var SsidPerBand = '<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>';
var WlanInfoList = '<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|SSID|X_HW_ServiceEnable|Enable,stWlanInfo);FT=HW_FT_FEATURE_PLDT%>';
var WlanInfo = eval(WlanInfoList);
if (WlanInfo == undefined) {
    WlanInfo = new Array();
}

var ssidEnd2G = SsidPerBand - 1;
var ssidStart5G = SsidPerBand;

function stWlanInfo(domain,name,ssid,X_HW_ServiceEnable,enable) {
    this.domain = domain;
    this.name = name;
    this.ssid = ssid;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.enable = enable;
}



if (hilinkStart == 0) {
    hilinkRoll = 0;
}

function stWlan(domain,ssid,name,Enable,X_HW_ServiceEnable,SSIDAdvertisementEnabled,BeaconType,BasicEncryptionModes,KeyIndex,WEPEncryptionLevel,X_HW_WPAand11iEncryptionModes, X_HW_Standard,X_HW_HT20,BasicAuthenticationMode,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,X_HW_WPAand11iAuthenticationMode,IsolationEnable,X_HW_AssociateNum,WMMEnable)
{
    this.domain = domain;
    this.ssid = ssid;
    this.name = name;
    this.Enable = Enable;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.SSIDAdvertisementEnabled = SSIDAdvertisementEnabled;
    this.BeaconType = BeaconType;
    this.BasicEncryptionModes = BasicEncryptionModes;
    this.KeyIndex = KeyIndex;
    this.WEPEncryptionLevel = WEPEncryptionLevel;
    this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;

    this.X_HW_Standard = X_HW_Standard;
    this.X_HW_HT20 = X_HW_HT20;
    this.BasicAuthenticationMode = BasicAuthenticationMode;
    this.WPAEncryptionModes = WPAEncryptionModes;
    this.WPAAuthenticationMode = WPAAuthenticationMode;
    this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
    this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
    this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
    this.X_HW_AssociateNum = X_HW_AssociateNum;
    this.IsolationEnable = IsolationEnable;
    this.WMMEnable = WMMEnable;

    this.InstId = getWlanInstFromDomain(domain);

}

var allWlanInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},SSID|Name|Enable|X_HW_ServiceEnable|SSIDAdvertisementEnabled|BeaconType|BasicEncryptionModes|WEPKeyIndex|WEPEncryptionLevel|X_HW_WPAand11iEncryptionModes|X_HW_Standard|X_HW_HT20|BasicAuthenticationMode|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iAuthenticationMode|IsolationEnable|X_HW_AssociateNum|WMMEnable,stWlan);%>;

var currChannel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_WIFIInfo.X_HW_WifiUpInfo.Channel);%>';

if(currChannel == "")
{
    var wifiType = "noAcess";
}
else if(currChannel < 15)
{
    var wifiType = "2.4G";
}
else
{
    var wifiType = "5G";
}

function ltrim(str) { 
    if (trimssidFlag == 0) {
        return str.toString().replace(/(^\s*)/g,""); 
    } else {
        return str.toString();
    } 
}

function isValPWDRule(val)
{    
    var reg = /^[A-Za-z0-9]+$/;
    if(val.match(reg))
    {
        return val;
    }
    else
    {
        return '';
    }
}

if(allWlanInfo != null && allWlanInfo.length > 1)
{
    allWlanInfo.pop();
    
    allWlanInfo.sort(function(s1, s2)
        {
            return parseInt(s1.name.charAt(s1.name.length - 1), 10) - parseInt(s2.name.charAt(s2.name.length - 1), 10);
        }
    );
}

function isValidAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch <= ' ' || ch > '~' )
        {
            return false;
        }
    }
    return true;
}

function CheckSsid(ssid)
{
    if (ssid == '') {
        alert('The SSID cannot be empty.');
        return false;
    }

    if (ssid.length > 32) {
        alert('The SSID ' + ssid + ' can contain a maximum of 32 characters.');
        return false;
    }

    if (!isValidAscii(ssid)) {
        alert('The SSID contains invalid characters.');
        return false;
    }

    return true;
}

function getWlanPortNumber(name) {
    if (name != '') {
        if(name.length > 4) {
            return parseInt(name.charAt(name.length - 2) + name.charAt(name.length - 1));    
        } else {
            return parseInt(name.charAt(name.length - 1)); 
        }
    }
}

function CheckWlanSsid(id) {
    var ssid = ltrim(getValue(id));
    if (!CheckSsid(ssid)) {
        return false;
    }

    var freq = (id == 'ssid1_name') ? '2G' : '5G';
    var index = (id == 'ssid1_name') ? 0 : ssidStart5G;

    for (var i = 0; i < WlanInfo.length - 1; i++) {
        if ((getWlanPortNumber(WlanInfo[i].name) > ssidEnd2G) && ((IsDoubleWifi == 1) && (freq == '2G'))) {
            continue;
        }
        
        if ((getWlanPortNumber(WlanInfo[i].name) <= ssidEnd2G) && ((IsDoubleWifi == 1) && (freq == '5G'))) {
            continue;
        }

        if ((getWlanPortNumber(WlanInfo[i].name) > ssidEnd2G) && ((IsDoubleWifi != 1))) {
            continue;
        }

        if (getWlanPortNumber(WlanInfo[i].name) != index) {
            if (WlanInfo[i].ssid == ssid) {
                alert('Duplicate SSID.');
                return false;
            }
        }
    }

    return true;
}

function IsValidPskKey_pldt(id)
{
    var score = 0;
    var password1 = getElementById(id).value;

    if (password1.length < 8) {
        return false;
    } else if (password1.length >= 15) {
        return true;
    }

    if (isLowercaseInString(password1)) {
        score++;
    }

    if (isUppercaseInString(password1)) {
        score++;
    }

    if (isDigitInString(password1)) {
        score++;
    }

    if (isSpecialCharacterNoSpace(password1)) {
        score++;
    }

    if (score < 3) {
        return false;
    }
    
    return true;
}

function isValidWPAPskKey(val)
{
    var ret = false;
    var len = val.length;
    var maxSize = 64;
    var minSize = 8;
    if (!isValidAscii(val))
    {
       return false;
    }
    if ( len >= minSize && len < maxSize )
    {      
        ret = true;
    }
    else if ( len == maxSize )
    {
        for ( i = 0; i < maxSize; i++ )
            if ( isHexaDigit(val.charAt(i)) == false )
                break;
        if ( i == maxSize )
            ret = true;
    }
    else
    {      
        ret = false;
    }
    return ret;
}

function CheckWiFiParameter() 
{
    if (!CheckWlanSsid('txt_2g_wifiname')) {
        return false;
    }

    if (!isValidWPAPskKey("pwd_2g_wifipwd")) {
        alert("The wifi password of " + getElById('txt_2g_wifiname').value + " must be between 8 and 63 characters or 64 hexadecimal characters.");
        return false;
    }

    if (!IsValidPskKey_pldt('pwd_2g_wifipwd')) {
        alert("The wifi password of "+ getElById('txt_2g_wifiname').value +" must be at least 8 characters long and must contain three the following: uppercase characters, lowercase characters, digits (0-9), special characters or length contains 15 characters.");
        return false;
    }

    var password1 = getElementById("pwd_2g_wifipwd").value
    var confirmPassword1 = getElementById("pwd_2g_confirmpwd").value
    if (password1 != confirmPassword1) {
        alert("The confirm password of " + getElById('txt_2g_wifiname').value + " is different from the WiFi password.");
        return false;
    }

    var enable = document.getElementById('band_sterring_enable').checked
    if (!enable && (IsDoubleWifi == 1)) {
        if (!CheckWlanSsid('txt_5g_wifiname')) {
            return false;
        }

        if (!isValidWPAPskKey('pwd_5g_wifipwd')) {
            alert("The wifi password of "+ getElById('txt_5g_wifiname').value +" must be between 8 and 63 characters or 64 hexadecimal characters.");
            return false;
        }

        if (!IsValidPskKey_pldt('pwd_5g_wifipwd')) {
            alert("The wifi password of "+ getElById('txt_5g_wifiname').value +" must be at least 8 characters long and must contain three the following: uppercase characters, lowercase characters, digits (0-9), special characters or length contains 15 characters.");
            return false;
        }

        var password2 = getElementById("pwd_5g_wifipwd").value
        var confirmPassword2 = getElementById("pwd_5g_confirmpwd").value
        if (password2 != confirmPassword2) {
            alert("The confirm password of " + getElById('txt_5g_wifiname').value + "  is different from the WiFi password.");
            return false;
        }

        if (getValue("txt_5g_wifiname") == getValue("txt_2g_wifiname")) {
            alert("If the 2.4G and 5G Wi-Fi names are the same, turn on the dual-band combination function.");
			return false;
		}
    }

    return true;
}

function getWlan()
{
    wlan1 = getFirstSSIDInst(1, allWlanInfo);
	if (wlan1 != null) {
        convStdAuthMode(wlan1);
	}
    wlan5 = getFirstSSIDInst(2, allWlanInfo);
    if (wlan5 != null) {
        convStdAuthMode(wlan5);
    }
}
function judgeIsSplit()
{
    if (RadioEnable0 != RadioEnable1) {
        IsSplit = 0;
        return;
    }
    if (wlan1.Enable != wlan5.Enable) {
        IsSplit = 0;
        return;
    }
    if (wlan1.ssid != wlan5.ssid) {
        IsSplit = 0;
        return;
    }
    if (wlan1.BeaconType != wlan5.BeaconType) {
        IsSplit = 0;
        return;
    }
}
function SetBandSteeringState()
{
    if (IsSplit == 1) {
        document.getElementById('tb_SSIDName2G_label').innerHTML = 'WiFi SSID:';
        document.getElementById('tb_5g_enable').style.display = 'none';

        getElById('txt_2g_wifiname').value = Ssid1;
        getElementById("band_sterring_enable").checked = true;
    } else {
        document.getElementById('tb_SSIDName2G_label').innerHTML = '2.4G WiFi SSID:';
        document.getElementById('tb_5g_enable').style.display = 'block';

        getElById('txt_2g_wifiname').value = Ssid1;
        getElById('txt_5g_wifiname').value = Ssid2;
        getElementById("band_sterring_enable").checked = false;
    }

}

function LoadFrame()
{
    getWlan();
    document.getElementById('wifiCfgApMainDiv').style.display = 'block';
    judgeIsSplit()
    SetBandSteeringState();

    return;
}

function SetDoneGuideFlag()
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : '/smartguide.cgi?1=1&RequestFile=html/amp/wlanbasic/guidepldtwificfg.asp',
        data:'Parainfo='+'1',
        success : function(data) {
            ;
        }
    });
    
}

var urlNew = "";
function addRadioEnableParaBoth(Form)
{
	Form.addParameter('r1.Enable',1);
	Form.addParameter('r2.Enable',1);
	urlNew += 'r1=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1&';
	urlNew += 'r2=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2&';
}
function SubmitForm() 
{
    if (!CheckWiFiParameter()) {
        return false;
    }

    var urlStr = 'MdfPwdNormalNoLg.cgi?';
    if (curUserType == 0) {
        urlStr = 'MdfPwdAdminNoLg.cgi?';
    }

    SetDoneGuideFlag();
    var paralist = "";

    var enable = document.getElementById('band_sterring_enable').checked
    if (enable) {
        var wlancover = "z=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&";
        urlStr += wlancover;

        var ssid = getValue("txt_2g_wifiname");
        paralist += "z.BeaconType=11i&z.IEEE11iEncryptionModes=AESEncryption&z.IEEE11iAuthenticationMode=PSKAuthentication&z.BeaconType5G=11i&z.IEEE11iEncryptionModes5G=AESEncryption&z.IEEE11iAuthenticationMode5G=PSKAuthentication&z.SSID=" + ssid + "&z.SSID5G=" + ssid +"&z.SsidInst=1&z.SsidInst5G=5&z.Enable=1&z.Enable5G=1&";
        paralist += "x.PreSharedKey=" + getValue('pwd_2g_wifipwd') + "&y.PreSharedKey=" + getValue('pwd_2g_wifipwd') +
        "&m.SSID=" + getValue('txt_2g_wifiname') + "&n.SSID=" + getValue('txt_2g_wifiname') +
        "&m.BeaconType=11i&m.IEEE11iEncryptionModes=AESEncryption&m.IEEE11iAuthenticationMode=PSKAuthentication&n.BeaconType=11i&n.IEEE11iEncryptionModes=AESEncryption&n.IEEE11iAuthenticationMode=PSKAuthentication&m.Enable=1&n.Enable=1"

    } else {
        paralist += "x.PreSharedKey=" + getValue('pwd_2g_wifipwd') +"&y.PreSharedKey=" + getValue('pwd_5g_wifipwd') + "&m.SSID=" + getValue('txt_2g_wifiname') +
        "&n.SSID=" + getValue('txt_5g_wifiname');
    }


    paralist += "&x.X_HW_Token=" + getValue('onttoken');

    $.ajax({
		type : "POST",
		async : false,
		cache : false,
		data: paralist,
		url : urlStr +'x=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1&y=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.PreSharedKey.1&'+ urlNew +'m=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1&n=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5&RequestFile=/html/amp/wlanbasic/guidepldtwificfg.asp',
		success : function(data) {
            window.location.href ="/index.asp"
		}
	});
}

function Cancel()
{
    SetDoneGuideFlag();

    window.location="/index.asp";
}

function EnableBandSteering()
{
    var enable = document.getElementById('band_sterring_enable').checked
    if (enable) {
        document.getElementById('tb_SSIDName2G_label').innerHTML = 'WiFi SSID:';
        document.getElementById('tb_5g_enable').style.display = 'none';
    } else {
        document.getElementById('tb_SSIDName2G_label').innerHTML = '2.4G WiFi SSID:';
        document.getElementById('tb_5g_enable').style.display = 'block';
        getElById('txt_5g_wifiname').value = getValue('txt_2g_wifiname') + "_5G";
        document.getElementById('tb_SSIDName2G_label').innerHTML = '2.4G WiFi SSID:';
    }

}

</script>
<style>
html {
    height: 100%;
}
body {
    background-color: #EDF1F2;
    text-align: right;
    height: calc(100% - 60px);
}
#band_sterring_2G_5G {
    padding-left: 56px;
}
tr {
    height: 30px;
    line-height: 30px;
}
.tb_radio {
    height: 30px;
    width: 50px;
    background-repeat: no-repeat;
}
.tb_radio_close {
    height: 30px;
    width: 50px;
    background-repeat: no-repeat;
}
.splitEnableNote {
    font-size:12px;
    color:gray;
    line-height:18px;
    width:310px;
}
.font-dir {
    direction: rtl;
}

body, td, div, textarea, input, select {
    font-family: "Arial", "";
    font-size: 17px;
}
#wifimain {
    width: 1100px;
    margin: 60px auto 0;
    position: relative;
}
#pwd_label {
text-align: left;
}
button {
    width: auto;
    min-width: 60px;
    padding: 5px 10px;
}
</style>
</head>
<body onLoad="LoadFrame();" >
<div id="wifimain">    
<div id="pwd_label" style="font-size: 15px;color: red;">
    Recommend to enable Band steering for better internet experience. Band steering will utilize the less crowded 5 GHz WiFi band resulting to less radio interference.
</div>

<div class="bodyStyle" id='wifiCfgApMainDiv' style='display:none;'>
<div id="band_sterring_2G_5G" >
<table id="tb_2g" border="0" cellpadding="3" cellspacing="1" style="margin-left: 56px;margin-top: 10px;">
    <tr>
        <td class="tb_label">
            <span>Band steering</span>
        </td>
        <td>
            <input id="band_sterring_enable" style="margin-right: 36px;" class="band_sterring_enable" type="checkbox" onClick="EnableBandSteering(this.id)"></input>
        </td>
    </tr>
</table>

<table id="tb_2g_enable" border="0" cellpadding="3" cellspacing="1" style="margin-left: 20px;">    
    <tr id='tb_SSIDName2G'>
        <td class="tb_label" id='tb_SSIDName2G_label'>
            <span>2.4G WiFi SSID:</span>
        </td>
        <td>
            <input type="text" name="txt_2g_wifiname" id="txt_2g_wifiname" class="input_con_text" maxlength="32" style="width:283px;">
        </td>
    </tr>

    <tr id='tb_pwd_2g'>
        <td class="tb_label">
            <span>WiFi Password:</span>
        </td>
        <td> 
            <input type="password" autocomplete="off" name="pwd_2g_wifipwd" id="pwd_2g_wifipwd" maxlength="64" style="width:253px;padding-right:30px;" class="input_con_text">
        </td>
    </tr>

    <tr id='tb_confirmPwd_2g'>
        <td class="tb_label">
            <span>Confirm Password:</span>
        </td>
        <td> 
            <input type="password" autocomplete="off" name="pwd_2g_confirmpwd" id="pwd_2g_confirmpwd" maxlength="64" style="width:253px;padding-right:30px;" class="input_con_text">
        </td>
    </tr>
</table>

<table id="tb_5g_enable" border="0" cellpadding="3" cellspacing="1" style="margin-left: 20px;">    
    <tr id='tb_SSIDName5G'>
        <td class="tb_label">
            <span>5G WiFi SSID:</span>
        </td>
        <td>
            <input type="text" name="txt_5g_wifiname" id="txt_5g_wifiname" class="input_con_text" maxlength="32" style="width:283px;">
        </td>
        
    </tr>
    <tr id='tb_pwd_5g'>
        <td class="tb_label">
            <span>WiFi Password:</span>
        </td>
        <td>
            <input type="password" autocomplete="off" name="pwd_5g_wifipwd" id="pwd_5g_wifipwd" maxlength="64" style="width:253px;padding-right:30px;" class="input_con_text">
        </td>
    </tr>
    <tr id='tb_confirmPwd_5g'>
        <td class="tb_label">
            <span>Confirm Password:</span>
        </td>
        <td>
            <input type="password" autocomplete="off" name="pwd_5g_confirmpwd" id="pwd_5g_confirmpwd" maxlength="64" style="width:253px;padding-right:30px;" class="input_con_text">
        </td>
    </tr>
</table>
</div>

<div id="band_sterring_label" style="margin-right: 100px;">
    <ul style="position:absolute; clear:both; list-style-type: none; top: 32px; left: 282px; height: 12px; line-height:23px">
        <li style="position: absolute; top: 20px; width: 280px;font-size: 12px; left: inherit;" >
            <div align="left"  style="font-size: 15px;">
            1.The Wi-Fi password must contain at least 8 characters.<br/> 2.The Wi-Fi password must contain at least three of the following characters: uppercase letters, lowercase letters, digits, and special characters or contain at least 15 characters.
            </div>
        </li>
    </ul>
</div>
<div class="title_spread" style="height: 16px;"></div>
<div align="center">
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
<table id="apply_button" style=" height: 20px;width: 100%;">
    <tr>
        <td></td>
        <td style="width: 10%;">
            <button id="btnSave" type="button" class="Nextbuttoncss saveBtnStyle"  style="height:30px;"  onClick="SubmitForm();" value="保存">
                <span>Apply</span>
            </button>
        </td>
      
        <td style="width: 10%;">
            <button id="btnSave" type="button" class="Nextbuttoncss saveBtnStyle"  style="height:30px;"  onClick="Cancel();" value="保存">
                <span>Cancel</span>
            </button>
        </td>
        <td style="width: 50%;"></td>
    </tr>
</table>
</div>
</div>
</div>
</body>
</html>

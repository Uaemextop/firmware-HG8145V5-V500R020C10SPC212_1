<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet" type="text/css" href="/Cuscss/<%HW_WEB_GetCusSource(mainpage_new.css);%>" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>


<style>
input.cmn-toggle-round+label {
    padding: 2px;
    width: 45px;
    height: 20px;
    background-color: #dddddd;
    border-radius: 10px;
}

input.cmn-toggle-round:checked+label:after {
    margin-left: 24px;
}

div.wlan_div_style5{
    text-align: left;
    margin-left:50%;
    width: 20%;
}

.table_right1 
{
    background-color: #FFFFFF;
    padding-left: 40px;
    height: 35px;
    line-height: 150%;
    font-size:14px;
    font-family:"微软雅黑";
    color:#333333;
}
.table_right2
{
    background-color: #FFFFFF;
    padding-left: 30px;
    height: 35px;
    line-height: 150%;
    font-size:14px;
    font-family:"微软雅黑";
    color:#333333;
}
</style>
<script language="JavaScript" type="text/javascript">
var trimBsdSsidFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_NOT_TRIM_SSID);%>';
var aisApBackhaul = '<%HW_WEB_GetFeatureSupport(FT_WLAN_AISAP);%>';

var backupenable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_AIS_Backup.Enable);%>';;

function bandSteeringInfo(domain, enableSSID1_5, enableSSID2_6, enableSSID3_7, enableSSID4_8, nameSSID1_5, nameSSID2_6, nameSSID3_7, nameSSID4_8)
{
    this.domain = domain;
    this.enableSSID1_5 = enableSSID1_5;
    this.enableSSID2_6 = enableSSID2_6;
    this.enableSSID3_7 = enableSSID3_7;
    this.enableSSID4_8 = enableSSID4_8;
    this.nameSSID1_5   = nameSSID1_5;
    this.nameSSID2_6   = nameSSID2_6;
    this.nameSSID3_7   = nameSSID3_7;
    this.nameSSID4_8   = nameSSID4_8;
}

var BSDInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_AIS_BandSteering,SSID1-5_enable|SSID2-6_enable|SSID3-7_enable|SSID4-8_enable|SSID1-5_name|SSID2-6_name|SSID3-7_name|SSID4-8_name, bandSteeringInfo);%>;
var BSDInfo = BSDInfos[0];


function wlanInfo(domain, enable)
{
    this.domain = domain;
    this.enable = enable;
}

var wlanInfos = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Enable,wlanInfo);%>;


var ssid1enable = 0;
var ssid2enable = 0;
var ssid3enable = 0;
var ssid4enable = 0;
var ssid5enable = 0;
var ssid6enable = 0;
var ssid7enable = 0;
var ssid8enable = 0;

function getWlanInstFromDomain(domain)
{
    if ('' != domain)
    {
        var array = domain.split('.');
        var str = array[4];
        
        return (parseInt(str));
    }
}

for (var i = 0; i < wlanInfos.length - 1; i++) {
    var wlanInst = getWlanInstFromDomain(wlanInfos[i].domain);
    switch (wlanInst) 
    {
        case 1:
            ssid1enable =  wlanInfos[i].enable;
            break;
        case 2:
            ssid2enable =  wlanInfos[i].enable;
            break;
        case 3:
            ssid3enable =  wlanInfos[i].enable;
            break;
        case 4:
            ssid4enable =  wlanInfos[i].enable;
            break;
        case 5:
            ssid5enable =  wlanInfos[i].enable;
            break;
        case 6:
            ssid6enable =  wlanInfos[i].enable;
            break;
        case 7:
            ssid7enable =  wlanInfos[i].enable;
            break;
        case 8:
            ssid8enable =  wlanInfos[i].enable;
            break;
        default:
            break;

    }
}

function ltrim(str)
{
    if (trimBsdSsidFlag == 0) {
        return str.toString().replace(/(^\s*)/g,"");
    } else {
        return str.toString();
    }
}


function setBSDInfo()
{
    setCheck('enableSSID1_5', BSDInfo.enableSSID1_5)
    setText('nameSSID1_5',BSDInfo.nameSSID1_5);
    setCheck('enableSSID2_6', BSDInfo.enableSSID2_6);
    setText('nameSSID2_6',BSDInfo.nameSSID2_6);
    setCheck('enableSSID3_7', BSDInfo.enableSSID3_7)
    setText('nameSSID3_7',BSDInfo.nameSSID3_7);
    setCheck('enableSSID4_8', BSDInfo.enableSSID4_8);
    setText('nameSSID4_8',BSDInfo.nameSSID4_8);
}

function setBSDEnableDisplay(ssid2gEnable, ssid5gEnable, id)
{
    if ((ssid2gEnable == 1) && (ssid5gEnable == 1)) {
        setDisable(id, 0);
    } else {
        setDisable(id, 1);
    }
}

function setBSDNameDisplay(bsdEnable, id)
{
    if (bsdEnable == 1) {
        setDisable(id, 0);
    } else {
        setDisable(id, 1);
    }
}


function LoadFrame()
{
    setBSDInfo();
   setBSDEnableDisplay(ssid1enable, ssid5enable, "enableSSID1_5");
   setBSDEnableDisplay(ssid2enable, ssid6enable, "enableSSID2_6");
   setBSDEnableDisplay(ssid3enable, ssid7enable, "enableSSID3_7");
   setBSDEnableDisplay(ssid4enable, ssid8enable, "enableSSID4_8");
   setBSDNameDisplay(BSDInfo.enableSSID1_5, "nameSSID1_5");
   setBSDNameDisplay(BSDInfo.enableSSID2_6, "nameSSID2_6");
   setBSDNameDisplay(BSDInfo.enableSSID3_7, "nameSSID3_7");
   setBSDNameDisplay(BSDInfo.enableSSID4_8, "nameSSID4_8");

   if (aisApBackhaul != 1) {
       setDisplay("bsdssid4_8", 0);
   }
}

function BSDEnableSwitch(bsdSsidId)
{ 
    var enable = getCheckVal(bsdSsidId);
    var bsdNameId = bsdSsidId.replace("enable","name");
    var bsdStatus = bsdSsidId.replace("enable","status");

    if (enable) {
        setDisable(bsdNameId, 0);
        document.getElementById(bsdStatus).innerHTML = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Enable'];
    } else {
        setDisable(bsdNameId, 1);
        document.getElementById(bsdStatus).innerHTML = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Disable'];
        var nameValue = BSDInfo.nameSSID1_5;
        if (bsdNameId == "nameSSID2_6") {
            nameValue = BSDInfo.nameSSID2_6;
        } else if (bsdNameId == "nameSSID3_7") {
            nameValue = BSDInfo.nameSSID3_7;
        } else if (bsdNameId == "nameSSID4_8") {
            nameValue = BSDInfo.nameSSID4_8;
        }
        setText(bsdNameId, nameValue);
    }
}

function BSDssidNameCheck(bsdSsidName)
{
    var ssidName = ltrim(bsdSsidName);
    if (ssidName == '') {
        AlertEx(cfg_wlanbandsteering_language['amp_wlan_bangsteering_empty_ssid']);
        return false;
    }

    if (ssidName.length > 32) {
        AlertEx(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssid_check'] + ssidName + cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssid_too_loog']);
        return false;
    }

    if (isValidAscii(ssidName) != '') {
        AlertEx(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssid_check'] + ssidName + cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssid_invalid'] + isValidAscii(ssidName));
        return false;
    }
    return true;
}

function ApplySubmit()
{
    var num = 3;
    if (aisApBackhaul == 1) {
        num = 4;
    }

    for (var i = 1, j = 5; i <= num; i++, j++) {
        var bsdSsidName = getValue('nameSSID' + i + '_' + j);
        if (BSDssidNameCheck(bsdSsidName) == false) {
            return;
        }
    }

    var Form = new webSubmitForm();
    var RequestFile = "html/amp/wlanbasic/bandsteering.asp";
    var enable1_5 = getCheckVal('enableSSID1_5');
    var enable2_6 = getCheckVal('enableSSID2_6');
    var enable3_7 = getCheckVal('enableSSID3_7');
    var enable4_8 = getCheckVal('enableSSID4_8');

    Form.addParameter('x.SSID1-5_enable', enable1_5);
    Form.addParameter('x.SSID2-6_enable', enable2_6);
    Form.addParameter('x.SSID3-7_enable', enable3_7);
    if (aisApBackhaul == 1) {
        Form.addParameter('x.SSID4-8_enable', enable4_8);
    }

    if (enable1_5 == 1) {
        Form.addParameter('x.SSID1-5_name', ltrim(getValue('nameSSID1_5')));
    }
    if (enable2_6 == 1) {
        Form.addParameter('x.SSID2-6_name', ltrim(getValue('nameSSID2_6')));
    }
    if (enable3_7 == 1) {
        Form.addParameter('x.SSID3-7_name', ltrim(getValue('nameSSID3_7')));
    }
    if (aisApBackhaul == 1) {
        if (enable4_8 == 1) {
            Form.addParameter('x.SSID4-8_name', ltrim(getValue('nameSSID4_8')));
        }
    }

    url = 'set.cgi?x=InternetGatewayDevice.X_AIS_BandSteering'
        + '&RequestFile=' + RequestFile;
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    setDisable('btnApplySubmit',1);
    Form.setAction(url);
    Form.submit();
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr></table>  
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("bandsteering", GetDescFormArrayById(cfg_wlanbandsteering_language, "amp_wlan_bangsteering_title"), GetDescFormArrayById(cfg_wlanbandsteering_language, "amp_wlan_bangsteering_description"), false);
</script>

<div class="title_spread"></div>
<table>
    <tr>
        <td class="table_title"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_SSID1_5']);</script></td>
        <td>
            <div class="wlan_div_style5">
                <input id="enableSSID1_5" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='BSDEnableSwitch(this.id);'>
                <label for="enableSSID1_5"></label>
            </div>
        </td>
        <td id="statusSSID1_5" class="table_right1">
            <script>
                var bsdStatus1_5 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Disable'];
                if (BSDInfo.enableSSID1_5 == 1) {
                    bsdStatus1_5 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Enable'];
                }
                document.write(bsdStatus1_5);
            </script>
        </td>
        <td class="table_right2"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssidname']);</script></td>
        <td class="table_right">
            <script language="JavaScript" type="text/javascript">
                document.write('<input type="text" name="nameSSID1_5" id="nameSSID1_5" style="width:123px" maxlength="32">');
            </script>  
        </td>
    </tr>
    <tr>
        <td class="table_title"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_SSID2_6']);</script></td>
        <td>
            <div class="wlan_div_style5">
                <input id="enableSSID2_6" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='BSDEnableSwitch(this.id);'>
                <label for="enableSSID2_6"></label>
            </div>
        </td>
        <td id="statusSSID2_6" class="table_right1">
            <script>
                var bsdStatus2_6 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Disable'];
                if (BSDInfo.enableSSID2_6 == 1) {
                    bsdStatus2_6 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Enable'];
                }
                document.write(bsdStatus2_6);
            </script>
        </td>
        <td class="table_right2"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssidname']);</script></td>
        <td class="table_right">
            <script language="JavaScript" type="text/javascript">
                document.write('<input type="text" name="nameSSID2_6" id="nameSSID2_6" style="width:123px" maxlength="32">');
            </script>
        </td>
    </tr>
    <tr id="bsdssid3_7">
        <td class="table_title"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_SSID3_7']);</script></td>
        <td>
            <div class="wlan_div_style5">
                <input id="enableSSID3_7" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='BSDEnableSwitch(this.id);'>
                <label for="enableSSID3_7"></label>
            </div>
        </td>
        <td id="statusSSID3_7" class="table_right1">
            <script>
                var bsdStatus3_7 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Disable'];
                if (BSDInfo.enableSSID3_7 == 1) {
                    bsdStatus3_7 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Enable'];
                }
                document.write(bsdStatus3_7);
            </script>
        </td>
        <td class="table_right2"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssidname']);</script></td>
        <td class="table_right">
            <script language="JavaScript" type="text/javascript">
                document.write('<input type="text" name="nameSSID3_7" id="nameSSID3_7" style="width:123px" maxlength="32">');
                if (aisApBackhaul == 1 && backupenable == 1) {
                    $("#bsdssid3_7").attr("style","display:none");
                }
            </script>
        </td>
    </tr>
    <tr id="bsdssid4_8">
        <td class="table_title"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_SSID4_8']);</script></td>
        <td>
            <div class="wlan_div_style5">
                <input id="enableSSID4_8" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='BSDEnableSwitch(this.id);'>
                <label for="enableSSID4_8"></label>
            </div>
        </td>
        <td id="statusSSID4_8" class="table_right1">
            <script>
                var bsdStatus4_8 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Disable'];
                if (BSDInfo.enableSSID4_8 == 1) {
                    bsdStatus4_8 = cfg_wlanbandsteering_language['amp_wlan_bangsteering_Enable'];
                }
                document.write(bsdStatus4_8);
            </script>
        </td>
        <td class="table_right2"><script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_ssidname']);</script></td>
        <td class="table_right">
            <script language="JavaScript" type="text/javascript">
                document.write('<input type="text" name="nameSSID4_8" id="nameSSID4_8" style="width:123px" maxlength="32">');
            </script>
        </td>
    </tr>
</table>
<tr>
    <td>
    </td>
</tr>
<table width="100%" border="0" cellpadding="0" cellspacing="0"  >
    <tr>
        <td class="table_submit width_per25"></td>
        <td class="table_submit">
            <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <button id="btnApplySubmit" name="btnApplySubmit" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="ApplySubmit();">
            <script>document.write(cfg_wlanbandsteering_language['amp_wlan_bangsteering_apply']);</script></button>
        </td>
    </tr>
</table>
</body>
</html>


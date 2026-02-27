<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="JavaScript" type="text/javascript">

var indexSSID = 0;
var totalSSID2gNum;
var totalSSID5gNum;
var newIndex;
var addFlags = false;
var radiuspassword;

function stISPPara(domain, SSID_IDX, PortIsolation, WifiShareMaxClientNumber, SSID, AuthenticationMode, RadiusServer, RadiusKey, RadiusAuthenticationPort, 
                    RadiusAccountPort, RadiusAccountEnable, UpRateLimit, DownRateLimit, KickRssiThreshold, AccessRssiThreshold) {
    this.domain = domain;
    this.SSID_IDX = SSID_IDX;
    this.PortIsolation = PortIsolation;
    this.WifiShareMaxClientNumber = WifiShareMaxClientNumber;
    this.SSID = SSID;
    this.AuthenticationMode = AuthenticationMode;
    this.RadiusServer = RadiusServer;
    this.RadiusKey = RadiusKey;
    this.RadiusAuthenticationPort = RadiusAuthenticationPort;
    this.RadiusAccountPort = RadiusAccountPort;
    this.RadiusAccountEnable = RadiusAccountEnable;
    this.UpRateLimit = UpRateLimit;
    this.DownRateLimit = DownRateLimit;
    this.KickRssiThreshold = KickRssiThreshold;
    this.AccessRssiThreshold = AccessRssiThreshold;
}

function stWlan(domain, Name, SSID, RadiusKey) {
    this.domain = domain;
    this.Name = Name;
    this.SSID = SSID;
    this.RadiusKey = RadiusKey;
}

var isaPara = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i}, SSID_IDX|PortIsolation|WifiShareMaxClientNumber|SSID|AuthenticationMode|RadiusServer|RadiusKey|RadiusAuthenticationPort|RadiusAccountPort|RadiusAccountEnable|UpRateLimit|DownRateLimit|KickRssiThreshold|AccessRssiThreshold, stISPPara,EXTEND);%>;

var wlanArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|SSID|X_HW_RadiusKey,stWlan);%>;

function LoadFrame() {
    Total2gNum();
    setDisplay('addDivForm', 0);
    setDisplay("selectline_new", 0);
    if (isaPara.length - 1 == 0) {
        setDisplay('divTableSwitchForm', 0);
        setDisplay('publicwifiConfig', 0);
    } else {
        setSelected(0);
        setDisplay('divTableSwitchForm', 1);
        setDisplay('publicwifiConfig', 1);
    }
}

function Total2gNum() {
    totalSSID2gNum = 0;
    totalSSID5gNum = 0;

    for (var loop = 0; loop < wlanArr.length - 1; loop++) {
        if (wlanArr[loop].Name == '') {
            continue;
        }

        if ((getWlanPortNumber(wlanArr[loop].Name) > ssidEnd2G) && (getWlanPortNumber(wlanArr[loop].Name) < 2*ssidStart5G)) {
            totalSSID5gNum++;
        } else if ((getWlanPortNumber(wlanArr[loop].Name) >= ssidStart2G) && (getWlanPortNumber(wlanArr[loop].Name) <= ssidEnd2G)) {
            totalSSID2gNum++;
        } else {

        }
    }
}

function findAddIndex() {
    for (var j = 1; j <= wlanArr.length; j++) {
        var isTheSame = 0;
        for (var i = 0; i < wlanArr.length - 1; i++) {
            if (j == getWlanInstFromDomain(wlanArr[i].domain)) {
                isTheSame = 1;
                break;
            }
        }

        if (isTheSame == 0) {
            newIndex = j;
            return;
        }

        if (j == wlanArr.length) {
            newIndex = j;
            return;
        }
    }
}

function addCheckForm() {
    if ((getValue('addSSID') == '') || (getValue('addAccessRssiThreshold') == '') || (getValue('addKickRssiThreshold') == '')) {
        AlertEx(cfg_wlancfgother_language['amp_empty_para']);
        return false;
    }

    if ((getValue('addAccessRssiThreshold') < -100) || (getValue('addAccessRssiThreshold') > 0) || (getValue('addKickRssiThreshold') < -100) || (getValue('addKickRssiThreshold') > 0)) {
        AlertEx(cfg_public_wifi_language['public_wifi_invalid_para']);
        return false;
    }

    if ((getSelectVal('addFreq') == '2G') && (totalSSID2gNum == 4)) {
        AlertEx(cfg_public_wifi_language['public_wifi_2G_maximum']);
        return false;
    } else if ((getSelectVal('addFreq') == '5G') && (totalSSID5gNum == 4)) {
        AlertEx(cfg_public_wifi_language['public_wifi_5G_maximum']);
        return false;
    }

    return true;
}

function zwaveAdd() {
    var lowerLayer = getSelectVal('addFreq');
    var Form = new webSubmitForm();
    var wlanDomain;
    var thisNode = (lowerLayer == '2G') ? node2G : node5G;

    if (addCheckForm(Form) == false) {
        return;
    }
    findAddIndex();

    Form.addParameter('y.LowerLayers', thisNode);
    Form.addParameter('y.SSID', getValue('addSSID'));
    Form.addParameter('y.Enable', 1);
    Form.addParameter('y.X_HW_AssociateNum', 8);
    Form.addParameter('z.SSID_IDX', newIndex);
    Form.addParameter('z.SSID', getValue('addSSID'));
    Form.addParameter('z.WifiShareMaxClientNumber', 8);
    Form.addParameter('z.KickRssiThreshold', getValue('addKickRssiThreshold'));
    Form.addParameter('z.AccessRssiThreshold', getValue('addAccessRssiThreshold'));

    Form.setAction('add.cgi?y=InternetGatewayDevice.LANDevice.1.WLANConfiguration&z=InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP'
                                       + '&RequestFile=html/amp/wlanbasic/publicwifi.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function clickRemove() {
    if (addFlags == true) {
       AlertEx(cfg_wlancfgother_language['amp_ssid_del']);
       return;
    }

    var rml = getElement('rml');
    var noChooseFlag = true;
    if (rml.length > 0) {
        var delIndex = new Array();
        var loop = 0;
        for (var i = 0; i < rml.length; i++) {
            if (rml[i].checked == true) {
                noChooseFlag = false;
                delIndex[loop++] = rml[i].value;
            }
        }
    } else if (rml.checked == true) {
        noChooseFlag = false;
        var delIndex = rml.value;
    }

    if (noChooseFlag) {
        AlertEx(cfg_wlancfgother_language['amp_ssid_select']);
        return ;
    }

    if (ConfirmEx(cfg_wlancfgother_language['amp_delssid_confirm']) == false) {
        document.getElementById("DeleteButton").disabled = false;
        return;
    }

    var Form = new webSubmitForm();

    if (rml.length > 0) {
        var IspDomain = new Array();
        var wlanDomain = new Array();
        for (var i = 0; i < delIndex.length; i++) {
            var delIndexNum = delIndex[i];
            IspDomain[i] = isaPara[delIndexNum].domain;
            wlanDomain[i] = "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + isaPara[delIndexNum].SSID_IDX;
            Form.addParameter(IspDomain[i], '');
            Form.addParameter(wlanDomain[i], '');
        }
    } else {
        var IspDomain = isaPara[delIndex].domain;
        var wlanDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + isaPara[delIndex].SSID_IDX;
        Form.addParameter(IspDomain, '');
        Form.addParameter(wlanDomain, '');
    }
    Form.setAction('del.cgi?RequestFile=html/amp/wlanbasic/publicwifi.asp');
    setDisable('applyButton',1);
    setDisable('cancelButton',1);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function checkForm() {
    if ((getValue('SSID') == '') || (getValue('WifiShareMaxClientNumber') == '') || (getValue('KickRssiThreshold') == '') ||
        (getValue('AccessRssiThreshold') == '') || (getValue('UpRateLimit') == '') || (getValue('DownRateLimit') == '')) {
        AlertEx(cfg_wlancfgother_language['amp_empty_para']);
        return false;
    }

    if (getSelectVal("AuthenticationMode") == "802.1x-EAP") {
        if ((getValue('RadiusServer') == '') || (getValue('twlRadiusKey') == '') || (getValue('RadiusAuthenticationPort') == '') || (getValue('RadiusAccountPort') == '')) {
            AlertEx(cfg_wlancfgother_language['amp_empty_para']);
            return false;
        }

        if ((getValue('RadiusAuthenticationPort') < 0) || (getValue('RadiusAuthenticationPort') > 65535) || (getValue('RadiusAccountPort') < 0) || (getValue('RadiusAccountPort') > 65535)) {
            AlertEx(cfg_public_wifi_language['public_wifi_invalid_para']);
            return false;
        }
    }

    if ((getValue('UpRateLimit') < 0) || (getValue('UpRateLimit') > 65535) || (getValue('DownRateLimit') < 0) || (getValue('DownRateLimit') > 65535)) {
        AlertEx(cfg_public_wifi_language['public_wifi_invalid_para']);
        return false;
    }

    if ((getValue('KickRssiThreshold') < -100) || (getValue('KickRssiThreshold') > 0) || (getValue('AccessRssiThreshold') < -100) || (getValue('AccessRssiThreshold') > 0)) {
        AlertEx(cfg_public_wifi_language['public_wifi_invalid_para']);
        return false;
    }

    if ((getValue('WifiShareMaxClientNumber') < 1) || (getValue('WifiShareMaxClientNumber') > 8)) {
        AlertEx(cfg_public_wifi_language['public_wifi_invalid_para']);
        return false;
    }

    return true;
}

function zwaveSet() {
    if (!checkForm()) {
        return;
    }

    var Form = new webSubmitForm();

    Form.addParameter('y.SSID', getValue('SSID'));
    Form.addParameter('y.AuthenticationMode', getSelectVal("AuthenticationMode"));
    Form.addParameter('y.WifiShareMaxClientNumber', getValue('WifiShareMaxClientNumber'));
    Form.addParameter('y.KickRssiThreshold', getValue('KickRssiThreshold'));
    Form.addParameter('y.AccessRssiThreshold', getValue('AccessRssiThreshold'));
    Form.addParameter('y.UpRateLimit', getValue('UpRateLimit'));
    Form.addParameter('y.DownRateLimit', getValue('DownRateLimit'));

    if (getSelectVal("AuthenticationMode") == "802.1x-EAP") {
        Form.addParameter('y.RadiusServer', getValue('RadiusServer'));
        Form.addParameter('y.RadiusKey', getValue('twlRadiusKey'));
        Form.addParameter('y.RadiusAuthenticationPort', getValue('RadiusAuthenticationPort'));
        Form.addParameter('y.RadiusAccountPort', getValue('RadiusAccountPort'));
        Form.addParameter('y.RadiusAccountEnable', getCheckVal('RadiusAccountEnable'));
    }

    Form.setAction('set.cgi?y=' + isaPara[indexSSID].domain + '&RequestFile=html/amp/wlanbasic/publicwifi.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    setDisable('applyButton', 1);
    setDisable('cancelButton', 1);    
    Form.submit();
}

function zwaveCancel() {
    LoadFrame();
}

function clickNewTitle() {
    setDisplay("selectline_new", 1);
    for (var i = 0;i < isaPara.length - 1; i++) {
        getElById('selectline_'+ i).style.background = '#f2f2f2';
    }
}

function addISPAttr() {
    if (wlanArr.length - 1 > 7) {
        AlertEx(cfg_wlancfgother_language['amp_ssid_4max']);
        return;
    }
    setDisplay("addDivForm", 1);
    setDisplay("divTableSwitchForm", 0);
    addFlags =  true;
    clickNewTitle();
}

function wlanWriteTabHeader(tabTitle, width, titleWidth, type)
{
    if (width == null) {
        width = "70%";
    }

    if (titleWidth == null) {
        titleWidth = "120";
    }

    var html = 
            "<table width=\"" + width + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
            + "<tr>"
            + "<td>"
            + "<table class=\"width_per100\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
            + "<tr class=\"tabal_head\">"
            + " <td class=\"width_per35\"><\/td>"
            + "<td class=\"align_right\">"
            + "<table class=\"width_per100\" border=\"0\" cellpadding=\"1\" cellspacing=\"0\">"
            + "<tr class=\"align_right\">";

        html +=  '<td></td><td class="align_right" width="40">'
                 + '<input name="BtnAdd" id="BtnAdd" type="button" class="submit" value="' + cfg_wlancfgother_language['amp_wlan_new'] + '" '
                 + 'onclick="addISPAttr();" />'
                 + '</td><td class="align_right" width="42">'
                 + '<input name="DeleteButton" id="DeleteButton" type="button" class="submit" value="' + cfg_wlancfgother_language['amp_wlan_del'] + '" ' 
                 + 'onclick="OnDeleteButtonClick(\''
                 + tabTitle + '\');" />'
                 + '</td><td width="3"></td>';

        html += "<\/tr>"
                + "<\/table>"
                + "<\/td>"
                + "<\/tr>"
                + "<\/table>"
                + "<\/td>"
                + "<\/tr>"
                + "<tr>"
                + "<td id=\"" + tabTitle + "\">";

    document.write(html);
}

function setDivValueDefault(id) {
    setText('SSID',isaPara[id].SSID);
    setText('WifiShareMaxClientNumber',isaPara[id].WifiShareMaxClientNumber);
    setSelect('AuthenticationMode', isaPara[id].AuthenticationMode);
    setText('RadiusServer',isaPara[id].RadiusServer);
    setText('wlRadiusKey',isaPara[id].RadiusKey);
    setText('twlRadiusKey',isaPara[id].RadiusKey);
    setText('RadiusAuthenticationPort',isaPara[id].RadiusAuthenticationPort);
    setText('RadiusAccountPort',isaPara[id].RadiusAccountPort);
    setCheck('RadiusAccountEnable', isaPara[id].RadiusAccountEnable);
    setText('KickRssiThreshold',isaPara[id].KickRssiThreshold);
    setText('AccessRssiThreshold',isaPara[id].AccessRssiThreshold);
    setText('UpRateLimit',isaPara[id].UpRateLimit);
    setText('DownRateLimit',isaPara[id].DownRateLimit);

    if (getSelectVal('AuthenticationMode') == 'WebPortal') {
        setDisplay('TableAuthSwitchForm', 0);
    } else {
        setDisplay('TableAuthSwitchForm', 1);
    }
}

function authModeChange() {
    if (getSelectVal('AuthenticationMode') == 'WebPortal') {
        setDisplay('TableAuthSwitchForm', 0);
    } else {
        setDisplay('TableAuthSwitchForm', 1);
    }
}

function setSelected(id) {
    setDisplay('addDivForm', 0);
    setDisplay("selectline_new", 0);
    setDisplay('divTableSwitchForm', 1);
    setDivValueDefault(id);
    getElById('selectline_'+ id).style.background = 'rgb(199, 231, 254)';
    indexSSID = id;

    for (var i = 0;i < isaPara.length - 1; i++) {
        if (i == id) {
            continue;
        }
        getElById('selectline_'+ i).style.background = '#f2f2f2';
    }

    addFlags = false;
}

function selectRemoveCnt(curCheck) {

}

function ShowOrHideText(checkBoxId, passwordId, textId, value) {
    if (getCheckVal(checkBoxId) == 1) {
        setDisplay(passwordId, 1);
        setDisplay(textId, 0);
    } else {
        setDisplay(passwordId, 0);
        setDisplay(textId, 1);
    }
}

</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();"> 
<div>
    <script language="JavaScript" type="text/javascript">
        HWCreatePageHeadInfo("Z-Wave", GetDescFormArrayById(cfg_public_wifi_language, "public_wifi_desc"), GetDescFormArrayById(cfg_public_wifi_language, "public_wifi_desc"), false);
        wlanWriteTabHeader('Publicwifi',"100%");
    </script> 
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="IspWifiInfo">
    <tr class="head_title">
        <td>&nbsp;</td>
        <td ><div class="align_left"><script>document.write(cfg_public_wifi_language['public_wifi_freq']);</script></div></td>
          <td ><div class="align_left"><script>document.write(cfg_wlanguestwifi_language['amp_guestwifi_tittle_ssidname']);</script></div></td>
          <td ><div class="align_left"><script>document.write(cfg_public_wifi_language['public_wifi_kickrssithreshold']);</script></div></td>
          <td ><div class="align_left"><script>document.write(cfg_public_wifi_language['public_wifi_accessrssithreshold']);</script></div></td>
    </tr>
    <script language="JavaScript" type="text/javascript">
        for (var i = 0;i < isaPara.length - 1; i++) {
            var freq = "";
            document.write('<TR id="selectline_' + i + '" style="background-color: #f2f2f2;" onclick="setSelected(' + i + ');">');
            for(var j = 0;j < wlanArr.length - 1; j++) {
                if (getWlanInstFromDomain(wlanArr[j].domain) == isaPara[i].SSID_IDX) {
                    if ((getWlanPortNumber(wlanArr[j].Name) >= 0) && (getWlanPortNumber(wlanArr[j].Name) <= 3)) {
                        freq = "2G";
                    } else if ((getWlanPortNumber(wlanArr[j].Name) >= 4) && (getWlanPortNumber(wlanArr[j].Name) <= 7)) {
                        freq = "5G";
                    }
                }
            }
            document.write('<TD>' + '<input type="checkbox" name="rml" id="rml"'  + ' value="'+ i + '" onclick="selectRemoveCnt(i);" >' + '</TD>');
            document.write('<TD>' + freq + '</TD>');
            document.write('<TD>' + htmlencode(isaPara[i].SSID) + '</TD>');
            document.write('<TD>' + isaPara[i].KickRssiThreshold + '</TD>');
            document.write('<TD>' + isaPara[i].AccessRssiThreshold + '</TD>');
            document.write('</TR>');
        }
    </script>
    <tr class="head_title" id="selectline_new" style="display:none;background-color:rgb(199, 231, 254);">
        <td><div class="align_left">----</div></td>
        <td><div class="align_left">----</div></td>
        <td><div class="align_left">----</div></td>
        <td><div class="align_left">----</div></td>
        <td><div class="align_left">----</div></td>
    </tr>
</table>
<div id="publicwifiConfig">
    <div class="title_spread"></div>
    <div class="func_title"><script>document.write(cfg_public_wifi_language["public_wifi_config"]);</script></div>
</div>
<div id="divTableSwitchForm" class="configborder" style="display:none;">
    <table id="TableSwitchForm" width="100%" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_ssid_name"]);</script>
                </div>
            </td>
            <td>
                <input id="SSID" type="text" style="width:123px;" maxlength="32">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wifiguide_language["amp_wifipage_name_notice"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_wlancfgbasic_language["amp_link_devnum"] + ':');</script>
                </div>
            </td>
            <td>
                <input id="WifiShareMaxClientNumber" type="text" style="width:123px;"> 
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_public_wifi_language["public_wifi_access_maximum_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_wlancfgdetail_language["amp_auth_mode"]);</script>
                </div>
            </td>
            <td>
                <select id='AuthenticationMode' name='AuthenticationMode' size='1' onChange='authModeChange()' style="width:127px;">
                    <option value="WebPortal">WebPortal</option>
                    <option value="802.1x-EAP">802.1x-EAP</option>
                </select>
            </td>
        </tr>
    </table>
    <table id="TableAuthSwitchForm" width="100%" cellpadding="0" cellspacing="1" class="tabal_noborder_bg" style="display:none;">
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_wlancfgdetail_language["amp_radius_srvip"]);</script>
                </div>
            </td>
            <td>
                <input id="RadiusServer" type="text" style="width:123px;">
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_wlancfgdetail_language["amp_radius_sharekey"]);</script>
                </div>
            </td>
            <td>
                <input type='password' autocomplete='off' id='wlRadiusKey' name='wlRadiusKey' size='20' maxlength='64' style='width:123px;' class="amp_font" onchange="radiuspassword=getValue('wlRadiusKey');getElById('twlRadiusKey').value=radiuspassword;" />
                <input type='text' autocomplete='off' id='twlRadiusKey' name='twlRadiusKey' size='20' maxlength='64' class="amp_font" style='display:none;width:123px;'  onchange="radiuspassword=getValue('twlRadiusKey');getElById('wlRadiusKey').value=radiuspassword;"/>
                <input checked disabled type="checkbox" id="hidewlRadiusKey" name="hidewlRadiusKey" value="on" onClick="ShowOrHideText('hidewlRadiusKey', 'wlRadiusKey', 'twlRadiusKey', radiuspassword);"/>
                <span class="gray">
                    <script>document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);</script>
                </span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_wlancfgdetail_language["amp_radius_srvport"]);</script>
                </div>
            </td>
            <td>
                <input id="RadiusAuthenticationPort" type="text" style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wlancfgdetail_language["amp_radiusport_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_radiusaccountport"]);</script>
                </div>
            </td>
            <td>
                <input id="RadiusAccountPort" type="text" style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wlancfgdetail_language["amp_radiusport_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_radiusaccountenable"]);</script>
                </div>
            </td>
            <td>
                <input type="checkbox" id="RadiusAccountEnable">
            </td>
        </tr>
    </table>
    <table id="TableEapSwitchForm" width="100%" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_kickrssithreshold_title"]);</script>
                </div>
            </td>
            <td>
                <input id="KickRssiThreshold" type="text" value='-72' style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_public_wifi_language["public_wifi_radiusthreshold_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_accessrssithreshold_title"]);</script>
                </div>
            </td>
            <td>
                <input id="AccessRssiThreshold" type="text" value='-70' style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_public_wifi_language["public_wifi_accessthreshold_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_upratelimit"]);</script>
                </div>
            </td>
            <td>
                <input id="UpRateLimit" type="text" style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wlancfgdetail_language["amp_radiusport_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_downratelimit"]);</script>
                </div>
            </td>
            <td>
                <input id="DownRateLimit" type="text" style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wlancfgdetail_language["amp_radiusport_note"]);</script></span>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
        <tbody>
            <tr>
                <td class="table_submit width_per25"></td>
                <td class="table_submit">
                    <button id="applyButton" name="applyButton" type="button" class="ApplyButtoncss buttonwidth_100px" onclick="zwaveSet();">
                        <script>document.write(cfg_public_wifi_language['public_wifi_apply']);</script></button>
                    <button id="cancelButton" name="cancelButton" type="button" class="ApplyButtoncss buttonwidth_100px" onclick="zwaveCancel();" >
                        <script>document.write(cfg_public_wifi_language['public_wifi_cancel']);</script></button>
                 </td>
            </tr>
        </tbody>
    </table>
</div>
<div id="addDivForm" class="configborder" style="display:none;">
    <table id="" width="100%" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_ssid_name"]);</script>
                </div>
            </td>
            <td>
                <input id="addSSID" type="text" style="width:123px;" maxlength="32">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_wifiguide_language["amp_wifipage_name_notice"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_freq_title"]);</script>
                </div>
            </td>
            <td>
                <select id='addFreq' name='addFreq' size='1' onChange='' style="width:127px;">
                    <option value="2G">2.4G</option>
                    <option value="5G">5G</option>
                </select>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_kickrssithreshold_title"]);</script>
                </div>
            </td>
            <td>
                <input id="addKickRssiThreshold" type="text" value='-72' style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_public_wifi_language["public_wifi_radiusthreshold_note"]);</script></span>
            </td>
        </tr>
        <tr class='tabal_01'>
            <td class="width_per25">
                <div style="width:150px;float:left;">
                    <script>document.write(cfg_public_wifi_language["public_wifi_accessrssithreshold_title"]);</script>
                </div>
            </td>
            <td>
                <input id="addAccessRssiThreshold" type="text" value='-70' style="width:123px;">
                <span class="gray" style='margin-left:10px;'><script>document.write(cfg_public_wifi_language["public_wifi_accessthreshold_note"]);</script></span>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
        <tbody>
            <tr>
                <td class="table_submit width_per25"></td>
                <td class="table_submit">
                    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                    <button id="addapplyButton" name="addapplyButton" type="button" class="ApplyButtoncss buttonwidth_100px" onclick="zwaveAdd();">
                        <script>document.write(cfg_public_wifi_language['public_wifi_apply']);</script></button>
                    <button id="addcancelButton" name="addcancelButton" type="button" class="ApplyButtoncss buttonwidth_100px" onclick="zwaveCancel();" >
                        <script>document.write(cfg_public_wifi_language['public_wifi_cancel']);</script></button>
                 </td>
            </tr>
        </tbody>
    </table>
</div>
</body>

</html>

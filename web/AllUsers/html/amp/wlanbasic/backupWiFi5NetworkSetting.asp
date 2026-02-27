<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<meta http-equiv="Pragma" content="no-cache" />
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="/resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<style type='text/css'>

.tb_radio {
    height: 30px;
    width: 70px;
    background: url(../../../images/equls-left.jpg) no-repeat;
    position: absolute;
    margin-left: 70px;
    margin-top: -5px;
    display: inline-block;
    vertical-align: bottom;
}

.backupWiFi5network {
    width: 170px;
    display: inline-block;
    margin-top: 20px;
}

.wifiEnable {
    margin-top: -20px;
    margin-left: 170px;
}
</style>
<script>
var wifi5ButtonFlag = 0;

var backupenable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_AIS_Backup.Enable);%>';;
var gssidname_2G = "";
var gssidname_5G = "";
var ssidname_2G = "";
var ssidname_5G = "";

function stWlan(domain, Name, SSID)
{
    this.domain = domain;
    this.Name = Name;
    this.SSID = SSID;
}

var WlanList = new Array();
var WlanList = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, Name|SSID, stWlan);%>;
var WlanListNum = WlanList.length -1;
for (var i = 0; i < WlanListNum; i++) {
    if (WlanList[i].domain == "InternetGatewayDevice.LANDevice.1.WLANConfiguration.1") {
        ssidname_2G = WlanList[i].SSID;
    } else if (WlanList[i].domain == "InternetGatewayDevice.LANDevice.1.WLANConfiguration.3") {
        gssidname_2G = WlanList[i].SSID;
    } else if (WlanList[i].domain == "InternetGatewayDevice.LANDevice.1.WLANConfiguration.5") {
        ssidname_5G = WlanList[i].SSID;
    } else if (WlanList[i].domain == "InternetGatewayDevice.LANDevice.1.WLANConfiguration.7") {
        gssidname_5G = WlanList[i].SSID;
    }
}

function enableClickWiFi5(id) {
    if ((backupenable == 0) && ((ssidname_2G.length > 25) || (ssidname_5G.length > 25))) {
        alert("The SSID1 or SSI5 name cannot exceed 25 characters.");
        return;
    }
    if (backupenable == 0) {
        backupenable = 1;
    } else {
        backupenable = 0;
    }
    submit();
    changeWiFiButton(id, backupenable);
}

function changeWiFiButton(id, flag) {
    if (flag == 0) {
        $("#wifi5content").hide();
        getElementById(id).style.backgroundImage = "url(../../../images/equls-left.jpg)";
    } else {
        getElementById(id).style.backgroundImage = "url(../../../images/equls-right.gif)";
    }
}

function submit() {
    var url = 'set.cgi?x=InternetGatewayDevice.X_AIS_Backup'
    var Form = new webSubmitForm();
    var RequestFile = "html/amp/wlanbasic/backupWiFi5NetworkSetting.asp";
    url = url + '&RequestFile=' + RequestFile;
    Form.addParameter('x.Enable', backupenable);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction(url);
    Form.submit();
}

</script>

</style>
<div style="margin-top: 20px;margin-left: 30px;background-color: white;">
<script>
    var backupwifi_header = cfg_backupwifi_language['backupwifi_header'];
    var backupWifiSummaryArray = new Array(new stSummaryInfo("text", GetDescFormArrayById(cfg_backupwifi_language, "backupwifi_title")),
                                    new stSummaryInfo("img","../../../images/icon_01.gif", GetDescFormArrayById(cfg_wlancfgother_language, "amp_wlan_note1")),
                                    new stSummaryInfo("text","1. " + GetDescFormArrayById(cfg_backupwifi_language, "backupwifi_note") + "<br>"),
                                    null);

    HWCreatePageHeadInfo("WiFi5setting", backupwifi_header, backupWifiSummaryArray, true);
</script>
</div>
<body  id="wanbody" style="background-color:white;">
<div style="margin: 10px 0 0 30px;font-size: 14px;">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
    <div>
        <div class="backupWiFi5network">
            <script>document.write(cfg_backupwifi_language['backupwifi_enable']);</script>
            <div class="tb_radio" id="enablewifi5" onclick="enableClickWiFi5(this.id)"></div>
        </div>
    </div>
    <div>
        <div style="margin-top: 20px;margin-left:170px;">
            <script>document.write(cfg_backupwifi_language['backupwifi_title_description']);</script>
        </div>
    </div>
    <div id="wifi5content">
        <div >
            <div class="backupWiFi5network"><script>document.write(cfg_backupwifi_language['backupwifi_2G']);</script></div>
            <div class="wifiEnable"><script>document.write(gssidname_2G);</script></div>
        </div name="wifi5password">
            <div class="backupWiFi5network"><script>document.write(cfg_backupwifi_language['backupwifi_5G']);</script></div>
            <div class="wifiEnable"><script>document.write(gssidname_5G);</script></div>
            <div style="margin-top: 20px;margin-left:170px;"><script>document.write(cfg_backupwifi_language['backupwifi_password']);</script></div>
            <script>
                changeWiFiButton("enablewifi5", backupenable);
            </script>
        </div>
    </div>
</div>
</div>
</head>
</html>

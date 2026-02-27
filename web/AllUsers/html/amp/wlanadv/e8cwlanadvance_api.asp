var wlan11acFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_11AC);%>';
var wdsFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WDS);%>';
var wifiPowerFixFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WIFI_POWER_FIX);%>';
var currentBin = '<%HW_WEB_GetBinMode();%>';
var enbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';
var guardInterval = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.1.GuardInterval);%>';
var wallMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.X_HW_WallModeForChina.Enable);%>';
var wdsMasterMac = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_WlanMac);%>';
var wlanWifiArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|PossibleChannels|SSIDAdvertisementEnabled|X_HW_ServiceEnable,StWlanWifi);%>;
var cfgMode = '<%HW_WEB_GetCfgMode();%>';
var tianyiFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_CTRG);%>';

var wlanPage;
var possibleChannels = "";
var wlanArrLen = wlanWifiArr.length - 1;
var wlanWifi = wlanWifiArr[0];
var uiTotal2gNum = 0;
var uiTotal5gNum = 0;
var uiTotalNum = 0;
var is11AX = 0;

if (location.href.indexOf("e8cWlanAdvance.asp?") > 0) {
    wlanPage = location.href.split("?")[1]; 
    top.WlanAdvancePage = wlanPage;
}

wlanPage = top.WlanAdvancePage;

if (wlanWifi == null) {
    wlanWifi = new StWlanWifi("", "", "", "", "11n", "", "", "", "", "", "", "", "");
}

if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
    wlanWifiInitFor5G();
    guardInterval = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.2.GuardInterval);%>';
    wdsMasterMac = '<%HW_WEB_GetWlanMac_5G();%>';
} else {
    setWlanWifiDefaultFor2G();
}

if ((wlanWifi.mode == "11ax") || (wlanWifi.mode == "n,ax") || (wlanWifi.mode == "b,g,n,ax") || (wlanWifi.mode == "ac,ax") || (wlanWifi.mode == "n,ac,ax")) {
    is11AX = 1;
}

function StWlanWifi(domain, name, enable, ssid, mode, channel, power, Country, AutoChannelEnable, channelWidth, PossibleChannels, Advertisement, X_HW_ServiceEnable) {
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.mode = mode;
    this.channel = channel;
    this.power = power;
    this.RegulatoryDomain = Country;
    this.AutoChannelEnable = AutoChannelEnable;
    this.channelWidth = channelWidth;
    this.PossibleChannels = PossibleChannels;
    this.Advertisement = Advertisement;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
}

function StWdsClientAp(domain, BSSID) {
    this.domain = domain;
    this.BSSID = BSSID;
}

function wlanWifiInitFor5G() {
    if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
        for (var i = 0; i < wlanArrLen; i++) {
            if (ssidStart5G == getWlanPortNumber(wlanWifiArr[i].name)) {
                wlanWifi = wlanWifiArr[i];
                return;
            }
        }
    }
}

function setWlanWifiDefaultFor2G() {
    if (wlanPage == "5G") {
        return;
    }

    for (var i = 0; i < wlanArrLen; i++) {
        if (ssidStart2G == getWlanPortNumber(wlanWifiArr[i].name)) {
            wlanWifi = wlanWifiArr[i];
            return;
        }
    }
}

function total2gNum() {
    uiTotal2gNum = 0;
    uiTotal5gNum = 0;
    uiTotalNum = wlanArrLen;

    for (var loop = 0; loop < wlanArrLen; loop++) {
        if (wlanWifiArr[loop].name == '') {
            continue;
        }
        
        if (getWlanPortNumber(wlanWifiArr[loop].name) > ssidEnd2G) {
            uiTotal5gNum++;
        } else {
            uiTotal2gNum++;
        }
    }
}

function getPossibleChannels(freq, country, mode, width) {
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/WlanChannel.asp?&1=1",
        data : "freq=" + freq + "&country=" + country + "&standard=" + mode + "&width=" + width,
        success : function(data) {
            possibleChannels = data;
            var lastIndex = possibleChannels.lastIndexOf(',');
            var index = possibleChannels.length;
            for (var i = lastIndex + 1; i < possibleChannels.length; i++) {
                if ((possibleChannels.charCodeAt(i) < 0x30) || (possibleChannels.charCodeAt(i) > 0x39)) {
                    index = i;
                    break;
                }
            }

            possibleChannels = possibleChannels.substring(0, index);
        }
    });
}

function loadChannelListByFreq(freq, country, mode, width) {
    var webChannel = getSelectVal('WlanChannel_select');
    var webChannelValid = 0;

    getPossibleChannels(freq, country, mode, width);
    var showChannels = possibleChannels.split(',');

    $("#WlanChannel_select").empty();

    document.forms[0].WlanChannel_select[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");
    
    for (var j = 1; j <= showChannels.length; j++) {
        if (showChannels[j-1] == webChannel) {
            webChannelValid = 1;
        }

        document.forms[0].WlanChannel_select[j] = new Option(showChannels[j-1], showChannels[j-1]);
    }

    if (webChannelValid == 1) {
        setSelect('WlanChannel_select', webChannel);
    } else {
        setSelect('WlanChannel_select', 0);
    }
}

function loadChannelList(country, mode, width) {
    var freq = '2G';
    if (wlanPage == "5G") {
        freq = '5G';
    }

    loadChannelListByFreq(freq, country, mode, width);
}

function channelWidthChange() {
    loadChannelList(wlanWifi.RegulatoryDomain, wlanWifi.mode, getSelectVal('WlanBandWidth_select'));
}

function InitGuardInterval() {
    $('#WlanInterval_select').empty();
    if (is11AX == 1) {
        document.forms[0].WlanInterval_select[0] = new Option("800nsec", "800nsec");
        document.forms[0].WlanInterval_select[1] = new Option("1600nsec", "1600nsec");
        document.forms[0].WlanInterval_select[2] = new Option("3200nsec", "3200nsec");
    } else {
        document.forms[0].WlanInterval_select[0] = new Option("短", "400nsec");
        document.forms[0].WlanInterval_select[1] = new Option("长", "800nsec");
    }

    if (guardInterval == 'Auto') {
        setSelect("WlanInterval_select", '400nsec');
    } else {
        setSelect("WlanInterval_select", guardInterval);
    }
}

function setDefaultWlanValue() {
    loadChannelList(wlanWifi.RegulatoryDomain,wlanWifi.mode, wlanWifi.channelWidth);
    setSelect('WlanTransmit_select', wlanWifi.power);
    if (wlanWifi.AutoChannelEnable == 1) {
        setSelect('WlanChannel_select', 0);
    } else {
        setSelect('WlanChannel_select', wlanWifi.channel);
    }

    setSelect('WlanBandWidth_select', wlanWifi.channelWidth);

    if (wlanWifi.Advertisement == 1) {
        setCheck('WlanHide_checkbox', 0);
    } else {
        setCheck('WlanHide_checkbox', 1);
    }

    InitGuardInterval();
    loadWdsConfig();
}

function wifiAdvanceShow(enable) {
    if (enable == 1) {
        setDisplay('wifiCfg', 1);
        if ((wlanWifi.mode == "11b") || (wlanWifi.mode == "11g") || (wlanWifi.mode == "11bg") || (wlanWifi.mode == "11a")) {
            $("#WlanBandWidth_select").empty();
            document.forms[0].WlanBandWidth_select[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
        }

        setDefaultWlanValue();
    } else {
        setDisplay('wifiCfg', 0);
    }
}

function wdsClickFunc() {
    if (getCheckVal('wds_enable') == 0) {
        setDisplay('div_wds_mac', 0);
    } else {
        setDisplay('div_wds_mac', 1);
    }
}

function loadWdsConfig() {
    if (wdsFlag == 1) {
        var wdsEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.Enable);%>';
        var wdsClientApMacAddr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.{i}, BSSID, StWdsClientAp);%>;

        if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
            wdsClientApMacAddr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.{i}, BSSID, StWdsClientAp);%>;
            wdsEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.Enable);%>';
        }

        setCheck('wds_enable', wdsEnable);
        document.getElementById("X_HW_WlanMac").innerHTML = wdsMasterMac;
        setText('wds_text_ap1', wdsClientApMacAddr[0].BSSID);
        setText('wds_text_ap2', wdsClientApMacAddr[1].BSSID);
        setText('wds_text_ap3', wdsClientApMacAddr[2].BSSID);
        setText('wds_text_ap4', wdsClientApMacAddr[3].BSSID);

        setDisplay('div_wds_config', 1);
        
        if (wdsEnable == 0) {
            setDisplay('div_wds_mac', 0);
        }
    } else {
        setDisplay('div_wds_config', 0);
    }
}

function setE8CWlanAdvanceTitle() {
    var thisTitle = "说明：无线连接的高级功能设置，可设置开放的信道，发射功率等一些高级参数(在无线网络功能关闭时，此页面内容可能为空)。";
    if ((DoubleFreqFlag == 1) && (wlanPage == "2G")) {
        thisTitle = cfg_wlancfgother_language['amp_wlanadvance_title_2G'];
    } else if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
        thisTitle = cfg_wlancfgother_language['amp_wlanadvance_title_5G'];
    }

    getElementById("e8CWlanAdvanceTitle").innerHTML = thisTitle;
}

function INIT_E8cWidth80M() {
    if ((currentBin.toUpperCase() == 'E8C') && (cfgMode.toUpperCase() != 'JSCT')) {
        document.forms[0].WlanBandWidth_select[3] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_80'], "3");
    } else {
        document.forms[0].WlanBandWidth_select[3] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_auto204080'], "3");
    }
}

function initX_HW_HT20() {
    var mode = wlanWifi.mode;
    if ((wlan11acFlag == 1) && (DoubleFreqFlag == 1) && (wlanPage == "5G") && (mode == "11ac")) {
        INIT_E8cWidth80M();
        if (capHT160 == 1) {
            document.forms[0].WlanBandWidth_select[4] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_160'], "4");
        }
    }

    if ((DoubleFreqFlag == 1) && (wlanPage == "5G") && (is11AX == 1)) {
        INIT_E8cWidth80M();
        document.forms[0].WlanBandWidth_select[4] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_160'], "4");
    }
}

function wdsIsMacAddrRepeat() {
    var aucMac = new Array();
    var i = 0;
    var j = 0;

    aucMac[0] = getValue('wds_text_ap1');
    aucMac[1] = getValue('wds_text_ap2');
    aucMac[2] = getValue('wds_text_ap3');
    aucMac[3] = getValue('wds_text_ap4');

    for (var i = 0; i < 4; i++) {
        for (var j = i + 1; j < 4; j++) {
            if ((aucMac[i].length == 17) && (aucMac[j].length == 17)) {
                if (aucMac[i].toLowerCase() == aucMac[j].toLowerCase()) {
                    return true;
                }
            }
        }
    }

    return false;
}

function wdsIsMacAddrInvalid(mac) {
    if ((mac.length != 0) && (mac.length != 17)) {
        return true;
    }

    if (mac.length == 17) {
        for (var loop = 0; loop < 17; loop++) {
            if ((1 + loop) % 3 == 0) {
                if (mac.charAt(loop) != ':') {
                    return true;
                }
            } else {
                if (((mac.charAt(loop) >= '0') && (mac.charAt(loop) <= '9')) || ((mac.charAt(loop) >= 'a') && (mac.charAt(loop) <= 'f')) || ((mac.charAt(loop) >= 'A') && (mac.charAt(loop) <= 'F'))) {
                    continue;
                } else {
                    return true;
                }
            }
        }
    }

    return false;
}

function setBindText() {
    var all = document.getElementsByTagName("td");
    for (var i = 0; i < all.length ; i++) {
        var b = all[i];
        if (b.getAttribute("BindText") == null) {
            continue;
        }
        
        if (cfg_wlancfgbasic_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgbasic_language[b.getAttribute("BindText")];
        } else if (cfg_wlancfgdetail_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgdetail_language[b.getAttribute("BindText")];    
        } else if (cfg_wlancfgadvance_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgadvance_language[b.getAttribute("BindText")];    
        } else if (cfg_wlancfgother_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlancfgother_language[b.getAttribute("BindText")];        
        } else if (cfg_wlanzone_language[b.getAttribute("BindText")]) {
            b.innerHTML = cfg_wlanzone_language[b.getAttribute("BindText")];        
        }
    }
}

function CheckForm(type) {
    if ((getSelectVal('WlanTransmit_select') == "") || (getSelectVal('WlanChannel_select') == "") ||
        (getSelectVal('WlanBandWidth_select') == "")) {
        AlertEx(cfg_wlancfgother_language['amp_basic_empty']);
        return false;
    }

    if (wdsFlag == 1) {
        if (getCheckVal('wds_enable') == 1) {
            if (wdsIsMacAddrInvalid(getValue('wds_text_ap1')) || wdsIsMacAddrInvalid(getValue('wds_text_ap2')) ||
                wdsIsMacAddrInvalid(getValue('wds_text_ap3')) || wdsIsMacAddrInvalid(getValue('wds_text_ap4'))) {
                AlertEx(cfg_wlancfgadvance_language['amp_wds_address_invalid']);
                return false;
            }

            if (wdsIsMacAddrRepeat()) {
                AlertEx(cfg_wlancfgadvance_language['amp_wds_address_repeat']);
                return false;
            }
        }
    }

    return true;
}

function addWdsSubmitParam(Form) {
    var wdsCheckValue = getCheckVal('wds_enable');
    if (wdsCheckValue == 1) {
        Form.addParameter('m.Enable', wdsCheckValue);
        Form.addParameter('n.BSSID', getValue('wds_text_ap1'));
        Form.addParameter('o.BSSID', getValue('wds_text_ap2'));
        Form.addParameter('p.BSSID', getValue('wds_text_ap3'));
        Form.addParameter('q.BSSID', getValue('wds_text_ap4'));

        if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
            url += '&y=' + wlanWifi.domain +
                   '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS' +
                   '&n=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.1' +
                   '&o=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.2' +
                   '&p=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.3' +
                   '&q=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS.ClientAP.4';
        } else {
            url += '&y=' + wlanWifi.domain +
                   '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS' +
                   '&n=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.1' +
                   '&o=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.2' +
                   '&p=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.3' +
                   '&q=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS.ClientAP.4';
        }
    } else {
        Form.addParameter('m.Enable',wdsCheckValue);
        if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
            url += '&y=' + wlanWifi.domain +
                   '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.5.X_HW_WDS';
        } else {
            url += '&y=' + wlanWifi.domain +
                   '&m=' + 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.X_HW_WDS';
        }
    }
}

function AddSubmitParam(Form, type) {
    if (getSelectVal('WlanChannel_select') == 0) {
        Form.addParameter('y.Channel', getSelectVal('WlanChannel_select'));
        Form.addParameter('y.AutoChannelEnable', 1); 
    } else {
        Form.addParameter('y.Channel', getSelectVal('WlanChannel_select'));
        Form.addParameter('y.AutoChannelEnable', 0);
    }

    Form.addParameter('y.X_HW_HT20', getSelectVal('WlanBandWidth_select')); 

    var wallModeSel = getSelectVal('wallMode_select');
    if (wifiPowerFixFlag != "1") {
        if (wallModeSel == 1) {
            if (tianyiFlag == 1) {
                Form.addParameter('y.TransmitPower', 200);
            } else {
                Form.addParameter('y.TransmitPower', 100);
            }
        } else {
            Form.addParameter('y.TransmitPower', getSelectVal('WlanTransmit_select'));
        }

        Form.addParameter('r.Enable', wallModeSel);

        if (DoubleFreqFlag == 1) {
            if (wallModeSel == 1) {
                if (tianyiFlag == 1) {
                    Form.addParameter('s.TransmitPower', 200);
                } else {
                    Form.addParameter('s.TransmitPower', 100);
                }
            } else if ((wallModeSel == 0) && (wallMode == 1)) {
                Form.addParameter('s.TransmitPower', 100);
            }
        }
    }

    var radioIndex = ((DoubleFreqFlag == 1) && (wlanPage == "5G")) ? 2 : 1;
    var wlan = getFirstSSIDInst(radioIndex, allWlanInfo);
    var wlanInst = wlan.InstId;
    WifiCoverParaDefault(wlan, wlanInst);

    if (getCheckVal('WlanHide_checkbox') == 1) {
        Form.addParameter('y.SSIDAdvertisementEnabled',0);
        setCoverSsidNotifyFlag(wlan.SSIDAdvertisementEnabled, 0, ENUM_SSIDAdvertisementEnabled);
    } else {
        Form.addParameter('y.SSIDAdvertisementEnabled',1);
        setCoverSsidNotifyFlag(wlan.SSIDAdvertisementEnabled, 1, ENUM_SSIDAdvertisementEnabled);
    }

    Form.addParameter('z.GuardInterval', getSelectVal('WlanInterval_select'));
    SubmitWIfiCoverSsid(Form, wlan, wlanInst);

    url = 'set.cgi?' + url_new;
    if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
        url += 'z=InternetGatewayDevice.LANDevice.1.WiFi.Radio.2';
    } else {
        url += 'z=InternetGatewayDevice.LANDevice.1.WiFi.Radio.1';
    }

    if (wifiPowerFixFlag != "1") {
        url += '&r=InternetGatewayDevice.LANDevice.1.WiFi.X_HW_WallModeForChina';
    }

    if (wdsFlag == 1) {
        addWdsSubmitParam(Form);
    } else {
        if ((DoubleFreqFlag == 1) && (wlanPage == "5G")) {
            url += '&y=' + wlanWifi.domain;
        } else {
            url += '&y=' + wlanWifi.domain;
        }
    }

    if ((DoubleFreqFlag == 1) && (wifiPowerFixFlag != "1") && ((wallModeSel == 1) || (wallMode == 1))) {
        if (wlanPage == "5G") {
            url += '&s=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1';
        } else {
            url += '&s=InternetGatewayDevice.LANDevice.1.WLANConfiguration.5';
        }
    }

    url += '&RequestFile=html/amp/wlanadv/e8cWlanAdvance.asp';
    Form.setAction(url);

    setDisable('Save_button', 1);
    setDisable('Cancel_button', 1);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
}

function cancelConfig() {
    setDefaultWlanValue();
    InitWallMode();
}

function loadFrameWifi() {
    initWlanCap();
    total2gNum();
    setE8CWlanAdvanceTitle();
    initX_HW_HT20();

    if (DoubleFreqFlag == 1) {
        if (enbl == 1) {
            if (wlanPage == '2G') {
                wifiAdvanceShow((enbl2G != "0") && (uiTotal2gNum > 0));
            }
            
            if (wlanPage == '5G') {
                wifiAdvanceShow((enbl5G != "0") && (uiTotal5gNum > 0));
            }
        } else {
            wifiAdvanceShow(enbl != "0");
        }
    } else {
        wifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
    }
    
    setBindText();

    if (wifiPowerFixFlag == "1") {
        setDisable('WlanTransmit_select', 1);
    }

    setDisplay('AdvanceConfig', 1);

    InitWallMode();
}

function InitWallMode() {
    if (wifiPowerFixFlag == "1") {
        return;
    }
    setSelect("wallMode_select", wallMode);
    if ((DoubleFreqFlag != 1) || (wlanPage == '5G')) {
        setDisplay("powerStrenthMode", 1);
    }
    setDisable("WlanTransmit_select", wallMode);
    if (wallMode == 1) {
        setSelect("WlanTransmit_select", 100);
    }
}

function WallModeChange() {
    var wallModeVal = getSelectVal('wallMode_select');
    setDisable("WlanTransmit_select", wallModeVal);
    if (wallModeVal == 1) {
        setSelect("WlanTransmit_select", 100);
    }
}


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var collectStatus = "";
var collectApStatus = "";
var collectPercentage = "";
var collectApPercentage = "";
var IsWebStartCollectFlag = '<%HW_WEB_GetShowProFlag();%>';
var IsWebStartCollectApFlag = '<%WEB_GetShowApProFlag();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var languageList = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE_SET.STRING);%>';
var initLanguage = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE.STRING);%>';
var dfxPacketParam = '<%WEB_DfxGetPacketParam();%>';
var isSupportWiFiDfxFlag = '<%WEB_IsSupportWifiOperationFlag();%>';
var doubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
var isOnlyShowPartFlag = 1;

var dfxType = '';
if (typeof top.wifiInfoDfxType == 'undefined') {
    top.wifiInfoDfxType = '';
}

if (location.href.indexOf("&RequestFile=html/ssmp/collect/collectInfo.asp") > 0) {
    dfxType = top.wifiInfoDfxType;
}

var languageSet = new Array();
var rosunionGame = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_ROSUNION_GAME);%>';

if ((typeof languageList == 'string') && (languageList != '')) {
    languageSet = languageList.split("|");
}

function IsSupportPrompt()
{
    if (languageSet.length > 1) {
        for (var lang in languageSet) {
            if ((languageSet[lang] != 'english') && (languageSet[lang] != 'chinese')) {
                return false;
            }
        }
    }

    if ((initLanguage != 'english') && (initLanguage != 'chinese')) {
        return false;
    }

    if ((curLanguage != 'english') && (curLanguage != 'chinese')) {
        return false;
    }

    return true;
}

function stApDeviceList(domain,ApOnlineFlag,APMacAddr)
{
    this.domain = domain;
    this.ApOnlineFlag = ApOnlineFlag;
    this.APMacAddr = APMacAddr;
}

var apDeviceList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i},ApOnlineFlag|APMacAddr,stApDeviceList);%>;
var apEnableDeviceList = new Array();
var apActionEnable = 0;
var idx = 0;
for (var i = 0; i < apDeviceList.length - 1; i++) {
    if (apDeviceList[i].ApOnlineFlag == '1') {
        GetApEnable(apDeviceList[i].APMacAddr);
        if (apActionEnable == 1) {
            apEnableDeviceList[idx] = apDeviceList[i];
            idx++;
        }
    }
}

function GetApEnable(mac)
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/GetApActionEnable.asp?&1=1",
        data :'APMacAddr=' + mac,
        success : function(data) {
            apActionEnable = data;
        }
    });
}

var supportCollectAp = false;
if (apEnableDeviceList.length > 0) {
    supportCollectAp = true;
}

function setButtonStatus()
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "../common/getCollectStatus.asp",
		success : function(data) {
			 collectStatus  = data;
		}
	});
	if("0" == collectStatus)
	{
		$("#progress_bar_container").css("display","none");
		setDisable('collect',0);
		setDisable('view', 1);
		getElement('CollectInfo').innerHTML = '';
		return;
	}
	else if("1" == collectStatus)
	{
		if(1 == parseInt(IsWebStartCollectFlag))
		{
			setPercentage();
		}
		setDisable('collect',1);
		setDisable('view', 1);
        var colorRef1 = "red";
        if (CfgMode.toUpperCase() == 'ZAIN') {
            colorRef1 = "#e0218a";
        } else if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
            colorRef1 = "#333333";
        }
        getElement('CollectInfo').innerHTML = '<B><FONT color=' + colorRef1 + '>'+GetLanguageDesc("s1119")+ '</FONT><B>';
		return;
	}
	else
	{
		if(1 == parseInt(IsWebStartCollectFlag))
		{
		$("#progress_bar_container").css("display","block");
		$(".bar").css("width",  "100%");
		$(".percentage").html("100%");	
		}	
		setDisable('collect',0);
		setDisable('view', 0);
        var colorRef1 = "red";
        if (CfgMode.toUpperCase() == 'ZAIN') {
            colorRef1 = "#e0218a";
        } else if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
            colorRef1 = "#333333";
        }
        getElement('CollectInfo').innerHTML = '<B><FONT color=' + colorRef1 + '>'+GetLanguageDesc("s1120")+ '</FONT><B>';
		return;
	}
}
function setPercentage()
{	
	$("#progress_bar_container").css("display","block");
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "../common/getCollectProgress.asp",
		success : function(data) {
			collectPercentage = data;
			$(".bar").css("width",collectPercentage + "%");
			$(".percentage").html(collectPercentage + "%");	
		}
	});
	
}

function setApButtonStatus()
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/getApCollectStatus.asp",
        success : function(data) {
             collectApStatus  = data;
        }
    });
    if (collectApStatus == '1') {
        if (parseInt(IsWebStartCollectApFlag) == 1) {
            setApPercentage();
        }
        setDisable('collectAp',1);
        setDisable('viewAp', 1);
        var colorRef1 = "red";
        if (CfgMode.toUpperCase() == 'ZAIN') {
            colorRef1 = "#e0218a";
        } else if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
            colorRef1 = "#333333";
        }
        getElement('CollectApInfo').innerHTML = '<B><FONT color=' + colorRef1 + '>'+GetLanguageDesc("s1119")+ '</FONT><B>';
        return;
    } else if (collectApStatus == '2') {
        if (parseInt(IsWebStartCollectApFlag) == 1) {
            $("#ap_progress_bar_container").css("display","block");
            $(".apBar").css("width",  "100%");
            $(".apPercentage").html("100%");
        }
        setDisable('collectAp',0);
        setDisable('viewAp', 0);
        var colorRef2 = "red";
        if (CfgMode.toUpperCase() == 'ZAIN') {
            colorRef2 = "#e0218a";
        } else if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
            colorRef2 = "#333333";
        }
        return;
    } else {
        $("#ap_progress_bar_container").css("display","none");
        setDisable('collectAp',0);
        setDisable('viewAp', 1);
        getElement('CollectApInfo').innerHTML = '';
        return;
    }
}

function setApPercentage()
{
    $("#ap_progress_bar_container").css("display","block");
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/getCollectApProgress.asp",
        success : function(data) {
            collectApPercentage = data;
            $(".apBar").css("width",collectApPercentage + "%");
            $(".apPercentage").html(collectApPercentage + "%");
        }
    });
}

function LoadFrame()
{
    setButtonStatus();
    setInterval(function() {
        try {
             setButtonStatus();
        } catch (e) {
        }
    }, 1000*5);
    if(curLanguage == "arabic"){
        document.getElementById("faultInfo").style.textAlign = "right";
    }
    else{
        document.getElementById("faultInfo").style.textAlign = "left";
    }

    if (supportCollectAp == true) {
        setDisplay('CollectApInfoForm', 1);
        setApButtonStatus();
        setInterval(function() {
            try {
                 setApButtonStatus();
            } catch (e) {
            }
        }, 1000*5);
    }

    if (isSupportWiFiDfxFlag == 1) {
        setDisplay('div_wifi_operation', 1);
        if (isOnlyShowPartFlag == 1) {
            ShowPartOpreation();
            setSelect('opreationType', 'SDT');
            OpreTypeChange();
        }
    }

    if (dfxType != '') {
        ShowWiFiOpreation();
        setSelect('opreationType', dfxType);
        OpreTypeChange();
    }
    if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
        $("#collect").css({"width": "105px", "margin-right": "32px"});
        $("#sdtbBtn").css("margin-right", "18px");
        $("#fwBtn").css("margin-right", "-49px");
    }
}

function ClickCollectAp()
{
    var Form = new webSubmitForm();
    Form.addParameter('FaultCmdParams', "-1");
    Form.addParameter('FaultType', "-1");
    Form.setAction('apCollectFaultInfo.cgi?RequestFile=html/ssmp/collect/collectInfo.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function CheckForm()
{
    return true; 
}

function AddSubmitParam(SubmitForm,type)
{

    setDisable('collect', 1);
	SubmitForm.addParameter('FaultCmdParams', "-1");
	SubmitForm.addParameter('FaultType', "-1");
	SubmitForm.setAction('collectFaultInfo.cgi?RequestFile=html/ssmp/collect/collectInfo.asp');
}

function viewFalutInfo(type)
{
    if (IsSupportPrompt() == true) {
        if (ConfirmEx(GetLanguageDesc("s1121")) == false) {
            return;
        }
    }

    var ua = navigator.userAgent.toLowerCase();	
    if (/iphone|ipad|ipod/.test(ua)) {
        window.open("/html/ssmp/collect/collectInfo_ios.asp");
        setDisable('view', 1);
        return;
    }
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    if (type == 0) {
        Form.setAction('colleInfodown.cgi?FileType=fault&RequestFile=html/ssmp/collect/collectInfo.asp');
    } else {
        Form.setAction('apCollectInfodown.cgi?FileType=fault&RequestFile=html/ssmp/collect/collectInfo.asp');
    }
    
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();

    if (type == 0) {
        setDisable('view', 1);
    } else {
        setDisable('viewAp', 1);
    }
    
}

function ShowPartOpreation() {
    $("#opreationType option[value='keyRecord']").remove();
    $("#opreationType option[value='PPDU']").remove();
    $("#opreationType option[value='CSI']").remove();
    $("#opreationType option[value='packet']").remove();
}

function ShowWiFiOpreation() {
    var isShow = 0;
    var btnTxt = cfg_wifiinfo_dfx_language['amp_dfx_btn_text'];
    if (getElById('divWifiOpreation').style.display == 'none') {
        isShow = 1;
        btnTxt = cfg_wifiinfo_dfx_language['amp_dfx_btn_hide_text'];
    }

    getElById('btn_wifi_operation').value = btnTxt;
    SetPacketTypeValue();

    if (doubleFreqFlag != 1) {
        $(".dfxFreqClass").hide();
    }

    setDisplay('divWifiOpreation', isShow);
}


function OpreTypeChange() {
    var opreationType = getSelectVal('opreationType');
    $(".wifiOpreationClass").hide();
    $(".opreationBtnClass").hide();
    setDisplay(opreationType + 'Tr', 1); 
    setDisplay(opreationType + 'BtnTr', 1);

    if (opreationType == 'CSI') {
        InitWifiMac();
    }

    if (opreationType == 'packet') {
        InitPacketTypeDom();
    }

    if (isOnlyShowPartFlag == 1) {
        if (opreationType == 'SDT') {
            setDisplay(opreationType + 'Tr', 0); 
        }

        if (opreationType == 'FW') {
            setDisplay(opreationType + 'Tr', 0);
            setDisplay('tdFwBtn', 0);
        }
    }
}
function InitSeltWifiMacOptions(associatedDevice) {
    var output = '';
    $("#SelMACAddress").empty();
    output = '<option value="0">' + cfg_wifiinfo_dfx_language['amp_dfx_csi_stamac_select'] + '</option>';
    $("#SelMACAddress").append(output);

    for (var i = 0; i < associatedDevice.length - 1; i++) {
        var ssid = getWlanInstFromDomain(associatedDevice[i].domain);
        var radio = 1;
        for (var j = 0; j < WlanInfo.length - 1; j++) {
            var ret = WlanInfo[j].domain.indexOf("InternetGatewayDevice.LANDevice.1.WLANConfiguration." + ssid);
            if (ret == 0) {
                var athindex = getWlanPortNumber(WlanInfo[j].name);
                if ((athindex >= ssidStart2G) && (athindex <= ssidEnd2G)) {
                    break;
                }

                if ((doubleFreqFlag == 1) && (athindex >= ssidStart5G) && (athindex <= ssidEnd5G)) {
                    radio = 2;
                    break;
                }
            }
        }

        if (getRadioVal('CSIFreq') != radio) {
            continue;
        }

        output = '<option value="' + htmlencode(associatedDevice[i].AssociatedDeviceMACAddress) + '" title="' + htmlencode(associatedDevice[i].AssociatedDeviceMACAddress) + '">' + htmlencode(associatedDevice[i].AssociatedDeviceMACAddress) + '</option>';
        $("#SelMACAddress").append(output);
    }
}

function SelWifiMacChange() {
    var sourceMacAddressText;
    if (getSelectVal('SelMACAddress') == 0) {
        sourceMacAddressText = '';
    } else {
       sourceMacAddressText = getSelectVal('SelMACAddress');
    }

    setText('sourceMACAddress', sourceMacAddressText);
}

function InitWifiMac() {
    var associatedDevice;
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../../amp/wlaninfo/getassociateddeviceinfo.asp",
        success : function(data) {
            associatedDevice = eval(data);	
        }
    }); 

    InitSeltWifiMacOptions(associatedDevice);
    getElById('SelMACAddress').onchange = function() {
        SelWifiMacChange();
    }
}

function CsiFreqChange() {
    setText('sourceMACAddress', '');
    InitWifiMac();
}

function DownloadKeyRecord() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('radioInst', getRadioVal('keyRecordFreq'));
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadRecord.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function CheckPpduColTime() { 
    var colTime = getValue('PPDUColTime');

    if (!isInteger(colTime)) {
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_ppdu_col_time_int']);
        return false;
    }

    if ((parseInt(colTime,10) < 0) || (parseInt(colTime,10) > 360)){
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_ppdu_col_time_range']);
        return false;
    }

    return true;
}

function SubmitParamForPPDU() {
    if (!CheckPpduColTime()) {
        return;
    }

    top.wifiInfoDfxType = 'PPDU';
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('ConfigPpduParam.cgi?radioInst=' + getRadioVal('PPDUFreq') + '&colTime=' + getValue('PPDUColTime') + '&RequestFile=html/ssmp/collect/collectInfo.asp');
    Form.submit();
}

function DownloadPpduLog() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadPpduLog.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function CheckCsiParam() { 
    var colTimeNum = getValue('csiColTimeNum');
    var macAddress = getValue('sourceMACAddress');

    if (!isInteger(colTimeNum)) {
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_csi_col_time_num_int']);
        return false;
    }

    if ((parseInt(colTimeNum,10) < 1) || (parseInt(colTimeNum,10) > 1000)){
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_csi_col_time_num_range']);
        return false;
    }

    if (macAddress == '') {
        AlertEx(wlanmacfil_language['bbsp_macfilterisreq']);
        return false;
    }

    if (isValidMacAddress1(macAddress) == false) {
        AlertEx(wlanmacfil_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }

    return true;
}

function DownloadCsiLog() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadCsiLog.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function SubmitParamForCsi() {
    if (!CheckCsiParam()) {
        return;
    }

    top.wifiInfoDfxType = 'CSI';
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    var url = 'ConfigCsiParam.cgi?radioInst=' + getRadioVal('CSIFreq') + '&colTimeNum=' + getValue('csiColTimeNum');
    url += '&macAddress=' + getValue('sourceMACAddress') + '&RequestFile=html/ssmp/collect/collectInfo.asp';
    Form.setAction(url);
    Form.submit();
}

function CheckSdtParam() {
    var sdtFeatureText = ltrim(getValue('sdtFeatureText'));

    if (sdtFeatureText == '') {
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_sdt_feature_empty']);
        return false;
    }

    if (isValidAscii(sdtFeatureText) != '') {
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_sdt_feature_invalid']);
        return false;
    }

    return true;
}

function SumbmitParamForSdt() {
    if (!CheckSdtParam()) {
        return;
    }

    top.wifiInfoDfxType = 'SDT';
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    var url = 'ConfigSdtParam.cgi?radioInst=' + getRadioVal('sdtFreq') + '&sdtFeatureText=' + ltrim(getValue('sdtFeatureText'));
    url += '&enable=' + 1 + '&RequestFile=html/ssmp/collect/collectInfo.asp';
    Form.setAction(url);
    Form.submit();
}

function ClearAllParamForSdt() {
    top.wifiInfoDfxType = 'SDT';
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    var url = 'ConfigSdtParam.cgi?radioInst=' + getRadioVal('sdtFreq') + '&sdtFeatureText=all';
    url += '&enable=' + 0 +'&RequestFile=html/ssmp/collect/collectInfo.asp';
    Form.setAction(url);
    Form.submit();
}

function DownloadSdtLog() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadSdtLog.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function GetSelectValues(id) {
    var value = 0;
    $('input[name=' + id + ']:checked').each(function() {
        value += parseInt($(this).val(),10);
    }); 

    return value;
}

var selPacketType = 0;
function CheckPacketParam() { 
    selPacketType = GetSelectValues('packetType');
    if (selPacketType == 0) {
        AlertEx(cfg_wifiinfo_dfx_language['amp_dfx_packet_condition_empty']);
        return false;
    }

    return true;
}

var maxPacketTypeIdIndex = 0;

function SetPacketTypeValue() {
    $('input[name=packetType]').each(function() {
        var idIndex = this.id.substring(this.id.indexOf('_') + 1);
        $(this).val(Math.pow(2, parseInt(idIndex, 10)));

        if (parseInt(maxPacketTypeIdIndex, 10) < parseInt(idIndex, 10)) {
            maxPacketTypeIdIndex = idIndex;
        }
    }); 
}


function InitPacketTypeDom() {
    var enable = dfxPacketParam.split(',')[0];
    var radioInst = dfxPacketParam.split(',')[1];
    var packetType = dfxPacketParam.split(',')[2];

    if (enable == 0) {
        return;
    }

    setRadio('packetFreq', radioInst);
    $("input[name=packetFreq]").on('click',function(){return false;});
    setDisable('btnStartPacket', 1);
    setDisable('btnStopPacket', 0);
    if (packetType == 0) {
        setCheck('packetTypeAll', 1);
        SetPacketTypeCheck();
    } else {
        for (var i = maxPacketTypeIdIndex; i >= 0, packetType > 0; i--) {
            if (packetType >= Math.pow(2, i)) {
                packetType = packetType - Math.pow(2, i);
                setCheck('packetType_' + i, 1);
            }
        }
    }

    SetPacketTypeDisabled();
}

function SetPacketTypeDisabled() {
    setDisable('packetTypeAll', 1);
    var element = getElement('packetType');
    for (var i = 0; i < element.length; i++) {
        element[i].disabled = true;
    }
}

function SetPacketTypeCheck() {
    var enable = getCheckVal('packetTypeAll');
    var element = getElement('packetType');
    for (var i = 0; i < element.length; i++) {
        if (enable == '1') {
            element[i].checked = true;
        } else {
            element[i].checked = false;
        }
    }
}

function SubmitParamForPacket(packetEnable) {
    if (!CheckPacketParam()) {
        return;
    }

    top.wifiInfoDfxType = 'packet';
    if (selPacketType == (Math.pow(2, parseInt(maxPacketTypeIdIndex, 10) + 1) - 1)) {
        selPacketType = 0;
    }

    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    var url = 'ConfigPacketParam.cgi?radioInst=' + getRadioVal('packetFreq') + '&enable=' + packetEnable;
    url += '&packetType=' + selPacketType + '&RequestFile=html/ssmp/collect/collectInfo.asp';
    Form.setAction(url);
    Form.submit();
}

function DownloadPacketLog() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadPacketLog.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function DownloadFW() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadFwLog.cgi?radioInst=" + getRadioVal('FWFreq') + "RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

function DownloadFWHist() {
    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction("DownloadFwHistLog.cgi?RequestFile=html/ssmp/collect/collectInfo.asp");
    Form.submit();
}

</script>
</head>

<body class="mainbody pageBg" onload="LoadFrame();"> 
<div id="faultInfo"> 
<script language="JavaScript" type="text/javascript">
    var headRef = "s1101";
    var titleRef = "s1102";
    if (CfgMode.toUpperCase() == "DESKAPASTRO") {
        headRef = "s1101_astro";
        titleRef = "s1102_astro";
    }
    HWCreatePageHeadInfo("collectInfoasp", GetDescFormArrayById(CollectInfoLgeDes, headRef), GetDescFormArrayById(CollectInfoLgeDes, titleRef), false);
</script> 
<div class="title_spread"></div>
<div class="func_title" BindText="s1101"></div> 
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="margin-top:15;display:none">
    </table> 
<div id="CollectFaultInfo"> 
    <table width="100%" cellpadding="0" cellspacing="0"> 
        <tr> 
            <td>
                <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                <input class="ApplyButtoncss buttonwidth_150px pix_70_120" name="button" id="collect" type='button' onClick='Submit()' BindText="s1104" />
                <input class="ApplyButtoncss buttonwidth_150px pix_90_130" name="button" id="view" type='button' onClick='viewFalutInfo(0)' BindText="s1114" />
            </td> 
        </tr> 
    </table> 
</div> 
<div class="func_spread"></div>
<div id="CollectInfo"></div> 
<div id="progress_bar_container">
    <span class="percentage">0%</span>
    <div class="bar"></div>
</div>
<div id="div_wifi_operation" style='display:none;'>
<div class="title_spread"></div>
<div class="func_title"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_title'])</script></div>
<input id="btn_wifi_operation" type="button" value="" class="ApplyButtoncss buttonwidth_120px_220px" onclick="ShowWiFiOpreation();"/>
<script>
        getElById('btn_wifi_operation').value = cfg_wifiinfo_dfx_language['amp_dfx_btn_text'];
</script>
</div>
<div id='divWifiOpreation' style='display:none;'> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
    <tr>
        <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type']);</script></td>
        <td class="table_right">
            <select id="opreationType" size="1" onchange="OpreTypeChange();" class="width_180px">
                <option value="keyRecord" selected><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_keyrecord']);</script></option>
                <option value="PPDU"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_ppdu']);</script></option>
                <option value="CSI"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_csi']);</script></option>
                <option value="SDT"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_sdt']);</script></option>
                <option value="packet"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_packet']);</script></option>
                <option value="FW"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_type_fw']);</script></option>
            </select>
        </td>
    </tr>
    <tr id='keyRecordTr' class='wifiOpreationClass dfxFreqClass' style='display:none;'>
        <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
        <td class="table_right">
            <input name="keyRecordFreq" type="radio" value="1" checked="checked" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
            <input name="keyRecordFreq" type="radio" value="2" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
        </td>
    </tr>
    <tr id='PPDUTr' class='wifiOpreationClass' style='display:none;'>
        <td colspan='2'>
        <table width="100%">
        <tr class='dfxFreqClass'>
            <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
            <td class="table_right">
                <input name="PPDUFreq" type="radio" value="1" checked="checked" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
                <input name="PPDUFreq" type="radio" value="2" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
            </td>
        </tr>
        <tr>
            <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_col_time']);</script></td>
            <td class="table_right">
                <input id="PPDUColTime" type="text" class="TextBox" maxlength="3" style="width: 50px" value="10">
                <font color="red">*</font>
                <span class="gray"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_ppdu_col_time_note']);</script></span>
                <button id="" name="" type="button" class="ApplyButtoncss" onclick="SubmitParamForPPDU()"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_start']);</script></button>
            </td>
        </tr>
        </table>
        </td>
    </tr>
    <tr id='CSITr' class='wifiOpreationClass' style='display:none;'>
        <td colspan='2'>
        <table width="100%">
        <tr class='dfxFreqClass'>
            <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
            <td class="table_right">
                <input name="CSIFreq" type="radio" value="1" checked="checked" onclick="CsiFreqChange();"/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
                <input name="CSIFreq" type="radio" value="2" onclick="CsiFreqChange();"/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
            </td>
        </tr>
        <tr>
            <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_csi_stamac']);</script></td>
            <td class="table_right">
                <input id="sourceMACAddress"  type="text" title="AA:BB:CC:DD:EE:FF" class="TextBox" maxlength="17" style="width: 173px">
                <font color="red">*</font>
                <select id="SelMACAddress" class="Select_2 restrict_dir_ltr" style="width: 173px">
                    <option value="0"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_csi_stamac_select']);</script></option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_csi_col_time_num']);</script></td>
            <td class="table_right">
                <input id="csiColTimeNum" type="text" class="TextBox" maxlength="10" style="width: 173px" value='1'>
                <font color="red">*</font>
                <span class="gray"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_csi_col_time_num_note']);</script></span>
                <button id="" name="" type="button" class="ApplyButtoncss" onclick="SubmitParamForCsi()"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_start']);</script></button>
            </td>
        </tr>
        </table>
        </td>
    </tr>
    <tr id='SDTTr' class='wifiOpreationClass' style='display:none;'>
        <td colspan='2'>
        <table width="100%">
            <tr class='dfxFreqClass'>
                <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
                <td class="table_right">
                    <input name="sdtFreq" type="radio" value="1" checked="checked" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
                    <input name="sdtFreq" type="radio" value="2" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
                </td>
            </tr>
            <tr>
                <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_sdt_feature']);</script></td>
                <td class="table_right">
                    <input id="sdtFeatureText" type="text" title="" class="TextBox" maxlength="10" style="width: 173px">
                    <button id="" name="" type="button" class="ApplyButtoncss" onclick="SumbmitParamForSdt();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_sdt_set']);</script></button>
                    <button id="" name="" type="button" class="ApplyButtoncss" onclick="ClearAllParamForSdt();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_sdt_clearall']);</script></button>		
                </td>
            </tr>
        </table>
        </td>
    </tr>
    <tr id='packetTr' class='wifiOpreationClass' style='display:none;'>
        <td colspan='2'>
        <table width="100%">
            <tr class='dfxFreqClass'>
                <td class="table_title width_per35" style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
                <td class="table_right">
                    <input name="packetFreq" type="radio" value="1" checked="checked" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
                    <input name="packetFreq" type="radio" value="2" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
                </td>
            </tr>
            <tr>
                <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_packet_condition']);</script></td>
                <td class="table_right">
                    <table width="100%">
                        <tr>
                            <td><input type="checkbox" name="packetTypeAll" id="packetTypeAll" onclick='SetPacketTypeCheck();'><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_packet_condition_all']);</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_0"><script>document.write('dhcp');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_1"><script>document.write('eapol');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_2"><script>document.write('arp_rsp');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_3"><script>document.write('arp_req');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_4"><script>document.write('dhcp_v6');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_5"><script>document.write('pppoe');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_6"><script>document.write('wapi');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_7"><script>document.write('hs20');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_8"><script>document.write('chariot_sig');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_9"><script>document.write('vip_frame');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_10"><script>document.write('tdls');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_11"><script>document.write('vlan');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_12"><script>document.write('nd');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_13"><script>document.write('normal');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_14"><script>document.write('igmp');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_15"><script>document.write('icmp_req');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_16"><script>document.write('icmp_rsp');</script></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="packetType" id="packetType_17"><script>document.write('dns_req');</script></td>
                            <td><input type="checkbox" name="packetType" id="packetType_18"><script>document.write('dns_rsp');</script></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="table_title width_per35"  style="color: #000000;"></td>
                <td class="table_right">
                    <button id="btnStartPacket" name="" type="button" class="ApplyButtoncss" onclick="SubmitParamForPacket(1)"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_start']);</script></button>
                    <button id="btnStopPacket" name="" type="button" class="ApplyButtoncss" onclick="SubmitParamForPacket(0)" disabled><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_stop']);</script></button>
                </td>
            </tr>
        </table>
        </td>
    </tr>
    <tr id='FWTr' class='wifiOpreationClass dfxFreqClass' style='display:none;'>
        <td class="table_title width_per35"  style="color: #000000;"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_frequency']);</script></td>
        <td class="table_right">
            <input name="FWFreq" type="radio" value="1" checked="checked" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_2g']);</script>
            <input name="FWFreq" type="radio" value="2" onclick=""/><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_5g']);</script>
        </td>
    </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="">
    <tbody>
    <tr id='keyRecordBtnTr' class='opreationBtnClass' style='text-align:center'>
        <td class="table_submit"><button id="" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadKeyRecord();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_log']);</script></button></td>
    </tr>
    <tr id='PPDUBtnTr' class='opreationBtnClass' style='text-align:center; display:none;'>
        <td class="table_submit"><button id="" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadPpduLog();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_log']);</script></button></td>
    </tr>
    <tr id='CSIBtnTr' class='opreationBtnClass' style='text-align:center; display:none;'>
        <td class="table_submit"><button id="" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadCsiLog();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_log']);</script></button></td>
    </tr>
    <tr id='SDTBtnTr' class='opreationBtnClass' style='text-align:center; display:none;'>
        <td class="table_submit"><button id="sdtbBtn" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadSdtLog();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_log']);</script></button></td>
    </tr>
    <tr id='packetBtnTr' class='opreationBtnClass' style='text-align:center; display:none;'>
        <td class="table_submit"><button id="" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadPacketLog();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_log']);</script></button></td>
    </tr>
    <tr id='FWBtnTr' class='opreationBtnClass' style='text-align:center; display:none;'>
        <td id="tdFwBtn" class="table_submit"><button id="" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadFW();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_run_log']);</script></button></td>
        <td class="table_submit"><button id="fwBtn" name="" type="button" class="ApplyButtoncss buttonwidth_150px_250px" onclick="DownloadFWHist();"><script>document.write(cfg_wifiinfo_dfx_language['amp_dfx_download_hist_log']);</script></button></td>
    </tr>
   </tbody>
</table>
</div> 
<div class="title_spread"></div>
<form id="CollectApInfoForm" style="display:none">
    <div class="func_title" BindText="s1122"></div> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="margin-top:15;display:none">
        </table> 
    <div id="CollectApFaultInfo"> 
        <table width="100%" cellpadding="0" cellspacing="0"> 
            <tr> 
                <td>
                    <input class="ApplyButtoncss buttonwidth_150px pix_70_120" name="button" id="collectAp" type='button' onClick='ClickCollectAp()' BindText="s1104" />
                    <input class="ApplyButtoncss buttonwidth_150px pix_90_130" name="button" id="viewAp" type='button' onClick='viewFalutInfo(1)' BindText="s1114" />
                </td> 
            </tr> 
        </table> 
    </div> 
    <div class="func_spread"></div>
    <div id="CollectApInfo"></div> 
    <div id="ap_progress_bar_container">
        <span class="apPercentage">0%</span>
        <div class="apBar"></div>
    </div>
</form>
<script>
function GetLanguageDesc(Name)
{
    return CollectInfoLgeDes[Name];
}
if (rosunionGame == "1") {
	$(".ApplyButtoncss").removeClass("ApplyButtoncss").addClass("CancleButtonCss");
}
ParseBindTextByTagName(CollectInfoLgeDes, "td",     1);
ParseBindTextByTagName(CollectInfoLgeDes, "div",    1);
ParseBindTextByTagName(CollectInfoLgeDes, "input",  2);
</script>

</body>
</html>

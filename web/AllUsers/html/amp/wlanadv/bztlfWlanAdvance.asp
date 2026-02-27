<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(gateway.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>" language="JavaScript"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/lanuserinfo.asp"></script>

<style>
    table.setupWifiTable tfoot td {
        background:#e3e3e3;
    }

    table.setupWifiTable tbody td.cinza {
        text-align: center;
    }

    table.setupWifiTable tbody td.cinza2 {
        text-align: center;
    }

    table.setupWifiTable td span.vmsg.error.hidden {
        display: none;
    }

    table.setupWifiTable td span.vmsg.error.show {
        display: block;
    }

    input.messageInput {
        display:inline-block;
        width:150px;
        color: #666666;
        padding:0px;
        text-align:center;
        background-color: inherit;
    }

    input[disabled] {
        color: #666666;
        background-color: inherit;
        border-width:0px;
    }

    .btn-default-orange-small {
        margin-top:0px;
        margin-bottom:0px;
        padding-top:0px;
        padding-bottom:0px;
        outline:none;
    }

    button[disabled].btn-default-orange-small,button[disabled].btn-default-orange-small span {
        background-color:#999999;
    }

    #authorizedDevices input {
        background-color: transparent;
        border:0 solid #e4e4e4;  
    }
</style>
<script language="JavaScript" type="text/javascript">
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sptUserType ='1';
var TelMexFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELMEX);%>';
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';     
var Wlan11acFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_11AC);%>';
var AisPrev = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_AIS);%>';
var AntGain = '<%HW_WEB_GetSPEC(AMP_SPEC_ANT_GAIN.UINT32);%>';
var bssid_5 = '<%HW_WEB_GetWlanMac_5G();%>';
var bssid_2 = '<%HW_WEB_GetWlanMac_2G();%>';
var AisFlag;
if ((AisPrev == 1) && (AntGain == 5))
{
	AisFlag = 1;
}
else
{
	AisFlag = 0;
}
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curWlanChipType2G = 0;
var curWlanChipType5G = 0;
var t2Flag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_BZTLF);%>';
var chlwidth80Res = (t2Flag=='1')?'amp_chlwidth_80':'amp_chlwidth_auto204080';

var telmexSpan = false;
if ((('TELMEX' == CfgMode.toUpperCase()) || ('TELMEX5G' == CfgMode.toUpperCase())) && 'SPANISH' == curLanguage.toUpperCase())
{
    telmexSpan = true;
}

var wlanpage;
if (location.href.indexOf("bztlfWlanAdvance.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanAdvancePage = wlanpage;
}

wlanpage = top.WlanAdvancePage;  

initWlanCap(wlanpage);

var curWlanChipType = curWlanChipType2G;
if ('5G' == wlanpage)
{
	curWlanChipType = curWlanChipType5G;
}

var possibleChannels = "";

function stWlan(domain,name,enable,ssid,wlHide,DeviceNum,wmmEnable,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                KeyIndex,EncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,WPARekey,RadiusServer,RadiusPort,RadiusKey,X_HW_ServiceEnable)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.wlHide = wlHide;
    this.DeviceNum = DeviceNum;
    this.wmmEnable = wmmEnable;
    this.BeaconType = BeaconType;
    this.BasicEncryptionModes = BasicEncryptionModes;
    this.BasicAuthenticationMode = BasicAuthenticationMode;
    this.KeyIndex = KeyIndex;
    this.EncypBit = EncryptionLevel;
    this.WPAEncryptionModes = WPAEncryptionModes;
    this.WPAAuthenticationMode = WPAAuthenticationMode;
    this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
    this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
    this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;
    this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
    this.WPARekey = WPARekey;
    this.RadiusServer = RadiusServer;
    this.RadiusPort = RadiusPort;
    this.RadiusKey = RadiusKey;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
}

var enbl = WlanEnable[0].enable;

var Wlan = new Array();

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|SSIDAdvertisementEnabled|X_HW_AssociateNum|WMMEnable|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_GroupRekey|X_HW_RadiuServer|X_HW_RadiusPort|X_HW_RadiusKey|X_HW_ServiceEnable,stWlan);%>;

var wlanArrLen = WlanArr.length - 1;

for (i=0; i < wlanArrLen; i++)
{
    Wlan[i] = new stWlan();
    Wlan[i] = WlanArr[i];
}

function stWiFiRadio(domain,GuardInterval)
{
    this.domain = domain;
	this.GuardInterval = GuardInterval;
}

var WiFiRadioArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WiFi.Radio.{i},GuardInterval,stWiFiRadio,EXTEND);%>;
var WiFiRadioArrLen = WiFiRadioArr.length - 1;
var WiFiRadio = WiFiRadioArr[0];


function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
}

function stExtendedWLC(domain, SSIDIndex)
{
    this.domain = domain;
    this.SSIDIndex = SSIDIndex;
}

var apExtendedWLC = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.X_HW_APDevice.{i}.WifiCover.ExtendedWLC.{i}, SSIDIndex, stExtendedWLC,EXTEND);%>;

var uiBandIncludeWifiCoverSsid = 0;

function setBandWifiCoverSsidFlag(wlanInst)
{
    for (var j = 0; j < apExtendedWLC.length - 1; j++)
    {
        if (wlanInst == apExtendedWLC[j].SSIDIndex)
        {
            uiBandIncludeWifiCoverSsid++;
        }
    }
}

var uiTotal2gNum = 0;
var uiTotal5gNum = 0;
var uiTotalNum = 0;
function Total2gNum()
{
    uiTotal2gNum = 0;
    uiTotal5gNum = 0;
    uiTotalNum = Wlan.length;

    for (var loop = 0; loop < Wlan.length; loop++)
    {
        if ('' == Wlan[loop].name)
        {
            continue;
        }
        
        if (getWlanPortNumber(Wlan[loop].name) > 3)
        {
            uiTotal5gNum++;
        }
        else
        {
            uiTotal2gNum++;

            setBandWifiCoverSsidFlag(getWlanInstFromDomain(Wlan[loop].domain));
        }
    }
}

function InitX_HW_Standard()
{  
    var wlgmode = getSelectVal('X_HW_Standard'); 
    var isshow11n = 0;    
    var isshow11ac = 0;	 
    var isshow11a = 0;
    var isantel = (CfgMode.toUpperCase() == 'ANTEL');
    
    for (i = 0; i < Wlan.length; i++) 
    {
        var BeaconType = Wlan[i].BeaconType;    
        var BasicEncryptionModes =  Wlan[i].BasicEncryptionModes;       
        var WPAEncryptionModes  = Wlan[i].WPAEncryptionModes;
        var IEEE11iEncryptionModes = Wlan[i].IEEE11iEncryptionModes;
        var X_HW_WPAand11iEncryptionModes = Wlan[i].X_HW_WPAand11iEncryptionModes;

        var name = Wlan[i].name;
        var portIndex = parseInt(name.charAt(length-1));
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if (portIndex < 4)
            {
                continue;
            }
        }

        if ((1 == DoubleFreqFlag) && ("2G" == wlanpage))
        {
            if (portIndex > 3)
            {
                continue;
            }                    
        }
       
        if ((BeaconType == "Basic") && (BasicEncryptionModes == "WEPEncryption"))
        {
           isshow11n += 1;
           isshow11ac +=1;
        }
       
        else if ((BeaconType =="WPA" )
                   && ((WPAEncryptionModes == "TKIPEncryption")||(WPAEncryptionModes == "TKIPandAESEncryption")))
        {
           isshow11n += 1;           
        }
       
        else if ( ((BeaconType =="11i" ) || (BeaconType =="WPA2") )
                   && ((IEEE11iEncryptionModes == "TKIPEncryption")||(IEEE11iEncryptionModes == "TKIPandAESEncryption")) )
        {
           isshow11n += 1;           
        }
       
        else if ( ((BeaconType =="WPAand11i" ) || (BeaconType =="WPA/WPA2") )
                   && ((X_HW_WPAand11iEncryptionModes == "TKIPEncryption")||(X_HW_WPAand11iEncryptionModes == "TKIPandAESEncryption")))
        {
           isshow11n += 1;           
        }
        
        if (0 == Wlan[i].wmmEnable)
        {
            isshow11n += 1;
        }
        
    }          

    isshow11n += (1 - cap11n) + isantel;
    isshow11a += 1 - cap11a;
    
    $('X_HW_Standard').empty();

    var standardArr = { '11a' : ["802.11a", 0], 
	                  '11b' : ["802.11b", 0], 
	                  '11g' : ["802.11g", 0], 
	                  '11n' : ["802.11n", 0], 
	                  '11bg' : ["802.11b/g", 0], 
					  '11gn' : ["802.11g/n", 0],
	                  '11bgn' : ["802.11b/g/n", 0], 
	                  '11na' : ["802.11a/n", 0], 
	                  '11ac' : ["802.11a/n/ac", 0]
	                };

    standardArr['11n'][1] = (0 == isshow11n);
    
    if ("5G" == wlanpage)
    {
        standardArr['11a'][1] = (0 == isshow11a);
        standardArr['11na'][1] = 1;
        standardArr['11ac'][1] = ((1 == Wlan11acFlag) && (0 == isshow11ac));
    }
    else
    {
        standardArr['11b'][1] = 1;
        standardArr['11g'][1] = !isantel;
        standardArr['11bg'][1] = 1;
		standardArr['11gn'][1] = 1;
        standardArr['11bgn'][1] = 1;
    }

    InitDropDownListWithSelected('X_HW_Standard', standardArr, wlgmode)
    
}

function stWlanAdv(domain,DtimPeriod,BeaconPeriod,RTSThreshold,FragThreshold)
{
    this.domain = domain;
    this.DtimPeriod = DtimPeriod;
    this.BeaconPeriod = BeaconPeriod;
    this.RTSThreshold = RTSThreshold;
    this.FragThreshold = FragThreshold;
}

function stWlanWifi(domain,Name,Enable,SSID,X_HW_Standard,Channel,TransmitPower,RegulatoryDomain,AutoChannelEnable,X_HW_HT20,PossibleChannels, wmmEnable, X_HW_WorkMode,X_IEEE80211wEnabled,X_TxBFEnabled,X_OCCACEnables, X_HW_MCS, X_HW_RSSIThreshold, X_HW_RSSIThresholdEnable, MACAddressControlEnabled, UAPSDEnable)
{
    this.domain = domain;
    this.Name = Name;
    this.Enable = Enable;
    this.SSID = SSID;
    this.X_HW_Standard = X_HW_Standard;
    this.Channel = Channel;
    this.TransmitPower = TransmitPower;
    this.RegulatoryDomain = RegulatoryDomain;
    this.AutoChannelEnable = AutoChannelEnable;
    this.X_HW_HT20 = X_HW_HT20;
    this.PossibleChannels = PossibleChannels;
    this.wmmEnable = wmmEnable;
    this.X_HW_WorkMode = X_HW_WorkMode;
	this.X_IEEE80211wEnabled = X_IEEE80211wEnabled;	
    this.X_TxBFEnabled = X_TxBFEnabled;	
    this.X_OCCACEnables = X_OCCACEnables;		
    this.X_HW_MCS = X_HW_MCS;
    this.X_HW_RSSIThreshold = X_HW_RSSIThreshold;
    this.X_HW_RSSIThresholdEnable = X_HW_RSSIThresholdEnable;
	this.MACAddressControlEnabled = MACAddressControlEnabled;
	this.UAPSDEnable = UAPSDEnable;
}

var WlanAdvs = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.X_HW_AdvanceConf,DtimPeriod|BeaconPeriod|RTSThreshold|FragThreshold,stWlanAdv);%>;
var WlanAdv = WlanAdvs[0];

var WlanBasicArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable|SSID|X_HW_Standard|Channel|TransmitPower|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|PossibleChannels|WMMEnable|X_HW_WorkMode|X_IEEE80211wEnabled|X_TxBFEnabled|X_OCCACEnables|X_HW_MCS|X_HW_RSSIThreshold|X_HW_RSSIThresholdEnable|MACAddressControlEnabled|UAPSDEnable, stWlanWifi);%>;
var WlanBasic = WlanBasicArr[0];
if (null == WlanBasic)
{
    WlanBasic = new stWlanWifi("","","","","11n","","","","","","","","","","","","","","");
}

var uiFirstIndexFor5G = 0;
function WlanWifiInitFor5G()
{
    for (i=0; i < wlanArrLen; i++)
    {
        if ((1 == DoubleFreqFlag) && ("5G" == wlanpage))
        {
            if (('ath4' == WlanArr[i].name) || ('ath5' == WlanArr[i].name) || ('ath6' == WlanArr[i].name) || ('ath7' == WlanArr[i].name))
            {
                uiFirstIndexFor5G = i;        
                WlanBasic = WlanBasicArr[uiFirstIndexFor5G];
                WlanAdv = WlanAdvs[uiFirstIndexFor5G];
                return;
            }
        }
    }
}

function SetWlanWifiDefaultFor2G()
{
    if ("5G" == wlanpage)
    {
        return;
    }

    for (i=0; i < wlanArrLen; i++)
    {
        if (('ath0' == WlanArr[i].name) || ('ath1' == WlanArr[i].name) || ('ath2' == WlanArr[i].name) || ('ath3' == WlanArr[i].name))
        {
            WlanBasic = WlanBasicArr[i];
            WlanAdv = WlanAdvs[i];
            return;
        }
    }
}

function SetWiFiRadioDefault()
{

    if ("5G" == wlanpage)
	{
		WiFiRadio = WiFiRadioArr[1];
	}
	else if("2G" == wlanpage)
	{
	   WiFiRadio = WiFiRadioArr[0];
	}
	else
	{
	}
	
	return;
}
SetWlanWifiDefaultFor2G();
WlanWifiInitFor5G();
SetWiFiRadioDefault();

function stTotalWlanAttr(WlanBasic, WlanAdv,WiFiRadio)
{
	this.TransmitPower = WlanBasic.TransmitPower;
	this.RegulatoryDomain = WlanBasic.RegulatoryDomain;
	this.AutoChannelEnable = WlanBasic.AutoChannelEnable;
	this.GuardInterval = WiFiRadio.GuardInterval;	
	this.X_IEEE80211wEnabled = WlanBasic.X_IEEE80211wEnabled;	
	this.X_TxBFEnabled = WlanBasic.X_TxBFEnabled;
	this.X_OCCACEnables = WlanBasic.X_OCCACEnables;	
	
	if (1 == WlanBasic.AutoChannelEnable)
	{
		this.Channel = 0;
	}
	else
	{
		this.Channel = WlanBasic.Channel;
	}

	this.X_HW_WorkMode = WlanBasic.X_HW_WorkMode;
	this.X_HW_HT20 = WlanBasic.X_HW_HT20;
	this.X_HW_Standard = WlanBasic.X_HW_Standard;
    this.X_HW_MCS = WlanBasic.X_HW_MCS;

	this.DtimPeriod = WlanAdv.DtimPeriod;
	this.BeaconPeriod = WlanAdv.BeaconPeriod;
	this.RTSThreshold = WlanAdv.RTSThreshold;
	this.FragThreshold = WlanAdv.FragThreshold;
}

var TotalWlanAttr = new stTotalWlanAttr(WlanBasic, WlanAdv,WiFiRadio);

function getPossibleChannels(freq, country, mode, width)
{
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/WlanChannel.asp?&1=1",
            data :"freq="+freq+"&country="+country+"&standard="+mode + "&width="+width,
            success : function(data) {
                possibleChannels = data;
            }
        });
}

function load2GChannelList(country, mode)
{
    var WebChannel = getSelectVal('Channel');
    var WebChannelValid = 0;
    var len = document.forms[0].Channel.options.length;

    for (i = 0; i < len; i++)
    {
        document.forms[0].Channel.remove(0);
    }

    document.forms[0].Channel[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");

    for (i = 1; i <= 11; i++)
    {
        if (WebChannel == i)
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[i] = new Option(i, i);
    }

    if (country != "CA" && country != "CO" && country != "DO" && country != "GT" && country != "MX"
        && country != "PA" && country != "PR" && country != "TW" && country != "US" && country != "UZ" && country != "PH")
    {
        if ((WebChannel == 12) || (WebChannel == 13))
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[12] = new Option("12", "12");
        document.forms[0].Channel[13] = new Option("13", "13");
    }
        
    if ((mode == "11b") &&  (country == "JP"))
    {
        if (WebChannel == 14)
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[14] = new Option("14", "14");
    }

    if (1 == WebChannelValid)
    {
        setSelect('Channel', WebChannel);
    }
    else
    {
        setSelect('Channel', 0);    
    }
}


function loadChannelListByFreq(freq, country, mode, width)
{
    var len = document.forms[0].Channel.options.length;
    var index = 0;
    var i;
    var WebChannel = getSelectVal('Channel');
    var WebChannelValid = 0;    

    getPossibleChannels(freq, country, mode, width);
    var ShowChannels = possibleChannels.split(',');

    for (i = 0; i < len; i++)
    {
        document.forms[0].Channel.remove(0);
    }

    document.forms[0].Channel[0] = new Option(cfg_wlancfgadvance_language['amp_chllist_auto'], "0");
    
    for (var j=1; j<=ShowChannels.length; j++)
    {
        if(j==ShowChannels.length)
        {
            for(i = 0; i < ShowChannels[ShowChannels.length-1].length;i++)
            {
                if((ShowChannels[ShowChannels.length-1].charCodeAt(i)< 0x30)||(ShowChannels[ShowChannels.length-1].charCodeAt(i) > 0x39))
                {
                    index = i;
                    break;
                    
                }
            }
            ShowChannels[j-1] = ShowChannels[ShowChannels.length-1].substring(0,index);
        }
        
        if (WebChannel == ShowChannels[j-1])
        {
            WebChannelValid = 1;
        }
        document.forms[0].Channel[j] = new Option(ShowChannels[j-1], ShowChannels[j-1]);
    }

    if (1 == WebChannelValid)
    {
        setSelect('Channel', WebChannel);
    }
    else
    {
        setSelect('Channel', 0);    
    }
}

function loadChannelList(country, mode, width)
{
    var freq = '2G';
    if ("5G" == wlanpage)
    {
        freq = '5G';
    }
    loadChannelListByFreq(freq, country, mode, width);
}

function wmmChange()
{
	var wmmEnable = (getRadioVal("enableWmm") == "wmmON") ? "1" : "0";
	setDisplay('powersaving', 1);
    if ((0 == wmmEnable) && ((WlanBasic.X_HW_Standard == "n") || (WlanBasic.X_HW_Standard == "11bgn") || (WlanBasic.X_HW_Standard == "11gn") || (WlanBasic.X_HW_Standard == "11na")))
    {
        AlertEx(cfg_wlancfgother_language['amp_wlan_wmm_disable_notify']);
    }
}

function disablewmmChange()
{
	setDisplay('powersaving', 0);
	var wmmEnable = (getRadioVal("enableWmm") == "wmmON") ? "1" : "0";
	if ((0 == wmmEnable) && ((WlanBasic.X_HW_Standard == "n") || (WlanBasic.X_HW_Standard == "11bgn") || (WlanBasic.X_HW_Standard == "11gn") || (WlanBasic.X_HW_Standard == "11na")))
    {
        AlertEx(cfg_wlancfgother_language['amp_wlan_wmm_disable_notify']);
    }
	setDisplay('powersaving', 0);
}

function onClickMacFilterEnable($this)
{	
	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : "x.WlanMacFilterRight="+1+"&x.X_HW_Token="+getValue('onttoken'),
		 url : "set.cgi?x=InternetGatewayDevice.X_HW_Security&RequestFile="+RequestFile,
		 success : function(data) {
			$('#mac_filter_table_add_device').show();
			$('#mac_filter_table_list_device').show();
		 },
		 complete: function (XHR, TS) {
			XHR=null;
		 }
    });
}

function onClickMacFilterDisable($this)
{
	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : "x.WlanMacFilterRight="+0+"&x.X_HW_Token="+getValue('onttoken'),
		 url : "set.cgi?x=InternetGatewayDevice.X_HW_Security&RequestFile="+RequestFile,
		 success : function(data) {
			$('#mac_filter_table_add_device').hide();
			$('#mac_filter_table_list_device').hide();
		 },
		 complete: function (XHR, TS) {
			XHR=null;
		 }
    });
}
function X_HW_StandardChange()
{
    var mode = getSelectVal('X_HW_Standard');

    var channelWidthRestore = getSelectVal('X_HW_HT20');
    var channel = getSelectVal('Channel');
    var country = WlanBasic.RegulatoryDomain;
	
    var len = document.forms[0].X_HW_HT20.options.length;
    var lenChannel = document.forms[0].Channel.options.length;

    if ((14 == channel) && ("11b" != mode))
    {
        setSelect('Channel', 0);
    }

    for (i = 0; i < len; i++)
    {
        document.forms[0].X_HW_HT20.remove(0);
    }

    if ((mode == "11b") || (mode == "11g") || (mode == "11bg") || (mode == "11a"))
    {    
        document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
    }
    else
    {
        if (CfgMode.toUpperCase() == 'ANTEL')
        {
            document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
            document.forms[0].X_HW_HT20[1] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_40'], "2");
        }
        else
        {
            document.forms[0].X_HW_HT20[0] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_auto2040'], "0");
            document.forms[0].X_HW_HT20[1] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_20'], "1");
            document.forms[0].X_HW_HT20[2] = new Option(cfg_wlancfgadvance_language['amp_chlwidth_40'], "2");
        }
        
        if ( (1 == Wlan11acFlag) && (1 == DoubleFreqFlag) && ("5G" == wlanpage) && (mode == "11ac") )
        {
            if (country != "RU")
            {
                document.forms[0].X_HW_HT20[3] = new Option(cfg_wlancfgadvance_language[chlwidth80Res], "3");			
            }
        }

        if ((3 != channelWidthRestore) || (mode == "11ac"))
        {
            setSelect('X_HW_HT20', channelWidthRestore);
        }
        else
        {
            setSelect('X_HW_HT20', 0);
        }
    }

	var width = getValue('X_HW_HT20');
    loadChannelList(country, mode, width);
}

function X_HW_HT20Change()
{
	X_HW_StandardChange();
}

function ChannelChange()
{

}

function WifiAdvanceShow(enable)
{
	if ((0 == enable) || (WlanAdv == null) || (WlanBasic == null))
	{
		setDisplay('div_wlanadv', 0);
	}
	else
	{
		setDisplay('div_wlanadv', 1);
	}
}

function RemoveDropDownListTransmitPower()
{
    var len = document.forms[0].TransmitPower.options.length;    

    for (i = 0; i < len; i++)
    {
        document.forms[0].TransmitPower.remove(0);
    }
}

function RebuildWlanBasicDropDownList()
{
	InitX_HW_Standard();
    X_HW_StandardChange();
}

function LoadFrameWifi()
{
	SetWlanWifiDefaultFor2G();
    
    WlanWifiInitFor5G();
	
	SetWiFiRadioDefault();

    Total2gNum();
	
	initMacFilter();
	
	
    if (1 == DoubleFreqFlag)
    {
        if (1 == enbl)
        {
            if ('2G' == wlanpage)
            {
            	document.getElementById('mac_address').innerHTML = bssid_2;
                WifiAdvanceShow((enbl2G != "0") && (uiTotal2gNum > 0));
            }
            
            if ('5G' == wlanpage)
            {
            	document.getElementById('mac_address').innerHTML = bssid_5;
                WifiAdvanceShow((enbl5G != "0") && (uiTotal5gNum > 0));
            }
        }
        else
        {
            WifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
        }
 
        if (IsSonetSptUser())
        {
			setDisplay('RegulatoryDomain' + 'Row', 0);
        }
    }
    else       
    {
        WifiAdvanceShow((enbl != "0") && (uiTotalNum > 0));
    }
	
	InitX_HW_Standard();
}

function CancelConfig()
{
    RemoveDropDownListTransmitPower();

	InitWlanBasicDropDownList();

	showWlanAdvance();
	RebuildWlanBasicDropDownList();
}


function stInitOption(value, innerText)
{
	this.value = value;
	this.innerText = innerText;
}

function InitDropDownList(id, ArrayOption)
{
    var Control = getElById(id);
    var i = 0;   

    for(i = 0; i < ArrayOption.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = ArrayOption[i].value;
        Option.innerText = ArrayOption[i].innerText;
        Option.text = ArrayOption[i].innerText;
        Control.appendChild(Option);
    }
}

function InitTransmitPowerList(id)
{
	if(1 == TelMexFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("75","75%"), new stInitOption("50","50%"), new stInitOption("25","25%"));
	}else if (1 == PccwFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","HongKong"), new stInitOption("80","Europe"), new stInitOption("60","USA"));
		if ("PCCW4MAC" == CfgMode.toUpperCase())
		{
		    var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("80","80%"), new stInitOption("60","60%"), new stInitOption("40","40%"), new stInitOption("20","20%"));
		}
	}else if (1 == AisFlag)
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","Default"), new stInitOption("50","Thailand"));	
	}else
	{
        var ArrayTransmitPower = new Array(new stInitOption("100","100%"), new stInitOption("80","80%"), new stInitOption("60","60%"), new stInitOption("40","40%"), new stInitOption("20","20%"));
	}

    InitDropDownList(id, ArrayTransmitPower);
}

function InitChannelList(id)
{
    if((1 == DoubleFreqFlag) && ("5G" == wlanpage))
	{
		var ArrayChannel = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chllist_auto']),
									 new stInitOption("36",36), new stInitOption("40",40), new stInitOption("44",44), new stInitOption("48",48), 
									 new stInitOption("52",52), new stInitOption("56",56), new stInitOption("60",60), new stInitOption("64",64), 
									 new stInitOption("100",100), new stInitOption("104",104), new stInitOption("108",108), new stInitOption("112",112), 
									 new stInitOption("116",116), new stInitOption("120",120), new stInitOption("124",124), new stInitOption("128",128), 
									 new stInitOption("132",132), new stInitOption("136",136), new stInitOption("140",140), new stInitOption("144",144), 
									 new stInitOption("149",149), new stInitOption("153",153), new stInitOption("157",157), new stInitOption("161",161), 
									 new stInitOption("165",165));	
	}
	else
	{
		var ArrayChannel = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chllist_auto']),
									 new stInitOption("1",1), new stInitOption("2",2), new stInitOption("3",3), new stInitOption("4",4), 
									 new stInitOption("5",5), new stInitOption("6",6), new stInitOption("7",7), new stInitOption("8",8), 
									 new stInitOption("9",9), new stInitOption("10",10), new stInitOption("11",11), new stInitOption("12",12), 
									 new stInitOption("13",13), new stInitOption("14",14));
	}

    InitDropDownList(id, ArrayChannel);
}

function InitChannelWidthList(id)
{
	if(CfgMode.toUpperCase() == 'ANTEL')
	{
        var ArrayChannelWidth = new Array(new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']),
										  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']));
	}else
	{
		if((1 == Wlan11acFlag) && (1 == DoubleFreqFlag) && ("5G" == wlanpage) && (WlanBasic.X_HW_Standard == "11ac"))
		{
            var ArrayChannelWidth = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chlwidth_auto2040']), 
											  new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']), 
											  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']),
											  new stInitOption("3",cfg_wlancfgadvance_language[chlwidth80Res]));
		}else
		{
            var ArrayChannelWidth = new Array(new stInitOption("0",cfg_wlancfgadvance_language['amp_chlwidth_auto2040']), 
											  new stInitOption("1",cfg_wlancfgadvance_language['amp_chlwidth_20']), 
											  new stInitOption("2",cfg_wlancfgadvance_language['amp_chlwidth_40']));
		}
    }

    InitDropDownList(id, ArrayChannelWidth);
}

function InitHwStandardList(id)
{
    var ArrayHwStandard = new Array(new stInitOption("11a","802.11a"), new stInitOption("11na","802.11a/n"), new stInitOption("11ac","802.11a/n/ac"), 
	 								new stInitOption("11b","802.11b"), new stInitOption("11g","802.11g"), new stInitOption("11n","802.11n"),
									new stInitOption("11bg","802.11b/g"), new stInitOption("11gn", "802.11g/n"), new stInitOption("11bgn","802.11b/g/n"));
    InitDropDownList(id, ArrayHwStandard);
}

function InitWlanBasicDropDownList()
{
	InitTransmitPowerList("TransmitPower");
	InitChannelList("Channel");
	InitChannelWidthList("X_HW_HT20");
	InitHwStandardList("X_HW_Standard");
}

function AddSubmitParam(Form,type)
{
	var wmmEnable = (getRadioVal("enableWmm") == "wmmON") ? "1" : "0";

	var macFilterEnable = (getRadioVal("enablemacFilter") == "macFilterON") ? "1" : "0";
	
	var pSavingWmmEnable = (getRadioVal("psavingenableWmm") == "psavewmmON") ? "1" : "0";
	
    if (getSelectVal('Channel') == 0)
    {
        Form.addParameter('y.Channel',getSelectVal('Channel'));
        Form.addParameter('y.AutoChannelEnable',1); 
    }
    else
    {
        Form.addParameter('y.Channel',getSelectVal('Channel'));
        Form.addParameter('y.AutoChannelEnable',0);
    }
	
    Form.addParameter('y.X_HW_HT20',getSelectVal('X_HW_HT20'));
	
	if (wmmEnable == '1')
	{
		Form.addParameter('y.UAPSDEnable', pSavingWmmEnable);
	}
    
    Form.addParameter('y.TransmitPower',getSelectVal('TransmitPower'));      
    Form.addParameter('y.X_HW_Standard',getSelectVal('X_HW_Standard'));
	Form.addParameter('y.WMMEnable', wmmEnable);
	Form.addParameter('y.MACAddressControlEnabled', macFilterEnable);
	
	Form.setAction('set.cgi?x=' + WlanBasic.domain + '.X_HW_AdvanceConf'
				   + '&y=' + WlanBasic.domain
				   + '&r=' + WiFiRadio.domain
				   + '&RequestFile=html/amp/wlanadv/bztlfWlanAdvance.asp');
    
	setDisable('btnApply', 1);
    setDisable('btnCancel', 1);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));  
}

function CheckForm(type)
{
        if((getSelectVal('TransmitPower') == "") || (getSelectVal('RegulatoryDomain') == "") || (getSelectVal('Channel') == "") 
        || (getSelectVal('X_HW_Standard') == "") || (getSelectVal('X_HW_HT20') == ""))
        {
              AlertEx(cfg_wlancfgother_language['amp_basic_empty']);
                   return false;
        }
		
		if((1 == PccwFlag) && (1 == DoubleFreqFlag) && ("PCCW4MAC" != CfgMode.toUpperCase()))
            {
                var pccw_TxPwr = getSelectVal('TransmitPower');
                if( pccw_TxPwr != WlanBasic.TransmitPower)
                {
                    AlertEx(cfg_wlancfgother_language['amp_wlancfg_resetvalid']);
                }
            }

    if(!isWlanInitFinished(wlanpage, WlanBasic.X_HW_Standard, WlanBasic.X_HW_HT20))
    {
        return false;
    }
    
    return true;
}

function showWlanAdvance()
{
	setSelect('TransmitPower',WlanBasic.TransmitPower);
	setSelect('X_HW_Standard',WlanBasic.X_HW_Standard);
	setSelect('X_HW_HT20',WlanBasic.X_HW_HT20);
	setSelect('Channel',WlanBasic.Channel);
	setRadio("enableWmm", ("1" == WlanBasic.wmmEnable) ? "wmmON" : "wmmOFF");
	setRadio("psavingenableWmm", ("1" == WlanBasic.UAPSDEnable) ? "psavewmmON" : "psavewmmOFF");
	if ("1" == WlanBasic.wmmEnable)
	{
		setDisplay('powersaving', 1);
	}
	else
	{
		setDisplay('powersaving', 0);
	}
	setRadio("enablemacFilter", ("1" == WlanBasic.MACAddressControlEnabled) ? "macFilterON" : "macFilterOFF");
}

	var RequestFile = 'html/amp/wlanadv/bztlfWlanAdvance.asp';//
	var locationRequestFile = 'bztlfWlanAdvance.asp';
	var enableFilter = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.WlanMacFilterRight);%>';
	var userDevices = new Array();
	
	var macAddress = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.AllowedMACAddresses);%>';
	var MacFilter = new Array();
	
	function initMacFilter(){
		if(enableFilter==1){
			setRadio("enableWlanMacFilter", "macFilterON");
			$('#mac_filter_table_add_device').show();
			$('#mac_filter_table_list_device').show();
		}else{
			setRadio("enableWlanMacFilter", "macFilterOFF");
			$('#mac_filter_table_add_device').hide();
			$('#mac_filter_table_list_device').hide();
		}
	}
	
	function initWlanMacHostName(){
		GetLanUserDevInfo(function(para1)
		{	
			this.userDevices = para1;
			
			getHostNameList(userDevices);
			getRelateMac();
            			
			initAuthorizedDevices(userDevices);
		});	
	}
	function inputSet(obj,key,value){
		obj.each(function(){
			if(key=='disabled'){
				$(this).attr(key,value);
				if(value==true){
					$(this).css({'border-width':'0px'});
					
				}else{
					$(this).css({'border-width':'1.8px'});
				}
			}
		});
	
	}
	function getHostNameByMac(userDevices,macAddress){
		for(var i=0; i<userDevices.length-1;i++){
			if(userDevices[i].MacAddr==macAddress){
				return userDevices[i].HostName;
			}
		}
		return "--";
	}
	function initMacFilterList(){
		if (macAddress != "")
		{
			var MacFilterSrc = macAddress.split(",");
			for (var i = 0; i < MacFilterSrc.length; i++)
			{
				MacFilter.push({domain:i,MACAddress:MacFilterSrc[i]}); 
			}
		}
		MacFilter.push(null);
	}
	
	function getHostNameList(userDevices){        
		for(var i=0;i<userDevices.length - 1;i++){
                $('#hostName').append('<option title="' + htmlencode(userDevices[i].HostName) 
                    + '" value="'+userDevices[i].MacAddr+ '">'+GetStringContent(htmlencode(userDevices[i].HostName),32)+'</option>');  
		}

        if(userDevices.length == 0)
        {
            $('#hostName').append('<option title="" value=""></option>'); 
        }
	}
	
	function getRelateMac(){
		var macAddr = $('#hostName').val();
        if (macAddr == null)
        {
            macAddr = '';
        }
		setText("macAddress", macAddr);	
	}
	
	function isRepeatMacAddrCon(macAddr){
		for(var i = 0; i < MacFilter.length - 1; i++){
			if(macAddr.toUpperCase() == MacFilter[i].MACAddress.toUpperCase()){
				return true;
			}			
		}
		return false;
	}
	
	function CheckMac(macAddress){		
		if (macAddress == "")
		{
			msg = dhcpstatic_language['bbsp_macnull'];
			AlertEx(msg);
			return false;
		}

		if(isValidMacAddress(macAddress) == false)
		{
			AlertEx(dhcpstatic_language['bbsp_mac']+ macAddress + dhcpstatic_language['bbsp_invalid']);
			return false;
		}	
			
		return true;
	}
	
	function AddMACList()
	{
        if (MacFilter.length - 1 >= 28)
	    {
	        AlertEx(wlanmacfil_language['bbsp_rulenum3']);
	        return;
	    }
		var macAddress = getValue('macAddress');
		if (false == CheckMac(macAddress))
		{
			$('#macAddress').focus();
			return;
		}        
		
		setDisable('btnAddWlanMac',1);
		
		var stMacAddress = '';
		for (var i = 0; i < MacFilter.length - 1; i++)
		{
			stMacAddress += MacFilter[i].MACAddress;
			stMacAddress += ',';
		}
		stMacAddress += macAddress;
		toInterface(stMacAddress);

		window.location.reload();
	}
	
	function toInterface(stMacAddress){
		$.ajax({
			 type : "POST",
			 async : false,
			 cache : false,
			 data : "x.AllowedMACAddresses="+stMacAddress+"&x.X_HW_Token="+getValue('onttoken'),
			 url : "setajax.cgi?x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement&RequestFile="+RequestFile,
			 success : function(data) {
			 },
			 complete: function (XHR, TS) {
				XHR=null;
			 }
		});
		 
	}
	
	function checkAllMacFilterList()
	{
		var check = true;
		
		$('#authorizedDevices input.messageInput.edit').each(function(index){
			var macAddress = $(this).val();
			if(false == CheckMac(macAddress)){
				$(this).focus();
				check = false;
				return false;
			}
		});
		
		return check;
	}
	
	function getNewMacFilterList()
	{
		var newMacfilterList = new Array();
		$('#authorizedDevices input.messageInput.edit').each(function(index){
			newMacfilterList.push($(this).val());
		});
		
		return newMacfilterList;
	}
	
	
	function ApplyMACList()
	{
		if(false == checkAllMacFilterList())
		{
			return;
		}
		
		var NewMacfilterList = getNewMacFilterList();
		
		if(0 == NewMacfilterList.length){
			return;
		}
		
		var stMacAddress = "";
		for (var i = 0; i < NewMacfilterList.length; i++)
		{
			stMacAddress += NewMacfilterList[i];

			stMacAddress += ',';
		}
		stMacAddress = stMacAddress.substring(0, stMacAddress.length-1);
		toInterface(stMacAddress);
		
		window.location.reload();
	}
	
	function initAuthorizedDevices(userDevices){
		$('#authorizedDevices').html('');
		setDisable('applyMac',1);
		var reservationListTr = '';
		if (MacFilter.length <= 1){
			return;
		}
		
		for(var i=0;i< MacFilter.length - 1;i++){
			var classname =  (i%2==0)?"cinza":"cinza2";
			var trid = 'authorizedDevices_tr' + i;
			var hostname = htmlencode(getHostNameByMac(userDevices, MacFilter[i].MACAddress));
		
			reservationListTr += '<tr id="' + trid +'">'
				+'<td class="' + classname + '"><input type="text" class="messageInput" value="'+ GetStringContent(hostname, 20)+ '" title="' + hostname + '"></td>'
				+'<td class="' + classname + '"><input type="text" class="messageInput edit" style="backgroud-color:red" maxlength="17" value="'+ htmlencode(MacFilter[i].MACAddress)+'"></td>'
				+'<td class="' + classname + '">'
				+'<div class="actions">'
				+'<a class="action edit"><img class="img-actions" src="../../../images/edit2.gif" onclick="editReservation(this, ' + i+ ');return false;"></a> '
				+'<a class="action delete"><img class="img-actions" src="../../../images/trash.gif" onclick="deleteReservation(this, ' + i+ ');return false;"></a>' 
				+'</div>'
				+'</td>'
				+'</tr>';
		}

		$('#authorizedDevices').html(reservationListTr);
		inputSet($('#authorizedDevices input.messageInput'),'disabled',true);
	}
	
	function editReservation(obj, index){
		var curRow = $("#authorizedDevices_tr"+index).children('td');
		
		if($(curRow.children('input.messageInput.edit')[0]).attr('disabled')=='disabled'){
			$(obj).attr('src','../../../images/ok.gif');
			inputSet(curRow.children('input.messageInput.edit'),'disabled',false);
            curRow.children('input.messageInput.edit').css({"border":"1px solid rgb(168, 166, 166)", "background":"#fff"});
			setDisable('applyMac',0);
		}else{			
			var hostName = $(curRow.children('input.messageInput')[0]).val();
			var macAddress = $(curRow.children('input.messageInput')[1]).val();
			
			if(!CheckMac(macAddress)){
				return;
			}
			
			$(obj).attr('src','../../../images/edit2.gif');
			inputSet(curRow.children('input.messageInput.edit'),'disabled',true);
            curRow.children('input.messageInput.edit').css({"border":"0 solid #e4e4e4", "background-color":"transparent"});

			if(MacFilter[index].MACAddress.toUpperCase() == macAddress.toUpperCase())
			{
				setDisable('applyMac',1);
				return;
			}
			
			MacFilter[index].MACAddress = macAddress;
			var stMacAddress = "";
			for (var i = 0; i < MacFilter.length - 1; i++)
			{
				stMacAddress += MacFilter[i].MACAddress;

				stMacAddress += ',';
			}
			stMacAddress = stMacAddress.substring(0, stMacAddress.length-1);
			
			toInterface(stMacAddress);
			
			window.location.reload();
		}		
	}
	
	function deleteReservation(obj, index){
	
		var stMacAddress = "";
		for (var i = 0; i < MacFilter.length - 1; i++)
		{
			if(i==index)continue;
			stMacAddress += MacFilter[i].MACAddress;
			stMacAddress += ',';
		}
		stMacAddress = stMacAddress.substring(0, stMacAddress.length-1);
		
		toInterface(stMacAddress);
		
		window.location.reload();
	}
	
	$(function(){
		initMacFilterList();
		initWlanMacHostName();
	});
</script>

</head>
<body  class="iframebody" onLoad="LoadFrameWifi();" style="text-align: left;">
<div class="title_spread"></div>

<form id = "wlanadvForm">
<div id="div_wlanadv">

<table class="setupWifiTable">
	<thead>
		<th colspan="2" BindText="amp_wifivivo_advancedsettings"></th>
	</thead>

	<tr>
		<td style="width:200px;" BindText="amp_wifivivo_operation_mode"></td>
		<td>
			<select name="X_HW_Standard" id = "X_HW_Standard" onchange ="X_HW_StandardChange();"></select> 
		</td>
	</tr> 

	<tr>
		<td BindText="amp_wifivivo_channel"></td>
		<td>
			<select name="Channel" id = "Channel" ></select>
		</td>
	</tr>                        

	<tr>
		<td BindText="amp_wifivivo_channel_bandwidth"></td>
		<td><select name="X_HW_HT20" id = "X_HW_HT20" onchange ="X_HW_HT20Change();"></select></td>
	</tr>

	<tr>
		<td BindText="amp_wifivivo_transmit_power"></td>
		<td><select name="TransmitPower" id = "TransmitPower" ></select></td>
	</tr>
	
	<tr>
		<td BindText="amp_wifivivo_wmm"></td>
		<td>
			<input type="radio" name="enableWmm" id="enableWmm" value="wmmON" onclick = "wmmChange()"/> </input><span BindText="amp_wifivivo_on"></span> &nbsp;&nbsp; 
			<input type="radio" name="enableWmm" id="enableWmm" value="wmmOFF" onclick = "disablewmmChange()"/> </input><span BindText="amp_wifivivo_off"></span> 
		</td>
	</tr>

	<tr id = "powersaving">
		<td BindText="amp_wifivivo_powersaving_wmm"></td>
		<td>
			<input type="radio" name="psavingenableWmm" id="psavingenableWmm" value="psavewmmON" /> </input><span BindText="amp_wifivivo_on"></span> &nbsp;&nbsp; 
			<input type="radio" name="psavingenableWmm" id="psavingenableWmm" value="psavewmmOFF" /> </input><span BindText="amp_wifivivo_off"></span> 
		</td>
	</tr>

	<tr>
		<td BindText="amp_wifivivo_mac_address"></td>
		<td id = "mac_address" name = "mac_address"></td>
	</tr>
	<tr>
		<td BindText = "amp_wifivivo_frequency_band"></td>		
		<td id = "wifi_frequency" name = "wifi_frequency">
		<script>
		if (wlanpage == '5G')
		{
			document.getElementById('wifi_frequency').innerHTML = '5 GHz';
		}
		else
		{
			document.getElementById('wifi_frequency').innerHTML = '2.4 GHz';
		}
		</script>
		</td>
	</tr>

	<tr>
		<td BindText="amp_wifivivo_mac_filter"></td>
		<td>
			<input type="radio" name="enableWlanMacFilter" id="enablemacFilter" value="macFilterON" onchange="onClickMacFilterEnable(this);" onclick=""/> </input><span BindText="amp_wifivivo_on"></span> &nbsp;&nbsp; 
			<input type="radio" name="enableWlanMacFilter" id="disablemacFilter" value="macFilterOFF" onchange="onClickMacFilterDisable(this);" onclick=""/> </input><span BindText="amp_wifivivo_off"></span> 
		</td>
	</tr>
	<tr>				
		<td colspan="2" class="text-right">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<a href="#" id="btnCancel" class="btn-default-orange-small right" onClick="CancelConfig();"><span BindText="amp_wifivivo_cancel"></span></a>
			<a href="#" id="btnApply" class="btn-default-orange-small right"  onClick="Submit();"><span BindText="amp_wifivivo_apply"></span></a>
		</td>
	</tr>
</table>



	<table class="setupWifiTable" style="display: none;" id="mac_filter_table_add_device">
		<thead>
			<tr>
				<th colspan="2" BindText="bbsp_wifivivo_macFilter"></th>
			</tr>
			<tr>
				<th BindText="bbsp_wifivivo_mac_hostName"></th>
				<th BindText="bbsp_wifivivo_mac_macAddress"></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><select id="hostName" name="" onchange="getRelateMac()">
					</select></td>
				<td style="text-align:center;"><input name="" type="text"  id="macAddress" maxlength="17"></input>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<button  id="btnAddWlanMac" class="btn-default-orange-small right" onclick="AddMACList();return false;"><span BindText="bbsp_wifivivo_mac_allow"></span></button>
				</td>
			</tr>
		</tbody>
	</table>
	
	<table class="setupWifiTable" style="display: none;" id="mac_filter_table_list_device">
		<thead>
			<tr>
				<th colspan="3" BindText="bbsp_wifivivo_authorizedDevices"></th>
			</tr>
			<tr>
				<th BindText="bbsp_wifivivo_authorized_hostName"></th>
				<th BindText="bbsp_wifivivo_authorized_macAddress"></th>
				<th BindText="bbsp_wifivivo_authorized_set"></th>
			</tr>
		</thead>
		<tbody id="authorizedDevices">
			
		</tbody>
		<tfoot>
			<tr>
				<td colspan="3">
				<button id="applyMac" href="#" class="btn-default-orange-small right" disabled="disabled" onclick="ApplyMACList();return false;"><span BindText="bbsp_wifivivo_apply">Apply</span></button>
				</td>
			</tr>
		</tfoot>
	</table>
</div>
<script>
	ParseBindTextByTagName(cfg_wlancfgadvanced_tdevivo_language, "div",  1);
	ParseBindTextByTagName(cfg_wlancfgadvanced_tdevivo_language, "td",  1);
	ParseBindTextByTagName(cfg_wlancfgadvanced_tdevivo_language, "span",  1);
	ParseBindTextByTagName(cfg_wlancfgadvanced_tdevivo_language, "input", 2);
	ParseBindTextByTagName(cfg_wlancfgadvanced_tdevivo_language, "th", 1);
	InitWlanBasicDropDownList();
	showWlanAdvance();	
	RebuildWlanBasicDropDownList();
</script>
</form>
</body>
</html>

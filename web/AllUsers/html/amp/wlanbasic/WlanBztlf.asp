<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(gateway.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/wlan_list.asp"></script>

<script language="JavaScript" type="text/javascript">

var isFireFox4 = 0;
if (navigator.userAgent.toLowerCase().indexOf('firefox/4.0') > 0)
{
	isFireFox4 = 1;
}

var WPAPSKFlag = '<%HW_WEB_GetFeatureSupport(FT_WLAN_WPAPSK_SUPPORT);%>';
var wlanpage;
if (location.href.indexOf("WlanBztlf.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanBasicPage = wlanpage;
}

wlanpage = top.WlanBasicPage;
initWlanCap(wlanpage);

var ssidIdx = 0;

function stWlan(domain,name,enable,ssid,wlShow,BeaconType,BasicEncryptionModes,BasicAuthenticationMode,
                WEPKeyIndex,WEPEncryptionLevel,WPAEncryptionModes,WPAAuthenticationMode,IEEE11iEncryptionModes,IEEE11iAuthenticationMode,
                X_HW_WPAand11iEncryptionModes,X_HW_WPAand11iAuthenticationMode,X_HW_ServiceEnable,mode,channel,Country,AutoChannelEnable,
                X_HW_HT20,wmmEnable,MACAddressControlEnabled)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
    this.ssid = ssid;
    this.wlShow = wlShow;
    this.BeaconType = BeaconType;
    this.BasicEncryptionModes = BasicEncryptionModes;
    this.BasicAuthenticationMode = BasicAuthenticationMode;
    this.KeyIndex = WEPKeyIndex;
    this.WEPEncryptionLevel = WEPEncryptionLevel;
    this.WPAEncryptionModes = WPAEncryptionModes;
    this.WPAAuthenticationMode = WPAAuthenticationMode;
    this.IEEE11iEncryptionModes = IEEE11iEncryptionModes;
    this.IEEE11iAuthenticationMode = IEEE11iAuthenticationMode;
    this.X_HW_WPAand11iEncryptionModes = X_HW_WPAand11iEncryptionModes;
    this.X_HW_WPAand11iAuthenticationMode = X_HW_WPAand11iAuthenticationMode;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.mode = mode;
    this.channel = parseInt(channel);
    this.RegulatoryDomain = Country;
    this.AutoChannelEnable = parseInt(AutoChannelEnable);
    this.X_HW_HT20 = X_HW_HT20;
    this.wmmEnable = wmmEnable;
    this.MACAddressControlEnabled = MACAddressControlEnabled;
}

function stWEPKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

function stPreSharedKey(domain, psk, kpp)
{
    this.domain = domain;
    this.value = psk;

    if('1' == kppUsedFlag)
    {
        this.value = kpp;
    }
}

function stExtendedWLC(domain, SSIDIndex)
{
    this.domain = domain;
    this.SSIDIndex = SSIDIndex;
}

function stLanDevice(domain, WlanCfg, Wps2)
{
    this.domain = domain;
    this.WlanCfg = WlanCfg;
    this.Wps2 = Wps2;
}

function stWpsPin(domain, X_HW_ConfigMethod, DevicePassword, X_HW_PinGenerator, Enable)
{
    this.domain = domain;
    this.X_HW_ConfigMethod = X_HW_ConfigMethod;
    this.DevicePassword = DevicePassword;
    this.X_HW_PinGenerator = X_HW_PinGenerator;
    this.Enable = Enable;
}

var LanDeviceArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1, X_HW_WlanEnable|X_HW_Wps2Enable, stLanDevice,EXTEND);%>;
var LanDevice = LanDeviceArr[0];

var enbl = LanDevice.WlanCfg;
var Wps2 = LanDevice.Wps2;

var WlanCus = '<%HW_WEB_GetWlanCus();%>';
var WpsCapa = WlanCus.split(',')[0];

var wpsPinNum = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.WPS,X_HW_ConfigMethod|DevicePassword|X_HW_PinGenerator|Enable,stWpsPin, STATUS);%>;


function ssidNullCheckAndSet()
{
    if(null == Wlan)
    {
        isSsidNull = true;
        Wlan = new stWlan("InternetGatewayDevice.LANDevice.1.WLANConfiguration.1","",0,"",0,"","","",1,"","","","","","","",0,"",0,"",0,"",0,0);
        pwdPsk = "";
        pwdWep = "";
    }
    else
    {
        pwdPsk = pwdPsk[0].value;
        pwdWep = pwdWep[Wlan.KeyIndex - 1].value;
    }
}



var Wlan = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1,Name|Enable|SSID|SSIDAdvertisementEnabled|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_ServiceEnable|X_HW_Standard|Channel|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|WMMEnable|MACAddressControlEnabled,stWlan);%>;

var pwdPsk = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1,PreSharedKey|KeyPassphrase,stPreSharedKey);%>;

var pwdWep = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.WEPKey.{i},WEPKey,stWEPKey);%>;

var isSsidNull = false;

if(wlanpage == "5G")
{
    Wlan = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2,Name|Enable|SSID|SSIDAdvertisementEnabled|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WEPKeyIndex|WEPEncryptionLevel|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_ServiceEnable|X_HW_Standard|Channel|RegulatoryDomain|AutoChannelEnable|X_HW_HT20|WMMEnable|MACAddressControlEnabled,stWlan);%>;
    
    pwdPsk = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2.PreSharedKey.1,PreSharedKey|KeyPassphrase,stPreSharedKey);%>;
    
    pwdWep = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2.WEPKey.{i},WEPKey,stWEPKey);%>;
    wpsPinNum = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2.WPS,X_HW_ConfigMethod|DevicePassword|X_HW_PinGenerator|Enable,stWpsPin, STATUS);%>;
        
}
Wlan = Wlan[0];
ssidNullCheckAndSet();


var urlNode = '';
var Form = null;
var pwdType = "-1";
var wlanInst = getWlanInstFromDomain(Wlan.domain);
var beaconType = Wlan.BeaconType;

var apExtendedWLC = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.X_HW_APDevice.{i}.WifiCover.ExtendedWLC.{i}, SSIDIndex, stExtendedWLC, EXTEND);%>;

if(Wlan.BeaconType == "Basic" && Wlan.BasicAuthenticationMode == "SharedAuthentication")
{
    beaconType = "Shared";
}



function authModeChange()
{
    encryTypeChange();
    if (IsWpsConfigDisplay() == true)
    {
        displayWpsConfig();
    }
    else
    {
        HideWpsConfig();
    }
}

function encryTypeChange(encry)
{
    var encry = getSelectVal('wlAuthMode');
    var type = "psk";
    var pwd = pwdPsk;
    if(encry == "Basic")
    {
        type = "";
        pwd = "";
    }
    else if(encry == "Shared")
    {
        type = "wep";
        pwd = pwdWep;
    }

    setWiFiPwd(pwd, type);
}

function onClickWpsEnable()
{
    if ('wpsON' == getRadioVal("wpsEnable"))
    {
        setDisplay("trwpsmode", 1);
        onClickWpsMode()
    }
    else
    {
        setDisplay("trwpsmode", 0);
        setDisplay("trwpspin", 0);
    }
}

function onClickWpsMode()
{
    if ('wpsPIN' == getRadioVal("wpsMode"))
    {
        setText("wpspinnum", changeToPinNumber(wpsPinNum[0].DevicePassword,8));
        setDisplay("trwpspin", 1);
    }
    else
    {
        setDisplay("trwpspin", 0);
    }
}

function IsAuthModePsk(AuthMode)
{
    if (AuthMode == 'WPA' || AuthMode == '11i' || AuthMode == 'WPAand11i')
    {
        return true;
    }
    else
    {
        return false;
    }
}

function IsWpsConfigDisplay( )
{
    var AuthMode = getSelectVal('wlAuthMode');
    
    
    if ('1' == '<%HW_WEB_GetFeatureSupport(FT_WLAN_MULTI_WPS_METHOD);%>')
    {
	    return false;
    }

    if (IsAuthModePsk(AuthMode))
    {
        if (((Wps2 == 1) && (AuthMode == 'WPA')) || (WpsCapa == 0))
        {
        	return false;
        }

        if(0 == wps1Cap)
        {
            if((AuthMode == '11i'))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
        return true;
    }

    return false;
}

function changeToPinNumber(number,length)
{
    var pinNumber = '';
    for (var i = 0; i < length-number.length; i++)
    {
        pinNumber += '0';
    }
    pinNumber += number;
    return pinNumber;
}

function HideWpsConfig()
{
    setDisplay("tbWPS",0);
    setDisplay("trwpsmode",0);
    setDisplay("trwpspin",0);
}

function displayWpsConfig()
{
    if (IsWpsConfigDisplay() == false)
    {
        HideWpsConfig();
        return;
    }
   
    setRadio("wpsEnable", ("1" == wpsPinNum[0].Enable) ? "wpsON" : "wpsOFF");
    if (wpsPinNum[0].X_HW_ConfigMethod == 'Lable')
    {
        setRadio("wpsMode", "wpsPIN");
        setText("wpspinnum", changeToPinNumber(wpsPinNum[0].DevicePassword,8));
    }
    else
    {
        setRadio("wpsMode", "wpsButton");
    }
    setDisplay("tbWPS", 1);
    onClickWpsEnable();
}

function initAuthMode()
{
    $("#wlAuthMode").empty();
    var i = 0;
    
    if ((1 == capWPAWPA2PSK) && (Wlan.mode!="11n"))
    {        
        document.forms[0].wlAuthMode[i] = new Option(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_auth_wpawpa2psk'], "WPAand11i");
        i++;
    }
    document.forms[0].wlAuthMode[i] = new Option(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_auth_wpa2psk'], "11i");
    i++;
    if ((1 == capWPAPSK) && ('1' == WPAPSKFlag))
    {
        document.forms[0].wlAuthMode[i] = new Option(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_auth_wpapsk'], "WPA");
        i++;
    }
    if(Wlan.mode!="11n" && Wlan.mode!="11ac" && wepCap)
    {
        document.forms[0].wlAuthMode[i] = new Option(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_auth_shared'], "Shared");
        i++;
    }
    document.forms[0].wlAuthMode[i] = new Option(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_auth_open'], "Basic");
    i++;
    setSelect("wlAuthMode", beaconType);
    
    authModeChange();

}

function setWiFiPwd(pwd, type)
{
    if(pwdType == type)
    {
        return;
    }

    setDisable("PSKssidPwdTxt", 0);
    
    if ("wep" == type)
    {
        setDisplay("PSKssidPwd", 0);
        setDisplay("PSKssidPwdTxt", 0);

        setText("WEPssidPwd", pwd);
        setText("WEPssidPwdTxt", pwd);
    }
    else if ("psk" == type)
    {
        setDisplay("WEPssidPwd", 0);
        setDisplay("WEPssidPwdTxt", 0);

        setText("PSKssidPwd", pwd);
        setText("PSKssidPwdTxt", pwd);		
    }
    else if ("" == type)
    {
        setDisable("PSKssidPwdTxt", 1);
        setText("PSKssidPwdTxt", "");
		
        setDisplay("PSKssidPwd", 0);
        setDisplay("PSKssidPwdTxt", 1);
        setDisplay("WEPssidPwd", 0);
        setDisplay("WEPssidPwdTxt", 0);
    }
    
    ssidPwdChkClick(type);
    pwdType = type;

}


function addBackSlash(str)
{
    var strNeedSlash = "\\'\".:,;";
    var strNew = "";
  
    for(var i=0; i<str.length; i++)
    {
        var c = str.charAt(i);
        for(var j=0; j<strNeedSlash.length; j++)
        {
            if(c == strNeedSlash.charAt(j))
            {
                strNew += "\\";
                break;
            }
        }
        strNew += c;
    }
    
    return strNew;
}

function LoadFrame()
{
    
    setText("ssidName", Wlan.ssid);
    
    initAuthMode();

    setRadio("ssidHide", ("1" == Wlan.wlShow) ? "ssidShow" : "ssidHide");

    setRadio("radioEnable", ("1" == (wlanpage == "2G" ? enbl2G : enbl5G)) ? "ssidON" : "ssidOFF");
    
    displayWpsConfig();
}

function checkWep(val)
{
    Form.addParameter('y.WEPEncryptionLevel', '104-bit');
    
    if ( val != '' && val != null)
    {
       if (isValidKey(val, 13) == false )
       {
           AlertEx(cfg_wlancfgdetail_language['amp_key_check1'] + val + cfg_wlancfgdetail_language['amp_key_invalid1']);
           return false;
       }
    }
    else
    {
       AlertEx(cfg_wlancfgdetail_language['amp_wifipwd_empty']);
       return false;
    }
    return true;
}

function checkSSIDForTDE(wlan)
{
	var ssid = wlan.ssid;
	
	if(checkSSIDExist(wlan, WlanInfo))
    {
    	return false;
    }

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

    if (true != checkSepcailStrValid(ssid))
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid']);
        return false;
    }
	
	if(getTDEStringActualLen(ssid) > 32)
	{
	    AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
        return false;
	}
    
    return true;
}

function checkAddPara()
{
    var ssid = getValue('ssidName');
    ssid = ltrim(ssid);
    Wlan.ssid = ssid;
    if(false == checkSSIDForTDE(Wlan))
    {
        return false;
    }
    Form.addParameter('y.SSID',ssid);

    var pwd = "";

    if(pwdType == "wep")
    {
        pwd = getValue("WEPssidPwd");
		if ((isFireFox4 == 1) && (pwd == ''))
		{
			pwd = getValue("WEPssidPwdTxt");
		}

        if(!checkWep(pwd))
            return false;
            
        var curAuthMode = getSelectVal("wlAuthMode");
        
        if( Wlan.WEPEncryptionLevel != '104-bit' )
        {
            for(var i = 1; i <= 4; i++)
            {
                var wepDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + wlanInst + ".WEPKey." + i;        
                Form.addParameter('w' + i + '.WEPKey', pwd);
                urlNode += "w" + i + "=" + wepDomain + "&";
            }
        }
        else
        {
            var wepDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."+wlanInst+".WEPKey." + Wlan.KeyIndex;        
            Form.addParameter('w.WEPKey', pwd);
            urlNode += "w=" + wepDomain + "&";
        }
    }
    else if(pwdType == "psk")
    {
    	pwd = getValue("PSKssidPwd");
		if ((isFireFox4 == 1) && (pwd == ''))
		{
			pwd = getValue("PSKssidPwdTxt");;
		}
		
        if(false == isValidWPAPskSepcialKey(pwd))
		{
		    return false;
		}
		
        var pskDomain = "InternetGatewayDevice.LANDevice.1.WLANConfiguration."+wlanInst+".PreSharedKey.1";

        Form.addParameter('p.PreSharedKey', pwd);
        Form.addParameter('p.KeyPassphrase', pwd);
        
        urlNode += "p="+pskDomain+"&";                
    }
    
    return true;
}

function isWifiCoverSsid()
{
    for (var j = 0; j < apExtendedWLC.length - 1; j++)
    {
        if (wlanInst == apExtendedWLC[j].SSIDIndex)
        {
            return true;            
        }
    }
    return false
}

function addCoverPara()
{
    if(!isWifiCoverSsid())
        return true;

    var paraChanged = false;

    var ssidCoverParaArr = [["SsidInst", "", wlanInst], ["SSID", "", Wlan.ssid], ["Standard", "", Wlan.mode], ["BeaconType", "", Wlan.BeaconType], 
		    ["BasicEncryptionModes", "", Wlan.BasicEncryptionModes], ["BasicAuthenticationMode", "", Wlan.BasicAuthenticationMode], 
		    ["WPAEncryptionModes", "", Wlan.WPAEncryptionModes], ["WPAAuthenticationMode", "", Wlan.WPAAuthenticationMode], 
		    ["IEEE11iEncryptionModes", "", Wlan.IEEE11iEncryptionModes], ["IEEE11iAuthenticationMode", "", Wlan.IEEE11iAuthenticationMode], 
		    ["X_HW_WPAand11iEncryptionModes", "MixEncryptionModes", Wlan.X_HW_WPAand11iEncryptionModes], 
		    ["X_HW_WPAand11iAuthenticationMode", "MixAuthenticationMode", Wlan.X_HW_WPAand11iAuthenticationMode], 
		    ["WEPKey", "Key", pwdWep], ["PreSharedKey", "Key", pwdPsk]];
    
    var postForm = $("form[method='POST']");
    
    if(0 == postForm.find("input").length)
    {
        return true;
    }
    
    $.each(ssidCoverParaArr, function(idx, ssidCoverPara){
    
        var key = (ssidCoverPara[1] == "") ? ssidCoverPara[0] : ssidCoverPara[1];
        var value = ssidCoverPara[2];

        var inputPara = postForm.find("input[name$='." + ssidCoverPara[0] + "']");
        if(inputPara.length > 0)
        {
            value = inputPara[0].value;
            paraChanged = true;
        }
        
        Form.addParameter('c.'+key, value);
    });
    
    if(paraChanged)
    {
        urlNode += "c=InternetGatewayDevice.X_HW_DEBUG.AMP.WifiCoverSetWlanBasic&";
        
        return ConfirmEx(cfg_wificover_basic_language['amp_wificover_ssid_change_notify']);
    }
    
    return true;
}

function addAuthPara()
{
    var curBeaconType = getSelectVal("wlAuthMode");
    var beaconEncryArr = 
               [["Basic", "BasicEncryptionModes", 'None', 'BasicAuthenticationMode', 'None'], 
                ["Shared", "BasicEncryptionModes", 'WEPEncryption', 'BasicAuthenticationMode', 'SharedAuthentication'], 
                ["WPA", "WPAEncryptionModes", 'TKIPEncryption', 'WPAAuthenticationMode', 'PSKAuthentication'], 
                ["11i", "IEEE11iEncryptionModes", 'AESEncryption', 'IEEE11iAuthenticationMode', 'PSKAuthentication'], 
                ["WPAand11i", "X_HW_WPAand11iEncryptionModes", 'TKIPandAESEncryption', 'X_HW_WPAand11iAuthenticationMode', 'PSKAuthentication']];

    Form.addParameter('y.BeaconType', curBeaconType);
    
    if (curBeaconType=="Basic")
    {
    }
    else if (curBeaconType=="Shared")
    {
        Form.addParameter('y.BeaconType', "Basic");
        pwdType = "wep";
    }
    else
    {
        pwdType = "psk";
    }
    
    for(var i=0; i < beaconEncryArr.length; i++)
    {
        if(curBeaconType == beaconEncryArr[i][0])
        {
            Form.addParameter('y.' + beaconEncryArr[i][1], beaconEncryArr[i][2]);
            Form.addParameter('y.' + beaconEncryArr[i][3], beaconEncryArr[i][4]);            
            break;
        }
    }
}

function ssidPwdChkClick(pwdType)
{
    if ("wep" == pwdType)
	{
        setDisplay("PSKssidPwd", 0);
        setDisplay("PSKssidPwdTxt", 0);
        if (1 == getCheckVal("ssidPwdChk"))
        {
            setDisplay("WEPssidPwd", 1);
            setDisplay("WEPssidPwdTxt", 0);
        }
        else
        {
            setDisplay("WEPssidPwd", 0);
            setDisplay("WEPssidPwdTxt", 1);
        }	
    }
    else if("psk" == pwdType)
    {
        setDisplay("WEPssidPwd", 0);
        setDisplay("WEPssidPwdTxt", 0);
        if (1 == getCheckVal("ssidPwdChk"))
        {
            setDisplay("PSKssidPwd", 1);
            setDisplay("PSKssidPwdTxt", 0);
        }
        else
        {
            setDisplay("PSKssidPwd", 0);
            setDisplay("PSKssidPwdTxt", 1);
        }
    }
}

function changeToInteger(number,length)
{
    var i;
    for (i = 0; i < number.length; i++)
    {
        if (number.charAt(i) != '0')
        {
            break;
        }
    }
    return number.substr(i,length-i);
}

function ValidateChecksum(PIN) 
{
    var accum = 0;
    var iRet;
    accum += 3 * (parseInt(PIN / 10000000) % 10); 
    accum += 1 * (parseInt(PIN / 1000000) % 10); 
    accum += 3 * (parseInt(PIN / 100000) % 10);
    accum += 1 * (parseInt(PIN / 10000) % 10);
    accum += 3 * (parseInt(PIN / 1000) % 10);
    accum += 1 * (parseInt(PIN / 100) % 10);
    accum += 3 * (parseInt(PIN / 10) % 10);
    accum += 1 * (parseInt(PIN / 1) % 10);
    if (0 == (accum % 10))
    {
        iRet = 0;                                 
    }
    else
    {
        iRet = 1;
    }
    return iRet;
} 

function addParaWps(Form)
{
    var wpsEnable = (getRadioVal("wpsEnable") == "wpsON") ? "1" : "0";
    Form.addParameter('z.Enable',wpsEnable);
    if (getRadioVal("wpsMode") == "wpsButton")
    {
        Form.addParameter('z.X_HW_ConfigMethod','PushButton');
    }
    else
    {
        var clientPinNum = getValue('wpspinnum');
        if (clientPinNum == '')
        {
            AlertEx(cfg_wlancfgother_language['amp_clientpin_empty']);
            return false;
        }
            
         if (isInteger(clientPinNum) == false)
         {
              AlertEx(cfg_wlancfgother_language['amp_clientpin_int']);
              return false;
          }

          if (clientPinNum.length != 8)
          {
              AlertEx(cfg_wlancfgother_language['amp_clientpin_8int']);
              return false;
           }

          if (clientPinNum == 0)
          {   
              AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
              return false;
          }
            
          var pinNum = parseInt(changeToInteger(clientPinNum,8));
          if (ValidateChecksum(parseInt(pinNum, 10)) != 0)
          {
              AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
              return false;
          }
          Form.addParameter('z.X_HW_ConfigMethod','Lable');
          Form.addParameter('z.X_HW_PinGenerator','STA');
          Form.addParameter('z.DevicePassword',parseInt(pinNum, 10));
    }
}

function ApplySubmit()
{    
    Form = new webSubmitForm();
    urlNode = "";
    
    var valid = true;
    var tmp = 0;

    var ssidShow = (getRadioVal("ssidHide") == "ssidHide") ? "0" : "1";
    if(Wlan.wlShow != ssidShow)
    {
        Form.addParameter('y.SSIDAdvertisementEnabled', ssidShow);
    }    
    addAuthPara();   
    
    if(!checkAddPara() || !addCoverPara())
    {
        return;
    }

    urlNode += 'y=' + Wlan.domain + "&";
    
    var radioEnable = (getRadioVal("radioEnable") == "ssidON") ? "1" : "0";
    if((wlanpage == "2G" ? enbl2G : enbl5G) != radioEnable)
    {
        urlNode += 'r=InternetGatewayDevice.LANDevice.1.WiFi.Radio.' + (wlanpage == "2G" ? 1 : 2) + '&';
        Form.addParameter('r.Enable', radioEnable);
    }
    
    if (IsWpsConfigDisplay() == true)
    {
        urlNode += 'z=' + Wlan.domain + '.WPS' + '&';
        if (addParaWps(Form) == false)
        {        
            return;
        }
    }
    Form.setAction("set.cgi?" + urlNode
                        + 'RequestFile=html/amp/wlanbasic/WlanBztlf.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    setDisable("apply", 1);
    setDisable("cancle", 1);
    setDisable("onAssociate", 1);

    Form.submit();
}

function addParameterPin(Form)
{
    var clientPinNum = getValue('wpspinnum');
    if (clientPinNum == '')
    {
        AlertEx(cfg_wlancfgother_language['amp_clientpin_empty']);
        return false;
    }
        
    if (isInteger(clientPinNum) == false)
    {
        AlertEx(cfg_wlancfgother_language['amp_clientpin_int']);
        return false;
    }

    if (clientPinNum.length != 4 && clientPinNum.length != 8)
    {
        AlertEx(cfg_wlancfgother_language['amp_clientpin_8int']);
        return false;
    }   

    if (clientPinNum == 0)
    {   
        AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
        return false;
    }
    var pinLen = clientPinNum.length;
    var pinNum = parseInt(changeToInteger(clientPinNum, pinLen));
    if (clientPinNum.length == 8)
    {  
        if (ValidateChecksum(parseInt(pinNum, 10)) != 0)
        {
          AlertEx(cfg_wlancfgother_language['amp_clientpin_invalid']);
          return false;
        }
    }
    Form.addParameter('z.X_HW_ConfigMethod','Lable');
    Form.addParameter('z.X_HW_PinGenerator','STA');
    Form.addParameter('z.DevicePassword',parseInt(pinNum, 10));
}

function onAssociate()
{
    var wpsEnable = (getRadioVal("wpsEnable") == "wpsON") ? "1" : "0";
    var wlandomain = Wlan.domain;
    var url_pin = 'set.cgi?z=' + wlandomain + '.WPS' + '&RequestFile=html/amp/wlanbasic/WlanBztlf.asp';
    var Form = new webSubmitForm();
    if (addParameterPin(Form) == false)
    {        
        return;
    }
    if (wpsEnable == 0)
    {
        AlertEx(cfg_wlancfgdetail_language['amp_wps_enable_note']);
        return;
    }

    if (ConfirmEx(cfg_wlancfgdetail_language['amp_wps_start'])) 
    {
        Form.setAction(url_pin);        
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        setDisable("apply", 1);
        setDisable("cancel", 1);
        setDisable("onAssociate", 1);
        Form.submit();
    }   
}

function CancelConfig()
{
    LoadFrame();
}

</script>

</head>
<body  class="iframebody" onLoad="LoadFrame();" style="text-align: left;">
<div class="title_spread"></div>

<form>
<div id="WiFiArea">

<table class="setupWifiTable">
<thead>
    <th colspan="2"><script>document.write(cfg_wlancfgbasic_tdevivo_language['amp_wifivivo_basicsettings']);</script></th>
</thead>

<tr>
    <td style="width:200px;" BindText="amp_wifivivo_wifistatus"></td>
    <td>
        <input type="radio" name="radioEnable" id="radioEnable" value="ssidON"/> </input><span BindText="amp_wifivivo_on"></span>&nbsp;&nbsp;
        <input type="radio" name="radioEnable" id="radioEnable" value="ssidOFF"/> </input><span BindText="amp_wifivivo_off"></span>
    </td>
</tr> 

<tr>
    <td BindText="amp_wifivivo_hidewifi"></td>
    <td>
        <input type="radio" name="ssidHide" id="ssidHide" value="ssidShow"/> </input><span BindText="amp_wifivivo_on"></span>&nbsp;&nbsp;
        <input type="radio" name="ssidHide" id="ssidHide" value="ssidHide"/> </input><span BindText="amp_wifivivo_off"></span>
    </td>
</tr>                        

<tr>
    <td BindText="amp_wifivivo_wifiname"></td>
    <td><input name="ssidName" type="text" class="input-text" id="ssidName"  maxlength="32"/></td>
</tr>

<tr>
    <td BindText="amp_wifivivo_wifipwd"></td>
    <td>
        <input name="PSKssidPwdTxt" type="text" class="input-text" id="PSKssidPwdTxt" style="display:none;" onkeyup="setText('PSKssidPwd', this.value);" maxlength="63" />
        <input name="PSKssidPwd" type="password" class="input-text" id="PSKssidPwd" onkeyup="setText('PSKssidPwdTxt', this.value);" maxlength="63" />
        
        <input id="WEPssidPwdTxt" type="text" class="input-text" style="display:none;" onkeyup="setText('WEPssidPwd', this.value);" maxlength="26"/>
        <input id="WEPssidPwd" type="password" class="input-text" onkeyup="setText('WEPssidPwdTxt', this.value);" maxlength="26"/>
        
        <input id="ssidPwdChk" type="checkbox" checked onclick="ssidPwdChkClick(pwdType);" /><span ><script>document.write(cfg_wlancfgdetail_language['amp_wlanpassword_hide']);</script></span>
    </td>
</tr>

<tr>
    <td BindText="amp_wifivivo_auth_type"></td>
    <td>
    <select id="wlAuthMode" name="wlAuthMode" onchange="authModeChange()">
    </select>
    </td>
</tr>


<tr id="tbWPS" style='display:none;'>
    <td BindText="amp_wifivivo_wps"></td>
    <td>
        <input type="radio" name="wpsEnable" id="wpsEnable" value="wpsON" onclick="onClickWpsEnable();"/> </input><span BindText="amp_wifivivo_on"></span> &nbsp;&nbsp; 
        <input type="radio" name="wpsEnable" id="wpsEnable" value="wpsOFF" onclick="onClickWpsEnable();"/> </input><span BindText="amp_wifivivo_off"></span> 
    </td>
</tr>
<tr id='trwpsmode'  style='display:none;'>
    <td BindText="amp_wifivivo_wpsmode"></td>
    <td>
        <input type="radio" name="wpsMode" id="wpsMode" value="wpsButton" onclick="onClickWpsMode();"/> </input><span BindText="amp_wifivivo_wpsbutton"></span>
        <input type="radio" name="wpsMode" id="wpsMode" value="wpsPIN" onclick="onClickWpsMode();"/> <span BindText="amp_wifivivo_wpspin"></span> 
    </td>
</tr>
<tr id="trwpspin"  style="display: none;">
    <td BindText="amp_wifivivo_wpspinmenu"></td>
    <td>
    <input name="input_wps_pin" type="text" class="input-text" id="wpspinnum" maxlength="8"/>
    <a href="#" id="onAssociate" class="btn-default-orange-small right" onClick="onAssociate();"><span BindText="amp_wifivivo_wpsasso"></span></a>
    </td>
</tr>

<tr>
    <td colspan="2" class="text-right">
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <a href="#" id="cancle" class="btn-default-orange-small right" onClick="CancelConfig();"><span BindText="amp_wifivivo_cancle"></span></a>
        <a href="#" id="apply" class="btn-default-orange-small right" onClick="ApplySubmit();"><span BindText="amp_wifivivo_apply"></span></a>
    </td>
</tr>

</table>


</div>


<script>
ParseBindTextByTagName(cfg_wlancfgbasic_tdevivo_language, "div",  1);
ParseBindTextByTagName(cfg_wlancfgbasic_tdevivo_language, "td",  1);
ParseBindTextByTagName(cfg_wlancfgbasic_tdevivo_language, "span",  1);
ParseBindTextByTagName(cfg_wlancfgbasic_tdevivo_language, "input", 2);
</script>

</form>

</body>

</html>

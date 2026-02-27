<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../../bbsp/wan/<%HW_WEB_CleanCache_Resource(wanlanguage.html);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="javascript" src="../common/vimsglobe.asp"></script>
<script language="JavaScript" type="text/javascript">

function isIpAddress(address)
{
    var i = 0;
    var addrParts = address.split('.');
    if (addrParts.length != 4) {
        return false;
    }
    for (i = 0; i < 4; i++) {
        if (isNaN(addrParts[i]) || addrParts[i] == "" || addrParts[i].charAt(0) == '+' ||
            addrParts[i].charAt(0) == '-') {
            return false;
        }
        if (!isInteger(addrParts[i]) || addrParts[i] < 0) {
            return false;
        }
    }
    return true;
}

function isvalidVoipIpAddress(address)
{
    var i;
    if (address == '255.255.255.255') {
        return false;
    }
    if (address == '0.0.0.0') {
        return true;
    }
    var addrParts = address.split('.');
    if (addrParts.length != 4) {
        return false;
    }
    for (i = 0; i < 4; i++) {
        if (isNaN(addrParts[i]) || addrParts[i] == "" || addrParts[i].charAt(0) == '+' || addrParts[i].charAt(0) == '-') {
            return false;
        }
        if (addrParts[i].length > 3 || addrParts[i].length < 1) {
            return false;
        }
        if (addrParts[i].length > 1 && addrParts[i].charAt(0) == '0') {
            return false;
        }
        if (!isInteger(addrParts[i]) || addrParts[i] < 0) {
            return false;
        }
        num = parseInt(addrParts[i]);
        if (num < 0 || num > 255) {
            return false;
        }
    }
    return true;
}

function isValidVoipPort(port)
{
    if (!isInteger(port) || port < 0 || port > 65535) {
        return false;
    }
    return true;
}

function vspaisValidCfgStr(cfgName, val, len)
{
    if (isValidAscii(val) != '') {
        AlertEx(cfgName + Languages['vspa_hasvalidch'] + isValidAscii(val) + Languages['vspa_end']);
        return false;
    }
    if (val.length > len) {
        AlertEx(cfgName + Languages['vspa_cantexceed'] + len + Languages['vspa_characters']);
        return false;
    }
}


function CheckConfigForm()
{
    if ( '' != removeSpaceTrim(getValue('SIPServer'))) {
        if ( true == isIpAddress(getValue('SIPServer')) ) {
            if (false == isvalidVoipIpAddress(getValue('SIPServer'))) {
                AlertEx(Languages['vspa_SIPaddvalid']);
                return false;
            }
        } else {
            if (false == vspaisValidCfgStr(Languages['vspa_SIP'], getValue('SIPServer'),256) ) {
                return false;
            }
        }
    } 
    if (getValue('SIPPort') == '') {
        AlertEx(Languages['vspa_siploporthint']);
        return false;
    } else {
        if (isValidVoipPort(getValue('SIPPort')) == false) {
            AlertEx(Languages['vspa_siploport'] + getValue('SIPPort') + Languages['vspa_isvalid']);
            return false;
        }
    }
    return true;
}

function stUserRepeatCheck(Domain, UserRepeatCheck)
{
    this.Domain = Domain;
    this.UserRepeatCheck = UserRepeatCheck;
}
var UserRepeatCheckFlag = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.X_HW_InnerParameters, UserRepeatCheck, stUserRepeatCheck); %>;

function isEmpty(obj)
{
    if (typeof obj == "undefined" || obj == null || obj == "") {
        return true;
    } else {
        return false;
    }
}

function CheckUserRepeat()
{
    var configTelNum;
    var configUserName;
    if (UserRepeatCheckFlag[0].UserRepeatCheck == 0) {
        return false;
    }
    if (!isEmpty(getValue('SIPTeleNum2'))) {
        if (getValue('SIPTeleNum1') == getValue('SIPTeleNum2')) {
            AlertEx("SIPTeleNum repeat!");
            return true;
        }
    }
    if (!isEmpty(getValue('SIPUsername2'))) {
        if (getValue('SIPUsername1') == getValue('SIPUsername2')) {
            AlertEx("SIPUsername repeat!");
            return true;
        }
    }
    for (var index = 0; (index < AllLine.length - 1) && (index < 2); index++) {
        configTelNum = getValue('SIPTeleNum' + (index + 1));
        configUserName = getValue('SIPUsername' + (index + 1));
        for (var existIndex = 0; (existIndex < AllLine.length - 1) && (existIndex < 2); existIndex++) {
            if (!isEmpty(configTelNum)) {
                if (configTelNum == AllLine[existIndex].DirectoryNumber && index != existIndex) {
                    AlertEx("configTelNum " + configTelNum + " exist telNum " + AllLine[existIndex].DirectoryNumber);
                    return true;
                }
            }
            if (!isEmpty(configUserName)) {
                if (configUserName == AllAuth[existIndex].AuthUserName && index != existIndex) {
                    AlertEx("configUserName " + configUserName + " exist UserName " + AllAuth[existIndex].AuthUserName);
                    return true;
                }
            }
        }
    }
    return false;
}

function isAllUserDisableAndHasNumber()
{
    for (var index = 0; (index < AllLine.length - 1) && (index < 2); index++) {
        if (AllLine[index].Enable == 1 || (isEmpty(AllLine[index].DirectoryNumber) && isEmpty(AllAuth[index].AuthUserName))) {
            return false;
        }
    }
    return true;
}

function stAuth(Domain, AuthUserName, AuthPassword)
{
    this.Domain = Domain;
    if (AuthUserName != null) {
        this.AuthUserName = AuthUserName.toString().replace(/&apos;/g, "\'");
    } else {
        this.AuthUserName = AuthUserName;
    }
    this.AuthPassword = AuthPassword;
}

function stLine(Domain, DirectoryNumber, Enable, Status)
{
    this.Domain = Domain;
    if (DirectoryNumber != null) {
        this.DirectoryNumber = DirectoryNumber.toString().replace(/&apos;/g, "\'");
    } else {
        this.DirectoryNumber = DirectoryNumber;
    }

    if (Enable.toLowerCase() == 'enabled') {
        this.Enable = 1;
    } else {
        this.Enable = 0;
    }
    if (Status.toLowerCase() == 'up') {
        this.Status = 1;
    } else {
        this.Status = 0;
    }
}
function BasicWanIPOE(domain, ConnectionStatus, X_HW_SERVICELIST, AddressingType)
{
    this.domain = domain;
    this.ConnectionStatus = ConnectionStatus;
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
    this.AddressingType = AddressingType;
}
function BasicWanPPP(domain, ConnectionStatus, X_HW_SERVICELIST, ConnectionType)
{
    this.domain = domain;
    this.ConnectionStatus = ConnectionStatus;
    this.X_HW_SERVICELIST = X_HW_SERVICELIST;
    this.ConnectionType = ConnectionType;
}

function PingResultClass(domain, FailureCount, SuccessCount)
{
    this.domain = domain;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
}

var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP, AuthUserName|AuthPassword, stAuth);%>;
var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}, DirectoryNumber|Enable|Status, stLine);%>;
var IPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}, ConnectionStatus|X_HW_SERVICELIST|AddressingType, BasicWanIPOE);%>;
var PPPWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}, ConnectionStatus|X_HW_SERVICELIST|ConnectionType, BasicWanPPP);%>;
var IPAddress = '<%HW_WEB_GetSPEC(SPEC_PING_DIAGNOSE_IPADDRESS.STRING);%>';
var AllSIPServer = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP, ProxyServer|ProxyServerPort|OutboundProxy|OutboundProxyPort|X_HW_SecondaryOutboundProxy|X_HW_SecondaryOutboundProxyPort|X_HW_SecondaryProxyServer|X_HW_SecondaryProxyServerPort|RegistrarServer|UserAgentPort, stSIPServer);%>;

var PingResult = new PingResultClass("InternetGatewayDevice.IPPingDiagnostics", "0", "0");

var StartPingFlag = 0;

var g_getpingtimer = 0;

function GetVOIPWan()
{
    if (IPWanList.length <= 1) {
        return -1;
    }
    for (var index = 0; index < IPWanList.length - 1; index++) {
        if ((IPWanList[index].X_HW_SERVICELIST.toString().toUpperCase().indexOf("VOIP") >= 0) &&
            (IPWanList[index].ConnectionStatus.toString().toUpperCase() == "CONNECTED") &&
            (IPWanList[index].AddressingType.toString().toUpperCase() == "STATIC")) {
            return index;
        }
    }
    return -1;
}

function GetTR069InternetPPPWan()
{
    if (PPPWanList.length <= 1) {
        return -1;
    }
    for (var index = 0; index < PPPWanList.length - 1; index++) {
        if ((PPPWanList[index].X_HW_SERVICELIST.toString().toUpperCase().indexOf("INTERNET") >= 0) &&
            (PPPWanList[index].ConnectionType.toString().toUpperCase().indexOf("ROUTED") >= 0) &&
            (PPPWanList[index].ConnectionStatus.toString().toUpperCase() == "CONNECTED")) {
            return index;
        }
    }
    return -1;
}

function SetDisplaySIPInfo()
{
    for (var index = 0; index < AllLine.length - 1; index++) {
        if (AllAuth[index].Domain.toString().indexOf(AllLine[index].Domain.toString()) >= 0) {
            setCheck('SIPUser' + (index + 1) + 'Enable', AllLine[index].Enable);
            setText('SIPTeleNum' + (index + 1), AllLine[index].DirectoryNumber);
            setSelect('VImsRegionOption', vimsOpt[0].vims);
            setText('SIPUsername' + (index + 1), AllAuth[index].AuthUserName);
            setText('SIPPassword' + (index + 1), AllAuth[index].AuthPassword);
        }
    }
    setText('SIPServer',AllSIPServer[0].RegistrarServer);
    setText('SIPPort', AllSIPServer[0].UserAgentPort);
    setText('OutboundProxy', AllSIPServer[0].OutboundProxy);
    setText('OutboundProxyPort', AllSIPServer[0].OutboundProxyPort);
    setText('SecondaryOutboundProxy', AllSIPServer[0].X_HW_SecondaryOutboundProxy);
    setText('SecondaryOutboundProxyPort', AllSIPServer[0].X_HW_SecondaryOutboundProxyPort);
    setText('ProxyServer', AllSIPServer[0].ProxyServer);
    setText('ProxyServerPort', AllSIPServer[0].ProxyServerPort);
    setText('SecondProxyServer', AllSIPServer[0].X_HW_SecondaryProxyServer);
    setText('SecondProxyServerPort', AllSIPServer[0].X_HW_SecondaryProxyServerPort);
    setText('HomeDomain', AllSIPServer[0].RegistrarServer);
    setText('UserAgentPort', AllSIPServer[0].UserAgentPort);
}

function OnApply()
{
    if (false == CheckConfigForm()) {
        return;
    }

    if (CheckForm1() != true) {
        return;
    }

    if (CheckUserRepeat()) {
        return;
    }

    var sndProServerPort;
    var ProServerPort;
    var sndOutboundServerPort;
    var OutboundServerPort;

    if (removeSpaceTrim(getValue('SecondProxyServerPort').toString()) == "") {
        sndProServerPort = 0;
    } else {
        sndProServerPort = parseInt(getValue('SecondProxyServerPort'), 10);
    }

    if (removeSpaceTrim(getValue('ProxyServerPort').toString()) == "") {
        ProServerPort = 0;
    } else {
        ProServerPort = parseInt(getValue('ProxyServerPort'), 10);
    }
    if (removeSpaceTrim(getValue('OutboundProxyPort').toString()) == "") {
        OutboundServerPort = 0;
    } else {
        OutboundServerPort = parseInt(getValue('OutboundProxyPort'), 10);
    }
    if (removeSpaceTrim(getValue('SecondaryOutboundProxyPort').toString()) == "") {
        sndOutboundServerPort = 0;
    } else {
        sndOutboundServerPort = parseInt(getValue('SecondaryOutboundProxyPort'), 10);
    }

    var Form = new webSubmitForm();
    var arr = new Array('x', 'y');
    var arr_sip = new Array('a', 'b');
    var ActionURL = '';
    for (var index = 0; (index < AllLine.length - 1) && (index < 2); index++) {
        if (GetLanguage("Apply") == getValue('ButtonApply')) {
            if (getCheckVal('SIPUser' + (index + 1) + 'Enable') == 1) {
                Form.addParameter(arr[index] + '.Enable', 'Enabled');
            } else {
                Form.addParameter(arr[index] + '.Enable', 'Disabled');
            }
        } else {
            Form.addParameter(arr[index] + '.Enable', 'Disabled');
        }
        Form.addParameter(arr[index] + '.DirectoryNumber', getValue('SIPTeleNum' + (index + 1)));
        Form.addParameter(arr_sip[index] + '.AuthUserName', getValue('SIPUsername' + (index + 1)));
        if (getValue('SIPPassword' + (index + 1)) != '****************************************************************') {
            Form.addParameter(arr_sip[index] + '.AuthPassword', getValue('SIPPassword' + (index + 1)));
        }
        ActionURL += arr[index] + "=" + AllLine[index].Domain + '&' + arr_sip[index] + '=' + AllLine[index].Domain + '.SIP&';
    }
    var addOutbound = getValue('OutboundProxy');
    var addSecondOutbound = getValue('SecondaryOutboundProxy');
    if (addOutbound != AllSIPServer[0].OutboundProxy) {
        Form.addParameter('z.OutboundProxy', getValue('OutboundProxy'));
    }
    Form.addParameter('z.OutboundProxyPort', parseInt(OutboundServerPort));
    if (addSecondOutbound != AllSIPServer[0].X_HW_SecondaryOutboundProxy) {
        Form.addParameter('z.X_HW_SecondaryOutboundProxy', getValue('SecondaryOutboundProxy'));
    }

    var curCfgServer = new stSIPServer("", "", "", "", "", "", "", "", "", "", "");
    GetImsSubmit(curCfgServer);
    imsSelectInit(curCfgServer);

    Form.addParameter('f.VImsRegionOption', vimsOpt[0].vims);
    Form.addParameter('z.X_HW_SecondaryOutboundProxyPort', parseInt(sndOutboundServerPort));
    Form.addParameter('z.ProxyServer', getValue('ProxyServer'));
    Form.addParameter('z.ProxyServerPort', parseInt(ProServerPort));
    Form.addParameter('z.X_HW_SecondaryProxyServerPort', parseInt(sndProServerPort));
    Form.addParameter('z.UserAgentPort', parseInt(getValue('UserAgentPort'), 10));
    Form.addParameter('z.X_HW_SecondaryProxyServer', getValue('SecondProxyServer'));
    Form.addParameter('z.RegistrarServer', getValue('HomeDomain'));
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    ActionURL = 'set.cgi?' + ActionURL + 'z=' + AllSIPServer[0].Domain + '&f=' + AllSIPServer[0].Domain +
                '.X_HW_SIPExtend' + '&RequestFile=html/voip/globevoipwan/voipwanGlobe.asp';
    Form.setAction(ActionURL);
    Form.submit();
    setDisable('ButtonApply' ,0);
}

function DisableOrEnableSetConnect(index, ctrFlag)
{
    setDisable('SIPUsername' + index, ctrFlag);
    setDisable('SIPPassword' + index, ctrFlag);
    setDisable('SIPTeleNum' + index, ctrFlag);
}

function OnChangewWanServiceUI(Obj)
{
    var ConnectionObj = document.getElementById("SIPUser1Enable");
    if (Obj == ConnectionObj) {
        if (Obj.checked) {
            setDisable('SIPUsername1', 0);
            setDisable('SIPPassword1', 0);
            setDisable('SIPTeleNum1', 0);
        } else {
            setDisable('SIPUsername1', 1);
            setDisable('SIPPassword1', 1);
            setDisable('SIPTeleNum1', 1);
        }
    } else {
        if (Obj.checked) {
            setDisable('SIPUsername2', 0);
            setDisable('SIPPassword2', 0);
            setDisable('SIPTeleNum2', 0);
        } else {
            setDisable('SIPUsername2', 1);
            setDisable('SIPPassword2', 1);
            setDisable('SIPTeleNum2', 1);
        }
    }
}

function SetDisableTelephone()
{
    setDisable('SIPPort', 1);
    setDisable('SIPUser1Enable', 1);
    setDisable('SIPUser2Enable', 1);
    DisableOrEnableSetConnect(1, 1);
    DisableOrEnableSetConnect(2, 1);
}

function StartPingDiagnose()
{
    var PPPWanIdex = GetTR069InternetPPPWan();
    PPPWanIdex = 0;
    if (PPPWanIdex == -1) {
        return;
    }
    var DSCP = 0;
    var PingData;
    StartPingFlag = 1;
    PingResult.SuccessCount = 0;
    PingResult.FailureCount = 0;
    PingData = "x.Host=" + IPAddress + "&x.DiagnosticsState=Requested" + "&x.NumberOfRepetitions=3" + "&x.DSCP=" + DSCP;
    if (PPPWanList[PPPWanIdex].domain != "") {
        PingData += "&x.Interface=" + PPPWanList[PPPWanIdex].domain;
    }
    $.ajax({
        type : "POST",
        async : true,
        cache : false,
        data : PingData,
        url : "ping.cgi?x=InternetGatewayDevice.IPPingDiagnostics",
        success : function(data) {
            ;
        }
    });
}

function GetPingInternetStatus()
{
    if (StartPingFlag > 0) {
        $.ajax({
            type : "POST",
            async : true,
            cache : false,
            timeout : 4000,
            url : "../../bbsp/common/GetRegPingResult.asp",
            success : function(data) {
                PingResult = eval(data);
                StartPingFlag ++
            }
        });
        if (PingResult.SuccessCount != 0 || PingResult.FailureCount != 0) {
            StartPingFlag = 0;
            clearInterval(g_getpingtimer);
            pause();
        }
    }
}

function IsTelephoneUP()
{
    for (var index = 0; index < AllLine.length - 1; index++) {
        if (AllLine[index].Status.toString().toUpperCase() == 1) {
            return true;
        }
    }
    return false;
}

function SetEnableSIP()
{
    setDisable('SIPUser1Enable', 0);
    setDisable('SIPUser2Enable', 0);
    setDisable('ButtonApply', 0);
    setDisable('SIPPort', 0);
}

function pause()
{
    setDisplay("TableConfigForm", 1);
    setDisplay("voipbasic", 1);
    setDisplay("ConfigForm1", 1);
    if (AllLine.length > 2) {
        setDisplay("ConfigForm2", 1);
    }
    setDisplay("ConfigPanelButtons", 1);
    SetDisplaySIPInfo();
    SetDisableTelephone();
    /* *Item 4 */
    if (true == IsTelephoneUP()) {
        setDisable('ButtonApply', 0);
        setText("ButtonApply", GetLanguage("Cancel"));
        return;
    }
    if (parseInt(PingResult.SuccessCount) == 0) {
        return;
    }

    PingResult.SuccessCount = 0;
    PingResult.FailureCount = 0;
    if (isAllUserDisableAndHasNumber()) {
        setDisable('ButtonApply', 0);
        document.getElementById("SIPUser1Enable").checked = true;
        document.getElementById("SIPUser2Enable").checked = true;
        return;
    }

    SetEnableSIP();
    if (document.getElementById("SIPUser1Enable").checked) {
        DisableOrEnableSetConnect(1, 0);
    } else {
        DisableOrEnableSetConnect(1, 1);
    }

    if (document.getElementById("SIPUser2Enable").checked) {
        DisableOrEnableSetConnect(2, 0);
    } else {
        DisableOrEnableSetConnect(2, 1);
    }
}

function SetConnect()
{
    var IPWanIndex = GetVOIPWan();
    var PPPWanIndex = GetTR069InternetPPPWan();
    if (IPWanIndex == -1 || PPPWanIndex == -1) {
        setDisplay("TableConfigForm", 1);
        setDisplay("SIPServerRow", 0);
        setDisplay("voipbasic", 1);
        setDisplay("ConfigForm1", 1);
        if (AllLine.length > 2) {
            setDisplay("ConfigForm2", 1);
        }
        setDisplay("ConfigPanelButtons", 1);
        setDisplay("ButtonApply", 1);
        SetDisplaySIPInfo();
        SetDisableTelephone();
        return;
    }
    StartPingDiagnose();
    g_getpingtimer = setInterval('GetPingInternetStatus()', 500);
}

function LoadFrame()
{
    setDisplay("TableConfigForm", 0);
    setDisplay("ConfigForm1", 0);
    setDisplay("ConfigForm2", 0);
    setDisplay("ConfigPanelButtons", 0);
    setDisplay("ButtonApply", 0);
    imsSelectInit(AllSIPServer[0]);
    SetConnect();
    initvIms();
}
</script>
<body  id="wanbody" onLoad="LoadFrame();" class = "mainbody" >
<form id="ConfigForm" >
<div class ="PageTitle_title" id = "SIPBasicInfoBar"><script>document.write(globevimsinterface['SIPBasicInfoBar']);</script></div>
<div class="PageTitle_content"><script>document.write(globevimsinterface['SIPBasicInfo']);</script></div>
<table id = "ConfigPanel"  width = "100%" cellspacing = "1" cellpadding = "0">
<li   id="SIPServer"                 RealType="TextBox"            DescRef="SIPAddreess"                    RemarkRef="Empty"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.domain"             InitValue="Empty"/>
<li id="VImsRegionOption" RealType="DropDownList" DescRef="vspa_IMSRegion" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="VImsRegionOption" InitValue="[{TextRef:'vspa_GMA',Value:'0'},{TextRef:'vspa_Luzon',Value:'1'},{TextRef:'vspa_Visayas',Value:'2'},{TextRef:'vspa_Mindanao',Value:'3'},{TextRef:'vspa_Others',Value:'4'}]" ClickFuncApp="onchange=vIMSChange">
<li id="SIPPort" RealType="TextBox" DescRef="SIPLocalPort" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="d.PingIPAddress" InitValue="Empty" MaxLength="63"/>
</table>
<script>
var WanConfigFormList = [];
var dir_style = "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm", "");
HWParsePageControlByID("ConfigForm", TableClass, globevimsinterface, "");
</script>
</form>

<form id="voipbasic">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title">
  <tr>
    <td BindText='vspa_basic'></td>
  </tr>
</table>
<table width = "100%" border = "0" cellpadding = "0" cellspacing = "1" class = "tabal_noborder_bg">
<li id="OutboundProxy" RealType="TextBox" DescRef="vspa_outbanproxy" RemarkRef="vspa_outbandproxyhint" ErrorMsgRef="Empty" Require="FALSE" BindField="OutboundProxy" InitValue="Empty" MaxLength="256"/>
<li id="OutboundProxyPort" RealType="TextBox" DescRef="vspa_outbandport" RemarkRef="vspa_outbandporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="OutboundProxyPort" InitValue="Empty" MaxLength="256"/>
<li id="SecondaryOutboundProxy" RealType="TextBox" DescRef="vspa_stoutproxy" RemarkRef="vspa_outbandproxyhint" ErrorMsgRef="Empty" Require="FALSE" BindField="SecondaryOutboundProxy" InitValue="Empty" MaxLength="256"/>
<li id="SecondaryOutboundProxyPort" RealType="TextBox" DescRef="vspa_stoutport" RemarkRef="vspa_outbandporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="SecondaryOutboundProxyPort" InitValue="Empty" MaxLength="256"/>
<li id="ProxyServer" RealType="TextBox" DescRef="vspa_proxy" RemarkRef="vspa_outbandproxyhint" ErrorMsgRef="Empty" Require="FALSE" BindField="ProxyServer" InitValue="Empty" MaxLength="256"/>
<li id="ProxyServerPort" RealType="TextBox" DescRef="vspa_proxyport" RemarkRef="vspa_outbandporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="ProxyServerPort" InitValue="Empty" MaxLength="11"/>
<li id="SecondProxyServer" RealType="TextBox" DescRef="vspa_stproxy" RemarkRef="vspa_outbandproxyhint" ErrorMsgRef="Empty" Require="FALSE" BindField="SecondProxyServer" InitValue="Empty" MaxLength="256"/>
<li id="SecondProxyServerPort" RealType="TextBox" DescRef="vspa_stport" RemarkRef="vspa_outbandporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="SecondProxyServerPort" InitValue="Empty" MaxLength="11"/>
<script language="JavaScript" type="text/javascript">
document.write("\<li id=\"HomeDomain\" RealType=\"TextBox\" DescRef=\"vspa_homedomain\" RemarkRef=\"vspa_outbandproxyhint\" ErrorMsgRef=\"Empty\" Require=\"FALSE\" BindField=\"HomeDomain\" InitValue=\"Empty\" MaxLength=\"256\"\/\> ");
</script>
<li id="UserAgentPort" RealType="TextBox" DescRef="vspa_loport" RemarkRef="vspa_outbandporthint" ErrorMsgRef="Empty" Require="TRUE" BindField="UserAgentPort" InitValue="Empty" MaxLength="11"/>
<script>
var VoipConfigFormList1 = HWGetLiIdListByForm("voipbasic", null);
HWParsePageControlByID("voipbasic", TableClass, sipinterface, null);
var VoipBasicParaSetArray = new Array();
HWSetTableByLiIdList(VoipConfigFormList1, VoipBasicParaSetArray, null);
</script>
</table>
</form>

<form id="ConfigForm1" >
<div class ="PageTitle_title" id = "SIPFirstUSerInfo"><script>document.write(Languages['SIPFirstUSerInfo']);</script></div>
<table id="ConfigPanel1"  width="100%" cellspacing="1" cellpadding="0">
<li id="SIPUser1Enable" RealType="CheckBox" DescRef="EnableUser" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField=""   InitValue="Empty"  ClickFuncApp="onclick=OnChangewWanServiceUI"/>
<li id="SIPTeleNum1" RealType="TextBox" DescRef="SIPTeleNum" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="t.APN" InitValue="Empty"   MaxLength="31"/>
<li id="SIPPassword1" RealType="TextBox" DescRef="SIPPassword" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="" InitValue="Empty"   MaxLength="31"/>
<li id="SIPUsername1" RealType="TextBox"  DescRef="SIPUserName" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="" InitValue="Empty"   MaxLength="31"/>
</table>
<script>
var WanConfigFormList = [];
var dir_style = "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm1", "");
HWParsePageControlByID("ConfigForm1", TableClass, Languages, "");
</script>
</form>

<form id="ConfigForm2" >
<div class ="PageTitle_title" id = "SIPSecondUSerInfo"><script>document.write(Languages['SIPSecondUSerInfo']);</script></div>
<table id="ConfigPanel2"  width="100%" cellspacing="1" cellpadding="0">
<li id="SIPUser2Enable" RealType="CheckBox" DescRef="EnableUser"  RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField=""  InitValue="Empty" ClickFuncApp="onclick=OnChangewWanServiceUI"/>
<li id="SIPTeleNum2"  RealType="TextBox"  DescRef="SIPTeleNum"  RemarkRef=""  ErrorMsgRef="Empty" Require="FALSE" BindField="" Elementclass="TextBoxLtr"   InitValue="Empty"/>
<li id="SIPPassword2" RealType="TextBox" DescRef="SIPPassword" RemarkRef="" ErrorMsgRef="Empty" Require="FALSE" BindField="" Elementclass="TextBoxLtr"   InitValue=""TitleRef="AddressStuffTitle"/>
<li id="SIPUsername2" RealType="TextBox" DescRef="SIPUserName" RemarkRef="" ErrorMsgRef="Empty" Require="FALSE" BindField=""  Elementclass="TextBoxLtr"   InitValue="Empty"/>
</table>
<script>
var WanConfigFormList = [];
var dir_style = "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm2", "");
HWParsePageControlByID("ConfigForm2", TableClass, Languages, "");

</script>
</form>

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
<script>
    setText("ButtonApply", GetLanguage("Apply"));
</script>
</body>
</html>

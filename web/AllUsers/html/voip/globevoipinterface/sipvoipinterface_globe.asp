<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta name="format-detection" content="telephone=no"/>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(voicedes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>VOIP Interface</title>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/wandns.asp"></script>
<script language="javascript" src="../common/voip_disableallelement.asp"></script>
<script language="javascript" src="../common/vimsglobe.asp"></script>
<style>
.interfacetextclass{
    width:300px;
    height:50px;
    color:black;
}

.TextBox
{
    width:155px;
}

.lineclass
{
    width:200px;
}

.lineclass2
{
    width:180px;
}

.wordclass
{
    word-wrap:break-all;
    word-break: break-all;
}


</style>

<script language = "JavaScript" type = "text/javascript">
var PortNum = '<%HW_WEB_GetPortNum();%>';

var selctIndex = -1;

var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';

var vagIndex = 0;

var vagLastInst = '<%HW_WEB_GetVoiceVagIndex();%>';

var TableClass = new stTableClass("width_per30", "width_per70", "ltr");

function isValidVoipPort(port)
{
    if (!isInteger(port) || port < 0 || port > 65535) {
        return false;
    }
    return true;
}

function GetVagIndexByInst(vagInst)
{
    for (var i = 0; i < AllProfile.length - 1; i++) {
        if (AllProfile[i].profileid == vagInst) {
            return i;
        }
    }
    return 0;
}

function stMediaPortName(Domain, X_HW_PortName_RTP)
{
    this.Domain = Domain;
    this.X_HW_PortName_RTP = X_HW_PortName_RTP;
}
var MediaPortName = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.RTP, X_HW_PortName, stMediaPortName);%>;

function stProfile(Domain, Region, X_HW_DigitMapMatchMode, X_HW_PortName, DigitMap)
{
    this.Domain = Domain;
    this.Region = Region;
    this.X_HW_DigitMapMatchMode = X_HW_DigitMapMatchMode;
    this.X_HW_PortName = X_HW_PortName;
    var temp = Domain.split('.');
    this.key = '.' + temp[5] + '.';
    this.profileid = temp[5];
    this.Relating = new stSIPServer("", "", "5060", "", "5060", "", "5060");
    this.DigitMap = DigitMap;
}

function stDigitMap(Domain, DigitMap)
{
    this.Domain = Domain;
    this.DigitMap = DigitMap;
}
var SipDigitMap = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP.X_HW_SIPDigitmap.1, DigitMap, stDigitMap);%>;

var AllProfile = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}, Region|X_HW_DigitMapMatchMode|X_HW_PortName, stProfile);%>;
vagIndex = GetVagIndexByInst(vagLastInst);

var vimsOpt = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP.X_HW_SIPExtend, VImsRegionOption, stVims);%>;
function stVims(Domain, vims)
{
    this.Domain = Domain;
    this.vims = vims;
}

var maxvagnum = AllProfile.length - 1;

for (var i = 0; i < AllProfile.length - 1; i++)
{
    AllProfile[i].DigitMap = SipDigitMap[i].DigitMap;
}

function stSIPServer(Domain, ProxyServer, ProxyServerPort, OutboundProxy, OutboundProxyPort, X_HW_SecondaryOutboundProxy, X_HW_SecondaryOutboundProxyPort, X_HW_SecondaryProxyServer, X_HW_SecondaryProxyServerPort, RegistrarServer, UserAgentPort, RegistrationPeriod)
{
    this.Domain = Domain;
    this.OutboundProxy = OutboundProxy;
    this.OutboundProxyPort = OutboundProxyPort;
    this.X_HW_SecondaryOutboundProxy = X_HW_SecondaryOutboundProxy;
    this.X_HW_SecondaryOutboundProxyPort = X_HW_SecondaryOutboundProxyPort;

    this.ProxyServer = ProxyServer;
    this.ProxyServerPort = ProxyServerPort;
    this.RegistrationPeriod = RegistrationPeriod;
    this.X_HW_SecondaryProxyServer = X_HW_SecondaryProxyServer;
    this.UserAgentPort = UserAgentPort;
    this.RegistrarServer = RegistrarServer;
    this.X_HW_SecondaryProxyServerPort = X_HW_SecondaryProxyServerPort;
    var temp = Domain.split('.');
    this.key = '.' + temp[5] + '.';
}
var ProductType = '<%HW_WEB_GetProductType();%>';
var AllSIPServer = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP, ProxyServer|ProxyServerPort|OutboundProxy|OutboundProxyPort|X_HW_SecondaryOutboundProxy|X_HW_SecondaryOutboundProxyPort|X_HW_SecondaryProxyServer|X_HW_SecondaryProxyServerPort|RegistrarServer|UserAgentPort|RegistrationPeriod, stSIPServer);%>;
AssociateParam('AllProfile','AllSIPServer','ProxyServer|ProxyServerPort|OutboundProxy|OutboundProxyPort|X_HW_SecondaryOutboundProxy|X_HW_SecondaryOutboundProxyPort|X_HW_SecondaryProxyServer|X_HW_SecondaryProxyServerPort|RegistrarServer|UserAgentPort|RegistrationPeriod');

function ValidVoipWan(wan)
{
    return ((wan.Enable == true) && (wan.ServiceList.toUpperCase().indexOf("VOIP") >= 0));
}

var WanInfo = GetWanListByFilter(ValidVoipWan);

function MakeVoipWanName(wan)
{
    DomainElement = wan.domain.split(".");
    var wanInst = DomainElement[4];
    var wanServiceList  = wan.ServiceList;
    var currentWanName = "wan" + wanInst;
    return currentWanName;
}

var dmm = sipinterface['vspa_dmmhint'];

function ShowTab(index, URI, TelNo, AuthUserName, Password, PhyReferenceList)
{
    this.index = index;
    this.URI = URI;
    this.TelNo = TelNo;
    this.AuthUserName = AuthUserName;
    this.Password = Password;
    this.PhyReferenceList = PhyReferenceList;
}

function init()
{
    var objTR = getElementByName('vag_tr');
    if (objTR != null) {
        for (var i = 0; i < objTR.length; i++) {
            objTR[i].value = sipinterface['vspa_profile'] + AllProfile[i].profileid;
            if (i == vagIndex) {
                objTR[i].style.background = '#B4B4B4';
                objTR[i].style.color = '#990000';
                objTR[i].style.fontWeight = 'bold';
            } else {
                objTR[i].style.background = '#C3C3C3';
                objTR[i].style.color = '#505050';
                objTR[i].style.fontWeight = 'normal';
            }
        }
    }
    document.getElementById('DigitMap').title = dmm;

    initCtlValue();

    imsSelectInit(AllProfile[vagIndex].Relating);
    if (AllProfile[0] == null) {
        return;
    }

    if (AllProfile[vagIndex].Relating.X_HW_SecondaryProxyServer == "255.255.255.255") {
        AllProfile[vagIndex].Relating.X_HW_SecondaryProxyServer = "";
    }

    if (AllProfile[vagIndex].Relating.ProxyServer == "255.255.255.255") {
        AllProfile[vagIndex].Relating.ProxyServer = "";
    }
    setText('OutboundProxy', AllProfile[vagIndex].Relating.OutboundProxy);
    setText('OutboundProxyPort', AllProfile[vagIndex].Relating.OutboundProxyPort);
    setText('SecondaryOutboundProxy', AllProfile[vagIndex].Relating.X_HW_SecondaryOutboundProxy);
    setText('SecondaryOutboundProxyPort', AllProfile[vagIndex].Relating.X_HW_SecondaryOutboundProxyPort);
    setText('ProxyServer', AllProfile[vagIndex].Relating.ProxyServer);
    setText('ProxyServerPort', AllProfile[vagIndex].Relating.ProxyServerPort);
    setText('SecondProxyServer', AllProfile[vagIndex].Relating.X_HW_SecondaryProxyServer);
    setText('SecondProxyServerPort', AllProfile[vagIndex].Relating.X_HW_SecondaryProxyServerPort);
    setText('HomeDomain', AllProfile[vagIndex].Relating.RegistrarServer);
    setText('UserAgentPort', AllProfile[vagIndex].Relating.UserAgentPort);
    setText('DigitMap', AllProfile[vagIndex].DigitMap);
    setSelect('Region', AllProfile[vagIndex].Region);
    setSelect('X_HW_DigitMapMatchMode', AllProfile[vagIndex].X_HW_DigitMapMatchMode);
    setSelect('VImsRegionOption', vimsOpt[vagIndex].vims);

    var wanSigValue;
    for (k = 0; k < WanInfo.length; k++) {
        if (MakeVoipWanName(WanInfo[k]) ==  AllProfile[vagIndex].X_HW_PortName) {
            wanSigValue = domainTowanname(WanInfo[k].domain);
            break;
        }
    }
    if (k == WanInfo.length) {
        wanSigValue = AllProfile[vagIndex].X_HW_PortName;
    }
    setSelect('X_HW_PortName', wanSigValue);

    setText('RegistrationPeriod', AllProfile[vagIndex].Relating.RegistrationPeriod);

    var wanRtpValue;
    for (k = 0; k < WanInfo.length; k++) {
        if (MakeVoipWanName(WanInfo[k]) == MediaPortName[vagIndex].X_HW_PortName_RTP) {
            wanRtpValue = domainTowanname(WanInfo[k].domain);
            break;
        }
    }
    if (k == WanInfo.length) {
        wanRtpValue = MediaPortName[vagIndex].X_HW_PortName_RTP;
    }
    setSelect('X_HW_PortName_RTP', wanRtpValue);
}

function ChangeVAGTable(allvagnum, vagIndex)
{
    for (index = 0; index < allvagnum; index++) {
        var optid = 'linelist' + index + '_tbl';

        if (vagIndex == index) {
            setDisplay(optid, 1);
        } else {
            setDisplay(optid, 0);
        }
    }
}

function LoadFrame()
{
    init();
    var j = 0;

    ChangeVAGTable(maxvagnum, vagIndex);

    if (LineList[vagIndex].length > 0) {
        selectLine('record_0');

        for (j = 0; j < maxvagnum; j++) {
            if (vagIndex == j) {
                var oid = 'linelist' + j + '_record_0';
                selectLine(oid);
            }
        }

        setDisplay('ConfigForm1', 1);
    } else {
        selectLine('record_no');

        for (j = 0; j < maxvagnum; j++) {
            if (vagIndex == j) {
                var oid = 'linelist' + j + '_record_no';
                selectLine(oid);
            }
        }

        setDisplay('ConfigForm1', 0);
    }
    setDisplay('ConfigForm2', 1);

    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length; i++) {
        var b = all[i];
        if (b.getAttribute("BindText") == null) {
            continue;
        }
        b.innerHTML = sipinterface[b.getAttribute("BindText")];
    }
}

function NumberChange()
{
    var obj = document.getElementById("DirectoryNumber");
    var auth = document.getElementById("AuthUserName");
    if (removeSpaceTrim(obj.value) != "") {
        auth.value = "+63" + obj.value + "@vims.globe.com.ph";
    } else {
        auth.value = obj.value;
    }
}

var g_Index = -1;

function isIpAddress(address)
{
    var addrParts = address.split('.');
    if (addrParts.length != 4) {
        return false;
    }
    for (var i = 0; i < 4; i++) {
        if (isNaN(addrParts[i]) || addrParts[i] == "" || addrParts[i].charAt(0) == '+' || addrParts[i].charAt(0) == '-') {
            return false;
        }
        if (!isInteger(addrParts[i]) || addrParts[i] < 0) {
            return false;
        }
    }
    return true;
}

function getIpAddress(address)
{
    var i = 0;
    var addrParts = address.split('.');
    var IpAddress = parseInt(addrParts[0], 10) + '.' + parseInt(addrParts[1], 10) + '.' + parseInt(addrParts[2], 10) + '.' + parseInt(addrParts[3], 10);
    return IpAddress
}

function isvalidVoipIpAddress(address)
{
    var i = 0;
    if (address == '255.255.255.255') {
        return false;
    }

    if (address == '0.0.0.0') {
        return true;
    }
    var addrParts = address.split('.');
    if (addrParts.length != 4) return false;
    for (i = 0; i < 4; i++) {
        if (isNaN(addrParts[i]) || addrParts[i] == "" || addrParts[i].charAt(0) == '+' || addrParts[i].charAt(0) == '-')
            return false;
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
        if (num < 0 || num > 255)
            return false;
    }
    return true;
}


function vspaisValidCfgStr(cfgName, val, len)
{
    if (isValidAscii(val) != '') {
        AlertEx(cfgName + sipinterface['vspa_hasvalidch'] + isValidAscii(val) + sipinterface['vspa_end']);
        return false;
    }
    if (val.length > len) {
        AlertEx(cfgName + sipinterface['vspa_cantexceed']  + len  + sipinterface['vspa_characters']);
        return false;
    }
}

function stPhyInterface(Domain, InterfaceID)
{
    this.Domain = Domain;
}

var AllPhyInterface = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.PhyInterface.{i}, InterfaceID, stPhyInterface);%>;
function stLine(Domain, DirectoryNumber, Enable, PhyReferenceList)
{
    this.Domain = Domain;
    if (DirectoryNumber != "") {
        var viewNumber = DirectoryNumber.toString().replace(/&apos; /g, "\'");
        var prefix = "+63";
        if (viewNumber.indexOf(prefix) >= 0) {
            if (viewNumber.substring(0, prefix.length) == prefix) {
                this.DirectoryNumber = viewNumber.substring(prefix.length, viewNumber.length);
            }
        } else {
            this.DirectoryNumber = viewNumber;
        }
    } else {
        this.DirectoryNumber = '';
    }
    this.PhyReferenceList = PhyReferenceList;

    if (Enable.toLowerCase() == 'enabled') {
        this.Enable = 1;
    } else {
        this.Enable = 0;
    }
    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}

var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}, DirectoryNumber|Enable|PhyReferenceList, stLine);%>;
var LineList = new Array(new Array(), new Array(), new Array(), new Array());
var AllLineInsNumArray = new Array(new Array(), new Array(), new Array(), new Array());
for (var j = 0; j < 4; j++) {
    for (var i = 0; i < 68; i++) {
        AllLineInsNumArray[j][i]=256;
    }
}

for (var i = 0; i < AllLine.length - 1; i++)
{
    var temp = AllLine[i].Domain.split('.');
    var Vagindex = GetVagIndexByInst(temp[5]);
    LineList[Vagindex].push(AllLine[i]);
    index = temp[7];
    AllLineInsNumArray[Vagindex][index - 1] = index;
}

function FindFreeLineInst(Vagindex)
{
    var numtotal ;

    for (var i = 0; i < 68; i++) {
        if (AllLineInsNumArray[Vagindex][i] == 256) {
            return i + 1;
        }
    }
    return 256;
}

function stAuth(Domain, AuthUserName, AuthPassword, URI)
{
    this.Domain = Domain;
    if (AuthUserName != null) {
        this.AuthUserName = AuthUserName.toString().replace(/&apos; /g, "\'");
    } else {
        this.AuthUserName = AuthUserName;
    }

    this.AuthPassword = AuthPassword;
    if (URI != null) {
        this.URI = URI.toString().replace(/&apos; /g, "\'");
    } else {
        this.URI = URI;
    }

    var temp = Domain.split('.');
    this.key = '.' + temp[7] + '.';
}

var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.Line.{i}.SIP, AuthUserName|AuthPassword|URI, stAuth);%>;
var AuthList = new Array(new Array(),new Array(),new Array(),new Array());
for (var i = 0; i < AllAuth.length - 1; i++)
{
    var temp = AllAuth[i].Domain.split('.');
    var index = GetVagIndexByInst(temp[5]);
    AuthList[index].push(AllAuth[i]);
}

var recordDirectoryNumber;

function SelectLineRecord(recordId)
{
    selectLine(recordId);
    recordDirectoryNumber = getElement("DirectoryNumber").value;
}

function SubmitBasicPara()
{
    var Form = new webSubmitForm();
    var sndProServerPort;
    var ProServerPort;
    var sndOutboundServerPort;
    var OutboundServerPort;
    var ActionURL;
    var FreeLine;
    var strvar = getValue('AuthPassword');
    if (AllProfile[0] == null) {
        return false;
    }
    var ulret = CheckForm1();
    if (ulret != true) {
        return false;
    }
    ulret = CheckParaForm();
    if (ulret != true) {
        return false;
    }
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

    if (CheckUserRepeat()) {
        return false;
    }

    var addOutbound = getValue('OutboundProxy');
    var addSecondOutbound = getValue('SecondaryOutboundProxy');
    if (addOutbound != AllProfile[vagIndex].Relating.OutboundProxy) {
        Form.addParameter('y.OutboundProxy', getValue('OutboundProxy'));
    }
    Form.addParameter('y.OutboundProxyPort', parseInt(OutboundServerPort));
    if (addSecondOutbound != AllProfile[vagIndex].Relating.X_HW_SecondaryOutboundProxy) {
        Form.addParameter('y.X_HW_SecondaryOutboundProxy', getValue('SecondaryOutboundProxy'));
    }
    Form.addParameter('y.X_HW_SecondaryOutboundProxyPort', parseInt(sndOutboundServerPort));
    Form.addParameter('x.Region', getValue('Region'));
    Form.addParameter('z.DigitMap', getValue('DigitMap'));
    Form.addParameter('x.X_HW_DigitMapMatchMode', getValue('X_HW_DigitMapMatchMode'));
    Form.addParameter('y.ProxyServer', getValue('ProxyServer'));
    Form.addParameter('y.ProxyServerPort', parseInt(ProServerPort));
    Form.addParameter('y.RegistrationPeriod', parseInt(getValue('RegistrationPeriod'), 10));
    Form.addParameter('y.X_HW_SecondaryProxyServerPort', parseInt(sndProServerPort));
    Form.addParameter('y.UserAgentPort', parseInt(getValue('UserAgentPort'), 10));
    Form.addParameter('y.X_HW_SecondaryProxyServer', getValue('SecondProxyServer'));
    Form.addParameter('y.RegistrarServer', getValue('HomeDomain'));
    var curCfgServer = new stSIPServer("", "", "", "", "", "", "", "", "", "", "");
    GetImsSubmit(curCfgServer);
    imsSelectInit(curCfgServer);

    Form.addParameter('f.VImsRegionOption', vimsOpt[0].vims);

    Form.addParameter('x.X_HW_PortName', getValue('X_HW_PortName'));
    Form.addParameter('a.X_HW_PortName', getValue('X_HW_PortName_RTP'));
    if (removeSpaceTrim(getValue('DirectoryNumber')) != '') {
        Form.addParameter('Add_b.DirectoryNumber', "+63" + getValue('DirectoryNumber'));
    } else {
        Form.addParameter('Add_b.DirectoryNumber', getValue('DirectoryNumber'));
    }
    Form.addParameter('Add_b.PhyReferenceList', getValue('PhyReferenceList'));
    Form.addParameter('c.AuthUserName', getValue('AuthUserName'));
    if (strvar != '****************************************************************') {
        Form.addParameter('c.AuthPassword', getValue('AuthPassword'));
    }
    Form.addParameter('c.URI', getValue('URI'));
    if (getCheckVal('Enable') == 1) {
        Form.addParameter('Add_b.Enable','Enabled');
    } else {
        Form.addParameter('Add_b.Enable','Disabled');
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    if (selctIndex == -1) {
        FreeLine = FindFreeLineInst(vagIndex);
        ActionURL = 'complex.cgi?' + 
                    'y=' + AllProfile[vagIndex].Domain + '.SIP' +
                    '&z=' + AllProfile[vagIndex].Domain + '.SIP.X_HW_SIPDigitmap.1' +
                    '&x=' +  AllProfile[vagIndex].Domain +
                    '&a=' + AllProfile[vagIndex].Domain + '.RTP' +
                    '&Add_b=' + AllProfile[vagIndex].Domain + '.Line' +
                    '&c=' + AllProfile[vagIndex].Domain + '.Line.' + FreeLine + '.SIP' +
                    '&f=' + AllProfile[vagIndex].Domain + '.SIP'+ '.X_HW_SIPExtend' +
                    '&RequestFile=html/voip/globevoipinterface/voipinterface_globe.asp';
    } else if (selctIndex == -2) {
        ActionURL = 'set.cgi?' +
                    'y=' + AllProfile[vagIndex].Domain + '.SIP' +
                    '&z=' + AllProfile[vagIndex].Domain + '.SIP.X_HW_SIPDigitmap.1' +
                    '&x=' + AllProfile[vagIndex].Domain +
                    '&a=' + AllProfile[vagIndex].Domain + '.RTP' +
                    '&f=' + AllProfile[vagIndex].Domain + '.SIP'+ '.X_HW_SIPExtend' +
                    '&RequestFile=html/voip/globevoipinterface/voipinterface_globe.asp';
    } else {
        ActionURL = 'set.cgi?' +
                    'y=' + AllProfile[vagIndex].Domain + '.SIP' +
                    '&z=' + AllProfile[vagIndex].Domain + '.SIP.X_HW_SIPDigitmap.1'+
                    '&x=' +  AllProfile[vagIndex].Domain +
                    '&a=' + AllProfile[vagIndex].Domain + '.RTP' +
                    '&Add_b=' + LineList[vagIndex][selctIndex].Domain +
                    '&c=' + LineList[vagIndex][selctIndex].Domain + '.SIP' +
                    '&f=' + AllProfile[vagIndex].Domain + '.SIP'+ '.X_HW_SIPExtend' +
                    '&RequestFile=html/voip/globevoipinterface/voipinterface_globe.asp';
    }
    Form.setAction(ActionURL);
    setDisable('btnApplySipUser', 1);
    setDisable('btnApplyVoipUser', 1);
    setDisable('cancelValue', 1);
    Form.submit();
}

function setCtlDisplay(LineRecord, AuthRecord)
{
    setText('URI', AuthRecord.URI);
    setText('DirectoryNumber', LineRecord.DirectoryNumber);
    setText('AuthUserName', AuthRecord.AuthUserName);
    setText('AuthPassword', AuthRecord.AuthPassword);
    setSelect('PhyReferenceList', LineRecord.PhyReferenceList);
    setCheck('Enable', LineRecord.Enable);
}

function initCtlValue()
{
    setText('URI', '');
    setText('DirectoryNumber','');
    setText('AuthUserName','');
    setText('AuthPassword','');
    setSelect('PhyReferenceList', '');
    setCheck('Enable', '');
}

var g_Index = -1;

function setControl(index)
{
    var record;
    selctIndex = index;

    if (index == -1) {
        if (LineList[vagIndex].length >= ((AllPhyInterface.length - 1) * 17)) {
            setDisplay('ConfigForm1', 0);
            AlertEx(sipinterface['vspa_toomanyuser']);
            return false;
        }
        var LineRecord = new stLine("", "", "Disabled", "");
        var AuthRecord = new stAuth("", "", "", "");
        setDisplay('ConfigForm1', 1);
        setCtlDisplay(LineRecord, AuthRecord);
    } else if (index == -2) {
        setDisplay('ConfigForm1', 0);
    } else {
        record = LineList[vagIndex][index];
        var LineRecord = LineList[vagIndex][index];
        var AuthRecord = AuthList[vagIndex][index];
        setDisplay('ConfigForm1', 1);
        setCtlDisplay(LineRecord, AuthRecord);
    }
    g_Index = index;
}

function clickRemove()
{
    if (LineList[vagIndex].length == 0) {
        AlertEx(sipinterface['vspa_usercanotdel']);
        return;
    }
    if (selctIndex == -1) {
        AlertEx(sipinterface['vspa_usercanotdel1']);
        document.getElementById("DeleteButton").disabled = false;
        return;
    }
    var rml = getElement('linelist' + vagIndex + 'rml');

    var noChooseFlag = true;
    var SubmitForm = new webSubmitForm();

    if (rml.length > 0) {
        for (var i = 0; i < rml.length; i++) {
            if (rml[i].checked == true) {
                noChooseFlag = false;
                SubmitForm.addParameter(rml[i].value, '');
            }
        }
    } else if (rml.checked == true) {
        noChooseFlag = false;
        SubmitForm.addParameter(rml.value, '');
    }
    if (noChooseFlag) {
        AlertEx(sipinterface['vspa_nouserdel']);
        return ;
    }
    if (ConfirmEx(sipinterface['vspa_del']) == false) {
        document.getElementById("DeleteButton").disabled = false;
        return;
    }
    setDisable('btnApplySipUser', 1);
    setDisable('btnApplyVoipUser', 1);
    setDisable('cancelValue', 1);

    if (!noChooseFlag) {
        SubmitForm.setAction('del.cgi?RequestFile=html/voip/globevoipinterface/voipinterface_globe.asp');
        SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
        SubmitForm.submit();
    }
}

function CheckUserRepeat()
{
    var configUri = getValue('URI');
    var configTelNum = getValue('DirectoryNumber');
    var configUserName = getValue('AuthUserName');

    if (UserRepeatCheckFlag[0].UserRepeatCheck == 0) {
        return false;
    }
    if (selctIndex == -3 || selctIndex == -2) {
        return false;
    }
    for (var existIndex = 0; (existIndex < LineList[vagIndex].length) && (existIndex < 2); existIndex++) {
        if (!isEmpty(configTelNum)) {
            if (configTelNum == LineList[vagIndex][existIndex].DirectoryNumber && selctIndex != existIndex) {
                AlertEx("configTelNum " + configTelNum + " exist telNum "+ LineList[vagIndex][existIndex].DirectoryNumber+" repeat!");
                return true;
            }
        }
        if (!isEmpty(configUserName)) {
            if (configUserName == AuthList[vagIndex][existIndex].AuthUserName && selctIndex != existIndex) {
                AlertEx("configUserName " + configUserName + " exist UserName "+ AuthList[vagIndex][existIndex].AuthUserName+" repeat!");
                return true;
            }
        }
        if (!isEmpty(configUri)) {
            if (configUri == AuthList[vagIndex][existIndex].URI && selctIndex != existIndex) {
                AlertEx("configUri " + configUri + " exist URI "+ AuthList[vagIndex][existIndex].URI+" repeat!");
                return true;
            }
        }
    }
    return false;
}

function CancelUserConfig(selctIndex)
{
    LoadFrame();
    selectLine('record_' + selctIndex);
}

function DropDownListSelect(id, ArrayOption)
{
    var Control = getElById(id);
    var i = 1;

    var Option = document.createElement("Option");
    Option.value = "";
    Option.innerText = "";
    Option.text = "";
    Control.appendChild(Option);

    var Option = document.createElement("Option");
    Option.value = "br0";
    Option.innerText = "br0";
    Option.text = "br0";
    Control.appendChild(Option);

    InitWanNameListControlWanname(id, ValidVoipWan);
}

function vIMSChange()
{
    var vImsPara;
    var vImsOption = document.getElementById("VImsRegionOption");
    if (vImsOption.value == '0') {
        vImsPara = gmaPara;
    }
    if (vImsOption.value == '1') {
        vImsPara = luzonPara;
    }
    if (vImsOption.value == '2') {
        vImsPara = visayasPara;
    }
    if (vImsOption.value == '3') {
        vImsPara = mindanaoPara;
    }
    if (vImsOption.value == '4') {
        vImsPara = others;
    }
    document.getElementById("OutboundProxyPort").value = vImsPara.OutboundProxyPort;
    document.getElementById("SecondaryOutboundProxyPort").value = vImsPara.X_HW_SecondaryOutboundProxyPort;
    document.getElementById("ProxyServerPort").value = vImsPara.ProxyServerPort;
    document.getElementById("SecondProxyServerPort").value = vImsPara.X_HW_SecondaryProxyServerPort;
    document.getElementById("UserAgentPort").value = vImsPara.UserAgentPort;
    document.getElementById("HomeDomain").value = vImsPara.RegistrarServer;
    document.getElementById("OutboundProxy").value = vImsPara.OutboundProxy;
    document.getElementById("SecondaryOutboundProxy").value = vImsPara.X_HW_SecondaryOutboundProxy;
    document.getElementById("ProxyServer").value = vImsPara.ProxyServer;
    document.getElementById("SecondProxyServer").value = vImsPara.X_HW_SecondaryProxyServer;
}

function RegionSelect(id)
{
    var Control = getElById(id);
    var Option = document.createElement("Option");
    Option.value = "";
    Option.innerText = "";
    Option.text = "";
    Control.appendChild(Option);

    var RegionEn = [
        ["AF", sipinterface['vspa_AF']],
        ["AX", sipinterface['vspa_AX']],
        ["AL", sipinterface['vspa_AL']],
        ["DZ", sipinterface['vspa_DZ']],
        ["AS", sipinterface['vspa_AS']],
        ["AD", sipinterface['vspa_AD']],
        ["AO", sipinterface['vspa_AO']],
        ["AI", sipinterface['vspa_AI']],
        ["AQ", sipinterface['vspa_AQ']],
        ["AG", sipinterface['vspa_AG']],
        ["AR", sipinterface['vspa_AR']],
        ["AM", sipinterface['vspa_AM']],
        ["AW", sipinterface['vspa_AW']],
        ["AU", sipinterface['vspa_AU']],
        ["AT", sipinterface['vspa_AT']],
        ["AZ", sipinterface['vspa_AZ']],
        ["BS", sipinterface['vspa_BS']],
        ["BH", sipinterface['vspa_BH']],
        ["BD", sipinterface['vspa_BD']],
        ["BB", sipinterface['vspa_BB']],
        ["BY", sipinterface['vspa_BY']],
        ["BE", sipinterface['vspa_BE']],
        ["BZ", sipinterface['vspa_BZ']],
        ["BJ", sipinterface['vspa_BJ']],
        ["BM", sipinterface['vspa_BM']],
        ["BT", sipinterface['vspa_BT']],
        ["BO", sipinterface['vspa_BO']],
        ["BQ", sipinterface['vspa_BQ']],
        ["BA", sipinterface['vspa_BA']],
        ["BW", sipinterface['vspa_BW']],
        ["BV", sipinterface['vspa_BV']],
        ["BR", sipinterface['vspa_BR']],
        ["IO", sipinterface['vspa_IO']],
        ["BN", sipinterface['vspa_BN']],
        ["BG", sipinterface['vspa_BG']],
        ["BF", sipinterface['vspa_BF']],
        ["BI", sipinterface['vspa_BI']],
        ["KH", sipinterface['vspa_KH']],
        ["CM", sipinterface['vspa_CM']],
        ["CA", sipinterface['vspa_CA']],
        ["CV", sipinterface['vspa_CV']],
        ["KY", sipinterface['vspa_KY']],
        ["CF", sipinterface['vspa_CF']],
        ["TD", sipinterface['vspa_TD']],
        ["CL", sipinterface['vspa_CL']],
        ["CN", sipinterface['vspa_CN']],
        ["CX", sipinterface['vspa_CX']],
        ["CC", sipinterface['vspa_CC']],
        ["CO", sipinterface['vspa_CO']],
        ["KM", sipinterface['vspa_KM']],
        ["CG", sipinterface['vspa_CG']],
        ["CK", sipinterface['vspa_CK']],
        ["CR", sipinterface['vspa_CR']],
        ["CI", sipinterface['vspa_CI']],
        ["HR", sipinterface['vspa_HR']],
        ["CU", sipinterface['vspa_CU']],
        ["CW", sipinterface['vspa_CW']],
        ["CY", sipinterface['vspa_CY']],
        ["CZ", sipinterface['vspa_CZ']],
        ["KP", sipinterface['vspa_KP']],
        ["DK", sipinterface['vspa_DK']],
        ["DJ", sipinterface['vspa_DJ']],
        ["DM", sipinterface['vspa_DM']],
        ["DO", sipinterface['vspa_DO']],
        ["EC", sipinterface['vspa_EC']],
        ["EG", sipinterface['vspa_EG']],
        ["SV", sipinterface['vspa_SV']],
        ["GQ", sipinterface['vspa_GQ']],
        ["ER", sipinterface['vspa_ER']],
        ["EE", sipinterface['vspa_EE']],
        ["ET", sipinterface['vspa_ET']],
        ["FK", sipinterface['vspa_FK']],
        ["FO", sipinterface['vspa_FO']],
        ["FJ", sipinterface['vspa_FJ']],
        ["FI", sipinterface['vspa_FI']],
        ["FR", sipinterface['vspa_FR']],
        ["GF", sipinterface['vspa_GF']],
        ["PF", sipinterface['vspa_PF']],
        ["TF", sipinterface['vspa_TF']],
        ["GA", sipinterface['vspa_GA']],
        ["GM", sipinterface['vspa_GM']],
        ["GE", sipinterface['vspa_GE']],
        ["DE", sipinterface['vspa_DE']],
        ["GH", sipinterface['vspa_GH']],
        ["GI", sipinterface['vspa_GI']],
        ["GR", sipinterface['vspa_GR']],
        ["GL", sipinterface['vspa_GL']],
        ["GD", sipinterface['vspa_GD']],
        ["GP", sipinterface['vspa_GP']],
        ["GU", sipinterface['vspa_GU']],
        ["GT", sipinterface['vspa_GT']],
        ["GG", sipinterface['vspa_GG']],
        ["GN", sipinterface['vspa_GN']],
        ["GW", sipinterface['vspa_GW']],
        ["GY", sipinterface['vspa_GY']],
        ["HT", sipinterface['vspa_HT']],
        ["HM", sipinterface['vspa_HM']],
        ["HN", sipinterface['vspa_HN']],
        ["HK", sipinterface['vspa_HK']],
        ["HU", sipinterface['vspa_HU']],
        ["IS", sipinterface['vspa_IS']],
        ["IN", sipinterface['vspa_IN']],
        ["ID", sipinterface['vspa_ID']],
        ["IR", sipinterface['vspa_IR']],
        ["IQ", sipinterface['vspa_IQ']],
        ["IE", sipinterface['vspa_IE']],
        ["IM", sipinterface['vspa_IM']],
        ["IL", sipinterface['vspa_IL']],
        ["IT", sipinterface['vspa_IT']],
        ["JM", sipinterface['vspa_JM']],
        ["JP", sipinterface['vspa_JP']],
        ["JE", sipinterface['vspa_JE']],
        ["JO", sipinterface['vspa_JO']],
        ["KZ", sipinterface['vspa_KZ']],
        ["KE", sipinterface['vspa_KE']],
        ["KI", sipinterface['vspa_KI']],
        ["KW", sipinterface['vspa_KW']],
        ["KG", sipinterface['vspa_KG']],
        ["LA", sipinterface['vspa_LA']],
        ["LV", sipinterface['vspa_LV']],
        ["LB", sipinterface['vspa_LB']],
        ["LS", sipinterface['vspa_LS']],
        ["LR", sipinterface['vspa_LR']],
        ["LY", sipinterface['vspa_LY']],
        ["LI", sipinterface['vspa_LI']],
        ["LT", sipinterface['vspa_LT']],
        ["LU", sipinterface['vspa_LU']],
        ["MO", sipinterface['vspa_MO']],
        ["MG", sipinterface['vspa_MG']],
        ["MW", sipinterface['vspa_MW']],
        ["MY", sipinterface['vspa_MY']],
        ["MV", sipinterface['vspa_MV']],
        ["ML", sipinterface['vspa_ML']],
        ["MT", sipinterface['vspa_MT']],
        ["MH", sipinterface['vspa_MH']],
        ["MQ", sipinterface['vspa_MQ']],
        ["MR", sipinterface['vspa_MR']],
        ["MU", sipinterface['vspa_MU']],
        ["YT", sipinterface['vspa_YT']],
        ["MX", sipinterface['vspa_MX']],
        ["FM", sipinterface['vspa_FM']],
        ["MD", sipinterface['vspa_MD']],
        ["MC", sipinterface['vspa_MC']],
        ["MN", sipinterface['vspa_MN']],
        ["ME", sipinterface['vspa_ME']],
        ["MS", sipinterface['vspa_MS']],
        ["MA", sipinterface['vspa_MA']],
        ["MZ", sipinterface['vspa_MZ']],
        ["MM", sipinterface['vspa_MM']],
        ["NA", sipinterface['vspa_NA']],
        ["NR", sipinterface['vspa_NR']],
        ["NP", sipinterface['vspa_NP']],
        ["NL", sipinterface['vspa_NL']],
        ["NC", sipinterface['vspa_NC']],
        ["NZ", sipinterface['vspa_NZ']],
        ["NI", sipinterface['vspa_NI']],
        ["NE", sipinterface['vspa_NE']],
        ["NG", sipinterface['vspa_NG']],
        ["NU", sipinterface['vspa_NU']],
        ["NF", sipinterface['vspa_NF']],
        ["MK", sipinterface['vspa_MK']],
        ["MP", sipinterface['vspa_MP']],
        ["NO", sipinterface['vspa_NO']],
        ["OM", sipinterface['vspa_OM']],
        ["PK", sipinterface['vspa_PK']],
        ["PW", sipinterface['vspa_PW']],
        ["PS", sipinterface['vspa_PS']],
        ["PA", sipinterface['vspa_PA']],
        ["PG", sipinterface['vspa_PG']],
        ["PY", sipinterface['vspa_PY']],
        ["PE", sipinterface['vspa_PE']],
        ["PH", sipinterface['vspa_PH']],
        ["PN", sipinterface['vspa_PN']],
        ["PL", sipinterface['vspa_PL']],
        ["PT", sipinterface['vspa_PT']],
        ["PR", sipinterface['vspa_PR']],
        ["QA", sipinterface['vspa_QA']],
        ["KR", sipinterface['vspa_KR']],
        ["RE", sipinterface['vspa_RE']],
        ["RO", sipinterface['vspa_RO']],
        ["RU", sipinterface['vspa_RU']],
        ["RW", sipinterface['vspa_RW']],
        ["BL", sipinterface['vspa_BL']],
        ["SH", sipinterface['vspa_SH']],
        ["KN", sipinterface['vspa_KN']],
        ["LC", sipinterface['vspa_LC']],
        ["MF", sipinterface['vspa_MF']],
        ["PM", sipinterface['vspa_PM']],
        ["VC", sipinterface['vspa_VC']],
        ["WS", sipinterface['vspa_WS']],
        ["SM", sipinterface['vspa_SM']],
        ["ST", sipinterface['vspa_ST']],
        ["SA", sipinterface['vspa_SA']],
        ["SN", sipinterface['vspa_SN']],
        ["RS", sipinterface['vspa_RS']],
        ["SC", sipinterface['vspa_SC']],
        ["SL", sipinterface['vspa_SL']],
        ["SG", sipinterface['vspa_SG']],
        ["SX", sipinterface['vspa_SX']],
        ["SK", sipinterface['vspa_SK']],
        ["SI", sipinterface['vspa_SI']],
        ["SB", sipinterface['vspa_SB']],
        ["SO", sipinterface['vspa_SO']],
        ["ZA", sipinterface['vspa_ZA']],
        ["GS", sipinterface['vspa_GS']],
        ["SS", sipinterface['vspa_SS']],
        ["ES", sipinterface['vspa_ES']],
        ["LK", sipinterface['vspa_LK']],
        ["SD", sipinterface['vspa_SD']],
        ["SR", sipinterface['vspa_SR']],
        ["SJ", sipinterface['vspa_SJ']],
        ["SZ", sipinterface['vspa_SZ']],
        ["SE", sipinterface['vspa_SE']],
        ["CH", sipinterface['vspa_CH']],
        ["SY", sipinterface['vspa_SY']],
        ["TW", sipinterface['vspa_TW']],
        ["TJ", sipinterface['vspa_TJ']],
        ["TZ", sipinterface['vspa_TZ']],
        ["TH", sipinterface['vspa_TH']],
        ["CD", sipinterface['vspa_CD']],
        ["TL", sipinterface['vspa_TL']],
        ["TG", sipinterface['vspa_TG']],
        ["TK", sipinterface['vspa_TK']],
        ["TO", sipinterface['vspa_TO']],
        ["TT", sipinterface['vspa_TT']],
        ["TN", sipinterface['vspa_TN']],
        ["TR", sipinterface['vspa_TR']],
        ["TM", sipinterface['vspa_TM']],
        ["TC", sipinterface['vspa_TC']],
        ["TV", sipinterface['vspa_TV']],
        ["UG", sipinterface['vspa_UG']],
        ["UA", sipinterface['vspa_UA']],
        ["AE", sipinterface['vspa_AE']],
        ["GB", sipinterface['vspa_GB']],
        ["US", sipinterface['vspa_US']],
        ["UM", sipinterface['vspa_UM']],
        ["UY", sipinterface['vspa_UY']],
        ["UZ", sipinterface['vspa_UZ']],
        ["VU", sipinterface['vspa_VU']],
        ["VA", sipinterface['vspa_VA']],
        ["VE", sipinterface['vspa_VE']],
        ["VN", sipinterface['vspa_VN']],
        ["VG", sipinterface['vspa_VG']],
        ["VI", sipinterface['vspa_VI']],
        ["WF", sipinterface['vspa_WF']],
        ["YE", sipinterface['vspa_YE']],
        ["ZM", sipinterface['vspa_ZM']],
        ["ZW", sipinterface['vspa_ZW']]];

    for (i = 0; i < RegionEn.length; i++) {
        var Option = document.createElement("Option");
        Option.value = RegionEn[i][0];
        Option.innerText = RegionEn[i][1];
        Option.text = RegionEn[i][1];
        Control.appendChild(Option);
    }
}

function DropDownLineListSelect(id, ArrayOption)
{
    var Control = getElById(id);
    var i = 1;

    var Option = document.createElement("Option");
    Option.value = "";
    Option.innerText = "";
    Option.text = "";
    Control.appendChild(Option);

    var PotsNum = parseInt(PortNum, 10);
    for (i = 1; i <= PotsNum; i++) {
        var Option = document.createElement("Option");
        Option.value = i;
        Option.innerText = i;
        Option.text = i;
        Control.appendChild(Option);
    }
}

function SubmitGetProfile(vagInst)
{
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    Form.setAction('SetVoiceVagIndex.cgi?vagIndex=' + vagInst);
    Form.setTarget('disableIframe');
    Form.submit();

    vagIndex = GetVagIndexByInst(vagInst);
    LoadFrame();
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("VoipInterface", GetDescFormArrayById(sipinterface, "v01"), GetDescFormArrayById(sipinterface, "v02"), false);
</script>

<div class="title_spread"></div>

<script type="text/javascript">
if(AllProfile.length > 2)
{
    document.write('<iframe name="disableIframe" style="display:none"></iframe>');
    document.write('<table border="0" cellpadding="0" cellspacing="0">');
    document.write('<tr>');
    var html = '';

    for(var i = 0; i < AllProfile.length-1; i++)
    {
        html += '<td><input id="vag_' + i + '" name="vag_tr" type="button" onfocus="this.blur()" class="submit" style="cursor:pointer;background:#C3C3C3;font-size: 12px;height: 25px;width: 110px;border: 0px;" onClick="SubmitGetProfile(' +htmlencode(AllProfile[i].profileid)+ ');"/>';
        html += '</td>';
    }

    document.write(html);
    document.write('</tr>');
    document.write('</table>');
}
</script>

<form id="voipbasic">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title">
  <tr> 
    <td BindText='vspa_basic'></td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg"> 
<li id="VImsRegionOption" RealType="DropDownList" DescRef="vspa_IMSRegion" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="VImsOption" InitValue="[{TextRef:'vspa_GMA',Value:'0'},{TextRef:'vspa_Luzon',Value:'1'},{TextRef:'vspa_Visayas',Value:'2'},{TextRef:'vspa_Mindanao',Value:'3'},{TextRef:'vspa_Others',Value:'4'}]" ClickFuncApp="onchange=vIMSChange"/>
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
<li id="DigitMap" RealType="TextArea" DescRef="vspa_digmap" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="DigitMap" InitValue="Empty" Elementclass="interfacetextclass"/>
<li id="X_HW_DigitMapMatchMode" RealType="DropDownList" DescRef="vspa_digmatchmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="X_HW_DigitMapMatchMode" InitValue="[{TextRef:'vspa_minmat',Value:'Min'},{TextRef:'vspa_maxmat',Value:'Max'}]"/>
<li id="RegistrationPeriod" RealType="TextBox" DescRef="vspa_regperiod" RemarkRef="vspa_regperiodhint" ErrorMsgRef="Empty" Require="FALSE" BindField="RegistrationPeriod" InitValue="Empty" MaxLength="11"/>
<li id="X_HW_PortName" RealType="DropDownList" DescRef="vspa_sigport" RemarkRef="vspa_sigporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" Elementclass="restrict_dir_ltr"/>
<li id="X_HW_PortName_RTP" RealType="DropDownList" DescRef="vspa_meiport" RemarkRef="vspa_meiporthint" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" Elementclass="restrict_dir_ltr"/>
<li id="Region" RealType="DropDownList" DescRef="vspa_Region" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Region" InitValue="Empty"/>
<script>
var VoipConfigFormList1 = HWGetLiIdListByForm("voipbasic", null);
HWParsePageControlByID("voipbasic", TableClass, sipinterface, null);
var VoipBasicParaSetArray = new Array();
DropDownListSelect("X_HW_PortName", WanInfo);
DropDownListSelect("X_HW_PortName_RTP", WanInfo);
RegionSelect("Region");
HWSetTableByLiIdList(VoipConfigFormList1, VoipBasicParaSetArray, null);
</script>
</table>
</form>


<div class="func_spread"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title">
  <tr> 
    <td BindText='vspa_userbaspara'></td>
  </tr>
</table>

<script language="JavaScript" type="text/javascript">
initCtlValue();
var i = 0;
var ShowableFlag = 1;
var ShowButtonFlag = 1;
var ColumnNum = 7;
var ConfiglistInfo = new Array(new stTableTileInfo("Empty", "", "DomainBox", false),
                               new stTableTileInfo("vspa_seq", "align_center", "index", false),
                               new stTableTileInfo("vspa_useruri", "wordclass align_center", "URI", false),
                               new stTableTileInfo("vspa_regusername", "wordclass align_center", "TelNo", false),
                               new stTableTileInfo("vspa_authusername", "wordclass align_center", "AuthUserName", false),
                               new stTableTileInfo("vspa_password", "align_center", "Password", false),
                               new stTableTileInfo("vspa_assopot", "align_center", "PhyReferenceList", false), null);

function GetVAGPara(vagInsId)
{
    var VoipArray = new Array();
    if (LineList[vagInsId].length == 0) {
        var VoipShowTab = new ShowTab();
        VoipShowTab.index = "--";
        VoipShowTab.URI = "--";
        VoipShowTab.TelNo = "--";
        VoipShowTab.AuthUserName = "--";
        VoipShowTab.Password = "--";
        VoipShowTab.PhyReferenceList = "--";
    } else {
        for (var i = 0; i < LineList[vagInsId].length; i++) {
            var VoipShowTab = new ShowTab();
            VoipShowTab.domain = LineList[vagInsId][i].Domain;
            VoipShowTab.index = i + 1;
            if (AuthList[vagInsId][i].URI == "") {
                VoipShowTab.URI = "--";
            } else {
                VoipShowTab.URI = AuthList[vagInsId][i].URI;
            }
            if (LineList[vagInsId][i].DirectoryNumber == "") {
                VoipShowTab.TelNo = "--";
            } else {
                VoipShowTab.TelNo = "+63" + LineList[vagInsId][i].DirectoryNumber;
            }
            if (AuthList[vagInsId][i].AuthUserName == "") {
                VoipShowTab.AuthUserName = "--";
            } else {
                VoipShowTab.AuthUserName = AuthList[vagInsId][i].AuthUserName;
            }
            VoipShowTab.Password = "*******";
            if (LineList[vagInsId][i].PhyReferenceList == "") {
                VoipShowTab.PhyReferenceList = "--";
            } else {
                VoipShowTab.PhyReferenceList = LineList[vagInsId][i].PhyReferenceList;
            }
            VoipArray.push(VoipShowTab);
        }
    }
    VoipArray.push(null);
    return VoipArray;
}

for (var index = 0; index < maxvagnum; index++)
{
    var tableid = "linelist"+index;
    VoipArray = GetVAGPara(index);
    HWShowTableListByType(ShowableFlag, tableid, ShowButtonFlag, ColumnNum, VoipArray, ConfiglistInfo, sipinterface, null);
}

function linelist0selectRemoveCnt()
{
}

function linelist1selectRemoveCnt()
{
}

</script>

<form id="ConfigForm1">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
<tbody>
<tr>
<td class="table_title width_per30">Enable User:</td>
<td class="table_right width_per70">
<input id="Enable" type="checkbox" realtype="CheckBox" class="CheckBox" bindfield="Enable">
</td>
</tr>
<tr>
<td class="table_title width_per30">Associated POTS Port:</td>
<td class="table_right width_per70">
<select id="PhyReferenceList" class="selectdefcss" realtype="DropDownList" bindfield="PhyReferenceList"></select>
<span class="gray" id="PhyReferenceListspan">
</span>
</td>
</tr>
<tr>
<td class="table_title width_per30">URI:</td>
<td class="table_right width_per70"> 
<input id="URI" type="text" title="URI" class="lineclass" maxlength="null" realtype="TextBox" bindfield="URI">
<span class="gray" id="URIRemark">(URI)</span>
</td>
</tr>
<tr>
<td class="table_title width_per30">Telephone Number:</td>
<td class="table_right width_per63"> +63 <input id="DirectoryNumber" type="text" title="phone number" class="lineclass2" maxlength="null" realtype="TextBox" bindfield="DirectoryNumber" oninput = NumberChange()>
<span class="gray" id="DirectoryNumberRemark">(phone number)</span></td></tr>
<tr>
<td class="table_title width_per30">Password:</td>
<td class="table_right width_per70">
<input autocomplete="off" id="AuthPassword" type="password" title="The length must range 0 to 64. Double-click to select all." class="lineclass" maxlength="null" realtype="TextBox" bindfield="AuthPassword">
<span class="gray" id="AuthPasswordRemark">(The length must range 0 to 64. Double-click to select all.)</span>
</td>
</tr>
<tr>
<td class="table_title width_per30">User Name:</td>
<td id="AuthUserNameCol" class="table_right width_per70">
<input id="AuthUserName" type="text" title="The length must range 0 to 64." class="lineclass" maxlength="null" realtype="TextBox" bindfield="AuthUserName">
<span class="gray" id="AuthUserNameRemark">(The length must range 0 to 64.)</span></td>
</tr>
</tbody>
</table>
</div>
<script>
var VoipConfigFormList2 = HWGetLiIdListByForm("ConfigForm1", null);
HWParsePageControlByID("ConfigForm1", TableClass, sipinterface, null);
DropDownLineListSelect("PhyReferenceList", AllPhyInterface);
</script>
</table>
</form>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
<tr >
<td class="table_submit width_per25"></td>
<td class="table_submit"> 
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
<input name="btnApplyVoipUser" id="btnApplyVoipUser" type="button" class="ApplyButtoncss buttonwidth_100px" value="Apply" onClick="SubmitBasicPara();"/>
<script type="text/javascript">
document.getElementsByName('btnApplyVoipUser')[0].value = sipinterface['vspa_apply'];
</script>
<input name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" value="Cancel" onClick="CancelUserConfig(selctIndex);"/>
<script>
document.getElementsByName('cancelValue')[0].value = sipinterface['vspa_cancel'];
</script>

</td>
</tr>
</table>
<br></br>

</body>
</html>

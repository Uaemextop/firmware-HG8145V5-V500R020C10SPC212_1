var gmaPara = new stSIPServer("", "10.91.52.32", "5060", "10.91.52.32", "5060", "10.91.52.36", "5060", "10.91.52.36", "5060", "vims.globe.com.ph", "5060");
var luzonPara = new stSIPServer("", "10.91.52.36", "5060", "10.91.52.36", "5060", "10.91.52.32", "5060", "10.91.52.32", "5060", "vims.globe.com.ph", "5060");
var visayasPara = new stSIPServer("", "10.91.53.32", "5060", "10.91.53.32", "5060", "10.91.53.36", "5060", "10.91.53.36", "5060", "vims.globe.com.ph", "5060");
var mindanaoPara = new stSIPServer("", "10.91.53.36", "5060", "10.91.53.36", "5060", "10.91.53.32", "5060", "10.91.53.32", "5060", "vims.globe.com.ph", "5060");
var others = new stSIPServer("", "", "5060", "", "5060", "", "5060", "", "5060", "", "5060");

var vimsOpt = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.{i}.SIP.X_HW_SIPExtend, VImsRegionOption, stVims);%>;
function stVims(Domain, vims)
{
    this.Domain = Domain;
    this.vims = vims;
}

function stSIPServer(Domain, ProxyServer, ProxyServerPort, OutboundProxy, OutboundProxyPort, X_HW_SecondaryOutboundProxy, X_HW_SecondaryOutboundProxyPort, X_HW_SecondaryProxyServer, X_HW_SecondaryProxyServerPort, RegistrarServer, UserAgentPort)
{
    this.Domain = Domain;
    this.OutboundProxy = OutboundProxy;
    this.OutboundProxyPort = OutboundProxyPort;
    this.X_HW_SecondaryOutboundProxy = X_HW_SecondaryOutboundProxy;
    this.X_HW_SecondaryOutboundProxyPort = X_HW_SecondaryOutboundProxyPort;
    this.ProxyServer = ProxyServer;
    this.ProxyServerPort = ProxyServerPort;
    this.X_HW_SecondaryProxyServer = X_HW_SecondaryProxyServer;
    this.X_HW_SecondaryProxyServerPort = X_HW_SecondaryProxyServerPort;
    this.UserAgentPort = UserAgentPort;
    this.RegistrarServer = RegistrarServer;
    var temp = Domain.split('.');
    this.key = '.' + temp[5] + '.';
}


function CheckForm1()
{
    if (removeSpaceTrim(getValue('OutboundProxy')) != '') {
        if (isIpAddress(getValue('OutboundProxy')) == true) {
            if (isvalidVoipIpAddress(getValue('OutboundProxy')) == false) {
                AlertEx(sipinterface['vspa_outproxyaddvalid']);
                return false;
            }
        } else {
            if (vspaisValidCfgStr(sipinterface['vspa_theoutproxy'], getValue('OutboundProxy'), 65) == false) {
                return false;
            }
        }
    }

    if (removeSpaceTrim(getValue('OutboundProxyPort')) != '') {
        if (isValidVoipPort(getValue('OutboundProxyPort')) == false) {
            AlertEx(sipinterface['vspa_theoutport'] +  getValue('OutboundProxyPort') + sipinterface['vspa_isvalid']);
            return false;
        }
    }
    if (removeSpaceTrim(getValue('SecondaryOutboundProxy')) != '') {
        if (isIpAddress(getValue('SecondaryOutboundProxy')) == true) {
            if (isvalidVoipIpAddress(getValue('SecondaryOutboundProxy')) == false) {
                AlertEx(sipinterface['vspa_secproxyaddvalid']);
                return false;
            }
        } else {
            if (vspaisValidCfgStr(sipinterface['vspa_thesecproxy'], getValue('SecondaryOutboundProxy'), 65) == false) {
                return false;
            }
        }
    }
    if (removeSpaceTrim(getValue('SecondaryOutboundProxyPort')) != '') {
        if (isValidVoipPort(getValue('SecondaryOutboundProxyPort')) == false) {
            AlertEx(sipinterface['vspa_thesecporxy'] + getValue('SecondaryOutboundProxyPort') + sipinterface['vspa_isvalid']);
            return false;
        }
    }

    if (removeSpaceTrim(getValue('ProxyServer')) != '') {
        if (isIpAddress(getValue('ProxyServer')) == true) {
            if (isvalidVoipIpAddress(getValue('ProxyServer')) == false) {
                AlertEx(sipinterface['vspa_priproxyaddva']);
                return false;
            }
        } else {
            if (vspaisValidCfgStr(sipinterface['vspa_thepriproxy'], getValue('ProxyServer'), 65) == false) {
                return false;
            }
        }
    }

    if (removeSpaceTrim(getValue('ProxyServerPort')) != '') {
        if (isValidVoipPort(getValue('ProxyServerPort')) == false) {
            AlertEx(sipinterface['vspa_thepri'] +  getValue('ProxyServerPort') + sipinterface['vspa_isvalid']);
            return false;
        }
    }

    if (removeSpaceTrim(getValue('SecondProxyServer')) != '') {
        if (isIpAddress(getValue('SecondProxyServer')) == true) {
            if (isvalidVoipIpAddress(getValue('SecondProxyServer')) == false) {
                AlertEx(sipinterface['vspa_stproxyaddvalid']);
                return false;
            }
        } else {
            if (vspaisValidCfgStr(sipinterface['vspa_standbyproxy'], getValue('SecondProxyServer'), 65) == false) {
                return false;
            }
        }
    }

    if (removeSpaceTrim(getValue('SecondProxyServerPort')) != '') {
        if (isValidVoipPort(getValue('SecondProxyServerPort')) == false) {
            AlertEx(sipinterface['vspa_thestport'] +  getValue('SecondProxyServerPort') + sipinterface['vspa_isvalid']);
            return false;
        }
    }

    if (removeSpaceTrim(getValue('HomeDomain')) != '') {
        if (isIpAddress(getValue('HomeDomain')) == true) {
            if (isvalidVoipIpAddress(getValue('HomeDomain')) == false) {
                AlertEx(sipinterface['vspa_domainvalid']);
                return false;
            }
        } else {
            if (vspaisValidCfgStr(sipinterface['vspa_thehomedomain'], getValue('HomeDomain'), 65) == false) {
                AlertEx(sipinterface['vspa_domainvalid']);
                return false;
            }
        }
    }

    if (getValue('UserAgentPort') == '') {
        AlertEx(sipinterface['vspa_siploporthint']);
        return false;
    } else {
        if (isValidVoipPort(getValue('UserAgentPort')) == false) {
            AlertEx(sipinterface['vspa_siploport'] +  getValue('UserAgentPort') + sipinterface['vspa_isvalid']);
            return false;
        }
    }

    return true;
}

function SetSipServerDisplay(display)
{
    setDisplay('OutboundProxyRow', display);
    setDisplay('OutboundProxyPortRow', display);
    setDisplay('SecondaryOutboundProxyRow', display);
    setDisplay('SecondaryOutboundProxyPortRow', display);
    setDisplay('ProxyServerRow', display);
    setDisplay('ProxyServerPortRow', display);
    setDisplay('SecondProxyServerRow', display);
    setDisplay('SecondProxyServerPortRow', display);
    setDisplay('UserAgentPortRow', display);
    setDisplay('HomeDomainRow', display);
}

function initvIms()
{
    if (getSelectVal("VImsRegionOption") == 4) {
        SetSipServerDisplay(1);
    } else {
        SetSipServerDisplay(0);
    }
}

function CheckParaForm()
{
    if (removeSpaceTrim(getValue('DirectoryNumber')) != '') {
        if (vspaisValidCfgStr(sipinterface['vspa_theregister'], getValue('DirectoryNumber'), 64) == false) {
            return false;
        }
    }

    if (removeSpaceTrim(getValue('URI')) != '') {
        if (vspaisValidCfgStr(sipinterface['vspa_theuri'], getValue('URI'), 64) == false) {
            return false;
        }
    }

    if (removeSpaceTrim(getValue('AuthUserName')) != '') {
        if (vspaisValidCfgStr(sipinterface['vspa_theauthname'], getValue('AuthUserName'), 64) == false) {
            return false;
        }
    }

    if (removeSpaceTrim(getValue('AuthPassword')) != '') {
        if (vspaisValidCfgStr(sipinterface['vspa_thepassword'], getValue('AuthPassword'), 64) == false) {
            return false;
        }
    }

    if ((selctIndex < 0) || (getValue('PhyReferenceList') != LineList[vagIndex][selctIndex].PhyReferenceList) ||
        (getCheckVal('Enable') != LineList[vagIndex][selctIndex].Enable)) {
        for (var i = 0; i < LineList[vagIndex].length; i++) {
            if (selctIndex == i) {
                continue;
            }
            if ((getValue('PhyReferenceList') == "") || (getValue('PhyReferenceList') != LineList[vagIndex][i].PhyReferenceList)) {
                continue;
            }
            if ((getCheckVal('Enable') == 1) && (LineList[vagIndex][i].Enable == 1)) {
                var ret = ConfirmEx(sipinterface['vspa_pots'] + getValue('PhyReferenceList') + sipinterface['vspa_potsassohint']);
                return ret;
            }
        }
    }

    if (getValue('PhyReferenceList') != "") {
        for (var i = 0; i < LineList.length; i++) {
            if (vagIndex == i) {
                continue;
            }
            for (var j = 0; j < LineList[i].length; j++) {
                if (getValue('PhyReferenceList') == LineList[i][j].PhyReferenceList) {
                    AlertEx(sipinterface['vspa_vagsportexsit']);
                    return false;
                }
            }
        }
    }

    var sipAuthUserName = getValue('AuthUserName');
    var inLen = sipAuthUserName.length;

    if (inLen != 0) {
        if ((sipAuthUserName.charAt(0) == ' ') || (sipAuthUserName.charAt(inLen - 1) == ' ')) {
            if (ConfirmEx(sipinterface['vspa_spacewarning'])) {
                return true;
            } else {
                return false;
            }
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

function vIMSChange()
{
    var vImsPara;
    var vImsOption = document.getElementById("VImsRegionOption");
    initvIms();
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

function CheckImsSelect(curSipServer, imsTemplate)
{
    if (curSipServer.OutboundProxy == imsTemplate.OutboundProxy &&
        curSipServer.OutboundProxyPort == imsTemplate.OutboundProxyPort &&
        curSipServer.X_HW_SecondaryOutboundProxy == imsTemplate.X_HW_SecondaryOutboundProxy &&
        curSipServer.X_HW_SecondaryOutboundProxyPort == imsTemplate.X_HW_SecondaryOutboundProxyPort &&
        curSipServer.ProxyServer == imsTemplate.ProxyServer &&
        curSipServer.ProxyServerPort == imsTemplate.ProxyServerPort &&
        curSipServer.X_HW_SecondaryProxyServer == imsTemplate.X_HW_SecondaryProxyServer &&
        curSipServer.X_HW_SecondaryProxyServerPort == imsTemplate.X_HW_SecondaryProxyServerPort &&
        curSipServer.RegistrarServer == imsTemplate.RegistrarServer &&
        curSipServer.UserAgentPort == imsTemplate.UserAgentPort) {
        return true;
    }
    return false;
}

function imsSelectInit(curSipServer)
{
    if (CheckImsSelect(curSipServer, gmaPara)) {
        vimsOpt[0].vims = 0;
    } else if (CheckImsSelect(curSipServer, luzonPara)) {
        vimsOpt[0].vims = 1;
    } else if (CheckImsSelect(curSipServer, visayasPara)) {
        vimsOpt[0].vims = 2;
    } else if (CheckImsSelect(curSipServer, mindanaoPara)) {
        vimsOpt[0].vims = 3;
    } else {
        vimsOpt[0].vims = 4;
    }
}

function GetImsSubmit(curSipServer)
{
    curSipServer.OutboundProxyPort = getValue('OutboundProxyPort');
    curSipServer.X_HW_SecondaryOutboundProxyPort = getValue('SecondaryOutboundProxyPort');
    curSipServer.ProxyServerPort = getValue('ProxyServerPort');
    curSipServer.X_HW_SecondaryProxyServerPort = getValue('SecondProxyServerPort');
    curSipServer.UserAgentPort = getValue('UserAgentPort');
    curSipServer.RegistrarServer = getValue('HomeDomain');
    curSipServer.OutboundProxy = getValue('OutboundProxy');
    curSipServer.X_HW_SecondaryOutboundProxy = getValue('SecondaryOutboundProxy');
    curSipServer.ProxyServer = getValue('ProxyServer');
    curSipServer.X_HW_SecondaryProxyServer = getValue('SecondProxyServer');
}
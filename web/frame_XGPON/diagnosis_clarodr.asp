<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta http-equiv="Pragma" content="no-cache" />
    <script src="/../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"
        type="text/javascript"></script>
    <script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <link href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>" media="all" rel="stylesheet" />
    <script src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>" language="JavaScript"></script>
    <script language="javascript" src="/asp/getHardwareDetectionResult.asp"></script>
    <script>
        var diagnoseAllResult;
        var allLedState1;
        var allLedState2;
        var EquipTestResultInfo;
        var EquipShowStr;
        var CLICK_START_FLAG = "START";
        var CLICK_TERMINAL_FLAG = "TERMIANL";
        var EQUIPTEST_FLAG = "EquipTest";
        var EquipTestClickFlag = "<%HW_WEB_GetRunState("EquipTest");%>";
        var EquipFinalStr;
        var PhyResult = new Array();
        var ontInfos = <% HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT, Ontid|State, ONTInfo);%>;
        var ontInfo = ontInfos[0];
        var WlanInfo = new Array();
        WlanInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, Enable|Name, stWlan);%>;
        var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';
        var radioEnable1 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.1.Enable);%>';
        var SsidPerBand = '<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>';
        var ssidStart2G = 0;
        var ssidEnd2G = SsidPerBand - 1;
        var ssidStart5G = SsidPerBand;
        var ssidEnd5G = 2 * SsidPerBand -1;
        var radioEnable2 = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.WiFi.Radio.2.Enable);%>';
        var portNum = '<%HW_WEB_GetPortNum();%>';
        var ledStr;
        var lanid = "";
        var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
        var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
        var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
        var ShowStr = "";
        if (window.location.href.indexOf(br0Ip) == -1) {
            window.location = 'http://' + br0Ip +':'+ httpport +'/diagnosis_clarodr.asp';
        }

        getAllLedstate();
        var wlanMode = {
            "11a" : "802.11a",
            "11na" : "802.11a/n",
            "11ac" : "802.11a/n/ac",
            "11nac" : "802.11n/ac",
            "11aconly" : "802.11ac",
            "11b" : "802.11b",
            "11g" : "802.11g",
            "11n" : "802.11n",
            "11bg" : "802.11b/g",
            "11gn" : "802.11g/n",
            "11bgn" : "802.11b/g/n",
            "11ax" : "802.11b/g/n/ax",
            "11ax" : "802.11a/n/ac/ax"
        };

        var wlanArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, X_HW_Standard, stWlanWifi);%>;
        function stWlanWifi(domain, X_HW_Standard) {
            this.domain = domain;
            this.X_HW_Standard = X_HW_Standard;
        }

        function getAllLedstate() {
            if (portNum == 1) {
                var allLedState = "<%WEB_GetAllLedState("1");%>";
            } else if (portNum == 2) {
                var allLedState = "<%WEB_GetAllLedState("2");%>";
            }

            if (allLedState != null) {
                ledStr = allLedState.split("|");
            }
        }

        function ONTInfo(domain, ONTID, Status) {
            this.domain = domain;
            this.ONTID = ONTID;
            this.Status = Status;
        }

        function stWlan(domain, enable, name) {
            this.domain = domain;
            this.enable = enable;
            this.name = name;
        }

        function setwifiStatus() {
            if ((wlanEnbl == 1) && (radioEnable1 == 1) && (true == IsExistEnableSSID(1))) {
                document.getElementById("wifiStatusResult2_enable").innerHTML = "Enabled";
            } else {
                document.getElementById("wifiStatusResult2_enable").innerHTML = "Disabled";
            }
            
            document.getElementById("wifiStatusResult2_mode").innerHTML = wlanMode[wlanArr[0].X_HW_Standard];

            if (DoubleFreqFlag === "1") {
                if ((wlanEnbl == 1) && (radioEnable2 == 1) && (true == IsExistEnableSSID(2))) {
                    document.getElementById("wifiStatusResult5_enable").innerHTML = "Enabled";
                } else {
                    document.getElementById("wifiStatusResult5_enable").innerHTML = "Disabled";
                }

                document.getElementById("wifiStatusResult5_mode").innerHTML = wlanMode[wlanArr[1].X_HW_Standard];
            } else {
                setDisplay("wlan5GResult", 0);
                setDisplay("wlan5GModeResult", 0);
            }
        }

        function setponStatus() {
            document.getElementById("ponLinkResult").innerHTML = ontInfo.Status;
        }

        function setHardwareStatus() {
            document.getElementById("hardwareDetectionResult").innerHTML = ShowStr;
        }

        function getWlanPortNumber(name) {
            if (name != '') {
                if (name.length > 4) {
                    return parseInt(name.charAt(name.length - 2) + name.charAt(name.length - 1));
                } else {
                    return parseInt(name.charAt(name.length - 1));
                }
            }
        }

        function IsExistEnableSSID(RadioInst) {
            for (var i = 0; i < WlanInfo.length - 1; i++) {
                var athindex = getWlanPortNumber(WlanInfo[i].name);
                if (RadioInst == 1) {
                    if ((athindex >= ssidStart2G) && (athindex <= ssidEnd2G)) {
                        if (1 == WlanInfo[i].enable) {
                            return true;
                        }
                    }
                } else {
                    if ((athindex >= ssidStart5G) && (athindex <= ssidEnd5G)) {
                        if (1 == WlanInfo[i].enable) {
                            return true;
                        }
                    }
                }
            }

            return false;
        }

        function ParseLinkTestResult(rawresult) {
            var result = "";
            var resulttemp = "";
            var nochecknum = 0;
            var innerres;
            var finalres;
            portres = rawresult.split(";");

            for (i = 0; i < 12; i++) {
                innerres = portres[i].split(":");
                finalres = innerres[1];

                if (finalres.indexOf("NoCheck") >= 0) {
                    nochecknum++;
                    continue;
                }

                if (!(i % 2)) {
                    if (finalres.indexOf("Failed") >= 0) {
                        resulttemp = "511X ETH" + (i + 2) / 2 + "MAC chip forwarding fails.";
                        result += resulttemp;
                    }
                }
                else {
                    if (finalres.indexOf("Failed") >= 0) {
                        resulttemp = "ETH" + (i + 1) / 2 + 'PHY chip forwarding fails.';
                        result += resulttemp;
                    }
                }
            }

            if (nochecknum == 12) {
                result = "NoCheck";
            }
            return result;
        }

        function ParseSelfTestResult(SelfTestResult, PhyResult) {
            var result = "";
            var resulttemp = "";
            if (SelfTestResult.SD5113Result.indexOf("Failed") >= 0) {
                result += "SD5113 chip fault.";
            }

            if ((SelfTestResult.WifiResult.indexOf("Failed") >= 0) || (SelfTestResult.WifiResult.indexOf("FAIL") >= 0)) {
                result += 'Wi-Fi chip fault.';
            }

            if (SelfTestResult.LswResult.indexOf("Failed") >= 0) {
                result += 'LSW chip fault.';
            }

            if (SelfTestResult.CodecResult.indexOf("Failed") >= 0) {
                result += 'Codec chip fault.';
            }

            if (SelfTestResult.OpticResult.indexOf("Failed") >= 0) {
                result += 'Optical module chip fault.';
            }

                var PhyNumber = 6;

            for (i = 0; i < PhyNumber; i++) {
                if (PhyResult[i].indexOf("Failed") >= 0) {
                    resulttemp = "ETH" + (i + 1) + 'PHY chip fault.';
                    result += resulttemp;
                }
            }

            if (SelfTestResult.ExtRfResult.indexOf("Failed") >= 0) {
                result += 'RF module chip fault.';
            }

            if (SelfTestResult.DECTResult.indexOf("Failed") >= 0) {
                result += 'DECT chip fault';
            }

            return result;
        }

        function EquipTestResult() {
            var PrifixStr = 'Detection Result:';
            LinkResult = ParseLinkTestResult(EquipTestResultInfo.LinkTestResult);
            EquipFinalStr = ParseSelfTestResult(EquipTestResultInfo, PhyResult) + LinkResult;

            if (EquipFinalStr == "") {
                ShowStr = PrifixStr + 'Hardware is functioning properly.';
            } else {
                ShowStr = PrifixStr + EquipFinalStr + "!";
                ShowStr = ShowStr.replace("；!", "");
            }

            if (LinkResult.indexOf("NoCheck") >= 0) {
                ShowStr = "";
            }

            EquipShowStr = ShowStr;
            return ShowStr;
        }

        function GetEquipInfo() {
            PhyResult[0] = EquipTestResultInfo.Port1Result;
            PhyResult[1] = EquipTestResultInfo.Port2Result;
            PhyResult[2] = EquipTestResultInfo.Port3Result;
            PhyResult[3] = EquipTestResultInfo.Port4Result;
            PhyResult[4] = EquipTestResultInfo.Port5Result;
            PhyResult[5] = EquipTestResultInfo.Port6Result;
        }

        function GetEquipTestResult() {
            $.ajax({
                type: "POST",
                async: true,
                cache: false,
                url: "/asp/getHardwareDetectionResult.asp",
                success: function (data) {
                    EquipTestResultInfo = eval(data);
                    GetEquipInfo();
                    EquipTestResult();
                },
                complete: function (XHR, TS) {
                    XHR = null;
                }
            });
        }

        function SetFlag(flag,value)
        {
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                data: '&x.portid=' + lanid + '&RUNSTATE_FLAG.value=' + CLICK_START_FLAG,
                url: 'DiagnoseEntrance.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck&RUNSTATE_FLAG=' + EQUIPTEST_FLAG + '&RequestFile=/diagnosis_clarodr.asp',
                success: function (data) {
                }
            });
        }

        function Ondiagresult() {
            GetEquipTestResult();
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: "/asp/getStatus.asp",
                success: function (data) {
                    EquipTestClickFlag = data;
                }
            });

            if (EquipTestClickFlag == "None") {
                SetFlag(EQUIPTEST_FLAG, CLICK_START_FLAG);
            } else {
                if (CLICK_START_FLAG == EquipTestClickFlag) {
                    if (EquipShowStr == "") {
                        EquipTestClickFlag = CLICK_START_FLAG;
                        SetFlag(EQUIPTEST_FLAG, CLICK_START_FLAG);
                    } else {
                        EquipTestClickFlag = CLICK_TERMINAL_FLAG;
                        SetFlag(EQUIPTEST_FLAG, CLICK_TERMINAL_FLAG);
                    }
                }

                if (CLICK_TERMINAL_FLAG == EquipTestClickFlag) {
                    clearInterval(TimerHandle);
                    setwifiStatus();
                    setponStatus();
                    setHardwareStatus();
                    setDisplay('resultID', 1);
                    if (DoubleFreqFlag === "1") {
                        setDisplay("wlan5GResult", 1);
                    } else {
                        document.getElementById("title_2Status").innerHTML = "WiFi Status";
                        setDisplay("wlan5GResult", 0);

                    }

                    document.getElementById("btndiagnose").disabled = "";
                }
            }
        }

        function OnEquipCheck() {
            EquipShowStr = '';
            var EquipTestClickFlag = CLICK_START_FLAG;
            EquipTestResultInfo = GetEquipTestResultInfo();
            GetEquipInfo();

            if (EquipTestResultInfo.SD5113Result.indexOf("OK") >= 0) {
                for (i = 0; i < 6; i++) {
                    if (PhyResult[i].indexOf("OK") >= 0) {
                        lanid += "" + (i + 1);
                    }
                }
            }

            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                data: '&x.portid=' + lanid + '&RUNSTATE_FLAG.value=' + CLICK_START_FLAG,
                url: 'DiagnoseEntrance.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck&RUNSTATE_FLAG=' + EQUIPTEST_FLAG + '&RequestFile=/diagnosis_clarodr.asp',
                success: function (data) {
                }
            });
        }

        function initDiagnoseData() {
            WlanInfo = diagnoseAllResult.WlanInfo;
            allLedState1 = diagnoseAllResult.allLedState1;
            allLedState2 = diagnoseAllResult.allLedState2;
            ontInfos = diagnoseAllResult.ontInfos;
            radioEnable1 = diagnoseAllResult.radioEnable1;
            radioEnable2 = diagnoseAllResult.radioEnable2;
            wlanArr = diagnoseAllResult.wlanArr;
            wlanEnbl = diagnoseAllResult.wlanEnbl;
        }

        function onbtndiagnose() {
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: "/asp/getDiagnoseResult_DR.asp",
                success: function (data) {
                    diagnoseAllResult = eval(data);
                }
            });

            initDiagnoseData();
            ontInfo = ontInfos[0];
            if (portNum == 1) {
                var allLedState = allLedState1;
            } else if (portNum == 2) {
                var allLedState = allLedState2;
            }

            if (allLedState != null) {
                ledStr = allLedState.split("|");
            }

            document.getElementById("btndiagnose").disabled = true;
            GetWanListInfo();
            DiagnosticIpv4Info(WanListInfo);
            DiagnosticIpv6Info(WanListInfo);
            
            setDisplay('resultID', 0);
            $("#ledState").empty();
            for (var i = 0; i < ledStr.length - 1; i++) {
                $("#ledState").append('<td class="head_title">' + ledStr[i] + '</td>');
            }
            $("#ipv4All").empty();
            $("#ipv4All").append('<tr><td class="head_title" align="center">WAN Name</td><td class="head_title" align="center">Status</td><td class="head_title" align="center">IP Address</td><td class="head_title" align="center">Ping Test</td><td class="head_title" align="center">Diagnose Result</td></tr>');
            $("#ipv6All").empty();
            $("#ipv6All").append('<tr><td class="head_title" align="center">WAN Name</td><td class="head_title" align="center">Status</td><td class="head_title" align="center">IP Address</td><td class="head_title" align="center">Ping Test</td><td class="head_title" align="center">Diagnose Result</td></tr>');
            $("#ipv4All").append(v4Html);
            $("#ipv6All").append(v6Html);

            OnEquipCheck();
            TimerHandle = setInterval('Ondiagresult()', 5000);
        }

function PingResultClass(domain, FailureCount, SuccessCount, DiagnosticsState)
{
    this.domain = domain;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
    this.DiagnosticsState = DiagnosticsState;
}

var PingResult = new PingResultClass("InternetGatewayDevice.IPPingDiagnostics","0","0", "");
var TimerHandlePing = null;
var wanIndex = "";
var WanListInfo;
var Ipv6WanListInfo;
var Ipv6AddressListInfo;
var v4Html = "";
var v6Html = "";
function GetPingStatus(flag)
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "/asp/getPingResult.asp",
        success : function(data) {
            PingResult = eval(data);
            if ((PingResult.DiagnosticsState != "") && (PingResult.DiagnosticsState != "Requested")) {
                clearInterval(TimerHandlePing);
                EnableBtn();
                var resultHtml = (PingResult.SuccessCount == 1) ?  "Success" : "Fail";
                if (flag == 0) {
                    document.getElementById('ipv4pingresult_' + wanIndex).innerHTML = resultHtml;
                } else {
                    document.getElementById('ipv6pingresult_' + wanIndex).innerHTML = resultHtml;
                }
            }
        }
    });
}

function DiagnosticIpv4Info(waninfo)
{
    v4Html = "";
    var WanCount = 0;
    for (var i = 0; i < waninfo.length; i++) {
        var CurrentWan = waninfo[i];
        if (CurrentWan.IPv4Enable != "1") {
            continue;
        }
        WanCount ++;
		v4Html += '<TR id="record_' + i + '" align="center">';
		v4Html += '<td class="table_title">'+ htmlencode(CurrentWan.Name) + '</td>';

        if (CurrentWan.ConnectionStatus.toUpperCase() == "UNCONFIGURED") {
			v4Html += '<td class=\"table_title\" id=\"ipv4status_' + i + '\">'+'Disconnected'+'</td>';
        } else {
			v4Html += '<td class=\"table_title\" id=\"ipv4status_' + i + '\">'+CurrentWan.ConnectionStatus+'</td>';
        }

        var AddressHtml = "";
        if ((CurrentWan.ConnectionStatus == 'Connected') && (CurrentWan.IPv4IPAddress != '') && (CurrentWan.Mode == 'IP_Routed')) {
            AddressHtml = CurrentWan.IPv4IPAddress;
        }

		v4Html += '<td class=\"table_title\" id=\"ipv4address_' + i + '\">'+ ((AddressHtml == "") ? "--" : AddressHtml) + '</td>';
        if (CurrentWan.Mode == 'IP_Routed') {
			v4Html += "<td class=\"table_title\"><input type=\"button\"  id='btnIpv4_" + i + "' onclick='OnClickStartPing(0, " + i + ")' style=\"width:50px;height:30px;\" value=\"ping\"> </td>";
        } else {
			v4Html += "<td class=\"table_title\">--</td>"
        }
        var resultHtml = "";
		v4Html += '<td class=\"table_title\" id=\"ipv4pingresult_' + i + '\">'+ ((resultHtml == "") ? "--" : resultHtml) + '</td>';
		v4Html += '</tr>';
    }

    if (WanCount == 0) {
		v4Html += '<tr>';
		v4Html += '<td class=\"table_title\">'+'--'+'</td>';
		v4Html += '<td class=\"table_title\">'+'--'+'</td>';
		v4Html += '<td class=\"table_title\">'+'--'+'</td>';
		v4Html += '<td class=\"table_title\">'+'--'+'</td>';
		v4Html += '<td class=\"table_title\">'+'--'+'</td>';
		v4Html += '<tr>';
    }
}

function GetIPv6WanInfo(WanInstanceId)
{
    GetIpv6Info();
    for (var i = 0; i < Ipv6WanListInfo.length; i++) {
        if (Ipv6WanListInfo[i] != null) {
            if (Ipv6WanListInfo[i].WanInstanceId == WanInstanceId) {
                return Ipv6WanListInfo[i];
            }
        }
    }
}

function GetIPv6AddressList(WanInstanceId)
{
    GetIpv6Address();
    var List = new Array();
    var Count = 0;
    
    for (var i = 0; i < Ipv6AddressListInfo.length; i++) {
        if (Ipv6AddressListInfo[i] == null)
            continue;

        if (Ipv6AddressListInfo[i].WanInstanceId != WanInstanceId)
            continue;

        List[Count++] = Ipv6AddressListInfo[i];
    }
    return List;
}

function DiagnosticIpv6Info(waninfo)
{
    v6Html = "";
    var WanCount = 0;
    for (var i = 0; i < waninfo.length; i++) {
            var CurrentWan = waninfo[i];
            if (CurrentWan.IPv6Enable != "1") {
                continue;
            }
            WanCount ++;
            v6Html += '<TR id="record_' + i + '" align="center">';
            v6Html += '<td class="table_title">'+ htmlencode(CurrentWan.Name) + '</td>';
            var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
            CurrentWan.ConnectionStatus = ipv6Wan.ConnectionStatus;
            if (CurrentWan.ConnectionStatus.toUpperCase() == "UNCONFIGURED") {
                v6Html += '<td class=\"table_title\" id=\"ipv6status_' + i + '\">'+'Disconnected'+'</td>';
            } else {
                v6Html += '<td class=\"table_title\" id=\"ipv6status_' + i + '\">'+CurrentWan.ConnectionStatus+'</td>';
            }

            var AddressHtml = "";
            var AddressList = GetIPv6AddressList(CurrentWan.MacId);
            for (var m = 0; m < AddressList.length; m++) {
                if (CurrentWan.Enable == "1") {
                    AddressHtml += AddressList[m].IPAddress + "<br>";
                }
            }

            v6Html += '<td class=\"table_title\" id=\"ipv6address_' + i + '\">'+ ((AddressHtml == "") ? "--" : AddressHtml) + '</td>';

            if (CurrentWan.Mode == 'IP_Routed') {
                v6Html += "<td class=\"table_title\"><input type=\"button\" id='btnIpv6_" + i + "' onclick='OnClickStartPing(1, " + i + ")' style=\"width:50px;height:30px;\" value=\"ping\"> </td>";
            } else {
                v6Html += "<td class=\"table_title\">--</td>";
            }

            var resultHtml = "";
            v6Html += '<td class=\"table_title\" id=\"ipv6pingresult_' + i + '\">'+ ((resultHtml == "") ? "--" : resultHtml) + '</td>';
            v6Html += '</tr>';
        }

            if (WanCount == 0) {
                v6Html += "<tr>";
                v6Html += '<td class=\"table_title\">'+'--'+'</td>';
                v6Html += '<td class=\"table_title\">'+'--'+'</td>';
                v6Html += '<td class=\"table_title\">'+'--'+'</td>';
                v6Html += '<td class=\"table_title\">'+'--'+'</td>';
                v6Html += '<td class=\"table_title\">'+'--'+'</td>';
                v6Html += "</tr>";
            }
}

function GetWanListInfo()
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "/asp/getDiagnoseWanInfo.asp",
        success : function(data) {
            WanListInfo = eval(data);
        },
        complete: function (XHR, TS) { 
            XHR = null;
        }
    });
}

function GetIpv6Info()
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "/asp/getIpv6WanInfo.asp",
        success : function(data) {
        Ipv6WanListInfo = eval(data);
        }
    });
}

function GetIpv6Address()
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "/asp/getIpv6AddressList.asp",
        success : function(data) {
        Ipv6AddressListInfo = eval(data);
        }
    });
}

function DisableBtn()
{
    for (var i = 0; i < WanListInfo.length; i++) {
        if (WanListInfo[i].IPv4Enable == "1") {
            setDisable("btnIpv4_" + i , 1);
        }
        if (WanListInfo[i].IPv6Enable == "1") {
            setDisable("btnIpv6_" + i , 1);
        }
    }
}

function EnableBtn()
{
    for (var i = 0; i < WanListInfo.length; i++) {
        if (WanListInfo[i].IPv4Enable == "1") {
            setDisable("btnIpv4_" + i , 0);
        }
        if (WanListInfo[i].IPv6Enable == "1") {
            setDisable("btnIpv6_" + i , 0);
        }
    }
}

function IsExistIPv6WAN()
{
    GetWanListInfo();
    var IPv6WanCount = 0;
    for (var i = 0; i < WanListInfo.length; i++) {
        if (WanListInfo[i].IPv6Enable != "1") {
            continue;
        }
        IPv6WanCount++;
    }
    return (IPv6WanCount > 0) ? true : false;
}

function OnClickStartPing(flag,index)
{
    wanIndex = index;
    GetWanListInfo();
    var specifyWan = WanListInfo[index];
    if (flag == 0) {
        document.getElementById('ipv4pingresult_' + wanIndex).innerHTML = "--";	
    } else {
        document.getElementById('ipv6pingresult_' + wanIndex).innerHTML = "--";
        var ipv6Wan = GetIPv6WanInfo(specifyWan.MacId);
        specifyWan.IPv4Gateway = ipv6Wan.DefaultRouterAddress;
    }

    DisableBtn();
    var PingData = "";
    PingData = "x.Interface=" + specifyWan.domain;
    var xhost = (specifyWan.IPv4Gateway == "") ? "0.0.0.0":specifyWan.IPv4Gateway;
    PingData += "&x.Host=" + xhost;
    PingData += "&x.DiagnosticsState=Requested";
    PingData += "&x.NumberOfRepetitions=1";
    PingData += "&x.Timeout=100000";
    PingData += "&x.DataBlockSize=56";

    PingResult.SuccessCount = 0;
    PingResult.FailureCount = 0;
    PingResult.DiagnosticsState = "";

    $.ajax({
        type : "POST",
        async : true,
        cache : false,
        data : PingData,
        url : "ping.cgi?x=InternetGatewayDevice.IPPingDiagnostics",
        success : function(data) {
        }
    });

    TimerHandlePing = setInterval('GetPingStatus(' + flag + ')', 1000);
}

function LoadFrame()
{
    setDisplay('resultID', 0);
    document.getElementById("redirectToLogin").href = "http://" + br0Ip + ':' + httpport + "/login.asp";
    if (IsExistIPv6WAN() == false) {
        setDisplay('ipv6Info', 0);
    }
}
    </script>
    <style>
        .mainbody {
            background-color: #F5F9FD;
            margin-left: 50px;
            margin-right: 50px;
            margin-top: 24px;
            list-style: none;
        }

        .bluebutton {
            border: #56B2F8 1px solid;
            background-color: #56B2F8;
            -mox-border-radius: 4px;
            -webkit-border-radius: 4px;
            border-radius: 4px;
            color: #FFFFFF;
            font-size: 16px;
            font-family: "微软雅黑";
            margin-left: 537px;
            margin-top: 36px;
        }

        .bluebutton1 {
            border: #56B2F8 1px solid;
            background-color: #56B2F8;
            -mox-border-radius: 4px;
            -webkit-border-radius: 4px;
            border-radius: 4px;
            color: #FFFFFF;
            font-size: 16px;
            font-family: "微软雅黑";
            margin-left: 8px;
            width: 80px;
            position: absolute;
            top: 10px;
            left: 1069px;
        }

        .PageTitle_content {
            padding: 5px 0px;
            font-family: "Tohama", "Arial", "宋体";
            font-size: 12px;
            color: #5c5d55;
            padding-left: 115px;
            margin-top: 40px;
            width: 757px;
        }

        #ledtitle {
            margin-top: 34px;
            margin-left: 118px;
        }

        .btndiagnoseDivStyle {
            margin-left: 518px;
            margin-top: 20px;
        }
    </style>
</head>

<body class="mainbody" onload="LoadFrame();">
    <div class=""><a id="redirectToLogin" style="color:#56B2F8;text-decoration: underline;margin-left: 1027px;" href="">loginPage</a></div>


    <div id="DCpingtitle_content" class="PageTitle_content" style="font-size: 14px;">
        Network connection interrupted, Please perform one-click diagnosis!
    </div>
    <div id="btndiagnoseDiv" class="btndiagnoseDivStyle">
        <input type="button" id="btndiagnose" class="bluebuttonBlueBgcss"  style="font-size: 20px;" onclick="onbtndiagnose();" value="One-Click Diagnosis" />
    </div>

    <div id="resultID" style="display: none;">
        <div id="ledtitle">Status of LEDs</div>
        <div style="margin-left: 117px;">
            <table id="leddiagnostic" width="60%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"
                style="table-layout:fixed; word-break:break-all">
                <tr class="">
                    <td class="head_title">PON <br> (green)</td>
                    <td class="head_title">LOS <br> (red)</td>
                    <td class="head_title">LAN1 <br> (green)</td>
                    <td class="head_title">LAN2 <br> (green)</td>
                    <td class="head_title">LAN3 <br> (green)</td>
                    <td class="head_title">LAN4 <br> (green)</td>
                    <script>
                        if (portNum == 1) {
                            document.write('<td class="head_title">TEL <br> (green)</td>');
                        } else if (portNum == 2) {
                            document.write('<td class="head_title">TEL1 <br> (green)</td>');
                            document.write('<td class="head_title">TEL2 <br> (green)</td>');
                        }
                    </script>
                    <td class="head_title">USB <br> (green)</td>
                    <td class="head_title">WLAN <br> (green)</td>
                    <td class="head_title">WPS <br> (green)</td>
                </tr>

                <tr id="ledState" class="">
                </tr>
            </table>
            <div id="wandiagnostics">
                <div style="margin-top: 20px;" BindText="mainpage100"></div>
                <table id="ipv4All" width="60%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"
                    style="table-layout:fixed; word-break:break-all">
                    <tr>
                        <td class="head_title" align="center" BindText="mainpage101"></td>
                        <td class="head_title" align="center" BindText="mainpage102"></td>
                        <td class="head_title" align="center" BindText="mainpage103"></td>
                        <td class="head_title" align="center" BindText="mainpage104"></td>
                        <td class="head_title" align="center" BindText="mainpage105"></td>
                    </tr>
                    <script>
                        GetWanListInfo();
                        DiagnosticIpv4Info(WanListInfo);
                    </script>
                </table>
                <div id="ipv6Info">
                    <div style="margin-top: 20px;" BindText="mainpage106"></div>
                    <table width="60%" id="ipv6All" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"
                        style="table-layout:fixed; word-break:break-all">
                        <tr>
                            <td class="head_title" align="center" BindText="mainpage101"></td>
                            <td class="head_title" align="center" BindText="mainpage102"></td>
                            <td class="head_title" align="center" BindText="mainpage103"></td>
                            <td class="head_title" align="center" BindText="mainpage104"></td>
                            <td class="head_title" align="center" BindText="mainpage105"></td>
                        </tr>
                        <script>
                            DiagnosticIpv6Info(WanListInfo);
                        </script>
                    </table>
                </div>
            </div>
            <div style="margin-top: 20px;"></div>
            <div>Other Fault Detection</div>
            <table id="otherdiagnostic" width="60%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"
                style="table-layout:fixed; word-break:break-all">
                    <tr class="">
                        <td class="head_title" id="">Status of internal circuits</td>
                        <td class="table_title" id="hardwareDetectionResult">Hardware Detection</td>
                    </tr>
                    
                    <tr class="">
                        <td class="head_title" id="title_2Status">2.4G WiFi Status</td>
                        <td class="table_title" id="wifiStatusResult2_enable">2.4G Enable</td>
                    </tr>

                    <tr class="">
                        <td class="head_title" id="">2.4G WiFi Mode</td>
                        <td class="table_title" id="wifiStatusResult2_mode">Mode</td>
                    </tr>

                    <tr id="wlan5GResult" >
                        <td class="head_title" id="title_5Status">5G WiFi Status</td>
                        <td class="table_title" id="wifiStatusResult5_enable">5G enable</td>
                    </tr>
                    <tr id="wlan5GModeResult">
                        <td class="head_title" id="">5G WiFi Mode</td>
                        <td class="table_title" id="wifiStatusResult5_mode">Mode</td>
                    </tr>

                    <tr>
                        <td class="head_title" id="">Status of PON link</td>
                        <td class="table_title" id="ponLinkResult">O1</td>
                    </tr>
            </table>
        </div>
    </div>
    </div>
    <script>
    ParseBindTextByTagName(framedesinfo, "td", 1);
    ParseBindTextByTagName(framedesinfo, "div", 1);
    ParseBindTextByTagName(framedesinfo, "input", 2);
    </script>
</body>

</html>

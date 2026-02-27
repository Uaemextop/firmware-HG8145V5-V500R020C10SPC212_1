<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"/>
<link rel="stylesheet" type="text/css" href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>" />
<link rel="stylesheet" type="text/css" href="/Cuscss/<%HW_WEB_GetCusSource(mainpage_new.css);%>" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(indexclick.css);%>' type='text/css'>
<link href="/Cuscss/<%HW_WEB_GetCusSource(bootstrap.min.css);%>"  media="all" rel="stylesheet" />
<script language="javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='/Cusjs/<%HW_WEB_CleanCache_Resource(InitFormCus.js);%>'></script>
<script language="javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(bootstrap.min.js);%>"></script>
<script language="javascript" src="/html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list.asp"></script>
<script language="javascript" src="/html/bbsp/common/GetLanUserDevInfo.asp"></script>
<script language="javascript" src="/html/bbsp/common/lanuserinfo.asp"></script>
<script language="javascript" src="/html/bbsp/common/wanipv6state.asp"></script>
<script language="javascript" src="/html/amp/common/wlan_list.asp"></script>
<script language="javascript" src="/html/amp/common/wlan_extended.asp"></script>
<script language="javascript" src="/Cusjs/<%HW_WEB_CleanCache_Resource(mainpagesrc_new.asp);%>"></script>

<script language="JavaScript" src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript">
function stDeviceInfo(domain,SerialNumber,HardwareVersion,SoftwareVersion,ModelName,VendorID,ReleaseTime,Mac,Description,ManufactureInfo,DeviceAlias) {
    this.domain                = domain;
    this.SerialNumber          = SerialNumber;
    this.HardwareVersion       = HardwareVersion;
    this.SoftwareVersion       = SoftwareVersion;
    this.ModelName             = ModelName;
    this.VendorID              = VendorID;
    this.ReleaseTime           = ReleaseTime;
    this.Mac                   = Mac;
    this.Description           = Description;
    this.ManufactureInfo       = ManufactureInfo;
    this.DeviceAlias           = DeviceAlias;
}

var wlan2g;
var wlan5g;

var wanList = GetWanList();
var wanLists = [];
var connectWanLists = [];
var ipv6Wan = {};
var AddressHtml = "";
var PriDNSServers = "";
var SecDNSServers = "";



var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufactureInfo|X_HW_DeviceAlias, stDeviceInfo);%>;
var deviceInfo = deviceInfos[0];
var SingtelMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SINGTEL);%>';

var showCPUnMemUsed = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_SHOWCPUMEM);%>';
var cpuUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_CpuUsed);FT=HW_SSMP_FEATURE_SHOWCPUMEM&USER=15%>%';
var memUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_MemUsed);FT=HW_SSMP_FEATURE_SHOWCPUMEM&USER=15%>%';
var MainPageToken = "<%HW_WEB_GetToken();%>";
var PING_FLAG="Ping";
var EQUIPTEST_FLAG="EquipTest";
var PING_FLAG="Ping";
var TRACEROUTE_FLAG="Traceroute";
var NSLOOKUP_FLAG="Nslookup";
var splitobj = "[@#@]";
var TimerHandlePing;

var CLICK_INIT_FLAG="None";
var CLICK_START_FLAG="START";
var CLICK_TERMINAL_FLAG="TERMIANL";

var STATE_INIT_FLAG="None";
var STATE_DOING_FLAG="Doing";
var STATE_DONE_FLAG="Done";
var PingClickFlag= "<%HW_WEB_GetRunState("Ping");%>";
var TracerouteClickFlag= "<%HW_WEB_GetRunState("Traceroute");%>";
var EquipTestClickFlag= "<%HW_WEB_GetRunState("EquipTest");%>";
var NslookupClickFlag= "<%HW_WEB_GetRunState("Nslookup");%>";

var PingState=STATE_INIT_FLAG;
var TraceRouteState=STATE_INIT_FLAG;
var EquipCheckState=STATE_INIT_FLAG;
var NslookupState=STATE_INIT_FLAG;
var isPingSuccess = false;
var UpUserPortID = '<%HW_WEB_GetCurUpUserPortID();%>';
var SystemTime = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.UpTime);%>';

function changeTime(time)
{
    var days = 0;
    var hours = 0;
    var minutes = 0;
    var seconds = 0;

    seconds = time%60;
    minutes = Math.floor(time/60);
    hours  = Math.floor(minutes/60);
    minutes = minutes%60;
    days = Math.floor(hours/24);
    hours = hours%24;
    if (hours < 10) {
        hours = "0" + hours;
    }
    if (minutes < 10) {
        minutes = "0" + minutes;
    }
    if (seconds < 10) {
        seconds = "0" + seconds;
    }
    time = days + " days " + hours + ":" + minutes + ":" + seconds;
    return time;
}

function parseSystemTime()
{
    SystemTime = changeTime(SystemTime);
    document.getElementById('DI_p_right_systime').innerHTML = htmlencode(SystemTime);
}

function parseWANTime()
{
    var wanUpTime = 0;

    if (wanList.length != 0) {
        for(var i = 0; i < wanList.length; i++) {
            if (wanList[i].ServiceList.indexOf("INTERNET") != -1) {
                wanUpTime = wanList[i].Uptime;
                break;
            }
        }
    }
    wanUpTime = changeTime(wanUpTime);
    document.getElementById('DI_p_right_wantime').innerHTML = htmlencode(wanUpTime);
}

function loadframe() {
    setDisable("btn5",1);
    setDisable("btn2",1);
    setDisable("btn3",1);

    document.getElementById('DI_p_right_1').innerHTML = htmlencode(deviceInfo.ModelName) + "-AIS";
    document.getElementById('DI_p_right_2').innerHTML = htmlencode(deviceInfo.Mac);
    document.getElementById('DI_p_right_3').innerHTML = htmlencode(deviceInfo.HardwareVersion);
    document.getElementById('DI_p_right_4').innerHTML = htmlencode(deviceInfo.SoftwareVersion);
    setData();
    SetDeviceNum();  
    GetDevInfo();
    setISData();
    OnApply();
    parseSystemTime();
    parseWANTime();

    if (UpUserPortID == 1) {
        document.getElementById("ED_div_pross_LAN1").style.display = "none";
    } else if (UpUserPortID == 2) {
        document.getElementById("ED_div_pross_LAN2").style.display = "none";
    } else if (UpUserPortID == 3) {
        document.getElementById("ED_div_pross_LAN3").style.display = "none";
    } else if (UpUserPortID == 4) {
        document.getElementById("ED_div_pross_LAN4").style.display = "none";
    }

    LoadWlanSsidEnable();
}

function GetPingResult() {
    var PingContent="";
    $.ajax({
        type : "POST",
        async : true,
        cache : false,
        url : "../html/bbsp/maintenance/GetPingResult.asp",
        success : function(data) {     
            if ((data.length > 8) && ('\\n" + ' == data.substr(2,6))) {
                data = data.substr(8);
            }
            var PingContent = eval(data);
            ParsePingResult(PingContent);
            setData();
        },
        complete: function (XHR, TS) { 
            PingContent=null;            
            XHR = null;
        }
    });
}

function GetPingAllResult() {
    GetPingResult();   
    
    if (TimerHandlePing != undefined) {
        clearInterval(TimerHandlePing);
        setDisable("btn5",0);
    }
    if (TimerHandlePing == undefined) {            
        TimerHandlePing = setInterval("GetPingAllResult()", 4000);
    }
}

function setData() {
    if (wanList.length !== 0) {
        for(var i = 0; i < wanList.length; i++) {
            if (wanList[i].ServiceList.indexOf("INTERNET") != -1) {
                wanLists.push(wanList[i]);
            }
        }

        if (wanLists.length != 0) {
            var CurrentWan = wanLists[0];
            if (CurrentWan.IPv6Enable == "1") {
                var AddressList = GetIPv6AddressList(CurrentWan.MacId);
                ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
                for (var m = 0; m < AddressList.length; m++) {
                     if (AddressList[m].Origin != "LinkLocal") {
                         AddressHtml = AddressList[m].IPAddress;
                     }     
                }

                if (ipv6Wan.DNSServers != "") {
                    if(ipv6Wan.DNSServers.indexOf(",") >= 0) {
                        PriDNSServers = ipv6Wan.DNSServers.split(",")[0];
                        SecDNSServers = ipv6Wan.DNSServers.split(",")[1];
                    } else {
                        PriDNSServers = ipv6Wan.DNSServers;
                        SecDNSServers = "";
                    }
                }
            }
            if (wanLists[0].Status == "Connected" || ipv6Wan.ConnectionStatus == "Connected") {
                connectWanLists.push(wanLists[0]);
            }
        }

        if (connectWanLists.length !== 0) {
            if (connectWanLists[0].ProtocolType.indexOf("IPv4") !== -1) {
                document.getElementById('ED_right_1').innerHTML = connectWanLists[0].IPv4IPAddress;
                document.getElementById('ED_right_2').innerHTML = connectWanLists[0].IPv4PrimaryDNS;
                document.getElementById('ED_right_3').innerHTML = connectWanLists[0].IPv4SecondaryDNS;
                document.getElementById('IPAddress').value = connectWanLists[0].IPv4Gateway;
                document.getElementById('WanNameList').value = connectWanLists[0].domain;
                document.getElementById("ED_right_Ping").innerHTML = connectWanLists[0].IPv4Gateway;
            } else if (connectWanLists[0].ProtocolType == "IPv6") {
                document.getElementById('ED_right_1').innerHTML = AddressHtml;
                document.getElementById('ED_right_2').innerHTML = PriDNSServers;
                document.getElementById('ED_right_3').innerHTML = SecDNSServers;
                document.getElementById('IPAddress').value = ipv6Wan.DefaultRouterAddress;
                document.getElementById('WanNameList').value = connectWanLists[0].domain;
                document.getElementById("ED_right_Ping").innerHTML = ipv6Wan.DefaultRouterAddress;
            } else {
                document.getElementById('ED_right_1').innerHTML = "";
                document.getElementById('ED_right_2').innerHTML = "";
                document.getElementById('ED_right_3').innerHTML = "";
                document.getElementById('IPAddress').value = "";
                document.getElementById('WanNameList').value = "";
                document.getElementById("ED_right_Ping").innerHTML = "";
            }
        } else {
                document.getElementById('ED_right_1').innerHTML = "";
                document.getElementById('ED_right_2').innerHTML = "";
                document.getElementById('ED_right_3').innerHTML = "";
                document.getElementById('IPAddress').value = "";
                document.getElementById('WanNameList').value = "";
                document.getElementById("ED_right_Ping").innerHTML = "";
            }
    } else {
        document.getElementById('ED_right_1').innerHTML = "";
        document.getElementById('ED_right_2').innerHTML = "";
        document.getElementById('ED_right_3').innerHTML = "";
        document.getElementById('IPAddress').value = "";
        document.getElementById('WanNameList').value = "";
        document.getElementById("ED_right_Ping").innerHTML = "";
    }

    if (connectWanLists.length !== 0) {
        if (connectWanLists[0].ProtocolType.indexOf("IPv4") !== -1) {
            if (connectWanLists[0].IPv4IPAddress !== "") {
                document.getElementById("progress-bar3").style.width = "100%";
                $("#ED_p_pross3").removeClass("ED_isRight1");
                $("#ED_p_pross3").addClass("ED_isRight");
            } else {
                document.getElementById("progress-bar3").style.width = "0%";
                $("#ED_p_pross3").removeClass("ED_isRight");
                $("#ED_p_pross3").addClass("ED_isRight1");
            }
            
            if (connectWanLists[0].IPv4PrimaryDNS !== "" || connectWanLists[0].IPv4SecondaryDNS !== "") {
                document.getElementById("progress-bar4").style.width = "100%";
                $("#ED_p_pross4").removeClass("ED_isRight1");
                $("#ED_p_pross4").addClass("ED_isRight");
            } else {
                document.getElementById("progress-bar4").style.width = "0%";
                $("#ED_p_pross4").removeClass("ED_isRight");
                $("#ED_p_pross4").addClass("ED_isRight1");
            }
        } else if (connectWanLists[0].ProtocolType == "IPv6") {
            if (AddressHtml !== "") {
                document.getElementById("progress-bar3").style.width = "100%";
                $("#ED_p_pross3").removeClass("ED_isRight1");
                $("#ED_p_pross3").addClass("ED_isRight");
            } else {
                document.getElementById("progress-bar3").style.width = "0%";
                $("#ED_p_pross3").removeClass("ED_isRight");
                $("#ED_p_pross3").addClass("ED_isRight1");
            }
            
            if (PriDNSServers !== "" || SecDNSServers !== "") {
                document.getElementById("progress-bar4").style.width = "100%";
                $("#ED_p_pross4").removeClass("ED_isRight1");
                $("#ED_p_pross4").addClass("ED_isRight");
            } else {
                document.getElementById("progress-bar4").style.width = "0%";
                $("#ED_p_pross4").removeClass("ED_isRight");
                $("#ED_p_pross4").addClass("ED_isRight1");
            }
        } else {
                document.getElementById("progress-bar3").style.width = "0%";
                document.getElementById("progress-bar4").style.width = "0%";
                $("#ED_p_pross3").removeClass("ED_isRight");
                $("#ED_p_pross4").removeClass("ED_isRight");
                $("#ED_p_pross3").addClass("ED_isRight1");
                $("#ED_p_pross4").addClass("ED_isRight1");
            }
    } else {
        document.getElementById("progress-bar3").style.width = "0%";
        document.getElementById("progress-bar4").style.width = "0%";
        $("#ED_p_pross3").addClass("ED_isRight1");
        $("#ED_p_pross4").addClass("ED_isRight1");
    }
    if (isPingSuccess == true && $("#ED_right_Ping").html() !== "") {
        document.getElementById("progress-bar5").style.width = "100%";
        $("#ED_p_pross5").removeClass("ED_isRight1");
        $("#ED_p_pross5").addClass("ED_isRight");
    } else {
        document.getElementById("progress-bar5").style.width = "0%";
        $("#ED_p_pross5").removeClass("ED_isRight");
        $("#ED_p_pross5").addClass("ED_isRight1");
    }
        
    if ($("#LAN1").html() !== "") {
        document.getElementById("progress-bar6").style.width = "100%";
        $("#ED_p_pross6").removeClass("ED_isRight1");
        $("#ED_p_pross6").addClass("ED_isRight");
    } else {
        document.getElementById("progress-bar6").style.width = "0%";
        $("#ED_p_pross6").removeClass("ED_isRight");
        $("#ED_p_pross6").addClass("ED_isRight1");
    }    
            
    if ($("#LAN2").html() !== "") {
        document.getElementById("progress-bar7").style.width = "100%";
        $("#ED_p_pross7").removeClass("ED_isRight1");
        $("#ED_p_pross7").addClass("ED_isRight");
    } else {
        document.getElementById("progress-bar7").style.width = "0%";
        $("#ED_p_pross7").removeClass("ED_isRight");
        $("#ED_p_pross7").addClass("ED_isRight1");
    }
            
    if ($("#LAN3").html() !== "") {
        document.getElementById("progress-bar8").style.width = "100%";
        $("#ED_p_pross8").removeClass("ED_isRight1");
        $("#ED_p_pross8").addClass("ED_isRight");
    } else {
        document.getElementById("progress-bar8").style.width = "0%";
        $("#ED_p_pross8").removeClass("ED_isRight");
        $("#ED_p_pross8").addClass("ED_isRight1");
    }

    if ($("#LAN4").html() !== "") {
        document.getElementById("progress-bar9").style.width = "100%";
        $("#ED_p_pross9").removeClass("ED_isRight1");
        $("#ED_p_pross9").addClass("ED_isRight");
    } else {
        document.getElementById("progress-bar9").style.width = "0%";
        $("#ED_p_pross9").removeClass("ED_isRight");
        $("#ED_p_pross9").addClass("ED_isRight1");
    }
}

function ResetONT() {
    var Title = ResetLgeDes["s0601"];
    if(ConfirmEx(Title)) {
        var Form = new webSubmitForm();
        Form.setAction('set.cgi?x=' + 'InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
                                + '&RequestFile=../CustomApp/mainpage_new.asp');
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.submit();
    }
}

function Refresh2() {
    setDisable("btn2",1);
    SetDeviceNum();
}

function Refresh3() {
    wanList = [];
    wanLists = [];
    connectWanLists = [];
    setDisable("btn3",1);
    $.getScript("../html/bbsp/common/GetLanUserDevInfo.asp",setISData)
    $.getScript("../html/bbsp/common/wan_list.asp",function(){
        wanList = GetWanList();
        setISData();
    })
}

function Refresh5() {
    setDisable("btn5",1);
    document.getElementById('ED_right_1').innerHTML = "";
    document.getElementById('ED_right_2').innerHTML = "";
    document.getElementById('ED_right_3').innerHTML = "";
    document.getElementById("ED_right_Ping").innerHTML = "";
    
    document.getElementById("progress-bar3").style.width = "0%";
    document.getElementById("progress-bar4").style.width = "0%";
    document.getElementById("progress-bar5").style.width = "0%";
    document.getElementById("progress-bar6").style.width = "0%";
    document.getElementById("progress-bar7").style.width = "0%";
    document.getElementById("progress-bar8").style.width = "0%";
    document.getElementById("progress-bar9").style.width = "0%";
    
    $("#ED_p_pross3").addClass("ED_isRight1");
    $("#ED_p_pross4").addClass("ED_isRight1");
    $("#ED_p_pross5").addClass("ED_isRight1");
    $("#ED_p_pross6").addClass("ED_isRight1");
    $("#ED_p_pross7").addClass("ED_isRight1");
    $("#ED_p_pross8").addClass("ED_isRight1");
    $("#ED_p_pross9").addClass("ED_isRight1");
    wanList = [];
    wanLists = [];
    connectWanLists = [];
    
    GetDevInfo1();
    TimerHandlePing = undefined;
    isPingSuccess = false;
   
    $.getScript("../html/bbsp/common/GetLanUserDevInfo.asp",function(){
        GetDevInfo();
    })
    $.getScript("../html/bbsp/common/wan_list.asp",function(){
        wanList = GetWanList();
        setData();
         OnApply();
    })
}

function SetDeviceNum() {
    var EthDevNum = 0;
    var WifiDevNum = 0;
    GetLanUserInfo(function(para1, para2) {
        UserDevinfo = para2;
        var WifiDev = new Array();
        var EthDev = new Array();

        for (var i = 0; (null !=UserDevinfo && UserDevinfo.length > 0 && i < UserDevinfo.length-1); i++) {
            if (UserDevinfo[i].PortType.toUpperCase() == "ETH") {
                if ((UserDevinfo[i].DevStatus == "Offline")) {
                     continue;
                }
                EthDev[EthDevNum] = new USERDevice("","","","","","","","","","");
                EthDev[EthDevNum] = UserDevinfo[i];
                EthDevNum++;
            } else if (UserDevinfo[i].PortType.toUpperCase() == "WIFI") {
                if ((UserDevinfo[i].DevStatus == "Offline")) {
                     continue;
                }
                WifiDev[WifiDevNum] = new USERDevice("","","","","","","","","","");
                WifiDev[WifiDevNum] = UserDevinfo[i];
                WifiDevNum++;
            }
        }
            
        if (WifiDevNum + EthDevNum > 0) {
            document.getElementById('AD_text_span_1').innerHTML = WifiDevNum + EthDevNum;   
        } else {
            document.getElementById('AD_text_span_1').innerHTML = 0;
        }    
        setDisable("btn2",0);
    });
}

function setISData() {
 
    var EthDevNum = 0;
    var WifiDevNum = 0;
    GetLanUserInfo(function(para1, para2) {
        UserDevinfo = para2;
        var WifiDev = new Array();
        var EthDev = new Array();

        for (var i = 0; (null !=UserDevinfo && UserDevinfo.length > 0 && i < UserDevinfo.length-1); i++) {
            if (UserDevinfo[i].PortType.toUpperCase() == "ETH") {
                if ((UserDevinfo[i].DevStatus == "Offline")) {
                     continue;
                }
                EthDev[EthDevNum] = new USERDevice("","","","","","","","","","");
                EthDev[EthDevNum] = UserDevinfo[i];
                EthDevNum++;
            } else if (UserDevinfo[i].PortType.toUpperCase() == "WIFI") {
                if ((UserDevinfo[i].DevStatus == "Offline")) {
                     continue;
                }
                WifiDev[WifiDevNum] = new USERDevice("","","","","","","","","","");
                WifiDev[WifiDevNum] = UserDevinfo[i];
                WifiDevNum++;
            }
        }

        if (WifiDevNum + EthDevNum > 0) {
            $("#isRight").children().addClass("isRight");
        } else {
            $("#isRight").children().addClass("isWrong");
        }
        setDisable("btn3",0);
    });
    if (wanList.length !== 0) {
        for(var i = 0; i < wanList.length; i++) {
            if (wanList[i].ServiceList.indexOf("INTERNET") != -1) {
                wanLists.push(wanList[i]);
            }
        }
        if (wanLists.length != 0) {
            var CurrentWan = wanLists[0];
            if (CurrentWan.IPv6Enable == "1") {
                var AddressList = GetIPv6AddressList(CurrentWan.MacId);
                ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
                for (var m = 0; m < AddressList.length; m++) {
                     if (AddressList[m].Origin != "LinkLocal") {
                         AddressHtml = AddressList[m].IPAddress;
                     }     
                }

                if (ipv6Wan.DNSServers != "") {
                    if(ipv6Wan.DNSServers.indexOf(",") >= 0) {
                        PriDNSServers = ipv6Wan.DNSServers.split(",")[0];
                        SecDNSServers = ipv6Wan.DNSServers.split(",")[1];
                    } else {
                        PriDNSServers = ipv6Wan.DNSServers;
                        SecDNSServers = "";
                    }
                }
                if (wanLists[0].Status == "Connected" || ipv6Wan.ConnectionStatus == "Connected") {
                    connectWanLists.push(wanLists[0]);
                }
            }
        }

        if (connectWanLists.length !==0) {
            if (connectWanLists[0].ProtocolType.indexOf("IPv4") !== -1) {
                document.getElementById('AD_text_span_2').innerHTML = connectWanLists[0].IPv4IPAddress;
                document.getElementById('AD_text_span_3').innerHTML = connectWanLists[0].IPv4PrimaryDNS;
                $("#isWrong").children().removeClass("isWrong");
                $("#isWrong").children().addClass("isRight");
            } else if (connectWanLists[0].ProtocolType == "IPv6") {
                document.getElementById('AD_text_span_2').innerHTML = AddressHtml;
                document.getElementById('AD_text_span_3').innerHTML = PriDNSServers;
                $("#isWrong").children().removeClass("isWrong");
                $("#isWrong").children().addClass("isRight");
            } else {
                document.getElementById('AD_text_span_2').innerHTML = "";
                document.getElementById('AD_text_span_3').innerHTML = "";
                $("#isWrong").children().removeClass("isRight");
                $("#isWrong").children().addClass("isWrong");
            }
        } else {
            document.getElementById('AD_text_span_2').innerHTML = "";
            document.getElementById('AD_text_span_3').innerHTML = "";
            $("#isWrong").children().addClass("isWrong");
        }
        
    } else {
        document.getElementById('AD_text_span_2').innerHTML = "";
        document.getElementById('AD_text_span_3').innerHTML = "";
        $("#isWrong").children().addClass("isWrong");
    } 
}

function GetDevInfo() {
    EthDevNum = 0;
    EthDev = new Array();
    var UserDevices = GetUserDevInfoList();
    for (var i=0; UserDevices.length > 0 && i < UserDevices.length-1; i++) {
        if(UserDevices[i].PortType.toUpperCase() == "ETH") {
            EthDev[EthDevNum] = new USERDevice("","","","","","","","","","");
            EthDev[EthDevNum] = UserDevices[i];
            EthDevNum++;
        }
    }
    for (var j = 0;j < EthDev.length;j++) {
        var lanArr = ["LAN1","LAN2","LAN3","LAN4"];
        if (EthDev[j].DevStatus == "Online") {
            for (var m = 0;m < lanArr.length;m++) {
                if (EthDev[j].Port == lanArr[m]) {
                  document.getElementById(lanArr[m]).innerHTML = EthDev[j].IpAddr;
                }
            }    
        }
    }
}

function GetDevInfo1() {    
    EthDevNum = 0;
    EthDev = new Array();
    var UserDevices = GetUserDevInfoList();
    for (var i=0; UserDevices.length > 0 && i < UserDevices.length-1; i++) {
        if (UserDevices[i].PortType.toUpperCase() == "ETH") {
            EthDev[EthDevNum] = new USERDevice("","","","","","","","","","");
            EthDev[EthDevNum]    = UserDevices[i];
            EthDevNum++;    
        }
    }
    for (var j = 0;j < EthDev.length;j++) {
        var lanArr = ["LAN1","LAN2","LAN3","LAN4"];
        if (EthDev[j].DevStatus == "Online") {
            for (var m = 0;m < lanArr.length;m++) {
                if (EthDev[j].Port == lanArr[m]) {
                  document.getElementById(lanArr[m]).innerHTML = "";
                }
            }    
        }
    }
}

function USERDevice(Domain,IpAddr,MacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName) {
    this.Domain     = Domain;
    this.IpAddr        = IpAddr;
    this.MacAddr    = MacAddr;
    this.Port         = Port;
    this.PortType    = PortType;    
    this.DevStatus     = DevStatus;
    this.IpType        = IpType;
    this.Time        = Time;
}

function OnApply() {
    var SummitData = "";
    var IPAddress = getValue("IPAddress");
    var WanName = getValue("WanNameList");

    IPAddress = removeSpaceTrim(IPAddress);
    var DataBlockSize = getValue("DataBlockSize");
    DataBlockSize = removeSpaceTrim(DataBlockSize);
    
    var NumberOfRepetitions = getValue("NumOfRepetitions");
    NumberOfRepetitions = removeSpaceTrim(NumberOfRepetitions);

    var DSCP = getValue("DscpValue");
    DSCP = removeSpaceTrim(DSCP);

    var MaxTimeout = getValue("MaxTimeout");
    MaxTimeout = removeSpaceTrim(MaxTimeout);
    MaxTimeout = MaxTimeout*1000;
   
    if (WanName != "") {
       SummitData += "&x.Interface=" + WanName;
    }
    
    SummitData += "&x.Host=" + IPAddress;
    
    SummitData += "&x.DiagnosticsState=" + 'Requested';
    SummitData += "&x.NumberOfRepetitions=" + NumberOfRepetitions;
    if (DSCP != "" && false == IsSonetUser()) {
        SummitData += "&x.DSCP=" + DSCP;
    }
    SummitData += "&x.DataBlockSize=" + DataBlockSize;
    SummitData += "&x.Timeout=" + MaxTimeout;
    
    $.ajax({
            type : "POST",
            async : false,
            cache : false,
            data : "RUNSTATE_FLAG.value=" + CLICK_START_FLAG + SummitData +"&x.X_HW_Token="+getValue('onttoken'),
            url : 'complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=../CustomApp/mainpage_new.asp',
            success : function(data) {
            GetPingAllResult();
            },
            complete: function (XHR, TS) {
            XHR=null;
            }
        });
}

function ParsePingResult(pingString) {   
     var subString = pingString.split(splitobj);
     var result = "";
     var status = "";
     if (subString.length >= 2) {
         if ("\n" == subString[1]) {
            status = subString[0];
            substring=null;
            return;
        } else {
            status = subString[1];
            result = subString[0];
        }
     } else {
          substring=null;
          return ;  
     }
     if (status.indexOf("Requested") >= 0) {
         if (CLICK_START_FLAG == PingClickFlag) {
            PingState=STATE_DOING_FLAG;
         } else if(CLICK_INIT_FLAG == PingClickFlag) {
            PingState=STATE_INIT_FLAG;
         }         
     } else if(status.indexOf("Complete_Err") >= 0) {
            isPingSuccess = false;
            PingState=STATE_DONE_FLAG;
            var errResult = "";
            errResult += + result;
            getElement("PingResultArea").value = errResult;
     } else if(status.indexOf("Complete") >= 0) {
            isPingSuccess = true;
            PingState=STATE_DONE_FLAG;          
            var completeResult = "";
            completeResult += result;
            getElement("PingResultArea").value = completeResult;        
     } else if (status.indexOf("None") >= 0) {   
            isPingSuccess = false;     
            PingState=STATE_DONE_FLAG;
     } else {
            isPingSuccess = false;
            PingState=STATE_DONE_FLAG;        
            var otherResult = "Operation failed";
            getElement("PingResultArea").value = otherResult;
     }
}

function LoadWlanSsidEnable() {
    wlan2g = getFirstSSIDInst(1, allWlanInfo);
    wlan5g = getFirstSSIDInst(2, allWlanInfo);
    SetDivValue('wlSsid2G', wlan2g.ssid);
    setCheck('wlEnable2G', enbl2G);
    SetDivValue('wlSsid5G', wlan5g.ssid);
    setCheck('wlEnable5G', enbl5G);
}

function SsidEnable(id) {
    var wlan = wlan2g;
    var radioInst = 1;
    if (id != 'wlEnable2G') {
        wlan = wlan5g;
        radioInst = 2;
    }

    setDisable(id, 1);
    var Form = new webSubmitForm();
    var enable = getCheckVal(id);

    var wlanInst = wlan.InstId;
    Form.addParameter('x.Enable', enable);
    Form.addParameter('y.Enable', enable);
    Form.addParameter('y.RadioInst', radioInst);
    Form.setAction('set.cgi?y=InternetGatewayDevice.X_HW_DEBUG.AMP.SetWifiCoverEnable' +
                    '&x=InternetGatewayDevice.LANDevice.1.WiFi.Radio.' + radioInst +
                    '&RequestFile=../CustomApp/mainpage_new.asp');

    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function RedirectToWlanPage() {
    setDisplay('mainbody', 0);
    window.parent.onMenuChange("wlancoverinfo");
}

function RedirectToWlanbasic2g() {
    setDisplay('mainbody', 0);
    window.parent.onMenuChange("wlan2basic");
}

function RedirectToWlanbasic5g() {
    setDisplay('mainbody', 0);
    window.parent.onMenuChange("wlan5basic");
}

function RedirectToHomePage() {
    setDisplay('mainbody', 0);
    window.parent.onMenuChange("MainPage");
}
</script>
<style>
.osgidisable{
    background:#ccc!important;
    color:#fff!important;
}
</style>
</head>
<body id="mainbody" onload="loadframe();">
    <div id="mainDiv">
    <!-- 第一列 -->
        <ul id="mainDiv_ulOne">
           <div class="li_cont">
             <li>
                  <div class="deviceInfo">
                      <p class="title">Device Infomation</p>
                      <div style="width:100%;">
                        <div id="DI_div">
                            <p class="p_left">Model Name:</p>
                            <p class="p_right" id="DI_p_right_1"></p>
                        </div>
                        <div id="DI_div">
                            <p class="p_left">Mac-Address:</p>
                            <p class="p_right" id="DI_p_right_2"></p>
                        </div>
                        <div id="DI_div">
                            <p class="p_left">Hardware Version:</p>
                            <p class="p_right" id="DI_p_right_3"></p>
                        </div>
                        <div id="DI_div">
                            <p class="p_left">Firmware Version:</p>
                            <p class="p_right" id="DI_p_right_4"></p>
                        </div>
                        <div id="DI_div">
                            <p class="p_left">System Up Time:</p>
                            <p class="p_right" id="DI_p_right_systime"></p>
                        </div>
                        <div id="DI_div">
                            <p class="p_left">WAN Up Time:</p>
                            <p class="p_right" id="DI_p_right_wantime"></p>
                        </div>
                        <div class="DI_div_pross">
                            <p class="p_left">CPU Usage:</p>
                            <p class="p_pross">
                                <div class="progress progress-striped active clear small progress1">
                                    <div class="progress-bar" id="progress-bar1" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <script type="text/javascript">
                                      function GetCpuUsed() {
                                            if (cpuUsed != null) {
                                                document.getElementById("progress-bar1").style.width = cpuUsed;
                                            } else {
                                                document.getElementById("progress-bar1").style.width = 0;
                                            }
                                        }
                                      GetCpuUsed();                 
                                </script>
                            </p>
                        </div>
                        <div class="DI_div_pross">
                            <p class="p_left">Memory Usage:</p>
                            <p class="p_pross">
                                <div class="progress progress-striped active clear small progress1">
                                    <div class="progress-bar" id="progress-bar2" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <script type="text/javascript">
                                  function GetMemUsed() {
                                        if (memUsed != null) {
                                            document.getElementById("progress-bar2").style.width = memUsed;
                                        } else {
                                            document.getElementById("progress-bar2").style.width = 0;
                                        }
                                    }
                                  GetMemUsed();
                                </script>
                            </p>
                        </div>
                      </div>
                  </div>
             </li>
             <div class="li_footer">
                <div><input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>"></div>
                <div id="btn" onClick="ResetONT(this);">Reboot</div>
             </div>
           </div>
           <div class="li_cont">
             <li>
                <div class="attachDevice">
                     <p class="title">Attached Devices</p>
                     <div style="width:100%;">
                      <div class="AD_img">
                          <img src="../../images/home/img_home_attached_devices.png">
                      </div>
                      <div class="AD_text">Link to DHCP client</div>
                      <div class="AD_text">
                          Number of devices:<a onClick='RedirectToHomePage();'><span class="AD_text_span" id="AD_text_span_1"></span></a>
                      </div>
                     </div>
                </div>
             </li>
             <div class="li_footer2">
                <button id="btn2" onClick="Refresh2(this);" type="button">Refresh</button>
             </div>
           </div>
        </ul>
    <!-- 第二列 -->
         <ul id="mainDiv_ulTwo">
           <div class="li_cont">
             <li>
                <div class="interStatus">
                     <p class="title">Internet Status</p>
                     <div style="width:100%;">
                      <div class="IS_img">
                          <div class="IS_img_div"><img src="../../images/home/Group_24.png"></div>
                          <div class="IS_img_div" id="isRight"><i></i></div>
                          <div class="IS_img_div"><img src="../../images/home/Group_34.png"></div>
                          <div class="IS_img_div" id="isWrong"><i></i></div>
                          <div class="IS_img_div"><img src="../../images/home/Group_35.png"></div>
                      </div>
                      <div class="AD_text">
                          IP Address:<span class="AD_text_span" id="AD_text_span_2"></span>
                      </div>
                      <div class="AD_text">
                          DNS IP Address:<span class="AD_text_span"id="AD_text_span_3"></span>
                      </div>
                     </div>
                </div>
             </li>
             <div class="li_footer2">
                <button id="btn3" onClick="Refresh3(this);" type="button">Re-Connect</button>
             </div>
           </div>
           <div class="li_cont">
             <li>
                <div class="interStatus">
                    <p class="title">Wireless</p>
                      <div class='wlan_div_style1'>
                        <div class="line-header"></div>
                        <div class="AD_text wlan_div_style2">
                            <div class="IS_img_div wlan_div_style3">
                                <img src="../../images/home/ico_wifi_on_iii.png" style='width: 40px;'>
                            </div>
                            <div class="wlan_div_style4">
                                <div>2.4 GHz</div>
                                <div id='wlSsid2G'>AIS-FIBRE-FB_2.4GHz</div>
                                <div><a class='wlan_a_style' href="javascript:void(0);" onClick="RedirectToWlanbasic2g();">CHANGE</a></div>
                            </div>
                            <div class="wlan_div_style5">
                                    <input id="wlEnable2G" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='SsidEnable(this.id);'>
                                    <label for="wlEnable2G"></label>
                            </div>
                        </div>
                        <div class="line-header"></div>
                        <div class="AD_text wlan_div_style2">
                            <div class="IS_img_div wlan_div_style3">
                                <img src="../../images/home/ico_wifi_on_iii.png" style='width: 40px;'>
                            </div>
                            <div class="wlan_div_style4">
                                <div>5 GHz</div>
                                <div id='wlSsid5G'>AIS-FIBRE-FB_5GHz</div>
                                <div><a class='wlan_a_style' href="javascript:void(0);" onClick="RedirectToWlanbasic5g();">CHANGE</a></div>
                            </div>
                            <div class="wlan_div_style5">
                                <input id="wlEnable5G" class="cmn-toggle cmn-toggle-round" type="checkbox" onClick='SsidEnable(this.id);'>
                                <label for="wlEnable5G"></label>
                            </div>
                        </div>
                        <div class="line-header"></div>
                     </div>
                </div>
             </li>
           </div>
           <div class="li_cont">
             <li>
                <div class="interStatus">
                   <p class="title">HiLink</p>
                   <div class='wlan_div_style1'>
                        <div class="AD_text wlan_div_style6">
                            <iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" width="100%" src = '/html/amp/wificoverinfo/simplewlancoverinfo.asp'>
                            </iframe>
                        </div>
                    </div>
                </div>
             </li>
             <div class="li_footer2">
                <button id="btn4" onClick='RedirectToWlanPage();' type="button">Show Detail</button>
             </div>
           </div>
        </ul>
    <!-- 第三列 -->
        <ul id="mainDiv_ulThree">
            <div class="li_cont">
             <li>
                  <div class="deviceInfo">
                      <p class="title">Easy Diagnostic</p>
                      <div style="width:100%;">
                        <div class="ED_div_pross">
                            <p class="ED_p_left">WAN IP Check</p>
                            <p class="ED_p_pross">
                                <!--<div class="container" style="height:10px;width:75%;display:inline-block;"></div>-->
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar3" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="80" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross3"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">WAN IP Check :&nbsp;</p>
                                 <p class="ED_right" id="ED_right_1"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross ED_div_pross1">
                            <p class="ED_p_left">DNS Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar4" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross4"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">DNS1 Check :&nbsp;</p>
                                 <p class="ED_right" id="ED_right_2"></p>
                               </div>
                               <div id="ED_div" style="height:15px;line-height:15px;">
                                 <p class="ED_left">DNS2 Check :&nbsp;</p>
                                 <p class="ED_right" id="ED_right_3"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross">
                            <p class="ED_p_left">Ping Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar5" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross5"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">Ping Check :&nbsp;</p>
                                 <p class="ED_right" id="ED_right_Ping"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross" id="ED_div_pross_LAN1">
                            <p class="ED_p_left">LAN1 IP Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar6" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross6"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">LAN1 IP Check :&nbsp;</p>
                                 <p class="ED_right" id="LAN1"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross" id="ED_div_pross_LAN2">
                            <p class="ED_p_left">LAN2 IP Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar7" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross7"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">LAN2 IP Check :&nbsp;</p>
                                 <p class="ED_right" id="LAN2"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross" id="ED_div_pross_LAN3">
                            <p class="ED_p_left">LAN3 IP Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar8" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross8"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">LAN3 IP Check :&nbsp;</p>
                                 <p class="ED_right" id="LAN3"></p>
                               </div>
                            </p>
                        </div>
                        <div class="ED_div_pross" id="ED_div_pross_LAN4">
                            <p class="ED_p_left">LAN4 IP Check</p>
                            <p class="ED_p_pross">
                                <div class="progress progress-striped active clear small">
                                    <div class="progress-bar" id="progress-bar9" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%;">
                                        <span class="sr-only">0% Complete</span>
                                    </div>
                                </div>
                                <span class="ED_isRight0" id="ED_p_pross9"></span>
                            </p>
                            <p>
                               <div id="ED_div">
                                 <p class="ED_left">LAN4 IP Check :&nbsp;</p>
                                 <p class="ED_right" id="LAN4"></p>
                               </div>
                            </p>
                        </div>
                      </div>
                  </div>
             </li>
             <div class="li_footer2">
                <button id="btn5" onClick="Refresh5(this);" type="button">Re-Connect</button>
             </div>
           </div>
        </ul>
    </div>
<form id="table_ping" style="display:none;"> 
    <table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
        <tr>
           <td><input id="IPAddress" type="text" BindField="x.Host"/></td>
        </tr>
        <tr>
           <td><input id="WanNameList" type="text" BindField="x.Interface"/></td>
        </tr>
        <tr>
           <td><input id="DataBlockSize" type="text" BindField="x.DataBlockSize" value="56"/></td>
        </tr>
        <tr>
           <td><input id="NumOfRepetitions" type="text" BindField="x.NumberOfRepetitions" value="4"/></td>
        </tr>
        <tr>
           <td><input id="MaxTimeout" type="text" BindField="x.Timeout" value="10"/></td>
        </tr>
        <tr>
           <td><input id="DscpValue" type="text" BindField="x.DSCP" value="0"/></td>
        </tr>
    </table>
      <textarea name="PingResultArea" id="PingResultArea"  wrap="off" readonly="readonly" style="width: 100%;height: 150px;margin-top: 10px;display:none;">
      </textarea> 
     </div>         
</form> 
</body>
</html>
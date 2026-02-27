<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>User Device detail Information</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/GetLanUserDevInfo.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="JavaScript" type="text/javascript">

var num = 0;
var domianvlaue = "OldWeb";
var page = 1;
var MAX_LINE_TYPE=129;
var HW_USER_DEVICE_IP_STATIC="Static";
var FOR_NULL="--";
var hostname = "";
var deviceIP = "";
var IPType   = "";
var remainleasetime = "";
var rssi = "--";
var negotiatedrate = "--";
var deviceDur = "";
var unit_h = "";
var unit_m = "";
var IsPTVDFFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var IsDevTypeFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_USER_DEVTYPE);%>';
var STBPort = '<%HW_WEB_GetSTBPort();%>';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var APAutoUPPortFlag = '<%HW_WEB_GetFeatureSupport(FT_AP_WEB_SELECT_UPPORT);%>';

var mngtTY40 = '<%HW_WEB_GetFeatureSupport(FT_WEB_TIANYI_40);%>';
var isSupportIPv6Wan = "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6_WANCFG);%>";
var isSupportNPTv6 = '<%HW_WEB_GetFeatureSupport(FT_WEB_NPTV6);%>';
var isFTTRMAIN = '<%HW_WEB_GetFeatureSupport(FT_FTTR_MAIN_ONT);%>';
var rosunionGame = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_ROSUNION_GAME);%>';
var BinWord = '<%HW_WEB_GetBinMode();%>';
var isRealmac = '<%HW_WEB_GetFeatureSupport(BBSP_FT_STA_REALMAC);%>';

function SupportNPTv6Address()
{
    if (((mngtTY40 == '1') || (isSupportNPTv6 == '1')) &&(isSupportIPv6Wan == '1')) {
        return true;
    }

    return false;
}

function IsFreInSsidName()
{
    if(1 == IsPTVDFFlag)
    {
        return true;
    }
}

if(( window.location.href.indexOf("?") > 0) &&( window.location.href.split("?").length == 3))
{
    if(window.location.href.split("?")[1].indexOf("InternetGatewayDevice") >=0)
    {
        domianvlaue = window.location.href.split("?")[1] ;
        if(domianvlaue.charAt(domianvlaue.length - 1) == '.')
        {
            domianvlaue = domianvlaue.substr(0, domianvlaue.length - 1);
            num = domianvlaue.substr(domianvlaue.length - 1,domianvlaue.length);
            top.userdevinfonum = num;             
        }
    }
    else
    {
        num  = window.location.href.split("?")[1];
        top.userdevinfonum = num;
    }
    page = window.location.href.split("?")[2];  
}

function IPv6USERDevice(Domain,IpAddr,MacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName,LeaseTimeRemaining,NPTv6IP)
{
    this.Domain     = Domain;
    this.IpAddr     = IpAddr;
    this.MacAddr    = MacAddr;
    if(Port=="LAN0" || Port=="SSID0")
    {
        this.Port   = FOR_NULL;
    }
    else
    {
       this.Port    = Port;
    }   
    this.PortType   = PortType;
    this.DevStatus  = DevStatus;
    this.IpType     = IpType;
    
    if(IpType==HW_USER_DEVICE_IP_STATIC)
    {
      this.DevType = FOR_NULL;
    }
    else
    {
        if(DevType=="")
        {
            this.DevType    = FOR_NULL; 
        }
        else
        {
            this.DevType    = DevType;      
        }   
    }
        
    this.Time       = Time;
    if(HostName=="")
    {
        this.HostName   = FOR_NULL;
    }
    else
    {
       this.HostName    = HostName;
    }
    
    this.LeaseTimeRemaining = LeaseTimeRemaining ;
    
    if (NPTv6IP == "") {
        this.NPTv6IP = FOR_NULL;
    } else {
        this.NPTv6IP = NPTv6IP;
    }
}

function IPv6USERDeviceNew(Domain,IpAddr,MacAddr,RealMacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName,LeaseTimeRemaining,NPTv6IP)
{
    this.Domain = Domain;
    this.IpAddr = IpAddr;
    this.MacAddr = MacAddr;
    this.RealMacAddr = RealMacAddr;
    if (Port == "LAN0" || Port == "SSID0") {
        this.Port = FOR_NULL;
    } else {
       this.Port = Port;
    }   
    this.PortType = PortType;
    this.DevStatus = DevStatus;
    this.IpType  = IpType;
    
    if(IpType==HW_USER_DEVICE_IP_STATIC) {
      this.DevType = FOR_NULL;
    } else {
        if(DevType == "") {
            this.DevType = FOR_NULL; 
        } else {
            this.DevType = DevType;      
        }   
    }
        
    this.Time = Time;
    if(HostName == "") {
        this.HostName = FOR_NULL;
    } else {
       this.HostName = HostName;
    }
    this.LeaseTimeRemaining = LeaseTimeRemaining ;
    
    if (NPTv6IP == "") {
        this.NPTv6IP = FOR_NULL;
    } else {
        this.NPTv6IP = NPTv6IP;
    }
}
function DhcpInfo(Domain, IPAddress, MACAddress, LeaseTimeRemaining,AddressSource)
{
    this.Domain     = Domain;
    this.IPAddress  = IPAddress;
    this.MACAddress = MACAddress;
    this.LeaseTimeRemaining = LeaseTimeRemaining;
    this.AddressSource = AddressSource;
}
var DhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.Hosts.Host.{i},IPAddress|MACAddress|LeaseTimeRemaining|AddressSource, DhcpInfo);%>;
var DhcpInfosNum = DhcpInfos.length - 1;
var UserDevices = new Array();
$.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "/html/bbsp/common/GetLanUserDevInfo.asp",
        success : function(data) {
        UserDevices = eval(data);
        }
    });

var UserDevicesnum = UserDevices.length - 1;


function GetRemainLeaseTime(ipaddr, macaddr)
{
    if(domianvlaue.indexOf(".IPv6Address") >= 0)
    {
        return  UserDevices[num] .LeaseTimeRemaining ;
    }
    for (var i = 0; i < DhcpInfosNum; i++)
    {
        if ((ipaddr == DhcpInfos[i].IPAddress) && (macaddr == DhcpInfos[i].MACAddress))
        {
            return DhcpInfos[i].LeaseTimeRemaining;
        }
    }
    
    return -1;
}

function loadlanguage()
{
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }
        b.innerHTML = userdevinfo_language[b.getAttribute("BindText")];
    }
}

function LoadUserDevice()
{
    var index = top.userdevinfonum;
    var DeviceType = IsSpecifiedDeviceType(UserDevices[index]);
    var UserDevAlias = UserDevices[index].UserDevAlias;
    setText("UserDevAlias",UserDevAlias);
    setSelect("DeviceType",DeviceType);
}
function DisplayUserType()
{
    if ((IsDevTypeFlag == 0) || (IsUseNewWeb() == true)) {
        setDisplay("aliasRow",0);
        setDisplay("devtypeRow",0);
        setDisplay("apply",0);
    }
}
function InitUserType()
{
    var TypeList = getElementById("DeviceType");
    var arr = ["--",userdevinfo_language['bbsp_phone'],userdevinfo_language['bbsp_pad'],
                userdevinfo_language['bbsp_pc'],userdevinfo_language['bbsp_stb'],userdevinfo_language['bbsp_other']];
    for (var i = 0; i < arr.length; i++)
    {
        TypeList.options.add(new Option(arr[i],i));
    }
}
function IsUseNewWeb()
{
    if ('OldWeb' == domianvlaue)
    {
        return false;
    }
    return true;
}
function IsSpecifiedDeviceType(obj)
{
    if (obj.UserSpecifiedDeviceType >0)
    {
        return obj.UserSpecifiedDeviceType;
    }
    else
    {
        if (obj.DeviceType >0)
        {
            return obj.DeviceType;
        }
        else
        {
            return;
        }
    }
}
function OnSubmit()
{
    var UserDevAlias = getValue("UserDevAlias");
    var DeviceType = getSelectVal("DeviceType");
    var Form = new webSubmitForm();
    var RequestFile = "html/bbsp/userdevinfo/userdetdevinfo.asp"
    Form.addParameter('x.UserDevAlias',UserDevAlias);
    Form.addParameter('x.UserSpecifiedDeviceType',DeviceType);
    url = 'set.cgi?x='
        + UserDevices[num].Domain
        + '&RequestFile=' + RequestFile;
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    setDisable('apply',1);
    Form.setAction(url);
    Form.submit();
}

function OnBack()
{
    if (((curWebFrame == 'frame_XGPON') || (curWebFrame == 'FrameAISAP')) && (IsUseNewWeb() != true) ||
        ((curWebFrame == 'frame_huawei') && (BinWord.toUpperCase() == 'A8C'))) {
        window.location= '/CustomApp/mainpage.asp';
    } else {
        if (IsUseNewWeb() == true)  {
            window.location='userdevinfo1.asp?'+page;
        } else {
            window.location='userdevinfo.asp?'+page;
        }
    }
}
function USERv6Device(domain, IPv6Addr, IPv6Scope)
{
    this.domain = domain;
    this.IPv6Addr = IPv6Addr;
    this.IPv6Scope = IPv6Scope; 
}
function USERDevIPv6(Domain,IpAddr,MacAddr,PortID,IpType,DevType,DevStatus,PortType,time,HostName,LeaseTime,NPTv6IP) {
    this.Domain = Domain;
    this.IpAddr = (IpAddr.length == 0)?"--":IpAddr;
    this.MacAddr = MacAddr;
    if(PortID == "LAN0" || PortID == "SSID0") {
        this.PortID  = "--"; 
    } else {
        this.PortID  = PortID;
    }
    this.PortType = PortType;
    this.DevStatus = DevStatus;
    this.IpType = IpType;
    if (IpType == "Static") {
        this.DevType = "--";
    } else {
        if (DevType == "") {
            this.DevType = "--";
        } else {
            this.DevType = DevType;
        }
    }
    this.time = time;
    if (HostName == "") {
        this.HostName = "--";
    } else {
        this.HostName = HostName;
    }
    this.LeaseTime = LeaseTime;
    if (NPTv6IP == "") {
        this.NPTv6IP = "--";
    } else {
        this.NPTv6IP = NPTv6IP;
    }
}

function USERDevIPv6New(Domain,IpAddr,MacAddr,RealMacAddr,PortID,IpType,DevType,DevStatus,PortType,time,HostName,LeaseTime,NPTv6IP) {
    this.Domain = Domain;
    this.IpAddr = (IpAddr.length == 0)?"--":IpAddr;
    this.MacAddr = MacAddr;
    this.RealMacAddr = RealMacAddr;
    if(PortID == "LAN0" || PortID == "SSID0") {
        this.PortID  = "--"; 
    } else {
        this.PortID  = PortID;
    }
    this.PortType = PortType;
    this.DevStatus = DevStatus;
    this.IpType = IpType;
    if (IpType == "Static") {
        this.DevType = "--";
    } else {
        if (DevType == "") {
            this.DevType = "--";
        } else {
            this.DevType = DevType;
        }
    }
    this.time = time;
    if (HostName == "") {
        this.HostName = "--";
    } else {
        this.HostName = HostName;
    }
    this.LeaseTime = LeaseTime;
    if (NPTv6IP == "") {
        this.NPTv6IP = "--";
    } else {
        this.NPTv6IP = NPTv6IP;
    }
}

function USERDev(Domain, IpAddr, MacAddr, PortID, IpType, DevType, DevStatus, PortType, time, HostName, RSSI, NegotiatedRate) {
    this.Domain = Domain;
    this.IpAddr = (IpAddr.length == 0) ? "--" : IpAddr;
    this.MacAddr = MacAddr;
    if (PortID == "LAN0" || PortID == "SSID0") {
        this.PortID = "--";
    } else {
        this.PortID = PortID;
    }
    this.PortType = PortType;
    this.DevStatus = DevStatus;
    this.IpType = IpType;
    if (IpType == "Static") {
        this.DevType = "--";
    } else {
        if (DevType == "") {
            this.DevType = "--";
        } else {
            this.DevType = DevType;
        }
    }
    this.time = time;
    if (HostName == "") {
        this.HostName = "--";
    } else {
        this.HostName = HostName;
    }
    this.RSSI = RSSI;
    this.NegotiatedRate = NegotiatedRate;
}

function USERDevNew(Domain, IpAddr, MacAddr, RealMacAddr, PortID, IpType, DevType, DevStatus, PortType, time, HostName, RSSI, NegotiatedRate) {
    this.Domain = Domain;
    this.IpAddr = (IpAddr.length == 0) ? "--" : IpAddr;
    this.MacAddr = MacAddr;
    this.RealMacAddr = RealMacAddr;
    if (PortID == "LAN0" || PortID == "SSID0") {
        this.PortID = "--";
    } else {
        this.PortID = PortID;
    }
    this.PortType = PortType;
    this.DevStatus = DevStatus;
    this.IpType = IpType;
    if (IpType == "Static") {
        this.DevType = "--";
    } else {
        if (DevType == "") {
            this.DevType = "--";
        } else {
            this.DevType = DevType;
        }
    }
    this.time = time;
    if (HostName == "") {
        this.HostName = "--";
    } else {
        this.HostName = HostName;
    }
    this.RSSI = RSSI;
    this.NegotiatedRate = NegotiatedRate;
}

function LoadFrame()
{
	if (APAutoUPPortFlag == 1)
	{
		 setDisplay("devport",0);
	}
	
    if ( "1" == GetCfgMode().TELMEX )
    {
        document.getElementById('ShowOnlineTimeInfo').style.display="none";
    }
    if ((domianvlaue.indexOf(".IPv6Address") < 0) || (SupportNPTv6Address() == false)) {
        setDisplay("NPTv6IPInfo",0);
    }
    loadlanguage();
    DisplayUserType();    
    InitUserType();
	if (IsDevTypeFlag == 1) 
	{
    LoadUserDevice();
    }
    
    if (UserDevices[num].PortType.toUpperCase() != "WIFI") {
        setDisplay("ReceivedSignalStrengthIndication", 0);
    }
}

function GetRSSIAndNegrateDevByDomain(domianvlaueSub) {
    var UserDevinfo = <% HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo, InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName|X_HW_RSSI|X_HW_NegotiatedRate,USERDev);%>;
    for (var k = 0; k < UserDevinfo.length - 1; k++) {
        if (UserDevinfo[k].Domain == domianvlaueSub) {
            return UserDevinfo[k];
        }
    }

    return null;
}
</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
if (IsUseNewWeb() == true) {
    if ((domianvlaue.indexOf(".IPv6Address") < 0) || (SupportNPTv6Address() == false)) {
        HWCreatePageHeadInfo("userdetdevinfotitle", GetDescFormArrayById(userdevinfo_language, "bbsp_mune"), GetDescFormArrayById(userdevinfo_language, "bbsp_userdetdevinfo_title1"), false);
    } else {
        HWCreatePageHeadInfo("userdetdevinfotitle", GetDescFormArrayById(userdevinfo_language, "bbsp_mune"), GetDescFormArrayById(userdevinfo_language, "bbsp_userdetdevinfo_title2"), false);
    }
} else {
    HWCreatePageHeadInfo("userdetdevinfotitle", GetDescFormArrayById(userdevinfo_language, "bbsp_mune"), GetDescFormArrayById(userdevinfo_language, "bbsp_userdetdevinfo_title"), false);
}
</script> 
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg" id='devdetinfo'> 
  <tr> 
    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
    <td class="table_title  width_per25" BindText='bbsp_hostnamemh'></td> 
    <td class="table_right width_per75"> <script language="JavaScript">
                if (IsDevTypeFlag ==1)
                {
                     num = top.userdevinfonum;
                }

                var UserDevinfoNew;
                if(IsUseNewWeb() == true)
                { 
                    var Result = null;
                    var ParameterList = null ;
                    var ObjPath = 'x='+domianvlaue;
                    if( domianvlaue.indexOf(".IPv6Address") >= 0 ) {
                        if (isRealmac == 1) {
                            var UserDevinfoall = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i}.IPv6Address.{i},IP|MacAddr|RealMacAddr|PortID|IpType|DevType|DevStatus|PortType|Time|HostName|LeaseTime|NPTv6IP,USERDevIPv6New);%>;
                        } else {
                            var UserDevinfoall = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i}.IPv6Address.{i},IP|MacAddr|PortID|IpType|DevType|DevStatus|PortType|Time|HostName|LeaseTime|NPTv6IP,USERDevIPv6);%>;
                        }
                    } else {
                        if (isRealmac == 1) {
                            var UserDevinfoall = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|RealMacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName|X_HW_RSSI|X_HW_NegotiatedRate,USERDevNew);%>;
                        } else {
                            var UserDevinfoall = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName|X_HW_RSSI|X_HW_NegotiatedRate,USERDev);%>;
                        }
                    }
                
					for(var i = 0; i < UserDevinfoall.length-1; i++)
					{
						if(UserDevinfoall[i].Domain == domianvlaue)
						{
							var UserDevinfo = UserDevinfoall[i];
							break;
                        }
					}
                    
					var UserDevInfoTmp = UserDevinfo;
                    if (domianvlaue.indexOf(".IPv6Address") >= 0) {
                        if (isRealmac == 1) {
                            UserDevices[num] = new IPv6USERDeviceNew(domianvlaue,UserDevInfoTmp.IpAddr,UserDevInfoTmp.MacAddr,UserDevInfoTmp.RealMacAddr,UserDevInfoTmp.PortID,UserDevInfoTmp.IpType,UserDevInfoTmp.DevType,UserDevInfoTmp.DevStatus,UserDevInfoTmp.PortType,UserDevInfoTmp.time,UserDevInfoTmp.HostName,UserDevInfoTmp.LeaseTime,UserDevInfoTmp.NPTv6IP);
                        } else {
                            UserDevices[num] = new IPv6USERDevice(domianvlaue,UserDevInfoTmp.IpAddr,UserDevInfoTmp.MacAddr,UserDevInfoTmp.PortID,UserDevInfoTmp.IpType,UserDevInfoTmp.DevType,UserDevInfoTmp.DevStatus,UserDevInfoTmp.PortType,UserDevInfoTmp.time,UserDevInfoTmp.HostName,UserDevInfoTmp.LeaseTime,UserDevInfoTmp.NPTv6IP);
                        }
                    } else {
                        if (isRealmac == 1) {
                            UserDevices[num] = new USERDeviceNew(domianvlaue,UserDevInfoTmp.IpAddr,UserDevInfoTmp.MacAddr,UserDevInfoTmp.RealMacAddr,UserDevInfoTmp.PortID,UserDevInfoTmp.IpType,UserDevInfoTmp.DevType,UserDevInfoTmp.DevStatus,UserDevInfoTmp.PortType,UserDevInfoTmp.time,UserDevInfoTmp.HostName);
                        } else {
                            UserDevices[num] = new USERDevice(domianvlaue,UserDevInfoTmp.IpAddr,UserDevInfoTmp.MacAddr,UserDevInfoTmp.PortID,UserDevInfoTmp.IpType,UserDevInfoTmp.DevType,UserDevInfoTmp.DevStatus,UserDevInfoTmp.PortType,UserDevInfoTmp.time,UserDevInfoTmp.HostName);
                        }
                    }
                    
                    if (domianvlaue.indexOf(".IPv6Address") >= 0) {
                        var domianvlaueSub = domianvlaue.substr(0, domianvlaue.indexOf(".IPv6Address"));
                        var UserDevinfoNew = GetRSSIAndNegrateDevByDomain(domianvlaueSub);
                        if (UserDevinfoNew != null) {
                            rssi = UserDevinfoNew.RSSI;
                            negotiatedrate = UserDevinfoNew.NegotiatedRate;
                        }
                    } else {
                        rssi = UserDevInfoTmp.RSSI;
                        negotiatedrate = UserDevInfoTmp.NegotiatedRate;
                    }
                } else {
                    UserDevinfoNew = GetRSSIAndNegrateDevByDomain(UserDevices[num].Domain);
                    if (UserDevinfoNew != null) {
                        rssi = UserDevinfoNew.RSSI;
                        negotiatedrate = UserDevinfoNew.NegotiatedRate;
                    }
                }

                if(true == IsFreInSsidName())
                {
                    var SL = GetSSIDList();
                    var SLFre = GetSSIDFreList();
                    for(var j = 0; j < SL.length; j++)
                    {
                        if(SL[j].name == UserDevices[num].Port.toUpperCase())
                        {
                            UserDevices[num].Port = SLFre[j].name;
                            break;
                        }
                    }
                }
                
                if(STBPort > 0)
                {
                    var LanPort = "LAN" + STBPort;
                    if(UserDevices[num].Port.toUpperCase() == LanPort)
                    {
                        UserDevices[num].Port = userdevinfo_language['bbsp_lanstb'];
                    }
                }
                
                if(('--' == UserDevices[num].HostName) && ("1" == GetCfgMode().TELMEX))
                {
                    document.write(UserDevices[num].MacAddr);
                }
                else
                {
                    document.write(htmlencode(UserDevices[num].HostName.substr(0,MAX_LINE_TYPE)));
                }           
                
                if( "X_RTK_BRIDGE" == UserDevices[num].IpType)
                {
                    hostname = "--";
                    deviceIP = UserDevices[num].IpAddr;
                    IPType   = "X_RTK_BRIDGE";
                    remainleasetime  =  "--";
                    deviceDur   =  "--";
                }
                else
                {
                    hostname        =  htmlencode(UserDevices[num].DevType.substr(0,MAX_LINE_TYPE));
                    deviceIP        =  UserDevices[num].IpAddr;
                    IPType          =  userdevinfo_language[UserDevices[num].IpType];       
                    unit_h = (parseInt(UserDevices[num].Time.split(":")[0],10) > 1) ? userdevinfo_language['bbsp_hours'] : userdevinfo_language['bbsp_hour'];
                    unit_m = (parseInt(UserDevices[num].Time.split(":")[1],10) > 1) ? userdevinfo_language['bbsp_mins'] : userdevinfo_language['bbsp_min'];
                    deviceDur = UserDevices[num].Time.split(":")[0] + unit_h + UserDevices[num].Time.split(":")[1] + unit_m;
                    
                    remainleasetime = "--";
                    if ('DHCP' == UserDevices[num].IpType || 'DHCPV6'==UserDevices[num].IpType.toUpperCase())
                    {   
                        remainleasetime =  GetRemainLeaseTime(UserDevices[num].IpAddr, UserDevices[num].MacAddr);
                        if (remainleasetime > 0)
                        {
                            remainleasetime = remainleasetime + " " + userdevinfo_language["bbsp_second"];
                        }
                        else
                        {
                            remainleasetime = "--";
                        }
                    }
                }
                </script> </td> 
  </tr> 
  <tr id="aliasRow"> 
      <td class="table_title width_per25" BindText='bbsp_aliasmh'></td>
      <td class="table_right width_per75">
          <input type="text" id="UserDevAlias" value = "">
      </td>
  </tr>
  <tr id="devtypeRow">
    <td  class="table_title width_per25" BindText='bbsp_usertypemh'></td> 
    <td  class="table_right width_per75">
        <select id="DeviceType">
        </select>
    </td>
  </tr>
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_devtypemh'></td> 
    <td  class="table_right width_per75"> 
        <script language="JavaScript">
                document.write(hostname);
        </script> 
    </td>   
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_ipmh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">               
                 document.write(deviceIP);
                </script> </td> 
  </tr> 
   <tr id="NPTv6IPInfo"> 
    <td  class="table_title width_per25" BindText='bbsp_nptv6addrmh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
                 document.write(UserDevices[num].NPTv6IP);
                </script> </td> 
  </tr> 
  <tr> 
    <script>
        if (isRealmac == 1) {
            document.write("<td  class='table_title width_per25' BindText='bbsp_macmh'></td> ")
        } else {
            document.write("<td  class='table_title width_per25' BindText='bbsp_realmacmh'></td> ")
        }
    </script>
    <td  class="table_right width_per75"> <script language="JavaScript">-
                document.write(UserDevices[num].MacAddr);
                </script> </td> 
  </tr>
<script>
    if (isRealmac == 1) {
        document.write("<tr>");
        document.write("<td  class='table_title width_per25' BindText='bbsp_realmacmh'></td>");
        document.write("<td  class='table_right width_per75'>" + UserDevices[num].RealMacAddr + "</td>" );
        document.write("</tr>");
    }
</script>  
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_devstatemh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
                document.write(userdevinfo_language[UserDevices[num].DevStatus]);
                </script> </td> 
  </tr>
  <tr id="ShowOnlineTimeInfo"> 
    <td class="table_title width_per25">
        <script>
            if (UserDevices[num].DevStatus.toUpperCase() == 'ONLINE') {
                document.write(userdevinfo_language['bbsp_onlinetimemh']);
            } else {
                document.write(userdevinfo_language['bbsp_offlineiimemh']);
            }
        </script>
    </td>
    <td class="table_right width_per75">
        <script language="JavaScript">
            document.write(deviceDur);
        </script>
    </td>
  </tr>
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_porttypemh'></td> 
    <td  class="table_right width_per75">
        <script language="JavaScript">
        if(isFTTRMAIN == '1' && UserDevices[num].PortType == "ONU") {
            document.write("PON");
        } else {
            document.write(UserDevices[num].PortType);
        }
        </script>
    </td> 
  </tr> 
  <tr id="devport"> 
    <td  class="table_title width_per25">
    <script>
    if (true == IsUseNewWeb())
    {
        document.write(userdevinfo_language['bbsp_interfacemh']);
    }
    else
    {
        document.write(userdevinfo_language['bbsp_portmh']);
    }
    </script>
    </td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
        if(isFTTRMAIN == '1' && UserDevices[num].PortType == "ONU") {
            document.write("PON1");
        } else {
            document.write(UserDevices[num].Port);
        }
        </script> </td> 
  </tr>
  <tr id="ReceivedSignalStrengthIndication">
    <td class="table_title width_per25" BindText='bbsp_receivedsignalstrength'></td>
    <td class="table_right width_per75">
        <script language="JavaScript">
            if (rssi == "--" || UserDevices[num].DevStatus.toUpperCase() != 'ONLINE') {
                document.write("--");
            } else {
                document.write(rssi+" dBm");
            }
        </script>
    </td>
  </tr>
  <tr id="NegotiationRate">
    <td class="table_title width_per25" BindText='bbsp_negotiationrate'></td>
    <td class="table_right width_per75">
        <script language="JavaScript">
            if (negotiatedrate == "--" || UserDevices[num].DevStatus.toUpperCase() != 'ONLINE') {
                document.write("--");
            } else {
                document.write(negotiatedrate+" Mbps");
            }
        </script>
    </td>
  </tr>
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_ipacmodemh' ></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
                if( domianvlaue.indexOf(".IPv6Address") >= 0 )
                {
                    document.write(UserDevices[num].IpType);
                }
                else
                {
                    document.write(IPType);
                }
                </script> </td> 
  </tr> 
  <tr> 
    <td class="table_title width_per25" BindText='bbsp_remainleasedtime'></td> 
    <td class="table_right width_per75"> <script language="JavaScript">
        document.write(remainleasetime );       
    </script> </td> 
  </tr>
</table> 
<table width="100%" height="30"> 
  <tr> 
    <td class='title_bright1'>
        <button id="apply" name="back" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnSubmit();" enable=true  ><script>document.write(userdevinfo_language['bbsp_apply']);</script></button>
        <button id="back" name="back" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnBack();" enable=true  ><script>document.write(userdevinfo_language['bbsp_back']);</script></button>
		<script>
			if (rosunionGame == "1") {
				$("#back").removeClass("ApplyButtoncss").addClass("CancleButtonCss");
			}
		</script>
    </td>
  </tr> 
</table> 
</body>
</html>



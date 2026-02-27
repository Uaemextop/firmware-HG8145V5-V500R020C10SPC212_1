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
	table.setupWifiTable tbody tr td.cinza{
		text-align:center;
		padding-top: 12px;
		padding-bottom: 12px;
	}
	table.setupWifiTable tbody tr td.cinza2{
		text-align:center;
		padding-top: 12px;
		padding-bottom: 12px;
	}
</style>
<script language="JavaScript" type="text/javascript">

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var sptUserType ='1';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var bssid_5 = '<%HW_WEB_GetWlanMac_5G();%>';
var bssid_2 = '<%HW_WEB_GetWlanMac_2G();%>';
var CurrentBin = '<%HW_WEB_GetBinMode();%>';
var wlaninfo_channel_display = 0;

var wlanpage;
if (location.href.indexOf("bztlfwlaninfo.asp?") > 0)
{
    wlanpage = location.href.split("?")[1]; 
    top.WlanAdvancePage = wlanpage;
}

wlanpage = top.WlanAdvancePage; 

var isStaWorkingModeShow = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PTVDF);%>';

var IspSSIDVisibility = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_ISPSSID_VISIBILITY);%>';
var ChanInfo = '<%HW_WEB_GetChanInfo();%>';
var transmitPower = 0;
var transmitPower5g = 0;
var WlanChannel5g = -2;
var WlanChannel2g = ChanInfo.split(',')[0];
if (1 == DoubleFreqFlag)
{
    WlanChannel5g = ChanInfo.split(',')[1];
}

var staNum = 0;
var weakerSta = 0;
var staNum5g = 0;
var weakerSta5g = 0;

var nAPNum = 0;
var strongNAPNum = 0;
var nAPNum5g = 0;
var strongNAPNum5g = 0;

var SsidPerBand = '<%HW_WEB_GetSPEC(AMP_SPEC_SSID_NUM_MAX_BAND.UINT32);%>';
var possibleChannels = "";
function stWlan(domain,enable,name,ssid,BeaconType,BasicEncrypt,BasicAuth,WPAEncrypt,WPAAuth,IEEE11iEncrypt,IEEE11iAuth,WPAand11iEncrypt,WPAand11iAuth,Channel,LowerLayers, X_HW_Standard, RegulatoryDomain, X_HW_HT20, TransmitPower)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
    this.BeaconType = BeaconType;    
    this.BasicAuth = BasicAuth;
	this.BasicEncrypt = BasicEncrypt;    
    this.WPAAuth = WPAAuth;
	this.WPAEncrypt = WPAEncrypt;    
    this.IEEE11iAuth = IEEE11iAuth;
	this.IEEE11iEncrypt = IEEE11iEncrypt;
	this.WPAand11iAuth = WPAand11iAuth;
	this.WPAand11iEncrypt = WPAand11iEncrypt;
	this.Channel = Channel;	
	this.LowerLayers = LowerLayers;
    this.X_HW_Standard = X_HW_Standard;
    this.RegulatoryDomain = RegulatoryDomain;
    this.X_HW_HT20 = X_HW_HT20;
    this.TransmitPower = TransmitPower;
}

function stWlanTb(wlanInst, ssid, wetherConfig, auth, encrypt)
{
	this.wlanInst = wlanInst;
	this.ssid = ssid;
	this.wetherConfig = wetherConfig;
	this.auth = auth;
	this.encrypt = encrypt;
}

function stPacketInfo(domain,totalBytesSent,totalPacketsSent,totalBytesReceived,totalPacketsReceived)
{
    this.domain = domain;
    this.totalBytesSent = totalBytesSent;
	this.totalPacketsSent = totalPacketsSent;
	this.totalBytesReceived = totalBytesReceived;
	this.totalPacketsReceived = totalPacketsReceived;
}

function stStats(domain,errorsSent,errorsReceived,discardPacketsSent,discardPacketsReceived)
{
    this.domain = domain;
    this.errorsSent = errorsSent;
    this.errorsReceived = errorsReceived;
    this.discardPacketsSent = discardPacketsSent;
    this.discardPacketsReceived = discardPacketsReceived;
}

function stRadio(domain,OperatingFrequencyBand,Enable)
{
    this.domain = domain;
    this.OperatingFrequencyBand = OperatingFrequencyBand;
    this.Enable = Enable;
}

function stIndexMapping(index,portIndex)
{
    this.index = index;
    this.portIndex = portIndex;
}

function stAssociatedDevice(domain,AssociatedDeviceMACAddress,X_HW_Uptime,X_HW_RxRate,X_HW_TxRate,X_HW_RSSI,X_HW_Noise,X_HW_SNR,X_HW_SingalQuality,X_HW_WorkingMode,X_HW_WMMStatus,X_HW_PSMode)
{
	this.domain = domain;
	this.AssociatedDeviceMACAddress = AssociatedDeviceMACAddress;
    this.X_HW_Uptime = X_HW_Uptime;
    this.X_HW_RxRate = X_HW_RxRate;
    this.X_HW_TxRate = X_HW_TxRate;
    this.X_HW_RSSI   = X_HW_RSSI;
    this.X_HW_Noise  = X_HW_Noise;
    this.X_HW_SNR    = X_HW_SNR;
    this.X_HW_SingalQuality  = X_HW_SingalQuality;
    this.X_HW_WorkingMode  = X_HW_WorkingMode;
    this.X_HW_WMMStatus  = X_HW_WMMStatus;
    this.X_HW_PSMode  = X_HW_PSMode;
    this.ssidname = 0;
}

function stNeighbourAP(domain,SSID,BSSID,NetworkType,Channel,RSSI,Noise,DtimPeriod,BeaconPeriod,Security,Standard,MaxBitRate)
{
	this.domain = domain;
	this.SSID = SSID;
    this.BSSID = BSSID;
    this.NetworkType = NetworkType;
    this.Channel = Channel;
    this.RSSI = RSSI;
    this.Noise = Noise;
    this.DtimPeriod = DtimPeriod;
    this.BeaconPeriod = BeaconPeriod;
    this.Security = Security;
    this.Standard = Standard;
    this.MaxBitRate = MaxBitRate;
}


var WlanInfo = new Array();
WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Enable|Name|SSID|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|Channel|LowerLayers|X_HW_Standard|RegulatoryDomain|X_HW_HT20|TransmitPower,stWlan,STATUS);%>;  

var WlanChannel = '';

var PacketInfo = new Array();
PacketInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},TotalBytesSent|TotalPacketsSent|TotalBytesReceived|TotalPacketsReceived,stPacketInfo,STATUS);%>; 

var Stats = new Array();
Stats = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.Stats,ErrorsSent|ErrorsReceived|DiscardPacketsSent|DiscardPacketsReceived,stStats,STATUS);%>;
	
var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';


var AssociatedDevice = new stAssociatedDevice("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");

var NeighbourAP = new stNeighbourAP("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");

function getWlanPortNumber(name)
{
    var length = name.length;
    var number;
    var str = parseInt(name.charAt(length-1));
    return str;
}

var WlanMap = new Array();

for (var i = 0; i < WlanInfo.length-1; i++)
{
    var index = getWlanPortNumber(WlanInfo[i].name);
	WlanMap[i] = new stIndexMapping(i, index);
}

if (WlanMap.length >= 2)
{
    for (var i = 0; i < WlanMap.length-1; i++)
    {
        for( var j =0; j < WlanMap.length-i-1; j++)
        {
            if (WlanMap[j+1].portIndex < WlanMap[j].portIndex)
            {
                var middle = WlanMap[j+1];
                WlanMap[j+1] = WlanMap[j];
                WlanMap[j] = middle;
            }
        }
    }
}


function getIndexFromPort(index)
{
    for (var i = 0; i < WlanMap.length; i++)
    {
        if (index == WlanMap[i].portIndex)
        {
            return WlanMap[i].index;
        }
    }
}

function getPortFromIndex(index)
{
    for (var i = 0; i < WlanMap.length; i++)
    {
        if (index == WlanMap[i].index)
        {
            return WlanMap[i].portIndex;
        }
    }
}

function GetSecurityType(index)
{  
	var securityType = 'WPA2';
    var WlanInfo_s = WlanInfo[index];
	var curBeaconType = WlanInfo_s.BeaconType; 
	
    switch (curBeaconType)
    {
        case 'WPAand11i':
            securityType = "WPA/WPA2";
            break;
        case '11i':
            securityType = "WPA2";
            break;
        case 'WPA':
            securityType = "WPA";
            break;
        case 'Basic':
            if (WlanInfo_s.BasicAuth == 'None')
            {
                securityType = cfg_wlaninfomation_tdevivo_language['amp_info_none'];
            }
            else if (WlanInfo_s.BasicAuth == 'SharedAuthentication')
            {
                securityType = "WEP";
            }
            break;
    }
    return securityType;
}

function LoadFrame()
{
	writeResult();
}

    var standardArr = { '11a' : '802.11a', 
	                  '11b' : '802.11b', 
	                  '11g' : '802.11g', 
	                  '11n' : '802.11n', 
	                  '11bg' : '802.11b/g', 
					  '11gn' : '802.11g/n',
	                  '11bgn' : '802.11b/g/n', 
	                  '11na' : '802.11a/n', 
	                  '11ac' : '802.11a/n/ac'
	                };
					
					
function writeResult()
{
	 var index = 0;
	 if (wlanpage == '2G')
	 {
		index = 0;
		document.getElementById('wlaninfo_bssid').innerHTML = bssid_2;
		
	 }
	 if (wlanpage == '5G')
	 {
		index = 1;
		document.getElementById('wlaninfo_bssid').innerHTML = bssid_5;		
	 }

	document.getElementById('wlaninfo_ssid').innerHTML = htmlencode(WlanInfo[index].ssid);
	document.getElementById('wlaninfo_mode').innerHTML = standardArr[WlanInfo[index].X_HW_Standard];
	document.getElementById('wlaninfo_security').innerHTML = GetSecurityType(index);
	document.getElementById('wlaninfo_channel').innerHTML = WlanInfo[index].Channel;
	document.getElementById('wlaninfo_power').innerHTML = WlanInfo[index].TransmitPower;
	
	var receive_packets = PacketInfo[index].totalPacketsReceived;
	
	var receive_errors = Stats[index].errorsReceived;
	var sent_packets = PacketInfo[index].totalPacketsSent;	
	var sent_errors = Stats[index].errorsSent;
	
	document.getElementById('wlaninfo_packets_received').innerHTML = receive_packets;
	document.getElementById('wlaninfo_bytes_received').innerHTML = PacketInfo[index].totalBytesReceived;
	document.getElementById('wlaninfo_errors_received').innerHTML = receive_errors;
	document.getElementById('wlaninfo_discards_received').innerHTML = Stats[index].discardPacketsReceived;
	
	document.getElementById('wlaninfo_packets_sent').innerHTML = sent_packets;
	document.getElementById('wlaninfo_bytes_sent').innerHTML = PacketInfo[index].totalBytesSent;
	document.getElementById('wlaninfo_errors_sent').innerHTML = sent_errors;
	document.getElementById('wlaninfo_discards_sent').innerHTML = Stats[index].discardPacketsSent;
	
	var error_percentage_received = 0.00;
	var error_percentage_sent = 0.00;
	if (receive_packets != 0)
	{
		error_percentage_received = receive_errors * 100 / receive_packets;
	}

	if (sent_packets != 0)
	{
		error_percentage_sent = sent_errors * 100 / sent_packets;
	}
	document.getElementById('wlaninfo_errorper_received').innerHTML = error_percentage_received.toFixed(2);
	document.getElementById('wlaninfo_errorper_sent').innerHTML = error_percentage_sent.toFixed(2);
}

function stAssociatedWlanDevice(domain,AssociatedDeviceMACAddress,X_HW_Uptime){
	this.domain = domain;
	this.AssociatedDeviceMACAddress = AssociatedDeviceMACAddress;
	this.X_HW_Uptime = X_HW_Uptime;
}

var associatedDevice = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}.AssociatedDevice.{i},AssociatedDeviceMACAddress|X_HW_Uptime,stAssociatedWlanDevice,STATUS);%>
var connectedDevices = [];

function GetSsidFreq(name)
{
	var SSIDList = GetSSIDList();
	var freq = "";

	for(var i=0;i<SSIDList.length;i++){
		if(SSIDList[i].name == name){
			return  SSIDList[i].freq;
		}
	}
}

function isMathWlanFreq(name)
{
	var freq = GetSsidFreq(name);

	if (wlanpage == '5G')
	{
		if(freq == "5GHz")
		{
			return true;
		}
	}
	else
	{
		if(freq == "2.4GHz")
		{
			return true;
		}
	}

	return false;
}


function getConnectedTimeByMacAddress(childArray,UserDevices){
	for(var i=0;i<childArray.length-1;i++){

		for(var j=0;j<UserDevices.length-1;j++){			
			if((UserDevices[j].DevStatus != "Online") || (UserDevices[j].PortType != "WIFI") || (true != isMathWlanFreq(UserDevices[j].Port))){
					continue;}

			if(childArray[i].AssociatedDeviceMACAddress.toUpperCase() == UserDevices[j].MacAddr.toUpperCase()){
				var theDevice = UserDevices[j];
				theDevice.X_HW_Uptime = childArray[i].X_HW_Uptime;
				this.connectedDevices.push(theDevice);
				break;
			}
		}
	}
	
	this.connectedDevices.push(null);
}

function initLeaseTable(connectedDevices){
	$('#leaseTable tbody').html('');
	var leaseTable = '';
	if (connectedDevices.length <= 1){
		return;
	}
	$('#connectNumber').text((connectedDevices.length - 1)+" "+cfg_wlaninfomation_tdevivo_language["bbsp_connected_devices"])
	for(var i=0;i< connectedDevices.length - 1;i++){
		if(i%2==0){
			leaseTable += '<tr>'
			+'<td class="cinza" title="' + htmlencode(connectedDevices[i].HostName) +'">'+GetStringContent(htmlencode(connectedDevices[i].HostName), 20)+'</td>'
			+'<td class="cinza">'+connectedDevices[i].MacAddr+'</td>'
			+'<td class="cinza">'+connectedDevices[i].IpAddr+'</td>'
			+'<td class="cinza">'+Math.floor(parseInt(connectedDevices[i].X_HW_Uptime, 10)/60)+' min</td>'
			'</tr>';
		}else{
			leaseTable += '<tr>'
			+'<td class="cinza2" title="' + htmlencode(connectedDevices[i].HostName) +'">'+GetStringContent(htmlencode(connectedDevices[i].HostName), 20)+'</td>'
			+'<td class="cinza2">'+connectedDevices[i].MacAddr+'</td>'
			+'<td class="cinza2">'+connectedDevices[i].IpAddr+'</td>'
			+'<td class="cinza2">'+Math.floor(parseInt(connectedDevices[i].X_HW_Uptime, 10)/60)+' min</td>'
			'</tr>';
		}
			
	}
	$('#leaseTable tbody').html(leaseTable);
}

$(document).ready(function(){
	GetLanUserDevInfo(function(para){			
		getConnectedTimeByMacAddress(this.associatedDevice,para);
		initLeaseTable(this.connectedDevices);
	});	
});
</script>

</head>	
<body  class="mainbody" onLoad="LoadFrame();"> 
<div class = "clear"/>
<div class = "tab" id="tab-03" style = "display:block;" width = "100%">
	<div id="tabela_esquerdaDSL" >
		<table class = "setupWifiTable width-hpna">
			<tbody>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_ssid"></td>
					<td class = "cinza center" id = "wlaninfo_ssid" name = "wlaninfo_ssid"></td>
				</tr>
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_mode"></td>
					<td class = "cinza2 center" id = "wlaninfo_mode" name = "wlaninfo_mode"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_security"></td>
					<td class = "cinza center" id = "wlaninfo_security" name = "wlaninfo_security"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="tabela_direitaDSL">
		<table class = "setupWifiTable width-hpna">
			<tbody>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_channel"></td>
					<td class = "cinza center" id = "wlaninfo_channel" name = "wlaninfo_channel"></td>
				</tr>
				
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_power"></td>
					<td class = "cinza2 center" id = "wlaninfo_power" name = "wlaninfo_power"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_bssid"></td>
					<td class = "cinza center" id = "wlaninfo_bssid" name = "wlaninfo_bssid"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="tabela_esquerdaDSL">
		<table class = "setupWifiTable width-hpna" >
			<thead>
				<th colspan="2"  BindText="amp_wlaninfo_vivo_packet_received"></th>
			</thead>
			<thead>
				<tr>
					<th class = "no-up" width = "240" BindText="amp_wlaninfo_vivo_statistics"></th>
					<th class = "no-up" BindText="amp_wlaninfo_vivo_value"></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_packets"></td>
					<td class = "cinza center" id = "wlaninfo_packets_received" name = "wlaninfo_packets_received"></td>
				</tr>
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_bytes"></td>
					<td class = "cinza2 center" id = "wlaninfo_bytes_received" name = "wlaninfo_bytes_received"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_errors"></td>
					<td class = "cinza center" id = "wlaninfo_errors_received" name = "wlaninfo_errors_received"></td>
				</tr>
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_discards"></td>
					<td class = "cinza2 center" id = "wlaninfo_discards_received" name = "wlaninfo_discards_received"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_errors_perc"></td>
					<td class = "cinza center" id = "wlaninfo_errorper_received" name = "wlaninfo_errorper_received"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="tabela_direitaDSL">
		<table class = "setupWifiTable width-hpna">
			<thead>
				<th class = "no-up" colspan="2" BindText="amp_wlaninfo_vivo_packet_sent"/>
			</thead>
			<thead>
				<tr>
					<th class = "no-up" width = "240" BindText="amp_wlaninfo_vivo_statistics"/>
					<th class = "no-up" BindText="amp_wlaninfo_vivo_value"/>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_packets"></td>
					<td class = "cinza center" id = "wlaninfo_packets_sent" name = "wlaninfo_packets_sent"></td>
				</tr>
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_bytes"></td>
					<td class = "cinza2 center" id = "wlaninfo_bytes_sent" name = "wlaninfo_bytes_sent"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_errors"></td>
					<td class = "cinza center" id = "wlaninfo_errors_sent" name = "wlaninfo_errors_sent"></td>
				</tr>
				<tr>
					<td class = "cinza2" BindText="amp_wlaninfo_vivo_discards"></td>
					<td class = "cinza2 center" id = "wlaninfo_discards_sent" name = "wlaninfo_discards_sent"></td>
				</tr>
				<tr>
					<td class = "cinza" BindText="amp_wlaninfo_vivo_errors_perc"></td>
					<td class = "cinza center" id = "wlaninfo_errorper_sent" name = "wlaninfo_errorper_sent"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id="tabela_leaseTable">
		<table id="leaseTable" class="setupWifiTable">
			<thead>
				<tr>
					<th colspan="4"><span id="connectNumber" BindText="bbsp_connected_device"></span></th>
				</tr>
				<tr>
					<th BindText="bbsp_wifi_hostName"></th>
					<th BindText="bbsp_wifi_macAddress"></th>
					<th BindText="bbsp_wifi_ipAddress"></th>
					<th BindText="bbsp_wifi_connectedTime"></th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table>
	</div>
</div>

<script type="text/javascript">
ParseBindTextByTagName(cfg_wlaninfomation_tdevivo_language, "div",  1);
ParseBindTextByTagName(cfg_wlaninfomation_tdevivo_language, "td",  1);
ParseBindTextByTagName(cfg_wlaninfomation_tdevivo_language, "th",  1);
ParseBindTextByTagName(cfg_wlaninfomation_tdevivo_language, "span",  1);
</script>
</body>
</html>

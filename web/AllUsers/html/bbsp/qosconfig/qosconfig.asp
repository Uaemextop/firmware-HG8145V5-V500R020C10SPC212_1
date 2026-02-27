<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta name="format-detection" content="telephone=no"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<title>Intelligent Channel</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="JavaScript" type="text/javascript">

var MaxQosSmartRule = 64;
var MaxPolicerRule = 16;
var OperatorFlag = 0;
var selIndex = -1;

var DisplayControl = <% HW_WEB_GetFeatureSupport(BBSP_FT_MODIFY_PRI_OR_TC);%>;
var TableName = "QosSmartConfigList";
var PolicerTableName = "PolicerConfigList";

function PortName2Domain(Name)
{
    if(Name.length == 0)
    {
        return '';
    }
     
    var Num = Name.charAt(Name.length - 1);
	
	if(Name.indexOf("LAN") >= 0)
	{
		return  "InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig." + Num;
	}
	else
	{
		return  "InternetGatewayDevice.LANDevice.1.WLANConfiguration." + Num;
	}
    
    
}


function appendPrompt(filedName)
{   
    return qos_config_language[filedName]+qos_config_language['bbsp_qosPrompt'];
}


function LanDomain2LanName(Domain)
{
	if(Domain == undefined)
	{
		return '';
	}
    if(Domain.length == 0)
    {
        return '';
    }
    
    var EthNum = Domain.charAt(Domain.length - 1);
    
    return  "LAN" + EthNum;
}

function SsidDomain2SsidName(Domain)
{
	if(Domain == undefined)
	{
		return '';
	}
    if(Domain.length == 0)
    {
        return '';
    }
    
    var SsidNum = Domain.charAt(Domain.length - 1);
    
    return  "SSID" + SsidNum;
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
		b.innerHTML = qos_config_language[b.getAttribute("BindText")];
	}
}



function TopoInfo(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

function QosSmartEnableInfo(_Domain,  _QosSmartEnableValue, _X_HW_Bandwidth )
{
    this.Domain = _Domain;
	this.QosSmartEnableValue = _QosSmartEnableValue;
    this.X_HW_Bandwidth = _X_HW_Bandwidth;
}

function QosSmartItem(_Domain, _X_HW_Dircetion, _ClassInterface, _DestIP, _DestMask, _SourceIP, _SourceMask, _Protocol, _DestPort, _DestPortRangeMax, _SourcePort, _SourcePortRangeMax, _DSCPMark, _VLANIDCheck, _EthernetPriorityMark,_X_HW_OutHardwareQueue,_ClassPolicer,_SrcMAC,_DestMAC)
{
	this.Domain = _Domain;
	this.X_HW_Dircetion =_X_HW_Dircetion;
    this.ClassInterface = _ClassInterface;
    this.DestIP = _DestIP;
    this.DestMask = _DestMask;
    this.SourceIP = _SourceIP;
    this.SourceMask = _SourceMask;
    this.Protocol = _Protocol;
    this.DestPort = _DestPort;
    this.DestPortRangeMax = _DestPortRangeMax;
    this.SourcePort = _SourcePort;
    this.SourcePortRangeMax = _SourcePortRangeMax;    
    this.DSCPMark = _DSCPMark;
    this.VLANIDCheck = _VLANIDCheck;
    this.EthernetPriorityMark = _EthernetPriorityMark;
	this.X_HW_OutHardwareQueue = _X_HW_OutHardwareQueue;
	this.ClassPolicer = _ClassPolicer;		

	this.SrcMAC = _SrcMAC;
	this.DestMAC = _DestMAC
}

function QosSmartRateItem(_Domain, _CommittedRate, _PeakRate, _Enable)
{
     this.Domain = _Domain;
	 this.CommittedRate = _CommittedRate;
	 this.PeakRate    =_PeakRate;
	 this.Enable = _Enable;
}

function QosSmartRateDisp(_Domain, _Index, _CommittedRate, _PeakRate, _Enable)
{
     this.Domain = _Domain;
	 this.index = _Index;
	 this.CommittedRate = _CommittedRate;
	 this.PeakRate    =_PeakRate;
	 this.Enable = _Enable;
}

function QosApplicationItem(_Name, _Protocol, _ExternalPort, _ExternalPortEnd, _InternalPort, _InternalPortEnd)
{
	 this.Name = _Name;
	 this.Protocol = _Protocol
	 this.ExternalPort = _ExternalPort;
	 this.ExternalPortEnd =_ExternalPortEnd;
	 this.InternalPort = _InternalPort;
	 this.InternalPortEnd = _InternalPortEnd;
}

function QosAppNameItem(_Domain, _Name, _Type)
{
     this.Domain = _Domain;
	 this.Name = _Name;
	 this.Type = _Type;
}

function QosAppPortItem(_Domain, _Protocol, _ExternalPort, _ExternalPortEnd, _InternalPort, _InternalPortEnd)
{
     this.Domain = _Domain;
	 this.Protocol = _Protocol
	 this.ExternalPort = _ExternalPort;
	 this.ExternalPortEnd =_ExternalPortEnd;
	 this.InternalPort = _InternalPort;
	 this.InternalPortEnd = _InternalPortEnd;
}


var QosSmartList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement.Classification.{i},X_HW_Dircetion|ClassInterface|DestIP|DestMask|SourceIP|SourceMask|Protocol|DestPort|DestPortRangeMax|SourcePort|SourcePortRangeMax|DSCPMark|VLANIDCheck|EthernetPriorityMark|X_HW_OutHardwareQueue|ClassPolicer|SourceMACAddress|DestMACAddress, QosSmartItem);%>  

var QosSmartRate = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement.Policer.{i},CommittedRate|PeakRate|PolicerEnable, QosSmartRateItem);%>

var QosSmartBandList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement, Enable|X_HW_Bandwidth, QosSmartEnableInfo);%>

var QosAppNameTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_Application.{i}, Name|Type , QosAppNameItem);%>

var QosAppPortList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_Application.{i}.Content.{i}, Protocol|ExternalPort|ExternalPortEnd|InternalPort|InternalPortEnd, QosAppPortItem);%>

var AppInst = 0;

var AppQosTypeBit = 4; 

var QosAppNameList = new Array();

for(var i = 0 ; i < QosAppNameTemp.length - 1 ; i++)
{
	if( 0 != ( AppQosTypeBit & parseInt(QosAppNameTemp[i].Type,10) ) )
	{
		QosAppNameList[AppInst] = QosAppNameTemp[i];
		AppInst++;
	}
}

var QosAppList = new Array();

QosAppList[0] = new QosApplicationItem(qos_config_language['bbsp_hostName_select'],"","","","","");

var AppIndex = 1;

for(var i = 0 ; i < QosAppNameList.length ; i++)
{
	for( var j = 0 ; j < QosAppPortList.length - 1 ; j++)
	{
		if( QosAppPortList[j].Domain.split('.')[3] == QosAppNameList[i].Domain.split('.')[3] )
		{
			QosAppList[AppIndex] = new QosApplicationItem();
			if( 1 == QosAppPortList[j].Domain.split('.')[5] )
			{
				QosAppList[AppIndex].Name =  QosAppNameList[i].Name ;
			}
			else
			{
				QosAppList[AppIndex].Name =  QosAppNameList[i].Name + QosAppPortList[j].Domain.split('.')[5] ;
			}
			
			QosAppList[AppIndex].Protocol = QosAppPortList[j].Protocol;
			QosAppList[AppIndex].ExternalPort = QosAppPortList[j].ExternalPort;
			QosAppList[AppIndex].ExternalPortEnd = QosAppPortList[j].ExternalPortEnd;
			QosAppList[AppIndex].InternalPort = QosAppPortList[j].InternalPort;
			QosAppList[AppIndex].InternalPortEnd = QosAppPortList[j].InternalPortEnd;
			AppIndex++;
		}
	}
}

var QosSmartBand = QosSmartBandList[0];
var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfo);%>;
var TopoInfo = TopoInfoList[0];
TopoInfo.EthNum = '<%GetLanPortNum();%>';

var ListLength = QosSmartList.length-1;



var LANhostIP = new Array();
var LANhostName = new Array();
var MACaddress = new Array();

LANhostIP[0] = "";
LANhostName[0] = qos_config_language['bbsp_hostName_select'];
MACaddress[0] = "";

var SelectIP = "";

function setlanhostnameip(UserDevices)
{
	var UserDevicesnum = UserDevices.length - 1;

	for (var i = 0, j = 1; i < UserDevicesnum; i++)
	{
		
			if ("--" != UserDevices[i].HostName)
			{
				LANhostName[j] = htmlencode(UserDevices[i].HostName);
				LANhostIP[j] = UserDevices[i].IpAddr;
				MACaddress[j] = UserDevices[i].MacAddr;
				j++;
			}
			else
			{	
				LANhostName[j] = UserDevices[i].MacAddr;
				LANhostIP[j] = UserDevices[i].IpAddr;
				MACaddress[j] = UserDevices[i].MacAddr;
				j++;
			}
		
	}
}

function CreateDestMACSelectInfo()
{
	var output = '';
	for (i = 0; i < LANhostName.length; i++)
	{	
		output = '<option value=' + i + ' id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>';
		$("#DestMACSelect").append(output);
	} 		
}

function CreateSrcMACSelectInfo()
{
	var output = '';
	for (i = 0; i < LANhostName.length; i++)
	{
		output = '<option value=' + i + ' id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>';
		$("#SrcMACSelect").append(output);
	} 	
}

function CreateDestIPSelectInfo()
{
	var output = '';
	for (i = 0; i < LANhostName.length; i++)
	{
		output = '<option value=' + i + ' id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>';
		$("#DestIPSelect").append(output);
	} 	
}

function CreateSrcIPSelectInfo()
{
	var output = '';
	for (i = 0; i < LANhostName.length; i++)
	{
		output = '<option value=' + i + ' id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>';
		$("#SrcIPSelect").append(output);
	} 	
}

function CreateAppPortSelectInfo()
{
	var output = '';
	for (i = 0; i < QosAppList.length; i++)
	{
		output = '<option value=' + i + ' id="' + htmlencode(QosAppList[i].Name) + '">' + htmlencode(QosAppList[i].Name) + '</option>';
		$("#AppPortSelect").append(output);
	} 	
}

function setInitValue()
{
	setSelect('DestMACSelect', '0');
	setSelect('SrcMACSelect', '0');
	setSelect('DestIPSelect', '0');
	setSelect('SrcIPSelect', '0');
	setSelect('AppPortSelect', '0');
	
	if( 1 == QosAppList.length)
	{
		setDisplay('AppPortSelect', 0);
		setDisplay('AppPortExchange', 0);
	}
}

function SrcMACChange()
{
	setText('SrcMAC',MACaddress[getSelectVal('SrcMACSelect')]);
}

function DestMACChange()
{
	setText('DestMAC',MACaddress[getSelectVal('DestMACSelect')]);
}

function DestIPChange()
{
	setText('DestIP',LANhostIP[getSelectVal('DestIPSelect')]);
	if( "" != LANhostIP[getSelectVal('DestIPSelect')] )
	{
		setText('DestMask',"255.255.255.255");
	}
	else
	{
		setText('DestMask',"");
	}
}

function SrcIPChange()
{
	setText('SourceIP',LANhostIP[getSelectVal('SrcIPSelect')]);
	if( "" != LANhostIP[getSelectVal('SrcIPSelect')] )
	{
		setText('SourceMask',"255.255.255.255");
	}
	else
	{
		setText('SourceMask',"");
	}
}

function AppPortChange()
{
	var AppProtocol = QosAppList[getSelectVal('AppPortSelect')].Protocol;
	
	if( "TCP" == AppProtocol.toUpperCase())
	{
		setText('Protocol',"6");
	}
	else if( "UDP" == AppProtocol.toUpperCase())
	{
		setText('Protocol',"17");
	}
	else
	{
		setText('Protocol',"");
	}
	
	setText('DestPort',QosAppList[getSelectVal('AppPortSelect')].ExternalPort);
	setText('DestPortRangeMax',QosAppList[getSelectVal('AppPortSelect')].ExternalPortEnd);
	setText('SourcePort',QosAppList[getSelectVal('AppPortSelect')].InternalPort);
	setText('SourcePortRangeMax',QosAppList[getSelectVal('AppPortSelect')].InternalPortEnd);
}

function AppyPortExchange()
{
	var DPort = getSelectVal('DestPort');
	var DPortEnd = getSelectVal('DestPortRangeMax');
	var SPort = getSelectVal('SourcePort');
	var SPortEnd = getSelectVal('SourcePortRangeMax');
	setText('DestPort',SPort);
	setText('DestPortRangeMax',SPortEnd);
	setText('SourcePort',DPort);
	setText('SourcePortRangeMax',DPortEnd);	
}

function ClassInterfaceInitOption()
{
	var InterfaceList = getElementById('ClassInterface');
	var EthNum = TopoInfo.EthNum;
	var SsidNum = TopoInfo.SSIDNum;
    var i;
    
	for(i=1; i<=EthNum;i++)
	{
	    InterfaceList.options.add(new Option('LAN' + i, PortName2Domain('LAN' + i)));
	}
	
	for(i=1; i<=SsidNum;i++)
	{
	    InterfaceList.options.add(new Option('SSID' + i, PortName2Domain('SSID' + i)));
	}
}

function DirectionInitOption()
{
	var DircetionList = getElementById('X_HW_Dircetion');
	DircetionList.options.add(new Option(qos_config_language['bbsp_inbound'], "inbound"));
	DircetionList.options.add(new Option(qos_config_language['bbsp_outbound'], "outbound"));
}

function LoadQosSmartBand()
{    
    if( QosSmartBand.X_HW_Bandwidth != '')
	{	
		setText("X_HW_Bandwidth", parseInt(QosSmartBand.X_HW_Bandwidth,10));	
	}
}

function paraCompensate()
{
	var i = 0;
	var RecordCount = QosSmartList.length - 1;
	for(i = 0; i < RecordCount; i++)
	{
		QosSmartList[i].Protocol = (QosSmartList[i].Protocol == '-1')?'':QosSmartList[i].Protocol;
	    QosSmartList[i].DestPort = (QosSmartList[i].DestPort == '-1')?'':QosSmartList[i].DestPort;
	    QosSmartList[i].DestPortRangeMax = (QosSmartList[i].DestPortRangeMax == '-1')?'':QosSmartList[i].DestPortRangeMax;
	    QosSmartList[i].SourcePort = (QosSmartList[i].SourcePort == '-1')?'':QosSmartList[i].SourcePort;
	    QosSmartList[i].SourcePortRangeMax = (QosSmartList[i].SourcePortRangeMax == '-1')?'':QosSmartList[i].SourcePortRangeMax;    
	    QosSmartList[i].VLANIDCheck = (QosSmartList[i].VLANIDCheck == '-1')?'':QosSmartList[i].VLANIDCheck;
		QosSmartList[i].X_HW_OutHardwareQueue = (QosSmartList[i].X_HW_OutHardwareQueue == '-1')?'':QosSmartList[i].X_HW_OutHardwareQueue;
		QosSmartList[i].DSCPMark = ('-1' == QosSmartList[i].DSCPMark) ? '' : QosSmartList[i].DSCPMark;
	    QosSmartList[i].EthernetPriorityMark = ('-1' == QosSmartList[i].EthernetPriorityMark) ? '' : QosSmartList[i].EthernetPriorityMark;
	}

}
	

function LoadFrame()
{	
	DirectionInitOption();
    ClassInterfaceInitOption();

	loadlanguage();	
	

	
	LoadQosSmartBand();
	paraCompensate();
	
}

function ShortFormatStr( originData)
{
     var shortData = '';
     var shortLen  = 16;
    	    
    if(originData.length <= shortLen)
    {
        shortData = originData;    	        
    }
    else
    {
        shortData = originData.substr(0, shortLen) + '...';
    }
    
    return shortData;
}

function PortDisp(StartPort, EndPort)
{
    var defaultStr = '--';
    var novalue = '';
    if (novalue == StartPort && novalue == EndPort)
    {
        return defaultStr;
    }
    if (novalue != StartPort && novalue != EndPort) 
    {
        return StartPort + '-' + EndPort;
    }
    return (StartPort == novalue)? EndPort:StartPort;
}

function InitTableData()
{
	var TableDataInfo = new Array();
	var ShowButtonFlag = true;
    var RecordCount = QosSmartList.length - 1;
    var i = 0;
	var Listlen = 0;
	
	paraCompensate();
    if (RecordCount == 0)
    {
		TableDataInfo[Listlen] = new QosSmartItem();
		TableDataInfo[Listlen].domain = '--';
		TableDataInfo[Listlen].X_HW_Dircetion = '--';
		TableDataInfo[Listlen].ClassInterface = '--';
		TableDataInfo[Listlen].VLANIDCheck = '--';
		TableDataInfo[Listlen].Protocol = '--';
		TableDataInfo[Listlen].SrcMAC = '--';
		TableDataInfo[Listlen].DestMAC = '--';
		TableDataInfo[Listlen].DestIPMask = '--';
		TableDataInfo[Listlen].SrcIPMask = '--';
		TableDataInfo[Listlen].DestPortRange = '--';
		TableDataInfo[Listlen].SrcPortRange = '--';

		HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, QosSmartConfiglistInfo, qos_config_language, null);
    	return;
    }

    for (i = 0; i < RecordCount; i++)
    {
		TableDataInfo[Listlen] = new QosSmartItem();
		
		TableDataInfo[Listlen].domain = QosSmartList[i].Domain;

		if ('' != QosSmartList[i].X_HW_Dircetion)
    	{
			TableDataInfo[Listlen].X_HW_Dircetion = QosSmartList[i].X_HW_Dircetion;
    	}
    	else
    	{
			TableDataInfo[Listlen].X_HW_Dircetion = '--';
    	}
		
    	if ('' != QosSmartList[i].ClassInterface && QosSmartList[i].ClassInterface.indexOf("WLANConfiguration") >= 0)
    	{
			TableDataInfo[Listlen].ClassInterface = SsidDomain2SsidName(QosSmartList[i].ClassInterface);
    	}
		else if('' != QosSmartList[i].ClassInterface)
		{
			TableDataInfo[Listlen].ClassInterface = LanDomain2LanName(QosSmartList[i].ClassInterface);
		}
    	else
    	{
			TableDataInfo[Listlen].ClassInterface = '--';
    	}
    	
    	if ('' != QosSmartList[i].VLANIDCheck)
    	{
			TableDataInfo[Listlen].VLANIDCheck = QosSmartList[i].VLANIDCheck;
    	}
    	else
    	{
			TableDataInfo[Listlen].VLANIDCheck = '--';
    	}
    	
    	if ('' != QosSmartList[i].Protocol)
    	{
			TableDataInfo[Listlen].Protocol = QosSmartList[i].Protocol;
    	}
    	else
    	{
			TableDataInfo[Listlen].Protocol = '--';
    	}		
						
		if ('' != QosSmartList[i].DestMAC)
    	{
			TableDataInfo[Listlen].DestMAC = QosSmartList[i].DestMAC;
    	}
    	else
    	{
			TableDataInfo[Listlen].DestMAC = '--';
    	}
				
		if ('' != QosSmartList[i].SrcMAC)
    	{
			TableDataInfo[Listlen].SrcMAC = QosSmartList[i].SrcMAC;
    	}
    	else
    	{
			TableDataInfo[Listlen].SrcMAC = '--';
    	}

    	
    	if ('' != QosSmartList[i].DestIP)
    	{  	
    		TableDataInfo[Listlen].DestIPMask = ShortFormatStr(QosSmartList[i].DestIP) + '/\n' + ShortFormatStr(QosSmartList[i].DestMask);
		}
    	else
    	{
			TableDataInfo[Listlen].DestIPMask = '--';
    	}
    	
    	if ('' != QosSmartList[i].SourceIP)
    	{       	    
			TableDataInfo[Listlen].SrcIPMask = ShortFormatStr(QosSmartList[i].SourceIP) + '/\n' + ShortFormatStr(QosSmartList[i].SourceMask);
    	}
    	else
    	{
			TableDataInfo[Listlen].SrcIPMask = '--';
    	} 

		
		
		TableDataInfo[Listlen].DestPortRange = PortDisp(QosSmartList[i].DestPort, QosSmartList[i].DestPortRangeMax);
		TableDataInfo[Listlen].SrcPortRange = PortDisp(QosSmartList[i].SourcePort, QosSmartList[i].SourcePortRangeMax);

		Listlen++;
    }
    TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, QosSmartConfiglistInfo, qos_config_language, null);

	for (var i = 0; i < RecordCount; i++)
	{
		var DestIPMaskId = 'QosSmartConfigList_' + i +'_5';
		if ('' != QosSmartList[i].SourceIP)
		{
			document.getElementById(DestIPMaskId).title = htmlencode(QosSmartList[i].DestIP + '/' + QosSmartList[i].DestMask);
		}
		
		var SrcIPMaskId = 'QosSmartConfigList_' + i +'_6';
		if ('' != QosSmartList[i].SourceIP)
		{
			document.getElementById(SrcIPMaskId).title = htmlencode(QosSmartList[i].SourceIP + '/' + QosSmartList[i].SourceMask);
		}
	}
}



function InitPolicerTableData()
{
	var TableDataInfo = new Array();
	var ShowButtonFlag = true;
    var RecordCount = QosSmartRate.length - 1;
    var i = 0;
	var Listlen = 0;

    if (RecordCount == 0)
    {
		TableDataInfo[Listlen] = new QosSmartRateDisp();
		TableDataInfo[Listlen].domain = '--';
		TableDataInfo[Listlen].index = '--';
		TableDataInfo[Listlen].CommittedRate = '--';
		TableDataInfo[Listlen].PeakRate = '--';
		TableDataInfo[Listlen].Enable = '--';

		HWShowTableListByType(1, PolicerTableName, ShowButtonFlag, 5, TableDataInfo, PolicerConfiglistInfo, qos_config_language, null);
    	return;
    }

    for (i = 0; i < RecordCount; i++)
    {
		TableDataInfo[Listlen] = new QosSmartRateDisp();
		
		TableDataInfo[Listlen].domain = QosSmartRate[i].Domain;
		TableDataInfo[Listlen].index = QosSmartRate[i].Domain.split('.')[3];
		
		

		if ('' != QosSmartRate[i].CommittedRate)
    	{
			TableDataInfo[Listlen].CommittedRate = parseInt(QosSmartRate[i].CommittedRate/1000,10);
    	}
    	else
    	{
			TableDataInfo[Listlen].CommittedRate = '--';
    	}
		
		if ('' != QosSmartRate[i].PeakRate)
    	{
			TableDataInfo[Listlen].PeakRate = parseInt(QosSmartRate[i].PeakRate/1000,10);
    	}
    	else
    	{
			TableDataInfo[Listlen].PeakRate = '--';
    	}
		
		if('0' == QosSmartRate[i].Enable )
		{
			TableDataInfo[Listlen].Enable = qos_config_language['bbsp_policerdisable'];;
		}
		else
		{
			TableDataInfo[Listlen].Enable = qos_config_language['bbsp_policerenable'];;
		}
		
		Listlen++;
    }
    TableDataInfo.push(null);
	HWShowTableListByType(1, PolicerTableName, ShowButtonFlag, 5, TableDataInfo, PolicerConfiglistInfo, qos_config_language, null);
}

function GetInputRuleInfo()
{
 var qosSmartItem = new QosSmartItem("",getSelectVal("X_HW_Dircetion"),getSelectVal("ClassInterface"),getValue("DestIP"),
                                     getValue("DestMask"),getValue("SourceIP"),getValue("SourceMask"),
                                     getValue("Protocol"), getValue("DestPort"),getValue("DestPortRangeMax"),
                                     getValue("SourcePort"), getValue("SourcePortRangeMax"),
                                     getValue("DSCPMark"),getValue("VLANIDCheck"),getValue("EthernetPriorityMark"),
                                     getSelectVal("X_HW_OutHardwareQueue"),getValue("ClassPolicer"),getValue("SrcMAC"),getValue("DestMAC")); 

 return qosSmartItem;
}

function GetInputRuleInfo1()
{
	var qosSmartRate = new QosSmartRateItem("",getValue("CommittedRate"),getValue("PeakRate"),getCheckVal("Enable")); 

	return qosSmartRate;
}

function SetInputRuleInfo(QosSmartItem)
{
    setSelect("X_HW_Dircetion", QosSmartItem.X_HW_Dircetion); 
    setSelect("ClassInterface", QosSmartItem.ClassInterface); 
	setText("VLANIDCheck", QosSmartItem.VLANIDCheck);
	setText("Protocol", QosSmartItem.Protocol);

	setText("DestMAC", QosSmartItem.DestMAC);
    setText("SrcMAC", QosSmartItem.SrcMAC);
    setText("DestIP", QosSmartItem.DestIP);
    setText("DestMask", QosSmartItem.DestMask);
	setText("SourceIP", QosSmartItem.SourceIP);
    setText("SourceMask", QosSmartItem.SourceMask);
	
	setText("DestPort", QosSmartItem.DestPort);
    setText("DestPortRangeMax", QosSmartItem.DestPortRangeMax); 

    setText("SourcePort", QosSmartItem.SourcePort);
    setText("SourcePortRangeMax", QosSmartItem.SourcePortRangeMax);
    setText("DSCPMark", QosSmartItem.DSCPMark);

	setText("EthernetPriorityMark",QosSmartItem.EthernetPriorityMark);  
	if( QosSmartItem.ClassPolicer == '-1' || QosSmartItem.ClassPolicer == '0')
	{
		setText("ClassPolicer","");
	}
	else
	{
		setText("ClassPolicer",QosSmartItem.ClassPolicer);
	}
	
	setSelect("X_HW_OutHardwareQueue", QosSmartItem.X_HW_OutHardwareQueue);

}



function OnNewInstance(index)
{
   OperatorFlag = 1;

   var qossmartitem = new QosSmartItem("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "-1", "", "", "");
	  
   document.getElementById("TableConfigInfo").style.display = "block";

   SetInputRuleInfo(qossmartitem);
}

function ModifyInstance(index)
{
    OperatorFlag = 2;

    document.getElementById("TableConfigInfo").style.display = "block";

    SetInputRuleInfo(QosSmartList[index]);
	
}


function OnNewPolicer(index)
{
	OperatorFlag = 1;

	var qossmartrateitem =new QosSmartRateItem("","","");

	document.getElementById("PolicerConfigInfo").style.display = "block";

	setText("CommittedRate",'');

	setText("PeakRate",'');	
	
	setCheck("Enable",0);	
}

function ModifyPolicer(index)
{
	OperatorFlag = 2;

    document.getElementById("PolicerConfigInfo").style.display = "block";
	
	if (QosSmartRate[index].CommittedRate != '')
	{
	  setText("CommittedRate", parseInt(QosSmartRate[index].CommittedRate/1000,10));
	}
	else
	{
	  setText("CommittedRate",'');
	}
    if (QosSmartRate[index].PeakRate != '')
	{
	  setText("PeakRate", parseInt(QosSmartRate[index].PeakRate/1000,10));
	}
    else
	{
	  setText("PeakRate",'');
	}
	
	setCheck("Enable", QosSmartRate[index].Enable);
}

function setControl(index , LineId)
{ 
	var TableId = LineId.split('_')[0];
	
	if( TableId == TableName)
	{
		if (-1 == index)
		{
			if (QosSmartList.length-1 == MaxQosSmartRule)
			{
				var tableRow = getElementById(TableName);
				tableRow.deleteRow(tableRow.rows.length-1);
				AlertEx(qos_config_language['bbsp_qossmartfull']);
				return false;
			}
		}
		
		selIndex = index;
		if (index < -1)
		{
			return;
		}

		if (-1 == index)
		{        
			return OnNewInstance(index);
		}
		else
		{
			return ModifyInstance(index);
		}		
	}
	else if( TableId == PolicerTableName)
	{
		if (-1 == index)
		{
			if (QosSmartRate.length-1 == MaxPolicerRule)
			{
				var tableRow = getElementById(TableId);
				tableRow.deleteRow(tableRow.rows.length-1);
				AlertEx(qos_config_language['bbsp_qossmartfull']);
				return false;
			}
		}
		
		selIndex = index;
		if (index < -1)
		{
			return;
		}

		if (-1 == index)
		{        
			return OnNewPolicer(index);
		}
		else
		{	
			return ModifyPolicer(index);
		}		
	}
}

function IsRepeateConfig(RuleInfo)
{
    var i = 0;
    for(i = 0; i < QosSmartList.length-1; i++)
    {
        if (i != selIndex)
        {	
           if ((QosSmartList[i].ClassInterface == RuleInfo.ClassInterface)
			    && (QosSmartList[i].X_HW_Dircetion == RuleInfo.X_HW_Dircetion)
                && (QosSmartList[i].VLANIDCheck == RuleInfo.VLANIDCheck)           
                && (QosSmartList[i].Protocol == RuleInfo.Protocol)
                && (QosSmartList[i].DestIP == RuleInfo.DestIP)
                && (QosSmartList[i].DestMask == RuleInfo.DestMask)
                && (QosSmartList[i].SourceIP == RuleInfo.SourceIP)
                && (QosSmartList[i].SourceMask == RuleInfo.SourceMask)
                && (QosSmartList[i].DestPort == RuleInfo.DestPort)
                && (QosSmartList[i].DestPortRangeMax == RuleInfo.DestPortRangeMax)
                && (QosSmartList[i].SourcePort == RuleInfo.SourcePort)
				&& (QosSmartList[i].SrcMAC == RuleInfo.SrcMAC)
				&& (QosSmartList[i].DestMAC == RuleInfo.DestMAC)
                && (QosSmartList[i].SourcePortRangeMax == RuleInfo.SourcePortRangeMax))
            {
                return true;
            }        
        }
    }
    return false;
}

function IPV6IpCheck(Address, Mask)
{
    if (Address != "")
    {
	    if (IsIPv6AddressValid(Address) == false || IsIPv6ZeroAddress(Address) == true || IsIPv6LoopBackAddress(Address) == true || IsIPv6MulticastAddress(Address) == true)
        {
            return 4;
        }
    }
    if ((Mask != '') && ( isValidIPV6SubnetMask(Mask) == false) )
    {            
        return 5;
    }
    return 6;
}

function IPV4IpCheck(Address, Mask)
{
    if(Address != "")
    {
        if ( isAbcIpAddress(Address) == false 
            || isDeIpAddress(Address) == true 
            || isBroadcastIpAddress(Address) == true 
            || isLoopIpAddress(Address) == true ) 
        {              	
            return 1;
        }
    }	 	  

    if ((Mask != '') && ( isValidSubnetMask(Mask) == false) )
    {            
        return 2;
    }

    return 3;
}

function IpValidCheck(RuleInfo)
{  
    var v4DipCheckRet = 0; 
    var v6DipCheckRet = 0; 
    if ((RuleInfo.DestIP == '') && (RuleInfo.DestMask == '') 
        && (RuleInfo.SourceIP == '') && (RuleInfo.SourceMask == ''))
    {
        return true;
    }
    
    if (((RuleInfo.DestIP == '') && (RuleInfo.DestMask != ''))
       || ((RuleInfo.SourceIP == '') && (RuleInfo.SourceMask != '')))
    {
        AlertEx(qos_config_language['bbsp_ipneed']);
	    return false;
    }
    
    v4DipCheckRet = IPV4IpCheck(RuleInfo.DestIP, RuleInfo.DestMask );
    v6DipCheckRet = IPV6IpCheck(RuleInfo.DestIP, RuleInfo.DestMask);
    
    if ((RuleInfo.DestIP != '') && (3 != v4DipCheckRet) && (6 != v6DipCheckRet))
    {
        if ((1 == v4DipCheckRet) && (4 == v6DipCheckRet))
        {
            AlertEx(qos_config_language['bbsp_ipaddress'] + RuleInfo.DestIP + qos_config_language['bbsp_alert_invail']);
        }
        if (((2 == v4DipCheckRet) && (4 == v6DipCheckRet))
            ||((1 == v4DipCheckRet) && (5 == v6DipCheckRet)))
        {
            AlertEx(qos_config_language['bbsp_mask'] + RuleInfo.DestMask + qos_config_language['bbsp_alert_invail']);
        }
        
	    return false;
    }

	var v4SipCheckRet = 0;
	var v6SipCheckRet = 0;

	v4SipCheckRet = IPV4IpCheck(RuleInfo.SourceIP, RuleInfo.SourceMask );
    v6SipCheckRet = IPV6IpCheck(RuleInfo.SourceIP, RuleInfo.SourceMask);
    
    if ((RuleInfo.SourceIP != '')  && (3 != v4SipCheckRet) && (6 != v6SipCheckRet))
    {
        if ((1 == v4SipCheckRet) && (4 == v6SipCheckRet))
        {
            AlertEx(qos_config_language['bbsp_ipaddress'] + RuleInfo.SourceIP + qos_config_language['bbsp_alert_invail']);
        }
        if (((2 == v4SipCheckRet) && (4 == v6SipCheckRet))
            ||((1 == v4SipCheckRet) && (5 == v6SipCheckRet)))
        {
            AlertEx(qos_config_language['bbsp_mask'] + RuleInfo.SourceMask + qos_config_language['bbsp_alert_invail']);
        }
        
	    return false;
    }
    
    if ((RuleInfo.SourceIP != '') && (RuleInfo.DestIP != ''))
    {
        if ((3 == v4DipCheckRet ) && (6 == v6SipCheckRet))
        {
            AlertEx(qos_config_language['bbsp_alert_ipaddr_v4_v6_not_match']);
	        return false;
        }

        if ((6 == v6DipCheckRet)  && (3 == v4SipCheckRet))
        {
            AlertEx(qos_config_language['bbsp_alert_ipaddr_v4_v6_not_match']);
	        return false;
        } 
    } 
        
	return true;
}

function PortCheck(Protocol, StartPort, EndPort)
{	
	if ((StartPort == '') && (EndPort == ''))
	{
	    return true;
	}
	
	if ((Protocol != 6) && (Protocol != 17))
	{
	    AlertEx(qos_config_language['bbsp_port_protocol_not_match']);
        return false;
	}
	
	if ((StartPort != "") && (false == CheckNumber(StartPort, 1, 65535)))
    {
        AlertEx(qos_config_language['bbsp_port'] + StartPort + qos_config_language['bbsp_alert_invail']);
        return false;
    }
    
    if ((EndPort != "") && (false == CheckNumber(EndPort, 1, 65535)))
    {
        AlertEx(qos_config_language['bbsp_port'] + EndPort + qos_config_language['bbsp_alert_invail']);
        return false;
    }
    
    if (parseInt(StartPort, 10) > parseInt(EndPort, 10))
    {
        AlertEx(qos_config_language['bbsp_portrangeinvalid']);
        return false;
    }

	return true;
}

function MACValidCheck(RuleInfo)
{	
    if (RuleInfo.SrcMAC != '' && isValidMacAddress1(RuleInfo.SrcMAC) == false ) 
    {
        AlertEx(qos_config_language['bbsp_themac'] + RuleInfo.SrcMAC + qos_config_language['bbsp_macisinvalid']);
        return false;
    }
	if (RuleInfo.DestMAC != '' && isValidMacAddress1(RuleInfo.DestMAC) == false ) 
    {
        AlertEx(qos_config_language['bbsp_themac'] + RuleInfo.DestMAC + qos_config_language['bbsp_macisinvalid']);
        return false;
    }
}



function CheckForm(RuleInfo)
{
	if ((RuleInfo.VLANIDCheck != "") && (false == CheckNumber(RuleInfo.VLANIDCheck, 1, 4094)))
    {
        AlertEx(qos_config_language['bbsp_vlanidinvalid']);
        return false;
    }
 
	if ((RuleInfo.Protocol != "") && (false == CheckNumber(RuleInfo.Protocol, 0, 255)))
    {
        AlertEx(qos_config_language['bbsp_protocolidinvalid']);
        return false;
    }
	
	if(false == MACValidCheck(RuleInfo))
	{
        return false;
    }
    	

	if(false == IpValidCheck(RuleInfo))
	{
        return false;
    }
    

	if(false == PortCheck(RuleInfo.Protocol, RuleInfo.DestPort, RuleInfo.DestPortRangeMax))
    {
        return false;
    }
    
	if(false == PortCheck(RuleInfo.Protocol, RuleInfo.SourcePort, RuleInfo.SourcePortRangeMax))
    {
        return false;
    }
    
	if ((RuleInfo.DSCPMark != "") && (false == CheckNumber(RuleInfo.DSCPMark, 0, 63)))
    {
        AlertEx(qos_config_language['bbsp_dscpidinvalid']);
        return false;
    }
	

   	if ((RuleInfo.EthernetPriorityMark != "") && (false == CheckNumber(RuleInfo.EthernetPriorityMark, 0, 7)))
    {
        AlertEx(qos_config_language['bbsp_802idinvalid']);
        return false;
    }

    return true;
}


function FillupSubmitPara(Form, RuleInfo)
{
	Form.addParameter('x.X_HW_Dircetion', getSelectVal("X_HW_Dircetion"));

    if(RuleInfo.ClassInterface.length)
    {
        Form.addParameter('x.ClassInterface', RuleInfo.ClassInterface);
    }
    else
    {
    	Form.addParameter('x.ClassInterface', '');
    }
	
	if (RuleInfo.SrcMAC.length)
    {
        Form.addParameter('x.SourceMACAddress', RuleInfo.SrcMAC);
    } 
    else
    {
    	Form.addParameter('x.SourceMACAddress', '');
    }
	
	if (RuleInfo.DestMAC.length)
    {
        Form.addParameter('x.DestMACAddress', RuleInfo.DestMAC);
    } 
    else
    {
    	Form.addParameter('x.DestMACAddress', '');
    }  
	
    
    if (RuleInfo.DestIP.length)
    {
        Form.addParameter('x.DestIP', RuleInfo.DestIP);
    } 
    else
    {
    	Form.addParameter('x.DestIP', '');
    }  
    if (RuleInfo.DestMask.length)
    {
        Form.addParameter('x.DestMask', RuleInfo.DestMask);
    }
    else
    {
    	Form.addParameter('x.DestMask', '');
    }
    if (RuleInfo.SourceIP.length)
    {
        Form.addParameter('x.SourceIP', RuleInfo.SourceIP);
    }
    else
    {
    	Form.addParameter('x.SourceIP', '');
    }
    if (RuleInfo.SourceMask.length)
    {
        Form.addParameter('x.SourceMask', RuleInfo.SourceMask);
    }
    else
    {
    	Form.addParameter('x.SourceMask', '');
    }
    if (!RuleInfo.Protocol.length)
    {
        RuleInfo.Protocol = -1;
    }
    Form.addParameter('x.Protocol', RuleInfo.Protocol);
    
    if (!RuleInfo.DestPort.length)
    {
    	RuleInfo.DestPort = -1;        
    }
    Form.addParameter('x.DestPort', RuleInfo.DestPort);
    
    if (!RuleInfo.DestPortRangeMax.length)
    {
        RuleInfo.DestPortRangeMax = -1;
    }
    Form.addParameter('x.DestPortRangeMax', RuleInfo.DestPortRangeMax);
    
    if (!RuleInfo.SourcePort.length)
    {
        RuleInfo.SourcePort = -1;
    }
    Form.addParameter('x.SourcePort', RuleInfo.SourcePort);
    
    if (!RuleInfo.SourcePortRangeMax.length)
    {
        RuleInfo.SourcePortRangeMax = -1; 
    }
    Form.addParameter('x.SourcePortRangeMax', RuleInfo.SourcePortRangeMax);
    
    if (RuleInfo.DSCPMark.length)
    {
        Form.addParameter('x.DSCPMark', RuleInfo.DSCPMark);
    }
	else
	{
		Form.addParameter('x.DSCPMark', -1);
	}
	
	Form.addParameter('x.EthernetPriorityMark', ('' == RuleInfo.EthernetPriorityMark) ? -1 : RuleInfo.EthernetPriorityMark);
    
    if(!RuleInfo.VLANIDCheck.length)
    {
        RuleInfo.VLANIDCheck = -1;
    }
    Form.addParameter('x.VLANIDCheck', RuleInfo.VLANIDCheck);
    
	if(RuleInfo.X_HW_OutHardwareQueue.length)
    {
        Form.addParameter('x.X_HW_OutHardwareQueue', RuleInfo.X_HW_OutHardwareQueue);
    }
    else
    {
    	Form.addParameter('x.X_HW_OutHardwareQueue', -1);
    }

    if(!RuleInfo.ClassPolicer.length)
    {
        RuleInfo.ClassPolicer = -1;
    }
    Form.addParameter('x.ClassPolicer', RuleInfo.ClassPolicer);

}

function QosSmartConfigListselectRemoveCnt()
{
}

function PolicerConfigListselectRemoveCnt()
{
}

function OnModifySubmit()
{
    var RuleInfo = GetInputRuleInfo();

    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }
    

    if (true == IsRepeateConfig(RuleInfo))
    {
        AlertEx(qos_config_language['bbsp_ruleexist']);
        return false;
    }
		
    var Form = new webSubmitForm();
	var Domain1 = "";
	
    FillupSubmitPara(Form, RuleInfo);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));   
	Domain1 ='x=' + QosSmartList[selIndex].Domain;	 
    Form.setAction('set.cgi?' +Domain1 + '&RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();

}

function OnAddNewSubmit()
{
    var RuleInfo = GetInputRuleInfo();
	var  ClassPath= '';

    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }

    if (true == IsRepeateConfig(RuleInfo))
    {
        AlertEx(qos_config_language['bbsp_ruleexist']);
        return false;
    } 

    var Form = new webSubmitForm();
    FillupSubmitPara(Form, RuleInfo);
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	ClassPath = 'x=InternetGatewayDevice.QueueManagement.Classification';
    Form.setAction('add.cgi?' + ClassPath + '&RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();
    DisableRepeatSubmit();
}


function DeleteClassicationFunc()
{
	var CheckBoxList = document.getElementsByName(TableName + 'rml');
	var Count = 0;

    var i;
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }
	
    if (Count == 0)
    {
        return false;
    }

    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++)
    {
	    var j = i+1;
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }

        Form.addParameter(CheckBoxList[i].value,'');
		
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();
	DisableRepeatSubmit();	
}

function DeletePolicerFunc()
{
	var CheckBoxList = document.getElementsByName(PolicerTableName + 'rml');
	var Count = 0;

    var i;
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }
	
    if (Count == 0)
    {
        return false;
    }

    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++)
    {
	    var j = i+1;
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }

        Form.addParameter(CheckBoxList[i].value,'');		
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();
	DisableRepeatSubmit();	
}

function OnDeleteButtonClick(LineId)
{
	var TableId = LineId.split('_')[0];
	
	if( TableId == TableName)
	{
		DeleteClassicationFunc();
	}
	else if( TableId == PolicerTableName)
	{
		DeletePolicerFunc();
	}
}


function OnApply()
{
    if (OperatorFlag == 1)
    {
        return OnAddNewSubmit();
    }
    else
    {
        return OnModifySubmit();
    }
}


function CheckRate(RuleInfo1)
{
	if (RuleInfo1.PeakRate == '' && RuleInfo1.CommittedRate !='')
    {
        AlertEx(qos_config_language['bbsp_inputpeakrate']);
       return false;
    }
    if((RuleInfo1.CommittedRate != "")&& false == CheckNumber(RuleInfo1.CommittedRate, 0, 1000000))
    { 
       AlertEx(qos_config_language['bbsp_committedrateout']);
      return false;
    }
    if((RuleInfo1.PeakRate != "")&& false == CheckNumber(RuleInfo1.PeakRate, 0, 1000000))
    { 
      AlertEx(qos_config_language['bbsp_peakrateout']);
      return false;
    }
    if((RuleInfo1.CommittedRate != "")&& (parseInt(RuleInfo1.CommittedRate,10) > parseInt(RuleInfo1.PeakRate,10)))
    { 
      AlertEx(qos_config_language['bbsp_committedoutpeak']);    
      return false;
    } 
}

function OnAddNewPolicer()
{
	var  RuleInfo1 = GetInputRuleInfo1();
	var  PolicerPath='';

	if( false == CheckRate(RuleInfo1) )
	{
		return false;
	}
	
    var Form = new webSubmitForm();

	var CommittedBurstSize =  parseInt(RuleInfo1.CommittedRate*20000,10);
	var PeakBurstSize  = parseInt(RuleInfo1.PeakRate*20000,10);
	if (CommittedBurstSize > 4294967295)
	{
	    CommittedBurstSize = 4294967295;
	}
   if (PeakBurstSize > 4294967295)
	{
	    PeakBurstSize = 4294967295;
	}
	Form.addParameter('y.CommittedRate', parseInt(RuleInfo1.CommittedRate*1000,10));
	Form.addParameter('y.CommittedBurstSize',  CommittedBurstSize);
	Form.addParameter('y.PeakRate',parseInt(RuleInfo1.PeakRate*1000,10));
    Form.addParameter('y.PeakBurstSize',  PeakBurstSize);
	Form.addParameter('y.PolicerEnable',  RuleInfo1.Enable);
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	PolicerPath   = 'y=InternetGatewayDevice.QueueManagement.Policer';
    Form.setAction('add.cgi?' + PolicerPath + '&RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();
    DisableRepeatSubmit();
}


function OnModifyPolicer()
{
    var RuleInfo1 = GetInputRuleInfo1();

	if( false == CheckRate(RuleInfo1) )
	{
		return false;
	}
		
    var Form = new webSubmitForm();
	var Domain1 = "";
	
	var CommittedBurstSize =  parseInt(RuleInfo1.CommittedRate*20000,10);
	var PeakBurstSize  = parseInt(RuleInfo1.PeakRate*20000,10);
	if (CommittedBurstSize > 4294967295)
	{
	    CommittedBurstSize = 4294967295;
	}
   if (PeakBurstSize > 4294967295)
	{
	    PeakBurstSize = 4294967295;
	}
	Form.addParameter('y.CommittedRate', parseInt(RuleInfo1.CommittedRate*1000,10));
	Form.addParameter('y.CommittedBurstSize',  CommittedBurstSize);
	Form.addParameter('y.PeakRate',parseInt(RuleInfo1.PeakRate*1000,10));
    Form.addParameter('y.PeakBurstSize',  PeakBurstSize);
	Form.addParameter('y.PolicerEnable',  RuleInfo1.Enable);
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));   
	Domain1 ='y=' +  QosSmartRate[selIndex].Domain;	 
    Form.setAction('set.cgi?' +Domain1 + '&RequestFile=html/bbsp/qosconfig/qosconfig.asp');
    Form.submit();
}

function PolicerApply()
{
	if (OperatorFlag == 1)
    {
        return OnAddNewPolicer();
    }
    else
    {
        return OnModifyPolicer();
    }
}


function PolicerCancel()
{
	getElById('PolicerConfigInfo').style.display = 'none';
    
    if (selIndex == -1)
    {
         var tableRow = getElementById(PolicerTableName);
         if (tableRow.rows.length > 2)
			tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}



function OnCancel()
{
    getElById('TableConfigInfo').style.display = 'none';
    getElById('TableConfigInfo').style.display = 'none';
    
    if (selIndex == -1)
    {
         var tableRow = getElementById(TableName);
         if (tableRow.rows.length > 2)
         tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}

function CancelBandForm()
{
	LoadQosSmartBand();
}

function SubmitBandForm()
{
	var Form = new webSubmitForm();	 
	var UpBandwidth = getValue("X_HW_Bandwidth");
	UpBandwidth = removeSpaceTrim(UpBandwidth);
	
	if(UpBandwidth!="")
	{
	   if ( false == CheckNumber(UpBandwidth, 0, 1000000) )
	   {
		 AlertEx(qos_config_language['bbsp_bandwidth_invail']);
		 return false;
	   }
	}
	else
	{
	   UpBandwidth = 0;
	}
	
    UpBandwidth = parseInt(UpBandwidth,10);

	Form.addParameter('z.X_HW_Bandwidth',UpBandwidth);     
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
    Form.setAction('set.cgi?z=InternetGatewayDevice.QueueManagement'
                        + '&RequestFile=html/bbsp/qosconfig/qosconfig.asp');
	
    Form.submit();
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">

	HWCreatePageHeadInfo("qossmarttitle", GetDescFormArrayById(qos_config_language, "bbsp_mune"), GetDescFormArrayById(qos_config_language, "bbsp_qos_smart_title"), false);

</script> 
<div class="title_spread"></div>

<div  id="divqossmart" style="overflow-x:auto;overflow-y:hidden;width:100%;">
<form id="QosBandLimitForm" style="display:block;">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
		<li   id="X_HW_Bandwidth"                 RealType="TextBox"           DescRef="bbsp_upbandlimit"       RemarkRef="bbsp_rateremark"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="z.X_HW_Bandwidth"        Elementclass="width_260px"     InitValue="Empty" />	
	</table>
	<script>
		var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
		var QosSmartEnableConfigFormList = new Array();
		QosSmartEnableConfigFormList = HWGetLiIdListByForm("QosBandLimitForm", null);
		HWParsePageControlByID("QosBandLimitForm", TableClass, qos_config_language, null);
	</script>
	
	 <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
      <tr> 
        <td class="width_per25"></td> 
        <td class="table_submit pad_left5p">
			<button id='btnBandApply' type="button" onclick = "SubmitBandForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartapp']);</script></button>
          	<button id='btnBandCancel' type="button" onclick="CancelBandForm();" class="CancleButtonCss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartcancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
	
	<div class="func_spread"></div>
</form>


<div class="func_title" BindText="bbap_bandconfigtab">
	<script>
		document.write(qos_config_language['bbap_bandconfigtab']);
	</script>
</div>

<script language="JavaScript" type="text/javascript">
	var PolicerConfiglistInfo = new Array();
	PolicerConfiglistInfo.push(new stTableTileInfo("Empty","align_center width_per3","DomainBox"));
	PolicerConfiglistInfo.push(new stTableTileInfo("bbsp_policerindex","align_center","index"));
	PolicerConfiglistInfo.push(new stTableTileInfo("bbsp_commitrate","align_center","CommittedRate"));
	PolicerConfiglistInfo.push(new stTableTileInfo("bbsp_peakrate","align_center","PeakRate"));
	PolicerConfiglistInfo.push(new stTableTileInfo("bbsp_policerstatus","align_center","Enable"));
	
	PolicerConfiglistInfo.push(new stTableTileInfo(null));
	InitPolicerTableData();
</script> 
<form id="PolicerConfigInfo" style="display:none;"> 
 <div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
		<li   id="CommittedRate"          RealType="TextBox"        DescRef="bbsp_commitrate"   RemarkRef="bbsp_rateremark"      	     ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.CommittedRate"       Elementclass="width_260px"     InitValue="Empty"    MaxLength='8'/>
		<li   id="PeakRate"               RealType="TextBox"        DescRef="bbsp_peakrate"     RemarkRef="bbsp_rateremark"   		     ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.PeakRate"        Elementclass="width_260px"     InitValue="Empty" MaxLength='8'/>
		<li   id="Enable"           	  RealType="CheckBox"       DescRef="bbsp_policerenable"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.Enable"    InitValue="Empty" />

		</table>
	    <script language="JavaScript" type="text/javascript">
		var TableClass = new stTableClass("width_per15", "width_per85", "ltr");
		var PolicerConfigFormList = new Array();
		PolicerConfigFormList = HWGetLiIdListByForm("PolicerConfigInfo", null);
		HWParsePageControlByID("PolicerConfigInfo", TableClass, qos_config_language, null);
		
		</script>
	
    <table width="100%"   border="0" cellspacing="1" cellpadding="0" class="table_button"> 
      <tr> 
        <td class="width_per25"></td> 
        <td class="table_submit pad_left5p">
			<button id='Apply' type="button" onclick = "javascript:return PolicerApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartapp']);</script></button>
          	<button id='Cancel' type="button" onclick="javascript:return PolicerCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartcancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
	
</form> 

<div class="func_spread"></div>
<div class="func_title" BindText="bbap_bandconfigtab">
	<script>
		document.write(qos_config_language['bbsp_classiconfigtab']);
	</script>
</div>

<script language="JavaScript" type="text/javascript">
	var QosSmartConfiglistInfo = new Array();
	var ColumnNum = '';
	QosSmartConfiglistInfo.push(new stTableTileInfo("Empty","align_center width_per3","DomainBox"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qosdirection","align_center","X_HW_Dircetion"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartclassinterface","align_center","ClassInterface"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartvlan","align_center","VLANIDCheck"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartprotocol","align_center","Protocol"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qosdestmac","align_center","DestMAC"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossrcmac","align_center","SrcMAC"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartdestipmask","align_center restrict_dir_ltr","DestIPMask"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartsrcipmask","align_center restrict_dir_ltr","SrcIPMask"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartdestportrange","align_center","DestPortRange"));
	QosSmartConfiglistInfo.push(new stTableTileInfo("bbsp_qossmartsrcportrange","align_center","SrcPortRange"));

	ColumnNum = 11;

	QosSmartConfiglistInfo.push(new stTableTileInfo(null));
	InitTableData();
</script> 
 
<form id="TableConfigInfo" style="display:none;"> 
 <div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
		<li   id="MatchCondition"    RealType="HorizonBar"         DescRef="bbsp_matchcondition"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="Empty"              InitValue="Empty"/>

		<li   id="X_HW_Dircetion"    RealType="DropDownList"       DescRef="bbsp_qosdirection"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.X_HW_Dircetion"    Elementclass="width_260px"     InitValue="Empty"/>
		<li   id="ClassInterface"    RealType="DropDownList"       DescRef="bbsp_qossmartclassinterface"   RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.ClassInterface"    Elementclass="width_260px"     InitValue="Empty"/>
		<li   id="VLANIDCheck"       RealType="TextBox"            DescRef="bbsp_qossmartvlan"             RemarkRef="bbsp_vlanrange"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.VLANIDCheck"       Elementclass="width_260px"     InitValue="Empty"    MaxLength='4'/>
		<li   id="Protocol"          RealType="TextBox"            DescRef="bbsp_qossmartprotocol"         RemarkRef="bbsp_protocolrange" ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Protocol"          Elementclass="width_260px"     InitValue="Empty"    MaxLength='3'/>
		
		<li   id="DestMAC"           RealType="TextOtherBox"            DescRef="bbsp_qosdestmac"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.DestMAC"           Elementclass="width_260px"     
		InitValue="[{Type:'select',Item:[{AttrName:'id',AttrValue:'DestMACSelect'},{AttrName:'class',AttrValue:'Select_2 restrict_dir_ltr'}]}]"    MaxLength='17'/>	
		
		<li   id="SrcMAC"            RealType="TextOtherBox"            DescRef="bbsp_qossrcmac"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.SrcMAC"            Elementclass="width_260px"        
		InitValue="[{Type:'select',Item:[{AttrName:'id',AttrValue:'SrcMACSelect'},{AttrName:'class',AttrValue:'Select_2 restrict_dir_ltr'}]}]"    MaxLength='17'/>

		
		<li   id="DestIP"                      RealType="TextOtherBox"       DescRef="bbsp_qossmartdestipmask"             RemarkRef="Empty"            ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.DestIP"            Elementclass="width_120px restrict_dir_ltr"         MaxLength="64" 
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'DestIPBias'},{AttrName:'innerhtml', AttrValue:'bbsp_bias'}]},
					{Type:'text',Item:[{AttrName:'id',AttrValue:'DestMask'},{AttrName:'BindFileld', AttrValue:'x.DestMask'},{AttrName:'MaxLength', AttrValue:'64'},{AttrName:'class', AttrValue:'width_120px restrict_dir_ltr'}]},
					{Type:'select',Item:[{AttrName:'id',AttrValue:'DestIPSelect'},{AttrName:'class',AttrValue:'Select_2 restrict_dir_ltr'}]}]"/>    
					
		<li   id="SourceIP"                    RealType="TextOtherBox"       DescRef="bbsp_qossmartsrcipmask"             RemarkRef="Empty"            ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.SourceIP"          Elementclass="width_120px restrict_dir_ltr"         MaxLength="64" 
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'SourceIPBias'},{AttrName:'innerhtml', AttrValue:'bbsp_bias'}]},
					{Type:'text',Item:[{AttrName:'id',AttrValue:'SourceMask'},{AttrName:'BindFileld', AttrValue:'x.SourceMask'},{AttrName:'MaxLength', AttrValue:'64'},{AttrName:'class', AttrValue:'width_120px restrict_dir_ltr'}]},					
					{Type:'select',Item:[{AttrName:'id',AttrValue:'SrcIPSelect'},{AttrName:'class',AttrValue:'Select_2 restrict_dir_ltr'}]}]"/>  
					
		<li   id="DestPort"                    RealType="TextOtherBox"       DescRef="bbsp_qossmartdestportrange"             RemarkRef="Empty"            ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.DestPort"          Elementclass="width_120px "     MaxLength="5" 
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'DestPortDash'},{AttrName:'innerhtml', AttrValue:'bbsp_dash'}]},
					{Type:'text',Item:[{AttrName:'id',AttrValue:'DestPortRangeMax'},{AttrName:'BindFileld', AttrValue:'x.DestPortRangeMax'},{AttrName:'MaxLength', AttrValue:'5'},{AttrName:'class', AttrValue:'width_120px'}]},				
					{Type:'select',Item:[{AttrName:'id',AttrValue:'AppPortSelect'},{AttrName:'class',AttrValue:'Select_2 restrict_dir_ltr'}]}]"/>  
					
		<li   id="SourcePort"                  RealType="TextOtherBox"       DescRef="bbsp_qossmartsrcportrange"             RemarkRef="Empty"            ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.SourcePort"          Elementclass="width_120px "     MaxLength="5" 
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'SourcePortDash'},{AttrName:'innerhtml', AttrValue:'bbsp_dash'}]},
					{Type:'text',Item:[{AttrName:'id',AttrValue:'SourcePortRangeMax'},{AttrName:'BindFileld', AttrValue:'x.SourcePortRangeMax'},{AttrName:'MaxLength', AttrValue:'5'},{AttrName:'class', AttrValue:'width_120px'}]},
					{Type:'Button',Item:[{AttrName:'id',AttrValue:'AppPortExchange'},{AttrName:'class',AttrValue:'ApplyButtoncss restrict_dir_ltr align_center'},{AttrName:'style', AttrValue:'cursor:default'}]}]"/>    
		
		<li   id="RemarkBar"              RealType="HorizonBar"     DescRef="bbsp_remark"               RemarkRef="Empty"                ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>

		<li   id="DSCPMark"               RealType="TextBox"        DescRef="bbsp_qossmardscpmark"      RemarkRef="bbsp_dscpremark"      ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DSCPMark"       Elementclass="width_260px"     InitValue="Empty"    MaxLength='2'  />
		<li   id="EthernetPriorityMark"   RealType="TextBox"        DescRef="bbsp_qossmartpbitmark"     RemarkRef="bbsp_8021preamrk"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.EthernetPriorityMark"        Elementclass="width_260px"     InitValue="Empty" MaxLength='2'/>
		
		<li   id="BandLimit"              RealType="HorizonBar"     DescRef="bbsp_bandlimit"    RemarkRef="Empty"              	         ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>

		<li   id="ClassPolicer"            RealType="TextBox"            DescRef="bbsp_bandtemp"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.ClassPolicer"            Elementclass="width_260px"     InitValue="Empty"    MaxLength='2'/>		
		
		<li   id="QueueConfig"            RealType="HorizonBar"     DescRef="bbsp_queueconfig"  RemarkRef="Empty"              			 ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		
		<li   id="X_HW_OutHardwareQueue"  RealType="DropDownList"   DescRef="bbsp_queuepri"     RemarkRef="Empty"      					 ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.X_HW_OutHardwareQueue"       Elementclass="width_260px"     InitValue="[{TextRef:'Prioritynull',Value:'-1'},{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]"   />	
		
		</table>
	    <script language="JavaScript" type="text/javascript">
		var TableClass = new stTableClass("width_per15", "width_per85", "ltr");
		var QosSmartConfigFormList = new Array();
		QosSmartConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		HWParsePageControlByID("TableConfigInfo", TableClass, qos_config_language, null);
		
		</script>
	
    <table width="100%"   border="0" cellspacing="1" cellpadding="0" class="table_button"> 
      <tr> 
        <td class="width_per25"></td> 
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Apply' type="button" onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartapp']);</script></button>
          	<button id='Cancel' type="button" onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(qos_config_language['bbsp_qossmartcancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
	
</form> 
<div style="height:20px;"></div>
</div>
<div style="height:20px;"></div>
<script language="JavaScript" type="text/javascript">
GetLanUserDevInfo(function(para)
{
	setlanhostnameip(para);
	CreateDestMACSelectInfo();
	CreateSrcMACSelectInfo();
	CreateDestIPSelectInfo();
	CreateSrcIPSelectInfo();
	CreateAppPortSelectInfo();
	setInitValue();
	document.getElementById("AppPortExchange").value = qos_config_language['bbsp_portexchange'];
});

getElById('DestMACSelect').onchange = function()
{
	DestMACChange();
}

getElById('SrcMACSelect').onchange = function()
{
	SrcMACChange();
}

getElById('DestIPSelect').onchange = function()
{
	DestIPChange();
}

getElById('SrcIPSelect').onchange = function()
{
	SrcIPChange();
}

getElById('AppPortSelect').onchange = function()
{
	AppPortChange();
}

getElById('AppPortExchange').onclick = function()
{
	AppyPortExchange();
}
</script>
</body>
</html>

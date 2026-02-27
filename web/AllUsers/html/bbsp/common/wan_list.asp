var isSupportSFP = "<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SFP);%>";
var CurrentUpMode = '<%HW_WEB_GetUpMode();%>';
var xdPonSupport = "<%HW_WEB_GetFeatureSupport(FT_XD_PON_SURPPORTED);%>";
var dbaa1Mode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.CurProfile.BondingProfile);%>';
var DBAA1 = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATRUE_DBAA1);%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var IsZQ = "<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>";
var isSupportPCDN = '<%HW_WEB_GetFeatureSupport(FT_PCDN_SUPPORT);%>';
var isSupportModifyCdn = '<%HW_WEB_GetFeatureSupport(FT_MODIFY_CDN);%>';
var isFjCt = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_FJCT);%>';
var isHONWanView = '<%HW_WEB_GetFeatureSupport(FT_CDN_VIEW_SUPPORT);%>';

function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName, _EtherType,_PhyPortName)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
    this.EtherType = _EtherType;
    this.PhyPortName = _PhyPortName;
}

var PolicyRouteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName|EtherType|PhyPortName,PolicyRouteItem);%>;

function GetPolicyRouteList()
{
    return PolicyRouteList;
}

var IPProtVerMode = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_IPProtocolVersion.Mode);%>;
function GetIPProtVerMode()
{
    return IPProtVerMode;
}

var CurCfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var LanWanBindList = new Array();
var AnyPortAnyServiceList = new Array();
var EthRouteList = new Array();
var PortVlanBindList = new Array();
var i=0,j=0,k=0,m=0,n=0;
for (; i < PolicyRouteList.length-1; i++)
{
    if ( ((PolicyRouteList[i].Type == "SourcePhyPort") || (PolicyRouteList[i].Type == "SourcePhyPortV6") ))
    {
        LanWanBindList[j++] = PolicyRouteList[i];
    }

    if (PolicyRouteList[i].Type == "SoureIP")
    {
        AnyPortAnyServiceList[k++] = PolicyRouteList[i];
    }

    if (PolicyRouteList[i].Type == "EtherType")
    {
        EthRouteList[m++] = PolicyRouteList[i];
    }

    if (PolicyRouteList[i].Type == "PortVlan")
    {
        PortVlanBindList[n++] = PolicyRouteList[i];
    }

}

function GetLanWanBindList()
{
    return LanWanBindList;
}
function GetLanWanBindInfo(WanName)
{
    var BindList = GetLanWanBindList();
    for (var i = 0; i < BindList.length; i++)
    {
        if (WanName == BindList[i].WanName)
        {
            return BindList[i];
        }
    }
}


function GetAnyPortAnyServiceList()
{
    return AnyPortAnyServiceList;
}
function GetEthRouteList()
{
    return EthRouteList;
}
function GetPortVlanRouteList()
{
    return PortVlanBindList;
}


function domainTowanname(domain)
{
	if((null != domain) && (undefined != domain))
	{
		var domaina = domain.split('.');
		var type = (-1 == domain.indexOf("WANIPConnection")) ? '.ppp' : '.ip' ;
		return 'wan' + domaina[2]  + '.' + domaina[4] + type + domaina[6] ;
	}
}

function waninterface(tr098wanpath, tr181interface)
{
    this.tr098wanpath = tr098wanpath;
    this.tr181interface = tr181interface;
}

function domainTowanname_if(domain)
{
    var i;
    var waninterfaces = <%HW_WEB_GetTR181WANDomain(waninterface);%>;

    for (i = 0; i < waninterfaces.length - 1; i++)
    {
        if (domain == waninterfaces[i].tr098wanpath)
        {
            return waninterfaces[i].tr181interface;
        }
    }

    return "";
}

function GetWanConnectioDevicePath(WanFullPath)
{
    var IndexOfConnction = WanFullPath.indexOf("WANIPConnection");
    if (-1 == IndexOfConnction)
    {
        IndexOfConnction = WanFullPath.indexOf("WANPPPConnection");
    }
    return WanFullPath.substr(0, IndexOfConnction-1);
}

function MakeWanNameForPTVDF(wan)
{
	var currentWanName = '';

	if (true == IsRadioWanSupported(wan))
	{
		return "Mobile";
	}

	switch (wan.ServiceList.toUpperCase())
    {
		case "INTERNET":
		case "TR069_INTERNET":
    		currentWanName = "Internet";
    		break;
    	case "VOIP":
		case "TR069_VOIP":
    		currentWanName = "VoIP";
    		break;
		case "IPTV":
		case "TR069_IPTV":
    		currentWanName = "IPTV";
    		break;
		case "TR069":
    		currentWanName = "TR069";
    		break;
		case "OTHER":
    		currentWanName = "OTHER";
    		break;
    	case "VOIP_INTERNET":
		case "TR069_VOIP_INTERNET":
    		currentWanName = "VoIP_Internet";
    		break;
		case "VOIP_IPTV":
		case "TR069_VOIP_IPTV":
			currentWanName = "VoIP_IPTV";
			break;
		case "IPTV_INTERNET":
		case "TR069_IPTV_INTERNET":
    		currentWanName = "IPTV_Internet";
    		break;
		case "VOIP_IPTV_INTERNET":
		case "TR069_VOIP_IPTV_INTERNET":
			currentWanName = "VoIP_IPTV_Internet";
			break;
    	default:
    		break;
    }

	return currentWanName;
}

function MakeWanNameForTURKCELL(wan) {
    var currentWanName = '';

    switch (wan.ServiceList.toUpperCase()) {
        case "IPTV":
            currentWanName = "WAN_IPTV";
            break;
        case "TR069_VOIP_INTERNET":
            currentWanName = "WAN_INTERNET";
            break;
        default:
            if(IsXdProduct()) {
                currentWanName = MakeDefaultWanNameForXD(wan);
            } else {
                currentWanName = MakeDefaultWanName(wan);
            }
            break;
    }

    return currentWanName;
}

var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var IsTDE2Mode   = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var CurCfgModeWord ='<%HW_WEB_GetCfgMode();%>';

function MakeDefaultWanNameForXD(Wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
	var linktype = '';
	var pvc = '';
	
    wanInst = Wan.MacId;
    wanServiceList  = Wan.ServiceList.toUpperCase();
    wanMode         = (Wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = Wan.VlanId;
	pvc             = Wan.DestinationAddress;
	
	if(Wan.WanAccessType == 'DSL')
	{
		linktype = "ADSL";
	}
	else if(Wan.WanAccessType == 'VDSL')
	{
		linktype = "VDSL";
	}
	else if(Wan.WanAccessType == 'Ethernet')
	{
		linktype = "GE";
	}
	else if(Wan.WanAccessType == 'SFP' && 1 == isSupportSFP)
	{
		linktype = "SFP";
	}
	
    if (true == IsRadioWanSupported(Wan)) {
        if (DBAA1 == '1'){
            currentWanName = "INTERNET_MOBILE";
        } else {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + RADIOWAN_NAMEPREFIX + "_VID_";
        }
    } else {
    	if(linktype == "ADSL")
    	{
    		if (0 != parseInt(vlanId))
		    {
		        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype + "_" + pvc + "_VID_" + vlanId;
		    }
		    else
		    {
		        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype  + "_" + pvc;
		    }
    	}
    	else
    	{
			if ((CurCfgModeWord.toUpperCase() == "DTURKCELL2WIFI") || (CurCfgModeWord.toUpperCase() == 'TURKCELL2'))
			{
				if (4095 != parseInt(vlanId))
				{
					currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype + "_VID_" + vlanId;
				}
				else
				{
					currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype + "_VID_";
				}
			}
			else
			{
				if (0 != parseInt(vlanId))
				{
					currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype + "_VID_" + vlanId;
				}
				else
				{
					currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + linktype + "_VID_";
				}
			}
		 }
    }

    return currentWanName;
}


function MakeDefaultWanName(wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';

    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;

    if ((CurCfgModeWord.toUpperCase() == "GSCMCC_RMS") && (wanServiceList == "OTHER")) {
        wanServiceList = "IPTV";
    }

    if (IsRadioWanSupported(wan) == true) {
        currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
    } else if (CurCfgModeWord.toUpperCase() == 'TURKCELL2') {
        if (parseInt(vlanId) != 4095) {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
        } else {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
        }
    } else {
        if (parseInt(vlanId) != 0) {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
        } else {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
        }
    }

    return currentWanName;
}

function MakeGdgdWanName(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
    
    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    
    if (wanServiceList == 'INTERNET') {
        wanServiceList = "eRouter";
    } else if (wanServiceList == 'VOIP') {
        wanServiceList = "eMTA";
    } else if (wanServiceList == 'TR069_IPTV') {
        wanServiceList = "eSTB";
    }
    
    wanMode = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId = wan.VlanId;
    
    if (IsRadioWanSupported(wan) == true) {
        currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
    } else {
        if (parseInt(vlanId) != 0) {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
        } else {
            currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
        }
    }
    
    return currentWanName;
}

function MakeWanNameHiddenVlan(wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';

    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    if (!IsAdminUser())
    {
        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode;
    }
    else
    {
        currentWanName = MakeDefaultWanName(wan);
    }
    return currentWanName;     
}
function MakeWanNameForQtelMTN(wan)
{
	var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';
    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase();
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;

	if (true == IsRadioWanSupported(wan))
	{
		currentWanName = "Mobile";
	}
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }
    }

    return currentWanName;
}

function MakeWanNameForPCCW(wan)
{
	var currentWanName = '';
	var wanInst = 0;
	var wanMode = '';

	wanInst = wan.MacId;
	wanMode = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
	if(true == IsRadioWanSupported(wan))
	{
		currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
	else
	{
		wanMode = (wan.Mode == 'IP_Routed' ) ? "Route" : "Bridge";
		currentWanName = wanInst + "_" + wanMode + "_" + "WAN";
	}

	return currentWanName;
}

function MakeWanNameForVoice(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';

    wanInst = wan.MacId;
    wanServiceList  = wan.ServiceList.toUpperCase().replace(new RegExp(/(VOIP)/g),"VOICE");
    if (wanServiceList == "HQOS") {
        wanServiceList = "HQoS";
    }
    if (wanServiceList == "D_BUS") {
        wanServiceList = "D_Bus";
    }
    wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;

	if (true == IsRadioWanSupported(wan))
	{
		currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }
    }

    return currentWanName;
}

function MakeWanNameForA8C(wan)
{
	var wanServiceList = '';
	wanServiceList  = wan.ServiceList.toUpperCase();
	wanMode         = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.VlanId;
	var currentWanName = '';
	wanInst = wan.MacId;
	
	switch(wanServiceList)
	{
		case "INTERNET":
			wanServiceList = "Internet";
			break;
		case "VOIP":
			wanServiceList = "Voice";
			break;
		case "IPTV":
			wanServiceList = "iTV";
			break;
		case "TR069":
			wanServiceList = "Management";
			break;
		case "OTHER":
			wanServiceList = "Other";
			break;
		case "TR069_INTERNET":
			wanServiceList = "Management_Internet";
			break;
		case "TR069_VOIP":
			wanServiceList = "Management_Voice";
			break;
		case "VOIP_INTERNET":
			wanServiceList = "Voice_Internet";
			break;
		case "TR069_VOIP_INTERNET":
			wanServiceList = "Management_Voice_Internet";
			break;
		case "VOIP_IPTV":
			wanServiceList = "Voice_iTV";
			break;
		case "TR069_IPTV":
			wanServiceList = "Management_iTV";
			break;
		case "TR069_VOIP_IPTV":
			wanServiceList = "Management_Voice_iTV";
			break;
		case "IPTV_INTERNET":
			wanServiceList = "iTV_Internet";
			break;
		case "VOIP_IPTV_INTERNET":
			wanServiceList = "Voice_iTV_Internet";
			break;
		case "TR069_IPTV_INTERNET":
			wanServiceList = "Management_iTV_Internet";
			break;
		case "TR069_VOIP_IPTV_INTERNET":
			wanServiceList = "Management_Voice_iTV_Internet";
			break;
		default:
			break;
	}
	

    if (0 != parseInt(vlanId))
	{
	    currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_" + vlanId;
	}
	    else
	{
	    currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_";
    }  
	
	return currentWanName;
}

function KeepWanDefaultName()
{
    if (["TRIPLETAP", "TRIPLETAPNOGM", "TRIPLETAP6", "TRIPLETAP6PAIR", "CHILEWOM2"].indexOf(CfgModeWord.toUpperCase()) >= 0) {
        return true;
    }

    return false;
}

function MakeWanName_New(wan)
{
	var currentWanName = '';
	var Layer2Feature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_SERVICELIST_BY_LAYER2);%>";
	var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
	var CfgModePCCWHK = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PCCW);%>";
	var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
	var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
	var CurrentBin = '<%HW_WEB_GetBinMode();%>';
	var IsCUMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_CU);%>';
	var SingtelMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SINGTEL);%>';
	var RosUnionMode = '<%HW_WEB_GetFeatureSupport(FT_ROS_UNION);%>';
	var gdgdWanName = '<%HW_WEB_GetFeatureSupport(FT_SUPPORT_EXCHANGE_NAME_WAN);%>';
	
    if ("AIS" == CfgModeWord.toUpperCase() && wan.Name != '')
    {
        return wan.Name;
    }

    if (KeepWanDefaultName() && (wan.Name != '')) {
        return wan.Name;
    }

	if ((SingtelMode == '1') && wan.Name != '')
    {
        return wan.Name;
    }
	
	if(RosUnionMode == '1') {
		currentWanName = wan.Name;
	} 

	if(IsCmProduct())
	{
		return wan.Name;
	}
	
	if(wan.Name.indexOf("OLT") >= 0)
	{
		return MakeDefaultWanName(wan);
	}

	if (IsTDE2Mode == "1")
	{
		currentWanName = wan.Name;
		if (currentWanName == "")
		{
			 currentWanName = "untag";
		}
		return currentWanName
	}

	if("1" == Layer2Feature)
	{
		if(RosUnionMode == '1') {
			return currentWanName;
		}else{
			return MakeDefaultWanName(wan);
		}
	}

	if ('1' == IsPTVDFMode)
	{
		currentWanName = MakeWanNameForPTVDF(wan);
	} else if (CfgModeWord.toUpperCase() == "TURKCELL2") {
        currentWanName = MakeWanNameForTURKCELL(wan);
    }
	else if("1" == CfgModePCCWHK)
	{
		currentWanName = MakeWanNameForPCCW(wan);
	}
	else if('QTEL' == CurCfgModeWord.toUpperCase() || 'MTN2' == CurCfgModeWord.toUpperCase())
	{
		currentWanName = MakeWanNameForQtelMTN(wan);
	}
	else if(("0" == CUVoiceFeature) && ('1' == IsCUMode))
	{
	    currentWanName = MakeDefaultWanName(wan);
	}
	else if('E8C' == CurrentBin.toUpperCase() || "1" == CUVoiceFeature)
	{
		currentWanName = MakeWanNameForVoice(wan);
    }
    else if ((1 == IsZQ) && (CurrentBin.toUpperCase() == 'A8C'))
    {
       currentWanName = MakeWanNameForA8C(wan);
    }
	else if(IsXdProduct())
	{
		if(RosUnionMode == '1') {
			currentWanName = currentWanName;
		}else{
			currentWanName = MakeDefaultWanNameForXD(wan);
		}
	}
	else
	{
		currentWanName = MakeDefaultWanName(wan);
	}
	
    if (CfgModeWord.toUpperCase() == "TELECENTRO")
    {
        currentWanName = MakeWanNameHiddenVlan(wan);
    }

    if (gdgdWanName == "1") {
        currentWanName = MakeGdgdWanName(wan);
    }

	return currentWanName;
}

function MakeWanName(wan)
{
    return MakeWanName_New(wan);
}

function MakeWanName1(wan)
{
    return MakeWanName_New(wan);
}

function MakeMegacableWanName(wan) {
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';

    wanInst = wan.MacId;
    wanServiceList = wan.ServiceList.toUpperCase();
    wanMode  = (wan.Mode == 'IP_Routed' ) ? "R" : "B";
    vlanId = wan.VlanId;

    if (IsRadioWanSupported(wan) == true) {
        currentWanName = wanInst + "_" + RADIOWAN_NAMEPREFIX + "_" + wanServiceList + "_" + wanMode;
    } else {       
        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode;
    }

    return currentWanName;
}

function MakeWanName_Megacable(wan) {
    var currentWanName = '';
    if (wan.Name.indexOf("OLT") >= 0) {
        return MakeMegacableWanName(wan);
    }
    currentWanName = MakeMegacableWanName(wan);
    return currentWanName;
}

function MakeWanNameForMC(wan) {
    return MakeWanName_Megacable(wan);
}

function WlanISPSSID(domain, SSID, EnableUserId, UserId)
{
    this.domain = domain;
    this.SSID = SSID;
    this.EnableUserId = EnableUserId;
    this.UserId = UserId;
}

try
{
var ISPSSIDList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i},SSID_IDX|EnableUserId|UserId,WlanISPSSID);%>;
}
catch(e)
{
var ISPSSIDList = new Array(null);
}
function stWlanInfo(domain,name,X_HW_ServiceEnable,enable,bindenable)
{
    this.domain = domain;
    this.name = name;
    this.X_HW_ServiceEnable = X_HW_ServiceEnable;
    this.enable = enable;
    this.bindenable = bindenable;
}
var WlanInfo = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|X_HW_ServiceEnable|Enable,stWlanInfo);%>';
if (WlanInfo.length > 0)
{
	WlanInfo = eval(WlanInfo);
}
else
{
	WlanInfo = new Array(null);
}

function GetSSIDNameIndex(index)
{
	for ( i = 0 ; i < WlanInfo.length - 1 ; i++ )
	{
	var domain = WlanInfo[i].domain.split('.');
		if(domain[domain.length-1] == index)
		{
			  return parseInt(WlanInfo[i].name.charAt(WlanInfo[i].name.length-1));
		}
	}
}
function GetISPSSIDList()
{
    var ISPPortList = new Array();
    var ssid_i = new Array();

    for(var j = 0; j < ISPSSIDList.length - 1; j++)
    {
        ssid_i = ISPSSIDList[j].SSID;
        ISPPortList.push('SSID' + ssid_i);

    }
    return ISPPortList;
}

function BindWhichWan(BindList, Port)
{
    for (var i in BindList)
    {
        if(BindList[i].PhyPortName.toUpperCase().indexOf(Port.toUpperCase()) >= 0)
            return BindList[i].WanName;
    }

    return '';
}

function GetISPWanList(BindList, PortList)
{
    var WanList = new Array();

    for(var port in PortList)
    {
        var Wan = BindWhichWan(BindList, PortList[port]);
        if(Wan.length != 0)
        {
            if(ArrayIndexOf(WanList, Wan) < 0)
                WanList.push(Wan);
        }
    }

    if(IsVnpt())
	{
		if(ArrayIndexOf(WanList, "wan1.7.ip1") < 0)
			WanList.push("wan1.7.ip1");

		if(ArrayIndexOf(WanList, "wan1.7.ppp1") < 0)
			WanList.push("wan1.7.ppp1");

		if(ArrayIndexOf(WanList, "wan1.8.ip1") < 0)
			WanList.push("wan1.8.ip1");

		if(ArrayIndexOf(WanList, "wan1.8.ppp1") < 0)
			WanList.push("wan1.8.ppp1");
	}


    return WanList;
}

function ArrayIndexOf(List, Value){
    for(var i in List)
    {
        if(List[i] == Value)
            return i;
    }
    return -1;
}

try
{
    function GetISPWanOnlyRead()
	{
		if(typeof(__GetISPWanOnlyRead) == 'function'){

			return __GetISPWanOnlyRead();
		}
		else
		{
			return false;
		}
	}



	var ISPWanList =  new Array();
	if(typeof(GetLanWanBindList) == 'function'){

		ISPWanList = GetISPWanList(GetLanWanBindList(), GetISPSSIDList());
	}
	GetISPPortList = function(){return GetISPSSIDList();};
	IsWanHidden = function(interface){if(ArrayIndexOf(ISPWanList, interface) >= 0){return true;}else{return false;}}

	IsWanMustHidden = function(interface) { return (!GetISPWanOnlyRead()) && IsWanHidden(interface);}
}
catch(e)
{
	GetISPPortList = function(){return new Array();};
	IsWanHidden = function(interface){return false;};
}

var WanList = new Array();

var Tr069WanOnlyRead = <%HW_WEB_GetFeatureSupport("BBSP_FT_TR069_WAN_ONLY_READ");%>;
var WanstatistcsRead = '<%HW_WEB_GetFeatureSupport(BBSP_FT_WAN_STATISTICS);%>';

var IPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i},X_HW_VXLAN_Enable|ConnectionTrigger|MACAddress|ConnectionStatus|LastConnectionError|X_HW_RemoteWanInfo|Name|Enable|X_HW_LanDhcpEnable|X_HW_IPForwardList|ConnectionStatus|ConnectionType|AddressingType|ExternalIPAddress|SubnetMask|DefaultGateway|NATEnabled|X_HW_NatType|DNSServers|X_HW_VLAN|X_HW_MultiCastVLAN|X_HW_PRI|X_HW_VenderClassID|X_HW_ClientID|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_TR069FLAG|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable|X_HW_IPv6MultiCastVLAN|X_HW_PriPolicy|X_HW_DefaultPri|MaxMTUSize|X_HW_DHCPLeaseTime|X_HW_NTPServer|X_HW_TimeZoneInfo|X_HW_SIPServer|X_HW_StaticRouteInfo|X_HW_VendorInfo|X_HW_DHCPLeaseTimeRemaining|Uptime|DNSOverrideAllowed|X_HW_LowerLayers|X_HW_IPoEName|X_HW_IPoEPassword|X_HW_IGMPEnable|X_HW_DscpToPbitTbl|X_HW_2nd_IPAddress|X_HW_2nd_SubnetMask|X_HW_3rd_IPAddress|X_HW_3rd_SubnetMask|X_HW_NPTv6Enable|X_HW_SpeedLimit_UP|X_HW_SpeedLimit_DOWN|X_HW_LteProfile|X_HW_CU_IPForwardModeEnabled, WanIP);%>;

var PPPWanList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i},X_HW_VXLAN_Enable|ConnectionTrigger|MACAddress|ConnectionStatus|LastConnectionError|X_HW_RemoteWanInfo|Name|Enable|X_HW_LanDhcpEnable|X_HW_IPForwardList|ConnectionStatus|ConnectionType|ExternalIPAddress|DefaultGateway|NATEnabled|X_HW_NatType|DNSServers|Username|Password|ConnectionTrigger|X_HW_ConnectionControl|X_HW_VLAN|X_HW_MultiCastVLAN|X_HW_PRI|X_HW_LcpEchoReqCheck|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_TR069FLAG|IdleDisconnectTime|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable|X_HW_IPv6MultiCastVLAN|X_HW_PriPolicy|X_HW_DefaultPri|MaxMRUSize|PPPoEACName|X_HW_IdleDetectMode|Uptime|DNSOverrideAllowed|X_HW_LowerLayers|PPPoESessionID|X_HW_IGMPEnable|X_HW_StaticRouteInfo|X_HW_DscpToPbitTbl|X_HW_HURL|X_HW_MOTM|X_HW_BridgeEnable|X_HW_NPTv6Enable|X_HW_SpeedLimit_UP|X_HW_SpeedLimit_DOWN|X_HW_CU_IPForwardModeEnabled, WanPPP);%>;

var IPDSLiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_IPv6.DSLite,WorkMode|AFTRName,DsLiteInfo);%>;
var PPPDSLiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_IPv6.DSLite,WorkMode|AFTRName,DsLiteInfo);%>;

var IP6RDTunnelList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayIPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_6RDTunnel,Enable|RdMode|RdPrefix|RdPrefixLen|RdBRIPv4Address|RdIPv4MaskLen,GetIpWan6RDTunnelInfo);%>;

var PPP6RDTunnelList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayPPPWAN, InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_6RDTunnel,Enable|RdPrefix|RdPrefixLen|RdBRIPv4Address|RdIPv4MaskLen,GetPppWan6RDTunnelInfo);%>;

var RadioWanParaList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaRadioWanPara, InternetGatewayDevice.X_HW_Radio_WAN.{i},Username|APN|DialNumber|TriggerMode,RadioWanClass);%>;

var RadioWanPSList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaRadioWanPs, InternetGatewayDevice.X_HW_RadioWanPS.{i}, Enable|SwitchMode|SwitchDelayTime|PingIP|Radio_WAN_Index ,RadioWanPSClass);%>;

var TDEIPWanIPv6AddressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i},X_HW_UnnumberedModel|X_HW_TDE_IPv6AddressingType|X_HW_DHCPv6ForAddress,TDEIPWanIPv6AddressClass);%>;
var TDEPPPWanIPv6AddressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}, X_HW_UnnumberedModel|X_HW_TDE_IPv6AddressingType|X_HW_DHCPv6ForAddress,TDEPPPWanIPv6AddressClass);%>;

var TDEIPDelegationEnabled = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}, X_HW_E8C_IPv6PrefixDelegationEnabled, TDE_IP_DelegationEnabledClass);%>;

var TDEPPPDelegationEnabled = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}, X_HW_E8C_IPv6PrefixDelegationEnabled, TDE_PPP_DelegationEnabledClass);%>;
var WanEthIPStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i}.Stats,EthernetBytesSent|EthernetBytesReceived|EthernetPacketsSent|EthernetPacketsReceived|EthernetUnicastPacketsSent|EthernetUnicastPacketsReceived|EthernetMulticastPacketsSent|EthernetMulticastPacketsReceived|EthernetBroadcastPacketsSent|EthernetBroadcastPacketsReceived|X_HW_EthernetBytesSentHigh|X_HW_EthernetBytesSentLow|X_HW_EthernetBytesReceivedHigh|X_HW_EthernetBytesReceivedLow|X_HW_UpstreamBitrate|X_HW_DownstreamBitrate,WaninfoStats);%>;
var WanEthPPStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.Stats,EthernetBytesSent|EthernetBytesReceived|EthernetPacketsSent|EthernetPacketsReceived|EthernetUnicastPacketsSent|EthernetUnicastPacketsReceived|EthernetMulticastPacketsSent|EthernetMulticastPacketsReceived|EthernetBroadcastPacketsSent|EthernetBroadcastPacketsReceived|X_HW_EthernetBytesSentHigh|X_HW_EthernetBytesSentLow|X_HW_EthernetBytesReceivedHigh|X_HW_EthernetBytesReceivedLow|X_HW_UpstreamBitrate|X_HW_DownstreamBitrate,WaninfoStats);%>;

var DSLLinkConfigList =  <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANDSLLinkConfig, LinkType|DestinationAddress|ATMEncapsulation|ATMQoS|ATMPeakCellRate|ATMMaximumBurstSize|ATMSustainableCellRate, LinkConfig);%>;

var unnumberdIPInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_UnnumberedIP,Enable|IPAddress|SubnetMask,UnnumberdIPInfoClass);%>;

var SingtelModeEX = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SINGTEL_EX);%>';


var RadioWanBackup = "";
var RadioWanProfile = "";

function getWanBackupInfo() {
    var xmlhttp = CreateXMLHttp();
    xmlhttp.onreadystatechange = function(){
        if (xmlhttp.readyState == 4) {
            if (xmlhttp.status == 200) {
                RadioWanBackup = eval(xmlhttp.responseText);
            }
        }
    }
    xmlhttp.open('POST','/html/bbsp/common/ltebackupinfo.asp', false);
    xmlhttp.send(null); 
}

function getWanDialInfo() {
    var xmlhttp = CreateXMLHttp();
    xmlhttp.onreadystatechange = function(){
        if (xmlhttp.readyState == 4) {
            if (xmlhttp.status == 200) {
                RadioWanProfile = eval(xmlhttp.responseText);
            }
        }
    }
    xmlhttp.open('POST','/html/bbsp/common/ltedialinfo.asp', false);
    xmlhttp.send(null); 
}

function GetRadioWanProfileArray()
{
    getWanDialInfo();
    return RadioWanProfile;
}

if (isSupportLte == 1) {
   getWanBackupInfo();
   getWanDialInfo();
}

var ProductType = '<%HW_WEB_GetProductType();%>';
function IsXdProduct()
{
	return '2'==ProductType;
}

function IsXdUpMode() {
    return '2' == ProductType && CurrentUpMode != 1;
}

function IsXdPonUpMode() {
    return '2' == ProductType && CurrentUpMode == 1;
}

function IsCmProduct()
{
	return '3'==ProductType;
}

var DSLWanInstance = "";
var VDSLWanInstance = "";
var ETHWanInstance = "";
var SFPWanInstance = "";
var UMTSWanInstance = "";
var PonWanInstance = 6;

var AccessTypeList =  <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANCommonInterfaceConfig, WANAccessType, AccessType);%>;

for(var i = 0 ; i < AccessTypeList.length-1 ; i++)
{
    if( "DSL" == AccessTypeList[i].WANAccessType )
    {
        DSLWanInstance = AccessTypeList[i].domain.split(".")[2] ;
    }
    else if( "VDSL" == AccessTypeList[i].WANAccessType )
    {
        VDSLWanInstance = AccessTypeList[i].domain.split(".")[2];
    }
    else if( "Ethernet" == AccessTypeList[i].WANAccessType )
    {
        ETHWanInstance = AccessTypeList[i].domain.split(".")[2];
    }
    else if("SFP" == AccessTypeList[i].WANAccessType)
    {
        SFPWanInstance = AccessTypeList[i].domain.split(".")[2];
    }
    else if( "UMTS" == AccessTypeList[i].WANAccessType )
    {
        UMTSWanInstance = AccessTypeList[i].domain.split(".")[2];
    }
    else if( "PON" == AccessTypeList[i].WANAccessType )
    {
        PonWanInstance = AccessTypeList[i].domain.split(".")[2];
    }
}

function NeedFixupUmtsWan() 
{
    return ((UMTSWanInstance == "") && (IsXdProduct() || isSupportLte == "1"));
}

if (NeedFixupUmtsWan()) {
    var DEFAULT_WAN_DEVICE_INST = 1;
    UMTSWanInstance = DEFAULT_WAN_DEVICE_INST;
}

function GetWanInstByWanAceesstype(wanAccesstype)
{
    if( "DSL" == wanAccesstype )
    {
        return DSLWanInstance;
    }
    else if( "VDSL" == wanAccesstype )
    {
        return VDSLWanInstance;
    }
    else if( "Ethernet" == wanAccesstype )
    {
        return ETHWanInstance;
    }
    else if( "SFP" == wanAccesstype )
    {
        return SFPWanInstance;
    }
    else if( "UMTS" == wanAccesstype )
    {
        return UMTSWanInstance;
    } 
    else if( "PON" == wanAccesstype )
    {
        return PonWanInstance;
    } 
    return 1;
}

function GetWanAceesstypeByWanInst(Inst)
{
    if( DSLWanInstance == Inst )
    {
        return "DSL" ;
    }
    else if( VDSLWanInstance == Inst )
    {
        return "VDSL";
    }
    else if( ETHWanInstance == Inst )
    {
        return "Ethernet";
    }
    else if( SFPWanInstance == Inst && 1 == isSupportSFP)
    {
        return "SFP";
    }
    else if( UMTSWanInstance == Inst )
    {
        return "UMTS";
    }
    else if( PonWanInstance == Inst )
    {
        return "PON";
    }
    return null;
}

function GetPVCIsInUsedWANConnectionDeviceInst(Wan)
{
	for (var i = 0; i < GetWanList().length; i++)
	{
		if (GetWanList()[i].DestinationAddress == Wan.DestinationAddress)
		{
			return GetWanList()[i].domain.split(".")[4];
		}
	}
	
	return null;
}

function GetVdslIsInUsedWANConnectionDeviceInst(Wan)
{
    for (var i = 0; i < GetWanList().length; i++)
    {
        if (GetWanList()[i].domain.split(".")[2] == "2")
        {
            return GetWanList()[i].domain.split(".")[4];
        }
    }

    return null;
}

function GetEthIsInUsedWANConnectionDeviceInst(Wan)
{
    for (var i = 0; i < GetWanList().length; i++)
    {
        if (GetWanList()[i].domain.split(".")[2] == ETHWanInstance) {
            return GetWanList()[i].domain.split(".")[4];
        }
    }

    return null;
}

function GetSfpIsInUsedWANConnectionDeviceInst(Wan)
{
    for (var i = 0; i < GetWanList().length; i++)
    {
        if (GetWanList()[i].domain.split(".")[2] == "4")
        {
            return GetWanList()[i].domain.split(".")[4];
        }
    }

    return null;
}

function GetPonIsInUsedWANConnectionDeviceInst(Wan)
{
    for (var i = 0; i < GetWanList().length; i++)
    {
        if (GetWanList()[i].domain.split(".")[2] == "6")
        {
            return GetWanList()[i].domain.split(".")[4];
        }
    }

    return null;
}
function IsInvalidRadioWan()
{
	if (((1 == RadioWanParaList.length) && (RadioWanParaList.length < RadioWanPSList.length))
		|| ((1 == RadioWanPSList.length)&&(RadioWanParaList.length > RadioWanPSList.length)))
	{
	    return true;
	}
	return false;
}

function TranslateRadioWanProfile(profileInst) 
{
    var DEFAULT_PROFILE_INDEX = 0;
    
    if (RadioWanProfile == null) {
        return DEFAULT_PROFILE_INDEX;
    }
    
    var PROFILE_DOMAIN = "InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo.X_HW_MobileInterface.Profile." + profileInst; 
    for (var i = 0; i < (RadioWanProfile.length - 1); i++) {
        if (RadioWanProfile[i] == null) {
            continue;
        }
        
        if (RadioWanProfile[i].domain == PROFILE_DOMAIN) {
            return i;
        }
    }
    
    return DEFAULT_PROFILE_INDEX;
}

function CompensateRadioWanCfg()
{
	var requestUrl = "";
	var Onttoken = "<%HW_WEB_GetToken();%>";

	if ((1 == RadioWanParaList.length)&&(RadioWanParaList.length < RadioWanPSList.length))
	{
		requestUrl = 'InternetGatewayDevice.X_HW_RadioWanPS.1' + '=';
	}
	else if ((1 == RadioWanPSList.length)&&(RadioWanParaList.length > RadioWanPSList.length))
	{
		requestUrl = 'InternetGatewayDevice.X_HW_Radio_WAN.1' + '=';
	}
	else
	{
		return;
	}
	requestUrl += '&x.X_HW_Token=' + Onttoken;

	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	data : requestUrl,
	url :  "del.cgi?" + "&RequestFile=html/ipv6/not_find_file.asp",
	error:function(XMLHttpRequest, textStatus, errorThrown)
	{

	}
	});
}


for(i=0, j=0;IPWanList.length > 0 && i < IPWanList.length -1;i++, j++)
{
    if("1" == IPWanList[i].Tr069Flag || IsWanMustHidden(domainTowanname(IPWanList[i].domain)) == true)
    {
	    j--;
	    continue;
    }

    if(true == IsRDSGatewayUser() && -1 == IPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET"))
    {
	    j--;
	    continue;
    }

    if(SingtelModeEX == 1)
    {
    	if((IPWanList[i].ServiceList.toString().toUpperCase().indexOf("IPTV") >=0) || (IPWanList[i].ServiceList.toString().toUpperCase().indexOf("VOIP") >=0))
    	{
			j--;
	    	continue;
    	}
    }
    if(filterWanOnlyTr069(IPWanList[i]) == false )
    {
	    j--;
	    continue;
    }

    if(filterWanByVlan(IPWanList[i]) == false )
    {
	    j--;
	    continue;
    }

    if ((true == IsRadioWanSupported(IPWanList[i])) && (true == IsInvalidRadioWan()))
	{
		j--;
		CompensateRadioWanCfg();
		continue;
	}
    if ((CfgModeWord.toUpperCase() == "TELECENTRO") && (!IsAdminUser()))
    {
        if (IPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET") == -1)
        {
            j--;
            continue;
        }
    }	
    WanList[j] = new WanInfoInst();
    ConvertIPWan(IPWanList[i], WanList[j]);
    WanList[j].Name = MakeWanName(WanList[j]);
	
	if((WanList[j].ProtocolType.toString() == "IPv6") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
	{
		switch(IPDSLiteList[i].WorkMode.toUpperCase())
		{
			case "OFF":
			IPDSLiteList[i].WorkMode = "Off";
			break;
			case "STATIC":
			IPDSLiteList[i].WorkMode = "Static";
			break;
			case "DYNAMIC":
			IPDSLiteList[i].WorkMode = "Dynamic";
			break;
			default:
			break;
		}
	    WanList[j].IPv6DSLite = IPDSLiteList[i].WorkMode;
		if(IPDSLiteList[i].WorkMode == "Off")
		{
			WanList[j].EnableDSLite = "0";
		}
		else
		{
			WanList[j].EnableDSLite = "1";
		}

		WanList[j].IPv6AFTRName = IPDSLiteList[i].AFTRName;
	}

    if ((1 == IsTDE2Mode) && ("1" == WanList[j].IPv6Enable))
	{
	    WanList[j].X_HW_UnnumberedModel = TDEIPWanIPv6AddressList[i].X_HW_UnnumberedModel;
        WanList[j].X_HW_TDE_IPv6AddressingType = TDEIPWanIPv6AddressList[i].X_HW_TDE_IPv6AddressingType;
        WanList[j].X_HW_DHCPv6ForAddress  = TDEIPWanIPv6AddressList[i].X_HW_DHCPv6ForAddress;
		WanList[j].X_HW_E8C_IPv6PrefixDelegationEnabled  = TDEIPDelegationEnabled[i].X_HW_E8C_IPv6PrefixDelegationEnabled;
	}

	if (true == Is6RdSupported()){
    	if((WanList[j].ProtocolType.toString() == "IPv4") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
    	{
			WanList[j].RdMode = (IP6RDTunnelList[i].Enable6Rd == '1') ? IP6RDTunnelList[i].RdMode : "Off";
			WanList[j].Enable6Rd = IP6RDTunnelList[i].Enable6Rd;
			WanList[j].RdPrefix = IP6RDTunnelList[i].RdPrefix;
			WanList[j].RdPrefixLen = IP6RDTunnelList[i].RdPrefixLen;
			WanList[j].RdBRIPv4Address = IP6RDTunnelList[i].RdBRIPv4Address;
			WanList[j].RdIPv4MaskLen = IP6RDTunnelList[i].RdIPv4MaskLen;
    	}
	}

	if (true == IsRadioWanSupported(IPWanList[i]))
	{
		if (RadioWanPSList.length > 1)
		{
			WanList[j].RadioWanPSEnable = RadioWanPSList[0].RadioWanPSEnable;
			WanList[j].AccessType = RadioWanPSList[0].AccessType;
			WanList[j].SwitchMode = RadioWanPSList[0].SwitchMode;
			WanList[j].SwitchDelayTime = RadioWanPSList[0].SwitchDelayTime;
			WanList[j].PingIPAddress = RadioWanPSList[0].PingIPAddress;
 		}

		if (RadioWanParaList.length > 1)
		{
			WanList[j].RadioWanUsername = RadioWanParaList[0].RadioWanUsername;
			WanList[j].RadioWanPassword = RadioWanParaList[0].RadioWanPassword;
			WanList[j].APN = RadioWanParaList[0].APN;
			WanList[j].DialNumber = RadioWanParaList[0].DialNumber;
			WanList[j].TriggerMode = WanList[j].ConnectionTrigger;
		}

        if (isSupportLte == 1) {
            if (RadioWanBackup.length > 1) {
                WanList[j].BackupMode = RadioWanBackup[0].BackupMode;
                WanList[j].BackupDelayTime = RadioWanBackup[0].BackupDelayTime;
            }

            if (RadioWanProfile.length > 1) {
                var profileIndex = TranslateRadioWanProfile(WanList[i].X_HW_LteProfile);
                WanList[j].APN = RadioWanProfile[profileIndex].LteAPN;
                WanList[j].DialNumber = RadioWanProfile[profileIndex].LteDialNum;
                WanList[j].RadioWanUsername = RadioWanProfile[profileIndex].LteUsername;
                WanList[j].RadioWanPassword = RadioWanProfile[profileIndex].LtePassword;
                
                WanList[j].RadioWanPSEnable = IPWanList[i].Enable;
            }
        }
	}
	if (WanstatistcsRead ==1)
	{
	    WanList[j].BytesSent = WanEthIPStats[i].BytesSent;
	    WanList[j].BytesReceived = WanEthIPStats[i].BytesReceived;
	    WanList[j].PacketsSent = WanEthIPStats[i].PacketsSent;
	    WanList[j].PacketsReceived = WanEthIPStats[i].PacketsReceived;
	    WanList[j].UnicastSent = WanEthIPStats[i].UnicastSent;
	    WanList[j].UnicastReceived = WanEthIPStats[i].UnicastReceived;
	    WanList[j].MulticastSent = WanEthIPStats[i].MulticastSent;
	    WanList[j].MulticastReceived = WanEthIPStats[i].MulticastReceived;
	    WanList[j].BroadcastSent = WanEthIPStats[i].BroadcastSent;
        WanList[j].BroadcastReceived = WanEthIPStats[i].BroadcastReceived;
        
        WanList[j].BytesSentHigh = WanEthIPStats[i].BytesSentHigh;
	    WanList[j].BytesSentLow = WanEthIPStats[i].BytesSentLow;
	    WanList[j].BytesReceivedHigh = WanEthIPStats[i].BytesReceivedHigh;
	    WanList[j].BytesReceivedLow = WanEthIPStats[i].BytesReceivedLow;
	    WanList[j].BytesSent = Number(WanList[j].BytesSentHigh) * 4294967296 + Number(WanList[j].BytesSentLow);
	    WanList[j].BytesReceived = Number(WanList[j].BytesReceivedHigh) * 4294967296 + Number(WanList[j].BytesReceivedLow);
            WanList[j].X_HW_UpstreamBitrate = WanEthIPStats[i].X_HW_UpstreamBitrate;
	    WanList[j].X_HW_DownstreamBitrate = WanEthIPStats[i].X_HW_DownstreamBitrate;
	}
}

for(i=0; PPPWanList.length > 0 && i < PPPWanList.length - 1; j++,i++)
{
    if("1" == PPPWanList[i].Tr069Flag || IsWanMustHidden(domainTowanname(PPPWanList[i].domain)) == true && ('JSCMCC' != CfgModeWord.toUpperCase() || PPPWanList[i].VlanId != 4031 || curUserType != 0))
	{
		j--;
    	continue;
	}

	if(true == IsRDSGatewayUser() && -1 == PPPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET"))
    {
	    j--;
	    continue;
    }

	if(SingtelModeEX == 1)
    {
    	if((PPPWanList[i].ServiceList.toString().toUpperCase().indexOf("IPTV") >=0) || (PPPWanList[i].ServiceList.toString().toUpperCase().indexOf("VOIP") >=0))
    	{
			j--;
	    	continue;
    	}
    }
	if(filterWanOnlyTr069(PPPWanList[i]) == false )
    {
	    j--;
	    continue;
   	}

    if(filterWanByVlan(PPPWanList[i]) == false )
   	{
	    j--;
	    continue;
   	}

	if ((true == IsRadioWanSupported(PPPWanList[i])) && (true == IsInvalidRadioWan()))
	{
		j--;
		CompensateRadioWanCfg();
		continue;
	}
    if ((CfgModeWord.toUpperCase() == "TELECENTRO") && (!IsAdminUser()))
    {
        if (PPPWanList[i].ServiceList.toString().toUpperCase().indexOf("INTERNET") == -1)
        {
            j--;
            continue;
        }
	}

	WanList[j] = new WanInfoInst();
    ConvertPPPWan(PPPWanList[i], WanList[j]);
    WanList[j].Name = MakeWanName(WanList[j]);

	if((WanList[j].ProtocolType.toString() == "IPv6") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
	{
		switch(PPPDSLiteList[i].WorkMode.toUpperCase())
		{
			case "OFF":
			PPPDSLiteList[i].WorkMode = "Off";
			break;
			case "STATIC":
			PPPDSLiteList[i].WorkMode = "Static";
			break;
			case "DYNAMIC":
			PPPDSLiteList[i].WorkMode = "Dynamic";
			break;
			default:
			break;
		}
	    WanList[j].IPv6DSLite = PPPDSLiteList[i].WorkMode;
		if(PPPDSLiteList[i].WorkMode == "Off")
		{
			WanList[j].EnableDSLite = "0";
		}
		else
		{
			WanList[j].EnableDSLite = "1";
		}
		WanList[j].IPv6AFTRName = PPPDSLiteList[i].AFTRName;
	}

	if ((1 == IsTDE2Mode) && ("1" == WanList[j].IPv6Enable))
	{
	    WanList[j].X_HW_UnnumberedModel = TDEPPPWanIPv6AddressList[i].X_HW_UnnumberedModel;
        WanList[j].X_HW_TDE_IPv6AddressingType = TDEPPPWanIPv6AddressList[i].X_HW_TDE_IPv6AddressingType;
        WanList[j].X_HW_DHCPv6ForAddress  = TDEPPPWanIPv6AddressList[i].X_HW_DHCPv6ForAddress;
		WanList[j].X_HW_E8C_IPv6PrefixDelegationEnabled  = TDEPPPDelegationEnabled[i].X_HW_E8C_IPv6PrefixDelegationEnabled;
	}

	if (true == Is6RdSupported()){
    	if((WanList[j].ProtocolType.toString() == "IPv4") && (WanList[j].Mode.toString().toUpperCase() == "IP_ROUTED"))
    	{
			WanList[j].RdMode = (PPP6RDTunnelList[i].Enable6Rd == '1') ? "Static" : "Off";
        	WanList[j].Enable6Rd = PPP6RDTunnelList[i].Enable6Rd;
        	WanList[j].RdPrefix = PPP6RDTunnelList[i].RdPrefix;
        	WanList[j].RdPrefixLen = PPP6RDTunnelList[i].RdPrefixLen;
        	WanList[j].RdBRIPv4Address = PPP6RDTunnelList[i].RdBRIPv4Address;
        	WanList[j].RdIPv4MaskLen = PPP6RDTunnelList[i].RdIPv4MaskLen;
    	}
    }

	if (true == IsRadioWanSupported(PPPWanList[i]))
	{
		if (RadioWanPSList.length > 1)
		{
			WanList[j].RadioWanPSEnable = RadioWanPSList[0].RadioWanPSEnable;
			WanList[j].AccessType = RadioWanPSList[0].AccessType;
			WanList[j].SwitchMode = RadioWanPSList[0].SwitchMode;
			WanList[j].SwitchDelayTime = RadioWanPSList[0].SwitchDelayTime;
			WanList[j].PingIPAddress = RadioWanPSList[0].PingIPAddress;
 		}

		if (RadioWanParaList.length > 1)
		{
			WanList[j].RadioWanUsername = RadioWanParaList[0].RadioWanUsername;
			WanList[j].RadioWanPassword = RadioWanParaList[0].RadioWanPassword;
			WanList[j].APN = RadioWanParaList[0].APN;
			WanList[j].DialNumber = RadioWanParaList[0].DialNumber;
			WanList[j].TriggerMode = WanList[j].ConnectionTrigger;
		}

        if (isSupportLte == 1) {
            if (RadioWanBackup.length > 1) {
                WanList[j].BackupMode = RadioWanBackup[0].BackupMode;
                WanList[j].BackupDelayTime = RadioWanBackup[0].BackupDelayTime;
            }

            if (RadioWanProfile.length > 1) {
                WanList[j].APN = RadioWanProfile[0].LteAPN;
                WanList[j].DialNumber = RadioWanProfile[0].LteDialNum;
                WanList[j].RadioWanUsername = RadioWanProfile[0].LteUsername;
                WanList[j].RadioWanPassword = RadioWanProfile[0].LtePassword;
                WanList[j].RadioWanPSEnable = PPPWanList[i].Enable;
            }
        }
	}
	if (WanstatistcsRead ==1)
	{
	    WanList[j].BytesSent = WanEthPPStats[i].BytesSent;
	    WanList[j].BytesReceived = WanEthPPStats[i].BytesReceived;
	    WanList[j].PacketsSent = WanEthPPStats[i].PacketsSent;
	    WanList[j].PacketsReceived = WanEthPPStats[i].PacketsReceived;
	    WanList[j].UnicastSent = WanEthPPStats[i].UnicastSent;
	    WanList[j].UnicastReceived = WanEthPPStats[i].UnicastReceived;
	    WanList[j].MulticastSent = WanEthPPStats[i].MulticastSent;
	    WanList[j].MulticastReceived = WanEthPPStats[i].MulticastReceived;
	    WanList[j].BroadcastSent = WanEthPPStats[i].BroadcastSent;
        WanList[j].BroadcastReceived = WanEthPPStats[i].BroadcastReceived;
        
        WanList[j].BytesSentHigh = WanEthPPStats[i].BytesSentHigh;
	    WanList[j].BytesSentLow = WanEthPPStats[i].BytesSentLow;
	    WanList[j].BytesReceivedHigh = WanEthPPStats[i].BytesReceivedHigh;
	    WanList[j].BytesReceivedLow = WanEthPPStats[i].BytesReceivedLow;
	    WanList[j].BytesSent = Number(WanList[j].BytesSentHigh) * 4294967296 + Number(WanList[j].BytesSentLow);
	    WanList[j].BytesReceived = Number(WanList[j].BytesReceivedHigh) * 4294967296 + Number(WanList[j].BytesReceivedLow);
	    WanList[j].X_HW_UpstreamBitrate = WanEthPPStats[i].X_HW_UpstreamBitrate;
	    WanList[j].X_HW_DownstreamBitrate = WanEthPPStats[i].X_HW_DownstreamBitrate;
	}

    if (unnumberdIPInfo.length > 1) {
        WanList[j].EnableUnnumbered = unnumberdIPInfo[i].Enable;
        WanList[j].UnnumberedIpAddress = unnumberdIPInfo[i].IPAddress;
        WanList[j].UnnumberedSubnetMask = unnumberdIPInfo[i].SubnetMask;
    }
}

WanList.sort(
    function (wan1, wan2) {
        var wan1Id = parseInt(wan1.MacId);
        var wan2Id = parseInt(wan2.MacId);
        var wan3Id = Number(wan1Id);
        var wan4Id = Number(wan2Id);
        if (isNaN(wan3Id) || isNaN(wan4Id)) {
            return 0;
        }
        return wan1Id - wan2Id;
    }
);

try
{
    this.IPv6PrefixMode   = "PrefixDelegation";
    this.IPv6AddressStuff = "";
    this.IPv6AddressMode  = "DHCPv6";
    this.IPv6StaticPrefix = "20::01/64";
    this.IPv6IPAddress    = "20::02";
    this.IPv6AddrMaskLenE8c    = "64";
    this.IPv6GatewayE8c    = "";
	this.IPv6ReserveAddress = "";
    this.IPv6SubnetMask   = "";
    this.IPv6Gateway      = "";
    this.IPv6PrimaryDNS   = "";
    this.IPv6SecondaryDNS = "";
    this.IPv6WanMVlanId   = "";

    for (var i = 0; i < WanList.length; i++)
    {
        var AddressAcquireItem = GetIPv6AddressAcquireInfo(WanList[i].domain);
        var PrefixAcquireItem = GetIPv6PrefixAcquireInfo(WanList[i].domain);

        WanList[i].IPv6AddressMode = (null != AddressAcquireItem && AddressAcquireItem.Origin!="") ? AddressAcquireItem.Origin : "None";
        WanList[i].IPv6AddressStuff = (null != AddressAcquireItem) ? AddressAcquireItem.ChildPrefixBits : "";
        WanList[i].IPv6IPAddress = (null != AddressAcquireItem) ? AddressAcquireItem.IPAddress : "";
        WanList[i].IPv6AddrMaskLenE8c = (null != AddressAcquireItem) ? AddressAcquireItem.AddrMaskLen : "";
        WanList[i].IPv6GatewayE8c = (null != AddressAcquireItem) ? AddressAcquireItem.DefaultGateway : "";
		if (WanList[i].EncapMode == "IPoE")
		{
			WanList[i].IPv6ReserveAddress = (null != AddressAcquireItem) ? AddressAcquireItem.IPv6ReserveAddress : "";
		}
		else if (WanList[i].EncapMode == "PPPoE")
		{
			WanList[i].IPv6ReserveAddress = "";
		}
        WanList[i].IPv6PrefixMode = (null != PrefixAcquireItem && PrefixAcquireItem.Origin!="") ? PrefixAcquireItem.Origin : "None";

		WanList[i].EnablePrefix =(WanList[i].IPv6PrefixMode == "None") ? "0":"1";

        WanList[i].IPv6StaticPrefix = (null != PrefixAcquireItem) ? PrefixAcquireItem.Prefix : "";
    }
}
catch(ex)
{

}

function GetIPv6WanDNS(IPv6WanDomain)
{
  var DnsServer = GetIPv6WanDnsServerInfo(domainTowanname(IPv6WanDomain));

  if(DnsServer == null || DnsServer=="")
  {
    return null;
  }

  return DnsServer.DNSServer;
}


try
{
    for (var i = 0; i < WanList.length; i++)
    {
        var DnsServer = GetIPv6WanDNS(WanList[i].domain);

        if (DnsServer == null)
        {
            continue;
        }

        var DnsServerList = DnsServer.split(",");
        if (DnsServerList == null)
        {
            continue;
        }

        WanList[i].IPv6PrimaryDNS = ((DnsServerList.length >= 1) ? DnsServerList[0] : "");
        WanList[i].IPv6SecondaryDNS = ((DnsServerList.length >= 2) ? DnsServerList[1] : "");
    }
}catch(ex){}

function ModifyWanList(ModifyFunc)
{
	if (ModifyFunc == null || ModifyFunc == undefined)
	{
		return;
	}

	for (var i = 0; i < WanList.length; i++)
	{
		try
		{
			ModifyFunc(WanList[i]);
		}
		catch(e)
		{

		}
	}
}
function GetWanListLength() {
    return WanList.length;
}

function filterXDWanList() {
    var result = [];
    for (var i = 0; i < WanList.length; i++) {
        var wan = WanList[i];
        if (wan.WanAccessType != "PON") {
            result.push(wan);
        }
    }
    return result;
}

function filterPonWanList() {
    var result = [];
    for (var i = 0; i < WanList.length; i++) {
        var wan = WanList[i];
        if (wan.WanAccessType == "PON") {
            result.push(wan);
        }
    }
    return result;
}

function filterWanListByHON()
{
    var result = [];
    for (var i = 0; i < WanList.length; i++) {
        var wan = WanList[i];
        if (wan.ServiceList.toUpperCase() != "HON") {
            result.push(wan);
        }
    }
    return result;
}

function filterWanListByUpMode() {
    var localWanList = null;
    if (CurrentUpMode == 3) {
		localWanList = WanList;
    } else if (CurrentUpMode == 1) {
        localWanList = filterPonWanList();
    }
    return localWanList;
}

function dbaa1FilterWanList(wanList) {
    if (curUserType != '1') {
        return wanList;
    }
    for (var i = wanList.length - 1; i >= 0; i--) {
        if (dbaa1FilterWan(wanList[i]) == false) {
            wanList.splice(i, 1);
        }
    }
    return wanList;
}

function GetWanList() {
    if (xdPonSupport == 1) {
        return filterWanListByUpMode();
    }
    if (DBAA1 == "1") {
        return dbaa1FilterWanList(WanList);
    }
	if (((isFjCt == 1) && (isSupportPCDN == 1)) || ((isSupportPCDN == 0) && (isSupportModifyCdn == 1)) || ((isSupportPCDN == 1) && (isSupportModifyCdn == 1) && (curUserType == 1)) || ((isHONWanView != 1) && (isSupportPCDN == 1))) {
		return filterWanListByHON();
	}

    return WanList;
}

function IsOnlyReadWan(wan)
{
    if ((IsEnWebUserModifyWan() == true) && (wan.ServiceList.toString().toUpperCase() !='INTERNET')) {
        return true;
    }
	return (GetISPWanOnlyRead() && IsWanHidden(domainTowanname(wan.domain)));
}


function GetRadioWanParaList()
{
	return RadioWanParaList;
}

function GetRadioWanPSList()
{
	return RadioWanPSList;
}

function IsTr069WanOnlyRead()
{
    return Tr069WanOnlyRead;
}

function GetWanListByFilter(filterFunction)
{
  var WansResult = new Array();
  var WanList = GetWanList();
  var i=0;
  var j=0;

  for (i = 0; i < WanList.length; i++)
  {
     if (filterFunction != null && filterFunction != undefined)
     {
        if (filterFunction(WanList[i]) == false)
        {
           continue;
        }
     }

     WansResult[j]=WanList[i];
     j++;
  }

  return WansResult;
}

function FindWanInfoByAppInfo(appItem)
{
	var WanList = GetWanList();
	var wandomain_len = 0;
	var temp_domain = null;

	for(var k = 0; k < WanList.length; k++ )
	{
		wandomain_len = WanList[k].domain.length;
		temp_domain = appItem.domain.substr(0, wandomain_len);

		if (temp_domain == WanList[k].domain)
		{
			return WanList[k];
		}
	}
	return null;
}

function GetAppListFormWanAppendInfo(wanAppInfo1, wanAppInfo2, filterFunction)
{
	var listAppInfo = new Array();
	var Idx = 0;

    for (var i = 0; i < wanAppInfo1.length-1; i++)
	{
		var tmpWan = FindWanInfoByAppInfo(wanAppInfo1[i]);

		if (tmpWan == null)
	    {
	        continue;
	    }

		if (filterFunction == null || filterFunction(tmpWan))
		{
			listAppInfo[Idx] = wanAppInfo1[i];
			Idx ++;
		}
	}

	for (var j = 0; j < wanAppInfo2.length-1; j++)
	{
	    var tmpWan = FindWanInfoByAppInfo(wanAppInfo2[j]);

		if (tmpWan == null)
	    {
	        continue;
	    }

	    if (filterFunction == null || filterFunction(tmpWan))
		{
			listAppInfo[Idx] = wanAppInfo2[j];
			Idx ++;
		}
	}

	return listAppInfo;
}


function InitWanNameListControl(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
    var NullOption = document.createElement("Option");
    NullOption.value = '';
    NullOption.innerText = '';
    NullOption.text = '';
    Control.appendChild(NullOption);

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}
function InitWanNameListControl1(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
    var NullOption = document.createElement("Option");
    NullOption.value = '';
    NullOption.innerText = '';
    NullOption.text = '';
    Control.appendChild(NullOption);

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = WanList[i].domain;
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);

        Control.appendChild(Option);
    }
}
function InitWanNameListControl2(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = WanList[i].domain;
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);

        Control.appendChild(Option);
    }
}

function InitWanNameListControlForMC(WanListControlId, IsThisWanOkFunction) {
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;

    for (i = 0; i < WanList.length; i++) {
        var Option = document.createElement("Option");
        Option.value = WanList[i].domain;
        Option.innerText = MakeWanNameForMC(WanList[i]);
        Option.text = MakeWanNameForMC(WanList[i]);
        Control.appendChild(Option);
    }
}

function InitWanNameListControl_if(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;
    var NullOption = document.createElement("Option");
    NullOption.value = '';
    NullOption.innerText = '';
    NullOption.text = '';
    Control.appendChild(NullOption);

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = domainTowanname_if(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}
function InitWanNameListControlWanname(WanListControlId, IsThisWanOkFunction)
{
    var Control = getElById(WanListControlId);
    var WanList = GetWanListByFilter(IsThisWanOkFunction);
    var i = 0;

    for (i = 0; i < WanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
}


function GetWanFullName(WanName)
{
    for (var i = 0; i < WanList.length;i++)
    {
	    if (WanList[i].NewName == WanName)
		{
			return MakeWanName(WanList[i]);
		}
    }

    return WanName;
}

function getWANByVlan(vlan)
{
	var wanSpec = new Array();
	var i = 0;
	for(i=0; PPPWanList.length > 0 && i < PPPWanList.length - 1; i++)
	{
		if (vlan == PPPWanList[i].VlanId)
		{
			wanSpec.push(PPPWanList[i]);
		}
	}
	for(i=0; IPWanList.length > 0 && i < IPWanList.length - 1; i++)
	{
		if (vlan == IPWanList[i].VlanId)
		{
			wanSpec.push(IPWanList[i]);
		}
	}
	return wanSpec;
}

function GetWanInfoByWanName(WanName)
{
    for (var i = 0; i < WanList.length;i++)
    {
	    if (WanList[i].NewName == WanName)
		{
			return (WanList[i]);
		}
    }

    return WanName;
}

function GetWanInfoByDomain(Domain)
{
	for (var i = 0; i < WanList.length;i++)
    {
	    if (WanList[i].domain == Domain)
		{
			return (domainTowanname(WanList[i].domain));
		}
    }
	
    return Domain;
}

function PS_GetCmdFormat(type, dev, protocal, start, end)
{
    var cmd = type
              + "/" + dev
              + "/" + (("TCP/UDP" == protocal.toUpperCase())?"tcpudp":protocal)
              + "/" + start
              + "/" + (((end.length == 0) || (parseInt(end, 10) == 0))? 1:(parseInt(end, 10) - parseInt(start, 10) + 1));

    return cmd.toLowerCase();
}

function PS_CheckReservePort(Operation, NewPort, OldPOrt)
{
    var conflict = false;
    var Onttoken = "<%HW_WEB_GetToken();%>";
    $.ajax({
        type  : "POST",
        async : false,
        cache : false,
        data  : "act=" + Operation+ "&new=" + NewPort + "&old=" + OldPOrt +'&x.X_HW_Token=' + Onttoken,
        url   : "pdtportcheck",
        success : function(data) {
            conflict = true;
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
            conflict = false;
        },
        complete: function (XHR, TS) {
            XHR = null;
      }
    });

    return conflict;
}

function ParseUsernameForIraq(userName)
{
	var viewusrnm = '';
	var temp;
	var viewUserName = userName;

	if( false == IsAdminUser() )
	{
		var postFix = "@o3-telecom.com";

		if(userName.indexOf(postFix) >= 0)
		{
			if(userName.substring(userName.length - postFix.length) == postFix)
			{
				viewUserName =  userName.substring(0, userName.length - postFix.length);

			}
		}
	}
	return viewUserName;
}

function ParseUsernameFortedata(userName)
{
	var viewusrnm = '';
	var temp;
	var viewUserName = userName;

	var postFix = "@tedata.net.eg";

	if(userName.indexOf(postFix) >= 0)
	{
		if(userName.substring(userName.length - postFix.length) == postFix)
		{
			viewUserName =  userName.substring(0, userName.length - postFix.length);
		}
	}
	return viewUserName;
}

function WanMacId2WanPath(wanMacId)
{
	for (var i = 0; i < WanList.length;i++)
	{
		if(wanMacId == WanList[i].MacId) 
		{
			return WanList[i].domain;
			break;
		}
    }
	return "";
}

function WanPath2WanMacId(wanPath)
{
	for (var i = 0; i < WanList.length;i++) 
	{
		if(wanPath.toUpperCase() == WanList[i].domain.toUpperCase()) 
		{
			return WanList[i].MacId;
		}
    }
	return 0;
}

function RemoveDomainPoint(str)
{
    if (str.charAt(str.length-1) == ".")
    {
        return str.slice(0,str.length-1);
    }
    else
    {
        return str;
    }
}

function WanIsExist()
{	
	if ((IPWanList.length > 1 && IPWanList[0] != null) || (PPPWanList.length > 1 && PPPWanList[0] != null))
	{
		return true;
	}

	return false;
}

function IsDefaultLteWan(wanPath)
{
    if (isSupportLte != 1) {
        return false;
    }

    for (var i = 0; i < IPWanList.length - 1; i++) {
        if ((wanPath.toUpperCase() == IPWanList[i].domain.toUpperCase()) && (IPWanList[i].X_HW_LteProfile == 1)) {
            return true;
        }
    }

    return false;
}
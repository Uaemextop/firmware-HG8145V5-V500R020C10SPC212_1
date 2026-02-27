var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>"; 
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
var TDE2ModeFlag   = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';
var ProductType = '<%HW_WEB_GetProductType();%>';
var CurCfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var IsTedata = '<%HW_WEB_GetFeatureSupport(HW_FT_FEATURE_DTEDATA);%>';
var tedataGuide = '<%HW_WEB_GetFeatureSupport(HW_FT_FEATURE_TEDATAGUIDE);%>';

function SupportTtnet()
{
    return (CurCfgModeWord.toUpperCase() == "DTTNET2WIFI" || CurCfgModeWord.toUpperCase() == "TTNET2");
}

function stWanLink(domain,CurrentOperatingMode)
{
	this.domain = domain;
	this.CurrentOperatingMode = CurrentOperatingMode;
}

var WanLinkInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.MultiUpLinkSelectPolicy, CurrentOperatingMode,stWanLink);%>;

function getWanType()
{
	if(WanLinkInfos.length <=0 )
	{
		return ;
	}
	if("ADSL" == WanLinkInfos[0].CurrentOperatingMode.toString().toUpperCase())
	{
		return 1;
	}
	
	if("VDSL" == WanLinkInfos[0].CurrentOperatingMode.toString().toUpperCase())
	{
		return 2;
	}
	
	if("ETH" == WanLinkInfos[0].CurrentOperatingMode.toString().toUpperCase())
	{
		return 3;
	}
}


if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

if(typeof(HTMLElement)!="undefined" && !window.opera && !( navigator.appName == 'Microsoft Internet Explorer')) 
{ 
    HTMLElement.prototype.__defineGetter__("outerHTML",function() { 
        var a=this.attributes, str="<"+this.tagName, i=0;for(;i<a.length;i++) 
        if(a[i].specified) 
            str+=" "+a[i].name+'="'+a[i].value+'"'; 
        if(!this.canHaveChildren) 
            return str+" />"; 
        return str+">"+this.innerHTML+"</"+this.tagName+">"; 
    }); 
    HTMLElement.prototype.__defineSetter__("outerHTML",function(s) { 
        var r = this.ownerDocument.createRange(); 
        r.setStartBefore(this); 
        var df = r.createContextualFragment(s); 
        this.parentNode.replaceChild(df, this); 
        return s; 
    }); 
    HTMLElement.prototype.__defineGetter__("canHaveChildren",function(){ 
        return !/^(area|base|basefont|col|frame|hr|img|br|input|isindex|link|meta|param)$/.test(this.tagName.toLowerCase()); 
    }); 
}

function TDEIPv6AddressTransfer(X_HW_UnnumberedModel,X_HW_DHCPv6ForAddress,X_HW_TDE_IPv6AddressingType)
{
    var IPv6AddressType;

    if (X_HW_UnnumberedModel == 1)
    {
        IPv6AddressType = "None";
        return IPv6AddressType;
    }

    if (X_HW_DHCPv6ForAddress == 1)
    {
        IPv6AddressType = "DHCPv6";
        return IPv6AddressType;
    }
    
    if (X_HW_TDE_IPv6AddressingType == "SLAAC")
    {
        IPv6AddressType = "AutoConfigured";
    }
    else if (X_HW_TDE_IPv6AddressingType == "Static")
    {
        IPv6AddressType = "Static";
    }
    else
    {
        IPv6AddressType = "DHCPv6";
    }
    return IPv6AddressType;
}

function isReadModeForTR069Wan()
{
	return IsTr069WanOnlyRead();
}

	
function ShowWanListTable()
{
    var ShowTableFlag = 0;
    if (['DTURKCELL2WIFI', 'TURKCELL2'].indexOf(CfgModeWord.toUpperCase()) >= 0) {
        ShowTableFlag = 1;
    } else {
        if ((RadioWanFeature != "1") || (IsAdminUser() == true) || (MobileBackupWanSwitch == 1)) {
            ShowTableFlag = 1;
        }
    }
	var BoxHideFlag = '';
	var VlanHideFlag = (IsSonetUser()) ? true : false;
	
	var ShowButtonFlag = '';
	if (IsAdminUser() != true)
	{
		if (ProductType == '2')
		{
			if (IsLanUpport() == true)
			{
				ShowButtonFlag =  true;
				BoxHideFlag = false;
			} else if (CfgModeWord.toUpperCase() == "OTE") {
				ShowButtonFlag =  true;
				BoxHideFlag = false;
			}
			else
			{
				ShowButtonFlag = false;
				BoxHideFlag = true;
			}		
		}
		else
		{
			if ((IsLanUpCanOper() == true) || (tedataGuide == 1) || (IsEnWebUserModifyWan() == true))
			{
				ShowButtonFlag =  true;
				BoxHideFlag = false;
			}
			else
			{
				ShowButtonFlag = false;
				BoxHideFlag = true;
			}
			if (CfgModeWord.toUpperCase() == 'TELECENTRO') {
				VlanHideFlag = true;
			}

			if (CfgModeWord.toUpperCase() == 'RDSAP') {
				ShowButtonFlag = false;
				BoxHideFlag = true;
			}
		}
	}
	else
	{
		if((ProductType == '2') && ('TALKTALK2WIFI' == CfgModeWord.toUpperCase()))
		{
			ShowButtonFlag = false;
		}
		else
		{
			ShowButtonFlag = true;
		}
		BoxHideFlag = false;
	}
	var WanConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox",BoxHideFlag),
									new stTableTileInfo("WanConnectionName","align_center restrict_dir_ltr","Name",false),
									new stTableTileInfo("WanVlanPriority","align_center","VlanPriority",VlanHideFlag),
									new stTableTileInfo("WanProtocolType1","align_center","ProtocolType",false),null);
	
	var ColumnNum = 4;
	var UserInfo = new Array();
	
	for (var i = 0;i < GetWanList().length; i++)
	{
		if(false == filterWanByFeature(GetWanList()[i]))
		{
			continue;
		}
		
		if ((IsPTVDFMode == '1') && (RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 1))
		{
			if (GetWanList()[i].RealName.indexOf("RADIO") < 0)
			{
				continue;
			}
		}
		
		if((ProductType == '2')&&('TALKTALK2WIFI' == CfgModeWord.toUpperCase()))
		{
			var WanTypeDevice = getWanType();
			
			if(WanTypeDevice != GetWanList()[i].domain.split('.')[2])
			{
				continue ;
			}
	
			
		}
		if (CfgModeWord.toUpperCase() == "TRIPLETAP" || CfgModeWord.toUpperCase() == "TRIPLETAPNOGM" || CfgModeWord.toUpperCase() == "TRIPLETAP6" || CfgModeWord.toUpperCase() == "TRIPLETAP6PAIR") {
			if (GetWanList()[i].domain.indexOf(8) > -1) {
				continue;
			}
		}
		UserInfo.push(GetWanList()[i]);
	}
	
	var TableDataInfo =  HWcloneObject(UserInfo, 1);
	TableDataInfo.push(null);
	
	for(var j = 0; j < TableDataInfo.length-1; j++)
	{
		var vlan = "-", pri = "-";
		if ((CurCfgModeWord.toUpperCase() == 'DTURKCELL2WIFI') || (CurCfgModeWord.toUpperCase() == 'TURKCELL2'))
		{
			if ( 4095 != parseInt(TableDataInfo[j].VlanId) )
			{	
				vlan = TableDataInfo[j].VlanId;
				pri = ('SPECIFIED' == TableDataInfo[j].PriorityPolicy.toUpperCase()) ? TableDataInfo[j].Priority : TableDataInfo[j].DefaultPriority ;
			}
		}
		else
		{
			if ( 0 != parseInt(TableDataInfo[j].VlanId) )
			{	
				vlan = TableDataInfo[j].VlanId;
				pri = ('SPECIFIED' == TableDataInfo[j].PriorityPolicy.toUpperCase()) ? TableDataInfo[j].Priority : TableDataInfo[j].DefaultPriority ;
			}
		}

		TableDataInfo[j].VlanPriority = vlan+'/'+pri;
	}
	
	HWShowTableListByType(ShowTableFlag, "wanInstTable", ShowButtonFlag, ColumnNum, TableDataInfo, WanConfiglistInfo, Languages, WanConfigCallBack);
	
}


function ParsePageSpec()
{
	if (("1" == GetCfgMode().GDCT) || ("1" == GetCfgMode().FJCT) || ("1" == GetCfgMode().JSCT)
     || ("1" == GetCfgMode().CQCT) || ("1" == GetCfgMode().JXCT))
	{
		document.getElementById("DivIPv4BindLanList2").childNodes[1].nodeValue = "LAN2(iTV)";
	}
	
	if ((GetCfgMode().TELMEX != "1") && ( !SupportTtnet()))
	{
		if(1 == IsTedata)
		{
			$("#UserNameRemark").text("@tedata.net.eg");
		}
		else
		{
			$("#UserNameRemark").text("");
		}
		$("#PasswordRemark").text("");
	}
}

function GetPageData()
{   
    var Wan = new WanInfoInst();
	Wan = GetParaValueArrayByFormId(WanConfigFormList);

    if (Wan.EncapMode == "PPPoE" && Wan.Mode == "IP_Bridged")
    {
        Wan.Mode = "PPPoE_Bridged";
    }
    
    Wan.IPv4Enable = "0";
    Wan.IPv6Enable = "0";

    if (Wan.ProtocolType == "IPv4/IPv6")
    {
        Wan.IPv4Enable = "1";
        Wan.IPv6Enable = "1";
    }
    if (Wan.ProtocolType == "IPv4")
    {
        Wan.IPv4Enable = "1";
    }
    if (Wan.ProtocolType == "IPv6")
    {
        Wan.IPv6Enable = "1";
    }
	if(IsE8cFrame())
	{
		Wan.IPv4BindLanList = Wan.IPv4BindLanList.concat(Wan.IPv4BindSsidList);
	}

	if (1 == TDE2ModeFlag)
	{
	    Wan.IPv6AddressMode = TDEIPv6AddressTransfer(Wan.X_HW_UnnumberedModel,Wan.X_HW_DHCPv6ForAddress,Wan.X_HW_TDE_IPv6AddressingType);
	}
	
    return Wan;
      
}


function BindPageData(Wan)
{
    var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
    var SsidWanBindInfo = "";
    if (LanWanBindInfo != null && LanWanBindInfo != undefined)
    {
        Wan.IPv4BindLanList = LanWanBindInfo.PhyPortName.split(",");
		if(IsE8cFrame())
		{
			for(var j = 0; j< Wan.IPv4BindLanList.length; j++)
			{
				if(Wan.IPv4BindLanList[j].indexOf("SSID") >= 0)
				{
					SsidWanBindInfo += Wan.IPv4BindLanList[j] + ",";
				}
			}
			SsidWanBindInfo = SsidWanBindInfo.substring(0, SsidWanBindInfo.length - 1);
			Wan.IPv4BindSsidList = SsidWanBindInfo.split(",");
		}
    }
	
	HWSetTableByLiIdList(WanConfigFormList,Wan, null);
    
}


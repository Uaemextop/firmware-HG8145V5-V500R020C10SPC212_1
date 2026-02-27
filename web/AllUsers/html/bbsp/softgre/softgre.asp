<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>ARP Ping</title>
</head>
<body class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("softgretitle", GetDescFormArrayById(softgre_language, "bbsp_mune"), GetDescFormArrayById(softgre_language, "bbsp_gre_title"), false);
</script> 
<div class="title_spread"></div>

<table border="0" cellpadding="0" cellspacing="0" id="Table1" width="100%"> </table> 
<script language="javascript">
var selIndex = -1;
var MaxRouteWan = GetRouteWanMax();
var TableName = "GREConfigList";

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
		b.innerHTML = softgre_language[b.getAttribute("BindText")];
	}
}

function GreTunelItem(_Domain, _Name, _RemoteAddress, _DSCPMarkPolicy, _EgressPriPolicy, _EgressInterface)
{
	this.Domain = _Domain;
	this.Name = _Name;
	this.RemoteAddress = _RemoteAddress
    this.DSCPMarkPolicy = _DSCPMarkPolicy;
    this.EgressPriPolicy = _EgressPriPolicy;
	this.EgressInterface = _EgressInterface;
}

function GreIngressItem(_Domain, _InterfaceName, _VLANTaggingEnable, _VLANID, _PriPolicy, _Pri)
{
	this.Domain = _Domain;
	this.InterfaceName = _InterfaceName;
	this.VLANTaggingEnable = _VLANTaggingEnable
    this.VLANID = _VLANID;
    this.PriPolicy = _PriPolicy;
	this.Pri = _Pri;
}
function stWlan(domain,enable,name,ssid, X_HW_ServiceEnable)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
	this.X_HW_ServiceEnable = X_HW_ServiceEnable;

}
function stFonSsidInst(domain, inst2g, inst5g)
{
    this.domain = domain;
    this.fonssid2g = inst2g;
    this.fonssid5g = inst5g;
}
function stGuestWifi(domain,SSID_IDX)
{
	this.domain = domain;
    this.SSID_IDX = SSID_IDX;
}
function stIspSsid(domain, SSID_IDX,UpRateLimit,DownRateLimit,SSID)
{
    this.domain = domain;
    this.SSID_IDX = SSID_IDX;
	this.UpRateLimit = UpRateLimit;
	this.DownRateLimit = DownRateLimit;
	this.SSID = SSID;
}

var GreTunelList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_GRETunnel.{i},Name|RemoteAddress|DSCPMarkPolicy|EgressPriPolicy|EgressInterface,GreTunelItem);%>; 
var GreIngressList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_GRETunnel.1.IngressInterface.{i},InterfaceName|VLANTaggingEnable|VLANID|PriPolicy|Pri,GreIngressItem);%>; 

var WlanInfo = new Array();
WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Enable|Name|SSID|X_HW_ServiceEnable, stWlan,STATUS);%>;  
var IspSsidList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.{i}, SSID_IDX|UpRateLimit|DownRateLimit|SSID, stIspSsid);%>;
var GuestWifiArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_WLANForGuest.{i},SSID_IDX,stGuestWifi);%>;

var GuestWifiMap = {};
for(var i=0; i < GuestWifiArr.length - 1; i++)
{
    GuestWifiMap[GuestWifiArr[i].SSID_IDX] = GuestWifiArr[i];
}

var fonssidinsts  = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.FON, SSID2GINST|SSID5GINST, stFonSsidInst, EXTEND);%>;
var fonssidinst = new stFonSsidInst("", 0 , 0);
if ((fonssidinsts.length > 1) && ('1' == '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_FON);%>'))
{
    fonssidinst = fonssidinsts[0];
}

function GetEnableString(Enable)
{
    if (Enable == 1 || Enable == "1")
    {
        return softgre_language['bbsp_enable'];
    }
    return softgre_language['bbsp_disable'];
}

function InitTableData()
{
	var ColumnNum = 4;
	var ShowButtonFlag = true;
	var TableDataInfo = new Array();
	var Listlen = 0;
	var i = 0;
	var RecordCount = GreTunelList.length - 1;
     
    if (RecordCount == 0)
    {
		TableDataInfo[Listlen] = new GreTunelItem();
		TableDataInfo[Listlen].domain = '--';
		TableDataInfo[Listlen].Name = '--';
		TableDataInfo[Listlen].DSCPMarkPolicy = '--';
		TableDataInfo[Listlen].EgressPriPolicy = '--';
		HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, GREConfigListInfo, softgre_language, null);
    	return;
    }
    for (i = 0; i < RecordCount; i++)
    {
		TableDataInfo[Listlen] = new GreTunelItem();
		TableDataInfo[Listlen].domain = GreTunelList[i].Domain;
		TableDataInfo[Listlen].Name = GreTunelList[i].Name;
		TableDataInfo[Listlen].DSCPMarkPolicy = GreTunelList[i].DSCPMarkPolicy;
		TableDataInfo[Listlen].EgressPriPolicy = GreTunelList[i].EgressPriPolicy;
		Listlen++;
    }
   	TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, GREConfigListInfo, softgre_language, null);
}

function CheckWanOkFunction(item)
{
	if (item.ServiceList.toUpperCase().indexOf("INTERNET") >= 0)
	{
		return true;
	}
	if (item.ServiceList.toUpperCase().indexOf("IPTV") >= 0)
	{
		return true;
	}
	return false;
}


function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.substr(domain.lastIndexOf('.') + 1));
    }
}

function IsIspSsid(wlanInst)
{
    for (var i = 0; i < IspSsidList.length - 1; i++)
    {
        if (wlanInst == IspSsidList[i].SSID_IDX)
        {
            return true;        
        }
    }

    return false;
}

function IsThisWlanOkFunction(wlan)
{
	var wlanInst = getInstIdByDomain(wlan.domain);
	
    if ((wlanInst == fonssidinst.fonssid2g) || (wlanInst == fonssidinst.fonssid5g))
    {
        return false;
    }
	if(1 != wlan.X_HW_ServiceEnable)
	{
		return false;
	}
	if(undefined != GuestWifiMap[wlanInst])
	{
		return false;
	}
								
	return true;
}

function GetWlanListByFilter(filterFunction)
{
	var WlansResult = new Array();
	var i=0;
	var j=0;

	for (i = 0; i < WlanInfo.length - 1; i++)
	{
		if (filterFunction != null && filterFunction != undefined)
		{	
			if (filterFunction(WlanInfo[i]) == false)
			{
			   continue;
			}
		}
		
		WlansResult[j]=WlanInfo[i];
		j++;
	}
	return WlansResult;
}

function InitWlanNameListControlWlanname(WlanListControlId, IsThisWlanOkFunction)
{
    var Control = getElById(WlanListControlId);
    var WlanList = GetWlanListByFilter(IsThisWlanOkFunction);
    var i = 0;

    for (i = 0; i < WlanList.length; i++)
    {
        var Option = document.createElement("Option");
        Option.value = WlanList[i].domain;
        Option.innerText = WlanList[i].ssid;
        Option.text = WlanList[i].ssid;  
        Control.appendChild(Option);
    }
}

window.onload = function()
{
	InitWanNameListControlWanname("EgressInterface", CheckWanOkFunction);
	loadlanguage();
}

</script> 
<script language="JavaScript" type="text/javascript">
var OperatorFlag = 0;
var OperatorIndex = 0;

function SetGREInfo(GreTunelList, GreIngressList)
{
	var waninfo = GetWanInfoByDomain(GreTunelList.EgressInterface);
	
	
	setText("TunelName", GreTunelList.Name);
	setText("RemoteAddress", GreTunelList.RemoteAddress);
	setSelect("DSCPMarkPolicy", GreTunelList.DSCPMarkPolicy);
	setSelect("EgressPriPolicy", GreTunelList.EgressPriPolicy);
	setText("EgressInterface", waninfo);
	setCheck("VlanSwitch", GreIngressList.VLANTaggingEnable);
	setText("VlanId", GreIngressList.VLANID);
	setSelect("DefaultVlanPriority", GreIngressList.Pri);
	
	setText("DownRateLimit", IspSsidList[0].DownRateLimit);
	setText("UpRateLimit", IspSsidList[0].UpRateLimit);
	setText("InterfaceName", IspSsidList[0].SSID);
}

function SetISPinfo()
{
	setText("DownRateLimit", IspSsidList[0].DownRateLimit);
	setText("UpRateLimit", IspSsidList[0].UpRateLimit);
	setText("InterfaceName", IspSsidList[0].SSID);
}

function OnNewInstance(index)
{
   OperatorFlag = 1;
   document.getElementById("TableConfigInfo").style.display = "block";
   SetISPinfo();
}

function onSumbitCheck()
{
	if ( (false == isValidIpAddress(getValue("RemoteAddress"))) && (false == CheckDomainName(getValue("RemoteAddress"))))
	{
		AlertEx(softgre_language['bbsp_isinvalip']);
		return false;
	}
	if (1 == getCheckVal("VlanSwitch"))
	{
		if ((getValue("VlanId") < 1) || (getValue("VlanId") > 4094))
		{
			AlertEx(softgre_language['bbsp_VlanIDranges']);
			return false;
		}
	}
	
    return true;
}

function OnAddNewSubmit()
{
	if (false == onSumbitCheck())
    {
    	return false;
    }
	
	var urldata = 'complex.cgi?Add_x=' + 'InternetGatewayDevice.X_HW_GRETunnel' +
							'&Addconnect_y='+'InternetGatewayDevice.X_HW_GRETunnel.' + '{i}.IngressInterface' +
							'&z='+'InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.1'+
							'&RequestFile=html/bbsp/softgre/softgre.asp';
	
	var  waninterface = "";
	var waninfo = GetWanInfoByWanName(getValue("EgressInterface"));
	if (undefined != waninfo.domain)
	{
		waninterface  = waninfo.domain;
	}
	
	var Form = new webSubmitForm();
    Form.addParameter('Add_x.Name', getValue("TunelName"));
    Form.addParameter('Add_x.RemoteAddress',getValue("RemoteAddress"));
    Form.addParameter('Add_x.DSCPMarkPolicy',getValue("DSCPMarkPolicy"));	
    Form.addParameter('Add_x.EgressPriPolicy',getValue("EgressPriPolicy"));
	Form.addParameter('Add_x.EgressInterface',waninfo.domain);
	Form.addParameter('Addconnect_y.InterfaceName', 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.'+IspSsidList[0].SSID_IDX);
    Form.addParameter('Addconnect_y.VLANTaggingEnable', getCheckVal("VlanSwitch"));
	Form.addParameter('z.UpRateLimit', getValue("UpRateLimit"));
	Form.addParameter('z.DownRateLimit', getValue("DownRateLimit"));
	Form.addParameter('z.SSID', getValue("InterfaceName"));
	
	if (1 == getCheckVal("VlanSwitch"))
	{
		Form.addParameter('Addconnect_y.VLANID',getValue("VlanId"));	
		Form.addParameter('Addconnect_y.Pri',getValue("DefaultVlanPriority"));
	}    
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction(urldata);
    Form.submit();
	
	DisableRepeatSubmit();
}

function ModifyInstance(index)
{
    OperatorFlag = 2;
    OperatorIndex = index;
    
    document.getElementById("TableConfigInfo").style.display = "block";
	SetGREInfo(GreTunelList[index], GreIngressList[index]);
}
 
function OnModifySubmit()
{
	if(false == onSumbitCheck())
    {
    	return false;
    }

	var  waninterface = "";
	var waninfo = GetWanInfoByWanName(getValue("EgressInterface"));
	if (undefined != waninfo.domain)
	{
		waninterface  = waninfo.domain;
	}
	var Form = new webSubmitForm();
    Form.addParameter('GROUP_a_x.Name', getValue("TunelName"));
    Form.addParameter('GROUP_a_x.RemoteAddress',getValue("RemoteAddress"));
    Form.addParameter('GROUP_a_x.DSCPMarkPolicy',getValue("DSCPMarkPolicy"));	
    Form.addParameter('GROUP_a_x.EgressPriPolicy',getValue("EgressPriPolicy"));
	Form.addParameter('GROUP_a_x.EgressInterface',waninterface);
	//Form.addParameter('GROUP_a_y.InterfaceName', 'InternetGatewayDevice.LANDevice.1.WLANConfiguration.'+IspSsidList[0].SSID_IDX);
    Form.addParameter('GROUP_a_y.VLANTaggingEnable', getCheckVal("VlanSwitch"));
	Form.addParameter('z.UpRateLimit', getValue("UpRateLimit"));
	Form.addParameter('z.DownRateLimit', getValue("DownRateLimit"));
	Form.addParameter('z.SSID', getValue("InterfaceName"));
	
	if (1 == getCheckVal("VlanSwitch"))
	{
		Form.addParameter('GROUP_a_y.VLANID',getValue("VlanId"));	
		Form.addParameter('GROUP_a_y.Pri',getValue("DefaultVlanPriority"));
	}    
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' + 'GROUP_a_x=InternetGatewayDevice.X_HW_GRETunnel.1&GROUP_a_y=InternetGatewayDevice.X_HW_GRETunnel.1.IngressInterface.1' + '&z=InternetGatewayDevice.LANDevice.1.X_HW_WLANForISP.1'+'&RequestFile=html/bbsp/softgre/softgre.asp');
	Form.submit();

    DisableRepeatSubmit();
}

function DeleteLineRow()
{
   var tableRow = getElementById("GREConfigList");
   if (tableRow.rows.length > 1)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

function setControl(index)
{ 
   
    selIndex = index;
	if (index < -1)
	{
		return;
	}

    OperatorIndex = index;   

    if (-1 == index)
    {
		var RecordCount = GreTunelList.length - 1;
		if (RecordCount >= 1)
		{
			DeleteLineRow();
			AlertEx(softgre_language['bbsp_maxmum']);
			return;
		}
		else
			return OnNewInstance(index);
    }
    else
    {
        return ModifyInstance(index);
    }
}

function OnDeleteButtonClick(TableID)
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
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }

        Form.addParameter(CheckBoxList[i].value,'');
    }
    
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_GRETunnel.1' + '&RequestFile=html/bbsp/softgre/softgre.asp');
    Form.submit();
}

function GREConfigListselectRemoveCnt(obj)
{
	
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
</script> 

<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
	var GREConfigListInfo = new Array(new stTableTileInfo("Empty","align_center","DomainBox"),
										new stTableTileInfo("TunelName","align_center restrict_dir_ltr","Name"),
										new stTableTileInfo("DSCPMarkPolicy","align_center","DSCPMarkPolicy"),
										new stTableTileInfo("EgressPriPolicy","align_center","EgressPriPolicy"),null);
	InitTableData();
</script>
  
<form id="TableConfigInfo" style="display:none;"> 
	<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
		<li   id="SoftGRETunnel"              RealType="HorizonBar"         DescRef="SoftGRETunnel"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="TunelName"   RealType="TextBox"          DescRef="TunelName"  RemarkRef="bbsp_Namerange"  maxlength="32" ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Name"  Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="RemoteAddress"   RealType="TextBox"          DescRef="RemoteAddress"  RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.RemoteAddress"  Elementclass="width_254px"  InitValue="Empty"/>
		<li   id="DSCPMarkPolicy"       RealType="DropDownList"     DescRef="DSCPMarkPolicy"   RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DSCPMarkPolicy"		InitValue="[{TextRef:'Specified',Value:'Specified'},{TextRef:'CopyFromOriginalPacket',Value:'CopyFromOriginalPacket'}]" />
		<li   id="EgressPriPolicy"            RealType="DropDownList"    DescRef="EgressPriPolicy"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.EgressPriPolicy"     InitValue="[{TextRef:'CopyFromIngressInterface',Value:'CopyFromIngressInterface'},{TextRef:'FollowEgressInterface',Value:'FollowEgressInterface'}]" />
		<li   id="EgressInterface"   RealType="DropDownList"          DescRef="EgressInterface"  RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.EgressInterface"  InitValue="Empty"/>
		
		<li   id="InterfaceName"   RealType="TextBox"          DescRef="InterfaceName"  RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.InterfaceName"  InitValue="Empty"/>		
		<li   id="VlanSwitch"                RealType="CheckBox"           DescRef="EnableVlan"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.EnableVlan"         InitValue="Empty" />
		<li   id="VlanId"                    RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.VlanId"             InitValue="Empty"/>
		<li   id="DefaultVlanPriority"       RealType="DropDownList"       DescRef="DefaultVlanPriority"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DefaultPriority"    InitValue="[{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]" />
		<li   id="UpRateLimit"                    RealType="TextBox"            DescRef="UpRateLimit"                    RemarkRef="Empty"    ErrorMsgRef="Empty"    Require="FALSE"     BindField="z.UpRateLimit"             InitValue="Empty"/>
		<li   id="DownRateLimit"                    RealType="TextBox"            DescRef="DownRateLimit"                    RemarkRef="Empty"    ErrorMsgRef="Empty"    Require="FALSE"     BindField="z.DownRateLimit"             InitValue="Empty"/>
	</table> 
	<script language="JavaScript" type="text/javascript">
		var ArppingConfigFormList = new Array();
		ArppingConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		var formid_hide_id = null;
		HWParsePageControlByID("TableConfigInfo", TableClass, softgre_language, formid_hide_id);
	</script>
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per15"></td> 
        <td class="table_submit pad_left5p">
		    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Apply' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(softgre_language['bbsp_app']);</script></button>
          	<button id='Cancel' type=button onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(softgre_language['bbsp_cancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
</form> 
<script>
InitControlDataType();
</script> 
</body>
</html>

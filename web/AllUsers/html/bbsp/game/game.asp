<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="Pragma" content="no-cache" /> 
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/wandns.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<title>Service Identification</title>
</head>
<body class="mainbody">
<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("serviceroutetitle", GetDescFormArrayById(sergame_language, "bbsp_mune"), GetDescFormArrayById(sergame_language, "bbsp_serroute_title"), false);
</script> 
<div class="title_spread"></div>
      
<script language="javascript">
var selIndex = -1;
var TableName = "ServiceGameConfigList";
var viettelflag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_VIETTEL);%>';
var EthNum = '<%GetLanPortNum();%>';
var LanNameList = new Array();
var LanNameLists = new Array();

var gameList = ["Game", "Game"];
var SSIDNameList =  GetRealSSIDList();

function stLanInfo(domain,name) {
    this.domain = domain ;
    this.name = name;
}

for (var i = 1;i <= EthNum;i++) {
    LanNameList.push('LAN' + i);
    LanNameLists.push(new stLanInfo('InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.' + i,'LAN' + i));
}

var SSIDList = new Array();

for (var i = 0;i <= SSIDNameList.length-1;i++) {
    SSIDList.push(SSIDNameList[i].ssid + " " + "（" + SSIDNameList[i].freq + "）");
}

function InitConfigForm() {    
    for (var i = 0; i < gameList.length; i++) {
         if (gameList[i] !== "") {
             $("#gameList").append('<option value=' + gameList[i] + ' id="' + gameList[i] + '">' + gameList[i] + '</option>');
         } else {
             $("#gameList").append('<option value=' + gameList[i] + '>' + gameList[i] + '</option>');
         }    
    }
    for (var i = 0; i < LanNameList.length; i++) {
        $("#ServiceType").append('<option value=' + LanNameList[i] + ' id="' + LanNameList[i] + '">' + LanNameList[i] + '</option>');
    }
    for (var i = 0; i < SSIDNameList.length; i++) {
        $("#ServiceType").append('<option value=' + SSIDList[i] + ' id="' + SSIDList[i] + '">' + SSIDList[i] + '</option>');
    }
}

function PolicyGameItem(domain, Service, Interface) {
    this.Domain = domain;
    this.Service = Service;
    this.Interface = Interface;
}

var PolicyGameListAll =<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_PortService.{i},Service|Interface,PolicyGameItem);%>;  
var PolicyGameList = new Array();
var i,j = 0;
for (i = 0; i < PolicyGameListAll.length; i++) {  
     PolicyGameList[j++] = PolicyGameListAll[i];
}
function loadlanguage() {
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) {
        var b = all[i];
        if(b.getAttribute("BindText") == null) {
            continue;
        }
        b.innerHTML = sergame_language[b.getAttribute("BindText")];
    }
}

window.onload = function() {
    loadlanguage();
}

</script>
<script language="JavaScript" type="text/javascript">
var OperatorFlag = 0;
var OperatorIndex = 0;

function GetPortNameDomian(portType) {
    var portdomain = "";
    for (var i = 0 ; i< LanNameList.length ; i++) {
        if (portType == LanNameList[i]) {
            portdomain = LanNameLists[i].domain;
        }
    }
    for (var i = 0 ; i< SSIDList.length ; i++) {
        if (portType == SSIDNameList[i].ssid) {
            portdomain = SSIDNameList[i].domain;
        }
    }
    return portdomain;
}
 
function GetInputRouteInfo() {
    return new PolicyGameItem(getSelectVal("ServiceType"), getSelectVal("gameList"));  
}

function SetInputRouteInfo(gameInfo) {
    setSelect("ServiceType", gameInfo.Interface);
    setSelect("gameList", gameInfo.Service); 
}

function SetInterface(gameInfo) {
    var str = gameInfo.Interface.substr(gameInfo.Interface.length-1);
    if (gameInfo.Interface.indexOf("LANEthernetInterfaceConfig") > -1) {
        setSelect("ServiceType", "LAN" + str);
    } else if(gameInfo.Interface.indexOf("WLANConfiguration") > -1) {
        for (var j = 0;j <= SSIDNameList.length-1;j++) {
             var str1 = SSIDNameList[j].domain.substr(SSIDNameList[j].domain.length-1);
             if (str1 == str) {
                 setSelect("ServiceType", SSIDNameList[str1-1].ssid);
             }
        } 
    }
}

function OnNewInstance(index) {
   OperatorFlag = 1;
   document.getElementById("TableConfigInfo").style.display = "block";
}

function OnAddNewSubmit() {
    var portType = getSelectVal('ServiceType');
    var gameValue = getSelectVal('gameList');
    srcPortnNameStr = GetPortNameDomian(portType);
  
    var Form = new webSubmitForm();
    Form.addParameter('x.Service',gameValue);
    Form.addParameter('x.Interface',srcPortnNameStr);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));    
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.Services.X_HW_PortService' + '&RequestFile=html/bbsp/game/game.asp');
    Form.submit();
}
    
function ModifyInstance(index) {
    OperatorFlag = 2;
    OperatorIndex = index;
    
    document.getElementById("TableConfigInfo").style.display = "block";
    SetInputRouteInfo(PolicyGameList[index]);
    SetInterface(PolicyGameList[index]); 	
} 

function OnModifySubmit() {    
    var Form = new webSubmitForm();
    var portType = getSelectVal('ServiceType');
    srcPortnNameStr = GetPortNameDomian(portType);
    var gameValue = getSelectVal('gameList');
    
    Form.addParameter('x.Service',gameValue);   
    Form.addParameter('x.Interface',srcPortnNameStr);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' +'x='+ PolicyGameList[OperatorIndex].Domain + '&RequestFile=html/bbsp/game/game.asp');
    Form.submit();  
}
  
function setControl(index) { 
    selIndex = index;   
    if (index < -1) {
        return;
    }
    
    OperatorIndex = index;   

    if (index == -1 ) {
        return OnNewInstance(index);
    } else {
        return ModifyInstance(index);
    }
}

function OnDeleteButtonClick() {
    var CheckBoxList = document.getElementsByName(TableName + 'rml');
    var Count = 0;
    var i;
    for (i = 0; i < CheckBoxList.length; i++) {
        if (CheckBoxList[i].checked == true) {
            Count++;
        }
    }
    
    if (Count == 0) {
        return false;
    }
    
    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++) {
        if (CheckBoxList[i].checked != true) {
            continue;
        }
        Form.addParameter(CheckBoxList[i].value,'');
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.Services.X_HW_PortService' + '&RequestFile=html/bbsp/game/game.asp');
    Form.submit();
}

function OnApply() {
    if (OperatorFlag == 1) {
        return OnAddNewSubmit();
    } else {
        return OnModifySubmit();
    }
}

function ServiceGameConfigListselectRemoveCnt(val) {
}

function OnCancel() {
    getElById('TableConfigInfo').style.display = 'none';
    
    if (selIndex == -1) {
         var tableRow = getElementById(TableName);
         if (tableRow.rows.length > 2)
         tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}

function InitTableData() {
    var RecordCount = PolicyGameList.length - 1;
    var i = 0;
    for (i = 0; i < RecordCount; i++) {
        TableDataInfo[i].domain = PolicyGameList[i].Domain;
        TableDataInfo[i].Service = PolicyGameList[i].Service;
        var str = PolicyGameList[i].Interface.substr(PolicyGameList[i].Interface.length-1);
        if (PolicyGameList[i].Interface.indexOf("LANEthernetInterfaceConfig") > -1) {
            TableDataInfo[i].Interface = "LAN" + str;
        } else if(PolicyGameList[i].Interface.indexOf("WLANConfiguration") > -1) {
            for (var j = 0;j <= SSIDNameList.length-1;j++) {
                 var str1 = SSIDNameList[j].domain.substr(SSIDNameList[j].domain.length-1);
                 if (str1 == str) {
                     TableDataInfo[i].Interface = SSIDNameList[str1-1].ssid  + " " + "（" + SSIDNameList[str1-1].freq + "）";
                 }
            } 
        }
    }
}
</script>
<script language="JavaScript" type="text/javascript">
    var ServiceGameConfigListInfo = new Array(new stTableTileInfo("Empty","align_center","DomainBox"),
                                    new stTableTileInfo("bbsp_sertype","align_center","Interface",false,16),
                                    new stTableTileInfo("bbsp_game","align_center restrict_dir_ltr","Service"),null);
    var ColumnNum = 3;
    var ShowButtonFlag = true;
    var TableDataInfo =  HWcloneObject(PolicyGameList, 1);
    InitTableData();
    HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, ServiceGameConfigListInfo, sergame_language, null);
</script> 
  
<form id="TableConfigInfo" style="display:none">
  <div class="list_table_spread"></div>
  <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
        <li   id="ServiceType"      RealType="DropDownList"       DescRef="bbsp_sertypemh"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"    BindField=""    Elementclass="width_200px"     InitValue="Empty"/>
        <li   id="gameList"      RealType="DropDownList"       DescRef="bbsp_gamenamemh"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"    BindField="x.Service"  Elementclass="width_200px restrict_dir_ltr"  InitValue="Empty"/>                                                                   
        <script>
            var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
            var ServiceRouteConfigFormList = new Array();
            ServiceRouteConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
            var formid_hide_id = null;
            HWParsePageControlByID("TableConfigInfo", TableClass, sergame_language, formid_hide_id);
            InitConfigForm();       
        </script>
    </table>
    <table width="100%"  cellspacing="1" class="table_button">
      <tr>
       <td class='width_per15'></td>
        <td class="table_submit pad_left5p">
           <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
           <button type=button id='Apply' onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(sergame_language['bbsp_app']);</script> </button>
           <button type=button id='Cancel' onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(sergame_language['bbsp_cancel']);</script> </button>
        </td>
      </tr>
    </table>
</form>
</body>
</html>

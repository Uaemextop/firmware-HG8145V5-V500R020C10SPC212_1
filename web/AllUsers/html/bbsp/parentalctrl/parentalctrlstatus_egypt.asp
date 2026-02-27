 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<title>PCCstatus</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="JavaScript" type="text/javascript">
var IsPTVDFFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var Custom_cmcc_rms = '<%HW_WEB_GetFeatureSupport(BBSP_FT_CMCC_RMS);%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var BeltelePONFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOM);%>';
var BelteleLanFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOMLAN);%>';
var IsDevTypeFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_USER_DEVTYPE);%>';
var ParentCtrlTimeFeature = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PARENT_TIMTE_FILTER);%>';
var UrlIgnoreFwlevel = '<%HW_WEB_GetFeatureSupport(BBSP_FT_URLFLT_IGNORE_FWLEVEL);%>';
var IPV6Flag = "<%HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>";
var urlfilterByDns = '<%HW_WEB_GetFeatureSupport(BBSP_FT_URLFILTER_BY_DNS);%>';
var ChildListArray = GetChildList();
var ChildListArrayNr = ChildListArray.length-1;
var TemplatesListArray = GetTemplatesList();
var TemplatesListArrayNr = TemplatesListArray.length-1;
var DurationList = GetDurationList();
var ProductType = '<%HW_WEB_GetProductType();%>'; 
var firstpage = "1";
var FOR_NULL="--";
var UrlListMax = 128;
var currentFile='parentalctrlstatus_egypt.asp';
if(UrlValueArrayNr == 0) {
    firstpage = 0;
}
function IpConcernClass(_Domain, _IpConcern) {
    this.Domain = _Domain;
    this.IpConcern = _IpConcern;
}
function UrlFilterBaseValueClass(_Domain, _Policy, _Right) {
    this.Domain = _Domain;
    this.Policy = _Policy;
    this.Right = _Right;
}
var BaseUrlFilterValue = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i},UrlFilterPolicy|UrlFilterRight,UrlFilterBaseValueClass);%>;
var BaseIpConcernValue = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security,UrlFilterIpConcern,IpConcernClass);%>;
if (1 == BaseUrlFilterValue.length) {
    BaseUrlFilterValue = new Array();
    BaseUrlFilterValue[0] = new UrlFilterBaseValueClass();
    BaseUrlFilterValue[0].Right = "0";
    BaseUrlFilterValue[0].Policy = "1";
    BaseIpConcernValue = new IpConcernClass();
    BaseIpConcernValue.IpConcern = "0";
    UrlValueArray = new Array();
}
var FlagStatus = "EditTemplate";
var TemplateName = "template";
var TemplateInst = "1";
var CurTemplateId = "1";
var DurationListMax = 4;
var MAX_DEVICES = 8;
var UrlValueArray = GetUrlValueArray("1");
var UrlValueArrayNr = UrlValueArray.length;
var VarFilterApplyRange = GetFilterApplyRange();
var list = 10;
var lastpage = UrlValueArrayNr/list;
if(lastpage != parseInt(lastpage,10)) {
    lastpage = parseInt(lastpage,10) + 1;
}

var currentpage = firstpage;
var Page = new UrlFilterPage();
Page.LoadData();

function IsUrlIncludeIpv6Addr(strUrl) {
    if (IPV6Flag == 1) {
        if ((strUrl.indexOf("[") != -1) && (strUrl.indexOf("]") != -1)) {
            return true;
        }
    }
    return false;
}
function IsUrlRepeat(UrlList, NewUrl) {
    var i;
    for (i = 0; i < UrlList.length; i++) {
        if (UrlList[i] == null) {
            break;
        }
        if (UrlList[i].UrlAddress.toLowerCase() == NewUrl.toLowerCase()) {
            return true;
        }
    }
    return false;
}
function submitnext() {
    if (false == IsValidPage(currentpage)) {
        return;
    }
    currentpage++;
    window.location= currentFile + "?" + parseInt(currentpage,10);
}
function submitjump() {
    var jumppage = getValue('pagejump');
    if ((jumppage == '') || (isInteger(jumppage) != true)) {
        setText('pagejump', '');
        return;
    }
    jumppage = parseInt(jumppage, 10);
    if (jumppage < firstpage) {
        jumppage = firstpage;
    }
    if (jumppage > lastpage) {
        jumppage = lastpage;
    }
    window.location= currentFile + "?" + jumppage;
}
if(window.location.href.indexOf("?") > 0){
    if (window.location.href.indexOf("AddAllDev") != -1) {
        VarFilterApplyRange = "ALLDEVICE";
    } else {
        var para = window.location.href.split("?");
        var CurPage = para[1];
        if ('' != CurPage && CurPage.indexOf("=") < 0) {
            currentpage =parseInt(CurPage,10); 
        } else {
            currentpage = 1;
        }
    }
}
if(currentpage < firstpage) {
    currentpage = firstpage;
}
else if (currentpage > lastpage) {
    currentpage = lastpage;
}

function IsNeedAddSafeDesForBelTelecom() {
    if (1 == BeltelePONFlag || 1 == BelteleLanFlag || CfgModeWord.toUpperCase().indexOf("BELTELECOM") >= 0){
        return true;
    }
    return false;
}

function loadlanguage() {
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) {
        var b = all[i];
        if(b.getAttribute("BindText") == null) {
            continue;
        }
        setObjNoEncodeInnerHtmlValue(b, parentalctrl_language[b.getAttribute("BindText")]);
    }
}
function IsValidPage(pagevalue) {
    if (true != isInteger(pagevalue)) {
        return false;
    }
    return true;
}

function LoadFrame() {
    loadlanguage();
    LoadFrameTime();
    LoadFrameMac();
    LoadFrameUrl();
}

function PCCInfoselectRemoveCnt(val) {
}

function PCtrMacConfigListselectRemoveCnt(val) {
}

function adjustParentHeight(containerID, newHeight) {
    $("#DivContent").css("height", 'auto');
    var newHeight1 = (newHeight > 700) ? newHeight : 700;
    $("#" + containerID).css("height", newHeight1 + "px");

    if ((navigator.appName.indexOf("Internet Explorer") == -1) && (containerID == "pccframeWarpContent")) {
        var height1 = document.body.scrollHeight;
        var height = (height1 > 700) ? height1 : 700;
        $("#DivContent").css("height", height + "px");
    }
}

function InitTableDataMac() {
    if((TableDataInfoMac.length - 1 > 0)&&(VarFilterApplyRange=="ALLDEVICE")) {
        TableDataInfoMac[0].domain = TableDataInfoMac[0].domain;
        TableDataInfoMac[0].MACAddress = parentalctrl_language["bbsp_allDevice"];
        if (TableDataInfoMac[0].Description == '') {
            TableDataInfoMac[0].Description = FOR_NULL;
        }
        TableDataInfoMac[0].TemplateInst = "1";
    } else {
        for (var i = 0; i < TableDataInfoMac.length - 1 ; i++) {
            if (TableDataInfoMac[i].Description == '') {
                TableDataInfoMac[i].Description = FOR_NULL;
            }
            TableDataInfoMac[i].TemplateInst = "1";
        }
    }
}

function GetOneDurationNum(CurTemplateId) {
    var num = 0;
    for (var i = 0; i < DurationList.length -1; i++) {
        if (DurationList[i].TemplateId == CurTemplateId) {
            num++;
        }
    }
    return num;
}
var dayCount = [
    parentalctrl_language['bbsp_Monday'] + "/",
    parentalctrl_language['bbsp_Tuesday'] + "/",
    parentalctrl_language['bbsp_Wednesday'] + "/",
    parentalctrl_language['bbsp_Thursday'] + "/",
    parentalctrl_language['bbsp_Friday'] + "/",
    parentalctrl_language['bbsp_Saturday'] + "/",
    parentalctrl_language['bbsp_Sunday'] + "/"
]
function RepeatDayCount(strRepeatDay) {
    var DayString ='';
    for ( var i = 0 ; i < strRepeatDay.length ; i++ ) {
        var ch = strRepeatDay.charAt(i);
        if(ch > 0 && ch < 8){
            DayString +=dayCount[ch-1];
        }
    }
    DayString = DayString.substring(0,DayString.lastIndexOf('/'));
    return DayString;
}
function InitTableDataTime() {
    var num = GetOneDurationNum("1");
    var k = 0;
    for (var i = 0; i < DurationList.length -1; i++) {
        if (DurationList[i].TemplateId == "1") {
            TableDataInfoTime[k] = new DurationListClass();
            TableDataInfoTime[k].domain = DurationList[i].domain;
            TableDataInfoTime[k].Duration = DurationList[i].StartTime + '-' + DurationList[i].EndTime;
            TableDataInfoTime[k].RepeatDay = RepeatDayCount(DurationList[i].RepeatDay);
            k++;
        }
    }
}

function GetUserDevAlias(obj) {
    var UserDevAliasValue = "";
    if (obj.UserDevAlias != "--") {
        return obj.UserDevAlias;
    } else {
        return obj.MacAddr;
    }
}

function WriteDeviceOption(UserDevices) {
    var UserDevicesnum = UserDevices.length - 1;
    var output = "";

    if (UserDevicesnum<=0) {
        output = '<option value="OtherMac">' + parentalctrl_language['bbsp_manually'] + '</option>';
        $("#ChildrenList").append(output);
    } else {
        for (var i = 0; i < UserDevicesnum; i++) {
            for(var j = 0; j < ChildListArrayNr;j++) {
                if (UserDevices[i].MacAddr == ChildListArray[j].MACAddress )
                    break;
            }
            if (j == ChildListArrayNr) {
                if (IsDevTypeFlag == 1) {
                    output = '<option value=\"' + htmlencode(UserDevices[i].MacAddr) +'\" title="'+MakeDeviceOption(htmlencode(GetUserDevAlias(UserDevices[i])),UserDevices[i].HostName) + UserDevices[i].IpAddr +'">'+GetStringContent((MakeDeviceOption(htmlencode(GetUserDevAlias(UserDevices[i])),UserDevices[i].HostName) + UserDevices[i].IpAddr),48) + '</option>';
                } else {
                    output = '<option value=\"' + htmlencode(UserDevices[i].MacAddr) +'\" title="'+MakeDeviceOption(UserDevices[i].MacAddr,UserDevices[i].HostName) + UserDevices[i].IpAddr+'">'+GetStringContent((MakeDeviceOption(UserDevices[i].MacAddr,UserDevices[i].HostName) + UserDevices[i].IpAddr),48) + '</option>';
                }
                $("#ChildrenList").append(output);
            }
        }
        output = '<option value="OtherMac">' + parentalctrl_language['bbsp_manually'] + '</option>';
        $("#ChildrenList").append(output);
    }
}
function MakeDeviceOption(MacAddr,HostName) {
   var DeviceStr;

    if (HostName=='') {
        return MacAddr + '&nbsp;&nbsp;';
    } else {
        HostName = htmlencode(HostName);
        DeviceStr=MacAddr +'&nbsp;&nbsp;'+ HostName + '&nbsp;&nbsp;';
        return DeviceStr;
    }
}

function showlist(startlist , endlist) {
    var TableDataInfoUrl = new Array();
    var i = 0;
    var UrlListlen = 0;

    for(i=startlist;i <= endlist - 1;i++) {
        if (UrlValueArray[i] == null) {
            continue;
        }
        var urlArray = GetUrlValueArray(CurTemplateId);
        TableDataInfoUrl[UrlListlen] = new UrlFilterUrlAddress();
        TableDataInfoUrl[UrlListlen].domain = urlArray[i].Domain;
        TableDataInfoUrl[UrlListlen].UrlAddress = UrlValueArray[i].UrlAddress;
        UrlListlen++;
    }
    TableDataInfoUrl.push(null);
    HWShowTableListByType(1, "PCtrUrlConfigList", ShowButtonFlagUrl, ColumnNumUrl, TableDataInfoUrl, PCtrUrlConfiglistInfo, parentalctrl_language, null);
}
function showlistcontrol() {
    if(UrlValueArrayNr == 0) {
        showlist(0 , 0);
    } else if( UrlValueArrayNr >= list*parseInt(currentpage,10) ) {
        showlist((parseInt(currentpage,10)-1)*list , parseInt(currentpage,10)*list);
    } else {
        showlist((parseInt(currentpage,10)-1)*list , UrlValueArrayNr);
    }
}

function LoadFrameMac() {
    if (ChildListArrayNr == 0) {
        selectLine('record_no');
    } else {
        setDisplay('TableConfigInfoMac', 0);
    }

    if (VarFilterApplyRange=="ALLDEVICE") {
        document.getElementById("RadioAllDevice").checked = true;
        if(ChildListArrayNr > 0){
            setDisable('Newbutton',1);
        }
    } else {
        document.getElementById("RadioSpecifiedDevice").checked = true;
    }

    loadlanguage();
    CurDevSelect = getRadioVal('idRadioDevice');
}

function LoadFrameTime() {
    if (FlagStatus == "AddTemplate") {
        SetDivValue("DivTimedurationTitle",parentalctrl_language['bbsp_step2']);
        document.getElementById("buttonTime").innerHTML = parentalctrl_language['bbsp_next'];
    } else if (FlagStatus == "EditTemplate") {
        SetDivValue("DivTimedurationTitle",parentalctrl_language['bbsp_accesstimeduration']);
    }

    SetDisplayParentCtrlTime();

}

function GetTimeFilterRight(TemplateId) {
    var TimeFilterRight = "";
    for (var i = 0; i < TemplatesListArray.length-1; i++) {
        if (TemplatesListArray[i].TemplateId == TemplateId) {
            TimeFilterRight = TemplatesListArray[i].DurationRight;
        }
    }
    return TimeFilterRight;
}

function SetDisplayParentCtrlTime() {
    if (0 == ParentCtrlTimeFeature) {
        return ;
    }

    document.getElementById("TimeFilterCfg").style.display = '';
    SetDivValue("DivTimedurationTitle",parentalctrl_language['bbsp_settimeduration']);

    var TimeEnable = 0;
        TimeEnable = GetTimeFilterRight(CurTemplateId);

    setCheck('EnableFilter',TimeEnable);

    if (ENABLEFILTER_CHECKED == TimeEnable) {
        setDisplay("FilterListRow",1);
        setDisplay("PCCInfo_tbl",1);
    } else {
        setDisplay("FilterListRow",0);
        setDisplay("PCCInfo_tbl",0);
    }
    setDisplay("ConfigPanel", 0);
}

function GetUrlFilterRight(TemplateId) {
    var UrlFilterRight = "";
    for (var i = 0; i < TemplatesListArray.length-1; i++) {
        if (TemplatesListArray[i].TemplateId == TemplateId) {
            UrlFilterRight = TemplatesListArray[i].UrlFilterRight;
        }
    }
    return UrlFilterRight;
}

function LoadFrameUrl() {
    if ((FltsecLevel.toUpperCase() != 'CUSTOM') && (UrlIgnoreFwlevel != 1)) {
        setDisable('SmartEnable' , 1);
        setDisable('FilterMode' , 1);
    }

    var UrlEnable = GetUrlFilterRight("1");
    if (UrlEnable == "1") {
        setDisplay("FilterMode"+"Row",1);
        setDisplay("divConfigUrlForm",1);
        setCheck('UrlEnable',1);
        setDisplay("tabBtnFinsh",1)
    } else {
        setDisplay("FilterMode"+"Row",0);
        setDisplay("divConfigUrlForm",1);
        setCheck('UrlEnable',0);
        setDisplay("tabBtnFinsh",0)
    }
    getElById("FilterMode")[0].selected = true;
    if (BaseUrlFilterValue[0].Policy == "1") {
        getElById("FilterMode")[1].selected = true;
    }
    SetDivValue("DivUrlTitle",parentalctrl_language['bbsp_inputurllist']);
    loadlanguage();
}
function setControl(index,objid) {
    selectindex = index;
    var TableId = objid.split('_')[0];

    if (selectindex < -1) {
        adjustParentHeight();
        return;
    }

if (TableId == "PCCInfo") {
    if (selectindex == -1) {
        if (GetOneDurationNum(CurTemplateId) >= DurationListMax) {
            DeleteLineRow();
            AlertEx(parentalctrl_language['bbsp_timedurationfull']);
            setDisplay('ConfigPanel', 0);
            return;
        } else {
            setDisable('StartHour',0);
            setDisable('StartMinute',0);
            setDisable('EndHour',0);
            setDisable('EndMinute',0);
            setCheck('AllDay',0);
            setCheck('EveryDay',0);
            setText('StartHour', '');
            setText('StartMinute', '');
            setText('EndHour', '');
            setText('EndMinute', '');
            RepeatDayEx('',0);
            setDisplay("ConfigPanel", "1"); 
        }
    } else {
        setDisplay("ConfigPanel", "1");
        setDisable('StartHour',0);
        setDisable('StartMinute',0);
        setDisable('EndHour',0);
        setDisable('EndMinute',0);
        setCheck('AllDay',0);
        setCheck('EveryDay',0);
        var Id = GetSelectIdByIndex(selectindex);
        setText('StartHour',HourTimeEx(DurationList[Id].StartTime));
        setText('StartMinute',MinTimeEx(DurationList[Id].StartTime));
        setText('EndHour',HourTimeEx(DurationList[Id].EndTime));
        setText('EndMinute',MinTimeEx(DurationList[Id].EndTime));
        RepeatDayEx(DurationList[Id].RepeatDay,1);
    }
    setDisplay('TableConfigInfoMac', 0);
    setDisplay('ConfigUrlPanel', 0);
} else if (TableId == "PCtrMacConfigList") {
if (-1 == selectindex) {
        if (TemplatesListArrayNr === 0) {
            AlertEx(parentalctrl_language['bbsp_notemplate']);
            adjustParentHeight();
            return;
        }
        if(VarFilterApplyRange=="ALLDEVICE") {
            if (ChildListArrayNr >= 1) {
                DeleteLineRow();
                setDisplay('TableConfigInfoMac', 0);
                adjustParentHeight();
                return;
            }
        } else {
            if(ChildListArrayNr >= MAX_DEVICES) {
                DeleteLineRow();
                setDisplay('TableConfigInfoMac', 0);
                AlertEx(parentalctrl_language["bbsp_maxdevice"]);
                adjustParentHeight();
                return ;
            }
         }

        setDisable("ChildrenList",0);
        setText("ChildrenInfo","");
        setDisable("ChildrenInfo",0);
        setText("macAddr","");

        var selectObj = document.getElementById('ChildrenList');
        var optionArry = selectObj.options;

        if (window.location.href.indexOf("?") > 0 && (GetCfgMode().OSK == 1 || GetCfgMode().COMMON == 1)) {
            for (var i = 0,optionnum = optionArry.length - 1;i <= optionnum;i++) {
                if (optionArry[i].label.indexOf(numpara) >= 0) {
                    selectObj[i].selected = true;
                    break;
                }
                if (i == optionnum) {
                    selectObj[0].selected = true;
                }
            }
        } else {
            selectObj[0].selected = true;
        }

        setDisplay("ChildrenInfo",1);
        if (VarFilterApplyRange=="ALLDEVICE") {
            setDisplay('DisplayAllDevice'+'Row', 1);
            setDisplay('DisplaySpecifiedDevice'+'Row', 0);
            setDisplay('ChildrenList'+'Row', 0);
            setDisplay('macAddr'+'Row', 0);
        } else {
            setDisplay('DisplayAllDevice'+'Row', 0);
            setDisplay('DisplaySpecifiedDevice'+'Row', 0);
            setDisplay('ChildrenList'+'Row', 1);
            setDisplay('macAddr'+'Row', 1);
        }
        
        if (1==optionArry.length) {
            setDisplay("macAddr"+"Row",1);
        } else {
            setDisplay("macAddr"+"Row",0);
        }
        setDisplay('TableConfigInfoMac', 1);
    } else {
        var selectObj = document.getElementById('ChildrenList');
        var optionArry = selectObj.options;
        var TemplateName = "";

        setDisable("ChildrenList",1);

        selectObj.selectedIndex = optionArry.length-1;
        setDisplay("macAddr"+"Row",1);
        if (VarFilterApplyRange=="ALLDEVICE") {
            setText("ChildrenInfo",ChildListArray[0].Description);
            setDisable("ChildrenInfo",0);
            TemplateName = "1";
        } else {
            setText("ChildrenInfo",ChildListArray[selectindex].Description);
            setDisable("ChildrenInfo",0);
            TemplateName = "1";
            setText("macAddr",ChildListArray[selectindex].MACAddress);
        }
        setSelect("TemplateList",TemplateName);

        if (VarFilterApplyRange=="ALLDEVICE") {
            setDisplay('DisplayAllDevice'+'Row', 1);
            setDisplay('DisplaySpecifiedDevice'+'Row', 0);
            setDisplay('ChildrenList'+'Row', 0);
            setDisplay('macAddr'+'Row', 0);
        } else {
            setNoEncodeInnerHtmlValue("DisplaySpecifiedDevice", MakeDeviceSpecName(ChildListArray[selectindex].MACAddress));
            setDisplay('DisplayAllDevice'+'Row', 0);
            setDisplay('DisplaySpecifiedDevice'+'Row', 1);
            setDisplay('ChildrenList'+'Row', 0);
            setDisplay('macAddr'+'Row', 0);
        }
        setDisplay('TableConfigInfoMac', 1);
    }
    setDisplay("ConfigPanel", 0);
    setDisplay("ConfigUrlPanel", 0);
} else if (TableId == "PCtrUrlConfigList") {
    if (-1 == selectindex) {
        if (Page.GetData().GetUrlList().length >= UrlListMax) {
            DeleteLineRow();
            AlertEx(parentalctrl_language['bbsp_urlfull']);
            return ;
        }
        adjustParentHeight();
    } else {
        adjustParentHeight();
        return ;
    }
    getElById("ConfigUrlPanel").style.display = "block";
    setDisplay('TableConfigInfoMac', 0);
    setDisplay("ConfigPanel", 0);
}
    adjustParentHeight();
    return;
}

function MakeDeviceSpecName(macaddr) {
    var specialname = macaddr;

    for(var i = 0; i < UserDevinfo.length - 1; i++) {
        if (macaddr == UserDevinfo[i].MacAddr) {
            specialname = MakeDeviceOption(macaddr,UserDevinfo[i].HostName) + UserDevinfo[i].IpAddr;
        }
    }

    return specialname;
}

function ChooseDeviceOption() {
    var RadioValue = getRadioVal('idRadioDevice');
    var requestUrl = "";
    var Onttoken = getValue('onttoken');

    if (CurDevSelect == RadioValue) {
        return;
    }

    if (RadioValue == 'AllDevice') {
        if(ConfirmEx(parentalctrl_language['bbsp_confirm_alldevice'])) {
            for(var i = 0; i < ChildListArrayNr; i++) {
                if (0 === i) {
                    requestUrl +=  ChildListArray[i].domain + "=";
                } else {
                    requestUrl += '&' + ChildListArray[i].domain + "=";
                }
            }

            requestUrl += '&x.X_HW_Token=' + Onttoken;

            $.ajax({
                type : "POST",
                async : false,
                cache : false,
                data : requestUrl,
                url : "del.cgi?&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp",
                error:function(XMLHttpRequest, textStatus, errorThrown) {
                    window.location.replace("parentalctrlstatus_egypt.asp");
                },
                success:function() {
                    window.location="/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp?AddAllDev=1";
                }
            });
            CurDevSelect = RadioValue;
        } else {
            setRadio('idRadioDevice','SpecifiedDevice');
        }
    } else {
        if(ConfirmEx(parentalctrl_language['bbsp_confirm_specdevice'])) {
            var Form = new webSubmitForm();
            var searchList = new Array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p');
            for (var i = 0; i < ChildListArrayNr; i++) {
                var urlPrefix = 'Del_d' + searchList[i];
                if (0 === i) {
                    requestUrl += urlPrefix + '=' + ChildListArray[i].domain;
                }else{
                    requestUrl += '&' + urlPrefix + '=' + ChildListArray[i].domain;
                }
            }

            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.setAction("complex.cgi?" + requestUrl + "&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp");
            Form.submit();
            CurDevSelect = RadioValue;
        } else {
            setRadio('idRadioDevice','AllDevice');
        }
    }
}

function GetSelectIdByIndex(Index) {
    var domain = getValue('PCCInfo_rml'+Index);
    for (var i = 0; i < DurationList.length - 1; i++) {
        if (DurationList[i].domain == domain) {
            return i;
        }
    }
    return -1;
}

function OnCancelTime() {
    setDisplay('TableConfigInfoMac', 0);
    setDisplay("ConfigPanel", 0);
    setDisplay("ConfigUrlPanel", 0);
    if (selectindex == -1) {
        var tableRow = getElement("PCCInfo");
        if (tableRow.rows.length == 1) {

        } else if (tableRow.rows.length == 2) {
            setDisplay("ConfigPanel", "0");
        } else {
            tableRow.deleteRow(tableRow.rows.length-1);
        }
    }
}

function OnCancelUrl() {
    setDisplay('TableConfigInfoMac', 0);
    setDisplay("ConfigPanel", 0);
    setDisplay("ConfigUrlPanel", 0);
    var tableRow = getElementById("PCtrUrlConfigList");
    if (tableRow.rows.length > 2) {
        tableRow.deleteRow(tableRow.rows.length-1);
    }
    return false;
}
function OnCancelMac() {
    setDisplay('TableConfigInfoMac', 0);
    setDisplay("ConfigPanel", 0);
    setDisplay("ConfigUrlPanel", 0);
    if (selectindex == -1) {
        var tableRow = getElement("PCtrMacConfigList");

        if (tableRow.rows.length == 1) {

        } else if (tableRow.rows.length == 2) {
            if (ChildListArrayNr <= 0) {
                setDisplay('TableConfigInfoMac', 0);
            }
        } else {
            tableRow.deleteRow(tableRow.rows.length-1);
        }
    } else {
        if (VarFilterApplyRange=="ALLDEVICE") {
            setDisplay('TableConfigInfoMac', 0);
        }
    }
    
}

function OnChildListChange() {
    var SelectMac= getSelectVal("ChildrenList");

    setText("ChildrenInfo",'');
    if (SelectMac=="OtherMac") {
        setDisplay("macAddr"+"Row",1);
    } else {
        setDisplay("macAddr"+"Row",0);
        for (var j = 0; j < ChildListArrayNr; j++) {
            if ( ChildListArray[j].MACAddress == SelectMac) {
                if (ChildListArray[j].Description != '') {
                    setText("ChildrenInfo",ChildListArray[j].Description);
                }
            }
        }
    }
}

function CheckForm() {
    var SelectMac=getSelectVal('ChildrenList');
    var  ChildInfo= getValue('ChildrenInfo');
    ChildInfo = removeSpaceTrim(ChildInfo);
    var MacAddress = getValue('macAddr');
    var IsAnyTempSelect = false;

    if ('CMCC' != CurrentBin.toUpperCase()) {
       if ((ChildInfo!='')&&(isValidAscii(ChildInfo)!= '')) {
            AlertEx(parentalctrl_language['bbsp_devicescription'] + parentalctrl_language['bbsp_hasvalidch'] + isValidAscii(ChildInfo) + parentalctrl_language['bbsp_end']);
            return false;
       }
   }

    if (selectindex == -1) {
        for (var i = 0; i < ChildListArrayNr; i++) {
            if (SelectMac=="OtherMac") {
                if (MacAddress.toUpperCase() == (ChildListArray[i].MACAddress).toUpperCase() ) {
                    AlertEx(parentalctrl_language["bbsp_repeatmac"]);
                    return false;
                }
            }
        }
    }
   return true;
}

function OnApply() {
    var SelectMac = getSelectVal('ChildrenList');
    var ChildInfo = getValue('ChildrenInfo');
    ChildInfo = removeSpaceTrim(ChildInfo);
    var MacAddress = getValue('macAddr');
    var TemplateName = "template";
    var TemplateInst = "1";

    if (CheckForm()==false) {
        return;
    }

    var PCtrMacSpecCfgParaList = new Array();
    var url = '';
    if (VarFilterApplyRange=="ALLDEVICE") {
        PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress","FF:FF:FF:FF:FF:FF", 1));
        PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.Description",ChildInfo, 1));
        PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.TemplateInst",TemplateInst, 1));

        if (selectindex == -1) {
            url = 'add.cgi?' + 'x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.MAC' + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
        } else {
            url = 'set.cgi?x=' + ChildListArray[selectindex].domain + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
        }
    } else {
        if (SelectMac=="OtherMac") {
            PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress",MacAddress, 1));
        } else {
            PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress",SelectMac, 1));
        }

        PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.Description",ChildInfo, 1));
        if ("" != TemplateInst) {
            PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.TemplateInst",TemplateInst, 1));
        }

        if (selectindex == -1) {
            url = 'add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.MAC' + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
        } else {
            url = 'set.cgi?x=' + ChildListArray[selectindex].domain + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
        }
    }

    setDisable("ButtonApply", 1);
    setDisable("ButtonCancel", 1);

    var Parameter = {};
    Parameter.asynflag = null;
    Parameter.FormLiList = PCtrMacConfigFormList;
    Parameter.SpecParaPair = PCtrMacSpecCfgParaList;
    var tokenvalue = getValue('onttoken');
    HWSetAction(null, url, Parameter, tokenvalue);
    DisableRepeatSubmit();
}

function HourTimeEx(StrTime) {
    var valueEx = StrTime.split(':');
    var strH = valueEx[0];
    return strH;
}

function MinTimeEx(StrTime) {
    var valueEx = StrTime.split(':');
    var strM = valueEx[1];
    return strM;
}

function RepeatDayEx(strRepeatDay, nIndex) {
    var daySelArray = document.getElementsByName("AccessDay");
    for (var i = 0; i < daySelArray.length; i++) {
        setDisable(daySelArray[i].id, 0);
        daySelArray[i].checked = false;
    }
    if (nIndex == 0) {

    }
    if (nIndex == 1) {
        strRepeatDay = strRepeatDay.replace(/[,]/g,""); 
        for (var j = 0 ; j < strRepeatDay.length ; j++) {
            var ch = strRepeatDay.charAt(j);
            var index = getDayIndex(ch);
            var newid = index -1;
            daySelArray[newid].checked = true;
        }
    }
}

function getDayIndex(day) {
    var Index = "";
    switch(day) {
        case '0':
            Index = 0;
            break;
        case '7':
            Index = 1;
            break;
        case '1':
            Index = 2;
            break;
        case '2':
            Index = 3;
            break;
        case '3':
            Index = 4;
            break;
        case '4':
            Index = 5;
            break;
        case '5':
            Index = 6;
            break;
        case '6':
            Index = 7;
            break;
        default:
            break;
    }
    return Index;
}

function OnAllDayClick(AllDayControl) {
    var checked = AllDayControl.checked;
    if (checked == true) {
        document.getElementById("StartHour").value = "00"; 
        document.getElementById("StartMinute").value = "00"; 
        document.getElementById("EndHour").value = "23";
        document.getElementById("EndMinute").value = "59";
        setDisable('StartHour',1);
        setDisable('StartMinute',1);
        setDisable('EndHour',1);
        setDisable('EndMinute',1);
    } else {
        document.getElementById("StartHour").value = ""; 
        document.getElementById("StartMinute").value = ""; 
        document.getElementById("EndHour").value = "";
        document.getElementById("EndMinute").value = "";
        setDisable('StartHour',0);
        setDisable('StartMinute',0);
        setDisable('EndHour',0);
        setDisable('EndMinute',0);
    }
}

function OnDaySelectClick(EveryDayControl) {
    var checked = EveryDayControl.checked;
    var daySelArray = document.getElementsByName("AccessDay");
    if (checked) {
       for (var i = 0; i < daySelArray.length; i++) {
            daySelArray[i].checked = true;
            setDisable(daySelArray[i].id , 1);
       }
    } else {
        for (var i = 0; i < daySelArray.length; i++) {
            daySelArray[i].checked = false;
            setDisable(daySelArray[i].id , 0);
        }
    }
}
function PCtrUrlConfigListselectRemoveCnt() {

}
function OnApplyButtonClick() {
    if (!CheckParameter()) {
        return false;
    }

    var StartHour = getValue('StartHour');
    var StartMin = getValue('StartMinute');
    var EndHour = getValue('EndHour');
    var EndMin = getValue('EndMinute');
    var Onttoken = getValue('onttoken');
    var dayArray = document.getElementsByName("AccessDay");
    var StartTimeStr = "";
    var EndTimeStr = "";
    var RepeatDayStr = "";

    var OnLineFilter = getElById("EnableFilter");
    var OnLineFilterValue =(OnLineFilter.checked == true)?1:0;
    var SelectDurationPolicy = getElById("FilterList").selectedIndex;

    StartHour = parseTime(StartHour);
    StartMin = parseTime(StartMin);
    EndHour = parseTime(EndHour);
    EndMin = parseTime(EndMin);

    StartTimeStr = StartHour + ":" + StartMin;
    EndTimeStr = EndHour + ":" + EndMin;

    for (var i = 0; i < dayArray.length; i++) {
        if (dayArray[i].checked == true) {
            RepeatDayStr += dayArray[i].value + ",";
        }
    }
    RepeatDayStr = RepeatDayStr.substring(0,RepeatDayStr.lastIndexOf(','));

    var Id = GetSelectIdByIndex(selectindex);
    var action = '';
    if (selectindex == -1) {
        action = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId + ".Duration";
        action = action +'&y=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId;
    } else {
        action = 'set.cgi?x=' + DurationList[Id].domain;
        action = action + '&y=' + TemplatesListArray[0].domain;
    }

    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : 'x.StartTime=' + StartTimeStr + '&x.EndTime=' + EndTimeStr + '&x.RepeatDay=' + RepeatDayStr + '&y.DurationRight='+ OnLineFilterValue + '&y.DurationPolicy=' + SelectDurationPolicy + '&x.X_HW_Token=' + Onttoken,
        url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
        error:function(XMLHttpRequest, textStatus, errorThrown) 
        {
            if(XMLHttpRequest.status == 404)
            {
            }
        }
    }); 

    setDisable("ButtonApply", 1);
    setDisable("ButtonCancel", 1);
    window.location.href='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
}

function CheckParameter() {
    var strStartHour = getValue('StartHour');
    var strStartMin = getValue('StartMinute');
    var strEndHour = getValue('EndHour');
    var strEndMin = getValue('EndMinute');
    var daySelArray = document.getElementsByName("AccessDay");
    var strRepeatDay = "";

    if (isValidNumber(strStartHour)) {
        strStartHour = parseTime(strStartHour);
    }
    if (isValidNumber(strStartMin)) {
        strStartMin = parseTime(strStartMin);
    }
    if (isValidNumber(strEndHour)) {
        strEndHour = parseTime(strEndHour);
    }
    if (isValidNumber(strEndMin)) {
        strEndMin = parseTime(strEndMin);
    }

    var strStartTime = strStartHour +":" + strStartMin; 
    var strEndTime = strEndHour +":" + strEndMin;

    if (!isValidNumber(strStartHour) || !isValidNumber(strStartMin)) {
        AlertEx(parentalctrl_language['bbsp_stimeformatinvaild']);
        return false;
    }

    if (!isValidNumber(strEndHour) || !isValidNumber(strEndMin)) {
        AlertEx(parentalctrl_language['bbsp_etimeformatinvaild']);
        return false;
    }

    if (!isValidHour(strStartHour) || !isValidHour(strEndHour)) {
        AlertEx(parentalctrl_language['bbsp_htimerangeinvaild']);
        return false;
    }

    if (!isValidMinute(strStartMin) || !isValidMinute(strEndMin)) {
        AlertEx(parentalctrl_language['bbsp_mtimerangeinvalid']);
        return false;
    }

    if (!isValidTimeDuration(strStartHour, strStartMin, strEndHour, strEndMin)) {
        AlertEx(parentalctrl_language['bbsp_timedurationinvalid']);
        return false;
    }

    if (!CheckDaySelect(daySelArray)) {
        AlertEx(parentalctrl_language['bbsp_selectrepeatday']);
        return false;
    }

    for(var i = 0; i < daySelArray.length; i++) {
        if (daySelArray[i].checked == true) {
            strRepeatDay += daySelArray[i].value + ",";
        }
    }
    strRepeatDay = strRepeatDay.substring(0,strRepeatDay.lastIndexOf(','));

    for (var j = 0; j < DurationList.length-1; j++) {
        if (selectindex != j) {
            if (DurationList[j].TemplateId == CurTemplateId) {
                if ((strStartTime == DurationList[j].StartTime) && (strEndTime == DurationList[j].EndTime) && (strRepeatDay == DurationList[j].RepeatDay) ) {
                    AlertEx(parentalctrl_language['bbsp_timedurationrepeat']);
                    return false;
                }
            }
        } else {
            continue;
        }
    }
    return true;
}

function isValidNumber(number) {
    var numberLen = number.length;
    if (numberLen != 2 && numberLen != 1) {
        return false;
    }
    for (var i = 0 ; i < numberLen ; i++) {
        if (!isDecDigit(number.charAt(i))) {
            return false;
        }
    }
    return true;
}

function isDecDigit(digit) {
   var decVals = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
   var len = decVals.length;
   var i = 0;
   var ret = false;

    for ( i = 0; i < len; i++ ) {
        if ( digit == decVals[i] ) break;
    }
    if ( i < len ) {
        ret = true;
    }
   return ret;
}

function parseTime(str) {
    if (str.length == 1) {
        str = '0' + str;
    }
    return str;
}

function isValidHour(val) {
    if ((isValidNumber(val) == true) && (parseInt(val,10) < 24)) {
        return true;
    }
    return false;
}

function isValidMinute(val) {
    if ((isValidNumber(val) == true) && (parseInt(val,10) < 60)) {
        return true;
    }
    return false;
}

function isValidTimeDuration(startHour, startMin, endHour, endMin) {
    if(parseInt(startHour,10) < parseInt(endHour,10)) {
        return true;
    } else if((parseInt(startHour,10) == parseInt(endHour,10)) && (parseInt(startMin,10) < parseInt(endMin,10))) {
        return true;
    } else {
        return false;
    }
}

function CheckDaySelect(dayArray) {
    var index = 0;
    for (var i = 0; i < dayArray.length; i++) {
        if (!dayArray[i].checked)  {
            index++;
            continue;
        }
    }
    if (index == (dayArray.length)) {
        return false;
    }
    return true;
}

function OnBtAddUrlClick(BtAddUrlControl) {
    var UrlValueControl = document.getElementById("UrlValue");
    var UrlString = UrlValueControl.value;
    var ArrayOfUrl = Page.GetData().GetUrlList();
    var Ipv6Addr = "";
    var strNewUrl = "";
    var Onttoken = getValue('onttoken');

    if (ProductType == '2') {
        if (isValidAscii(UrlString) != '') {
            AlertEx(parentalctrl_language['bbsp_urladdr'] + parentalctrl_language['bbsp_hasvalidch'] + isValidAscii(UrlString) + parentalctrl_language['bbsp_end']);  
            return false;       
        }
        
        if (urlfilterByDns == 1 && UrlString.indexOf('https://') == 0) {
            UrlString = UrlString.substring(8);
        }
    
        if (IsUrlIncludeIpv6Addr(UrlString) == true) {
            Ipv6Addr = GetIPv6Addr(UrlString);
            if (IsIPv6AddressValid(Ipv6Addr) == false || IsIPv6ZeroAddress(Ipv6Addr) == true || IsIPv6LoopBackAddress(Ipv6Addr) == true || IsIPv6MulticastAddress(Ipv6Addr) == true) {
                AlertEx(parentalctrl_language['bbsp_urlipv6invalid']);
                return false;   
            } 
            strNewUrl = ChangeUrl(UrlString);
            if((CheckUrlParameter(strNewUrl) == false) || (IsUrlValid(strNewUrl) == false)) {
                AlertEx(parentalctrl_language['bbsp_urlinvalid']);
                return false;
            }
        } else {
            if ((CheckUrlParameter(UrlString) == false) || (IsUrlValid(UrlString) == false)) {
                AlertEx(parentalctrl_language['bbsp_urlinvalid']);
                return false;
            }
        }
    }
    if (IsUrlRepeat(ArrayOfUrl, UrlString) == true) {
        AlertEx(parentalctrl_language['bbsp_urlrepeat']);
        return false;
    }

    Page.GetData().AddUrl(new UrlValueClass("domain",UrlString));

    UrlString = encodeURIComponent(UrlString);

    var action = '';
    action = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.1.UrlFilter';

    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : 'x.UrlAddress=' + UrlString +'&x.X_HW_Token='+ Onttoken,
        url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
        error:function(XMLHttpRequest, textStatus, errorThrown) 
        {
        }
    });

    window.location='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';  
}

function UrlFilterPage() {
    this.UrlFileInfoObj = null;
    this.UIObserver = null;

    this.SetUIObserver = function(_UIObserver) {
        this.UIObserver = _UIObserver;
        this.UrlFileInfoObj.AddObserver(this.UIObserver);
    }
    this.GetUIObserver = function() {
        return this.UIObserver;
    }

    this.SetData = function(_UrlFilterInfo) {
        this.UrlFileInfoObj = _UrlFilterInfo;
        this.UrlFileInfoObj.NotifyObserver();
    }
    this.GetData = function() {
        return this.UrlFileInfoObj;
    }

    this.LoadData = function() {
        var DataObj = new DataPersistentClass();
        var UIObserver = new DataUIObserverClass();
        var UrlFilterInfo = DataObj.GetData();
        UrlFilterInfo.AddObserver(UIObserver);
        this.SetData(UrlFilterInfo);
    }

    this.SaveData = function() {
        this.UrlFileInfoObj.SaveData(new DataPersistentClass());
    } 
}

function GetUrlFilterPolicy(TemplateId) {
    var UrlFilterPolicy = "";
    for (var i = 0; i < TemplatesListArray.length-1; i++) {
        if (TemplatesListArray[i].TemplateId == TemplateId) {
            UrlFilterPolicy = TemplatesListArray[i].UrlFilterPolicy;
        }
    }
    return UrlFilterPolicy;
}

function DataPersistentClass() {
    this.GetData = function() {
        var UrlFilterInfo = new UrlFilterInfoClass();
        var UrlEnable = GetUrlFilterRight("1");
        var NameListMode = GetUrlFilterPolicy("1");
        var SmartEnable = BaseIpConcernValue.IpConcern;
        var ArrayOfUrl = UrlValueArray;
        var i = 0;

        var UrlFilterInfo = new UrlFilterInfoClass(UrlEnable, NameListMode, SmartEnable, ArrayOfUrl);
        UrlFilterInfo.SetEnable(UrlEnable);

        return UrlFilterInfo;
    }

    this.SaveData = function(UrlFilterInfo) {
        document.getElementById("UrlEnableData").value = UrlFilterInfo.GetEnable();
        document.getElementById("NameListModeData").value = UrlFilterInfo.GetNameListMode();
        document.getElementById("SmartEnableData").value = UrlFilterInfo.GetSmartEnable();
        document.getElementById("UrlData").value = UrlFilterInfo.GetUrlString(); 
    }
}

function DataUIObserverClass() {
    this.UpdateUI = function(UrlFilterInfo) {

    }
}
function submitprv() {
    if (false == IsValidPage(currentpage)) {
        return;
    }
    currentpage--;
    window.location = currentFile + "?" + parseInt(currentpage,10);
}
function submitfirst() {
    currentpage = firstpage;

    if (false == IsValidPage(currentpage)) {
        return;
    }
    window.location= currentFile + "?" + parseInt(currentpage,10);
}
function submitlast() {
    currentpage = lastpage;
    if (false == IsValidPage(currentpage)) {
        return;
    }

    window.location= currentFile + "?" + parseInt(currentpage,10);
}

function OnDeleteButtonClick(TableID) {
    if (TableID == "PCtrMacConfigList_head") {
        var CheckBoxList = document.getElementsByName("PCtrMacConfigListrml");
        var Count = 0;
        var i;

        if (ChildListArrayNr==0) {
            AlertEx(parentalctrl_language['bbsp_nomac']);
            return false;
        }
        for (i = 0; i < CheckBoxList.length; i++) {
            if (CheckBoxList[i].checked == true) {
                Count++;
            }
        }

        if (Count === 0) {
            AlertEx(parentalctrl_language['bbsp_selectmac']);
            return false;
        }

        setDisable("ButtonApply", 1);
        setDisable("ButtonCancel", 1);

        var Form = new webSubmitForm();
        for (i = 0; i < CheckBoxList.length; i++) {
            if (CheckBoxList[i].checked != true)
            {
                continue;
            }
            Form.addParameter(CheckBoxList[i].value,'');
        }
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));

        Form.setAction('del.cgi?RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp');
        Form.submit();
    } else if (TableID == "PCCInfo_head") {
        var SelectCount = 0;

        if(0 == GetOneDurationNum(CurTemplateId)) {
            AlertEx(parentalctrl_language['bbsp_notimerule']);
            return false;
        }
        
        var Form = new webSubmitForm();
        var str = "";
        var Onttoken = getValue('onttoken');
        for (var i = 0; i < DurationList.length-1; i++) {
            if (getCheckVal("PCCInfo_rml"+i) == "1") {
                SelectCount++;
                var Id = GetSelectIdByIndex(i);
                if (SelectCount > 1) {
                    str +='&';
                }
                str += getValue("PCCInfo_rml"+i) + '=' + '';
            }
        }
        str += '&x.X_HW_Token=' + Onttoken;
        if (SelectCount == 0) {
            AlertEx(parentalctrl_language['bbsp_selecttimeduration']);
            return false;
        }

        setDisable("ButtonApply", 1);
        setDisable("ButtonCancel", 1);

        var action = '';
        action = 'del.cgi?';

        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            data : str,
            url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
            error:function(XMLHttpRequest, textStatus, errorThrown)  {
                if(XMLHttpRequest.status == 404)
                {
                }
            }
        });
        window.location='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
    } else if (TableID == "PCtrUrlConfigList_head") {
        var i = 0;
        var count = Page.GetData().GetUrlList().length;
        var control = null;
        var DeleteInstanceArray = new Array();

        if (0 == (count)) {
            AlertEx(parentalctrl_language['bbsp_nourl']);
            return;
        }

        for (i = 0; i < count; i++) {
            control = document.getElementById("PCtrUrlConfigList_rml"+i);
            if (null == control) {
                continue;
            }
            if (control.checked == false) {
                continue;
            }
            DeleteInstanceArray.push(control.value);
        }

        if (DeleteInstanceArray.length == 0) {
            AlertEx(parentalctrl_language['bbsp_selecturl']);
            return;
        }

        var Form = new webSubmitForm();
        var str = "";
        var Onttoken = getValue('onttoken');
        var SelectCount = 0;
        for (i = 0; i < count; i++) {
            control = document.getElementById("PCtrUrlConfigList_rml"+i);
            SelectCount++;
            if (null == control) {
                continue;
            }
            if (control.checked == false) {
                continue;
            }
            if (SelectCount > 1) {
                str +='&';
            }
            str += control.value + '=' + '';
        }

        str += '&x.X_HW_Token=' + Onttoken;
        var action = '';
        action = 'del.cgi?';

        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            data : str,
            url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
            error:function(XMLHttpRequest, textStatus, errorThrown) 
            {
            }
        }); 
        window.location='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';
    }
}

function OnUrlEnableClick(UrlEnableControl) {
    var Checked = UrlEnableControl.checked;
    var Right = Checked == true?"1":"0";
    var Onttoken = getValue('onttoken');
    Page.GetData().SetEnable(Right);

    var action = '';
    action = 'set.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.1';

    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : 'x.UrlFilterRight=' + Right +'&x.X_HW_Token='+ Onttoken,
        url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
        error:function(XMLHttpRequest, textStatus, errorThrown) 
        {
        }
    }); 

    window.location='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp';  
}
function OnNameListModeChange() {
    var UrlFilterPolicy = "";
    var control = getElById("FilterMode");
    var Onttoken = getValue('onttoken');
    if (control[0].selected == true) {
        if (ConfirmEx(parentalctrl_language['bbsp_ischange'])) {
            UrlFilterPolicy = 0;
        } else {
            control[0].selected = false;
            control[1].selected = true;
            return;
        }
    } else if (control[1].selected == true) {
        if (ConfirmEx(parentalctrl_language['bbsp_ischange'])) {
            UrlFilterPolicy = 1;
        } else {
             control[0].selected = true;
             control[1].selected = false;
             return;
        }
    }

    var action = '';
    action = 'set.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId;

    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : 'x.UrlFilterPolicy=' + UrlFilterPolicy +'&x.X_HW_Token='+ Onttoken,
        url :  action + '&RequestFile=html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp',
        error:function(XMLHttpRequest, textStatus, errorThrown) 
        {
        }
    });

    window.location='/html/bbsp/parentalctrl/parentalctrlstatus_egypt.asp'; 
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">

    <div id="DivContent" style="display:block">
        <table width="100%" height="0" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr>
            <script language="JavaScript" type="text/javascript">
                HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title"), false);
            </script>
        </table>
    <div class="title_spread"></div>

    <div id="parentCtrlMAC">
        <div id="DivTableInfo">
            <td >
                <input name="idRadioDevice" id="RadioAllDevice" type="radio" value="AllDevice"  onclick="ChooseDeviceOption();"/>
                <span class="RadioDevice"><script>document.write(parentalctrl_language["bbsp_setalldevice"]);</script></span>
                <input name="idRadioDevice" id="RadioSpecifiedDevice" type="radio" value="SpecifiedDevice" class="RadioDevice" onclick="ChooseDeviceOption();"/>
                <span class="RadioDevice"><script>document.write(parentalctrl_language["bbsp_setspecifieddevice"]);</script></span>
            </td>
            <div class="button_spread"></div>
            <script language="JavaScript" type="text/javascript">
                var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
                var PCtrMacConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per10","DomainBox"),
                                                      new stTableTileInfo("bbsp_device","align_center width_per20","MACAddress"),
                                                      new stTableTileInfo("bbsp_scription","align_center width_per20","Description",false,15),null);
                var ColumnNumMac = 3;
                var ShowButtonFlagMac = true;
                var PctrMacConfigFormList = new Array();
                var TableDataInfoMac = HWcloneObject(ChildListArray, 1);
                InitTableDataMac();
                HWShowTableListByType(1, "PCtrMacConfigList", ShowButtonFlagMac, ColumnNumMac, TableDataInfoMac, PCtrMacConfiglistInfo, parentalctrl_language, null);
            </script>
        </div>
        <form id="TableConfigInfoMac" style="display:none">
            <div class="list_table_spread"></div>
            <table border="0" cellpadding="0" cellspacing="1"  width="100%">
                <li id="DeviceInfoBar" RealType="HorizonBar" DescRef="bbsp_device" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
                <li id="DisplayAllDevice" RealType="HtmlText" DescRef="bbsp_selectdevice" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
                <li id="DisplaySpecifiedDevice" RealType="HtmlText" DescRef="bbsp_selectdevice" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
                <li id="ChildrenList" RealType="DropDownList" DescRef="bbsp_selectdevice" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" Elementclass="SelectChildList" InitValue="Empty" ClickFuncApp="onchange=OnChildListChange"/>
                <li id="macAddr" RealType="TextBox" DescRef="bbsp_childmacmh" RemarkRef="bbsp_childmacremark1" ErrorMsgRef="Empty" Require="FALSE" BindField="x.MACAddress" Elementclass="Inputclass" InitValue="Empty" MaxLength="32"/>
                <li id="ScriptionInfoBar" RealType="HorizonBar" DescRef="bbsp_scription" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
                <li id="ChildrenInfo" RealType="TextBox" DescRef="bbsp_devicescription" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Description" Elementclass="Inputclass" InitValue="Empty" MaxLength="64"/>
            </table>
            <script>
                PCtrMacConfigFormList = HWGetLiIdListByForm("TableConfigInfoMac", null);
                var formid_hide_id = null;
                HWParsePageControlByID("TableConfigInfoMac", TableClass, parentalctrl_language, formid_hide_id);
                document.getElementById("DisplayAllDevice").innerHTML = parentalctrl_language["bbsp_allDevice"];
                GetLanUserDevInfoNoDelay(function(para) {
                    WriteDeviceOption(para);
                    UserDevinfo = para;
                });
            </script>
            <table cellpadding="0" cellspacing="0"  width="100%" class="table_button">
                <tr>
                <td class="table_submit" style="text-align:center">
                
                        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                        <button type="button" id='ButtonApply' onclick = "OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(parentalctrl_language['bbsp_app']);</script> </button>
                        &nbsp;
                        <button type="button" id='ButtonCancel' onclick="OnCancelMac();" class="CancleButtonCss buttonwidth_100px"><script>document.write(parentalctrl_language['bbsp_cancel']);</script> </button>
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div class="list_table_spread"></div>

    <div id="parentCtrlTIME">
        <table>
            <table width="100%" class="func_title"  cellpadding="0" cellspacing="0" id="PCCTimeTitle"> 
                <tr>
                    <td class="align_left">
                        <div id="DivTimedurationTitle"></div>
                    </td>
                </tr>
            </table>
            <form id="TimeFilterCfg" style="display:none;">
                <table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
                    <li id="EnableFilter" RealType="CheckBox" DescRef="bbsp_EnableFilter" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.DurationRight" InitValue="Empty"  ClickFuncApp="onclick=OnTimeEnableClick"/>
                    <li id="FilterList" RealType="DropDownList" DescRef="bbsp_FilterList" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.DurationPolicy" InitValue="[{TextRef:'bbsp_blacklist',Value:'0'},{TextRef:'bbsp_whitelist',Value:'1'}]" ClickFuncApp="onchange=OnTimeListModeChange"/>
                </table>
                <script>
                    var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
                    UrlfilterInfoConfigFormList = HWGetLiIdListByForm("TimeFilterCfg", null);
                    HWParsePageControlByID("TimeFilterCfg", TableClass, parentalctrl_language, null);
                    getElById("FilterList").title = parentalctrl_language['bbsp_timefilter'];
                    getElById("FilterList")[TemplatesListArray[0].DurationPolicy].selected = true;
                </script>
                <div class="func_spread"></div>
            </form>
            <script language="JavaScript" type="text/javascript">
                var TableClass = new stTableClass("width_per20", "width_per80", "ltr"); 
                
                var AccessTimeTitle = "";
                var AccessTimePeriod = "";
                if (1 == ParentCtrlTimeFeature) {
                    if (WHITELIST == TemplatesListArray[0 ].DurationPolicy ) {
                        AccessTimeTitle = "bbsp_enaccesstimeduration";
                    } else {
                        AccessTimeTitle = "bbsp_disaccesstimeduration";
                    }
                    AccessTimePeriod = "Empty";
                } else {
                    AccessTimePeriod = "bbsp_duration";
                    AccessTimeTitle = "bbsp_repeat";
                }

                var PCtrTimeConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per10","DomainBox"),
                                                       new stTableTileInfo(AccessTimePeriod,"align_center ","Duration"),
                                                       new stTableTileInfo(AccessTimeTitle,"align_center width_per70","RepeatDay"),
                                                       null);
                var ColumnNumTime = 3;
                var ShowButtonFlagTime = true;
                var PtrTimeConfigFormList = new Array();
                var TableDataInfoTime = new Array();
                InitTableDataTime();
                TableDataInfoTime.push(null);
                HWShowTableListByType(1, "PCCInfo", ShowButtonFlagTime, ColumnNumTime, TableDataInfoTime, PCtrTimeConfiglistInfo, parentalctrl_language, null);
            </script>
            <div id="ConfigPanel" style="display:none"> 
                <div class="list_table_spread"></div>
                <form id="TableConfigInfoTime" style="display:block"> 
                    <table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
                        <li id="AccessTimeInfoBar" RealType="HorizonBar" DescRef="" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
                        <li id="AllDay" RealType="CheckBox" DescRef="bbsp_allday" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" ClickFuncApp="onclick=OnAllDayClick"/>
                        <li id="StartHour" RealType="TextOtherBox" DescRef="bbsp_starttime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.StartTime" Elementclass="InputTime" MaxLength="2" InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'startColon'}]},{Type:'input',Item:[{AttrName:'id',AttrValue:'StartMinute'},{AttrName:'BindFileld', AttrValue:'Empty'},{AttrName:'MaxLength', AttrValue:'2'},{AttrName:'class', AttrValue:'InputTime'}]},{Type:'span',Item:[{AttrName:'innerhtml', AttrValue:'bbsp_starttimeremark'},{AttrName:'class', AttrValue:'gray'}]}]"/>
                        <li id="EndHour" RealType="TextOtherBox" DescRef="bbsp_endtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.EndTime" Elementclass="InputTime" MaxLength="2" InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'endColon'}]},{Type:'input',Item:[{AttrName:'id',AttrValue:'EndMinute'},{AttrName:'BindFileld', AttrValue:'Empty'},{AttrName:'MaxLength', AttrValue:'2'},{AttrName:'class', AttrValue:'InputTime'}]},{Type:'span',Item:[{AttrName:'innerhtml', AttrValue:'bbsp_endtimeremark'},{AttrName:'class', AttrValue:'gray'}]}]"/>
                        <li id="RepeatInfoBar" RealType="HorizonBar" DescRef="bbsp_repeatday1" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
                        <li id="EveryDay" RealType="CheckBox" DescRef="bbsp_everyday" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="0" ClickFuncApp="onclick=OnDaySelectClick"/>
                        <li id="AccessDay" RealType="CheckBoxList" DescRef="bbsp_repeatday1" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{TextRef:'bbsp_Sunday',Value:'7'},{TextRef:'bbsp_Monday',Value:'1'},{TextRef:'bbsp_Tuesday',Value:'2'},{TextRef:'bbsp_Wednesday',Value:'3'},{TextRef:'bbsp_Thursday',Value:'4'},{TextRef:'bbsp_Friday',Value:'5'},{TextRef:'bbsp_Saturday',Value:'6'}]" />
                    </table>
                    <script language="JavaScript" type="text/javascript">
                        PCtrTimeConfigFormList = HWGetLiIdListByForm("TableConfigInfoTime", null);
                        var formid_hide_id = null;
                        HWParsePageControlByID("TableConfigInfoTime", TableClass, parentalctrl_language, formid_hide_id);
                        document.getElementById("startColon").innerHTML = '&nbsp;&nbsp;'+ parentalctrl_language['bbsp_colon'] + '&nbsp;&nbsp;';
                        document.getElementById("endColon").innerHTML = '&nbsp;&nbsp;'+ parentalctrl_language['bbsp_colon'] + '&nbsp;&nbsp;';
                        if ('1' == ParentCtrlTimeFeature) {
                            if (WHITELIST == TemplatesListArray[0].DurationPolicy ) {
                                document.getElementById("AccessTimeInfoBar").innerHTML = parentalctrl_language['bbsp_accesstimedurationmh1'];
                            } else {
                                document.getElementById("AccessTimeInfoBar").innerHTML = parentalctrl_language['bbsp_disaccesstimedurationmh1'];
                            }
                        } else {
                            document.getElementById("AccessTimeInfoBar").innerHTML = parentalctrl_language['bbsp_accesstimedurationmh1'];
                        }
                    </script>
                    <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button"> 
                        <tr>
                            <td class="table_submit" style = "text-align:center;">
                                <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_app']);</script></button>
                                <button id="ButtonCancel" type="button" onclick="javascript:OnCancelTime();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_cancel']);</script></button>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </table>
    </div>

<div class="list_table_spread"></div>
<div id="parentCtrlURL">
        <div id="DivContent" style="display:block"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="func_title" >
            <tr>
                <td class="align_left" >
                    <div id="DivUrlTitle"></div>
                </td>
            </tr>
        </table>
        <form id="UrlFilterCfg" style="display:block;">
            <table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
                <li id="UrlEnable" RealType="CheckBox" DescRef="bbsp_enableurlfilter" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.UrlFilterRight" InitValue="Empty" ClickFuncApp="onclick=OnUrlEnableClick"/>
                <li id="FilterMode" RealType="DropDownList" DescRef="bbsp_urlfiltermodemh1" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.UrlFilterPolicy" InitValue="[{TextRef:'bbsp_blacklist',Value:'0'},{TextRef:'bbsp_whitelist',Value:'1'}]" ClickFuncApp="onchange=OnNameListModeChange"/>
            </table>
            <script>
                var TableClass_blacklist = new stTableClass("width_per30", "width_per70", "ltr");
                UrlfilterInfoConfigFormList = HWGetLiIdListByForm("UrlFilterCfg", null);
                HWParsePageControlByID("UrlFilterCfg", TableClass_blacklist, parentalctrl_language, null);
                getElById("FilterMode").title = parentalctrl_language['bbsp_urlfilternote3'];
            </script>
            <div class="func_spread"></div>
      </form>
    <div id="divConfigUrlForm">
        <script language="JavaScript" type="text/javascript">
            var PCtrUrlConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),
                                                  new stTableTileInfo("bbsp_urladdr","","UrlAddress",false, 64),null);    
            var ColumnNumUrl = 2;
            var ShowButtonFlagUrl = true;
            var PCtrUrlTableConfigInfoList = new Array();
            showlistcontrol();
        </script>
        <div id="ConfigUrlPanel" style="display:none;"> 
        <div class="list_table_spread"></div>
            <form id="TableConfigInfoUrl" style="display:block;"> 
                <table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
                    <li id="UrlValue" RealType="TextBox" DescRef="bbsp_urladdrmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="x.UrlAddress" InitValue="Empty" MaxLength='64'/>
                </table>
                <script language="JavaScript" type="text/javascript">
                    MPCtrUrlConfigFormList = HWGetLiIdListByForm("TableConfigInfoUrl", null);
                    HWParsePageControlByID("TableConfigInfoUrl", TableClass, parentalctrl_language, null);
                    if (IPV6Flag == 1) {
                        document.getElementById("UrlValueRemark").innerHTML = parentalctrl_language['bbsp_urlnote1'];
                    }
                </script>           
                <table width="100%" class="table_button"> 
                  <tr>
                    <td class="table_submit" style="text-align:center"> 
                        <button id='btnApply_ex' name="btnApply_ex" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="OnBtAddUrlClick(this)"><script>document.write(parentalctrl_language['bbsp_app']);</script></button> 
                        <button id='Cancel' name="cancel" class="CancleButtonCss buttonwidth_100px" type="button" onclick="OnCancelUrl();"><script>document.write(parentalctrl_language['bbsp_cancel']);</script></button> </td> 
                  </tr>
                </table>
            </form>
        </div>

      <table class='width_per100' border="0" cellspacing="0" cellpadding="0" > 
        <tr >
            <td >
                <input name="first" id="first" class="PageNext jumppagejumplastbutton_wh_px" type="button" value="<<" onClick="submitfirst();"/> 
                <input name="prv" id="prv"  class="PageNext jumppagejumpbutton_wh_px" type="button" value="<" onClick="submitprv();"/> 
                <script>
                        if (false == IsValidPage(currentpage)) {
                            currentpage = (0 == UrlValueArrayNr) ? 0:1;
                        }
                        document.write(parseInt(currentpage,10) + "/" + lastpage);
                </script>
                <input name="next"  id="next" class="PageNext jumppagejumpbutton_wh_px" type="button" value=">" onClick="submitnext();"/> 
                <input name="last"  id="last" class="PageNext jumppagejumplastbutton_wh_px" type="button" value=">>" onClick="submitlast();"/> 
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <script> document.write(parentalctrl_language['bbsp_goto']); </script> 
                    <input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
                <script> document.write(parentalctrl_language['bbsp_page']); </script>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input name="jump"  id="jump" class="PageNext jumpbutton_wh_px" type="button" onClick="submitjump();"></td>
                <script>setText("jump",parentalctrl_language["bbsp_jump"]); </script>
            </td>
        </tr>
    </table>
 </div>
<script>
if (currentpage == firstpage) {
    setDisable('first',1);
    setDisable('prv',1);
}
if (currentpage == lastpage) {
    setDisable('next',1);
    setDisable('last',1);
}
</script>
</div>
</div>
</body>
</html>

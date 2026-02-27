<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" type="text/javascript">
var aisApFlag= "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MESH);%>";
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var UnicomFlag = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_UNICOM);%>";
var NormalUpdownCfg = "<%HW_WEB_GetFeatureSupport(FT_NORMAL_UPDOWNLOADCFG);%>";
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var DBAA1 = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATRUE_DBAA1);%>";
var curUserType = '<%HW_WEB_GetUserType();%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var sysUserType = '0';
var dbaa1SuperSysUserType = '2';
var languageList = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE_SET.STRING);%>';
var initLanguage = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE.STRING);%>';
var languageSet = new Array();
var TableName = "ApInfpInst";
var selctIndex = -1;
var reqFile = "html/ssmp/cfgfile/cfgfile.asp";
var ProductType = '<%HW_WEB_GetProductType();%>';
var IsWebLoadConfigfile = "<%HW_WEB_GetFeatureSupport(FT_WEB_LOAD_CONFIGFILE);%>";

if (CfgMode.toUpperCase() == "TURKCELL2") {
    reqFile = "remote/conf.html";
}

if ((typeof languageList == 'string') && (languageList != '')) {
    languageSet = languageList.split("|");
}

function IsSupportPrompt()
{
    if (languageSet.length > 1) {
        for (var lang in languageSet) {
            if ((languageSet[lang] != 'english') && (languageSet[lang] != 'chinese')) {
                return false;
            }
        }
    }

    if ((initLanguage != 'english') && (initLanguage != 'chinese')) {
        return false;
    }

    if ((curLanguage != 'english') && (curLanguage != 'chinese')) {
        return false;
    }

    return true;
}

function stApDeviceList(domain,DeviceType,ApOnlineFlag,APMacAddr,SerialNumber)
{
    this.domain = domain;
    this.DeviceType = DeviceType;
    this.ApOnlineFlag = ApOnlineFlag;
    this.APMacAddr = APMacAddr;
    this.SerialNumber = SerialNumber;
}
var apDeviceList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i},DeviceType|ApOnlineFlag|APMacAddr|SerialNumber,stApDeviceList);%>;
var apEnableDeviceList = new Array();
var ApCfgStatus = new Array();
var apActionEnable = 0;
var idx = 0;
for (var i = 0; i < apDeviceList.length - 1; i++) {
    if (apDeviceList[i].ApOnlineFlag == '1') {
        GetApEnable(apDeviceList[i].APMacAddr);
        if (apActionEnable == 1) {
            apEnableDeviceList[idx] = apDeviceList[i];
            ApCfgStatus[idx] = 0;
            idx++;
        }
    }
}

function GetApEnable(mac)
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/GetApActionEnable.asp?&1=1",
        data :'APMacAddr=' + mac,
        success : function(data) {
            apActionEnable = data;
        }
    });
}

function GetApDownloadCfgStatusByIndex(index)
{
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : "../common/getApDownloadCfgStatus.asp?&1=1",
        data :'APMacAddr=' + apEnableDeviceList[index].APMacAddr,
        success : function(data) {
            if (data != '') {
                ApCfgStatus[index]  = data;
            }
        }
    });
}

function GetApDownloadCfgStatus()
{
    if (selctIndex == -1) {
        return;
    }
    GetApDownloadCfgStatusByIndex(selctIndex);
    SetDisplayStatus(ApCfgStatus[selctIndex]);
}

function SetDisplayStatus(stauts)
{
    if (stauts == "0") {
        setDisable('collectApCfgButton',0);
        setDisable('downloadApCfgButton', 1);
        getElement('CollectInfo').innerHTML = '';
    } else if (stauts == "1") {
        setDisable('collectApCfgButton',1);
        setDisable('downloadApCfgButton', 1);
        getElement('CollectInfo').innerHTML = '<B><FONT color=red>'+GetLanguageDesc("s0b09")+ '</FONT><B>';
    } else if (stauts == "2") {
        setDisable('collectApCfgButton',0);
        setDisable('downloadApCfgButton', 0);
        getElement('CollectInfo').innerHTML = '<B><FONT color=red>'+GetLanguageDesc("s0b10")+ '</FONT><B>';
    }
}

if (aisApFlag == "1") {
    curUserType='0';
}
function IsAdminUser()
{
    if (DBAA1 == '1') {
        return curUserType == dbaa1SuperSysUserType;
    }
    return curUserType == sysUserType;
}
function Check_SWM_Status()
{
	var xmlHttp = null;

	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", "/html/get_swm_status.asp", false);
	xmlHttp.send(null);

	var swm_status = xmlHttp.responseText;
	if (swm_status.substr(1,1) == "0") {
		return true;
	} else {
		return false;
	}
}

function setAllDisable()
{
	setDisable('f_file',1);
	setDisable('browse',1);
	setDisable('btnBrowse',1);
	setDisable('btnSubmit',1);
}
function GetLanguageDesc(Name)
{
	return CfgfileLgeDes[Name];
}

function isSGP210W()
{
    if ((CfgMode.toUpperCase() == 'SYNCSGP210W') || (CfgMode.toUpperCase() == 'SONETSGP210W')) {
        return true;
    }
    return false;
}

function LoadFrame() {
    if (IsAdminUser() || (CfgMode.toUpperCase() == 'OTE')) {
        setDisplay('downloadConfig', IsWebLoadConfigfile);
        setDisplay('uploadConfig', IsWebLoadConfigfile);
        if (UnicomFlag == 1) {
            setDisplay('saveConfig', 0);
        } else {
            setDisplay('saveConfig', 1);
        }
    } else {
        if ((['PCCW4MAC', 'PCCWSMART', 'PCCW2', 'DMASMOVIL2WIFI'].indexOf(CfgMode.toUpperCase()) >= 0) || (NormalUpdownCfg == 1)) {
            setDisplay('saveConfig', 1);
            setDisplay('downloadConfig', IsWebLoadConfigfile);
            setDisplay('uploadConfig', IsWebLoadConfigfile);
        } else {
            setDisplay('saveConfig', 1);
            setDisplay('downloadConfig', 0);
            setDisplay('uploadConfig', 0);
        }
    }

    if (isSGP210W()) {
        setDisplay('saveConfig', 0);
        setDisplay('downloadConfig', 1);
        setDisplay('uploadConfig', 1);
    }
    
    if ((CfgMode.toUpperCase() == 'TURKCELL2') && (curLanguage == 'turkish')) {
        $("#btnSubmit").css("width", "258px");
    }

    setTimeout('delayTime(top.SaveDataFlag)', 30);
    
    if (apEnableDeviceList.length > 0) {
        setDisplay('downloadApConfig', 1);
        GetApDownloadCfgStatus();
        setInterval(function() {
            try {
                 GetApDownloadCfgStatus();
            } catch (e) {
            }
        }, 1000 * 5);
    }
}
function delayTime(saveflag){
	if (saveflag == 1)
	{			
		saveflag = 0;
		top.SaveDataFlag = 0;
		AlertEx(GetLanguageDesc("s0701"));
	}
}

function CheckForm(type) {
	with(document.getElementById("ConfigForm")) {
	}
	return true;
}

function AddSubmitParam(SubmitForm, type) {
}

function VerifyFile(FileName)
{
	var filePath = document.getElementsByName(FileName)[0].value;

	if (filePath.length == 0) {
		AlertEx(GetLanguageDesc("s0702"));
		return false;
	}

	if (filePath.length > 128) {
		AlertEx(GetLanguageDesc("s0703"));
		return false;
	}

	return true;
}

function uploadSetting() {
    if (IsWebLoadConfigfile == "0") {
		return;
	}
	var uploadForm = document.getElementById("fr_uploadSetting");

	if (Check_SWM_Status() == false) {
		AlertEx(GetLanguageDesc("s0905"));
		return;
	}
	if (VerifyFile('browse') == false) {
		return;
	}

	if(!ConfirmEx(GetLanguageDesc("s0711")))
	{
		return;
	}
	top.previousPage = '/html/ssmp/reset/reset.asp';
	setDisable('btnSubmit', 1);
	uploadForm.submit();
	setDisable('browse',1);
	setDisable('btnBrowse',1);

}

function backupSetting() {
    if (IsWebLoadConfigfile == "0") {
		return;
	}
	if (IsSupportPrompt() == true) {
		if (ConfirmEx(GetLanguageDesc("ss0a0b")) == false) {
			return;
		}
	}

	XmlHttpSendAspFlieWithoutResponse("/html/ssmp/common/StartFileLoad.asp");
	var Form = new webSubmitForm();
	Form.setAction('cfgfiledown.cgi?&RequestFile=' + reqFile);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function SaveSetting() {
	var Form = new webSubmitForm();
	Form.setMethod('POST');
	top.SaveDataFlag = 1;
	Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave' + '&RequestFile=' + reqFile);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function SaveandReboot()
{
	if(ConfirmEx(GetLanguageDesc("s0706")))
	{
		setDisable('btnsaveandreboot', 1);
		var Form = new webSubmitForm();
		Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard' + '&RequestFile=' + reqFile);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
}

function fchange()
{
	var ffile = document.getElementById("f_file");
	var tfile = document.getElementById("t_file");
	ffile.value = tfile.value;

	var buttonstart = document.getElementById('btnSubmit');
	buttonstart.focus();
	return ;
}

function StartFileOpt()
{
    XmlHttpSendAspFlieWithoutResponse("/html/ssmp/common/StartFileLoad.asp");
}

function OnCollectApCfg()
{
    SetDisplayStatus("1");
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        data : "APMacAddr=" + apEnableDeviceList[selctIndex].APMacAddr + "&x.X_HW_Token=" + getValue('onttoken'),
        url : 'collectApConfig.cgi?&RequestFile=html/ssmp/cfgfile/cfgfile.asp',
        success : function(data) {
                var StrCode = "\"" + data + "\"";
                var ResultInfo = eval("("+ eval(StrCode) + ")");
                if (ResultInfo.Result == 0) {
                    return;
                }
                AlertEx(GetLanguageDesc("s0b11"));
                SetDisplayStatus("1");
            }
     });
}

function OnDownloadApCfg()
{
    if (IsSupportPrompt() == true) {
        if (ConfirmEx(GetLanguageDesc("ss0a0b")) == false) {
            return;
        }
    }

    XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
    var Form = new webSubmitForm();
    Form.addParameter('APMacAddr', apEnableDeviceList[selctIndex].APMacAddr);
    Form.setAction('apCfgFileDownload.cgi?&RequestFile=html/ssmp/cfgfile/cfgfile.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function setCtlDisplay(record)
{
    if (record != null) {
        if (record.DeviceType == '') {
            getElById("DeviceType").innerHTML = '--';
        } else {
            getElById("DeviceType").innerHTML = record.DeviceType;
        }
        if (record.APMacAddr == '') {
            getElById("MacAddress").innerHTML = '--';
        } else {
            getElById("MacAddress").innerHTML = record.APMacAddr;
        }
        if (record.SerialNumber == '') {
            getElById("SerialNumber").innerHTML = '--';
        } else {
            getElById("SerialNumber").innerHTML = record.SerialNumber;
        }
    } else {
        getElById("DeviceType").innerHTML = '--';
        getElById("MacAddress").innerHTML = '--';
        getElById("SerialNumber").innerHTML = '--';
    }
}

function setControl(index)
{
    var record;
    selctIndex = index;
    if (index == -2) {
        setDisplay('ApDeviceListInfo', 0);
        setDisplay('downloadApConfigTable', 0);
    } else if (index != -1) {
        setDisplay('ApDeviceListInfo', 1);
        setDisplay('downloadApConfigTable', 1);
        record = apEnableDeviceList[index];
        setCtlDisplay(record);
        GetApDownloadCfgStatusByIndex(index);
        SetDisplayStatus(ApCfgStatus[index]);
    }
}

function showlistcontrol()
{
    var TableDataInfo = new Array();
    var ColumnNum = 3;
    var ShowButtonFlag = false;
    var Listlen = 0;

    if (apEnableDeviceList.length == 0) {
        TableDataInfo[Listlen] = new stApDeviceList();
        TableDataInfo[Listlen].DeviceType = '--';
        TableDataInfo[Listlen].MacAddress = '--';
        TableDataInfo[Listlen].SerialNumber = '--';
        HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, apEnableDeviceListInfo, CfgfileLgeDes, null);
        return;
    } else {
        for (var i = 0; i < apEnableDeviceList.length; i++) {
            TableDataInfo[Listlen] = new stApDeviceList();
            if (apEnableDeviceList[i].DeviceType == '') {
                TableDataInfo[Listlen].DeviceType = '--';
            } else {
                TableDataInfo[Listlen].DeviceType = apEnableDeviceList[i].DeviceType;
            }
            if (apEnableDeviceList[i].APMacAddr == '') {
                TableDataInfo[Listlen].MacAddress = '--';
            } else {
                TableDataInfo[Listlen].MacAddress = apEnableDeviceList[i].APMacAddr;
            }
            if (apEnableDeviceList[i].SerialNumber == '') {
                TableDataInfo[Listlen].SerialNumber = '--';
            } else {
                TableDataInfo[Listlen].SerialNumber = apEnableDeviceList[i].SerialNumber;
            }
            Listlen++;
        }
        TableDataInfo.push(null);
        HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, apEnableDeviceListInfo, CfgfileLgeDes, null);
    }
}

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
    <script language="JavaScript" type="text/javascript">
        var desResId = "s0100";
        if (UnicomFlag == 1) {
            desResId = "s0103";
        } else if (IsWebLoadConfigfile == "0") {
            desResId = "s0707";
        }
        HWCreatePageHeadInfo("cfgfile", GetDescFormArrayById(CfgfileLgeDes, "s0102"), GetDescFormArrayById(CfgfileLgeDes, desResId), false);
    </script>
    <div class="title_spread"></div>
    <div id="saveConfig">
        <div class="func_title" BindText="s0101"></div>
        <table width="100%" cellpadding="0" cellspacing="0" class="table_button">
            <tr>
                <td><input  class="ApplyButtoncss buttonwidth_150px_250px" name="saveconfigbutton" id="saveconfigbutton" type='button' onClick='SaveSetting()' BindText="s0709" /></td>
                <td><input  class="ApplyButtoncss buttonwidth_150px_250px" name="btnsaveandreboot" id="btnsaveandreboot" type='button' onClick='SaveandReboot()' BindText="s070a" /></td>
            </tr>
        </table>
    </div>
    <div class="func_spread"></div>
    <div id="downloadConfig" style="display:none">
        <div class="func_title" BindText="s070c"></div>
        <table width="100%" cellpadding="0" cellspacing="0" class="table_button">
            <tr>
            <script language="JavaScript" type="text/javascript">
                var curClass = "ApplyButtoncss buttonwidth_150px_250px"
                if (curLanguage == 'russian') {
                    curClass = "ApplyButtoncss buttonwidth_36px_260px";
                }
                document.write('<td><input class="' + curClass + '" name="downloadconfigbutton" id="downloadconfigbutton" type="button" onClick="backupSetting()" BindText="s070c"></td>');
            </script>
            </tr>
        </table>
    </div>
    <div class="func_spread"></div>
    <div id="uploadConfig" style="display:none">
        <form action="cfgfileupload.cgi?RequestFile=html/ssmp/reset/reset.asp&FileType=config&RequestToken=<%HW_WEB_GetToken();%>" method="post" enctype="multipart/form-data" name="fr_uploadSetting" id="fr_uploadSetting">
            <div class="func_title" BindText="s0710"></div>
            <table width="100%" cellpadding="0" cellspacing="0" class="table_button">
                <tr>
                    <td class="filetitle" BindText="s070e"></td>
                    <td>
                        <div class="filewrap">
                            <div class="fileupload">
                                <input type="hidden" id="hwonttoken" name="onttoken" value="<%HW_WEB_GetToken();%>" />
                                <input type="text"   id="f_file"     autocomplete="off" readonly="readonly" />
                                <input type="file"   id="t_file"     name="browse" size="1"  onblur="StartFileOpt();" onchange="fchange();" />
                                <input type="button" id="btnBrowse"  class="CancleButtonCss filebuttonwidth_100px" BindText="s070f" />
                            </div>
                        </div>
                    </td>
                    <td>
                    <script language="JavaScript" type="text/javascript">
                        var curClass = "CancleButtonCss filebuttonwidth_150px_250px"
                        if (curLanguage == 'russian') {
                            curClass = "CancleButtonCss filebuttonwidth_150px_255px";
                        }
                        document.write('<input type="button" id="btnSubmit" name="btnSubmit" class="' + curClass + '" onclick="uploadSetting();" BindText="s0710" />');
                    </script>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div class="func_spread"></div>
    <form id="downloadApConfig" style="display:none">
    <div class="func_title" BindText="s0b00"></div> 
    <script language="JavaScript" type="text/javascript">
        var apEnableDeviceListInfo = new Array(new stTableTileInfo("s0b01","align_center","DeviceType"),
                                               new stTableTileInfo("s0b02","align_center","MacAddress"),
                                               new stTableTileInfo("s0b03","align_center","SerialNumber"),
                                               null);
        showlistcontrol();
    </script>
    </form> 
    <form id="ApDeviceListInfo" style="display:none">
        <table border="0" cellpadding="0" cellspacing="1" width="100%">
            <li id="DeviceType" RealType="HtmlText" DescRef="s0b04" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="FALSE" InitValue="Empty" ClickFuncApp="Empty"/>
            <li id="MacAddress" RealType="HtmlText" DescRef="s0b05" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="FALSE" InitValue="Empty" ClickFuncApp="Empty"/>
            <li id="SerialNumber" RealType="HtmlText" DescRef="s0b06" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="FALSE" InitValue="Empty" ClickFuncApp="Empty"/>
            <script>
                var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
                CollectFaultFormList = HWGetLiIdListByForm("ApDeviceListInfo",null);
                HWParsePageControlByID("ApDeviceListInfo", TableClass, CfgfileLgeDes, null);
            </script> 

        </table>
        <table width="100%" cellpadding="0" cellspacing="1" class="table_button">
        <tr>
            <td><input class="ApplyButtoncss buttonwidth_150px_250px" name="collectApCfgButton" id="collectApCfgButton" type='button' onClick='OnCollectApCfg()' BindText="s0b07"></td>
            <td><input class="ApplyButtoncss buttonwidth_150px_250px" name="downloadApCfgButton" id="downloadApCfgButton" type='button' onClick='OnDownloadApCfg()' BindText="s0b08"></td>
        </tr>
        <div id="CollectInfo"></div>
        </table> 
    </form>

    <script>
        ParseBindTextByTagName(CfgfileLgeDes, "div",    1);
        ParseBindTextByTagName(CfgfileLgeDes, "td",     1);
        ParseBindTextByTagName(CfgfileLgeDes, "input",  2);
    </script>

</body>
</html>

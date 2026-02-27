<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var isSupportV5 = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_V5_CMS_SUPPORT);%>';
var reqFile = "html/ssmp/fireware/firmware.asp";
var ProductType = '<%HW_WEB_GetProductType();%>';

if (CfgModeWord.toUpperCase() == "TURKCELL2") {
    reqFile = "remote/supgrade.html";
}

function setAllDisable()
{
	setDisable('f_file',    1);
	setDisable('browse',    1);
	setDisable('btnBrowse', 1);
	setDisable('btnSubmit', 1);
}

function GetLanguageDesc(Name)
{
	return FirmwareLgeDes[Name];
}

var AutoUpdateEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AutoUpdate.Enable);%>';
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
	if (swm_status.substr(1, 1) == "0") {
		return true;
	} else {
		return false;
	}
}

function LoadFrame()
{
	top.UpgradeFlag = 0;

	if((curWebFrame == 'frame_argentina') && (curUserType == sysUserType))
	{
		setAllDisable();
	}

	if("IPONLY" == CfgModeWord.toUpperCase() || "FORANET" == CfgModeWord.toUpperCase() || "TELIA" == CfgModeWord.toUpperCase())
	{
		setDisplay("tableautoupgrade", 1);
		setDisplay("localtext", 1);
		setCheck("autoupgrade", AutoUpdateEnable);
	}
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		$("#btnSubmit").css({"margin-left": "91px", "padding-left": "25px", "width": "125px", "height": "36px"});
	}
}

function VerifyFile(FileName)
{
	var File = document.getElementsByName(FileName)[0].value;
	if (File.length == 0)
	{
		AlertEx(GetLanguageDesc("s0901"));
		return false;
	}
	if (File.length > 128)
	{
		AlertEx(GetLanguageDesc("s0902"));
		return false;
	}

	return true;
}

function uploadImage()
{
	var uploadForm = document.getElementById("fr_uploadImage");

	if (Check_SWM_Status() == false)
	{
		AlertEx(GetLanguageDesc("s0905"));
		return;
	}

	if (VerifyFile('browse') == false)
	{
	   return;
	}
	
	setDisable('btnSubmit', 1);
	uploadForm.submit();
	top.UpgradeFlag = 1;
	setDisable('browse', 1);
	setDisable('btnBrowse',1);
}

</script>
<script language="JavaScript" type="text/javascript">
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

function ApplayAutoUpgrade()
{
	var Form = new webSubmitForm();
	Form.addParameter('x.Enable',getCheckVal('autoupgrade'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_AutoUpdate'
                         + '&RequestFile=' + reqFile);
	Form.submit();
}
    function isTEData() {
        if (isSupportV5 == 1) {
            return (CfgModeWord == 'TEDATA') || (CfgModeWord == 'TEDATA2');
        } else {
            return false;
        }
    }
    function ResetONT() {
        if (isTEData() == false) {
            return;
        }
        var Title = ResetLgeDes["s0601"];
        if (ConfirmEx(Title)) {
            setDisable('btnReboot', 1);
            var Form = new webSubmitForm();
            Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
                + '&RequestFile=html/ssmp/fireware/firmware.asp');
            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.submit();
        }
    }
    function RestoreONT() {
        if (isTEData() == false) {
            return;
        }
        var Title = RestoreLgeDes["s0a01"];

        if (ConfirmEx(Title)) {
            var Form = new webSubmitForm();
            setDisable('btnRestoreDftCfg', 1);
            Form.setAction('restoredefaultcfg.cgi?RequestFile=html/ssmp/fireware/firmware.asp');
            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.submit();
        }
    }
</script>
</head>

<body  class="mainbody pageBg" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
        if (isTEData()) {
            HWCreatePageHeadInfo("TEDataFirmwareTitle", GetDescFormArrayById(FirmwareLgeDes, "s0915"),
                GetDescFormArrayById(FirmwareLgeDes, "s0916"), false);
            document.write('<br/><br/>');
            HWCreatePageHeadInfo("RebootTitle", GetDescFormArrayById(FirmwareLgeDes, "s0917"), '', false);
        }
    </script>
    <div id="OntReset" style="display:none;">
        <div id="ResetIcon" class="OntResetIcon"></div>
        <div id="ResetButton" class="FloatLeftCss">
            <input type="button" class="bluebuttoncss buttonwidth_120px_140px" id="btnReboot" onClick="ResetONT(this);"
                value="" BindText="s1123" />
        </div>
        <div id="ResetDes">
            <table height="40px;">
                <tr>
                    <td class="ResetRestoreSpan" BindText="s1125"></td>
                </tr>
            </table>
        </div>
    </div>
    <script>
        if (isTEData()) {
            setDisplay("OntReset", 1);
            document.write('<br/><br/>');
            HWCreatePageHeadInfo("firmware", GetDescFormArrayById(FirmwareLgeDes, "s0918"), '', false);
        }
    </script>
    <div id="OntRestore" style="display:none;">
        <div id="RestoreIcon" class="OntRestoreIcon">
        </div>
        <div id="RestoreButton" class="FloatLeftCss">
            <input type="button" class="bluebuttoncss buttonwidth_140px_300px" id="btnRestoreDftCfg"
                onClick="RestoreONT(this);" value="" BindText="s1127" />
        </div>
        <div id="RestoreDes" style="width:420px;">
            <table height="40px;">
                <tr>
                    <td class="ResetRestoreSpan" BindText="s1126"></td>
                </tr>
            </table>
        </div>
    </div>

    <script language="JavaScript" type="text/javascript">
        if (isTEData()) {
            setDisplay("OntRestore", 1);
            document.write('<br/><br/>');
        }
        var titleRef = "s0906";
        if("IPONLY" == CfgModeWord.toUpperCase() || "FORANET" == CfgModeWord.toUpperCase() || "TELIA" == CfgModeWord.toUpperCase()) {
            titleRef = "s0906";
        } else if (CfgModeWord.toUpperCase() == "DESKAPASTRO") {
            titleRef = "s0906_astro";
        }
        HWCreatePageHeadInfo("firmware", GetDescFormArrayById(FirmwareLgeDes, "s0900"), GetDescFormArrayById(FirmwareLgeDes, titleRef), false);
    </script>
	<table id="tableautoupgrade" style="display:none;" width="100%">
	<tr>
	<td colspan="2" BindText=""></td>
	</tr>
	<tr>
	<td id="autotext" colspan="2" class="func_title" BindText="s090a"></td> <!-- s090a:    "Automatic Upgrade Configuration" -->
	</tr>
	<tr>
	<td class="width_per15" BindText="s090c"></td>  <!-- s090c:    "Enable automatic upgrade" -->
	<td class="width_per85" align="left"><input id="autoupgrade" name="autoupgrade" type="checkbox" onclick="ApplayAutoUpgrade();"></td>
	</tr>
	</table>
	<div class="title_spread"></div>
	<form action="Firmwareupload.cgi?RequestFile=/html/ssmp/reset/reset.asp&FileType=image" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
		<table>
		<tr>
		<td  id="localtext" colspan="3" class="func_title" BindText="s090b" style="display:none;"></td>
		</tr>
			<tr>
				<td class="filetitle" BindText="s0907"></td>
				<td>
					<div class="filewrap">
						<div class="fileupload">
							<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>" />
							<input type="text" id="f_file" autocomplete="off" readonly="readonly" />
							<input type="file" name="browse" id="t_file" size="1"  onblur="StartFileOpt();" onchange="fchange();" />
							<input type="button" id="btnBrowse" class="CancleButtonCss filebuttonwidth_100px" BindText="s0908" />
						</div>
					</div>
				</td>
				<td>
					<input class="CancleButtonCss filebuttonwidth_100px" name="btnSubmit" id="btnSubmit" type='button' onclick='uploadImage();'  BindText="s0909" />
				</td>
			</tr>
		</table>
	</form>	
	<script>
		ParseBindTextByTagName(FirmwareLgeDes, "div",    1);
		ParseBindTextByTagName(FirmwareLgeDes, "td",     1);
		ParseBindTextByTagName(FirmwareLgeDes, "input",  2);
	</script>

</body>
</html>

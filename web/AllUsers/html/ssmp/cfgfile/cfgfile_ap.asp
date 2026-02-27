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
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var UnicomFlag = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_UNICOM);%>";
var NormalUpdownCfg = "<%HW_WEB_GetFeatureSupport(FT_NORMAL_UPDOWNLOADCFG);%>";
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var APwebGuideFlag = '<%HW_WEB_GetFeatureSupport(FT_NEW_AP);%>';
var IsWebLoadConfigfile = "<%HW_WEB_GetFeatureSupport(FT_WEB_LOAD_CONFIGFILE);%>";
function Check_SWM_Status()
{
	var xmlHttp = null;

	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", "../../get_swm_status.asp", false);
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

function LoadFrame() {
	if (curUserType != sysUserType) {
		if ((['PCCW4MAC', 'PCCWSMART', 'PCCW2'].indexOf(CfgMode.toUpperCase()) >= 0) || (NormalUpdownCfg == 1)) {
		    setDisplay('saveConfig', 1);
			setDisplay('downloadConfig', IsWebLoadConfigfile);
			setDisplay('uploadConfig', IsWebLoadConfigfile);
		}
		else
		{
			setDisplay('saveConfig', 1);
			setDisplay('downloadConfig', 0);
			setDisplay('uploadConfig', 0);
		}
	}
	else
	{
		setDisplay('downloadConfig', IsWebLoadConfigfile);
		setDisplay('uploadConfig', IsWebLoadConfigfile);
		if (1 == UnicomFlag)
		{
			setDisplay('saveConfig', 0);
		}
		else
		{
			setDisplay('saveConfig', 1);
		}
	}
	
	setTimeout('delayTime(top.SaveDataFlag)',30);

    if ((['RDSAP', 'FIDNADESKAP2', 'DESKAPHRINGDU'].indexOf(CfgMode.toUpperCase()) >= 0) && (curUserType == '1')) {
        setDisplay('functitleid', 0);
        setDisplay('funcspreadid01', 0);
        setDisplay('funcspreadid02', 0);
        setDisplay('funcspreadid03', 0);
        setDisplay('titlespreadid', 0);
    }
	if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
		setDisplay('titlespreadid', 0);
		$('#downloadconfigbutton, #btnRestoreDftCfg').css("padding-left", "26px");
		$('.filetitle').css({"padding-right": "16px", "min-width": "130px"});
		$('#t_file').css({"right": "-32px", "width": "110px"});
		$('#btnBrowse').css({"right": "-35px", "width": "116px", "height": "36px", "padding-left": "18px"});
		$('#btnSubmit').css({"height": "36px", "padding": "0", "width": "228px", "margin-left": "41px"});
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
	top.previousPage = '/html/ssmp/cfgfile/cfgfile_ap.asp';
	setDisable('btnSubmit', 1);
	uploadForm.submit();
	setDisable('browse',1);
	setDisable('btnBrowse',1);

}

function backupSetting() {
	if (IsWebLoadConfigfile == "0") {
		return;
	}
	if ((CfgMode.toUpperCase() == 'DESKAP') || (CfgMode.toUpperCase() == 'TMAP6')) {
		if (ConfirmEx(GetLanguageDesc("ss0a0b")) == false) {
			return;
		}
	}

	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
	var Form = new webSubmitForm();
	Form.setAction('cfgfiledown.cgi?&RequestFile=html/ssmp/cfgfile/cfgfile_ap.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}


function RestoreDefaultCfg()
{
	var alertRef = 'ss0a01AP';
	if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
		alertRef = 'ss0a01AP_astro';
	}
	if(ConfirmEx(CfgfileLgeDes[alertRef]))
	{
		var Form = new webSubmitForm();
		setDisable('btnRestoreDftCfg', 1);
		Form.setAction('restoredefaultcfg.cgi?' + 'RequestFile=html/ssmp/cfgfile/cfgfile_ap.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
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
	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
}

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
    <script language="JavaScript" type="text/javascript">
    var headRef = "s0102a";
    var titleRef = "s0a04";
    if (((['RDSAP', 'FIDNADESKAP2', 'DESKAPHRINGDU'].indexOf(CfgMode.toUpperCase()) >= 0) && (curUserType == '1')) || (IsWebLoadConfigfile == "0")) {
        headRef = "ss0a03AP";
        titleRef = "ss0a02AP";
    } else if (CfgMode.toUpperCase() == 'DESKAPASTRO') {
        headRef = "s0102a_astro";
        titleRef = "s0a04_astro";
    }
    HWCreatePageHeadInfo("cfgfile", GetDescFormArrayById(CfgfileLgeDes, headRef), GetDescFormArrayById(CfgfileLgeDes, titleRef), false);
    </script>
	<div id ="funcspreadid01" class="func_spread"></div>
	<div id="downloadConfig" style="display:none">
		<div class="func_title" BindText="s0a05"></div>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td><input class="ApplyButtoncss buttonwidth_150px_250px" name="downloadconfigbutton" id="downloadconfigbutton" type='button' onClick='backupSetting()' BindText="s0a05"></td>
			</tr>
		</table>
	</div>
	<div id ="funcspreadid02" class="func_spread"></div>
	<div id="uploadConfig" style="display:none">
		<form action="cfgfileupload.cgi?RequestFile=html/ssmp/reset/reset.asp&FileType=config&RequestToken=<%HW_WEB_GetToken();%>" method="post" enctype="multipart/form-data" name="fr_uploadSetting" id="fr_uploadSetting">
			<div class="func_title" BindText="s0a06"></div>
			<table>
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
						<input type='button' id="btnSubmit" name="btnSubmit" class="CancleButtonCss filebuttonwidth_150px_250px" onclick='uploadSetting();' BindText="s0a06" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id ="funcspreadid03" class="func_spread"></div>
<div id ="titlespreadid" class="title_spread"></div>
<div id ="functitleid" class="func_title" BindText="ss0a03AP"></div>
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> 
      	<input  class = "ApplyButtoncss buttonwidth_150px_250px" name="btnRestoreDftCfg" id="btnRestoreDftCfg" type='button' onClick='RestoreDefaultCfg()'  value="" >
		<script type="text/javascript">
		if( APwebGuideFlag == 1)
		{
			document.getElementsByName('btnRestoreDftCfg')[0].value = CfgfileLgeDes['ss0a03AP']; 
		}
		else
		{
			document.getElementsByName('btnRestoreDftCfg')[0].value = CfgfileLgeDes['ss0a03']; 
		}
		</script>
      </td> 
    </tr> 
  </table> 
</div> 
	<script>
		ParseBindTextByTagName(CfgfileLgeDes, "div",    1);
		ParseBindTextByTagName(CfgfileLgeDes, "td",     1);
		ParseBindTextByTagName(CfgfileLgeDes, "input",  2);
		ParseBindTextByTagName(CfgfileLgeDes, "span", 1);
	</script>

</body>
</html>

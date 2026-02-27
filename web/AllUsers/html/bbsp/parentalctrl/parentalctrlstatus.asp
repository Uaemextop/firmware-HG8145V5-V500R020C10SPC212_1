 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type="text/css">

.head_title_VDF {
	border: #d9d9d9;
	font-family:"Trebuchet MS", Helvetica, sans-serif;
	background-color: #feffe0;
	font-size: 12px;
	font-weight: bold;
	text-align: center;
	color: #000;
	height: 18px;
	line-height: 16px;
}


#pccframeWarpContent {
	height: 610px;
}

</style>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<title>PCCstatus</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="JavaScript" type="text/javascript">


var IsPTVDFFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var Custom_cmcc_rms = '<%HW_WEB_GetFeatureSupport(BBSP_FT_CMCC_PARENTAL_CTRL);%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var BeltelePONFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOM);%>';
var BelteleLanFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOMLAN);%>';
var BinWord ='<%HW_WEB_GetBinMode();%>';
function IsNeedAddSafeDesForBelTelecom(){
	if(1 == BeltelePONFlag || 1 == BelteleLanFlag || CfgModeWord.toUpperCase().indexOf("BELTELECOM") >= 0){
		return true;
	}
	
	return false;
}

var numpara1 = '';
var numpara2 = '';
if( window.location.href.indexOf("?") > 0)
{
    numpara1 = window.location.href.split("?")[1]; 
	numpara2 = window.location.href.split("?")[2]; 
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
		setObjNoEncodeInnerHtmlValue(b, parentalctrl_language[b.getAttribute("BindText")]);
	}
}

function LoadFrame()
{
	ClickAllInfo();
	loadlanguage();
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		$('.TagTitle').css({"font-weight": "normal", "color": "#888888"});
		$('#tabTableId').css({"border": "solid #f6f6f8", "border-collapse": "collapse", "border-bottom": "2px solid #888888"});
		$('#tabSpaceId').css({"width": "50%", "border-bottom": "2px solid #f6f6f8"});
		$('#tabHelpId').css("border-bottom", "2px solid #f6f6f8");
		$('#tab1').css("border-bottom", "2px solid #e6007d");
		$('#tab1Span').css("color", "black");
		$('a').css("text-decoration", "none");
		$('.align_left').css({"text-align": "left", "font-size": "16px", "font-weight": "bold", "padding": "32px 0 5px 32px"});
		$('#tableHelpTitle').css({"padding": "48px 0 32px 32px", "font-size": "24px"});
		document.getElementById("tableHelpTitle").innerHTML = parentalctrl_language["bbsp_pcchelptitle_astro"];
		document.getElementById("helpTitleInfo").innerHTML = parentalctrl_language["bbsp_pcchelpinfo_astro"];
		document.getElementById("helpTempInfo1").innerHTML = parentalctrl_language["bbsp_pcchelptempalteinfo1_astro"];
		document.getElementById("helpTempInfo2").innerHTML = parentalctrl_language["bbsp_pcchelptempalteinfo2_astro"];
		document.getElementById("helpTempInfo3").innerHTML = parentalctrl_language["bbsp_pcchelptempalteinfo3_astro"];
		document.getElementById("helpAllInfo1").innerHTML = parentalctrl_language["bbsp_pcchelpallinfo1_astro"];
		document.getElementById("helpAllInfo3").innerHTML = parentalctrl_language["bbsp_pcchelpallinfo3_astro"];
		document.getElementById("helpStatInfo1").innerHTML = parentalctrl_language["bbsp_statinfo1_astro"];
		document.getElementById("helpFAQ1").innerHTML = parentalctrl_language["bbsp_FAQQ1info_astro"];
		document.getElementById("helpFAQ11").innerHTML = parentalctrl_language["bbsp_FAQA1info1_astro"];
		document.getElementById("helpFAQ12").innerHTML = parentalctrl_language["bbsp_FAQA1info2_astro"];
		document.getElementById("helpFAQ13").innerHTML = parentalctrl_language["bbsp_FAQA1info3_astro"];
		document.getElementById("helpFAQ2").innerHTML = parentalctrl_language["bbsp_FAQQ2info_astro"];
		document.getElementById("helpFAQ21").innerHTML = parentalctrl_language["bbsp_FAQA2info1_astro"];
		document.getElementById("helpFAQ22").innerHTML = parentalctrl_language["bbsp_FAQA2info2_astro"];
		document.getElementById("helpFAQ23").innerHTML = parentalctrl_language["bbsp_FAQA2info3_astro"];
	}
}

function ClickAllInfo()
{
	if (CfgModeWord.toUpperCase() == 'PLPLAYAP') {
		document.getElementById("ParentalctrlAllInfo").style.color = "#6c43bf";
	} else {
		document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleClick").css("color");
	}
	document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleNoClick").css("color");
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		$('#tab1').css("border-bottom", "2px solid #e6007d");
		$('#tab1Span').css("color", "black");
		$('#tab2, #tab3').css("border-bottom", "");
		$('#tab2Span, #tab3Span').css("color", "");
	}
	if( window.location.href.indexOf("?") > 0 && (GetCfgMode().OSK == 1 || GetCfgMode().COMMON == 1))
	{
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrlmac.asp?" + htmlencode(numpara1) +'?' + htmlencode(numpara2);
	}
	else
	{
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrlmac.asp";
	}
}
function ClickTemplate()
{
	if (CfgModeWord.toUpperCase() == 'PLPLAYAP') {
		document.getElementById("ParentalctrlTemplate").style.color = "#6c43bf";
	} else {
		document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleClick").css("color");
	}
	document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleNoClick").css("color");
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		$('#tab2').css("border-bottom", "2px solid #e6007d");
		$('#tab2Span').css("color", "black");
		$('#tab1, #tab3').css("border-bottom", "");
		$('#tab1Span, #tab3Span').css("color", "");
	}
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrltemplate.asp";
}
function ClickStatistics()
{
	if (CfgModeWord.toUpperCase() == 'PLPLAYAP') {
		document.getElementById("ParentalctrlStatistics").style.color = "#6c43bf";
	} else {
		document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleClick").css("color");
	}
	document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleNoClick").css("color");
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		$('#tab3').css("border-bottom", "2px solid #e6007d");
		$('#tab3Span').css("color", "black");
		$('#tab1, #tab2').css("border-bottom", "");
		$('#tab1Span, #tab2Span').css("color", "");
	}
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrlStat.asp";
}

function showdiag()
{
	var d = document.getElementById("diag");
	d.style.left  =20;
	d.style.top =0;
	d.style.display = "block";
	if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
		d.style.margin = "15px";
		d.style.left = "1px";
	}
}
function closeDiag()
{
	var d = document.getElementById("diag");
	d.style.display = "none";
}

function adjustParentHeight(containerID, newHeight)
{
	$("#DivContent").css("height", 'auto');
	var newHeight1 = (newHeight > 700) ? newHeight : 700;
	$("#" + containerID).css("height", newHeight1 + "px");

	if ((navigator.appName.indexOf("Internet Explorer") == -1)
		&& (containerID == "pccframeWarpContent"))
	{
		var height1 = document.body.scrollHeight;
		var height = (height1 > 700) ? height1 : 700;
		$("#DivContent").css("height", height + "px");
	}
}

if( Custom_cmcc_rms == 1 )
{
	parentalctrl_language['bbsp_FAQA2info2'] = parentalctrl_language['bbsp_FAQA2info2cmcc'];
}

</script>
</head>
<body  onLoad="LoadFrame();" class="mainbody">
	<div id="DivContent" style="display:block">
		<table width="100%" height="0" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr>
		<script language="JavaScript" type="text/javascript">
		if (IsNeedAddSafeDesForBelTelecom() == true) {
			HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title") + "<p style=\"color:red;\">Пользователь несет полную ответственность за изменение им настроек модема, которые могут повлечь несанкционированный доступ к модему сетевых злоумышленников и причинить пользователю финансовый ущерб.</p>", false);
		} else if ((CfgModeWord == "CNT") || (CfgModeWord == "CNT2")) {
            HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title_cnt"), false);
        } else if (('<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>' == 1) && (BinWord.toUpperCase() == 'A8C')) {
            HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title_a8c"), false);
		} else if (CfgModeWord.toUpperCase() == "DESKAPASTRO") {
			HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title_astro"), false);
		} else {
			HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title"), false);
		}
    	</script>
		</table>  
	   <div class="title_spread"></div>

		<table id="tabTableId">
			<tr>
				<td id="tab1" width="5%" class="TagTitle1"><a id="ParentalctrlAllInfo" href="#" name="ParentalctrlAllInfo" onClick="ClickAllInfo();"><span id="tab1Span" class="TagTitle"><script> document.write(parentalctrl_language['bbsp_all']); </script></span></a></td>
				<td class="TagLineSpace"></td>
				<td class="TagLine">|</td>
				<td class="TagLineSpace"></td>
				<td  id="tab2" width="5%"><a id="ParentalctrlTemplate" href="#" name="ParentalctrlTemplate" onClick="ClickTemplate();"><span id="tab2Span" class="TagTitle"><script> document.write(parentalctrl_language['bbsp_template']); </script></span></a></td>
				<td class="TagLineSpace"></td>
				<td class="TagLine">|</td>
				<td class="TagLineSpace"></td>
				<td id="tab3" width="5%"><a id="ParentalctrlStatistics" href="#" name="ParentalctrlStatistics" onClick="ClickStatistics();"><span id="tab3Span" class="TagTitle"><script> document.write(parentalctrl_language['bbsp_stat']); </script></span></a></td>
				<td id="tabSpaceId" width="75%"></td>
				<td id="tabHelpId" width="10%"><a id="Parentalctrlhelp" href="#" name="Parentalctrlhelp" onClick="showdiag();"><script> document.write(parentalctrl_language['bbsp_help']); </script></a></td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr ><td height="10">
			<div id="tagclick" class="TagTitleClick"></div>
			<div id="tagnoclick" class="TagTitleNoClick"></div>
			</td></tr>
		</table>

		<div id="diag" width="100%" class = "diaghelp" onClick="closeDiag();">
			<table  id="TableHelp"   width="100%" border="0" cellpadding="0" cellspacing="0">
				<script language="JavaScript" type="text/javascript">
				    if (IsPTVDFFlag == '1')
				    {
				    	document.write('<tr class="head_title_VDF">');
					}
					else if ('<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>' == 1)
					{
						document.write('<tr class="head_title">');
					}
				    else
				    {
				    	document.write('<tr class="head_helptitle">');
					}
				</script>
					<td id="tableHelpTitle" class='align_left' colspan="2" BindText ='bbsp_pcchelptitle'></td>
					<script language="JavaScript" type="text/javascript">
						if (CfgModeWord.toUpperCase() == 'DESKAPASTRO') {
							document.write('<span class="parentCtrlHelp_close"> </span>');
						}
					</script>
				</tr>
				<tr>
					<td id="helpTitleInfo" class="table_helptitle" BindText ='bbsp_pcchelpinfo'> </td>
				</tr>

				<script language="JavaScript" type="text/javascript">
				    if (IsPTVDFFlag == '1')
				    {
				    	document.write('<tr class="head_title_VDF">');
				    }
				    else if ('<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>' == 1)
				    {
				    	document.write('<tr class="head_title">');
				    }
				    else
				    {
				    	document.write('<tr class="head_helptitle">');
					}
				</script>
					<td class='align_left' colspan="2" BindText ='bbsp_template'></td>
				</tr>
				<tr>
					<td id="helpTempInfo1" class="table_helptitle"  colspan="2"  BindText ='bbsp_pcchelptempalteinfo1'> </td>
				</tr>
				<tr>
					<td class="table_helptitle"  colspan="2" BindText ='bbsp_pcchelpexplain'> </td>
				</tr>
				<tr>
					<td id="helpTempInfo2" class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelptempalteinfo2'> </td>
				</tr>
				<tr>
					<td id="helpTempInfo3" class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelptempalteinfo3'> </td>
				</tr>
				<tr>
					<td class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelptempalteinfo4'> </td>
				</tr>
				<tr>
					<td class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelptempalteinfo5'> </td>
				</tr>

				<script language="JavaScript" type="text/javascript">
				    if (IsPTVDFFlag == '1')
				    {
				    	document.write('<tr class="head_title_VDF">');
				    }
				    else if ('<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>' == 1)
				    {
				    	document.write('<tr class="head_title">');
				    }
				    else
				    {
				    	document.write('<tr class="head_helptitle">');
					}
				</script>
					<td class='align_left' colspan="2" BindText ='bbsp_all'></td>
				</tr>
				<tr>
					<td id="helpAllInfo1" class="table_helptitle"  colspan="2"  BindText ='bbsp_pcchelpallinfo1'> </td>
				</tr>
				<tr>
					<td class="table_helptitle"  colspan="2" BindText ='bbsp_pcchelpexplain'> </td>
				</tr>
				<tr>
					<td class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelpallinfo2'> </td>
				</tr>
				<tr>
					<td id="helpAllInfo3" class="table_helptitle bullet_info"  colspan="2" BindText ='bbsp_pcchelpallinfo3'> </td>
				</tr>

				<script language="JavaScript" type="text/javascript">
				    if (IsPTVDFFlag == '1')
				    {
				    	document.write('<tr class="head_title_VDF">');
				    }
				    else
				    {
				    	document.write('<tr class="head_helptitle">');
					}
				</script>
					<td class='align_left' colspan="2" BindText ='bbsp_stattitle'></td>
				</tr>
				<tr>
					<td id="helpStatInfo1" class="table_helptitle"  colspan="2"  BindText ='bbsp_statinfo1'> </td>
				</tr>

				<script language="JavaScript" type="text/javascript">
				    if (IsPTVDFFlag == '1')
				    {
				    	document.write('<tr class="head_title_VDF">');
					}
					else if ('<%HW_WEB_GetFeatureSupport(HW_FEATURE_ZQ);%>' == 1)
					{
						document.write('<tr class="head_title">');
					}
				    else
				    {
				    	document.write('<tr class="head_helptitle">');
					}
				</script>
					<td class='align_left' colspan="2" BindText ='bbsp_FAQtitle'></td>
				</tr>
				<tr>
					<td id="helpFAQ1" class="table_helptitle bold_astro"  colspan="2"  BindText ='bbsp_FAQQ1info'> </td>
				</tr>
				<tr>
					<td id="helpFAQ11" class="table_helptitle bullet_info"  colspan="2"  BindText ='bbsp_FAQA1info1'> </td>
				</tr>
				<tr>
					<td id="helpFAQ12" class="table_helptitle bullet_info"  colspan="2"  BindText ='bbsp_FAQA1info2'> </td>
				</tr>
				<tr>
					<td id="helpFAQ13" class="table_helptitle bullet_info last_info_space"  colspan="2"  BindText ='bbsp_FAQA1info3'> </td>
				</tr>
				<tr>
					<td id="helpFAQ2" class="table_helptitle question_title bold_astro"  colspan="2"  BindText ='bbsp_FAQQ2info'> </td>
				</tr>
				<tr>
					<td id="helpFAQ21" class="table_helptitle bullet_info"  colspan="2"  BindText ='bbsp_FAQA2info1'> </td>
				</tr>
				<tr>
					<td id="helpFAQ22" class="table_helptitle bullet_info"  colspan="2"  BindText ='bbsp_FAQA2info2'> </td>
				</tr>
				<tr>
					<td id="helpFAQ23" class="table_helptitle bullet_info last_info_space"  colspan="2"  BindText ='bbsp_FAQA2info3'> </td>
				</tr>
			</table>
		</div>

		<div id="pccframeWarpContent">
			<iframe id="pccframeContent" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" width="100%" height="100%" />
		</div>
	</div>
</body>
</html>

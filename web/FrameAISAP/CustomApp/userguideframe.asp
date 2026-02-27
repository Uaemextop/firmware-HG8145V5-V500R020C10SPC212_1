<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Pragma" content="no-cache" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>" media="all" rel="stylesheet" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(guide.css);%>" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script type="text/javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script type="text/javascript" src="/resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="javascript" src="/html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="/html/bbsp/common/wan_list.asp"></script>

<title></title>
</head>
<script>
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var ProductType = '<%HW_WEB_GetProductType();%>';
var IsSurportInternetCfg  = "<%HW_WEB_GetFeatureSupport(BBSP_FT_GUIDE_PPPOE_WAN_CFG);%>";
var IsSurportWlanCfg  = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var UpgradeFlag = 0;
var selectrepwlan = "";
var wifiForm = null;
var mngttype = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var logo_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var TypeWord_com = '<%HW_WEB_GetTypeWord();%>';
document.title = ProductName;
var smartlanfeature = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_LAN_UPPORT);%>';
var telmexwififeature = '<%HW_WEB_GetFeatureSupport(FT_PRODUCT_TELMEX);%>';
var curChangeMode = '<%HW_WEB_GetAPChangeModeValue();%>'; 
var apcmodefeature = '<%HW_WEB_GetFeatureSupport(FT_SSMP_AP_OPERATION_SWITCH);%>';
var GhnDevFlag = '<%HW_WEB_GetFeatureSupport(FT_SSMP_GHNAP_MNGT);%>';
var IsSmartDev = "<%HW_WEB_GetFeatureSupport(HW_OSGI_FT_BUNDLEINFOWEB);%>";
var DirectGuideFlag = '<%HW_WEB_GetFeatureSupport(FT_CHANGE_GUIDE_LEVEL);%>';
var DAUMLOGO = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_Web.X_WebLogo);%>';
var DAUMFEATURE = "<%HW_WEB_GetFeatureSupport(FT_PRODUCT_DAUM);%>";
var trueAdapt = '<%HW_WEB_GetFeatureSupport(FT_TRUE_ADAPT);%>';

var UserGuideSteps = getUserGuideSteps();
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var aprepeater = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_BbspConfig.UpLinkStatus);%>';
var aprepEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_FeatureList.BBSPCustomization.AutoSelectSlaveApUpPort);%>';
var timer = [];
if(1 != curChangeMode && 1 == aprepEnable)
{
	if(3 == aprepeater)
	{
		curChangeMode = 2;
	}
	else if(8 == aprepeater)
	{
		curChangeMode = 3;
	}
}
function getUserGuideSteps()
{
	return ((IsSurportInternetCfg == "1" && mngttype == "0") ? 0x2 : 0) + (IsSurportWlanCfg == "1" ? 1 : 0);
}

function filterPPPInternetWan(wanItem)
{
	if ((wanItem.ServiceList.toUpperCase().indexOf("INTERNET") >= 0)
		&& (wanItem.EncapMode.toUpperCase() == "PPPOE"))
	{
		return true; 
	}

	return false;
}

var internetPPPWanInfo = GetWanListByFilter(filterPPPInternetWan);

if(internetPPPWanInfo.length > 0)
{
	if((1 == smartlanfeature &&  1== IsSurportWlanCfg))
	{
		UserGuideSteps = 3;
	}
	else if((1 == smartlanfeature &&  0== IsSurportWlanCfg))
	{
		UserGuideSteps = 2;
	}
}

function showStep(step)
{
	//setDisplay("span" + step, flag);
	$("#span" + step).css("display", "inline-block");
	$("#span" + step).css("display", "-moz-inline-stack");
	setDisplay("ico"  + step, 1);
}

function setStepClass(step, css)
{
	$("#span" + step).addClass(css);
	$("#ico"  + step).addClass(css);
}

function loadframe()
{	
	var CfgAccountSrc = (1 == DirectGuideFlag)?"/html/ssmp/accoutcfg/guideaccountcfgAP.asp":"/html/ssmp/accoutcfg/guideaccountcfg.asp";
	
	if("" != curChangeMode && 0 != curChangeMode)
	{
		if(1 == apcmodefeature)
		{
			$("#spancmodeconfig").css("display", "inline-block");
			$("#icocmodeimage").css("display", "inline-block");
			$("#spanwlanconfig").css("display", "none");
			$("#icowlanconfig").css("display", "none");	
			document.getElementById("frameContent").src = "/html/ssmp/modechange/modechange_aisap.asp";
			$("#selectarrow").addClass("guidestep1of3");
			//setStepClass("wlanconfig", "guidestepintv3");
			setStepClass("sysconfig",  "guidestepintv3");
			setStepClass("configdone", "guidestepintv3");
			showStep("cmodecfg");	
			if("VDFPTAP"==CfgMode || "TRUEAP"==CfgMode)
			{
				document.getElementById("frameContent").src = "/html/amp/wlaninfo/wlanneighborAP.asp";
			}
			if(trueAdapt == 1)
			{
				document.getElementById("frameContent").src = "/html/ssmp/modechange/modechange_aisap.asp";
			}
		}
		else
		{
			if(curChangeMode=='2' || curChangeMode=='3')
			{
				$("#spancmodeconfig").css("display", "none");
				$("#icocmodeimage").css("display", "none");
				$("#spanwlanconfig").css("display", "none");
				$("#icowlanconfig").css("display", "none");	
				document.getElementById("frameContent").src = CfgAccountSrc;
				$("#selectarrow").addClass("guidestep1of2");
				//setStepClass("sysconfig",  "guidestepintv2");
				setStepClass("configdone", "guidestepintv2");
				
			}
		}
	}

	else
	{
		switch (UserGuideSteps)
		{
			case 3:
				document.getElementById("frameContent").src = "/html/bbsp/guideinternet/guideinternet.asp";
				$("#selectarrow").addClass("guidestep1of4");
				//setStepClass("internetconfig", "guidestepintv4");
				setStepClass("wlanconfig",     "guidestepintv4");
				setStepClass("sysconfig",      "guidestepintv4");
				setStepClass("configdone",     "guidestepintv4");
				showStep("internetconfig");
				showStep("wlanconfig");
				break;
			case 2:
				document.getElementById("frameContent").src = "/html/bbsp/guideinternet/guideinternet.asp";
				$("#selectarrow").addClass("guidestep1of3");
				//setStepClass("internetconfig", "guidestepintv3");
				setStepClass("sysconfig",      "guidestepintv3");
				setStepClass("configdone",     "guidestepintv3");
				showStep("internetconfig");
				break;
			case 1:	
					document.getElementById("frameContent").src = "/html/amp/wlanbasic/guidewificfg.asp";
					$("#selectarrow").addClass("guidestep1of3");
					//setStepClass("wlanconfig", "guidestepintv3");
					setStepClass("sysconfig",  "guidestepintv3");
					setStepClass("configdone", "guidestepintv3");
					showStep("wlanconfig");
					break;
			default:
				document.getElementById("frameContent").src = CfgAccountSrc;
				$("#selectarrow").addClass("guidestep1of2");
				//setStepClass("sysconfig",  "guidestepintv2");
				setStepClass("configdone", "guidestepintv2");
				break;
		}
	}
	setDisplay("selectarrow", 1);
	showStep("sysconfig");
	showStep("configdone");
	timer.push(setInterval("adjustParentHeight();", 200));
	wifiForm = new webSubmitForm();
}

function onchangestep(val)
{
	var id = val.id;
	var totalSteps = 2;
	var curStep = 1;
	var defStepOff = 2;
	var wifiStepOff = 0;

	switch (UserGuideSteps)
	{
		case 3:
			totalSteps  = 4;
			wifiStepOff = 0;
			defStepOff  = 2;
			break;
		case 2:
			totalSteps  = 3;
			wifiStepOff = 0;
			defStepOff  = 1;
			break;
		case 1:
			totalSteps  = 3;
			wifiStepOff = -1;
			defStepOff  = 1;
			break;
		default:
			wifiStepOff = -1;
			defStepOff  = 0;
			break;
	}
	
	
	if(id == "guideinternet")
	{
		curStep = 1;
	}
    else if(id == "guidewificfg" || id == "guidecmodecfg" || id == "guidewlanconfig") 
	{
		curStep = 2 + wifiStepOff;
	}
	else if(id == "guidesyscfg")
	{
		curStep = 1 + defStepOff;
	}
	else if(id == "guidecfgdone")
	{
		curStep = 2 + defStepOff;
	}
	else
	{
		return;
	}
	
	if((2 == curChangeMode && 0 == apcmodefeature) || (3 == curChangeMode && 0 == apcmodefeature))
	{
		totalSteps  = 2;
		defStepOff = 0;
		if(id == "guidecfgdone"){
			curStep = 2 + defStepOff;
		}else if(id == "guidesyscfg"){
			curStep = 1 + defStepOff;
		}else{
			return;
		}
	}
	
	resetArrowClass();
	$("#selectarrow").addClass("guidestep" + curStep + "of" + totalSteps);
	if('1' == smartlanfeature && val.name.indexOf("guidebssinfo.asp") != -1){
		val.name = "/html/ssmp/cfgguide/userguidecfgdone.asp";
	}
	
	document.getElementById("frameContent").src = val.name;
	timer.push(setInterval("adjustParentHeight();", 200));
}

function resetArrowClass()
{
	var steps = new Array("1of4", "2of4", "3of4", "4of4",
						  "1of3", "2of3", "3of3",
						  "1of2", "2of2");
	for (var i = 0; i < steps.length; i++)
	{
		$("#selectarrow").removeClass("guidestep" + steps[i]);
	}
}

function adjustParentHeight()
{
	adjustFrameHeight("framepageContent", "frameContent", 90);
}
</script>
<body onload="loadframe();">
	<div id="guideframebody">
		<div id="guideframebg">
			<script>
			if(true == logo_singtel)
			{
				document.write('<div id="brandlog_singtel" style="display:none;"></div>');				
			}
			else if (telmexwififeature == 1)
			{
				document.write('<div id="brandlog_telmex" style="display:none;"></div>');
			}
			else if ('TELECENTRO' == CfgMode.toUpperCase())
			{
				document.write('<div id="brandlog_telecentro" style="display:none;"></div>');
			}
			else if ('PLDT2' == CfgMode.toUpperCase() || 'PLDT' == CfgMode.toUpperCase())
			{
				document.write('<div id="brandlog_pldt" style="display:none;"></div>');
			}
			else if ('OMANONT' == CfgMode.toUpperCase())
			{
				document.write('<div id="brandlog_oman" style="display:none;"></div>');
			}
			else if ('MAROCTELECOM' == CfgMode.toUpperCase())
			{
				document.write('<div id="brandlog_maroctelecom" style="display:none;"></div>');
			}
			else if ('ORANGEMT' == CfgMode.toUpperCase())
			{
				document.write('<div style="margin: 0 auto">' + '<div style="height: 8px"></div>'+'<img id="brandlog_orangemt" src="../../images/hwlogo_orangemt.gif" width="48px"></img>' + '<div  id="ProductNameOrg">' + ProductName + '</div>'+'</div>');
			}
			else if((DAUMFEATURE == 1) && (DAUMLOGO == 1))
			{
				document.write('<div id="brandlog_daum_dodo" style="display:none;"></div>');
			}
			else if((DAUMFEATURE == 1) && (DAUMLOGO == 2))
			{
				document.write('<div id="brandlog_daum_iprimus" style="display:none;"></div>');
			}			
			else if ('DNZTELECOM2WIFI' == CfgMode.toUpperCase())
			{
				document.write('<div id="brandlog_dnztelecom" style="display:none;"></div>');
			}
			else
			{
				document.write('<div id="brandlog" style="display:none;"></div>');
			}
			</script>
			<script>
			if(true == logo_singtel)
			{
				document.write('<div id="ProductName" style="text-align:right; margin-left:630px;">' + ProductName + '</div>');				
			}
			else if ('ORANGEMT' !== CfgMode.toUpperCase())
			{
				document.write('<div id="ProductName">' + ProductName + '</div>');
			}
			</script>
			<script>
			if(true == logo_singtel)
			{
				if(TypeWord_com == "COMMON")
				{
					document.write('<div id="guideframehead"><span BindText="s2012SINGTELHS"></span></div>');
				}
				else
				{
					document.write('<div id="guideframehead"><span BindText="s2012SINGTEL"></span></div>');
				}
			}
			else
			{	
				if(smartlanfeature == 1)
				{	if("" != curChangeMode && 0 != curChangeMode || GhnDevFlag == 1)
					{
						document.write('<div id="guideframehead"><span BindText="s2012aplan"></span></div>');
					}
					else if(1 == IsSmartDev)
					{
						document.write('<div id="guideframehead"><span BindText="s2012lan"></span></div>');
					}else{
						document.write('<div id="guideframehead"><span BindText="s2012aplan"></span></div>');
					}
				}
				else{
                    if (ProductType == '2')
                    {
                        document.write('<div id="guideframehead"><span BindText="s2012_xd"></span></div>');
                    }
                    else
                    {
                        document.write('<div id="guideframehead"><span BindText="s2012"></span></div>');
                    }
				}
				
			}
			</script>
			<div id="guidestepsinfo" class="guidestepinfo">
				<div id="guidestepstitle">
					<span id="spaninternetconfig" class="" style="display:none;" BindText="s2016"></span>
					<span id="spanwlanconfig"     class="" style="display:none;" BindText="s2017"></span>

					<span id="spancmodeconfig"    class="" style="display:none;word-wrap: break-word;width: 118px;font-size: 18px;color: #ffffff;font-family: Arial, Î¢ÈíÑÅºÚ" BindText="s2038"></span>

					<span id="spansysconfig"      class="" style="display:none;" BindText="s2018"></span>
					<span id="spanconfigdone"     class="" style="display:none;" BindText="s2015"></span>
				</div>
				<div id="guidestepsico">
					<img id="icointernetconfig"   class="" style="display:none;" name="../../html/bbsp/guideinternet/guideinternet.asp" src="../images/configinternet.jpg" />
					<img id="icowlanconfig"       class="" style="display:none;" name="../../html/amp/wlanbasic/guidewificfg.asp" src="../images/configwlan.jpg" />

					<img id="icocmodeimage" class="" style="display:none;" name="" src="../images/cmode.png">


					<img id="icosysconfig"        class="" style="display:none;" name="guidesystemcfg.asp" src="" />
					<img id="icoconfigdone"       class="" style="display:none;" name="userguidecfgdone.asp" src="../images/configdone.jpg" />
				</div>
				<script type="text/javascript">
					if (true == logo_singtel)
					{
						document.getElementById("icosysconfig").src= "../images/syscfgnowifi.jpg";
					}
					else
					{
						document.getElementById("icosysconfig").src= "../images/syscfg.jpg";
					}
				</script>
			</div>
			<div id="selectarrow" style="display:none;">
				<img id="arrowimg" src="../images/guidearrow.jpg">
			</div>
		</div>
	</div>
	<div id="greenline"></div>
	<div id="framepageContent">
		<iframe id="frameContent" width="100%" frameborder="0" height="100%" marginheight="0" marginwidth="0" src=""></iframe>
	</div>
	<div style="display:none;">
		<iframe frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/refresh.asp"></iframe>
	</div>
	<script>
		ParseBindTextByTagName(CfgguideLgeDes, "span", 1, mngttype, logo_singtel);
		if (parseInt(mngttype, 10) != 1)
		{						
			if(parseInt(logo_singtel, 10) == 1)
			{
			    if(TypeWord_com == "COMMON")
				{
					$("#brandlog_singtel").css("background-image", "url()");
				}
			    $("#brandlog_singtel").css("display", "block");
			}
			else if (telmexwififeature == 1)
			{
				var btn=document.getElementById('brandlog_telmex');
				btn.onclick=function(){window.location.href="http://www.telmex.com";};
				$("#brandlog_telmex").css("display", "block");
				$("#brandlog_telmex").css("background", "url(../../../images/HeadertelmexLog.jpg)");
				$("#guideframebody").css("background-image", "url(../images/loginbg_telmex.jpg)");
				$("#brandlog_telmex").css("width", "187px");
				$("#brandlog_telmex").css("float", "left");
				$("#brandlog_telmex").css("height", "63px");
				$("#headerProductName").css("color","#56b2f8");
				$("#ProductName").css("line-height","58px");
			}
			else
			{
			    if ('TELECENTRO' == CfgMode.toUpperCase())
				{
					$("#brandlog_telecentro").css("display", "block");
				}
				else if ('PLDT2' == CfgMode.toUpperCase() || 'PLDT' == CfgMode.toUpperCase())
				{
					$("#brandlog_pldt").css("display", "block");
				}
				else if ('OMANONT' == CfgMode.toUpperCase())
				{
					$("#brandlog_oman").css("display", "block");
				}
				else if ('MAROCTELECOM' == CfgMode.toUpperCase())
				{
					$("#brandlog_maroctelecom").css("display", "block");
				}
				else if ('ORANGEMT' == CfgMode.toUpperCase())
				{
					$("#brandlog_orangemt").css("display", "block");
				}
				else if((DAUMFEATURE == 1) && (DAUMLOGO == 1))
				{
					$("#brandlog_daum_dodo").css("display", "block");
				}
				else if((DAUMFEATURE == 1) && (DAUMLOGO == 2))
				{
					$("#brandlog_daum_iprimus").css("display", "block");
				}
				else if ('DNZTELECOM2WIFI' == CfgMode.toUpperCase())
				{
					$("#brandlog_dnztelecom").css("display", "block");
				}
				else
				{
					$("#brandlog").css("display", "block");
				}
			}				
		}
	</script>
</body>
</html>

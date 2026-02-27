<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Pragma" content="no-cache" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>"  media="all" rel="stylesheet" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(guide.css);%>" rel="stylesheet" type="text/css" />
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript" ></script>
<script language="JavaScript" src="/resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<title></title>
</head>
<script>
var wifiPara = new Object();
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var ontAuthPage = '';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var ProductType = '<%HW_WEB_GetProductType();%>';
var IsSurportWlanCfg  = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var RedirtIndex = '<%HW_WEB_GetGuideChl();%>';
var UpgradeFlag = 0; 
var mngttype = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var logo_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var smartlanfeature = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_LAN_UPPORT);%>';
var IsSupportpon2lan = '<%HW_WEB_GetFeatureSupport(FT_PON_UPPORT_CONFIG);%>'; 
var CurrentUpMode = '<%HW_WEB_GetUpMode();%>';
var IsSmartDev = "<%HW_WEB_GetFeatureSupport(HW_OSGI_FT_BUNDLEINFOWEB);%>";
var apcmodefeature = '<%HW_WEB_GetFeatureSupport(FT_SSMP_AP_OPERATION_SWITCH);%>';
var curChangeMode = '<%HW_WEB_GetAPChangeModeValue();%>'; 
var GhnDevFlag = '<%HW_WEB_GetFeatureSupport(FT_SSMP_GHNAP_MNGT);%>';
var telmexwififeature = '<%HW_WEB_GetFeatureSupport(FT_PRODUCT_TELMEX);%>';
var DAUMLOGO = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_Web.X_WebLogo);%>';
var DAUMFEATURE = "<%HW_WEB_GetFeatureSupport(FT_PRODUCT_DAUM);%>";
var Passwordmode = 0;
var selectrepwlan = "";
var TypeWord_com = '<%HW_WEB_GetTypeWord();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
RedirtIndex = RedirtIndex-48;
var timer = [];
wifiPara.wifiFlag = 0;
document.title = ProductName;
function setOntAuthPage()
{
	if("chinese" == curLanguage)
	{
		ontAuthPage = '../../html/amp/ontauth/password.asp';
	}
	else
    {
        if (ProductType == '2')
        {
            ontAuthPage = '../../html/bbsp/wan/wan.asp?cfgguide=1';
        }
        else
        {
            ontAuthPage = '../../html/amp/ontauth/passwordcommon.asp';
        }
    }
    if (ProductType == '2')
    {
        getElById('icowancfg').name = ontAuthPage;
    }
    else
    {
        getElById('icoontauth').name = ontAuthPage;
    }
	getElById('frameContent').src = ontAuthPage;
}

function ifNoWanStep()
{
	if(1 == logo_singtel)
	{
		return true;
	}
	else
	{
		return (0 < RedirtIndex) && (RedirtIndex < 4);
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
function apcmodefun()
{
	if(curChangeMode == 2 || curChangeMode == 3)
	{
		var modeChangePage = "../../html/ssmp/modechange/modechange_aisap.asp?cfgguide=1";
		var wlanneighborAPPage = "../../html/amp/wlaninfo/wlanneighborAP.asp";
		var resultPage = (CfgMode == "VDFPTAP" || CfgMode == "TRUEAP")?wlanneighborAPPage:modeChangePage;
		$("#spanwancfg").css("display", "none");
		$("#icowancfg").css("display", "none");
		$("#icocmode").css("display", "inline-block");
		$("#spancmodecfg").css("display", "inline-block");
		
		showStep("cmodecfg");
		$("#selectarrow").addClass("guidestep1of2");
		setStepClass("cfgdone", "guidestepintv2");
		getElById('icocmode').name = resultPage;
		getElById('frameContent').src = resultPage;
		wifiPara.id = "guidecmodecfg";
		wifiPara.name = resultPage;
	}
	else if(curChangeMode == 1)
	{
		$("#spanwancfg").css("display", "inline-block");
		$("#icowancfg").css("display", "inline-block");
		$("#icocfgdone").css("display", "inline-block");
		$("#spancfgdone").css("display", "inline-block");
		$("#icocmode").css("display", "inline-block");
		$("#spancmodecfg").css("display", "inline-block");
		
		showStep("cmodecfg");
		$("#selectarrow").addClass("guidertstep");
		$("#icocmode").addClass("guideicocmode");
		$("#spancmodecfg").addClass("guidecmodestep");
		$("#icocfgdone").addClass("guidestepintv2rt");
		$("#spancfgdone").addClass("guidestepintv2rt");
		$("#icowancfg").addClass("guideicowancfg");
		$("#spanwancfg").addClass("guidewanstep");

		setStepClass("cfgdone", "guidestepintv2");
		getElById('icocmode').name = "../../html/ssmp/modechange/modechange_aisap.asp?cfgguide=1";
		getElById('frameContent').src = "../../html/ssmp/modechange/modechange_aisap.asp?cfgguide=1";
		wifiPara.id = "guidecmodecfg";
		wifiPara.name = "../../html/ssmp/modechange/modechange_aisap.asp?cfgguide=1";
	}
}
var wifiForm = null;
function loadframe()
{
	if(1 == smartlanfeature || (3 == CurrentUpMode && 1 == IsSupportpon2lan))
	{
		if(("" != curChangeMode && 0 != curChangeMode) || 1 == GhnDevFlag)
		{
			apcmodefun();
		}
		else
		{
			showStep("wancfg");
			$("#selectarrow").addClass("guidestep1of2");
			setStepClass("cfgdone", "guidestepintv2");
			getElById('icowancfg').name = "../../html/bbsp/wan/wan.asp?cfgguide=1";
			getElById('frameContent').src = "../../html/bbsp/wan/wan.asp?cfgguide=1";
			wifiPara.id = "guidewancfg";
			wifiPara.name = "../../html/bbsp/wan/wan.asp?cfgguide=1";
		}
	}
	else
	{
		if(("" != curChangeMode && 0 != curChangeMode) || 1 == GhnDevFlag)
		{
			apcmodefun();
		}
		else
		{
			if (ifNoWanStep())
			{
				$("#selectarrow").addClass("guidestep1of2");
				//setStepClass("ontauth", "guidestepintv2");
				setStepClass("cfgdone", "guidestepintv2");
				wifiPara.id = "guidecfgdone";
				wifiPara.name = "../../html/ssmp/bss/guidebssinfo.asp";
			}
			else
            {
                if (ProductType == '2')
                {
                    $("#selectarrow").addClass("guidestep1of4");
                    setStepClass("wlanconfig", "guidestepintv4");
                    setStepClass("sysconfig", "guidestepintv4");
                    setStepClass("cfgdone", "guidestepintv4");

                    showStep("wlanconfig");
                    showStep("sysconfig");
                    showStep("cfgdone");
                }
                else
                {
                    $("#selectarrow").addClass("guidestep1of3");
                    //setStepClass("ontauth", "guidestepintv3");
                    setStepClass("wancfg", "guidestepintv3");
                    setStepClass("cfgdone", "guidestepintv3");
                    showStep("wancfg");
                }
				wifiPara.id = "guidewancfg";
				wifiPara.name = "../../html/bbsp/wan/wan.asp?cfgguide=1";
			}
			
			showStep("ontauth");
			setOntAuthPage();
		}
	}
	
	setDisplay("selectarrow", 1);
    if (ProductType == '2')
    {
        showStep("wancfg");
        setOntAuthPage();
        wifiForm = new webSubmitForm();
    }
    else
    {
        showStep("cfgdone");
        timer.push(setInterval("adjustParentHeight();", 200));
		wifiForm = new webSubmitForm();
    }
}

function onchangestep(val)
{
	var id = val.id;
	if(("" != curChangeMode && 0 != curChangeMode) || 1 == GhnDevFlag)
	{
		if(curChangeMode == 2 || curChangeMode == 3)
		{
			if(id =="guidecmodecfg")
			{
				$("#selectarrow").addClass("guidestep1of2");
				$("#selectarrow").removeClass("guidestep2of2");
			}
			
			if(id == "guidecfgdone")
			{
				$("#selectarrow").addClass("guidestep2of2");
			}
		}
		else
		{
			if(id =="guidecmodecfg")
			{
				$("#selectarrow").addClass("guidertstep");
			}
			if(id == "guidewancfg")
			{
				$("#selectarrow").removeClass("guidertstep");
				$("#selectarrow").addClass("guidestep2of3");
				$("#selectarrow").removeClass("guidestep3of3rt");
			}
			
			if(id == "guidecfgdone")
			{
				$("#selectarrow").addClass("guidestep3of3rt");
			}
		}
	}
	else if(1 == smartlanfeature || (3 == CurrentUpMode && 1 == IsSupportpon2lan))
	{		
		$("#selectarrow").removeClass("guidestep1of2");
		$("#selectarrow").removeClass("guidestep2of2");
		if(id == "guidewancfg")
		{
			$("#selectarrow").addClass("guidestep1of2");
		}
		else if(id == "guidecfgdone")
		{
			val.name ="/html/ssmp/cfgguide/userguidecfgdone.asp";
			$("#selectarrow").addClass("guidestep2of2");
		}
	}
	else
	{
		if (ifNoWanStep())
		{
			$("#selectarrow").removeClass("guidestep1of2");
			$("#selectarrow").removeClass("guidestep2of2");
			if(id == "guideontauth")
			{
				$("#selectarrow").addClass("guidestep1of2");
			}
			else if(id == "guidecfgdone")
			{
				$("#selectarrow").addClass("guidestep2of2");
			}
		}
		else
		{
            if (ProductType == '2')
            {
                $("#selectarrow").removeClass("guidestep1of4");
                $("#selectarrow").removeClass("guidestep2of4");
                $("#selectarrow").removeClass("guidestep3of4");
                $("#selectarrow").removeClass("guidestep4of4");

                if(id == "guidewancfg")
                {
                    $("#selectarrow").addClass("guidestep1of4");
                }

                else if(id == "guidewlanconfig")
                {
                    $("#selectarrow").addClass("guidestep2of4");
                }
                else if(id == "guidesyscfg")
                {
                    $("#selectarrow").addClass("guidestep3of4");
                }
                else if(id == "guidecfgdone")
                {
                    $("#selectarrow").addClass("guidestep4of4");
                }
            }
            else
            {
                $("#selectarrow").removeClass("guidestep1of3");
                $("#selectarrow").removeClass("guidestep2of3");
                $("#selectarrow").removeClass("guidestep3of3");
                if(id == "guideontauth")
                {
                    $("#selectarrow").addClass("guidestep1of3");
                }
                else if(id == "guidewancfg")
                {
                    $("#selectarrow").addClass("guidestep2of3");
                }
                else if(id == "guidecfgdone")
                {
                    $("#selectarrow").addClass("guidestep3of3");
                }
            }
        }
    }
	$("#framepageContent").css("height", "300px");
	if(('1' == smartlanfeature || (3 == CurrentUpMode && 1 == IsSupportpon2lan))&& val.name.indexOf("guidebssinfo.asp") != -1){
		val.name = "/html/ssmp/cfgguide/userguidecfgdone.asp";
	}
	
	document.getElementById("frameContent").src = val.name;
	timer.push(setInterval("adjustParentHeight();", 200));
}

function adjustParentHeight()
{
	adjustFrameHeight("framepageContent", "frameContent", 90, 200);
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
			else  if ('ORANGEMT' !== CfgMode.toUpperCase())
			{
				document.write('<div id="ProductName">' + ProductName + '</div>');
			}
			</script>
			<script>
			if(true == logo_singtel)
			{
				if(TypeWord_com == "COMMON")
				{
					document.write('<div id="guideframehead"><span style="" BindText="s2012SINGTELHS"></span></div>');
				}
				else
				{
					document.write('<div id="guideframehead"><span style="" BindText="s2012SINGTEL"></span></div>');
				}
			}
			else
			{
				if(smartlanfeature == 1 || (3 == CurrentUpMode && 1 == IsSupportpon2lan))
				{	
					if(("" != curChangeMode && 0 != curChangeMode) || 1 == GhnDevFlag)
					{
						document.write('<div id="guideframehead"><span style="" BindText="s2012aplan"></span></div>');
					}
					else if(1 == IsSmartDev)
					{
						document.write('<div id="guideframehead"><span style="" BindText="s2012lan"></span></div>');
					}
					else{
						document.write('<div id="guideframehead"><span style="" BindText="s2012aplan"></span></div>');
					}
				}
				else
				{					
					if(("" != curChangeMode && 0 != curChangeMode) || 1 == GhnDevFlag)
					{
						document.write('<div id="guideframehead"><span style="" BindText="s2012aplan"></span></div>');
					}
					else
					{
                        if (ProductType == '2')
                        {
                            document.write('<div id="guideframehead"><span style="" BindText="s2012_xd"></span></div>');
                        }
                        else
                        {
                            document.write('<div id="guideframehead"><span style="" BindText="s2012"></span></div>');
                        }
					}
				}

			}
			</script>
			<div id="guidestepsinfo" class="guidestepinfo">
				<div id="guidestepstitle">
                <script>
                    if (ProductType == '2')
                    {
                        document.write('<span id="spanwancfg" class="" style="display:none;" BindText="s2014"></span>');
                        document.write('<span id="spanwlanconfig" class="" style="display:none;" BindText="s2017"></span>');
                        document.write('<span id="spansysconfig" class="" style="display:none;" BindText="s2018"></span>');
                        document.write('<span id="spancfgdone" class="" style="display:none;" BindText="s2015"></span>');
                    }
                    else
                    {
                        document.write('<span id="spanontauth" class="" style="display:none;" BindText="s2013"></span>');
                        document.write('<span id="spancmodecfg" class="" style="display:none;" BindText="s2038"></span>');
                        document.write('<span id="spanwancfg" class="" style="display:none;" BindText="s2014"></span>');
                        document.write('<span id="spancfgdone" class="" style="display:none;" BindText="s2015"></span>');
                    }
                </script>
				</div>
				<div id="guidestepsico">
                    <script>
                        if (ProductType == '2')
                        {
                            document.write('<img id="icowancfg" class="" style="display:none;" name="/html/bbsp/wan/wan.asp?cfgguide=1" src="../images/configwan.jpg" />');
                            document.write('<img id="icowlanconfig" class="" style="display:none;" name="../../html/amp/wlanbasic/guidewificfg.asp" src="../images/configwlan.jpg" />');
                            document.write('<img id="icosysconfig" class="" style="display:none;" name="guidesystemcfg.asp" src="../images/syscfg.jpg" />');
                            document.write('<img id="icocfgdone" class="" style="display:none;" name="guidebssinfo.asp" src="../images/configdone.jpg" />');
                        }
                        else
                        {
                            document.write('<img id="icoontauth" class="" style="display:none;" name="" src="" />');
                            document.write('<img id="icocmode" class="" style="display:none;" name="../../html/ssmp/modechange/modechange_aisap.asp?cfgguide=1" src="../images/cmode.png">');
                            document.write('<img id="icowancfg" class="" style="display:none;" name="../../html/bbsp/wan/wan.asp?cfgguide=1" src="../images/configwan.jpg" />');
                            document.write('<img id="icocfgdone" class="" style="display:none;" name="guidebssinfo.asp" src="../images/configdone.jpg" />');
                        }
                    </script>
				</div>
			</div>
			<script type="text/javascript">
                if (ProductType != '2')
                {
                    if (true == logo_singtel)
                    {
                        document.getElementById("icoontauth").src= "../images/syscfgnowifi.jpg";
                    }
                    else
                    {
                        document.getElementById("icoontauth").src= "../images/syscfg.jpg";
                    }
                }
			</script>
			<div id="selectarrow" style="display:none;"><img id="arrowimg" src="../images/guidearrow.jpg"></div>
		</div>
	</div>

	<div id="greenline"></div>

	<div id="framepageContent">
		<iframe id="frameContent" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" src=""></iframe>
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
				else if ((DAUMFEATURE == 1) && (DAUMLOGO == 1))
				{
					$("#brandlog_daum_dodo").css("display", "block");
				}
				else if ((DAUMFEATURE == 1) && (DAUMLOGO == 2))
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

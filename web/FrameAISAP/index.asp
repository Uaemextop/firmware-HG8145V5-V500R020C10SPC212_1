<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
<meta http-equiv="Pragma" content="no-cache" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>" rel="stylesheet" type="text/css" />
<link href="/Cuscss/<%HW_WEB_GetCusSource(index.css);%>" rel="stylesheet" type="text/css" />
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript" ></script>
<script src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>" language="JavaScript"></script>
<script src="/Cusjs/<%HW_WEB_CleanCache_Resource(frame.asp);%>" type="text/javascript"></script>
<link rel="stylesheet"  href='/resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="JavaScript" src="/resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='/Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>

<script language="javascript" type="text/javascript">

</script>

<script language="JavaScript" type="text/javascript">
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var ProductType = '<%HW_WEB_GetProductType();%>';
var IsSupportWifi = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var UserName = '<%HW_WEB_GetCurUserName();%>';
var ConfigFlag = '<%HW_WEB_GetGuideFlag();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var sysUserType = '0';
var IsModifiedPwd = '<%HW_WEB_GetWebUserMdFlag();%>';
var flagTips = true;
var timeout = null;
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var mngttype = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>';
var logo_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var telmexwififeature = '<%HW_WEB_GetFeatureSupport(FT_PRODUCT_TELMEX);%>';
var mngtpccwtype = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_PCCW);%>';
var MenuModeVDF = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_PTVDF);%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var IsSmartDev = "<%HW_WEB_GetFeatureSupport(HW_OSGI_FT_BUNDLEINFOWEB);%>";
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var TypeWord_com = '<%HW_WEB_GetTypeWord();%>';
var smartlanfeature = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_LAN_UPPORT);%>';
document.title = ProductName;
var apcmodefeature = '<%HW_WEB_GetFeatureSupport(FT_SSMP_AP_OPERATION_SWITCH);%>';
var GhnDevFlag = '<%HW_WEB_GetFeatureSupport(FT_SSMP_GHNAP_MNGT);%>';
var curChangeMode = '<%HW_WEB_GetAPChangeModeValue();%>'; 
var apghnfeature = '<%HW_WEB_GetFeatureSupport(FT_SSMP_GHNAP_MNGT);%>';
var videomodefeature = '<%HW_WEB_GetFeatureSupport(HW_AMP_FT_VIDEO_MODE);%>';
var fVideoCoverEnable = '<%HW_WEB_GetVedioCoverEnable();%>';
var DirectGuideFlag = '<%HW_WEB_GetFeatureSupport(FT_CHANGE_GUIDE_LEVEL);%>';
var UnSupportGuide = '<%HW_WEB_GetFeatureSupport(FT_UDO_XGPON_AGUIDE);%>';
var menuJsonData;
var UpgradeFlag = 0;  //0--normal, 1--updating, 2--diagnosing
var E8CAPFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_E8CAP_SWITCH);%>';
var VideoFlag = '<%HW_WEB_GetVideoChangeFlag();%>';
var CurrentUpMode = '<%HW_WEB_GetUpMode();%>';
var IsSupportpon2lan = '<%HW_WEB_GetFeatureSupport(FT_PON_UPPORT_CONFIG);%>'; 
var autoadapt = '<%HW_WEB_GetFeatureSupport(FT_SSMP_AUTO_ADAPT);%>';
var adaptResult = '<%HW_WEB_GetCModeAdaptValue();%>';

var aprepeater = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_BbspConfig.UpLinkStatus);%>';
var aprepEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_FeatureList.BBSPCustomization.AutoSelectSlaveApUpPort);%>';
var IsSmartBord = '<%HW_WEB_GetFeatureSupport(FT_SMART_BOARD);%>';
var COMMONV5CMODE = '<%HW_WEB_GetFeatureSupport(BBSP_FT_WAN_COMMONV5);%>';
var AdaptExist = '<%HW_WEB_IsSupportAd();%>';
var DAUMLOGO = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_Web.X_WebLogo);%>';
var DAUMFEATURE = "<%HW_WEB_GetFeatureSupport(FT_PRODUCT_DAUM);%>";
var IsSupportPortal = "<%HW_WEB_GetFeatureSupport(FT_WEB_REDIRECT_PORTALWIZARD);%>";
var portalAPType ='<%HW_WEB_GetApMode();%>';
var trueAdapt = '<%HW_WEB_GetFeatureSupport(FT_TRUE_ADAPT);%>';
var HostingQRcodeEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AppRemoteManage.HostingQRcodeEnable);%>';  
var IsPTVDFFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var isRTOnlyMode='<%HW_WEB_GetFeatureSupport(FT_SSMP_AP_MODE_ROUTER_ONLY);%>';
var userdevinfonum = "";
var IsSupportBridgeWan = "<%HW_WEB_GetFeatureSupport(FT_WAN_SUPPORT_BRIDGE_INTERNET);%>";
var IsSupportMesh = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MESH);%>";
var meshMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_Mesh.MeshMode);%>';  
var IsRomdt = "<%HW_WEB_GetFeatureSupport(SSMP_FT_REMOVE_USERGUIDE);%>"; 
var TableClass = new stTableClass("width_per30", "width_per70", "ltr");
var MainUpportModeArray = [];
var flagChangeMode = false;
var aisAPDefaultPonFeature = '<%HW_WEB_GetFeatureSupport(FT_AISAP_DEFAULT_PONUPPORT);%>';
var thisLv3Id = '';
var thisLv3Clicked = false;
var thisLv3Id = '';
var thisLv3Clicked = false;
var cpeReuseStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_AIS_reuseCPE_status);%>';

function stConfigPort(domain,X_HW_MainUpPort)
{
	this.domain = domain;
	this.X_HW_MainUpPort = X_HW_MainUpPort;
}

var PortConfigInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo,X_HW_MainUpPort,stConfigPort);%>;
var PortConfigInfo = PortConfigInfos[0];
var OriUpPortMode ='<%HW_WEB_GetOriUpPortMode();%>';

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
if(autoadapt == 1)
{
	curChangeMode = 4;
}

$.ajax({
    type : "POST",
    async : false,
    cache : false,
    url : "asp/getMenuArray.asp",
    success : function(data) {
         menuJsonData  = eval(data);
    }
});

/*re-direct to user-guide page when user login for the first time*/
if (CfgMode.toUpperCase() != 'AISAP' && 'PTVDF2' != CfgMode.toUpperCase() && 'PTVDF2WIFI_PWD' != CfgMode.toUpperCase() && (IsSupportPortal != 1 || (portalAPType == 1 && IsSupportPortal == 1)) && (IsSupportBridgeWan == 0))
{
    if(1 == DirectGuideFlag && ((!parseInt(ConfigFlag.split("#")[0], 10) && curUserType == sysUserType) || ((!parseInt(ConfigFlag.split("#")[1], 10) && curUserType == 1))))
    {
        if(1 != GhnDevFlag &&IsRomdt != 1)
        {
            window.location="CustomApp/userguideframe.asp";
        }
    }
    
    if(((curUserType == sysUserType && 0 == DirectGuideFlag) && !parseInt(ConfigFlag.split("#")[0], 10)))
    {
        if(1 == smartlanfeature || apcmodefeature == 1 || (3 == CurrentUpMode && 1 == IsSupportpon2lan))
        {   
            if((apcmodefeature == 0 && meshMode == 3) || GhnDevFlag == 1 || 1 == UnSupportGuide)
            {
                ;
            }else{
                window.location="/CustomApp/adminguideframe.asp";
            }
        }
        else
        {
            if((apcmodefeature == 0 && meshMode == 3) || GhnDevFlag == 1)
            {
                ;
            }else
            {
                if (ProductType == '2')
                {
                    window.location = "/CustomApp/adminguideframe.asp";
                }
                else
                {
                    window.location="/html/ssmp/cfgguide/guideindex.asp";
                }
            }
        }
    }
    else if(curUserType == sptUserType
        && !parseInt(ConfigFlag.split("#")[1], 10)
        && 1 != parseInt(mngtpccwtype, 10))
    {   
        if(1 != GhnDevFlag&& IsRomdt != 1)
        {
            window.location="CustomApp/userguideframe.asp";
        }
    }
}

function showUpportPage(flag)
{
    if ((document.getElementById("4") != null) && (document.getElementById("4").checked == true) && (flag == true)) {
        showconfirm();
        return;
    }
    document.getElementById("zhezhao").style.display = "none";
    document.getElementById("showcmode1").style.display = "none";
    var toast = document.getElementById("toast");
    var cover = document.getElementById("cover");
    cover.style.display = "block";
    toast.style.display = "block";
    toast.style.position = "fixed";
    $(function() {
        function boxAuto()
        {
            var dom = $("#toast");
            var w = dom.innerWidth();
            var h = dom.innerHeight();
            var t = ($(window).height() - h) / 2;
            var l = ($(window).width() - w) / 2;
            dom.css("top", t);
            dom.css("left", l);
        }
        boxAuto();
        $(window).resize(function() {
            boxAuto();
        })
    });
    flagChangeMode = flag;
    if (portalAPType == 1) {
        if (flagChangeMode == true) {
            MainUpportModeArray = ['Optical', 'LAN4'];
        } else {
            MainUpportModeArray = ['LAN1', 'LAN2', 'LAN3', 'LAN4'];
        }
    } else {
        if ((document.getElementById("4") != null) && (document.getElementById("4").checked == true) && (flagChangeMode == true)) {
            MainUpportModeArray = ['LAN1', 'LAN2', 'LAN3', 'LAN4'];
        } else {
            MainUpportModeArray = ['Optical', 'LAN4'];
        }
    }
    CreateMainUpportSelect("X_HW_MainUpPort", MainUpportModeArray);
    setDisable('X_HW_MainUpPort', 0);
    if ((document.getElementById("4") != null) && (document.getElementById("4").checked == true) && (PortConfigInfo.X_HW_MainUpPort == 'Optical')) {
        setSelect("X_HW_MainUpPort", 'LAN4');
    } else {
        setSelect("X_HW_MainUpPort", PortConfigInfo.X_HW_MainUpPort);
    }
}

function showCmodePage() 
{   
    if (isRTOnlyMode == 1) {
		 $("input[name='CMode'][value='wifi']").attr("disabled",true);
		 $("input[name='CMode'][value='autoconsult']").attr("disabled",true);
	 }
    document.getElementById("zhezhao").style.display ="block";
    document.getElementById("showcmode").style.display ="none";
    document.getElementById("showcmode1").style.display ="block";   
}
function hideCmodePage() 
{
    document.getElementById("zhezhao").style.display ='none';
    document.getElementById("showcmode").style.display ='none';
    document.getElementById("showcmode1").style.display ='none';
    document.getElementById("toast").style.display ='none';
    document.getElementById("cover").style.display ='none';
    DeleteMainUpportSelect(MainUpportModeArray);
    document.getElementById("1").disabled=false;
    document.getElementById("2").disabled=false;
    document.getElementById("3").disabled=false;
    if (document.getElementById("4") != null) {
        document.getElementById("4").disabled=false;
    }
    document.getElementById("MdyPwdApply").style.backgroundColor = "#bbbbbb";
    document.getElementById("MdyPwdApply").style.borderColor = "#bbbbbb";
	document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
    document.getElementById("MdyPwdApply1").style.borderColor = "#bbbbbb";
	document.getElementById("MdyPwdApply1").disabled=true;
    if(meshMode=='0')
    {
        if (document.getElementById("7")) document.getElementById("7").checked=true;
    }
    else if(meshMode=='1')
    {
        document.getElementById("5").checked=true;
    }
	else if(meshMode=='2')
    {
        document.getElementById("8").checked=true;
    }
	else if(meshMode=='3')
    {
        document.getElementById("4").checked=true;
    }
}

function GetIdByUrl(Type, BaseUrl)
{   
    var NewId = Type+"_";
    var MarkEnd="";
    try{
        var lastindex = BaseUrl.lastIndexOf('/');
        if( lastindex > -1 )
        {
            NewId += BaseUrl.substring(lastindex+1, BaseUrl.length);
        }
        else
        {
            NewId += BaseUrl;
        }
        
        if(NewId.indexOf("?") > -1)
        {
            MarkEnd = NewId.split("?")[1];
        }
        
        NewId = NewId.split(".")[0]+MarkEnd;
        
    }catch(e){
        NewId += Math.round(Math.random() * 10000);
    }
    return NewId;
}

function DisplayDownAPP()
{
    if (HostingQRcodeEnable == "1")
    {
        $("#guidespacethree").css('display', 'block');
        $("#AppDiv").css('display', 'block');
    }
    else
    {
        $("#guidespacethree").css('display', 'none');
        $("#AppDiv").css('display', 'none');
    }
}

function IsModifedFun(){

	if(IsModifiedPwd == 0 && curUserType != sysUserType)
	{
		$("#modifyPwdBox").fadeIn(300);	
	} 
}

function loadframe()
{
     if (isRTOnlyMode == 1) {
	     document.getElementById("gcmexplainbridge").innerHTML="Only support router mode";
		 document.getElementById("autoconsultexplain").innerHTML="Only support router mode";
	 }
	if ("1" == HostingQRcodeEnable)
    {
        $("#AppDiv").css("display", "block");
        $("#guidespacetwo").css("display", "block");
    }
	else
	{
		$("#AppDiv").css("display", "none");
		$("#guidespacetwo").css("display", "none");
	}	
    
	if (IsSupportBridgeWan == 0)
	{
	    if((parseInt(mngttype, 10) == 1 || parseInt(mngtpccwtype, 10) == 1 ) && curUserType != sysUserType)
	    {
	        $("#configguide").css("display", "none");
	        $("#guidespaceone").css("display", "none");
	    }
	    else
	    {
	        $("#configguide").css("display", "block");
	        $("#guidespaceone").css("display", "block");
	    }
	}

    if(CfgMode.toUpperCase() == 'AISAP') {
        $("#configguide").css("display", "none");
        $("#guidespaceone").css("display", "none");
    }

    if(parseInt(mngttype, 10) != 1)
    {
        if(parseInt(logo_singtel, 10) != 1)
        {
            if (telmexwififeature == 1)
			{
			    var btn=document.getElementById('headerbrandlog');
				btn.onclick=function(){window.location.href="http://www.telmex.com";};
				$("#headerbrandlog").css("background", "url(../../../images/HeadertelmexLog.jpg)");
		    	$("#headerbrandlog").css("display", "block");   
				$("#headerProductName").css("color","#56b2f8");
			}
            else if ('TELECENTRO' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_tel").css("display", "block"); 
			}
			else if ('PLDT2' == CfgMode.toUpperCase() || 'PLDT' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_pldt").css("display", "block"); 
			}
			else if ('OMANONT' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_oman").css("display", "block");
			}
			else if ('MAROCTELECOM' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_maroctelecom").css("display", "block");
			}
			else if ('ORANGEMT' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_orangemt").css("display", "block");
			}
			else if((DAUMFEATURE == 1) && (DAUMLOGO == 1))
			{
				$("#headerbrandlog_daum_dodo").css("display", "block");
			}
			else if((DAUMFEATURE == 1) && (DAUMLOGO == 2))
			{
				$("#headerbrandlog_daum_iprimus").css("display", "block");
			}
			else if ('DNZTELECOM2WIFI' == CfgMode.toUpperCase())
			{
				$("#headerbrandlog_dnztelecom").css("display", "block");
				$("#headerbg").css("background-image", "url()");
				$("#headerProductName").css("color","#00ad65");	
				$("#username").css("color","#666666");
				$("#configguidetext").css("color","#666666");
				$("#headerLogoutText").css("color","#666666");
			}
			else
			{
				$("#headerbrandlog").css("display", "block"); 
			}	  
        }
        else
        {   
            if(TypeWord_com == "COMMON")
            {
                 $("#headerbrandlogSingtel").css("background-image", "url()");
            } 
            $("#headerbrandlogSingtel").css("display", "block");
        }       
    }

	if('DTURKCELL2WIFI' == CfgMode.toUpperCase()){
		if(flagTips)
		{
			IsModifedFun();
			flagTips = false;
		}
		
	}
	
	if (telmexwififeature == 1)
	{
		$("#headerbg").css("background-image", "url()");
		$("#headerbrandlog").css("width", "187px");
		$("#HeaderRightMenu").css("color","#56b2f8");
		$("#headerProductName").css("width", "324px");
		$("#username").css("color","#56b2f8");
		$("#configguidetext").css("color","#56b2f8");
		$("#headerLogoutText").css("color","#56b2f8");
	}

	if((1 == videomodefeature) || (1 == VideoFlag))
	{
    	$("#VideoMode").css("display", "block");
        $("#guidevideospace").css("display", "block");
		setCheck('ckVideoSwitch', fVideoCoverEnable);
	}
	else
	{
		$("#VideoMode").css("display", "none");
        $("#guidevideospace").css("display", "none");
	}
    if(apghnfeature == 1)
    {
        document.getElementById("MdyPwdApply").disabled=true;
        document.getElementById("MdyPwdApply").style.backgroundColor = "#bbbbbb";
        document.getElementById("MdyPwdApply").style.borderColor = "#bbbbbb";       
        $("#AppDiv").css("display", "none");
        $("#cmodeLogout").css("display", "none");
        $("#bssinfo").css("display", "none");
        $("#guidespacetwo").css("display", "none");
        document.getElementById("1").disabled=true;
        document.getElementById("3").disabled=true;
        $("#configguide").css("display", "none");
        $("#guidespaceone").css("display", "none");
        return;
    }
    
    if(IsSupportMesh == 1)
    {
        document.getElementById("MdyPwdApply").disabled=true;
        document.getElementById("MdyPwdApply").style.backgroundColor = "#bbbbbb";
        document.getElementById("MdyPwdApply").style.borderColor = "#bbbbbb";
        document.getElementById("MdyPwdApply1").disabled=true;
        document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
        document.getElementById("MdyPwdApply1").style.borderColor = "#bbbbbb";
        $("#AppDiv").css("display", "none");
        $("#bssinfo").css("display", "none");
        
        if(apcmodefeature == 1)
        {       
            document.getElementById("cmodecontent").style.display="none";
            document.getElementById("aprepcontent").style.display="block";
            $("#cmodeLogout").css("display", "block");
            $("#guidespacetwo").css("display", "block");
            
            if(meshMode=='0' && curUserType == sysUserType)
            {
                document.getElementById("7").disabled=false;
                document.getElementById("7").checked=true;
                document.getElementById("autopic5").src="../images/router2.png";
                document.getElementById("autocontent").style.color="#8DC63F";
                document.getElementById("gcmexplainbridge").style.display="block";
            }
            else if(meshMode=='1')
            {
                document.getElementById("5").disabled=false;
                document.getElementById("5").checked=true;
                document.getElementById("rtpic5").src="../images/router2.png";
                document.getElementById("rtcontent").style.color="#8DC63F";
                document.getElementById("gcmexplainbridge").style.display="block";
            }
            else if(meshMode=='2')
            {
                document.getElementById("8").disabled=false;
                document.getElementById("8").checked=true;
                document.getElementById("untagrtpic5").src="../images/router2.png";
                document.getElementById("untagrtcontent").style.color="#8DC63F";
                document.getElementById("gcmexplainbridge").style.display="block";
            }
            else if(meshMode=='3' && curUserType == sysUserType)
            {
                document.getElementById("cmexplainrep").style.display="block";
                document.getElementById("wifipic4").src="../images/Ranger2.png";
                document.getElementById("4").disabled=false;
                document.getElementById("4").checked=true;
                document.getElementById("wificontent").style.color="#8DC63F";
            }
        }
        else
        {
            $("#cmodeLogout").css("display", "none");
            $("#guidespacetwo").css("display", "none");
            if(meshMode=='3'){
                if(curUserType == sysUserType)
                {
                    if(0 == DirectGuideFlag)
                    {
                        $("#configguide").css("display", "none");
                        $("#guidespaceone").css("display", "none");
                    }
                }
            }
        }
    }
	
	if(("VDFPTAP"==CfgMode) || (CfgMode.toUpperCase() == "TRUEAP") || ('SONET_HN8255Ws' == CfgMode) || ('JAPAN_HN8255Ws' == CfgMode))
	{
		$("#cmodeLogout").css("display", "none");
		$("#guidespacetwo").css("display", "none");
	}
	if((AdaptExist == 0 && isRTOnlyMode != 1) || (CfgMode.toUpperCase() == 'CTCTRIAP'))
	{
		document.getElementById('autoconsultguide').style.display = "none";
		document.getElementById('hengline1').style.display = "none";
		$("#showcmode1").css("height", "380px");
	}

	if(trueAdapt == 1)
	{
		$("#cmodeLogout").css("display", "block");
		$("#guidespacetwo").css("display", "block");
	}

    if (IsSupportMesh == 1)
    {
        document.getElementById('autoconsultguide').style.display = "none";
        document.getElementById('hengline1').style.display = "none";
        $("#showcmode1").css("height", "630px");
        if (curUserType != sysUserType)
        {
            document.getElementById('hengline2').style.display = "none";
            try {
                $("#automode").remove();
                $("#wifimode").remove();
                $("#autoconsultguide").remove();
            } catch (e) {}
            document.getElementById('currentmode_div').style.display = "block";
            if (meshMode=='0') {
                document.getElementById('currentmodeid').innerHTML = htmlencode(framedesinfo["mainpage051"]);
            } else if (meshMode=='1') {
                document.getElementById('currentmodeid').innerHTML = htmlencode(framedesinfo["mainpage052"]);
            } else if (meshMode=='2') {
                document.getElementById('currentmodeid').innerHTML = htmlencode(framedesinfo["mainpage053"]);
            } else if (meshMode=='3') {
                document.getElementById('currentmodeid').innerHTML = htmlencode(framedesinfo["mainpage054"]);
            }
        }
    }
}

function goToGuidePage()
{
    if (!ifCanChangeMenu())
    {
        return ;
    }
    
    if(1 == DirectGuideFlag)
    {
        window.location="/CustomApp/userguideframe.asp";
        return;
    }

    if (curUserType == sysUserType && ((1 == smartlanfeature) || (3 == CurrentUpMode && 1 == IsSupportpon2lan)))
    {
        window.location="/CustomApp/adminguideframe.asp";
    }
    else if (curUserType == sysUserType)
    {
        if(1 == apcmodefeature)
        {
            window.location="/CustomApp/adminguideframe.asp";
        }
        else
        {
            if (ProductType == '2')
            {
                window.location = "/CustomApp/adminguideframe.asp";
            }
            else
            {
                window.location="/html/ssmp/cfgguide/guideindex.asp";
            }
        }
    }
    else
    {
        window.location="/CustomApp/userguideframe.asp";
    }
}

function closePwdTips(){
	$("#modifyPwdBox").fadeOut(500);
}

function jumpModifyPwd(){
	var accountUrl = "/html/ssmp/accoutcfg/account.asp"
	closePwdTips();
	onMenuChange1("userconfig",accountUrl);
	
}

function ifCanChangeMenu()
{
    if (UpgradeFlag == 1)
    {
        if(ConfirmEx(framedesinfo["mainpage016"]))
        {
            UpgradeFlag = 0;
            return true;
        }
        else
        {
            return false;
        }
    }
    else if (UpgradeFlag == 2)
    {
        if(ConfirmEx(framedesinfo["mainpage017"]))
        {
            UpgradeFlag = 0;
            return true;
        }
        else
        {
            return false;
        }
    }

    return true;
}

function toggleQRCodeDisplay(flag)
{
    var Type = flag;
    if (flag == 'auto')
    {
        var displayflag = document.getElementById("D2CodeDivInfo").style.display;
        Type = "block" == displayflag ? "none" : "block";
    }
    $('#D2CodeDivInfo').css("display", Type);
}

function adjustParentHeight()
{
    var menuBar = $("#SecondMenuInfo");
    adjustFrameHeight("maincenter", "menuIframe", 280, (menuBar != null ? menuBar.innerHeight() + 100 : null));
}

function CreateMainUpportSelect(list, selectarray)
{
    var select = document.getElementById(list);
    for (var i in selectarray) {
        var opt = document.createElement('option');
        var optShow = selectarray[i];
        var html = document.createTextNode(optShow);
        var selectArrayId = selectarray[i] + "ID"
        opt.value = selectarray[i];
        opt.id = selectArrayId;
        opt.appendChild(html);
        select.appendChild(opt);
    }
}

function DeleteMainUpportSelect(selectarray)
{
    for (var i in selectarray) {
        var selectArrayId = selectarray[i] + "ID"
        var opt = document.getElementById(selectArrayId);
        if (opt != null) {
            opt.parentNode.removeChild(opt);
        }
    }
}

function RemoveOpticalUpportSelect()
{
    var opt = document.getElementById('OpticalId');
    if (opt != null) {
        opt.parentNode.removeChild(opt);
    }
}

function AddOpticalUpportSelect()
{
    var select = document.getElementById('X_HW_MainUpPort');
    var opt = document.createElement('option');
    var optShow = 'Optical';
    var html = document.createTextNode(optShow);
    opt.value = 'Optical';
    opt.id = 'OpticalId';
    opt.appendChild(html);
    select.appendChild(opt);
}

function SubmitUpportConfigForm()
{
    var Form = new webSubmitForm();
    if (ConfirmEx(GetDescFormArrayById(ConfigMainUpportDes, "sCMU003"))) {
        $.ajax({
        type: "POST",
        async: true,
        cache: false,
        url: '/SynchOriUpPortMode.cgi?' + '&RequestFile=/html/ssmp/mainupportcfg/mainupportconfig.asp',
        success: function(data) {}
        });

        var MainUpPort = getSelectVal('X_HW_MainUpPort');
        if (MainUpPort != "Optical") {
            Form.addParameter('x.X_HW_UpPortMode', 3);
        } else {
            Form.addParameter('x.X_HW_UpPortMode', OriUpPortMode);
            Form.addParameter('x.X_HW_UpPortID', 0x102001);
        }
        Form.addParameter('x.X_HW_MainUpPort', MainUpPort);
        if (flagChangeMode) {
            if (($("input[name=CMode]:checked").attr("id")) == '5') {
                meshMode = '1';
            } else if (($("input[name=CMode]:checked").attr("id")) == '7') {
                meshMode = '0';
            } else if (($("input[name=CMode]:checked").attr("id")) == '4') {
                meshMode = '3';
            } else if (($("input[name=CMode]:checked").attr("id")) == '8') {
                meshMode = '2';
            }
            if ((curUserType != sysUserType) && !(meshMode == '1' || meshMode == '2')) {
                return;
            }
            Form.addParameter('y.MeshMode', meshMode);
            Form.addParameter('x.X_HW_Token', HWGetToken());
            Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo&y=InternetGatewayDevice.LANDevice.1.X_HW_Mesh&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp');
        } else {
            Form.addParameter('x.X_HW_Token', HWGetToken());
            Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard' +
                           '&RequestFile=html/ssmp/mainupportcfg/mainupportconfig.asp');
        }
        Form.submit();
        setDisable('btnApply', 1);
        setDisable('cancelValue', 1);
    } else {
        LoadFrame();
    }
}

</script>
</head>
<body onload="loadframe();">
<div id="modifyPwdBox" style="display:none;">
	<div id="passwordTips" class="passwordTips">
		<div id="pwdCloseBtn" class="pwdCloseBtn">
			<a onclick="closePwdTips();"></a>
		</div>
		<div id="pwdContainer" class="pwdContainer">
			<h2>Notice</h2>
			<p>You are currently using the default login password. Please change this password to improve the network security.</p>
		</div>
		<div id="pwdBtn" class="pwdBtn">
			<a onclick="jumpModifyPwd();">Modify Login Password</a>
			<a style="margin-left: 40px;" onclick="closePwdTips();">Missing transition:UserLogin.Skip</a>
		</div>
	</div>
</div>
<div id="indexpage">
<script>
if (telmexwififeature == 1 )
{
	document.write('<div id="headertelmexbg">');
}
else
{
	document.write('<div id="headerbg">');
}
</script>  
        <div id="header">

        <script>
            if (logo_singtel == true)
            {
                document.write('<div id="headerbrandlogSingtel"></div>');               
            }
			else if ('TELECENTRO' == CfgMode.toUpperCase())
			{
				document.write('<div id="headerbrandlog_tel"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('PLDT2' == CfgMode.toUpperCase() || 'PLDT' == CfgMode.toUpperCase())
			{
				document.write('<div id="headerbrandlog_pldt"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('MAROCTELECOM' == CfgMode.toUpperCase())
			{
				document.write('<div id="headerbrandlog_maroctelecom"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('ORANGEMT' == CfgMode.toUpperCase())
			{
				document.write('<div style="margin: 0 auto">' + '<div style="height: 8px"></div>'+'<img id="brandlog_orangemt" src="images/hwlogo_orangemt.gif" width="53px"></img>' + '<div  id="headerProductNameOrg">' + ProductName + '</div>'+'</div>');
			}
			else if ((DAUMFEATURE == 1) && (DAUMLOGO == 1))
			{
				document.write('<div id="headerbrandlog_daum_dodo"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ((DAUMFEATURE == 1) && (DAUMLOGO == 2))
			{
				document.write('<div id="headerbrandlog_daum_iprimus"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('DNZTELECOM2WIFI' == CfgMode.toUpperCase())
			{
				document.write('<div id="headerbrandlog_dnztelecom"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('TM' == CfgMode.toUpperCase())
			{
				document.write('<img id="headerbrandlog_tm" src="images/hwlogo_tm.gif"></img>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
			else if ('OMANONT' == CfgMode.toUpperCase())
			{
				document.write('<div id="headerbrandlog_oman"></div>');
				document.write('<div id="headerProductName">' + ProductName + '</div>');
			}
            else
            {
                document.write('<div id="headerbrandlog"></div>');
                document.write('<div id="headerProductName">' + ProductName + '</div>');
            }
        </script>
            <div id="HeaderRightMenu">
                <div id="headerLogout">
                    <span id="headerLogoutText" class="HeaderSpanTextGuide" onclick="logoutfunc();"  BindText="mainpage009"></span>

                </div>
                <div id="headeruser">
                    <span id="username" class="HeaderSpanTextGuide" ></span>
                </div>

				<div id="guidespaceone" class="guidespace">
					<div class="guidespacebar"></div>
				</div>
				<div id="configguide">
					<span id="configguidetext" class="HeaderSpanTextGuide" onclick="goToGuidePage();" BindText="mainpage008"></span>
				</div>

                <div id="guidespacetwo" class="guidespace">
                    <div class="guidespacebar"></div>               
                </div>
                <div id="cmodeLogout" >
                    <span id="modechangeText" class="HeaderSpanTextGuide" onclick="showCmodePage();"  BindText="mainpage019"></span>
                </div>
				<div id="guidevideospace" style="display:none;" class="guidespace"><div class="guidespacebar"></div></div>
				<script language="JavaScript" type="text/javascript">
				function setVideoSwitch()
				{
					var isVideo = getCheckVal('ckVideoSwitch');
	
    				if(ConfirmEx("设置模式切换，需重启，是否执行？"))
					{
                         $.ajax({
                            type : "POST",
                            async : true,
                            cache : false,
                            data : "w.VideoCoverEnable=" + isVideo + "&x.X_HW_Token=" + HWGetToken(),
                            url : 'set.cgi?w=InternetGatewayDevice.X_HW_VideoCoverService',
            				success : function(data) {

                                 }
                         });
                     }
                     else
                     {
					 	var lastvideo = (isVideo == 0)? 1:0;
                        setCheck('ckVideoSwitch', lastvideo);
                     }
                 }

				</script>

			<div id="VideoMode" title="视频通模式，可解决家庭无网线开IPTV业务场景，可设置为普通模式" style="display:none;float:left;margin-top:16px;margin-right:5px;"><input type="checkbox" name="ckVideoSwitch" id="ckVideoSwitch" style="line-height:30px;vertical-align:middle;" onClick='setVideoSwitch();' ><span class="HeaderSpanTextGuide" >视频通</span></input></div>
			<div><input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>"></div>
                <div id="cmodeLogout" >
                    <span id="modechangeText" class="HeaderSpanTextGuide" onclick="showCmodePage();"  BindText="mainpage019"></span>
                </div>
                <div id="guidespacethree" class="guidespace" style="display: none">
                    <div class="guidespacebar"></div>               
                </div>
                <div id="AppDiv" >
                    <div id="MaPoniterText" >
                        <span class="HeaderSpanTextGuide" BindText="mainpage013"></span>
                    </div>
                    <div id="MaPoniterIcon" ></div>
                    <div id="D2CodeDivInfo">
                        <div id="FirstLineIcon">
                            <div id="phoneicon"><img src="images/D2CodePhone.jpg"></div>
                            <div id="phonetext"><span BindText="mainpage007"></span></div>
                        </div>
                        <div id="D2CodeTop">
                            <div class="D2CodeCornerLeft"></div>
                            <div class="D2CodeCornerRigth"></div>
                        </div>
                        <div id="D2CodeIcon"></div>
                        <div id="D2CodeBottom">
                            <div class="D2CodeCornerLeft"></div>
                            <div class="D2CodeCornerRigth"></div>
                        </div>
                    </div>
                </div>
                <script>
                    if(true == logo_singtel)
                    {
                        document.write('<div id="headerRightProductName"><span class="HeaderSpanProduct">' + ProductName + '</span></div>');
                    }
                </script>
            </div>
        </div>
    </div>
        <div id="MenuInfoWrapper" class="MenuInfoWrapper">
            <div id="MenuInfo" class="MenuInfo"></div>
        </div>
        <div id="maincenter">
            <div id="menuWrapper" class="Menuhide" style="height:100%;width:190px;background-color:#fff;float:left;margin-right:20px;">
                <div id="SecondMenuInfo" class="Menuhide"></div>
            </div>
            <div id="content">
                <iframe id="menuIframe" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" class="AspWidth" scrolling="no" overflow="hidden"></iframe>
            </div> 
        </div>

        <div align="center" id="copyright" class="copyright">
            <div class="menu-footer">
                <a href="http://www.ais.co.th/fibre/support.html" target="_blank">FAQ</a>
                <a href="http://www.ais.co.th/fibre/contact.html" target="_blank">AIS Call Center 1175</a>
            </div>
            <p class="text-footer">© 2019 ADVANCED INFO SERVICE PLC. ALL RIGHTS RESERVED. <br> This site is best viewed using Internet Explorer 9, Chrome, Safari and browser later.</p>
        </div>

    <div id="fresh">
        <iframe frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="refresh.asp"></iframe>
    </div>
</div>
<div id="zhezhao"></div>
<div id="showcmode" style="display:none;">
    <h2 id="cmodetitle" > 
        <div id="cmtitlecontent"  BindText="mainpage019"></div>
        <div id="cmodeclose" ><img id="cmimageclose" src="../images/xx.png" onclick="hideCmodePage();"></div>
    </h2>
    
    <div id="cmodecontent" style="display:none;">

        <div id="apmode">
            <div id="apradiodiv" ><input id="2" type="radio" name="CMode" value="lan" /></div>
            <div id="cmimagediv" ><img id="appic" src="../images/apmode1.png"></div>
            <div id="apmodecontent" >
                <h2 id="upmodenames"><span id="apcontent" class="Smartinforight"  BindText="mainpage021" ></span></h2>
                <div id="cmexplain" BindText="mainpage025"></div>
            </div>
            <p id="hengline" ></p>
            <div class="clear"></div>
        </div>

        <div id="wifimode1" >
            <div id="wifiradiodiv"><input id="3" type="radio" name="CMode" value="wifi" /></div>
            <div id="cmimagediv"><img id="wifipic" src="../images/Ranger1.png"></div>
            <div id="wifimodecontent">
                <h2 id="upmodenames"><span id="wificontent1" class="Smartinforight" BindText="mainpage022"></span></h2>
                <div id="cmexplain" BindText="mainpage026"></div>
            </div>
            <p id="hengline"></p>
            <div class="clear"></div>
        </div>

        <div id="rtmode" >
            <div id="rtradiodiv"><input id="1" type="radio" name="CMode" value="route" /></div>
            <div id="cmimagediv" class="cmpicdiv1" ><img id="rtpic" src="../images/router1.png"></div>
            <div id="rtmodecontent">
                <h2 id="upmodenames"><span id="rtcontent1" class="Smartinforight" BindText="mainpage020"></span></h2>
                <div id="cmexplain" BindText="mainpage027"></div>
            </div>
            <div class="clear"></div>
        </div>      
    </div>  
    <br>
    <div id="cmbutton" >
        <input type="button" id="MdyPwdcancel" class="CancleButtonCss buttonwidth_100px" onclick="hideCmodePage();" BindText="mainpage023" />
        <input type="button" id="MdyPwdApply" class="ApplyButtoncss buttonwidth_100px" onclick="showconfirm();" BindText="mainpage024" />   
        
    </div>
    
    <div class="alert_box" id="alert_box" style="display:none;">
        <div style="float:left;"><img id="reboot_img" src="../../../images/icon-thinking.gif" /></div>
        <div class="reboot_title_fir" style="float:left;margin-left:10px;" BindText="mainpage040"></div>
    </div>  
</div>

<div id="showcmode1" style="display:none;position:flex;top:50%;height:480px;margin-top:-315px;width:700px;left:50%;margin-left:-350px;background-color:white; z-index:1002;">
    <h2 id="cmodetitle1" style="width:100%;height:35px;background-color:#8DC63F;margin-top:0px;font-size:16px;font-family: 微软雅黑;color:#fff;"> 
        <div id="cmtitlecontent"  BindText="mainpage019"></div>
        <div id="cmodeclose" ><img id="cmimageclose" src="../images/xx.png" onclick="hideCmodePage();"></div>
    </h2>
    <div id="currentmode_div" style="display:none;margin-right:14.5%">
        <p class="p_left">Current Mode:</p>
        <p class="p_right" id="currentmodeid"></p>
    </div>
    <div id="aprepcontent" style="margin-top:4%;margin-left:2.5%;text-align:left;display:none;">
        <!-- Auto Mode -->
        <div id="automode" >
            <div id="autoradiodiv" style="margin-top:30px;float:left;"><input id="7" type="radio" name="CMode" value="auto" /></div>
            <div id="cmimagediv" class="cmpicdiv1" ><img id="autopic5" src="../images/apmode1.png"></div>
            <div id="automodecontent">
                <h2 id="upmodenames"><span id="autocontent" class="Smartinforight" BindText="mainpage051"></span></h2>
                <div id="cmexplain" BindText="mainpage044"></div>
            </div>
            <p id="hengline"></p>
            <div class="clear"></div>
        </div>
        <!-- Tagged 路由模式 -->
        <div id="rtmode" >
            <div id="rtradiodiv" style="margin-top:30px;float:left;"><input id="5" type="radio" name="CMode" value="route" /></div>
            <div id="cmimagediv" class="cmpicdiv1" ><img id="rtpic5" src="../images/router1.png"></div>
            <div id="rtmodecontent">
                <h2 id="upmodenames"><span id="rtcontent" class="Smartinfo464right" BindText="mainpage052"></span></h2>
                <script type="text/javascript">
                    if (aisAPDefaultPonFeature == 1) {
                        document.write("\<div id=\"cmexplain\" BindText=\"mainpage057\"\>\<\/div\>");
                    } else {
                        document.write("\<div id=\"cmexplain\" BindText=\"mainpage055\"\>\<\/div\>");
                    }
                </script>
            </div>
            <p id="hengline"></p>
            <div class="clear"></div>
        </div>
        <!-- Untagged 路由模式 -->
        <div id="untagrtmode" >
            <div id="untagrtradiodiv" style="margin-top:30px;float:left;"><input id="8" type="radio" name="CMode" value="route" /></div>
            <div id="cmimagediv" class="cmpicdiv1" ><img id="untagrtpic5" src="../images/router1.png"></div>
            <div id="untagrtmodecontent">
                <h2 id="upmodenames"><span id="untagrtcontent" class="Smartinforight" BindText="mainpage053"></span></h2>
                <script type="text/javascript">
                    if (aisAPDefaultPonFeature == 1) {
                        document.write("\<div id=\"cmexplain\" BindText=\"mainpage058\"\>\<\/div\>");
                    } else {
                        document.write("\<div id=\"cmexplain\" BindText=\"mainpage056\"\>\<\/div\>");
                    }
                </script>
            </div>
            <p id="hengline2"></p>
            <div class="clear"></div>
        </div>
		<!-- 桥接模式 -->
        <div id="wifimode" >
            <div id="wifiradiodiv" style="margin-top:30px;float:left;"><input id="4" type="radio" name="CMode" value="wifi" /></div>
            <div id="cmimagediv"><img id="wifipic4" src="../images/Ranger1.png"></div>
            <div id="wifimodecontent">
                <h2 id="upmodenames"><span id="wificontent" class="Smartinforight" BindText="mainpage054"></span></h2>
                <div id="cmexplainrep" style="display:none;margin-top:5px;" BindText="mainpage026"></div>
                <div id="gcmexplainap" style="display:none;margin-top:5px;" BindText="mainpage025"></div>
                <div id="gcmexplainbridge" style="margin-top:-5px;width:600px;display:none;" BindText="mainpage042"></div>
            </div>
			<p id="hengline1" style="width:98%;height:1px;background-color:#CCCCCC;margin-top:20px;float:left;" ></p>
            <div class="clear"></div>
        </div>
		<!-- 自适应模式 -->
		<div id="autoconsultguide" style="margin-top:30px;">
			<div id="autoconsultradio" style="float:left;margin-top:12px;"><input id="6" type="radio" name="CMode" value="autoconsult" /></div>
			<div id="cmimagediv" ><img id="autoadaptpic5" src="../../../images/apmode1.png"></div>
			<div id="apaumodecontent" style="margin-top:-11px;margin-left:72px;" >
				<h2 id="upmodenames" style=""><span id="autoconsultcontent" class="Smartinforight" BindText="mainpage043"></span></h2>
				<div id="autoconsultexplain" style="margin-top:-5px;width:600px;" BindText="mainpage044"></div>
			</div>
			<div class="clear"></div>
		</div>
		
    </div>
    
    <br>
    <div id="cmbutton1" style="margin-top:10px;">
        <input type="button" id="MdyPwdcancel" class="CancleButtonCss buttonwidth_100px" onclick="hideCmodePage();" BindText="mainpage023" />
        <script type="text/javascript">
            if (aisAPDefaultPonFeature == 1) {
                document.write("\<input type=\"button\" id=\"MdyPwdApply1\" class=\"ApplyButtoncss buttonwidth_100px\" onclick=\"showUpportPage(true);\" BindText=\"mainpage059\" \/\>");
                if (portalAPType != 1) {
                    document.write("\<input type=\"button\" id=\"MdyPwdNext\" class=\"ApplyButtoncss buttonwidth_100px\" onclick=\"showUpportPage(false);\" BindText=\"mainpage033\" \/\>");
                }
            } else {
                document.write("\<input type=\"button\" id=\"MdyPwdApply1\" class=\"ApplyButtoncss buttonwidth_100px\" onclick=\"showconfirm();\" BindText=\"mainpage024\" \/\>");
            }
        </script>
    </div>
    
    <div class="alert_box1" id="alert_box1">
        <div style="float:left;"><img id="reboot_img" src="../../../images/icon-thinking.gif" /></div>
        <div class="reboot_title_fir" style="float:left;margin-left:10px;" BindText="mainpage040"></div>
    </div>  
</div>
<div id="cover" style="display:none ;position: fixed;width: 100%;height: 100%;top:0px;left:0px;background: rgba(0,0,0,.5);"></div>
<div style="top:50%;margin-top:-70px;height:240px;width:700px;left:50%;margin-left:120px;background-color:white;display:none;position:flex;z-index: 1003;" id="toast" >
        <h2 id="cmodetitle1" style="width:100%;height:35px;background-color:#C4C8CC;margin-top:0px;font-size:16px;font-family: 微软雅黑;"> 
                <div id="cmtitlecontent"  BindText="mainpage060"></div>
                <div id="cmodeclose" ><img id="cmimageclose" src="../images/xx.png" onclick="hideCmodePage();"></div>
        </h2>  
    <div id="checkForm" style="auto;">
        <div id="MainUpportConfig">
                <form id="MainUpportConfigDetail">
                <table id="MainUpportConfigDetailTable"  cellpadding="0" cellspacing="0" width="100%">
                <li id="X_HW_MainUpPort"    RealType="DropDownList" DescRef="sCMU002" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_MainUpPort" InitValue="Empty" Elementclass="sntpselectdefcss"/>
                </table>
                <script>
                    ParseBindTextByTagName(ConfigMainUpportDes, "td",     1);
                    ParseBindTextByTagName(ConfigMainUpportDes, "span",   1);
                    ParseBindTextByTagName(ConfigMainUpportDes, "input",  2);
                    GetDescFormArrayById(ConfigMainUpportDes, "sCMU001");
                    GetDescFormArrayById(ConfigMainUpportDes, "sCMU000");
                    MainUpportConfigDetailList = HWGetLiIdListByForm("MainUpportConfigDetail", null);
                    HWParsePageControlByID("MainUpportConfigDetail", TableClass, ConfigMainUpportDes, null);
                </script>
                </form>
        </div>
        <div id="cmbutton2" style="margin-top:100px;margin-left:-100px;">
                <input type="button" id="MdyPwdcancel2" class="CancleButtonCss buttonwidth_100px" onclick="hideCmodePage();" BindText="mainpage023" />
                <input type="button" id="MdyPwdApply2" class="ApplyButtoncss buttonwidth_100px" onclick="SubmitUpportConfigForm();" BindText="mainpage024" />
        </div>
    </div> 
</div>

<script type="text/javascript">
        function HWGetToken()
        {
            var tokenstring="";
            $.ajax(
            {
                type : "POST",
                async : false,
                cache : false,
                url : "/html/ssmp/common/GetRandToken.asp",
                success : function(data) 
                {
                    tokenstring = data;
                }
            });
            return tokenstring;
        }

	$(function(){
		showwifimode();
		$("input[name=CMode]").click(function(){
			showwifimode();
			if(autoadapt == 1)
			{
				if(($("input[name=CMode]:checked").attr("id")) == '4')
				{
					if(curChangeMode=='1')
					{
						document.getElementById("MdyPwdApply1").disabled=true;  
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					}
					else
					{
						document.getElementById("MdyPwdApply1").disabled=false; 
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
						document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
					}

				}
				if(($("input[name=CMode]:checked").attr("id")) == '5')
				{
					if(curChangeMode=='2' || curChangeMode=='3')
					{
						document.getElementById("MdyPwdApply1").disabled=true;  
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					}
					else
					{
						document.getElementById("MdyPwdApply1").disabled=false; 
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
						document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
					}
				}

			}
			else
			{
				if(($("input[name=CMode]:checked").attr("id")) == '4')
				{
					if(meshMode != "3")
					{
						document.getElementById("MdyPwdApply1").disabled=false; 
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
						document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
					}
					else
					{
						document.getElementById("MdyPwdApply1").disabled=true;  
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					}

				}
				if(($("input[name=CMode]:checked").attr("id")) == '5')
				{
					if(meshMode != "1")
					{
						document.getElementById("MdyPwdApply1").disabled=false; 
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
						document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
					}
					else
					{
						document.getElementById("MdyPwdApply1").disabled=true;  
						document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
						document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					}
				}
			}
			if(($("input[name=CMode]:checked").attr("id")) == '7')
			{
				if(meshMode == "0")
				{
					document.getElementById("MdyPwdApply1").disabled=true;	
					document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
					document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
				}
				else
				{
					document.getElementById("MdyPwdApply1").disabled=false;	
					document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
					document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
				}
			}
            
			if(($("input[name=CMode]:checked").attr("id")) == '8')
			{
				if(meshMode == "2")
				{
					document.getElementById("MdyPwdApply1").disabled=true;	
					document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
					document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
				}
				else
				{
					document.getElementById("MdyPwdApply1").disabled=false;	
					document.getElementById("MdyPwdApply1").style.backgroundColor = "#8DC63F";
					document.getElementById("MdyPwdApply1").style.borderColor = "#CCCCCC";
					document.getElementById("MdyPwdApply1").style.Color = "#FFFFFF";
				}
            }
		});
	});
	function showwifimode(){
		switch($("input[name=CMode]:checked").attr("id")){
			case "1":
			document.getElementById("MdyPwdApply").disabled=false;
			break;
			case "2":
			document.getElementById("MdyPwdApply").disabled=false;
			break;
			case "3":
			document.getElementById("MdyPwdApply").disabled=false;
			break;
			case "4":
			document.getElementById("MdyPwdApply1").disabled=false;					
			break;  
			case "5":
			document.getElementById("MdyPwdApply1").disabled=false;
			break;  
			case "6":
			document.getElementById("MdyPwdApply1").disabled=false;
			break;  
			case "7":
			document.getElementById("MdyPwdApply1").disabled=false;
			break; 
			case "8":
			document.getElementById("MdyPwdApply1").disabled=false;
			break;             
			default:break;
		}
	}
	
	function showconfirm()
	{
		if(($("input[name=CMode]:checked").attr("id"))=='1' || ($("input[name=CMode]:checked").attr("id"))=='2' || ($("input[name=CMode]:checked").attr("id"))=='3' || ($("input[name=CMode]:checked").attr("id"))=='4' || ($("input[name=CMode]:checked").attr("id"))=='5' || ($("input[name=CMode]:checked").attr("id"))=='6' || ($("input[name=CMode]:checked").attr("id"))=='7' || ($("input[name=CMode]:checked").attr("id"))=='8')
		{
            if ((aisAPDefaultPonFeature == 1) && (document.getElementById("4").checked != true)) {
                var cmbln = true;
            } else {
                var cmbln = window.confirm(framedesinfo["mainpage028"]);
            }
		}
		if (cmbln == true)
		{
			document.getElementById('alert_box').style.display = "block";
			document.getElementById('alert_box1').style.display = "block";

			document.getElementById('cmodetitle').style.display = "none";
			document.getElementById('cmodetitle1').style.display = "none";
			document.getElementById('cmodecontent').style.display = "none";
			document.getElementById('cmbutton').style.display = "none";
			document.getElementById('cmbutton1').style.display = "none";
			document.getElementById('aprepcontent').style.display = "none";
			if(AdaptExist == 0)
			{
				$("#alert_box1").css("margin-top", "250px");
			}
			ModeChangeState();
			document.getElementById("MdyPwdApply").disabled=true;
			document.getElementById("MdyPwdApply").style.backgroundColor = "#bbbbbb";
			document.getElementById("MdyPwdApply").style.borderColor = "#bbbbbb";
			document.getElementById("cmimageclose").disabled=true;
			document.getElementById("MdyPwdcancel").disabled=true;  
			document.getElementById("1").disabled=true; 
			document.getElementById("2").disabled=true; 
			document.getElementById("3").disabled=true; 
			document.getElementById("4").disabled=true;
			document.getElementById("5").disabled=true;
			document.getElementById("6").disabled=true;
            document.getElementById("7").disabled=true;
            document.getElementById("8").disabled=true;
		}
		else
		{   
			document.getElementById("MdyPwdApply").disabled=true;
			document.getElementById("MdyPwdApply").style.backgroundColor = "#bbbbbb";
			document.getElementById("MdyPwdApply").style.borderColor = "#bbbbbb";
			
			document.getElementById("MdyPwdApply1").disabled=true;
			document.getElementById("MdyPwdApply1").style.backgroundColor = "#bbbbbb";
			document.getElementById("MdyPwdApply1").style.borderColor = "#bbbbbb";
			document.getElementById("6").disabled=false;
			document.getElementById("5").disabled=false;
			document.getElementById("4").disabled=false;
			document.getElementById("7").disabled=false;
			document.getElementById("8").disabled=false;
			if(meshMode=='0')
			{
				document.getElementById("7").checked=true;
				document.getElementById("7").disabled=false;
			}
			else if(meshMode=='1')
			{
				document.getElementById("5").checked=true;
				document.getElementById("5").disabled=false;
			}
			else if(meshMode=='3')
			{
				document.getElementById("4").checked=true;
				document.getElementById("4").disabled=false;
			}
			else if(meshMode=='2')
			{
				document.getElementById("8").checked=true;
				document.getElementById("8").disabled=false;
			}
		}
	}
	function ModeChangeState()
	{
        var Form = new webSubmitForm();
 
		if(($("input[name=CMode]:checked").attr("id"))=='5')
		{   
			meshMode = '1';
		}
		else if(($("input[name=CMode]:checked").attr("id"))=='7')
		{   
			meshMode = '0';
		}
		else if(($("input[name=CMode]:checked").attr("id"))=='4')
		{   
			meshMode = '3';
		}
		else if(($("input[name=CMode]:checked").attr("id"))=='8')
		{
            meshMode = '2';
		}
	
        Form.addParameter('x.MeshMode', meshMode);
		Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.X_HW_Mesh&RequestFile=index.asp');
        Form.addParameter('x.X_HW_Token', HWGetToken());
        Form.submit();
	}   
	
	ParseBindTextByTagName(framedesinfo, "span", 1);
	ParseBindTextByTagName(framedesinfo, "td", 1);
	ParseBindTextByTagName(framedesinfo, "div", 1);
	ParseBindTextByTagName(framedesinfo, "input", 2);

</script>

</body>
<script type="text/javascript">
var Firststr = '<div id="MenuFirstLineSpace"><div id="MenuFirstLineIcon"></div><div id="MenuFirstLineMid"></div><div id="MenuFirstLineSpaceborder"></div></div>';
var menulist = [];
var activeMenuId = null;

function stMenuData(id, path, level, defico, clickico, url, defchild)
{
    this.id         = id;
    this.path       = ((path == '') ? '' : (path + '.')) + id;
    this.level      = level;
    this.defico     = defico;
    this.clickico   = clickico;
    this.url        = url;
    this.defchild   = defchild;
    this.hasChild   = false;
}

function setLv1MenuStyle(id, flag, ifOnlyChangeStyle)
{
    var menu = menulist[id];

    if (flag)
    {
        //change menu style
        $("#"         + id).addClass("menuContentActive");
        $("#name_"    + id).addClass("menuContTitleActive");
        $("#pointer_" + id).addClass("menuContPointerActive");
        $("#icon_"    + id).css("background", "url( " + menu.clickico + ") no-repeat center");
        
        if(TypeWord_com == "AP" && ($("#name_Systeminfo").hasClass("menuContTitleActive"))) {
            $("#Systeminfo_subMenus").css("display","block");
            $("#menuWrapper").css("display","block");
            $("#SecondMenuInfo").css("display","block");
        }

        if ((ifOnlyChangeStyle != null) && (ifOnlyChangeStyle == "onlyshow"))
            return menu;

        //show default sub-menu
        if ((menu.defchild != menu.id) //default menu is not menu its self, activate sub-menu
            && menu.hasChild)
        {
            return setLv2MenuStyle(menu.defchild, flag); //activate default sub-menu;
        }
    }
    else
    {
        //change menu style
        $("#"         + id).removeClass("menuContentActive");
        $("#name_"    + id).removeClass("menuContTitleActive");
        $("#pointer_" + id).removeClass("menuContPointerActive");
        $("#icon_"    + id).css("background", "url( " + menu.defico + ") no-repeat center");
        
        if(TypeWord_com == "AP" && (!$("#name_Systeminfo").hasClass("menuContTitleActive"))) {
            $("#Systeminfo_subMenus").css("display","none");
        }
    }
    return menu;
}

function setLv2MenuStyle(id, flag, ifOnlyChangeStyle)
{
    var menu = menulist[id];
    var parentId = menu.path.split('.')[0];
    if (flag)
    {
        //change parent menu style
        setLv1MenuStyle(parentId, flag, "onlyshow");
        //change menu style of itself
        if (!menu.hasChild) $("#name_" + id).addClass("SecondMenuTitleActive");

        if ((ifOnlyChangeStyle != null) && (ifOnlyChangeStyle == "onlyshow"))
            return menu;

        //show default sub-menu
        if ((menu.defchild != menu.id) //default menu is not menu its self, activate sub-menu
            && menu.hasChild)
        {
            //change menu pointer style
            $("#pointer_" + id).removeClass("SecondMenuPointer");
            $("#pointer_" + id).addClass("SecondMenuPointerBlock");
            $("#name_" + id).css("color", "#8DC63F");
            return setLv3MenuStyle(menu.defchild, flag); //activate default sub-menu;
        }
        else
        {
            //change menu pointer style
            $("#pointer_" + id).removeClass("SecondMenuPointerBlock");
            if (menu.hasChild)
                $("#pointer_" + id).addClass("SecondMenuPointer");
            else
                $("#pointer_" + id).addClass("SecondMenuNullPointer");
        }
    }
    else
    {
        //change menu style
        $("#name_" + id).removeClass("SecondMenuTitleActive");
        //change menu pointer style
        $("#pointer_" + id).removeClass("SecondMenuPointerBlock");
        $("#name_" + id).css("color", "");
        if (menu.hasChild)
            $("#pointer_" + id).addClass("SecondMenuPointer");
        else
            $("#pointer_" + id).addClass("SecondMenuNullPointer");
    }
    return menu;
}

function setLv3MenuStyle(id, flag)
{
    var menu = menulist[id];

    if (flag)
    {
        var parentId = menu.path.split('.')[1];
        //change parent menu style
        setLv2MenuStyle(parentId, flag, "onlyshow");
        //change menu style
        $("#"+id).addClass("ThirdMenuTitleActive");
        $("#"+id + " span").css("color", "#fff");
    }
    else
    {
        //change menu style
        $("#"+id).removeClass("ThirdMenuTitleActive");
        $("#"+id + " span").css("color", "#8DC63F");
    }
    
    return menu;
}

function activeMenuStyle(id)
{
    var menu = menulist[id];

    if (menu == null)
        return null;

    var ids = menu.path.split('.');
    switch(menu.level)
    {
        case 3:
            menu = setLv3MenuStyle(ids[2], true); //set style of lv3 menu and parent lv2 & lv1 menu
            break;
        case 2:
            menu = setLv2MenuStyle(ids[1], true); //set style of lv2 menu and parent lv1 menu, active default lv3 menu
            break;
        default:
            menu = setLv1MenuStyle(ids[0], true); //set style of lv1 menu style, active default lv2 or lv3 menu
            break;
    }
    return menu;
}

function deactiveMenuStyle(id)
{
    var menu = menulist[id];

    if (menu == null)
        return ;

    var ids = menu.path.split('.');
    switch(menu.level)
    {
        case 3:
            setLv3MenuStyle(ids[2], false); //reset lv3 menu style
        case 2:
            setLv2MenuStyle(ids[1], false); //reset lv2 menu style
        default:
            setLv1MenuStyle(ids[0], false); //reset lv1 menu style
    }
}

function changeCrossLvMenuStyle(oldId, newId)
{
    var oldMenu = menulist[oldId];
    var newMenu = menulist[newId];

    if ((oldMenu == null) || (newMenu == null)) //page loaded for the first time
        return;

    if (oldMenu.level == newMenu.level) //check whether its parent menu is the same or not
    {
        switch(oldMenu.level)
        {
            case 3:
                var lv2id_o = oldMenu.path.split('.')[1];
                var lv2id_n = newMenu.path.split('.')[1];
                if (lv2id_o != lv2id_n) //different parent, change lv3 menu list
                {
                    $("#" + lv2id_o + "_menu").addClass("Menuhide");
                    $("#" + lv2id_n + "_menu").removeClass("Menuhide");
                }
                else //same parent, change lv2 parent pointer style, because it has been deactivated
                {
                    $("#pointer_" + lv2id_n).removeClass("SecondMenuPointer");
                    $("#pointer_" + lv2id_n).addClass("SecondMenuPointerBlock");
                    $("#name_" + id).css("color", "#8DC63F");
                }
            case 2:
                var lv1id_o = oldMenu.path.split('.')[0];
                var lv1id_n = newMenu.path.split('.')[0];
                if (lv1id_o != lv1id_n)
                {
                    $("#" + lv1id_o + "_subMenus").addClass("Menuhide");
                    $("#" + lv1id_n + "_subMenus").removeClass("Menuhide");
                }
            default:
                break;
        }
    }
    else if (oldMenu.level < newMenu.level)
    {
        //change from upper level to lower level
        var lv1id_n = newMenu.path.split('.')[0];
        var lv1id_o = oldMenu.path.split('.')[0];

        //show lv2 menu list
        if (lv1id_o != lv1id_n)
            $("#" + lv1id_o + "_subMenus").addClass("Menuhide");
        $("#" + lv1id_n + "_subMenus").removeClass("Menuhide");
        $("#SecondMenuInfo").removeClass("Menuhide");
        $("#SecondMenuInfo").addClass("Menushow");
        $("#menuWrapper").removeClass("Menuhide");
        $("#menuWrapper").addClass("Menushow");
        if (newMenu.level > 2)
        {
            var lv2id = newMenu.path.split('.')[1];
            //show lv3 menu list
            $("#" + lv2id + "_menu").removeClass("Menuhide");
        }
        if (oldMenu.level < 2)
        {
            //collapse lv1 menu list
            expandFirstMenuTitle(false);
        }
    }
    else
    {
        //change from lower level to upper level
        if (oldMenu.level > 2)
        {
            var lv2id = oldMenu.path.split('.')[1];
            //hide lv3 menu list
            $("#"+lv2id+"_menu").addClass("Menuhide");
        }

        if (newMenu.level < 2)
        {
            var lv1id = oldMenu.path.split('.')[0];
            //hide lv2 menu list
            $("#" + lv1id + "_subMenus").addClass("Menuhide");
            $("#SecondMenuInfo").removeClass("Menushow");
            $("#SecondMenuInfo").addClass("Menuhide");
            $("#menuWrapper").removeClass("Menushow");
            $("#menuWrapper").addClass("Menuhide");
            //expand lv1 menu list
            expandFirstMenuTitle(true);
        }
        else
        {
            var lv1id_o = oldMenu.path.split('.')[0];
            var lv1id_n = newMenu.path.split('.')[0];
            if (lv1id_o != lv1id_n)
            {
                $("#" + lv1id_o + "_subMenus").addClass("Menuhide");
                $("#" + lv1id_n + "_subMenus").removeClass("Menuhide");
            }
        }
    }
}
function onMenuChange1(id,url)
{
    if (!ifCanChangeMenu())
    {
        return;
    }

    if (activeMenuId != null)
    {
        deactiveMenuStyle(activeMenuId);
    }

    var menu = activeMenuStyle(id);

    changeCrossLvMenuStyle(activeMenuId, menu.id);

    if (menu != null)
        $("iframe#menuIframe").attr("src", url);

    activeMenuId = menu.id;
}

function onMenuChange(id)
{
    if (!ifCanChangeMenu())
    {
        return;
    }

    if (activeMenuId != null)
    {
        deactiveMenuStyle(activeMenuId);
    }

    var menu = activeMenuStyle(id);

    changeCrossLvMenuStyle(activeMenuId, menu.id);

    if (menu != null)
        $("iframe#menuIframe").attr("src", menu.url);

    activeMenuId = menu.id;

    if (menu.url.indexOf("mainpage_new.asp") !== -1) {
        $("#content").css("width","100%");
        $(".AspWidth").css("width","1200px");
        $("div#indexpage div#maincenter").css("width","1200px");
    } else {
        $("#content").css("width","80%");
        $(".AspWidth").css("width","790px");
        $("div#indexpage div#maincenter").css("width","1050px");
    }
}

function setParentDefchild(parentId, id)
{
    var menu = menulist[parentId];
    if ((menu != null)
        /*&& (menu.url == null)*/
        && (menu.defchild == parentId))
    {
        menu.defchild = id;
    }
}

/*create level-3 menus*/
function CreateThirdMenu(htmlTagId, parentId, parentPath, subMenus) {
    var m3contain = document.getElementById(htmlTagId);
    var onmouseEnterId = '';

    for (var i in subMenus)
    {
        var id = subMenus[i].id;
        
        menulist[id] = new stMenuData(id, parentPath, 3,
                                      subMenus[i].deficon,
                                      subMenus[i].clickicon,
                                      subMenus[i].url, id);
        
        var m3namesr = GetIdByUrl("m3div",subMenus[i].url);
        var m3title = document.createElement("a");
        m3title.id = id;
        //m3title.name = m3namesr;
        m3title.setAttribute('name',m3namesr);
        var Menu3NameStrValue = subMenus[i].name;

        m3title.className = "ThirdMenuTitle";

        m3title.onclick   = function(){ 
            onMenuChange(this.id);
            $("#name_" + parentId).css("color", "#8DC63F");
            thisLv3Id = this.id;
            thisLv3Clicked = true;
        }

        m3title.onmouseout = function (event) {
            var el = event.target;
            var thirdMenuActive = $(el).hasClass("ThirdMenuTitleActive");

            if (thisLv3Clicked == true) {
                $('#'+thisLv3Id).find('span').first().css('color', "#fff");
            }
            if (thisLv3Clicked == true && thisLv3Id != onmouseEnterId) {
                $('#'+onmouseEnterId).find('span').first().css('color', "#8DC63F");
            }
            if (thisLv3Clicked == false && thisLv3Id != onmouseEnterId) {
                $('#'+onmouseEnterId).find('span').first().css('color', "#8DC63F");
                    if (thirdMenuActive) {
                        $('#'+onmouseEnterId).find('span').first().css('color', "#fff")
                    }
            }
            if ((thisLv3Clicked == false) && (thisLv3Id == onmouseEnterId) && thirdMenuActive) {
                $('#'+el.id).find('span').first().css('color', "#fff");
            }
            if ((thisLv3Clicked == false) && (thisLv3Id == onmouseEnterId)) {
                $('#'+onmouseEnterId).find('span').first().css('color', "#8DC63F")
            }
        }

        m3title.onmouseenter = function (event) {
            var el = event.target;
            onmouseEnterId = el.id;

            if (thisLv3Clicked == false) {
                $('#'+el.id).find('span').first().css('color', "#fff");
            }
            if (thisLv3Clicked == true && thisLv3Id != el.id) {
                $('#'+el.id).find('span').first().css('color', "#fff");
            }
        }
        
        GetMenuTitle(subMenus[i].name, "third", m3title);
        var str = GetMenuStr(subMenus[i].name, "second");
        var txt = document.createTextNode(str.replace(/&nbsp;/g," "));
        m3title.appendChild(txt);

        var newLi = document.createElement("li");
        newLi.className = "liStyle";
        
        m3contain.appendChild(newLi);
        newLi.appendChild(m3title);

        var newSpan = document.createElement("span");
        var spanContent = document.createTextNode("|");
        newSpan.appendChild(spanContent);
        newSpan.className = "spanStyle";
        m3title.appendChild(newSpan);

        if (i == 0)
        {
            setParentDefchild(parentId, id);
        }
    }
}

/*create level-2 menus*/
function CreateSecondMenu(parentId, parentPath, subMenus)
{
    var m2list = document.getElementById("SecondMenuInfo");
    var m2contain = document.createElement("div");
    
    m2contain.id = parentId + "_subMenus";
    m2contain.className = "Menuhide";
    m2list.appendChild(m2contain);

    for (var i in subMenus)
    {
        var id = subMenus[i].id;
        if ((meshMode != '0' || cpeReuseStatus == 1) && (id == "subversioninfo")) { 
            continue;
        }

        menulist[id] = new stMenuData(id, parentPath, 2,
                                      subMenus[i].deficon,
                                      subMenus[i].clickicon,
                                      subMenus[i].url, id);

        var m2namesr = GetIdByUrl("m2div",subMenus[i].url);
        var m2menu = document.createElement("div");

        //m2menu.name = m2namesr;
        m2menu.setAttribute('name',m2namesr); 
        m2menu.id = id;
        m2menu.className = "SecondmenuContent";
        m2menu.onclick   = function() {
            onMenuChange(this.id); 
            thisLv3Clicked = false;
        }
        m2contain.appendChild(m2menu);
        var m2title = document.createElement("div");
        m2title.id = "name_"+id;
        var MenuNameStrValue = subMenus[i].name;
        if(1 == MenuModeVDF)
        {
            if(MenuNameStrValue.length > 22)
            {
                m2title.className = "SecondMenuTitleChangeLine";
            }
            else if(MenuNameStrValue.length > 20
                    && subMenus[i].subMenus != undefined)
            {
                m2title.className = "SecondMenuTitleChangeLine";
            }
            else
            {
                m2title.className = "SecondMenuTitle";
            }
        }
        else
        {
            m2title.className = "SecondMenuTitle";
        }
        
        GetMenuTitle(subMenus[i].name, "second", m2title);
        var str = GetMenuStr(subMenus[i].name, "second");
        var txt = document.createTextNode(str.replace(/&nbsp;/g," "));
        m2title.appendChild(txt);
        m2menu.appendChild(m2title);
        var m2pointer = document.createElement("div");
        m2menu.appendChild(m2pointer);
        m2pointer.id = "pointer_" + id;

        if (subMenus[i].subMenus != undefined)
        {
            m2pointer.className = "SecondMenuPointer";
            m2children = document.createElement("ul");
            m2children.id = id + "_menu";
            m2children.className = "Menuhide";
            m2contain.appendChild(m2children);
            CreateThirdMenu(m2children.id, id, menulist[id].path, subMenus[i].subMenus);
            menulist[id].hasChild = true;
        }
        else
        {
            m2pointer.className = "SecondMenuNullPointer";
        }

        if (i == 0)
        {
            setParentDefchild(parentId, id);
        }
    }
}

/*create level-1 menus*/
for(var FirstMenuindex in menuJsonData)
{
    var m1namesr = GetIdByUrl("m1div",menuJsonData[FirstMenuindex].url);
    var id = menuJsonData[FirstMenuindex].id;
    Firststr += '<div class="menuContent" id=' + id + ' onclick="onMenuChange(this.id);">';

    Firststr +='<div class="menuContTitle" id="name_' + id + '" name="' + m1namesr + '"'+ GetMenuTitle(menuJsonData[FirstMenuindex].name, "first") + '>'
             + '<a>' + GetMenuStr(menuJsonData[FirstMenuindex].name, "first") + '</a>'
             + '</div>';
    Firststr +='<div class="menuContPointer menuContPointerdef" id="pointer_' + id + '"></div>';
    Firststr +='</div>';
    menulist[id] = new stMenuData(id, '', 1,
                                  menuJsonData[FirstMenuindex].deficon,
                                  menuJsonData[FirstMenuindex].clickicon,
                                  menuJsonData[FirstMenuindex].url, id);

    if(undefined != menuJsonData[FirstMenuindex].subMenus)
    {
        CreateSecondMenu(id, menulist[id].path, menuJsonData[FirstMenuindex].subMenus);
        menulist[id].hasChild = true;
    }
}
Firststr += '<div id="MenuBottomLineSpace"><div id="MenuBottomLineIcon"></div><div id="MenuBottomLineMid"></div><div id="MenuBottomLineSpaceborder"></div></div>';
$("#MenuInfo").append(Firststr);

ParseBindTextByTagName(framedesinfo, "span", 1);
ParseBindTextByTagName(framedesinfo, "div",  1);
document.getElementById('username').appendChild(document.createTextNode(UserName));

var UpgradeHeigthHandle = setInterval("adjustParentHeight();", 200);

var FirstclickExpansion = menuJsonData[0].id;
$("#" + FirstclickExpansion).trigger("click");

$("#AppDiv").click(function() {
    toggleQRCodeDisplay('auto');
});

$("#D2CodeIcon").click(function() {
    window.open("http://www.huawei.com/appdownload/linkhome/index.htm", "newwindow");
});

function getMenuStrDefLen(level)
{
    var length = 0;

    if (curLanguage.toUpperCase() == "CHINESE")
    {
        length = 8;
    }
    else if(curLanguage.toUpperCase() == "JAPANESE")
    {
        if (level == "first" )
        {
            length = 12;
        }
        else
        {
            length = 8;
        }
    }
    else
    {
        if (level == "first" )
        {
            length = 22;
        }
        else
        {
            length = 18;
        }
    }

    return length;
}

function GetMenuStr(datastr, level)
{
    if(1 == MenuModeVDF)
    {
        return datastr;
    }
    else
    {
        var length = getMenuStrDefLen(level);
        var MenuName = GetStringContentForTitle(datastr, length);
        return MenuName;
    }

}

function GetMenuTitle(datastr, level, element)
{
    if(1 == MenuModeVDF)
    {
        return;
    }
    
    var length = getMenuStrDefLen(level);
    var titlestr = "";
    if (datastr.length > length)
    {
        titlestr = ' title="' + datastr + '" ';
        if (element != null)
            element.setAttribute("title", datastr);
    }
    return titlestr;
}

function expandFirstMenuTitle(flag)
{
    var id;
    var action = ((flag == true) ? "block" : "none");
    $('#MenuBottomLineMid').css("display", action);

    for(var tmp in menulist)
    {
        if (menulist[tmp].level != 1) continue;
        id = "name_" + menulist[tmp].id;
    }
}
</script>
</html>

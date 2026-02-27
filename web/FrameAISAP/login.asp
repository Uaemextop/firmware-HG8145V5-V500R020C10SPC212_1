<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
    <meta http-equiv="Pragma" content="no-cache" />
    <title></title>
    <link href="/Cuscss/<%HW_WEB_GetCusSource(login.css);%>"  media="all" rel="stylesheet" />
    <script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
</head>
<style type="text/css">

</style>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script type="text/javascript" src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script id="langResource" language="JavaScript" src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function GetRandCnt() { return '<%HW_WEB_GetRandCnt();%>'; }
function MD5(str) { return hex_md5(str); }
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = Var_DefaultLang;
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var locklefttimerhandle;
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var languageList = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_LANGUAGE_SET.STRING);%>';
var APPVersion = '<%HW_WEB_GetAppVersion();%>';
var langDescList = new Array();
var isplocking = '<%HW_WEB_GetFeatureSupport(FT_SSMP_ISP_LOCKING);%>';
var lockStatus = '<%WEB_GetDevcieLockStatus();%>';
var UpdateFlag = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1.UpdateFlag);%>';
var captChaEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.Captcha_enable);%>';
langDescList["chinese"] = "简体中文"; //or just '中文'?
langDescList["english"] = "English";
langDescList["japanese"] = "日本語";
langDescList["arabic"] = "العربية";
langDescList["portuguese"] = "Português";
langDescList["spanish"] = "Español";
langDescList["turkish"] = "Türkçe";

var languageSet = new Array();

if ((typeof languageList == 'string') && (languageList != ''))
	languageSet = languageList.split("|");

if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}

document.title = ProductName;

function genLanguageList()
{
	if (languageList == '')
		return false;

	var ChangeLanguage = '';

	if (languageSet.length > 1)
	{
		for (var lang in languageSet)
		{
			ChangeLanguage += '<td width="47%" nowrap><a id="' 
						   +  languageSet[lang] + '" href="#" name="' 
						   +  languageSet[lang] + '" onClick="onChangeLanguage(this.id);" class="changelanguage">[' 
						   +  langDescList[languageSet[lang]] + ']</a></td>';
		}
		document.getElementById('chooselagButton').innerHTML = ChangeLanguage;
		document.getElementById('chooselag').style.display = "block";
	}
}

function GetLoginDes(DesId)
{
	return framedesinfo[DesId];
}

function showlefttime()
{
	if (LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}	

	var html = GetLoginDes("frame011") +  LockLeftTime + GetLoginDes(LockLeftTime == 1 ? "frame012a" : "frame012");

	SetDivValue("DivErrPromt", html);

	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
	if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
		||( "1" == FailStat) || (ModeCheckTimes >= errloginlockNum) )
	{
		document.getElementById('DivErrPage').style.display = 'block';
	}

	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		if(ModeCheckTimes >= errloginlockNum)
		{
			SetDivValue("DivErrPromt", GetLoginDes("frame013a"));
		}
		else
		{
			SetDivValue("DivErrPromt", GetLoginDes("frame013"));
		}
		
		setDisable('txt_Username', 1);
		setDisable('txt_Password', 1);
		setDisable('loginbutton',  1);
		setDisable('txt_Captcha', 1);
	}
    else if('2' == FailStat)
    {
        var errhtml = 'You IP address cannot be used for a login.';
        SetDivValue("DivErrPromt", errhtml);
    }
	else if (LoginTimes > 0 && LoginTimes < errloginlockNum)
	{
		SetDivValue("DivErrPromt",  GetLoginDes("frame014"));
	}
	else if (LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		var desc = "frame012";
		if (parseInt(LockLeftTime) == 1)
			desc = "frame012a";

		var html = GetLoginDes("frame011") +  LockLeftTime + GetLoginDes(desc);
		
		SetDivValue("DivErrPromt", html);
		setDisable('txt_Username', 1);
		setDisable('txt_Password', 1);
		setDisable('loginbutton',  1);
		setDisable('txt_Captcha', 1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else
	{
		document.getElementById('DivErrPage').style.display = 'none';
	}
}

function IsIEBrower(num) {
    var ua = navigator.userAgent.toLowerCase();
    var isIE = ua.indexOf("msie")>-1;
    var safariVersion;
    if(isIE){
        safariVersion =  ua.match(/msie ([\d.]+)/)[1];
        var sa = parseInt(safariVersion);
        if(safariVersion <= num ){
           alert(framedesinfo["frame016"]);
        }
    }
}

function LoadFrame()
{
    if (UpdateFlag == 1) {
        document.getElementById("pwdtitle").innerHTML = "PASSWORD(Same as gateway)";
    } else {
        document.getElementById("pwdtitle").innerHTML = "PASSWORD";
    }
	document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);

	$("#accordion_help").css("display","none");

	onChangeLanguage();

	init();
}

function SetCusLanguageInfo(language, activflag)
{
	var node = document.getElementById(language);

	if ((null == node) || (undefined == node))
		return;

	var color = (activflag ? "#9b0000" : "#FFFFFF");
	node.style.color = color;
}

function init() {
	if (document.addEventListener) {
		document.addEventListener("keypress", onHandleKeyDown, false);
	} else {
		document.onkeypress = onHandleKeyDown;
	}
}

function onHandleKeyDown(event) {
	var e = event || window.event;
	var code = e.charCode || e.keyCode;

	if (code == 13) {
		LoginSubmit("loginbutton");
	}
}

function LoginSubmit(val)
{
	var Username = document.getElementById('txt_Username');
	var Password = document.getElementById('txt_Password');
	var captcha = document.getElementById('txt_Captcha');
	var appName = navigator.appName;
	var version = navigator.appVersion;
	var CheckResult = 0;

	if (appName == "Microsoft Internet Explorer")
	{
		var versionNumber = version.split(" ")[3];
		if (parseInt(versionNumber.split(";")[0]) < 6)
		{
			alert(GetLoginDes('frame006'));
			return false;
		}
	}

	if (Username.value == "") {
		alert(GetLoginDes("frame007"));
		Username.focus();
		return false;
	}

	if (Password.value == "") {
		alert(GetLoginDes("frame009"));
		Password.focus();
		return false;
	}

	if ((captChaEnable == '1') && (captcha.value == "")) {
		alert(GetLoginDes("frame009aisap"));
		captcha.focus();
		return false;
	}

	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date = new Date();
		date.setTime(date.getTime() - 10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
	}
	
	var cnt;
	var Form = new webSubmitForm();
	
	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	url : '/asp/GetRandCount.asp',
	success : function(data) {
		cnt = data;
	}
	});
	var Form = new webSubmitForm();
	var cookie2 = "Cookie=body:" + "Language:" + Language + ":" + "id=-1;path=/";
	Form.addParameter('UserName', Username.value);
	Form.addParameter('PassWord', base64encode(Password.value));
	Form.addParameter('Language', Language);
	document.cookie = cookie2;
	Username.disabled = true;
	Password.disabled = true;
	if (captChaEnable == '1') {
		Form.addParameter('CheckCode', getValue('txt_Captcha'));
		Form.setAction('login.cgi?' +'&CheckCodeErrFile=login.asp');
	} else {
		Form.setAction('/login.cgi');
	}
	
	Form.addParameter('x.X_HW_Token', cnt);
	Form.submit();
	return true;
}

function Refresh()
{
	window.location.href="/login.asp";
}

function onChangeLanguage(paralanguage)
{
	if (paralanguage != null)
	{
		if (Language == paralanguage) //same language, do nothing
			return;

		SetCusLanguageInfo(Language, false); //deactivate old language

		Language = paralanguage;
	}
	var langSrc = "/frameaspdes/" + Language + "/ssmpdes.js";
	loadLanguage("langResource", langSrc, onLanguageChanged);
}

function onLanguageChanged()
{
	ParseBindTextByTagName(framedesinfo, "span",  1);
	ParseBindTextByTagName(framedesinfo, "div",   1);
	ParseBindTextByTagName(framedesinfo, "input", 2);

	SetCusLanguageInfo(Language, true);//activate new language

	setErrorStatus();
}

function loadLanguage(id, url, callback)
{
	var docHead = document.getElementsByTagName('head')[0];
	var langScript = document.getElementById(id);
	if (langScript != null) {
		docHead.removeChild(langScript);
	}

	try
	{
		langScript = document.createElement('script');
		langScript.setAttribute('type', 'text/javascript');
		langScript.setAttribute('src',  url);
		langScript.setAttribute('id',   id);
		if (callback != null) 
		{
			langScript.onload = langScript.onreadystatechange = function() 
			{
				if (langScript.ready) 
				{
					return false;
				}
				if (!langScript.readyState || langScript.readyState == "loaded" || langScript.readyState == 'complete') 
				{
					langScript.ready = true;
					callback();
				}
			};
		}
		docHead.appendChild(langScript);
	}
	catch(e)
	{}
}


function isValidAscii(val)
{
	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch <= ' ' || ch > '~' )
		{
			return false;
		}
	}
	return true;
}

function isLowercaseInString(str)
{
		var lower_reg = /^.*([a-z])+.*$/;
		var MyReg = new RegExp(lower_reg);
		if ( MyReg.test(str) )
		{
			return true;
		}
		return false;
}

function isUppercaseInString(str)
{
		var upper_reg = /^.*([A-Z])+.*$/;
		var MyReg = new RegExp(upper_reg);
		if ( MyReg.test(str) )
		{
			return true;
		}
		return false;
}

function isDigitInString(str)
{
	var digit_reg = /^.*([0-9])+.*$/;
	var MyReg = new RegExp(digit_reg);
	if ( MyReg.test(str) )
	{
		return true;
	}
	return false;
}

function isSpecialCharacterNoSpace(str)
{
	var specia_Reg =/^.*[`~!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\'\;\,\./:\"\?><\\\|]{1,}.*$/;
	var MyReg = new RegExp(specia_Reg);
	if ( MyReg.test(str) )
	{
		return true;
	}
	return false;
}

function getValue(id)
{
    var item = getElement(id);
    if (item == null) {
        debug(id + " is not existed!");
        return -1;
    }
    return item.value;
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
}

function GetRandomNum(min, max)
{
    return Math.floor(Math.random() * (max-min) + min);
}

function CanvasDrawRandomLineAndPoint(canvasId, linesCount, maxLineLength, pointsCount)
{
	var canvasImgCode = document.getElementById(canvasId);
	var width = canvasImgCode.width;
    var height = canvasImgCode.height;
	
	var canvasContext = canvasImgCode.getContext("2d");
	canvasContext.clearRect(0,0,width,height);
	
	var arrayLineColor = new Array("#9ccc65", "#ffee58", "#d4e157", "#ffca28", "#ffab91", "#ffb74d", "#f48fb1", "#e1bee7");
	var lineColorCount = arrayLineColor.length;
	var arrayPointColor = new Array("#738ffe", "#9ccc65", "#ffee58", "#d4e157", "#ffca28", "#ffab91", "#ffb74d", "#673ab7", "#3f5165", "#9c27b0", "#e91e63");
	var pointColorCount = arrayPointColor.length;
	
	for(var i = 0; i < linesCount; i++){
        var x1 = GetRandomNum(0, width);
		var y1 = GetRandomNum(0, height);
		var x2 = GetRandomNum(0, width);
		var y2 = GetRandomNum(0, height);
		
		if ((x2 - x1) > maxLineLength){
			x2 = x1 + maxLineLength;
		}else if ((x2 - x1) < (-maxLineLength)){
			x2 = x1 - maxLineLength;
		}
        
        canvasContext.beginPath();
        canvasContext.moveTo(x1, y1);
        canvasContext.lineTo(x2, y2);
		canvasContext.closePath();
		
		var grdl = canvasContext.createLinearGradient(x1, y1, x2, y2);
		grdl.addColorStop(0, arrayLineColor[GetRandomNum(0, lineColorCount - 1)]);
		grdl.addColorStop(Math.random(), arrayLineColor[GetRandomNum(0, lineColorCount - 2)]);
		grdl.addColorStop(1, arrayLineColor[GetRandomNum(0, lineColorCount - 2)]);

        canvasContext.lineWidth = 2;
        canvasContext.strokeStyle = grdl;
        canvasContext.stroke();
    }

    for(var i = 0; i < pointsCount; i++){
        canvasContext.fillStyle = arrayPointColor[i % (pointColorCount - 1)];
        canvasContext.beginPath();
        canvasContext.arc(GetRandomNum(0, width), GetRandomNum(0, height), Math.random()+1, 0, Math.PI*2, true);
		canvasContext.closePath();
        canvasContext.fill();
    }	
}

function btnRefresh() {
    if (captChaEnable != '1') {
        $("#captchaForm").css("display","none");
    }
    document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
    CanvasDrawRandomLineAndPoint("canvasDrawImgcode", GetRandomNum(5,7), 100, GetRandomNum(30,40));
    var browser=navigator.appName;
    var b_version=navigator.appVersion;
    var version=b_version.split(";");
    var trim_Version=version[1].replace(/[ ]/g,"");
    if (browser=="Microsoft Internet Explorer" && trim_Version=="MSIE8.0") {
        document.getElementById('imgcode').style.marginLeft='0' 
    } else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE9.0") {
        document.getElementById('imgcode').style.marginLeft='0'
    }
}
</script>

<body onLoad="LoadFrame();">
    <div class="container-fluid">
        <div class="row">
            <div class="wrapper">
                <div class="warp-login">
                    <div style="text-align: center;padding-bottom:50px; ">
                        <img src="images/aisfibre.jpg" style="width:200px">
                    </div>
                    <h3 class="text-center">SIGN IN</h3>
                     <script>
                        if (isplocking == 1) {
                            if(lockStatus == '1') {
                                document.write('<div id="DivTip" BindText="frame023" style="display:block;"></div>');
                            }
                        }
                    </script>
                    <div class="form-group">
                        <p class="title">USERNAME</p>
                        <div><input type="text" id="txt_Username" name="txt_Username" class="input-form-login username" placeholder="USERNAME"></div>
                    </div>
                    <div class="form-group">
                        <p class="title" id="pwdtitle" ></p>
                        <div><input type="password" autocomplete="off" id="txt_Password" name="txt_Password" class="input-form-login password" placeholder="PASSWORD"></div>
                    </div>
                    <div class="form-group" id="captchaForm">
                    <div id="imgCheckCode">
                        <span id="captcha" style="position:relative;top:-2px;">CAPTCHA</span> <img id="imgcode" style="position:relative;top:8px;margin-left:20px;" width="150" height="35"/>
                        <canvas id="canvasDrawImgcode" style="position:relative;top:8px;margin-left:-155px;" width="150" height="35"></canvas>
                        <img src="/images/refresh.jpg" id="refresh" style="position:relative;top:10px;border-radius:8px;margin-left:8px;" onClick="btnRefresh();"/>
                    </div>
                        <div><input type="text" style="position:relative;top:15px;width:499.75px;" autocomplete="off" id="txt_Captcha" name="txt_Captcha" class="input-form-login captcha" placeholder="CAPTCHA"></div>
                    </div>
                    <script>
                        btnRefresh();
                    </script>
                    <div id="DivErrPage" class="contentItemlogin">
                        <div id="DivErrPagePlace" class="labelBoxlogin"></div>
                        <div id="DivErrIconPlace" class="contenboxlogin"><div id="DivErrIcon"></div><div id="DivErrPromt"></div></div>
                    </div>
                    
                    <div class="text-center" style="margin-top:70px;text-align:center;">
                        <button class="btn-signin" id="loginbutton" onClick="LoginSubmit(this.id);">SIGN IN</button>
                    <div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
		ParseBindTextByTagName(framedesinfo, "span",  1);
		ParseBindTextByTagName(framedesinfo, "input", 2);
    </script>
</body>
</html>

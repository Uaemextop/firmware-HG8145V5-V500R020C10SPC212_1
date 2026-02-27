<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<title>Go Fiber</title>
<link href="Cuscss/<%HW_WEB_GetCusSource(login.css);%>"  media="all" rel="stylesheet" />
<link href="images/o3_logo.ico" rel="shortcut icon" type="image/x-icon" />
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function MD5(str) { return hex_md5(str); }

var APPVersion = '<%HW_WEB_GetAppVersion();%>';
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = Var_DefaultLang;
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';

var locklefttimerhandle;

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}

	if(LockLeftTime == 1)
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
	}
	else
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
	}

	SetDivValue("DivErrPage", errhtml);
	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		var errhtml = 'Too many retrials.';

		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);

		setDisable('buttoninput',1);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';

		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('buttoninput',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
		var errhtml = 'Incorrect username/password combination. Please try again.';
		SetDivValue("DivErrPage", errhtml);
	}
	else
	{
		document.getElementById('DivErrPage').style.display = 'none';
	}
}


function SubmitForm() {
	var Username = document.getElementById('txt_Username');
	var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;

	if (appName == "Microsoft Internet Explorer")
	{
		var versionNumber = version.split(" ")[3];
		if (parseInt(versionNumber.split(";")[0]) < 6)
		{
			alert("We cannot support the IE version which is lower than 6.0.");
			return false;
		}
	}

	if (Username.value == "")
	{
				alert("User Name is a required field.");
		Username.focus();
		return false;
	}

	if (Password.value == "")
	{
		alert("Password is a required field.");
		Password.focus();
		return false;
	}

	var cnt;

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
	
	document.cookie = cookie2;

	Username.disabled = true;
	Password.disabled = true;

	Form.setAction('/login.cgi');
	Form.addParameter('x.X_HW_Token', cnt);
	Form.submit();
	return true;
}

function IsIEBrower(num) {
    var ua = navigator.userAgent.toLowerCase();
    var isIE = ua.indexOf("msie")>-1;
    var safariVersion;
    if(isIE){
        safariVersion =  ua.match(/msie ([\d.]+)/)[1];
        var sa = parseInt(safariVersion);
        if(safariVersion <= num ){
           alert("Your browser version is outdated (IE 6, IE 7, and IE 8 are not supported). You must upgrade your browser to IE 9 or later. ");
        }
    }
}

function LoadFrame() 
{

	
	document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);
	SetDivValue('account', 'Username');
	SetDivValue('password', 'Password');

	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) 
	{
		document.getElementById('DivErrPage').style.display = 'block';
		setErrorStatus();
	}
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		document.getElementById('DivErrPage').style.display = 'block';
		setErrorStatus();
	}
	init();
 }

function init() {
	if (document.addEventListener) 
	{
		document.addEventListener("keypress", onHandleKeyDown, false);
	} else {
		document.onkeypress = onHandleKeyDown;
	}
}

function onHandleKeyDown(event) {
	var e = event || window.event;
	var code = e.charCode || e.keyCode;

	if (code == 13) {
		SubmitForm();
	}
}

</script>
</head>
<body onLoad="LoadFrame();">
<div id="main_wrapper">
	<div id="logininfo">
		<div id="account" class="whitebold"></div>
		<div id="accountput">
			<input name="txt_Username" class="input_login" id="txt_Username" type="text" maxlength="32"/> 
		</div>
		<div id="password" class="whitebold"></div>
		<div id="passwordput">
			<input name="txt_Password" class="input_login" id="txt_Password" type="password" maxlength="127" autocomplete="off" /> 
		</div>
		<div id="loginbutton">
			<input type="button" id="buttoninput" class="loginbuttoncss" onClick="SubmitForm();" value="Login"/>
		</div>
	</div>
	
	<div id="DivErrPage" class="SpanDivErrPromt">
	</div>
</div>
</body>
</html>

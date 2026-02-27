<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<title></title>
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet"/>
<style type="text/css">
#first{
	background-color:white;
	height:25px;
	text-align: center;
	color: red;
	position:absolute;
	width: 380px;
	top: 312px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function MD5(str) { return hex_md5(str); }

var APPVersion = '<%HW_WEB_GetAppVersion();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = Var_DefaultLang;

var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var locklefttimerhandle;
var WebAccessMode = '<%HW_WEB_GetWebAccessMode();%>';

if((window.location.href.toUpperCase().indexOf("/ADMIN.HTML") == -1)&&(WebAccessMode=="lan"))
{
	window.top.location = "/pindex.asp"
}

document.title = ProductName;

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}

	if(LockLeftTime == 1)
	{
		var html = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
	}
	else
	{
		var html = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
	}

	SetDivValue("DivErrPage", html);
	LockLeftTime = LockLeftTime - 1;
}


function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
   if('1' == FailStat || (ModeCheckTimes >= errloginlockNum) )
	{
		var html = 'Too many retrials.';
		SetDivValue("DivErrPage", html);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('Submit',1);
	}
	else if ((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
			var html = 'Incorrect account/password combination. Please try again.';
			SetDivValue("DivErrPage", html);
	}
	else if ( LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0 )
	{
		var html = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
		SetDivValue("DivErrPage", html);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('Submit',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else
	{
		document.getElementById('loginfail').style.display = 'none';
	}
}

function SubmitFormPwd()
{
	SubmitForm();
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

	if (Username.value == "") {
		alert("Account is a required field.");
		Username.focus();
		return false;
	}

	if (Password.value == "") {
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

	Form.addParameter('x.X_HW_Token', cnt);
	Form.setAction('/login.cgi');
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
	var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';


	document.getElementById('account').innerHTML = 'Account';
	document.getElementById('Password').innerHTML = 'Password';
	document.getElementById('button').innerHTML = 'Login';
	
	document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved';


	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum) )
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	init();

	if((UserLeveladmin == '0'))
	{
		alert("The current user is not allowed to log in.");
		return false
	}
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
		SubmitForm();
	}
}
</script>
</head>
<body onLoad="LoadFrame();">
<div id="main_wrapper">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		  <td align="center" height="210" valign="bottom">
			<table border="0" cellpadding="0" cellspacing="0" width="36%">
				<tr>
					<td align="center" width="29%">
						<img height="75" src="images/logo.gif" width="70" alt="">
					</td>
					<td class="hg_logo" width="21%" id="hg_logo">
						<script language="JavaScript" type="text/javascript">
							document.write(ProductName);
						</script>
					</td>
				  <td valign="bottom" width="50%">
					<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
						<tr>
							<td width="47%"></td>
							<td width="53%"></td>
						</tr>
					</table>
				  </td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td align="center" height="65">
				<table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="60%" style="font-size:16px;">
					<tr>
						<td class="whitebold" height="37" align="right" width="20%" id="account">Account</td>
						<td class="whitebold" height="37" align="center" width="2%">:</td>
						<td width="78%" align=left>
							<input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="32">
						</td>
					</tr>
					<tr>
						<td class="whitebold" height="28" align="right" id="Password">Password</td>
						<td class="whitebold" height="28" align="center" >:</td>
						<td align=left>
							<input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127">&nbsp;
							<button style="font-size:12px;font-family:Tahoma,Arial;" id="button" class="submit" name="Submit" onClick="SubmitFormPwd();" type="button">Login</button>&nbsp;					
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="info_text" height="25" id="footer">Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved. </td>
		</tr>
		<tr>
			<td align="center">
				<table border="0" cellpadding="0" cellspacing="0" height="300" width="490" style="background: url('images/pic.jpg') no-repeat center;">
					<tr>
						<td valign="top" style="padding-top: 20px;">
						<div id="loginfail" style="display: none">
							<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%">
								<tr>
									<td align="center" bgcolor="#FFFFFF" height="21">
									<span style="color:red;font-size:12px;font-family:Arial;">
									<div id="DivErrPage"></div>
									</span>
									</td>
								</tr>
							</table>
						</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

</body>
</html>

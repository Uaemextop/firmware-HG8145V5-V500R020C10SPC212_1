<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<title></title>
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet" />
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
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var Language = '';
var locklefttimerhandle;

var ProductName = 'Mobily Fiber'; 
Var_DefaultLang ='arabic';

if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}


document.title = ProductName;

function GetErrHtmlForAr(time)
{
	var optTime = parseInt(time);
	if(optTime == 2)
	{
		var errhtml = 'تم إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  optTime + ' ثواني.';
	}
	else
	{
		var optTimestring=String(optTime);
		var TimestringLength = optTimestring.length;
		
		if (TimestringLength > 1)
		{
			var timelastchar = optTimestring.charAt(TimestringLength - 1); 
			var timeprevlastchar = optTimestring.charAt(TimestringLength - 2); 
		}
		
		if( (TimestringLength <= 1) 
		    || ((parseInt(timelastchar) <= 9 && parseInt(timelastchar) >= 3) && parseInt(timeprevlastchar) == 0) 
			|| (parseInt(timelastchar) == 0 && parseInt(timeprevlastchar) == 1))
		{
			var errhtml = 'تم إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  optTime + ' ثواني.';
		}
		else if(((parseInt(timelastchar) <= 2 && parseInt(timelastchar) >= 0) && parseInt(timeprevlastchar) == 0))
		{
			var errhtml = 'م إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  optTime + ' ثانية.';
		}
		else
		{
			var errhtml = 'تم إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  optTime + ' ثانية.';
		}
	}

	return errhtml;
}

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}
	
	if(LockLeftTime == 1)
	{
		if(Language == 'arabic')
		{	
			document.getElementById('DivErrPage').dir = 'rtl';
			var errhtml = 'تم إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  LockLeftTime + ' ثانية.';
		}
		else
		{
			var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
		}
	}
	else
	{
		if(Language == 'arabic')
		{	
			document.getElementById('DivErrPage').dir = 'rtl';
			var errhtml = GetErrHtmlForAr(LockLeftTime);
		}
		else
		{
			var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
		}
	}
	
	SetDivValue("DivErrPage", errhtml);
	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{	
	clearInterval(locklefttimerhandle); 
	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{   
		if(Language == 'arabic')
		{	
			document.getElementById('DivErrPage').dir = 'rtl';
			var errhtml = 'تم إجراء المحاولة مرات عديدة.';
		}
		else
		{
			var errhtml = 'Too many retrials.';
		}
		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		setDisable('Submit',1);
		
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum)) 
	{
		if(Language == 'arabic')
		{
			document.getElementById('DivErrPage').dir = 'rtl';
			var errhtml = "مجموعة الحساب/كلمة المرور غير صحيحة. يرجى إعادة المحاولة.";
		}
		else
		{
			var errhtml = 'Incorrect account/password combination. Please try again.';
		}
		
		SetDivValue("DivErrPage", errhtml);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{	
		if(Language == 'arabic')
		{	
			document.getElementById('DivErrPage').dir = 'rtl';
			var errhtml = 'تم إجراء المحاولة مرات عديدة، يرجى إعادة المحاولة بعد ' +  LockLeftTime + ' ثواني.';
		}
		else
		{
			var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
		}
		
		SetDivValue("DivErrPage", errhtml); 
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

function SubmitForm() {
    var Username = document.getElementById('txt_Username');
    var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;
  
	if (Language == "arabic")
	{
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
			alert("حقل الحساب من الحقول المطلوبة.");
			Username.focus();
        	return false;
		}
		
		if (Password.value == "") {
			alert("حقل كلمة المرور من الحقول المطلوبة.");
			Password.focus();
        	return false;
		}
	}
	else
	{

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
        	if (Language == "arabic")
        	{
        		alert("صدار المتصفح لديك قديم (إصدارات Internet Explorer السادس والسابع والثامن غير مدعومة). يتوجب عليك ترقية المتصفح إلى الإصدار التاسع أو الإصدارات الأحدث.");
        	}else{
           		alert("Your browser version is outdated (IE 6, IE 7, and IE 8 are not supported). You must upgrade your browser to IE 9 or later. ");
        	}
        }
    }
}

function LoadFrame()
{
	
	clearInterval(locklefttimerhandle);
    document.getElementById('txt_Username').focus();
    if (Language == "arabic")
    {
        document.getElementById('arabic').style.color = '#9b0000';
        document.getElementById('English').style.color = '#ffffff';
        document.getElementById('account').innerHTML = 'اسم المستخدم';
		document.getElementById('Password').innerHTML = 'كلمة المرور';
		document.getElementById('button').innerHTML = 'تسجيل الدخول';
		document.getElementById('footer').innerHTML = 'حقوق الطبع والنشر محفوظة لدى شركة © 2022 Huawei Technologies Co., Ltd. جميع الحقوق محفوظة.';
		document.getElementById('stc_dir').style.marginLeft ="";
    	document.getElementById('stc_dir').style.marginRight="120px";
    	document.getElementById('account').align = "left";
		document.getElementById('Password').align = "left";
		document.getElementById('ctruserclass').style.textAlign = "right";
		document.getElementById('ctrpwdclass').style.textAlign = "right";		
    	document.getElementById('stc_dir').dir = 'rtl';
    	document.getElementById('footer').dir = 'rtl';
    	document.getElementById('DivErrPage').dir = 'rtl';
    }
    else
    {	
		document.getElementById('arabic').style.color = '#ffffff';
	    document.getElementById('English').style.color = '#9b0000';
        document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved';
		document.getElementById('stc_dir').dir = '';
		document.getElementById('footer').dir = '';
		document.getElementById('account').align = "right";
		document.getElementById('Password').align = "right";
		document.getElementById('ctruserclass').style.textAlign = "left";
		document.getElementById('ctrpwdclass').style.textAlign = "left";
		document.getElementById('stc_dir').style.marginRight="";
		document.getElementById('stc_dir').style.marginLeft ='150px';
		 document.getElementById('txt_Username').focus();
    }

	
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

function onChangeLanguage(language)
{   
    Language = language;
    var Username = document.getElementById('txt_Username').value;
    if (language == 'arabic')
    {
        document.getElementById('arabic').style.color = '#9b0000';
        document.getElementById('English').style.color = '#ffffff';
		 document.getElementById('account').innerHTML = 'اسم المستخدم';
		document.getElementById('Password').innerHTML = 'كلمة المرور';
		document.getElementById('button').innerHTML = 'تسجيل الدخول';
		document.getElementById('footer').innerHTML = 'حقوق الطبع والنشر محفوظة لدى شركة © Huawei Technologies Co., Ltd 2022. جميع الحقوق محفوظة.';
        document.getElementById('stc_dir').style.marginLeft ="";
		document.getElementById('stc_dir').style.marginRight="120px";
		document.getElementById('account').align = "left";
		document.getElementById('Password').align = "left";
		document.getElementById('stc_dir').dir = 'rtl';
		document.getElementById('footer').dir = 'rtl';
		document.getElementById('DivErrPage').dir = 'rtl';
		document.getElementById('ctruserclass').style.textAlign = "right";
		document.getElementById('ctrpwdclass').style.textAlign = "right";
	
    }
    else if (language == 'english')
   	{
			document.getElementById('arabic').style.color = '#ffffff';
        document.getElementById('English').style.color = '#9b0000';
        document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd 2022. All rights reserved.';
		document.getElementById('stc_dir').style.marginRight="";
		document.getElementById('stc_dir').style.marginLeft ='150px';
		document.getElementById('account').align = "right";
		document.getElementById('Password').align = "right";
		document.getElementById('ctruserclass').style.textAlign = "left";
		document.getElementById('ctrpwdclass').style.textAlign = "left";		
		document.getElementById('stc_dir').dir = '';
		document.getElementById('footer').dir = '';
		document.getElementById('DivErrPage').dir = '';
			
	
    }
	if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
		||( "1" == FailStat) || (ModeCheckTimes >= errloginlockNum) ) 
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
}


</script>
</head>
<body  onLoad="LoadFrame();">
<form >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr height="326px" width="100%">
		<td>&nbsp;</td>
		<td width="658px" background="/images/a-login_bg.jpg" valign="top" align="center" style="background-size:100%;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td height = "85"></td>
				</tr>
			  <tr>
				<td height="25" align="center" >
					<table width="75%" height="25" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="33%"></td>
									<td align="center" width="15%">
														</td>
									<td class="hg_logo" width="13%" id="hg_logo" nowrap>
										<script language="JavaScript" type="text/javascript">
										
										</script>
								  </td>
									<td valign="bottom" width="30%">
										<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
											<tr>
												<td width="37%" nowrap>
													<a id="English" href="#" name="English" onClick="onChangeLanguage('english');" title="English" style="font-size:12px;font-family:Arial;">[English]</a></td>
												<td width="63%" nowrap>
													<a id="arabic" href="#" name="arabic" onClick="onChangeLanguage('arabic');" title="arabic" style="font-size:12px;font-family:Arial;">[العربية]</a></td>
											</tr>
										</table>
								  </td>
								  <td width="9%">
								  </td>
								</tr>
						</table>	
				</td>
			  </tr>
			  <tr>
				<td align="center" height="65"> 
						<div id="stc_dir">
						<table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="100%" style="font-size:16px;"> 
						  <tr> 
							<td class="whitebold" height="37" align="right" width="20%" id="account"></td> 
							<td class="whitebold" height="37" align="center" width="2%">:</td> 
							<td width="78%" id="ctruserclass"> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="32"> </td> 
						  </tr> 
						  <tr> 
							<td class="whitebold" height="28" align="right" id="Password"></td> 
							<td class="whitebold" height="28" align="center" >:</td> 
							<td id="ctrpwdclass"> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127" autocomplete="off"> 
				&nbsp; 
							  <button style="font-size:12px;font-family:Tahoma,Arial;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button"></button></td> 
						  </tr> 
						</table>
						</div>
					</td>  	
				</tr>
			  <tr>
				<td class="info_text" align="center" height="25" id="footer" ></td> 
			  </tr>
			   <tr>
						<td align="center">
							<table border="0" cellpadding="0" cellspacing="0" width="549" height="91" > 
							 <tr> 
						<td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none"> 
							<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%"> 
							  <tr> 
								<td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;"> 
								  <div id="DivErrPage"></div> 
								  </span> </td> 
							  </tr> 
							</table> 
						  </div></td> 
					  </tr> 
					</table></td> 
				</tr> 
				
			  </table> 
		 </td>
		<td>&nbsp;</td>
	</tr>
	<tr><td>
		<script type="text/javascript">
			var h = window.screen.availHeight-600;
		</script>
	</td></tr>
	</tr>
</td>
</table>
</table>
</form>
</body>
</html>

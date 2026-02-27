<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="Cuscss/<%HW_WEB_GetCusSource(login.css);%>"  media="all" rel="stylesheet" />
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
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var errVerificationCode = '<%HW_WEB_GetCheckCodeResult();%>';
var Language = '';
var locklefttimerhandle;

if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}

if ('ORO' == CfgMode.toUpperCase())
{
	ProductName = "Internet Box 1000";
}
document.title = ProductName;

function getValue(id)
{
    var item = getElement(id);
    if (item == null) {
        debug(id + " is not existed!");
        return -1;
    }
    return item.value;
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
		if(Language == 'portuguese')
		{
			var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde';
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundo/s.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
		}
		else
		{
			var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
		}
	}
	else
	{
		if(Language == 'portuguese')
		{
			var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
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

		if(Language == 'portuguese')
		{
			var errhtml = "Demasiadas tentativas.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "再試行回数が多すぎます。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "Ha intentado muchas veces.";
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток.';
		}
		else
		{
			var errhtml = 'Too many retrials.';
		}
		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
	}
    else if('2' == FailStat)
    {
        var errhtml = 'You IP address cannot be used for a login.';
		SetDivValue("DivErrPage", errhtml);
    }
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		if(Language == 'portuguese')
		{
			var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + ' 秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Слишком много попыток. Попробуйте снова через ' +  LockLeftTime + ' с.';
		}
		else
		{
			var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
		}

		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if( 1== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Incorrect validate code.");
	}
	else if( 2== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Login failure.");
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
		if(Language == 'portuguese')
		{
			var errhtml = "Nome de conta ou palavra-passe inválidos. Tente novamente.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "アカウントとパスワードの組み合わせが不正確です。 もう一度やり直してください。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "La combinación de la usuario/contraseña es incorrecta. Favor de volver a intentarlo.";
		}
		else if(Language == 'russian')
		{
			var errhtml = 'Неверное имя аккаунта или пароль. Повторите попытку.';
		}
		else if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
		{
			var errhtml = 'Login failure.';
		}
		else
		{
			var errhtml = 'Incorrect account/password combination. Please try again.';
		}

		SetDivValue("DivErrPage", errhtml);
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
	var CheckResult = 0;

	if(Language == "portuguese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("Versões IE inferiores a 6.0 não são compatíveis.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("Conta não pode ficar em branco.");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Palavra-passe não pode ficar em branco.");
			Password.focus();
			return false;
		}

	}
	else if(Language == "japanese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("6.0以前のIEバージョンには対応していません。");
				return false;
			}
		}

		if (Username.value == "") {
			alert("アカウントは必須項目です。");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("パスワードは必須項目です。");
			Password.focus();
			return false;
		}

	}
	else if(Language == "spanish")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("No se puede soportar la versión de IE inferior a la 6.0.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("La usuario es un campo obligatorio.");
			Username.focus();
			return false;
		}

		if (Password.value == "")
		{
			alert("La contraseña es un campo requerido.");
			Password.focus();
			return false;
		}
	}
	else if(Language == "russian")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("Версии браузера IE меньше 6.0 не поддерживаются.");
				return false;
			}
		}
		
		if (Username.value == "") {
			alert("Введите имя аккаунта.");
			Username.focus();
        	return false;
		}
		
	
		if (Password.value == "") {
			alert("Введите пароль.");
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
			if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
			{
				alert("User Name is a required field.");
			}
			else
			{
				alert("Account is a required field.");
			}
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Password is a required field.");
			Password.focus();
			return false;
		}

	}

	
	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date=new Date();
		date.setTime(date.getTime()-10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
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
	if('DT' == CfgMode.toUpperCase())
	{
		var cookie2 = "Cookie=" + "rid=" + RndSecurityFormat("" + cnt) + RndSecurityFormat(Username.value + cnt ) + RndSecurityFormat(RndSecurityFormat(MD5(Password.value)) + cnt) + ":" + "Language:" + Language + ":" +"id=-1;path=/";
	}
	else
	{
		var cookie2 = "Cookie=body:" + "Language:" + Language + ":" + "id=-1;path=/";
		Form.addParameter('UserName', Username.value);
		Form.addParameter('PassWord', base64encode(Password.value));
	}
	
	document.cookie = cookie2;
	Username.disabled = true;
	Password.disabled = true;

	if('TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
	{
		Form.addParameter('CheckCode', getValue('VerificationCode'));
		Form.setAction('login.cgi?' +'&CheckCodeErrFile=login.asp');
	}
	else
	{
		Form.setAction('/login.cgi');
	}
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

	var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';
	
	if(Language == "portuguese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Conta';
		document.getElementById('Password').innerHTML = 'Palavra-passe';
		document.getElementById('button').innerHTML = 'Iniciar sessão';
		
	}
	else if(Language == "japanese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'アカウント';
		document.getElementById('Password').innerHTML = 'パスワード';
		document.getElementById('button').innerHTML = 'ログイン';
		
	}
	else if(Language == "spanish")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Usuario';
		document.getElementById('Password').innerHTML = 'Contraseña';
		document.getElementById('button').innerHTML = 'Iniciar sesión';
		
	}
	else if(Language == "russian")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Аккаунт';
		document.getElementById('Password').innerHTML = 'Пароль';
		document.getElementById('button').innerHTML = 'Вход';
		
    }	
	else
	{
		document.getElementById('Specical_language').style.color = '#434343';
		document.getElementById('English').style.color = '#9b0000';
		if ( 'TRIPLET' == CfgMode.toUpperCase() || 'TRIPLETVOICE' == CfgMode.toUpperCase() || 'TRIPLET2' == CfgMode.toUpperCase())
		{
			document.getElementById('account').innerHTML = 'User Name';
		}
		else
		{
			document.getElementById('account').innerHTML = 'Username';
		}
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('button_cancel').innerHTML = 'Cancel';
	}

	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	init();
	
	if('VIETTEL' == CfgMode.toUpperCase())
	{
		var tiphtml = 'Tên truy nhập và mật khẩu của quý khách được in ở mặt đáy thiết bị ONT';
		SetDivValue("DivTipPage", tiphtml);
		document.getElementById('tipText').style.display = '';
	}
	
	if((UserLeveladmin == '0'))
	{
		if(Language == "portuguese")
		{
			alert("O administrador não tem autorização para abrir esta página de Internet.");
			return false;
		}
		else if(Language == "japanese")
		{
			alert("管理者はこのウェブページの閲覧を許可されていません。");
			return false;
		}
		else if (Language == "spanish")
		{
			alert("El administrador no puede abrir esta página.");
			return false;
		}
		else if (Language == "russian")
		{
			alert("У текущего пользователя нет права входа.");
			return false;
		}
		else
		{
			alert("The current user is not allowed to log in.");
			return false;
		}
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
function onChangeLanguage(language) {
	Language = language;
	if(language == "portuguese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Conta';
		document.getElementById('Password').innerHTML = 'Palavra-passe';
		document.getElementById('button').innerHTML = 'Iniciar sessão';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. Todos os direitos reservados.';
	}
	else if(language == "japanese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'アカウント';
		document.getElementById('Password').innerHTML = 'パスワード';
		document.getElementById('button').innerHTML = 'ログイン';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved.';
	}
	else if (language == "spanish")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Usuario';
		document.getElementById('Password').innerHTML = 'Contraseña';
		document.getElementById('button').innerHTML = 'Iniciar sesión';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Tecnologias Huawei Co., Ltd. Todos los derechos reservados.';
    }
	else if (language == "russian") 
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Аккаунт';
		document.getElementById('Password').innerHTML = 'Пароль';
		document.getElementById('button').innerHTML = 'Вход';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. Все права защищены.';
    }
	else 
	{
		document.getElementById('Specical_language').style.color = '#434343';
		document.getElementById('English').style.color = '#9b0000';
		document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('footer').innerHTML = 'Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved.';
	}
    
	if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
	   ||( "1" == FailStat) || (ModeCheckTimes >= errloginlockNum) )
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
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

function CompareString(srcstr,deststr)
{
	var reverestr=(srcstr.split("").reverse().join(""));
	if ( srcstr == deststr )
	{
		return false;
	}

	if (reverestr == deststr )
	{
		return false;
	}
	return true;
}

function SubmitCancel() 
{
	document.getElementById('txt_Username').value = '';
	document.getElementById('txt_Password').value = '';
}

function SubmitLanguage() 
{

}

</script>
</head>
<body onLoad="LoadFrame();">

<div id="base_mask" style=""></div>
<div id="main_wrapper">
  
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td align="center" height="170" valign="bottom"> 
			<table border="0" cellpadding="0" cellspacing="0" width="36%">
				<tr style="position: absolute; margin-left: -200px; margin-top: -180px;">
					<td class="hg_logo" width="21%" id="hg_logo" nowrap></td>
					<td valign="bottom" width="50%" style="padding-left: 427px;">
						<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
							<tr>
							  <script language="JavaScript" type="text/javascript">
								//语言选择暂时保留
								if ('ANTEL' == CfgMode.toUpperCase())
								{
									document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage(' + "'english'" + ');" style="font-size:12px;font-family:Arial;">[English]</a> </td>');
									document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language" onClick="onChangeLanguage(' + "'spanish'" + ');" style="font-size:12px;font-family:Arial;">[Spanish]</a> </td>');
								}
								else
								{
									document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" style="font-size:12px;font-family:Arial;"></a> </td>');
									document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language"  style="font-size:12px;font-family:Arial;"></a> </td>');
								}
							  </script>
							</tr></table></td></tr></table></td></tr>
	
	<tr>
		<td id="login_for_common" align="center" height="65px" style="padding-left:110px; padding-top:0;"> 
			<table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="55%" style="font-size:16px; padding-left: 30px;"> 
					<tr>
						<td class="whitebold" height="36px" align="center" width="27%" id="account" style="visibility:hidden;"></td>
						<td width="78%" style="text-align: left;"> <input style="font-weight: bold; font-size:14px;font-family:Tahoma,Arial; background: none; border: none; color: #fff; line-height: 21px; vertical-align: text-top;outline:none;margin-top: -7px;" id="txt_Username" class="input_username" name="txt_Username" type="text" maxlength="31"> </td>
					</tr>
					<tr style="line-height: 47px;">
						<td class="whitebold" height="28px" align="center" id="Password" style="visibility:hidden;"></td>
						<td style="text-align: left;"> <input style="font-weight: bold; font-size:14px;font-family:Tahoma,Arial; background: none; border: none; color: #fff; line-height: 21px;outline:none;" id="txt_Password" class="input_pwd" name="txt_Password" type="password" maxlength="127">&nbsp;</td>
					</tr>
			</table>
		</td>	
	</tr>
	</table>
	<div style="position: relative; margin-left: 378px; margin-top: 14px;">
		<tr style="height: 50px; " >
			<td>
				<button id="button"  style="margin-left: -20px;" class="submit_login" name="Submit" onClick="SubmitForm();" type="button"></button>
			</td>
			<td>
				<button  id="button_cancel" style="position: absolute; margin-left: 40px;" class="submit_cancel" name="Submit_Cancel" onClick="SubmitCancel();" type="button"></button>
			</td>
		</tr>
	</div>

	<div class="zain_logo" style="position: absolute; margin-left: 275px; margin-top: -250px; ">
		<script language="JavaScript" type="text/javascript">
			document.write("Zain  ");
			document.write(ProductName);
		</script>
	</div>
	<div class="zain_logo" style="position: absolute; margin-left: 900px; margin-top: -260px; ">
		<button  id="button_language" class="submit_language"  name="Submit_Language" onClick="SubmitLanguage();" type="button">English</button>
	</div>
	<div id="loginfail" style="display: none; position: absolute; padding-left: 325px; padding-top: 60px; color: #e0218a; font: 16px Arial, ����;">
		<div id="DivErrPage"></div>
	</div>
	
</div>

</body>
</html>

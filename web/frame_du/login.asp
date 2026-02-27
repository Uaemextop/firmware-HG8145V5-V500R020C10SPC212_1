<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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

/*底层遮罩样式*/
#base_mask {
	width:100%;
	height:100%;
	position:absolute;
	left:0px;
	right:0px;
	z-index:2;	/*底层遮罩的z-index为2*/
	filter: alpha(opacity=60);
	-moz-opacity: 0.6;
	-khtml-opacity: 0.6;
	opacity: 0.8;
	background-color:#eeeeee;
	display:none;
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
        debug(id + " is not existed" );
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

function MouseProcess()
{
	$("#link_OurStores").mouseover(function() {
		$("#link_OurStores").css({
			"text-decoration" : "underline",
			"opacity" : "1"
		});
	});
	$("#link_OurStores").mouseout(function() {
		$("#link_OurStores").css({
			"text-decoration" : "none",
			"opacity" : "0.8"
		});
	});
	$("#link_ContaceUs").mouseover(function() {
		$("#link_ContaceUs").css({
			"text-decoration" : "underline",
			"opacity" : "1"
		});
	});
	$("#link_ContaceUs").mouseout(function() {
		$("#link_ContaceUs").css({
			"text-decoration" : "none",
			"opacity" : "0.8"
		});
	});
	$("#link_f").mouseover(function() {
		$("#link_f").css({
			"opacity" : "1"
		});
	});
	$("#link_f").mouseout(function() {
		$("#link_f").css({
			"opacity" : "0.8"
		});
	});
	$("#link_bird").mouseover(function() {
		$("#link_bird").css({
			"opacity" : "1"
		});
	});
	$("#link_bird").mouseout(function() {
		$("#link_bird").css({
			"opacity" : "0.8"
		});
	});
	$("#link_in").mouseover(function() {
		$("#link_in").css({
			"opacity" : "1"
		});
	});
	$("#link_in").mouseout(function() {
		$("#link_in").css({
			"opacity" : "0.8"
		});
	});
	$("#link_tube").mouseover(function() {
		$("#link_tube").css({
			"opacity" : "1"
		});
	});
	$("#link_tube").mouseout(function() {
		$("#link_tube").css({
			"opacity" : "0.8"
		});
	});
	$("#button").mouseover(function() {
		$("#button").css({
			"background-color" : "#d2d2d2"
		});
	});
	$("#button").mouseout(function() {
		$("#button").css({
			"background-color" : "#ffffff"
		});
	});
}
function LoadFrame() 
{
	document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);

	var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';
	MouseProcess();
	
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
			document.getElementById('account').innerHTML = 'Account';
		}
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
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
	}
	else if(language == "japanese")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'アカウント';
		document.getElementById('Password').innerHTML = 'パスワード';
		document.getElementById('button').innerHTML = 'ログイン';
	}
	else if (language == "spanish")
	{
		document.getElementById('Specical_language').style.color = '#9b0000';
		document.getElementById('English').style.color = '#434343';
		document.getElementById('account').innerHTML = 'Usuario';
		document.getElementById('Password').innerHTML = 'Contraseña';
		document.getElementById('button').innerHTML = 'Iniciar sesión';
    }
	else if (language == "russian") 
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
		document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
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

</script>
</head>
<body onLoad="LoadFrame();">

<div id="base_mask" style=""></div>
<div id="main_wrapper">

<div style="position:absolute; top:350px;margin-left:250px;height:300px; width:490px;">

<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
	<td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none">
		<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%">
		  <tr>
			<td align="center" height="21"> <span style="color:red;font-size:16px;font-family:DuCoHeadline;">
			  <div id="DivErrPage"></div>
			  </span> </td> </tr> </table> </div> </td> </tr>
</table>
</div>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<script language="JavaScript" type="text/javascript">
			document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="36%"> ');
		</script>
		<tr>
			<script language="JavaScript" type="text/javascript">
				document.write('<td align="center" width="29%"> ');
				document.write('<img height="80" src="images/logo_du.gif" width="100" alt="">');
			</script>
			</td>
			<script language="JavaScript" type="text/javascript">
				document.write('<td class="hg_logo" width="21%" id="hg_logo" nowrap>');
				document.write(ProductName);
				document.write('</td>');
				document.write('<td valign="bottom" width="50%">');
			</script>
			<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
				<tr>
				  <script language="JavaScript" type="text/javascript">
					document.write('<td width="47%" nowrap> <a id="English" href="#" name="English" style="font-size:12px;font-family:Arial;"></a> </td>');
					document.write('<td width="53%" nowrap> <a id="Specical_language" href="#" name="Specical_language"  style="font-size:12px;font-family:Arial;"></a> </td>');
				  </script>
				</tr>
			  </table></td>
		  </tr>
		</table></td>
	</tr>
	<tr>
      <td id="login_for_common" align="center" height="120px"> <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="45%" style="font-size:16px;">
		  <tr>
			<td class="whitebold" height="60" align="right" width="20%" id="account"></td>
			<td class="whitebold" height="60" align="center" width="2%">:</td>
			<td width="50%" style="text-align: left;"> <input style="font-size:16px;font-family:DuCoHeadline;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="31"> </td>
			<td width="28%" style="text-align: left;"></td>
		  </tr>
		  <tr>
			<td class="whitebold" height="60" align="right" id="Password"></td>
			<td class="whitebold" height="60" align="center" >:</td>
			<td style="text-align: left;"> <input style="font-size:14px;font-family:DuCoHeadline;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127"></td>
			<td style="text-align: left;">
			<button style="font-size: 16px; font-family: DuCoHeadline; width: 60px; height: 35px; color: #0099cc; background-color: #ffffff; line-height:32px;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button"></button>
			</td>
		</tr>


		</table></td>
	</tr>
	</table>

	<div style="position:relative;margin-left:360px; margin-top: 220px;">
	<div style="position:relative;margin-left:20px;top:-85px;height:40px;width:200px;">
		<a id="link_OurStores" style="color:#ffffff; font-family:DuCoHeadline; font-size:14px; text-decoration:none; opacity:0.8 " href="http://www.du.ae/personal/helpandsupport/ourshops" target="_black">Our Stores</a>
		<a style="color:#ffffff; font-family:DuCoHeadline; font-size:14px; text-decoration:none ">&nbsp;|&nbsp;</a>
		<a id="link_ContaceUs" style="color:#ffffff; font-family:DuCoHeadline; font-size:14px; text-decoration:none; opacity:0.8 " href="http://www.du.ae/personal/helpandsupport/contact-us" target="_black">Contact us</a>
	</div>
	<div id="link_f" style="position:relative;margin-left:25px;top:-85px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.facebook.com/du" target="_black">
			<img style="border:none;" src="images/ico_f.gif">
		</a>
	</div>
	<div id="link_bird" style="position:relative;margin-left:65px;top:-125px;height:40px;width:40px; opacity:0.8">
		<a href="https://twitter.com/dutweets" target="_black">
			<img style="border:none;" src="images/ico_bird.gif">
		</a>
	</div>
	<div id="link_in" style="position:relative;margin-left:105px;top:-165px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.linkedin.com/company/du/" target="_black">
			<img style="border:none;" src="images/ico_in.gif">
		</a>
	</div>
	<div id="link_tube" style="position:relative;margin-left:145px;top:-205px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.youtube.com/user/theduchannel" target="_black">
			<img style="border:none;" src="images/ico_tube.gif">
		</a>
	</div>	
	</div>
</div>
</body>
</html>

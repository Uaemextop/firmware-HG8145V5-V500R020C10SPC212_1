<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"/>
<title>ACCESS</title>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script>
function MD5(str) { return hex_md5(str); }
function stUserInfo(UserName,HintPassword) {
    this.UserName = UserName;
    this.HintPassword = HintPassword;
}
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var Language = '';
var UserInfo = <%HW_WEB_GetTelmexUserName(stUserInfo);%>;
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var IsDefaultPwd = '<%IsDefaultPwd();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var defaultString = "WPA KEY";
var locklefttimerhandle;
var UserName = UserInfo[0].UserName;
var HintPassword = UserInfo[0].HintPassword;
if (Var_LastLoginLang == '') {
    Language = Var_DefaultLang;
} else {
    Language = Var_LastLoginLang;
}

function LoadFrame() {
    cover.style.display = "block";
    toast.style.display = "block";
    toast.style.position = "fixed";
    var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';
    if (Language == "spanish") {
        document.getElementById('Spanish').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
        document.getElementById('account').innerHTML = 'Usuario';
        document.getElementById('Password').innerHTML = 'Contraseña';
        document.getElementById('button').innerHTML = 'Iniciar sesión';
    } else {
        document.getElementById('Spanish').style.color = '#434343';
        document.getElementById('English').style.color = '#9b0000';
        document.getElementById('account').innerHTML = 'User';
        document.getElementById('Password').innerHTML = 'Password';
        document.getElementById('button').innerHTML = 'Login';
    }
    if ((UserLeveladmin == '0')) {
        if (Language == "spanish") {
            alert("El administrador no puede abrir esta página.");
        } else {
            alert("Administrator is not allowed to open this Web page.");
        }
    }
    if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
        document.getElementById('loginfail').style.display = '';
        if (LoginTimes >= errloginlockNum) {
            document.getElementById('hintpwd').style.display = '';
        }
        setErrorStatus();
    }
    if (FailStat == "1" || (ModeCheckTimes >= errloginlockNum)) {
        document.getElementById('loginfail').style.display = '';
        if (LoginTimes >= errloginlockNum) {
            document.getElementById('hintpwd').style.display = '';
        }
        setErrorStatus();
    }
    init();
 }

function onChangeLanguage(language) {
    Language = language;
    if (language == "spanish") {
        document.getElementById('Spanish').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
        document.getElementById('account').innerHTML = 'Usuario';
        document.getElementById('Password').innerHTML = 'Contraseña';
        document.getElementById('button').innerHTML = 'Iniciar sesión';
    } else {
        document.getElementById('Spanish').style.color = '#434343';
        document.getElementById('English').style.color = '#9b0000';
        document.getElementById('account').innerHTML = 'User';
        document.getElementById('Password').innerHTML = 'Password';
        document.getElementById('button').innerHTML = 'Login';
    }
    if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
        ||(FailStat == "1") || (ModeCheckTimes >= errloginlockNum) ) {
        document.getElementById('loginfail').style.display = '';
        setErrorStatus();
    }
}

function showlefttime() {
    if (LockLeftTime <= 0) {
        window.location="/remoteaccess/access.asp";
        return;
    }

    if (LockLeftTime == 1) {
        if(Language == 'english') {
            var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
        } else {
            var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundo/s.';
        }
    } else {
        if(Language == 'english') {
            var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
        } else {
            var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
        }
    }

    SetDivValue("DivErrPage", errhtml);
    LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus() {
    var HintPasswordExpand = HintPassword.toString().replace(/ /g,"&nbsp;");
    clearInterval(locklefttimerhandle);
    if (FailStat == '1' || (ModeCheckTimes >= errloginlockNum)) {
        if (Language == 'english') {
            var errhtml = "Too many retrials.";
        } else {
            var errhtml = "Ha intentado muchas veces.";
        }

        SetDivValue("DivErrPage", errhtml);
        setDisable('user',1);
        setDisable('password',1);
        setDisable('Submit',1);
    } else if((LoginTimes > 0) && (LoginTimes < errloginlockNum)) {
        if (Language == 'english') {
            var errhtml = "Incorrect user/password combination. Please try again.";
        } else {
            var errhtml = "La combinación del usuario/contraseña es incorrecta. Favor de volver a intentarlo.";
        }
        SetDivValue("DivErrPage", errhtml);
    } else if (LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0) {
        if (Language == 'english') {
            var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
            var defaulthtml = "The default password of your device is the " + defaultString + ".";
            var hinthtml = "Your hint password is: "+HintPasswordExpand+".";
        } else {
            var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
            var defaulthtml = "La contraseña predeterminada es la " + defaultString + " de su equipo.";
            var hinthtml = "El recordatorio de la contraseña es la clave: "+HintPasswordExpand+".";
        }

        SetDivValue("DivErrPage", errhtml);
        SetDivValue("DivErrPage2", defaulthtml);
        SetDivValue("DivHintPasswordPage", hinthtml);
        setDisable('user',1);
        setDisable('password',1);
        setDisable('Submit',1);
        locklefttimerhandle = setInterval('showlefttime()', 1000);
    } else {
        document.getElementById('loginfail').style.display = 'none';
    }
}
</script>
</head>
<style type="text/css">
*{margin: 0;padding: 0};
</style>
<body onLoad="LoadFrame();">
<div id="cover" style="display: none;position: fixed;width: 100%;height: 100%;top:0px;left:0px;background: gray;"></div>
<div style="background: #93b2ce;width:580px;height:310px;margin:0 auto;display:none;" id="toast">  
    <div id="checkForm" style="width: 70%;margin: 8% auto;">
        <div>
		<table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="40%" style="margin-bottom:20px;">
			<tr>
				<td width="47%" nowrap> <a id="English" href="#" name="English" onClick="onChangeLanguage('english');" title="English" style="font-size:12px;font-family:Arial;">[English]</a> </td>
				<td width="53%" nowrap> <a id="Spanish" href="#" name="Spanish" onClick="onChangeLanguage('spanish');" title="Español" style="font-size:12px;font-family:Arial;">[Español]</a> </td>
			</tr>
	    </table>
		</div>
        <div style="margin-bottom:20px;">
            <label for="user" style="width:30%;display:inline-block;" id="account"></label>
            <input type="text" id="user" style="width:60%;height:30px;text-indent:10px;">
        </div>
        <div style="margin-bottom:20px;">
            <label for="password" style="width:30%;display:inline-block;" id="Password"></label>
            <input type="password" id="password" style="width:60%;height:30px;text-indent:10px;">
        </div>
        <p style="text-align:center;width:100%;color:red;margin-bottom:10px;" id="checkWord"></p>
        <div style="text-align:center;margin-bottom:15px;">
		    <button style="font-size: 14px;width: 100px;height: 40px;line-height: 40px;text-align: center;cursor: pointer;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button"></button>
        </div>
		<div id="hintpwd" style="display: none;margin-bottom:8px;">
		    <p id="DivHintPasswordPage" style="color:red;font-size:12px;font-family:Arial;text-align:center;"></p>
		</div>
		<div id="loginfail" style="display: none;margin-bottom:8px;">
		    <p id="DivErrPage" style="color:red;font-size:12px;font-family:Arial;text-align:center;"></p>
			<script>
			    if (LoginTimes >= errloginlockNum && IsDefaultPwd == 1) {
					document.write("<p id='DivErrPage2' style='color:red;font-size:12px;font-family:Arial;text-align:center;'>");
					document.write("</p>");
				}
			</script>
		</div>
    </div>    
</div>
<script type="text/javascript">
var toast = document.getElementById("toast");
var cover = document.getElementById("cover");

function stNormalUserInfo(UserName, ModifyPasswordFlag, InstantNo) {
    this.UserName = UserName;
    this.ModifyPasswordFlag = ModifyPasswordFlag;
    this.InstantNo = InstantNo;
}

var UserInfo = <%HW_WEB_GetNormalUserInfo(stNormalUserInfo);%>;
var userName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2.UserName);%>';

function SubmitForm() {
    var user = document.getElementById('user');
    var password = document.getElementById('password');
    var appName = navigator.appName;
    var version = navigator.appVersion;

    if (Language == "spanish") {
        if (appName == "Microsoft Internet Explorer") {
            var versionNumber = version.split(" ")[3];
            if (parseInt(versionNumber.split(";")[0]) < 6) {
                alert("No se puede soportar la versión de IE inferior a la 6.0.");
            }
        }
        if (user.value == "") {
            alert("La usuario es un campo obligatorio.");
            user.focus();
            return;
        }
        if (password.value == "") {
            alert("La contraseña es un campo requerido.");
            password.focus();
            return;
        }
    } else {
        if (appName == "Microsoft Internet Explorer") {
            var versionNumber = version.split(" ")[3];
            if (parseInt(versionNumber.split(";")[0]) < 6) {
                alert("We cannot support the IE version which is lower than 6.0.");
            }
        }
        if (user.value == "") {
            alert("User is a required field.");
            user.focus();
            return;
        }
        if (password.value == "") {
            alert("Password is a required field.");
            password.focus();
            return;
        }
    }
    var cnt;
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : '../asp/GetRandCount.asp',
        success : function(data) {
        cnt = data;
        }
    });

    var Form = new webSubmitForm();
    var cookie2 = "Cookie=body:" + "Language:" + Language + ":SubmitType=SetSsh" + ":" + "id=-1;path=/";
    Form.addParameter('UserName', user.value);
    Form.addParameter('PassWord', base64encode(password.value));
    document.cookie = cookie2;
    user.disabled = true;
    password.disabled = true;
    Form.addParameter('x.X_HW_Token', cnt);
    Form.setAction('../login.cgi?'+'&CheckCodeErrFile=remoteaccess/access.asp');
    Form.submit();
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

$(function() {
    function boxAuto() {
        var dom = $("#toast");
        var w =  dom.innerWidth();
        var h =  dom.innerHeight();
        var t = ($(window).height() - h) / 2;
        var l = ($(window).width() - w) / 2;
        dom.css("top",t);
        dom.css("left",l);
    }
    boxAuto();
    $(window).resize(function() {
        boxAuto();
    })
});
</script>
</body>
</html>
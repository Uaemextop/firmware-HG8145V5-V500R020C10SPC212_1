<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1" />
    <title></title>
    <link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>" media="all" rel="stylesheet" />
    <style type="text/css">
        #first {
            background-color: white;
            height: 25px;
            text-align: center;
            color: red;
            position: absolute;
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
        var LoginTimes = '<%WEB_GetSecondLoginFailCount();%>';
        var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
        var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
        var Language = '';
        var LockLeftTime = '<%WEB_GetSecondLeftLockTime();%>';
        var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
        var locklefttimerhandle;

        if (Var_LastLoginLang == '') {
            Language = Var_DefaultLang;
        } else {
            Language = Var_LastLoginLang;
        }

        function showlefttime() {
            if (LockLeftTime <= 0) {
                window.location = "/remoteandvoip.asp";
                return;
            }

            if (LockLeftTime == 1) {
                if (Language == 'english') {
                    var errhtml = 'Too many retrials, please retry ' + LockLeftTime + ' seconds later.';
                } else {
                    var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' + LockLeftTime + ' segundo/s.';
                }
            } else {
                if (Language == 'english') {
                    var errhtml = 'Too many retrials, please retry ' + LockLeftTime + ' seconds later.';
                } else {
                    var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' + LockLeftTime + ' segundos.';
                }
            }

            SetDivValue("DivErrPage", errhtml);
            LockLeftTime = LockLeftTime - 1;
        }

        function setErrorStatus() {
            clearInterval(locklefttimerhandle);
            if ((LoginTimes > 0) && (LoginTimes < errloginlockNum)) {
                if (Language == 'english') {
                    var errhtml = "Incorrect password combination. Please try again.";
                } else {
                    var errhtml = "La combinación del contraseña es incorrecta. Favor de volver a intentarlo.";
                }

                SetDivValue("DivErrPage", errhtml);
            } else if (LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0) {
                if (Language == 'english') {
                    var errhtml = 'Too many retrials, please retry ' + LockLeftTime + ' seconds later.';
                } else {
                    var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' + LockLeftTime + ' segundos.';
                }

                SetDivValue("DivErrPage", errhtml);
                setDisable('txt_Password', 1);
                setDisable('Submit', 1);
                locklefttimerhandle = setInterval('showlefttime()', 1000);
            } else {
                document.getElementById('loginfail').style.display = 'none';
            }
        }

        function SubmitForm() {
            var Password = document.getElementById('txt_Password');
            var appName = navigator.appName;
            var version = navigator.appVersion;

            if (Language == "spanish") {
                if (appName == "Microsoft Internet Explorer") {
                    var versionNumber = version.split(" ")[3];
                    if (parseInt(versionNumber.split(";")[0]) < 6) {
                        alert("No se puede soportar la versión de IE inferior a la 6.0.");
                        return false;
                    }
                }

                if (Password.value == "") {
                    alert("La contraseña es un campo requerido.");
                    Password.focus();
                    return false;
                }

            } else {
                if (appName == "Microsoft Internet Explorer") {
                    var versionNumber = version.split(" ")[3];
                    if (parseInt(versionNumber.split(";")[0]) < 6) {
                        alert("We cannot support the IE version which is lower than 6.0.");
                        return false;
                    }
                }

                if (Password.value == "") {
                    alert("Password is a required field.");
                    Password.focus();
                    return false;
                }

            }
            var checkResult = 0;

            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: '/asp/secondLogin.asp',
                data: 'password=' + base64encode(Password.value) + '&RequestFile=remoteandvoip.asp',
                success: function (data) {
                    checkResult = data;
                }
            });
            if (checkResult == 1) {
                window.location = 'relocation.asp';
            } else {
                window.location = 'remoteandvoip.asp';
            }

            return true;
        }

        function LoadFrame() {
            clearInterval(locklefttimerhandle);
            document.getElementById('txt_Password').focus();

            if (Language == "spanish") {
                document.getElementById('Password').innerHTML = 'Contraseña';
                document.getElementById('button').innerHTML = 'Iniciar sesión';
            } else {
                document.getElementById('Password').innerHTML = 'Password';
                document.getElementById('button').innerHTML = 'Login';
            }

            if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
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
    </script>
</head>

<body onLoad="LoadFrame();">
    <div id="main_wrapper" style="width:725px">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td align="center" height="170" valign="bottom" />
            </tr>

            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" height="40" width="490" style="background-color: none">
                        <tr>
                            <td valign="top" style="padding-top: 0px;" />
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td align="center" height="65">
                    <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="52%" style="font-size:16px;">
                        <tr>
                            <td class="whitebold" height="28" align="right" id="Password">Password</td>
                            <td class="whitebold" height="28" align="center">:</td>
                            <td align="left">
                                <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127" autocomplete="off"> &nbsp;
                                <button style="font-size:12px;font-family:Tahoma,Arial;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button">Login</button></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="info_text" height="25" id="footer"></td>
            </tr>
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" height="300" width="490"
                        style="background: url('images/pic.jpg') no-repeat center;">
                        <tr>
                            <td valign="top" style="padding-top: 20px;">
                                <div id="loginfail" style="display: none">
                                    <table border="0" cellpadding="0" cellspacing="5" height="33" width="99%">
                                        <tr>
                                            <td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;">
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
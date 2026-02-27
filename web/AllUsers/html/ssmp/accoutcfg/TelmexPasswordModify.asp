<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <link rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
    <link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script language="JavaScript" type="text/javascript">

        var pwdLen = '<%HW_WEB_GetSPEC(SPEC_SSMP_CHKPWD_LENGTH.UINT32);%>';

        function stUserInfo(UserName, HintPassword) {
            this.UserName = UserName;
            this.HintPassword = HintPassword;
        }

        var UserInfo = <%HW_WEB_GetTelmexUserName(stUserInfo);%>;
        var UserName = UserInfo[0].UserName;

        function stModifyUserInfo(domain, UserName, ModifyPasswordFlag) {
            this.domain = domain;
            this.UserName = UserName;
            this.ModifyPasswordFlag = ModifyPasswordFlag;
        }

        var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|ModifyPasswordFlag, stModifyUserInfo);%>;
        var PwdModifyFlag = 1;


        for (var i = 0; i < stModifyUserInfos.length - 1; i++) {
            if (UserName == stModifyUserInfos[i].UserName) {
                PwdModifyFlag = stModifyUserInfos[i].ModifyPasswordFlag;
                break;
            }
        }

        if ((parseInt(PwdModifyFlag, 10) == 0)) {
            PwdModifyFlag = 0;
        }

        if (PwdModifyFlag == 0) {
            AlertEx(GetLanguageDesc("s1118h"));
        } else {
            window.location = "/html/ssmp/accoutcfg/TelmexWlanPwdModify.asp";
        }

        function isValidAscii(val) {
            for (var i = 0; i < val.length; i++) {
                var ch = val.charAt(i);
                if (ch <= ' ' || ch > '~') {
                    return false;
                }
            }
            return true;
        }

        function TelmexComplex() {
            var newPassword = document.getElementById("newPassword").value;
            var OldPasswordPwd = document.getElementById("OldPasswordPwd").value;

            if (newPassword == "") {
                return true;
            }

            if (newPassword.length < 10) {
                AlertEx(GetLanguageDesc("s1118gg"));
                return false;
            }

            if (!isLowercaseInString(newPassword)) {
                AlertEx(GetLanguageDesc("s1118e"));
                return false;
            }

            if (!isUppercaseInString(newPassword)) {
                AlertEx(GetLanguageDesc("s1118d"));
                return false;
            }

            if (!isDigitInString(newPassword)) {
                AlertEx(GetLanguageDesc("s1118b"));
                return false;
            }

            if (!isSpecialCharacterNoSpace(newPassword)) {
                AlertEx(GetLanguageDesc("s1118f"));
                return false;
            }

            if (OldPasswordPwd == newPassword) {
                AlertEx(GetLanguageDesc("s1118c"));
                return false;
            }

            return true;
        }

        function CheckParameter() {
            var newPassword = document.getElementById("newPassword");
            var cfmPassword = document.getElementById("cfmPassword");
            var OldPasswordPwd = document.getElementById("OldPasswordPwd");

            if (OldPasswordPwd.value == "") {
                AlertEx(GetLanguageDesc("s0f0f"));
                return false;
            }

            var NormalPwdInfo = FormatUrlEncode(OldPasswordPwd.value);
            var CheckResult = 0;

            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: "/html/ssmp/common/CheckAdminPwd.asp?&1=1",
                data: 'NormalPwdInfo=' + NormalPwdInfo,
                success: function (data) {
                    CheckResult = data;
                }
            });

            if (CheckResult != 1) {
                AlertEx(GetLanguageDesc("s0f11"));
                return false;
            }

            if (!TelmexComplex()) {
                return false;
            }

            if (newPassword.value == "") {
                AlertEx(GetLanguageDesc("s0f02"));
                return false;
            }

            if (newPassword.value.length > 127) {
                AlertEx(GetLanguageDesc("s1904"));
                return false;
            }

            if (!isValidAscii(newPassword.value)) {
                AlertEx(GetLanguageDesc("s0f04"));
                return false;
            }

            if (cfmPassword.value != newPassword.value) {
                AlertEx(GetLanguageDesc("s0f06"));
                return false;
            }

            if (!CheckPwdIsComplex(newPassword.value)) {
                AlertEx(GetLanguageDesc("s1902"));
                return false;
            }

            setDisable('ModifyPwdApply', 1);
            setDisable('ModifyPwdCancel', 1);

            return true;
        }

        function SubmitPwd() {
            if (!CheckParameter()) {
                return false;
            }
            var parainfo = "";
            parainfo = 'x.Password=' + FormatUrlEncode(getValue('newPassword')) + "&";
            parainfo += 'x.OldPassword=' + FormatUrlEncode(getValue('OldPasswordPwd')) + "&";
            parainfo += 'x.X_HW_Token=' + getValue('onttoken');
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                data: parainfo,
                url: "setajax.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2&RequestFile=html/ssmp/accoutcfg/TelmexPasswordModify.asp",
                success: function (data) {
                    var StrCode = "\"" + data + "\"";
                    var ResultInfo = eval("(" + eval(StrCode) + ")");
                    if (0 == ResultInfo.result) {
                        AlertEx(GetLanguageDesc("s0f0e"));
                        window.location = "/html/ssmp/accoutcfg/TelmexWlanPwdModify.asp";
                    }
                    else {
                        AlertEx(GetLanguageDesc("s2200"));
                    }
                },
                complete: function (XHR, TS) {
                    XHR = null;
                    setDisable('ModifyPwdApply', 0);
                    setDisable('ModifyPwdCancel', 0);
                }
            });
        }

        function GetLanguageDesc(Name) {
            return AccountLgeDes[Name];
        }

        function Skip() {
            window.location = "/html/ssmp/accoutcfg/TelmexWlanPwdModify.asp";
        }

    </script>
</head>

<body class="mainbody" style="margin: 0 auto; width: 50%;background: #fff;border: 1px solid #E2E2E2">
    <script language="JavaScript" type="text/javascript">
    </script>
    <div class="title_spread"></div>
    <table width="100%" height="10" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td id="defaultpwdnotice"></td>
        </tr>
    </table>

    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
        <tr id="secUsername">
            <td class="width_per40">
                <table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF" class="tabal_bg">
                    <tr>
                        <td class="table_title_pwd width_per60" BindText="s0f08"></td>
                        <td class="table_right_pwd">
                            <script language="JavaScript" type="text/javascript">
                                document.write(htmlencode(UserName));
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="table_title_pwd width_per60" BindText="s0f13"></td>
                        <td class="table_right_pwd">
                            <input name='OldPasswordPwd' type="password" autocomplete="off" id="OldPasswordPwd"
                                size="15">
                        </td>
                    </tr>
                    <tr>
                        <td class="table_title_pwd width_per60" BindText="s0f09"></td>
                        <td class="table_right_pwd">
                            <input name='newPassword' type="password" autocomplete="off" id="newPassword" size="15">
                            <script>
                                $('#newPassword').blur(function () {
                                    TelmexComplex();
                                });
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="table_title_pwd width_per60" BindText="s0f0b"></td>
                        <td class="table_right_pwd"><input name='cfmPassword' type='password' autocomplete="off"
                                id="cfmPassword" size="15"></td>
                    </tr>

                </table>
            </td>

            <script language="JavaScript" type="text/javascript">
                if (pwdLen == 10) {
                    document.write('<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1118aa" ></td>');
                }
                else {
                    document.write('<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1118gg" ></td>');
                }
            </script>
        </tr>
    </table>

    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
        <tr>
            <td class="table_submit width_per25"></td>
            <td class="table_submit">
                <input class="ApplyButtoncss buttonwidth_100px" name="ModifyPwdApply" id="ModifyPwdApply" type="button"
                    onClick="SubmitPwd();" BindText="s0f0c">
                <input class="CancleButtonCss buttonwidth_100px" name="ModifyPwdCancel" id="ModifyPwdCancel"
                    type="button" onClick="Skip();" BindText="s2003">
            </td>
        </tr>
    </table>
    <div id="websslpage" style="display:none;">
        <div class="func_spread"></div>
        <div class="func_title" BindText="s0d23"></div>
        <form id="WebcertCfgForm">
            <table id="WebcertCfgFormPanel" class="tabal_bg" width="100%" cellspacing="1" cellpadding="0">
                <li id="WebCertificateEnable" RealType="CheckDivBox" DescRef="s0d25" RemarkRef="Empty"
                    ErrorMsgRef="Empty" Require="FALSE" BindField="x.Enable"
                    InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:310px; border:solid 1px #999999; background:#edeef0;'}]}]"
                    ClickFuncApp="onClick=SetCertificateInfo" />
                <li id="WebcertPassword" RealType="TextBox" DescRef="s0d26" RemarkRef="s1905a" ErrorMsgRef="Empty"
                    Require="FALSE" BindField="x.CertPassword"
                    ClickFuncApp="onmouseover=title_show;onmouseout=title_back" />
                <li id="WebCfmPassword" RealType="TextBox" DescRef="s0d28" RemarkRef="s1905a" ErrorMsgRef="Empty"
                    Require="FALSE" BindField="CfmPassword" InitValue="Empty" />
            </table>
            <script>
                var WebcertCfgFormList = new Array();
                WebcertCfgFormList = HWGetLiIdListByForm("WebcertCfgForm", null);
                var TableClass = new stTableClass("width_per20", "width_per80", "");
                HWParsePageControlByID("WebcertCfgForm", TableClass, AccountLgeDes, null);
            </script>
            <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
                <tr>
                    <td class="width_per30"></td>
                    <td class="table_submit">
                        <input class="ApplyButtoncss buttonwidth_100px" name="PWDbtnApply" id="PWDbtnApply"
                            type="button" BindText="s0d21" onClick="AddSubmitImportcert();">
                        <input class="CancleButtonCss buttonwidth_100px" name="PWDcancelValue" id="PWDcancelValue"
                            type="button" BindText="s0d22" onClick="CancelConfigPwd();">
                    </td>
                </tr>
            </table>
        </form>
        <div class="func_spread"></div>
        <form action="websslcert.cgi?RequestFile=html/ssmp/accoutcfg/TelmexMdyAdminPwd.asp" method="post"
            enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
            <div>
                <div class="func_title" BindText="s0d29"></div>
                <table>
                    <tr>
                        <td BindText="s0d2a"></td>
                        <td>
                            <div class="filewrap">
                                <div class="fileupload">
                                    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                                    <input type="text" id="f_file" autocomplete="off" readonly="readonly" />
                                    <input type="file" name="browse" id="t_file" size="1" onblur="StartFileOpt();"
                                        onchange="fchange();" />
                                    <input id="btnBrowse" type="button" class="CancleButtonCss filebuttonwidth_100px"
                                        BindText="s0d2b" />
                                </div>
                            </div>
                        </td>
                        <td> <input class="CancleButtonCss filebuttonwidth_100px" id="ImportCertification"
                                name="btnSubmit" type='button' onclick='uploadCert();' BindText="s0d2c" /> </td>
                    </tr>
                </table>
            </div>
        </form>
        <div class="func_spread"></div>
    </div>

    <script>
        var ele = document.getElementById("WebcertPassword");
        ele.setAttribute('title', '');

        ele = document.getElementById("WebCfmPassword");
        ele.setAttribute('title', '');

        ParseBindTextByTagName(AccountLgeDes, "div", 1);
        ParseBindTextByTagName(AccountLgeDes, "td", 1);
        ParseBindTextByTagName(AccountLgeDes, "input", 2);
    </script>
</body>

</html>
<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script language="JavaScript" type="text/javascript">

        function stWlanSSID(domain, ssid, rfBand) {
            this.domain = domain;
            this.ssid = ssid;
            this.rfBand = rfBand;
        }

        var WlanSsid = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, SSID|X_HW_RFBand, stWlanSSID);%>;
        var WlanSsidLen = WlanSsid.length - 1;
        var ssidName2G = "";
        var ssidName5G = "";
        var nameFlag = "";
        var index2G = -1;
        var index5G = -1;
        for (i = 0; i < WlanSsidLen; i++) {
            if (nameFlag == "") {
                ssidName2G = WlanSsid[i].ssid;
                nameFlag = WlanSsid[i].rfBand;
                index2G = i + 1;
                continue;
            }
            if (nameFlag == "2.4GHz" && WlanSsid[i].rfBand == "5GHz") {
                ssidName5G = WlanSsid[i].ssid;
                nameFlag = WlanSsid[i].rfBand;
                index5G = i + 1;
                break;
            }
        }

        var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';
        var BaseInstFacKeyChgF = '<%HW_WEB_GetBaseInstFacKeyChgF();%>';
        var BaseInstFacKeyChgF2g = BaseInstFacKeyChgF.split(',')[0];
        var BaseInstFacKeyChgF5g = BaseInstFacKeyChgF.split(',')[1];

        if (DoubleFreqFlag == 1) {
            if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 0)) {
                AlertEx(cfg_wlancfgbasic_language['amp_wlan_pwd_need_change']);
            }
            else if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 1)) {
                AlertEx(cfg_wlancfgbasic_language['amp_wlan_pwd_need_change_2G']);
            }
            else if ((BaseInstFacKeyChgF2g == 1) && (BaseInstFacKeyChgF5g == 0)) {
                AlertEx(cfg_wlancfgbasic_language['amp_wlan_pwd_need_change_5G']);
            } else {
                window.location = "/index.asp";
            }
        }
        else {
            if (BaseInstFacKeyChgF2g == 0) {
                AlertEx(cfg_wlancfgbasic_language['amp_wlan_pwd_need_change']);
            } else {
                window.location = "/index.asp";
            }
        }

        var pwdLen = '<%HW_WEB_GetSPEC(SPEC_SSMP_CHKPWD_LENGTH.UINT32);%>';

        function TelmexComplex(idName) {
            var newPassword = document.getElementById(idName).value;

            if (newPassword == "") {
                return true;
            }

            if (newPassword.length < 10) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1118_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1118_5g"));
                }
                return false;
            }

            if (!isLowercaseInString(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1118e_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1118e_5g"));
                }
                return false;
            }

            if (!isUppercaseInString(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1118d_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1118d_5g"));
                }
                return false;
            }

            if (!isDigitInString(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1118b_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1118b_5g"));
                }
                return false;
            }

            if (!isSpecialCharacterNoSpace(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1118f_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1118f_5g"));
                }
                return false;
            }

            return true;
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

        function GetLanguageDesc(Name) {
            return AccountLgeDes[Name];
        }

        function CheckParameterHelp(idName) {
            if (!TelmexComplex(idName)) {
                return false;
            }

            var newPassword = document.getElementById(idName).value;

            if (newPassword == "") {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s0f02_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s0f02_5g"));
                }
                return false;
            }

            if (newPassword.length > 127) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1904_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1904_5g"));
                }
                return false;
            }

            if (!isValidAscii(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s0f0_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s0f0_5g"));
                }
                return false;
            }

            if (!CheckPwdIsComplex(newPassword)) {
                if(idName == "newPassword2G"){
                    AlertEx(GetLanguageDesc("s1902_2g"));
                }else{
                    AlertEx(GetLanguageDesc("s1902_5g"));
                }
                return false;
            }

            return true;
        }

        function CheckParameter() {
            if (DoubleFreqFlag == 1) {
                if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 0)) {
                    if(!CheckParameterHelp("newPassword2G")){
                        return false;
                    }
                    if(!CheckParameterHelp("newPassword5G")){
                        return false;
                    }
                }
                else if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 1)) {
                    if(!CheckParameterHelp("newPassword2G")){
                        return false;
                    }
                }
                else if ((BaseInstFacKeyChgF2g == 1) && (BaseInstFacKeyChgF5g == 0)) {
                    if(!CheckParameterHelp("newPassword5G")){
                        return false;
                    }
                }
            }
            else {
                if (BaseInstFacKeyChgF2g == 0) {
                    if(!CheckParameterHelp("newPassword2G")){
                        return false;
                    }
                }
            }

            setDisable('ModifyPwdApply', 1);
            setDisable('ModifyPwdCancel', 1);

            return true;
        }
        
        function SubmitPwd() {
            if (!CheckParameter()) {
                return false;
            }
            Form = new webSubmitForm();

            formAction = 'set.cgi?';
            urlNode = "k1=InternetGatewayDevice.LANDevice.1.WLANConfiguration." + index2G + ".PreSharedKey.1";
            urlNode += "&k2=InternetGatewayDevice.LANDevice.1.WLANConfiguration." + index5G + ".PreSharedKey.1";
            Form.setAction(formAction + urlNode + "&RequestFile=/html/ssmp/accoutcfg/TelmexWlanPwdModify.asp");

            if (DoubleFreqFlag == 1) {
                if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 0)) {
                    Form.addParameter('k1.PreSharedKey', getValue('newPassword2G'));
                    Form.addParameter('k2.PreSharedKey', getValue('newPassword5G'));
                }
                else if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 1)) {
                    Form.addParameter('k1.PreSharedKey', getValue('newPassword2G'));
                }
                else if ((BaseInstFacKeyChgF2g == 1) && (BaseInstFacKeyChgF5g == 0)) {
                    Form.addParameter('k2.PreSharedKey', getValue('newPassword5G'));
                }
            }
            else {
                if (BaseInstFacKeyChgF2g == 0) {
                    Form.addParameter('k1.PreSharedKey', getValue('newPassword2G'));
                }
            }
            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.submit();
        }

        function Skip() {
            window.location = "/index.asp";
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
        <tr id="secWifiInfo">
            <td class="width_per40">
                <table name="WifiTb2G" id="WifiTb2G" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF" class="tabal_bg">
                    <tr>
                        <td class="table_title_pwd width_per60">
                            <script language="JavaScript" type="text/javascript">
                                document.write(cfg_wifiguide_language['amp_wifiguide_wifiname_2G']);
                            </script>
                        </td>
                        <td class="table_right_pwd">
                            <script language="JavaScript" type="text/javascript">
                                document.write(ssidName2G);
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="table_title_pwd width_per60">
                            <script language="JavaScript" type="text/javascript">
                                document.write(cfg_wifiguide_language['amp_wifiguide_wifipwd_2G']);
                            </script>
                        </td>
                        <td class="table_right_pwd">
                            <input name='newPassword2G' type="password" autocomplete="off" id="newPassword2G" size="15">
                            <script>
                                $('#newPassword2G').blur(function () {
                                    TelmexComplex("newPassword2G");
                                });
                            </script>
                        </td>
                    </tr>
                </table>
                <table name="WifiTb5G" id="WifiTb5G" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF" class="tabal_bg">
                    <tr>
                        <td class="table_title_pwd width_per60">
                            <script language="JavaScript" type="text/javascript">
                                document.write(cfg_wifiguide_language['amp_wifiguide_wifiname_5G']);
                            </script>
                        </td>
                        <td class="table_right_pwd">
                            <script language="JavaScript" type="text/javascript">
                                document.write(ssidName5G);
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <td class="table_title_pwd width_per60">
                            <script language="JavaScript" type="text/javascript">
                                document.write(cfg_wifiguide_language['amp_wifiguide_wifipwd_5G']);
                            </script>
                        </td>
                        <td class="table_right_pwd">
                            <input name='newPassword5G' type="password" autocomplete="off" id="newPassword5G" size="15">
                            <script>
                                $('#newPassword5G').blur(function () {
                                    TelmexComplex("newPassword5G");
                                });
                            </script>
                        </td>
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
        if (DoubleFreqFlag == 1) {
            if ((BaseInstFacKeyChgF2g == 0) && (BaseInstFacKeyChgF5g == 1)) {
                setDisplay("WifiTb5G", 0);
            }
            else if ((BaseInstFacKeyChgF2g == 1) && (BaseInstFacKeyChgF5g == 0)) {
                setDisplay("WifiTb2G", 0);
            }
        }
        else {
            if (BaseInstFacKeyChgF2g == 0) {
                setDisplay("WifiTb5G", 0);
            }
        }

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
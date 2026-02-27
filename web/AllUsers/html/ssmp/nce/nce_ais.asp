<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="format-detection" content="telephone=no"/>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
    <link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script>
        function NCEResolve(domain, CurrentMgtURL, CurrentPort, Heartbeat) {
            this.domain = domain;
            this.CurrentMgtURL = CurrentMgtURL;
            this.CurrentPort = CurrentPort;
        }

        var NCEs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AppRemoteManage, CurrentMgtURL|CurrentPort, NCEResolve);%>;
        var NCE = NCEs[0];

        function InitNCEData() {
            $("#currentMgtURL").val(NCE.CurrentMgtURL);
            $("#currentPort").val(NCE.CurrentPort);
        }

        function SubmitNECConfig() {
            var url =  getValue('currentMgtURL');
            var portVal = getValue('currentPort');
            var r = new RegExp("^[0-9]{1}\\d*$");

            if ((!r.test(portVal)) || (parseInt(portVal) > 65535)) {
                AlertEx(GetDescFormArrayById(NCE_AISDes, "s0005"));
                $("#currentPort").focus();
                return;
            }

            if (url.length > 256) {
                AlertEx(GetDescFormArrayById(NCE_AISDes, "s0006"));
                $("#currentMgtURL").focus();
                return;
            }

            for (var i = 0; i < url.length; i++) {
                var ascicode = url.charAt(i).charCodeAt();
                if ((ascicode > 126) || (ascicode < 33)) {
                    AlertEx(GetDescFormArrayById(NCE_AISDes, "s0007"));
                    $("#currentMgtURL").focus();
                    return;
                }
            }

            var Form = new webSubmitForm();
            Form.addParameter('x.CurrentMgtURL', url);
            Form.addParameter('x.CurrentPort', portVal);
            Form.addParameter('x.X_HW_Token', getValue('onttoken'));
            Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_AppRemoteManage'
                                + '&RequestFile=html/ssmp/nce/nce_ais.asp');
            setDisable('NCEbtnApply', 1);
            setDisable('NCEcancelValue', 1);
            Form.submit();
        }

        function LoadFram() {
            InitNCEData();
        }
    </script>
</head>
<body class="mainbody" onload="LoadFram()">
    <div class="PageTitle_title" BindText="s0000" ></div>
    <div class="PageTitle_content" BindText="s0001">
    </div>
    <div class="title_spread"></div>
    <div class="func_title" BindText="s0002"></div>
    <table id="AcsConfigFormPanel" width="100%" cellspacing="1" cellpadding="0">
        <tr>
            <td class="table_title width_per30" BindText="s0003"></td>
            <td class="table_right width_per70">
                <input id="currentMgtURL" class="TextBox" />
            </td>
        </tr>
        <tr>
            <td class="table_title width_per30" BindText="s0004"></td>
            <td  class="table_right width_per70">
                <input id="currentPort" class="TextBox" />
            </td>
        </tr>
    </table>
    <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button" style="margin-top: 20px;">
        <tr>
            <td class="width_per30"></td>
            <td class="table_submit">
                <input type="hidden" id="onttoken" name="onttoken" value="<%HW_WEB_GetToken();%>" />
                <input type="button" id="NCEbtnApply" value="" BindText="s0d21" class="ApplyButtoncss  buttonwidth_100px" onclick="SubmitNECConfig()" />
                <input type="button" id="NCEcancelValue" value="" BindText="s0d22" class="CancleButtonCss buttonwidth_100px" onclick="InitNCEData()" />
            </td>
        </tr>
    </table>
    <script>
        ParseBindTextByTagName(NCE_AISDes, "div", 1);
        ParseBindTextByTagName(NCE_AISDes, "td", 1);
        ParseBindTextByTagName(Tr069LgeDes, "input", 2);
    </script>
</body>
</html>

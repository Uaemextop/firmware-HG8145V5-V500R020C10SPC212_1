<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css" />
    <link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>

    <title>AP SN WhiteList</title>
</head>
<script language="JavaScript" type="text/javascript">
    var appName = navigator.appName;
    if (appName == "Microsoft Internet Explorer") {
        document.write('<body class="mainbody" scroll="auto">');
    } else {
        document.write('<body class="mainbody" >');
        document.write('<DIV style="overflow-x:hidden; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">');
    }
</script>
<div>
    <form id="ConfigForm">
        <script language="JavaScript" type="text/javascript">
            HWCreatePageHeadInfo("whitelistasp", GetDescFormArrayById(WhitelistInfoLgeDes, "s0100"), GetDescFormArrayById(WhitelistInfoLgeDes, "s0101"), false);
        </script>
        <div class="title_spread"></div>
        <table class='width_per100' border="0" align="center" cellpadding="0" cellspacing="1">
            <script language="JavaScript" type="text/javascript">
                var whiteList = "<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_WIFIInfo.X_HW_APLock.WhilteList);%>";
                whiteList = whiteList.split(":");
                var whiteListArr = new Array();

                for (var i = 0; (i < whiteList.length) && (whiteList[0] != ""); ++i) {
                    whiteListArr[i] = new Object();
                    whiteListArr[i].serialNumber = whiteList[i];
                    whiteListArr[i].apOnlineFlag = "0";
                }

                function stApDeviceList(domain,deviceType,apOnlineFlag,apMacAddr,serialNumber)
                {
                    this.domain = domain;
                    this.deviceType = deviceType;
                    this.apOnlineFlag = apOnlineFlag;
                    this.apMacAddr = apMacAddr;
                    this.serialNumber = serialNumber;
                }

                var apDeviceList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_APDevice.{i},DeviceType|ApOnlineFlag|APMacAddr|SerialNumber,stApDeviceList);%>;
                for (var i = 0; i < apDeviceList.length - 1; ++i) {
                    for (var j = 0; j < whiteListArr.length; ++j) {
                        if (apDeviceList[i].serialNumber == whiteListArr[j].serialNumber) {
                            whiteListArr[j].apOnlineFlag = apDeviceList[i].apOnlineFlag;
                        }
                    }
                }

                document.write('<tr class="head_title">' + '<td' + bottomBorderClass(true) + '>' + WhitelistInfoLgeDes['s0102'] +
                    '</td>' + '<td' + bottomBorderClass(true) + '>' + WhitelistInfoLgeDes['s0103'] + '</td>' + '</tr>');
                if (whiteListArr.length < 1) {
                    document.write('<tr class="tabal_01 align_center">' + '<td style="width:50%' + bottomBorderClass(true) + '">--</td>' +
                        '<td style="width:50%' + bottomBorderClass(true) + '">--</td>' + '</tr>');
                } else {
                    for (var i = 0; i < whiteList.length && whiteList[0] != ""; ++i) {
                        if (whiteListArr[i].apOnlineFlag == "0") {
                            document.write('<tr class="tabal_01 align_center">' + '<td style="width:50%' + bottomBorderClass(true) + '">' + whiteListArr[i].serialNumber +
                                '</td>' + '<td' + bottomBorderClass(true) + '>' + WhitelistInfoLgeDes['s0105'] + '</td>' + '</tr>');
                        } else {
                            document.write('<tr class="tabal_01 align_center">' + '<td style="width:50%' + bottomBorderClass(true) + '">' + whiteListArr[i].serialNumber +
                                '</td>' + '<td' + bottomBorderClass(true) + '>' + WhitelistInfoLgeDes['s0104'] + '</td>' + '</tr>');
                        }
                    }
                }
            </script>
        </table>
    </form>
</div>
<script language="JavaScript" type="text/javascript">
    document.write('</DIV>');
</script>
</body>
</html>

<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>AIS Agent</title>

<script language="JavaScript" type="text/javascript">

function cpeAgent(domain, firstServer, firstInterval, firstEnable, SecondServer, secondInterval, secondEnable, secretKey, secretKeyVersion)
{
    this.domain = domain;
    
    this.firstServer = firstServer;
    this.firstInterval = firstInterval;
    this.firstEnable = firstEnable;
    
    this.SecondServer = SecondServer;
    this.secondInterval = secondInterval;
    this.secondEnable = secondEnable;

    this.secretKey = secretKey;
    this.secretKeyVersion = secretKeyVersion;
}

var cpeAgent = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_AIS_CPEagent,Primary_server_address|CPEagent_Interval_time_first|First_server_enable|Secondary_server_address|CPEagent_Interval_time_second|Second_server_enable|SecretKey|SecretKeyVersion,cpeAgent);%>;
cpeAgent = cpeAgent[0];

function setRadioValue(id, value)
{
    if (value == "1") {
        document.getElementById(id).checked = true;
    } else {
        document.getElementById(id).checked = false;
    }
}

function getRadioValue(id)
{
    if (document.getElementById(id).checked == true) {
    	return 1;
    } 

    return 0
}

function CheckInterval(interval)
{
    if ((interval > 86400) || (interval < 1)) {
    	return false;
    }
    
    return true;
}

function OnApply()
{
    var firstServer = getValue('id_first_server');
    var firstInterval = getValue('id_first_interval');
    var firstEnable = getRadioValue('id_first_enable');
    
    var secondServer = getValue('id_second_server');
    var secondInterval = getValue('id_second_interval');
    var secondEnable = getRadioValue('id_second_enable')

    if (CheckInterval(firstInterval) == false || CheckInterval(secondInterval) == false) {
        AlertEx("Interval Time must between 1~86400");
        return;
    }
    
    var Form = new webSubmitForm();
    var configObject = "x=InternetGatewayDevice.X_AIS_CPEagent";
    setDisable("btn_apply", 1);
    setDisable("btn_sendNow", 1);

    var summitData = "x.Primary_server_address=" + firstServer +
                     "&x.CPEagent_Interval_time_first=" + firstInterval +
                     "&x.First_server_enable=" + firstEnable +
                     "&x.Secondary_server_address=" + secondServer +
                     "&x.CPEagent_Interval_time_second=" + secondInterval +
                     "&x.Second_server_enable=" + secondEnable;

    summitData += "&x.X_HW_Token=" + getValue('onttoken');
    
    $.ajax({
        type : "POST",
        async : false,
        cache : false,
        url : '/setajax.cgi?' + configObject + '&RequestFile=html/ssmp/aisagent/aisagent.asp',
        data: summitData,
        success : function(data) {
            setDisable("btn_apply", 0);
            setDisable("btn_sendNow", 0);
            location.reload();
        }
    });

    LoadServerConfig();	
}

function OnSendNow()
{
    var Form = new webSubmitForm();
    var configObject = "x=InternetGatewayDevice.X_AIS_CPEagent";
    var summitData = "x.send_information_immediately=1";
    summitData += "&x.X_HW_Token=" + getValue('onttoken');

    if ((cpeAgent.firstEnable != '1') && (cpeAgent.secondEnable != '1')) {
        AlertEx("Both the first server and the second server are disabled.");
        return;
    }

    setDisable("btn_apply", 1);
    setDisable("btn_sendNow", 1);

    $.ajax({
        type : "POST",
        async : true,
        cache : false,
        url : '/setajax.cgi?' + configObject + '&RequestFile=html/ssmp/aisagent/aisagent.asp',
        data: summitData,
        success : function(data) {
            setDisable("btn_apply", 0);
            $("#id_send_status").text("status:reporting");
            
            StartWatchReportersStatus();
        }
    });
    $("#id_send_status").text("status:reporting");

}

function LoadServerConfig()
{
    setText('id_first_server', cpeAgent.firstServer);
    setText('id_first_interval', cpeAgent.firstInterval);
    setRadioValue('id_first_enable', cpeAgent.firstEnable);
    
    setText('id_second_server', cpeAgent.SecondServer);
    setText('id_second_interval', cpeAgent.secondInterval);
    setRadioValue('id_second_enable', cpeAgent.secondEnable);

    setText('id_secret_key', cpeAgent.secretKey);
    setText('id_secret_key_version', cpeAgent.secretKeyVersion);
}

function LoadFrame()
{
	LoadServerConfig();
}

var oldRadioValue1 = cpeAgent.firstEnable;
var oldRadioValue2 = cpeAgent.SecondServer;

function ClickRadio(type)
{
    if (type == 0) {
        oldRadioValue1 = !oldRadioValue1;
        setRadioValue('id_first_enable', oldRadioValue1);
    } else {
        oldRadioValue2 = !oldRadioValue2;
        setRadioValue('id_second_enable', oldRadioValue2);
    }
    return;
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <script language="JavaScript" type="text/javascript">
            HWCreatePageHeadInfo("ais agent", 'AIS Agent', "", false);
        </script> 
        <tr>
            <td>
                <form id="form_ConfigForm" action="">
                    <table id="tb_form" border="0" cellpadding="0" cellspacing="1">
                        <tr id="id_first_title">
                            <td width="60%"> <label>First Server</label> </td>
                            <td width="20%"> <label>Interval Time</label> </td>
                            <td width="10%"> </td>
                            <td width="10%"> <label>Enable</label> </td>
                        </tr>
                        <tr id="id_first_input">
                            <td width="60%"> <input type="text" id="id_first_server" size="40" maxlength="50"></input> </td>
                            <td width="20%"> <input type="text" id="id_first_interval" size="15" maxlength="50"></input> </td>
                            <td width="10%"> <label>sec.</label> </td>
                            <td width="10%"> <input type="radio" id="id_first_enable" onclick="ClickRadio(0);"> </input></td>
                        </tr>
                        <tr id="id_first_status">
                            <td colspan="4" class="table_title width_per30" style="padding-left: 0px;"> <label id="label_id_first_status"> status: </label> </td>
                        </tr>                                            
                        <tr>
                            <td colspan="4">&nbsp;</td>
                        </tr> 
                        <tr id="id_second_title">
                            <td width="60%"> <label>Second Server</label> </td>
                            <td width="20%"> <label>Interval Time</label> </td>
                            <td></td>
                            <td width="10%"> <label>Enable</label> </td>
                        </tr>
                        <tr id="id_second_input">
                            <td width="60%"> <input type="text" id="id_second_server" size="40" maxlength="50"> </input></td>
                            <td width="20%"> <input type="text" id="id_second_interval" size="15" maxlength="50"> </input></td>
                            <td><label>sec.</label> </td>
                            <td width="10%"> <input type="radio" id="id_second_enable" onclick="ClickRadio(1);"> </input></td>
                        </tr>
                        <tr id="id_second_status">
                            <td colspan="4" class="table_title width_per30" style="padding-left: 0px;"><label id="label_id_second_status">status:</label> </td>
                        </tr>
                    </table>
                </form>
            </td>
        </tr>
        <tr>
            <table >
                <tr>
                    <td>&nbsp;</td>
                </tr> 
                <tr>
                    <td>
                        <label>AIS Agent secret key version</label>
                    </td>
                    <td style="padding-left: 15px;">
                        <input type="text" id="id_secret_key_version" size="40" style="width: 180px;" maxlength="40" disabled>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <label>AIS Agent secret key</label>
                    </td>
                    <td style="padding-left: 15px;">
                        <input type="text" id="id_secret_key" size="40"  style="width: 180px;" maxlength="40" disabled>
                    </td>
                </tr>
            </table>
        </tr>
        <tr>
            <td><table id="tb_apply" width="90%" cellspacing="1">
                <tbody>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="table_submit" style="text-align:center;">
                            <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                            <input id="btn_apply" type="button" value="APPLY" onclick="OnApply();"
                                class="ApplyButtoncss buttonwidth_100px"></input>
                        </td>
                    </tr>
                </tbody>
            </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>

                <script language="JavaScript" type="text/javascript">
                    HWCreatePageHeadInfo("send immediately", "Sent Information to Server Immediately", "", false);
                </script>
            </td>
        </tr>
        <tr>
            <td><table id="tb_apply" width="100%" cellspacing="1">
                <tbody>
                    <tr>
                        <td class="table_submit">
                            <input id="btn_sendNow" type="button" value="Send Now" onclick="OnSendNow();"
                                class="ApplyButtoncss buttonwidth_100px" style="margin-left: -4px;"></input>
                        </td>
                    </tr>
                </tbody>
            </table>
            </td>
        </tr>
        <tr>
            <td>
                <label class="table_title width_per30" style="padding-left: 0px;" id="id_send_status">status:</label>
            </td>
        </tr>
    </table>
    <script language="JavaScript" type="text/javascript">

        function ReporterServer(status, lastResult, imStatus) {
            this.status = status;
            this.lastResult = lastResult;
            this.imStatus = "NOT_START";
            this.curImCount = -1;
            if (imStatus != "NOT_START") {
                var dividerIndex = imStatus.lastIndexOf("_");
                if (dividerIndex > 0) {
                    this.imStatus = imStatus.substring(0, dividerIndex);
                    this.curImCount = parseInt(imStatus.substring(dividerIndex + 1));
                }
            }
        }

        function ReportersInfo(primaryServer, secondaryServer, imCount) {
            this.primaryServer = primaryServer;
            this.secondaryServer = secondaryServer;
            this.imCount = parseInt(imCount);
        }

        var rawReportersInfo = '<%webGetAisAgentReporterInfo();%>';
        var reportersInfo = null;

        function ParseReporterInfo(data) {
            var splitStr = data.split(' ');
            if (splitStr.length < 7) {
                return false;
            }
            var primaryServer = new ReporterServer(splitStr[0], splitStr[1], splitStr[2]);
            var secondaryServer = new ReporterServer(splitStr[3], splitStr[4], splitStr[5]);
            reportersInfo = new ReportersInfo(primaryServer, secondaryServer, splitStr[6]);
            rawReportersInfo = data;
            return true;
        }

        function GetReporterStatus(reporterServer) {
            if (reporterServer.status == 'STATE_IDLE') {
                return "status:idle";
            } else if (reporterServer.status == 'STATE_REPORTTING') {
                return "status:reporting";
            } else {
                var resultMap = {
                    "EVENT_REPORT_FAILED": "status:fail",
                    "EVENT_REPORT_SUCCESS": "status:success",
                    "EVENT_INTERVAL_TIMEOUT": "status:timeout"
                };
                var result = resultMap[reporterServer.lastResult];
                return result == null ? "" : result;
            }
        }

        function GetImSendStatus(reportersInfo) {
            if (reportersInfo.imCount < 0) {
                return "";
            }

            var primaryServerImState = reportersInfo.primaryServer.imStatus;
            var secondaryServerImState = reportersInfo.secondaryServer.imStatus;

            if ((reportersInfo.imCount > reportersInfo.primaryServer.curImCount) ||
                (reportersInfo.imCount > reportersInfo.secondaryServer.curImCount)) {
                return "status:reporting";
            }

            var imFailStateList = ["fail_collect", "fail_send", "fail_check_resp"];
            if ((imFailStateList.indexOf(primaryServerImState) >= 0) ||
                (imFailStateList.indexOf(secondaryServerImState) >= 0)) {
                return "status:fail";
            }

            var imReportingStateList = ["data_collecting", "sending_to_server", "check_response"];
            if ((imReportingStateList.indexOf(primaryServerImState) >= 0) ||
                (imReportingStateList.indexOf(secondaryServerImState) >= 0)) {
                return "status:reporting";
            }

            if ((primaryServerImState == 'not_ready') && (secondaryServerImState == 'not_ready')) {
                return "status:no reporter is ready";
            }

            return "status:success";
        }

        function UpdateRepoterState() {
            $("#label_id_first_status").text(GetReporterStatus(reportersInfo.primaryServer));
            $("#label_id_second_status").text(GetReporterStatus(reportersInfo.secondaryServer));
            var sendStatus = GetImSendStatus(reportersInfo);
            $("#id_send_status").text(sendStatus);
            setDisable('btn_sendNow', sendStatus.indexOf('status:reporting') >= 0 ? 1 : 0);
        }

        var isWatchingReportersStatus = false;
        function NeedWatching(reportersInfo) {
            if (reportersInfo == null) {
                return false;
            }
            if (reportersInfo.primaryServer.status != 'STATE_IDLE') {
                return true;
            }
            if (reportersInfo.secondaryServer.status != 'STATE_IDLE') {
                return true;
            }
            return false;
        }

        function PullLatestStatus() {
            $.ajax({
                type : "POST",
                async : false,
                cache : false,
                url : "../common/GetAisAgentReporterInfo.asp",
                data :'',
                success : function(data) {
                    if (ParseReporterInfo(data) == false) {
                        isWatchingReportersStatus = false;
                        return;
                    }
                    UpdateRepoterState();
                    if (NeedWatching(reportersInfo) == false) {
                        isWatchingReportersStatus = false;
                        return;
                    }
                    setTimeout('PullLatestStatus()', 2000);
                }
            });
        }
        function StartWatchReportersStatus() {
            if (isWatchingReportersStatus) {
                return;
            }
            isWatchingReportersStatus = true;
            ParseReporterInfo(rawReportersInfo);
            UpdateRepoterState();
            PullLatestStatus();
        }
        StartWatchReportersStatus();
    </script>
</body>
</html>
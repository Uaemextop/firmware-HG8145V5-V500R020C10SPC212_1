<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>TELMEXSSH</title>
<script language="JavaScript" src='Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../html/bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var fltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();
var telmexFlag = '<%HW_WEB_GetFeatureSupport(FT_PRODUCT_TELMEX);%>';
var isTelmexFlag = <%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_TELMEX);%>;
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var selctIndex = -1;
var curUserType='<%HW_WEB_GetUserType();%>';
var cfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var beltelePONFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOM);%>';
var belteleLanFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_BELTELECOMLAN);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';

var Language = '';
if (Var_LastLoginLang == '') {
    Language = Var_DefaultLang;
} else {
    Language = Var_LastLoginLang;
}

function list(domain,SrcIPPrefix) {
    this.domain = domain;
    this.SrcIPPrefix = SrcIPPrefix;
}

function stAclInfo(domain,HttpLanEnable,HttpWanEnable,FtpLanEnable,FtpWanEnable,TelnetLanEnable,TelnetWanEnable,HTTPWifiEnable,TELNETWifiEnable, SSHLanEnable, SSHWanEnable,HTTPSWanEnable) {
    this.domain = domain;
    this.HttpWifiEnable = HTTPWifiEnable;
    this.TelnetWifiEnable = TELNETWifiEnable;
    this.HttpLanEnable = HttpLanEnable;
    this.HttpWanEnable = HttpWanEnable;
    this.FtpLanEnable = FtpLanEnable;
    this.FtpWanEnable = FtpWanEnable;
    this.TelnetLanEnable = TelnetLanEnable;
    this.TelnetWanEnable = TelnetWanEnable;
    this.SSHLanEnable = SSHLanEnable;
    this.SSHWanEnable = SSHWanEnable;
    this.HTTPSWanEnable = HTTPSWanEnable;
}

var aclInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecAclInfos, InternetGatewayDevice.X_HW_Security.AclServices,HTTPLanEnable|HTTPWanEnable|FTPLanEnable|FTPWanEnable|TELNETLanEnable|TELNETWanEnable|HTTPWifiEnable|TELNETWifiEnable|SSHLanEnable|SSHWanEnable|HTTPSWanEnable,stAclInfo);%>;  
var aclInfo = aclInfos[0];

function LoadFrame() {        
    setCheck('ftplan',aclInfo.FtpLanEnable);
    setCheck('ftpwan',aclInfo.FtpWanEnable);
    setCheck('sshlan',aclInfo.SSHLanEnable);
    setCheck('sshwan',aclInfo.SSHWanEnable);
    setDisplay('DivMain', 1);
    
    $("#HerfTelmexText").text(productName);
    if (Language == "english") {
        $("#headerLogout span").html("Logout");
    } else {
        $("#headerLogout span").html("Cerrar sesión");
    }
    $("#headerLogout span").mouseover(function() {
        $("#headerLogout span").css({
            "color" : "#990000",
            "text-decoration" : "underline"
        });
    });
    $("#headerLogout span").mouseout(function() {
        $("#headerLogout span").css({
            "color" : "#000000",
            "text-decoration" : "none"
        });
    });
    $("#headerLogout span").click(function() {
        var sUserAgent = navigator.userAgent
        var isIELarge11 = (sUserAgent.indexOf("Trident") > -1 && sUserAgent.indexOf("rv") > -1);
        if (isIELarge11) {
            $.post('logout.cgi?&RequestFile=/html/logout.html');
            window.location = "/";
        } else {
            var Form = new webSubmitForm();
            Form.setAction('logout.cgi?RequestFile=/html/logout.html');
            Form.submit();
        }
    });
}

function SubmitForm() {
    setDisable('btnApply', 1);
    setDisable('cancelValue', 1);
    var formData = "x.SSHLanEnable=" + getCheckVal('sshlan') + "&x.SSHWanEnable=" + getCheckVal('sshwan') + "&x.FTPLanEnable=" + getCheckVal('ftplan') +
               "&x.FTPWanEnable=" + getCheckVal('ftpwan') + "&x.X_HW_Token=" + getValue('onttoken');
    $.ajax ({
        type : "POST",
        async : false,
        cache : false,
        data:formData,
        url : 'setajax.cgi?x=InternetGatewayDevice.X_HW_Security.AclServices' + '&RequestFile=telmexssh.asp',
        success : function(data) {
        },
        complete: function (XHR, TS) {
            XHR=null;
            setDisable('bttnApply',0);
            setDisable('cancelValue',0);
            window.location = "telmexssh.asp";         
        }
    });          
}

function CancelConfig() {
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody" id="DivMain" style="display:none;width:900px;margin:3% auto;"> 
  <div id="header" style="height:50px;"> 	     
    <div id="headerContent"> 
      <div id="headerInfo"> 
        <div id="HerfTelmex" style="float:left;color:#505050;font-size:25px;font-weight: bold;margin-left:10px;"><span id="HerfTelmexText"></span></div>
		<div id="headerLogout" style="float: right;margin-right: 10px;font-size: 14px;height: 50px;line-height: 50px;"><span id="headerLogoutText" onclick="logoutfunc();"></span></div> 
      </div> 
      <div id="headerTab"> 
        <ul> </ul> 
      </div> 
    </div> 
    <div id="headerSpace">&nbsp;</div> 
  </div> 
<div class="title_spread" BindText="bbsp_title_prompt" style="width:100%;height:40px;line-height:40px;background:#FFFAE3;text-indent:10px;"></div>
<form id="lan_table"> 
    <div id="LanServiceTitle" class="func_title" BindText="bbsp_table_lan" style="padding:5px 0 0 0;"></div>
    <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
        <tr style="background:#f1f1f1;height:25px;">
            <td BindText="bbsp_table_lanftp" width="50%" style="padding:0 5px;"></td>
            <td><input id="ftplan" type="checkbox" value="x.FTPLanEnable"></td>
        </tr>
        <tr style="background:#f1f1f1;height:25px;">
            <td BindText="bbsp_table_lanssh" width="50%" style="padding:0 5px;"></td>
            <td><input id="sshlan" type="checkbox" value="x.SSHLanEnable"></td>
        </tr>
    </table>
    <div class="func_spread"></div>
</form>  
<form id="wan_table"> 
<div class="func_spread"></div>
    <div id="WanServiceTitle" class="func_title" BindText="bbsp_table_wan" style="padding:5px 0 0 0;"></div>
    <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
        <tr style="background:#f1f1f1;height:25px;">	
            <td BindText="bbsp_table_wanftp" width="50%" style="padding:0 5px;"></td>
            <td><input id="ftpwan" type="checkbox" value="x.FTPWanEnable"></td>
        </tr>
        <tr style="background:#f1f1f1;height:25px;">	
            <td BindText="bbsp_table_wanssh" width="50%" style="padding:0 5px;"></td>
            <td><input id="sshwan" type="checkbox" value="x.SSHWanEnable"></td>
        </tr>
    </table>
</form> 
<table class="table_button" width="100%"> 
  <tr>
    <td class='width_per35'></td> 
    <td class="table_submit width_per45">
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <button id="bttnApply" name="bttnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();" id="Button1"><script>document.write(acl_language['bbsp_app']);</script></button>
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(acl_language['bbsp_cancel']);</script></button>
    </td> 
  </tr> 
</table>
<br>
<br>
<script>
    ParseBindTextByTagName(acl_language, "td",    1);
    ParseBindTextByTagName(acl_language, "div",   1);
    ParseBindTextByTagName(acl_language, "span",   1);
</script>
</body>
</html>

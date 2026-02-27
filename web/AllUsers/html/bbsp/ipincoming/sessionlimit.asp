<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
    <link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
    <script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
    
    <title>session limit</title>
    </head>
    <body  onLoad="LoadFrame();" class="mainbody"> 
<script language="javascript">
var sessionNum = '<%HW_WEB_GetSPEC(BBSP_SPEC_FWD_SESSIONNUM.UINT32);%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
if (['VIETTEL2', 'VIETTEL'].indexOf(CfgMode) >= 0) {
    sessionNum = '10000';
}


function stSessionLimitInfo(domain, Enable, MAXSession) {
    this.domain = domain;
    this.Enable = Enable;
    this.MAXSession = MAXSession;
}
var sessionLimitInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.UsrSessionLimit, Enable|MAXSession,stSessionLimitInfo);%>; 
var sessionLimitInfo = sessionLimitInfos[0];

function loadlanguage() {
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) {
        var b = all[i];
        if (b.getAttribute("BindText") == null) {
            continue;
        }
        b.innerHTML = sessionLimit_language[b.getAttribute("BindText")];
    }
}


function LoadFrame() {
    setText('MaxSessionID',sessionLimitInfo.MAXSession);
    setCheck('EnableID',sessionLimitInfo.Enable);    

    loadlanguage();
}


function OnApply() {
    var maxSession = getValue('MaxSessionID')
    if ((parseInt(maxSession) > parseInt(sessionNum)) || (parseInt(maxSession) <= 99)) {
        AlertEx(sessionLimit_language['SessionIsFull']);
        return;
    }
    var Form = new webSubmitForm();
    Form.addParameter('x.Enable',getCheckVal('EnableID'));
    Form.addParameter('x.MAXSession',getValue('MaxSessionID'));
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.UsrSessionLimit'
                    + '&RequestFile=html/bbsp/ipincoming/sessionlimit.asp');
   Form.submit();
}

function OnCancel() {
    LoadFrame();
}
</script> 
<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("portaltitle", GetDescFormArrayById(sessionLimit_language, "bbsp_mune"), GetDescFormArrayById(sessionLimit_language, "bbsp_sessionLimit_title"), false);
</script> 
<div class="title_spread"></div>

<form id="SessionCfg" style="display:block;">
    <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg"> 
        <li   id="EnableID"     RealType="CheckBox"     DescRef="bbsp_enable"       RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Enable"   InitValue="Empty"/>
        <li   id="MaxSessionID"           RealType="TextBox"      DescRef="bbsp_sessionLimit_maxsession"             RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.MAXSession"  Elementclass="inputclass"  InitValue="Empty"  Maxlength="256"/>
    </table>
<script>
var TableClass = new stTableClass("per_20_25", "", "ltr");
HWParsePageControlByID("SessionCfg", TableClass, sessionLimit_language, null);
getElById('EnableID').title = sessionLimit_language['bbsp_enable'];
getElById('MaxSessionID').title = sessionLimit_language['bbsp_sessionLimit_maxsession'];
getElById('MaxSessionIDRemark').innerHTML = "(100-"+ sessionNum+")";
</script>
<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0"> 
  <tr> 
    <td class="table_submit per_20_25"></td> 
    <td class="table_submit align_left"> 
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <button id='Apply' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"> <script>document.write(sessionLimit_language['bbsp_app']);</script></button> 
        <button id='Cancel' type=button onclick = "javascript:return OnCancel();" class="CancleButtonCss buttonwidth_100px"> <script>document.write(sessionLimit_language['bbsp_cancel']);</script></button> 
    </td> 
  </tr> 
</table> 
</form>
</body>
</html>

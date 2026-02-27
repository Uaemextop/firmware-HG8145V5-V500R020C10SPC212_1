<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script>
var APType ='<%HW_WEB_GetApMode();%>'
var DESKCTAP = '<%HW_WEB_GetFeatureSupport(FT_DESKCTAP_SUPPORT);%>';
var currentValue;
function LoadFrame() {
    if(APType == 1) {
        $('input[name="UpModeRadio"][Value=1]').attr("checked",true);
        currentValue = 1;
    } else {
        $('input[name="UpModeRadio"][Value=2]').attr("checked",true);
        currentValue = 2;
    }
}

function SubmitForm() {
    var selected = $('input:radio:checked').val();
    var upModeType;
    var selectResult = false;

    if (selected == currentValue) {
        window.location.reload() ;
        return;
    }
    
    if (selected == 1) {
        UpModeType = 1 ;
        selectResult = ConfirmEx(modeswitch_language['modeswitch_confirm01']);
    } else if (selected == 2) {
        UpModeType = 0 ;
        selectResult = ConfirmEx(modeswitch_language['modeswitch_confirm02']);
    }
 
    if (selectResult == true) {
        setDisable('btnApply', 1);
        $.ajax({
         type : "POST",
         async : true,
         cache : false,
         data : 'UpModeType=' + UpModeType + "&x.X_HW_Token=" + getValue('onttoken'),
         url : "routerbridgechange.cgi?&RequestFile=html/bbsp/upporttypecfg/modeswitch.asp",
         success : function(data) {
         },
         complete: function (XHR, TS) {
            XHR=null;
         }
        });
    }
}
</script>
</head>
<body onLoad="LoadFrame();"  class="mainbody">
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("dhcpstatic", GetDescFormArrayById(modeswitch_language, "modeswitch_title"), GetDescFormArrayById(modeswitch_language, "modeswitch_description"), false);
</script>
<div class="title_spread"></div>
<form id="UpModeCfgForm" name="UpModeCfgForm">
    <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
        <li id="UpModeRadio" RealType="RadioButtonList" DescRef="modeswitch_options" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{TextRef:'mode_type01',Value:'1'},{TextRef:'mode_type02',Value:'2'}]"/>
    </table>
    <script>
        var TableClass = new stTableClass("width_per40", "width_per60", "ltr");
        var UpModeCfgFormList = new Array();
        UpModeCfgFormList = HWGetLiIdListByForm("UpModeCfgForm",null);
        HWParsePageControlByID("UpModeCfgForm",TableClass,modeswitch_language,null);
    </script>
</form>

<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
    <tr>
        <td class="table_submit width_per40"></td>
        <td class="table_submit">
            <input type="hidden" id="onttoken"  name="onttoken" value="<%HW_WEB_GetToken();%>"/>
            <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(modeswitch_language['modeswitch_submit']);</script></button>
        </td>
    </tr>
</table>
</body>
</html>

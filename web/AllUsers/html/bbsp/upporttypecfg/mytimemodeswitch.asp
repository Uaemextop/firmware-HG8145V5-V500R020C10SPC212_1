<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title>Uplink Mode</title>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var UplinkMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_UplinkMode);%>';

function LoadFrame()
{	
    setSelect('UpModeList', UplinkMode);
}

function SubmitForm()
{
    if (getValue('UpModeList') == UplinkMode) {
        return;
    }

    if (ConfirmEx(upmodecfg_language["upmodecfg_confirm"]) == false) {
        return;
    }
    var Form = new webSubmitForm();
    Form.addParameter('x.X_HW_UplinkMode', getValue('UpModeList'));
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo'+ '&RequestFile=html/bbsp/upporttypecfg/mytimemodeswitch.asp');
    Form.submit();
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("upmodecfgtitle", GetDescFormArrayById(upmodecfg_language, "bbsp_mune"), GetDescFormArrayById(upmodecfg_language, ""), false);
    if ((CfgModeWord == 'TM2') || (CfgModeWord == 'TMAP6')) {
        document.getElementById("upmodecfgtitle_content").innerHTML = upmodecfg_language['bbsp_mytimeupmodecfg_title_tm'];
    } else {
        document.getElementById("upmodecfgtitle_content").innerHTML = upmodecfg_language['bbsp_mytimeupmodecfg_title'];
    }
</script>
<div class="title_spread"></div>

<form id="UpModeCfgForm" name="UpModeCfgForm">
    <table border="0" cellpadding="0" cellspacing="1"  width="100%" class="tabal_noborder_bg">
        <script>
            if ((CfgModeWord == 'TM2') || (CfgModeWord == 'TMAP6')) {
                document.write('<li id="UpModeList"  RealType="DropDownList" DescRef="upmodecfg_mode"   RemarkRef="Empty"   ErrorMsgRef="Empty"  Require="FALSE"   BindField="Empty"  InitValue="[{TextRef:\'Combo\',Value:\'0\'},{TextRef:\'Mesh\',Value:\'1\'},{TextRef:\'Router_Gateway\',Value:\'2\'}]"/>');
            } else {
                document.write('<li id="UpModeList"  RealType="DropDownList" DescRef="upmodecfg_mode"   RemarkRef="Empty"   ErrorMsgRef="Empty"  Require="FALSE"   BindField="Empty"  InitValue="[{TextRef:\'GPON\',Value:\'0\'},{TextRef:\'AP\',Value:\'1\'}]"/>');
            }
        </script>
    </table>
    <script>
        var TableClass = new stTableClass("width_per40", "width_per60", "ltr");
        var UpModeCfgFormList = new Array();
        UpModeCfgFormList = HWGetLiIdListByForm("UpModeCfgForm",null);
        HWParsePageControlByID("UpModeCfgForm",TableClass,upmodecfg_language,null);
    </script>
</form>

<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(upmodecfg_language['upmodecfg_app']);</script></button>
  </td>
  </tr>
</table>

</body>
</html>

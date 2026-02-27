<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<style>
.uriclass
{ 
	word-break:break-all;
	min-width:30px;
}

.regnameclass
{ 
	word-break:break-all;
	width:110px;
}

</style>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">

var cpeReuseStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_AIS_reuseCPE_status);%>';
var meshMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_Mesh.MeshMode);%>';

function LoadFrame()
{
    if (cpeReuseStatus == 1){
        setRadio('reuseStatus',1);
    } else {
        setRadio('reuseStatus',0);
    }

    if (meshMode !='0' || cpeReuseStatus == 1) {
        window.parent.location.reload();
    }
}

function OnApply()
{
    var status = getRadioVal("reuseStatus");
    var Form = new webSubmitForm();
    var RequestFile = "html/ssmp/deviceinfo/subversioninfo.asp";
    Form.addParameter('x.X_AIS_reuseCPE_status', status);
    url = 'set.cgi?x=InternetGatewayDevice.DeviceInfo'
        + '&RequestFile=' + RequestFile;
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    setDisable('applyButton',1);
    Form.setAction(url);
    Form.submit();
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo("subversioninfo", GetDescFormArrayById(cpeReuse_AISAP, "title"), GetDescFormArrayById(cpeReuse_AISAP, "description"), false);
</script>
<div class="title_spread"></div>
<table>
    <tr>
        <td class="table_title"><script>document.write(cpeReuse_AISAP['subversion']);</script></td>
        <td class="table_right">	
            <input name="reuseStatus" id="reuseStatus" type="radio" value="1" />
            <span ><script>document.write(cpeReuse_AISAP['status_Enable']);</script></span>
        </td>
    </tr>
    <tr>
        <td></td>
        <td class="table_right">
            <input name="reuseStatus" id="reuseStatus" type="radio" value="0" />
            <span ><script>document.write(cpeReuse_AISAP['status_Disable']);</script></span>
        </td>
    </tr>
</table>
<div>
    <table width="90%" height="50"> 
        <tr>
            <td class="align_center">
                <button id="applyButton" name="applyButton" class="ApplyButtoncss" type="button" onClick="OnApply();" enable=true><script>document.write(cpeReuse_AISAP['apply']);</script></button>
            </td>
        </tr>
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
    </table> 
</div>
</body>
</html>

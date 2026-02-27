<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<title>EAI Configration</title>
<script language="JavaScript" type="text/javascript">

var eduAccFt = '<%HW_WEB_GetFeatureSupport(FT_EAI_APP_IDENTIFY_EDU);%>';

function GetEaiStatus()
{  
    $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "/html/ssmp/eai/GetEaiStatus.asp",
		success : function(data) {
			eaiStatusAndStaIPList = eval("\"" + data + "\"");
		}
    });
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "/html/ssmp/eai/GetEaiStartedStatus.asp",
		success : function(data) {
			eaiStartFlag = data;
		}
    });
	var html = "EAI Core Chip Version:5117VV500\r\n";
	if (eaiStartFlag == '1') {
		document.getElementById('enableEai').checked = true;
		document.getElementById('staInfo').value = html + "EAI status: " + eaiStatusAndStaIPList;
	} else {
		document.getElementById('staInfo').value = html + "EAI status: off\r\n"
	    document.getElementById('enableEai').checked = false;
	}
}

function EnableSubmit()
{
    var value = document.getElementById('enableEai').checked ? "1" : "0";
    var Form = new webSubmitForm();
	Form.addParameter("EnableEai", value);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('startEai.cgi?RequestFile=html/ssmp/eai/eai.asp');

    Form.submit();
}

function LoadFrame()
{
    GetEaiStatus();

	if (eduAccFt == 1) {
		setDisplay('EAIset', 0);
	}
}

</script>

</head>
<body  class="mainbody" onLoad="LoadFrame();">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("eai", GetDescFormArrayById(smart_eai_language, "smart5000"), GetDescFormArrayById(smart_eai_language, "smart5005"), false);
</script>
 

<div class="title_spread"></div>
<div id="EAIset" class="func_title" ><script>document.write(smart_eai_language['smart5004']);</script></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg"> 
    <tr> 
      <td class="table_title width_per20" ><script>document.write(smart_eai_language['smart5001']);</script></td>
      <td class="table_right">
          <input id="enableEai" type="Checkbox" size="80" required="required" />
          <button id="submit" class="ApplyButtoncss buttonwidth_100px" name="submit" onclick="EnableSubmit()"><script>document.write(smart_eai_language['smart5006']);</script></button>
        </td> 
    </tr> 
</table>
<div class="func_spread"></div>
<div class="func_title" ><script>document.write(smart_eai_language['smart5002']);</script></div>
<div class="button_spread"></div>
<div id="backlog"> 
    <table width="100%" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td> <button id="display"class="ApplyButtoncss buttonwidth_150px_250px" name="submit" onclick="GetEaiStatus()"><script>document.write(smart_eai_language['smart5003']);</script></button>
        <input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>"></td> 
      </tr> 
    </table> 
</div>

<div class="button_spread"></div>
<div id="logviews">
    <textarea dir="ltr" name="staInfo" id="staInfo" class="text_log" wrap="off" readonly="readonly"></textarea>
</div>

<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</body>

</html>

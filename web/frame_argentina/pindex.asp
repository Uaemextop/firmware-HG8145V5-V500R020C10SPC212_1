<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
        <meta content="no-cache" http-equiv="Pragma" />
        <title>Waiting...</title>
		<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
        <script type="text/javascript">
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = Var_DefaultLang;

function SubmitFormNoPwd()
{
	/* clear COOKIE */
	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date=new Date();
		date.setTime(date.getTime()-10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
	}

	var cnt;

	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/asp/GetRandCount.asp',
		success : function(data) {
			cnt = data;
		}
		});

	var Form = new webSubmitForm();
	
	var cookie2 = "Cookie=body:" + "Language:" + Language + ":" + "id=-1;path=/";
	Form.addParameter('UserName', "anonymous");
	Form.addParameter('PassWord', base64encode("anonymous"));
	document.cookie = cookie2;

	Form.addParameter('x.X_HW_Token', cnt);
	Form.setAction('/login.cgi');
	Form.submit();
	return true;
}
        </script>
    </head>
    <body></body>
	<script>
	SubmitFormNoPwd();
        </script>
</html>

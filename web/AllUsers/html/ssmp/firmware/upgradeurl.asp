<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>CATV Port Configration</title>
<script language="JavaScript" type="text/javascript">

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var isRfOn = '<%HW_WEB_IsRfExist();%>'; 


function EnableSubmit()
{
    var url = document.getElementById('url').value;
    if(url == null || url == "") {
        alert("url can not be empty!");
        return;
    }
    
    var Form = new webSubmitForm();
    Form.addParameter('upgradeUrl', document.getElementById('url').value);
    Form.addParameter('Username', document.getElementById('Username').value);
    Form.addParameter('Password', document.getElementById('Password').value);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('SetUpgradeUrl.cgi?RequestFile=html/ssmp/firmware/upgradeurl.asp');

    Form.submit();
}

</script>

</head>
<body>
Url:
<input id="url" type="text" size="80" required="required" />
<br/>
Username:
<input id="Username" type="text" size="20"/>
Password:
<input id="Password" type="password" size="20"/>
<input id="submit" type="button" size="40" name="submit" value="submit" onclick="EnableSubmit()" />
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</body>

</html>

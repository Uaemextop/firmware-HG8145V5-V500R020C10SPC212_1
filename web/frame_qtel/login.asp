<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"/>
<title></title>
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet" />
<style type="text/css">
#first{
	background-color:white;
	height:25px;
	text-align: center;
	color: red;
	position:absolute;
	width: 380px;
	top: 312px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function MD5(str) { return hex_md5(str); }

var APPVersion = '<%HW_WEB_GetAppVersion();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = Var_DefaultLang;
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var locklefttimerhandle;

document.title = "Fibre Gateway";

var AdminInfo = '<%webGetAdminAccount();%>';


function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}
	
	if(LockLeftTime == 1)
	{
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';			
	}
	else
	{		
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
	}
	
	SetDivValue("DivErrPage", errhtml);
	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{	
	clearInterval(locklefttimerhandle); 
    if('1' == FailStat)
	{
		var errhtml = 'Too many retrials.';	
		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{			
		var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';		
		SetDivValue("DivErrPage", errhtml); 
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);				
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum)) 
	{		
		var errhtml = 'Incorrect account/password combination. Please try again.';		
		SetDivValue("DivErrPage", errhtml);
	}
	else
	{
		document.getElementById('loginfail').style.display = 'none';
	}
}


function SubmitForm() {
    var Username = document.getElementById('txt_Username');
    var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;
	
	if (Var_DefaultLang == "chinese")
	{
		Var_DefaultLang = "english";
		Language = Var_DefaultLang;
	}
  
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("We cannot support the IE version which is lower than 6.0.");
				return false;
			}
		}
		
		if (Username.value == "") {
			alert("Account is a required field.");
			Username.focus();
        	return false;
		}
		
		if (Password.value == "") {
			alert("Password is a required field.");
			Password.focus();
        	return false;
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
	Form.addParameter('UserName', Username.value);
	Form.addParameter('PassWord', base64encode(Password.value));
    document.cookie = cookie2;
    Username.disabled = true;
    Password.disabled = true;
    Form.addParameter('x.X_HW_Token', cnt);
	Form.setAction('/login.cgi');
	Form.submit();
    return true;
}

function IsIEBrower(num) {
    var ua = navigator.userAgent.toLowerCase();
    var isIE = ua.indexOf("msie")>-1;
    var safariVersion;
    if(isIE){
        safariVersion =  ua.match(/msie ([\d.]+)/)[1];
        var sa = parseInt(safariVersion);
        if(safariVersion <= num ){
           alert("Your browser version is outdated (IE 6, IE 7, and IE 8 are not supported). You must upgrade your browser to IE 9 or later. ");
        }
    }
}

function LoadFrame() {
	
    document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);

    	
	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
    }
	if( "1" == FailStat)
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	
    init();
}

function init() {
    if (document.addEventListener) {
        document.addEventListener("keypress", onHandleKeyDown, false);
    } else {
        document.onkeypress = onHandleKeyDown;
    }
}
function onHandleKeyDown(event) {
    var e = event || window.event;
    var code = e.charCode || e.keyCode;

    if (code == 13) {
        SubmitForm();
    }
}

function CancleFunction()
{
	document.getElementById('txt_Username').value='';
	document.getElementById('txt_Password').value='';
}
</script>
</head>
<body onLoad="LoadFrame();">
<div id="main_wrapper">
      <table width="955" height="719" font style="font-size:16px;">
      <tr>
        <td  height="330">
            <table  border="0" cellpadding="0" cellspacing="0" width="100%" font style="font-size:16px;">
            <tr>  
            <td width="24">&nbsp;</td>
            <td width="273">&nbsp;</td>
            <td width="182">&nbsp;</td>
            <td width="223">&nbsp;</td>
            <td width="259">&nbsp;</td>
            </tr>
            </table> 
        </td>
      </tr> 
      
      <tr> 
        <td  height="49">
        <table  border="0" cellpadding="0" cellspacing="0" width="100%" font style="font-size:16px;">
        <tr>
            <td width="476">&nbsp;</td>
            <td><input style="font-size:12px;font-family:Tahoma,Arial; color:#718483;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="32"/></td> 
        </tr>
        </table> 
        </td>
      </tr>
      
      <tr>
        <td  height="28">
        <table  border="0" cellpadding="0" cellspacing="0" width="100%" font style="font-size:16px;">
        <tr> 
            <td width="476">&nbsp;</td>
            <td ><input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127" autocomplete="off" /></td>
         </tr>
        </table> 
        </td>
      </tr> 
     
      <tr>      
          <td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="margin-left: 80px;display: none;"> 
                <table border="0" align="center" cellpadding="0" height="28" width="50%" font style="font-size:16px;"> 
                  <tr> 
                    <td align="center" bgcolor="#FFFFFF"> <span style="color:red;font-size:12px;font-family:Arial;"> 
                      <div id="DivErrPage"></div> 
                      </span></td> 
                  </tr> 
                </table> 
              </div></td> 
          </tr> 
          
      <tr height="60">
        <td>
        <table  border="0" cellpadding="0" cellspacing="0" width="100%" font style="font-size:16px;">
                <td width="328">&nbsp;</td>
                <td>
		    <img src="images/cancel_button.jpg" width="111" height="57" style="cursor:pointer;" onClick="CancleFunction();"> 
	        </td>  
           
                <td><img src="images/login_button.jpg" width="111" height="57" style="cursor:pointer;" onClick="SubmitForm();">
                </td>  
                <td width="230">&nbsp;</td>  
	</table>    
	</td>
      </tr>   

      <tr>
        <td height="171">&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>
</div>
</body>
</html>

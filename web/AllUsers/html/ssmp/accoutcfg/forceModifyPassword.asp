<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" type="text/javascript">

var pwdLen = '<%HW_WEB_GetSPEC(SPEC_SSMP_CHKPWD_LENGTH.UINT32);%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
function stUserInfo(UserName,HintPassword)
{
    this.UserName = UserName;
    this.HintPassword = HintPassword;	
}

var UserName = "";
var curUserType = '<%HW_WEB_GetUserType();%>';
var sysUserType = '0';

function stModifyUserInfo(domain,UserName,ModifyPasswordFlag)
{
    this.domain = domain;
    this.UserName = UserName;
    this.ModifyPasswordFlag = ModifyPasswordFlag;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|ModifyPasswordFlag, stModifyUserInfo);%>;  
var PwdModifyFlag = 1;

if (curUserType == sysUserType) {
    UserName = stModifyUserInfos[1].UserName;
    PwdModifyFlag = stModifyUserInfos[1].ModifyPasswordFlag;
} else {
    UserName = stModifyUserInfos[0].UserName;
    PwdModifyFlag = stModifyUserInfos[0].ModifyPasswordFlag;
}

if((parseInt(PwdModifyFlag,10) == 0)) {
    PwdModifyFlag = 0;
}

if (PwdModifyFlag == 0) {
        AlertEx(GetLanguageDesc("s1118h"));
    } else {
        window.location="/index.asp";
}

function isValidAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch <= ' ' || ch > '~' )
        {
            return false;
        }
    }
    return true;
}

function isLowercaseInString(str) 
{
    var lower_reg = /^.*([a-z])+.*$/;
    var MyReg = new RegExp(lower_reg);
    if (MyReg.test(str)) {
        return true;
    }
    return false;
}

function isUppercaseInString(str)
{
    var upper_reg = /^.*([A-Z])+.*$/;
    var MyReg = new RegExp(upper_reg);
    if (MyReg.test(str)) {
        return true;
    }
    return false;
}

function isDigitInString(str)
{
    var digit_reg = /^.*([0-9])+.*$/;
    var MyReg = new RegExp(digit_reg);
    if (MyReg.test(str)) {
        return true;
    }
    return false;
}

function isSpecialCharacterNoSpace(str)
{
    var specia_Reg = /^.*[`~!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\'\;\,\./:\"\?><\\\|]{1,}.*$/;
    var MyReg = new RegExp(specia_Reg);
    if (MyReg.test(str)) {
        return true;
    }
    return false;
}

function reverstring(str)
{
    var tempstr = new Array();
    var i = 0;
    for (i = (str.length - 1); i >=0; i--) {
        tempstr.push(str.charAt(i));
    }

    return tempstr.join("");
}

function CheckPwdIsComplex(str) {
    var count = 0;
    if (isLowercaseInString(str)) {
        count++;
    }

    if (isUppercaseInString(str)) {
        count++;
    }

    if (isDigitInString(str)) {
        count++;
    }

    if (isSpecialCharacterNoSpace(str)) {
        count++;
    }

    if (count < 2) {
        return false;
    }

    return true;
}

function CheckParameter()
{
    var newPassword = document.getElementById("newPassword");
    var cfmPassword = document.getElementById("cfmPassword");
    var OldPasswordPwd = document.getElementById("OldPasswordPwd");

    var NormalPwdInfo = FormatUrlEncode(OldPasswordPwd.value);
    var CheckResult = 0;
    if (curUserType == sysUserType) {
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/CheckAdminPwd.asp?&1=1",
            data :'NormalPwdInfo='+NormalPwdInfo, 
            success : function(data) {
                CheckResult=data;
            }
        });
    } else {
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../common/CheckNormalPwd.asp?&1=1",
            data :'NormalPwdInfo='+NormalPwdInfo, 
            success : function(data) {
                CheckResult=data;
            }
        });
    }

    $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: "../common/getLoginTimes.asp",
            success: function (data) {
                try {
                    ModeCheckTimes = parseInt(data);
                } catch (error) {
                    window.location.href = "/";
                }
            }
    });

    if ((CheckResult != 1) && isNaN(ModeCheckTimes)) {
        AlertEx(GetLanguageDesc("s0f11_f"));
        window.location.href = "/";
        return false;
    } else if ((CheckResult != 1) && (ModeCheckTimes < errloginlockNum)) {
        AlertEx(GetLanguageDesc("s0f11"));
        return false;
    } else if (CheckResult != 1) {
        AlertEx(GetLanguageDesc("s0f11_f"));
        window.location.href = "/";
        return false;
    }

    if (OldPasswordPwd.value == "") {
        AlertEx(GetLanguageDesc("s0f0f"));
        return false;
    }

    if (newPassword.value == "") {
        AlertEx(GetLanguageDesc("s0f02"));
        return false;
    }

    if (OldPasswordPwd == newPassword) {
        AlertEx(GetLanguageDesc("s1118c"));
        return false;
    }

    if ((newPassword.value == UserName) || (newPassword.value == reverstring(UserName))) {
        AlertEx(GetLanguageDesc("s1902"));
        return false;
    }

    if (newPassword.value.length > 127) {
        AlertEx(GetLanguageDesc("s1904"));
        return false;
    }

    if (!isValidAscii(newPassword.value)) {
        AlertEx(GetLanguageDesc("s0f04"));
        return false;
    }
    
    if (cfmPassword.value != newPassword.value) {
        AlertEx(GetLanguageDesc("s0f06"));
        return false;
    }

    if (newPassword.length < 6) {
        AlertEx(GetLanguageDesc("s1118g"));
        return false;
    }

    if(!CheckPwdIsComplex(newPassword.value)) {
        AlertEx(GetLanguageDesc("s1902"));
        return false;
    }

    setDisable('ModifyPwdApply', 1);
    setDisable('ModifyPwdCancel', 1);

    return true;
}

function SubmitPwd()
{    
    if(!CheckParameter()) {
        return false;
    }

    var parainfo = "";
    var url = "set.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2&RequestFile=html/ssmp/accoutcfg/forceModifyPassword.asp";
    if (curUserType != "0") {
        url = "set.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1&RequestFile=html/ssmp/accoutcfg/forceModifyPassword.asp";
    }
    parainfo = 'x.Password=' + FormatUrlEncode(getValue('newPassword')) + "&";
    parainfo += 'x.OldPassword=' + FormatUrlEncode(getValue('OldPasswordPwd')) + "&";
    parainfo += 'x.X_HW_Token=' + getValue('onttoken');
    $.ajax({
         type : "POST",
         async : false,
         cache : false,
         data : parainfo,
         url : url,
         success : function(data) {
                    AlertEx(GetLanguageDesc("s0f0e"));
                    window.location="/index.asp";
         }
    });
}

function GetLanguageDesc(Name)
{
    return AccountLgeDes[Name];
}

</script>
</head>
<body  class="mainbody" style="margin: 0 auto; width: 50%;background: #fff;border: 1px solid #E2E2E2">
<script language="JavaScript" type="text/javascript">
</script>
<div class="title_spread"></div>
<table width="100%" height="10" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
  <td id="defaultpwdnotice"></td> 
  </tr> 
</table> 

 <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
  <tr id="secUsername"> 
  <td class="width_per40">
  <table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF" class="tabal_bg">
  <tr>
  <td class="table_title_pwd width_per60" BindText="s0f08"></td>
    <td  class="table_right_pwd"> 
        <script language="JavaScript" type="text/javascript">
        document.write(htmlencode(UserName));
        </script> 
    </td> 
  </tr> 
  <tr> 
  <td class="table_title_pwd width_per60" BindText="s0f13"></td>
    <td  class="table_right_pwd" >
          <input name='OldPasswordPwd' type="password" autocomplete="off" id="OldPasswordPwd" size="15"> 
    </td> 
  </tr> 
  <tr> 
  <td class="table_title_pwd width_per60" BindText="s0f09"></td>
    <td  class="table_right_pwd" >
          <input name='newPassword' type="password" autocomplete="off" id="newPassword" size="15">
          <script>
            $('#newPassword').blur(function()
            {
            });
        </script>
    </td> 
  </tr> 
  <tr> 
  <td class="table_title_pwd width_per60" BindText="s0f0b"></td>
    <td  class="table_right_pwd"><input name='cfmPassword' type='password' autocomplete="off" id="cfmPassword" size="15"></td> 
  </tr> 
  </table>  </td>
    <script language="JavaScript" type="text/javascript">
        if (pwdLen == 10) {
        document.write('<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1118a" ></td>');
        } else {
        document.write('<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1116" ></td>');
        }
    </script>
  </tr> 
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
  <tr> 
    <td class="table_submit width_per25"></td> 
    <td  class="table_submit"> 
      <input class="ApplyButtoncss buttonwidth_100px"  name="ModifyPwdApply" id="ModifyPwdApply" type="button" onClick="SubmitPwd();" BindText="s0f0c"> 
    </td> 
  </tr> 
</table>
<div id="websslpage" style="display:none;">
<div class="func_spread"></div>
<div class="func_title" BindText="s0d23"></div>
<form id="WebcertCfgForm">
<table id="WebcertCfgFormPanel" class="tabal_bg" width="100%" cellspacing="1" cellpadding="0"> 
<li   id="WebCertificateEnable"   RealType="CheckDivBox"   DescRef="s0d25"    RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Enable" 
InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:310px; border:solid 1px #999999; background:#edeef0;'}]}]" ClickFuncApp="onClick=SetCertificateInfo"/>
<li   id="WebcertPassword"   RealType="TextBox"    DescRef="s0d26"    RemarkRef="s1905a"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.CertPassword" 
 ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
<li   id="WebCfmPassword"   RealType="TextBox"    DescRef="s0d28"    RemarkRef="s1905a"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="CfmPassword"  InitValue="Empty"/>
</table>
<script>
var WebcertCfgFormList = new Array();
WebcertCfgFormList = HWGetLiIdListByForm("WebcertCfgForm", null);
var TableClass = new stTableClass("width_per20", "width_per80", "");
HWParsePageControlByID("WebcertCfgForm", TableClass, AccountLgeDes, null);
</script>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">  
<tr>
<td  class="width_per30"></td> 
<td  class="table_submit">
<input  class="ApplyButtoncss buttonwidth_100px" name="PWDbtnApply" id= "PWDbtnApply" type="button" BindText="s0d21" onClick="AddSubmitImportcert();"> 
<input class="CancleButtonCss buttonwidth_100px" name="PWDcancelValue" id="PWDcancelValue" type="button" BindText="s0d22" onClick="CancelConfigPwd();"> 
</td> 
</tr> 
</table> 
</form>
<div class="func_spread"></div>
<form action="websslcert.cgi?RequestFile=html/ssmp/accoutcfg/TelmexMdyAdminPwd.asp" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage"> 
  <div>
    <div class="func_title" BindText="s0d29"></div>  
    <table> 
      <tr> 
        <td BindText="s0d2a"></td> 
        <td> 
            <div class="filewrap"> 
            <div class="fileupload">
              <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
              <input type="text" id="f_file" autocomplete="off" readonly="readonly" /> 
              <input type="file" name="browse" id="t_file" size="1"  onblur="StartFileOpt();" onchange="fchange();" /> 
              <input id="btnBrowse" type="button" class="CancleButtonCss filebuttonwidth_100px" BindText="s0d2b" /> 
            </div> 
          </div>
        </td> 
        <td> <input class="CancleButtonCss filebuttonwidth_100px" id="ImportCertification" name="btnSubmit" type='button' onclick='uploadCert();' BindText="s0d2c" /> </td> 
      </tr> 
    </table> 
  </div> 
</form> 
<div class="func_spread"></div>
</div> 

<script>
    var ele = document.getElementById("WebcertPassword");
    ele.setAttribute('title', '');

    ele = document.getElementById("WebCfmPassword");
    ele.setAttribute('title', '');
        
    ParseBindTextByTagName(AccountLgeDes, "div",    1);
    ParseBindTextByTagName(AccountLgeDes, "td",     1);
    ParseBindTextByTagName(AccountLgeDes, "input",  2);
</script>
</body>
</html>
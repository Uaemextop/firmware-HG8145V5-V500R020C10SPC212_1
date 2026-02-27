<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type='text/css'>
  span.language-string {
  padding: 0px 15px;
  display: block;
  height: 40px;
  line-height: 40px;
}
.row.hidden-pw-row {
  width: 132px;
  height: 30px;
  line-height: 30px;
}
</style>
<script language="JavaScript" type="text/javascript">
var MultiUser = 0;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var ShowOldPwd = 0;
var sptUserName = null;
var sptAdminName;
var UserNum = 0;
var CurUserBuf = new Array(); 
var CurUserInst = new Array(); 
var Ftmodifyadmin = '<%HW_WEB_GetFeatureSupport(FT_WEB_MODIFY_USER_PWD);%>';  
var RosFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_ROS);%>'; 
var PwdType = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_PWDTYPE.UINT32);%>'
var PwdMinLen = '<%HW_WEB_GetSPEC(SPEC_SSMP_CHKPWD_LENGTH.UINT32);%>'
var apcmodefeature = '<%HW_WEB_GetFeatureSupport(FT_SSMP_AP_OPERATION_SWITCH);%>';
var GhnDevFlag = '<%HW_WEB_GetFeatureSupport(FT_SSMP_GHNAP_MNGT);%>';
var curChangeMode = '<%HW_WEB_GetAPChangeModeValue();%>'; 
var Ftmodifyowner =  '<%HW_WEB_GetFeatureSupport(FT_WEB_MODIFY_OWNER_PWD);%>';
var PwdTipsFlag = '<%HW_WEB_GetFeatureSupport(FT_WEB_SHOW_PWD_TIPS);%>';
var IsViettel8045A2Flag='<%HW_WEB_GetFeatureSupport(FT_SSMP_VIETTEL_8045MODE);%>';
var CmccRmsOsgiFlag = '<%HW_WEB_GetFeatureSupport(FT_CMCC_RMS_OSGI);%>';
var CmccOsgiFlag = '<%HW_WEB_GetFeatureSupport(FT_CMCC_OSGI);%>';
var clisynFlag = '<%HW_WEB_GetFeatureSupport(HW_FT_CLI_WEB_PASSWORD_SYN);%>';
var cliadminsynFlag = '<%HW_WEB_GetFeatureSupport(HW_FT_CLI_WEB_PASSWORD_AUTH_IG);%>';
var adminUsrName = "";
var curUserType = '<%HW_WEB_GetUserType();%>';
var sysUserType = '0';
var UserNameNormal = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1.UserName);%>';
var UserNameAdmin = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2.UserName);%>';
function InitValue()
{
	if (curUserType == sysUserType) {
		getElementById("WebUserName").innerHTML = UserNameAdmin;
	} else {
		getElementById("WebUserName").innerHTML = UserNameNormal;
	}	
}
function GetLanguageDesc(Name)
{
	return AccountLgeDes[Name];
}

function stModifyUserInfo(domain,UserName,UserLevel,Enable)
{
	this.domain = domain;
	this.UserName = UserName;
	this.UserLevel = UserLevel;
	this.Enable = Enable;
}

function stSSLWeb(domain,Enable)
{
	this.domain = domain;
	this.Enable   = Enable;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel|Enable, stModifyUserInfo);%>;
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var stSSLWebs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebSslInfo,Enable,stSSLWeb);%>;
var SSLConfig = stSSLWebs[0];
var IsSurportWebsslPage  = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_WEBSSLPAGE);%>';
if (3 < stModifyUserInfos.length)
{
	MultiUser = 1;
}

if (Ftmodifyowner == 1)
{
	for (var i = 0; i < stModifyUserInfos.length - 1; i++) {
		if (stModifyUserInfos[i].UserLevel == 0) {
			sptAdminName = stModifyUserInfos[i].UserName;
			sptUserName = stModifyUserInfos[i].UserName;
			adminUsrName = stModifyUserInfos[i].UserName;
			ShowOldPwd = 1;			
			UserNum = 1; 
			CurUserInst[0]= i;
			break;
		}		
	}
}
else
{
	for (var i = 0; i < stModifyUserInfos.length - 1; i++) {
		if (stModifyUserInfos[i].UserLevel == 0) {
			sptAdminName = stModifyUserInfos[i].UserName;
			adminUsrName = stModifyUserInfos[i].UserName;
		}
			
		if (Ftmodifyadmin == 1) {
			if (stModifyUserInfos[i].Enable == 1) {
				if (UserNum == 0) {
					if (stModifyUserInfos[i].UserLevel == 0) {
						ShowOldPwd = 1;
					}
		
					sptUserName = stModifyUserInfos[i].UserName;
				}
				
				CurUserInst[UserNum] = i;
				UserNum++;
			}
		} else if (null == sptUserName) {
			if (stModifyUserInfos[i].UserLevel == 1) {
				sptUserName = stModifyUserInfos[i].UserName;
				CurUserInst[UserNum] = i;
				UserNum++;
			}
		}
	}
}
if (1 < UserNum)
{
	MultiUser = 1;
}

function title_show(input)
{
	var div=document.getElementById("title_show");
	div.style.left = (input.offsetLeft + 375) + "px";
	div.innerHTML = WebcertmgntLgeDes['s1116'];
	div.style.display = '';
}
function title_back(input)
{
	var div=document.getElementById("title_show");
	div.style.display = "none";
}

function WriteUserListOption(val)
{
	var j = 0;
	if (stModifyUserInfos != 'null') {
		var output = '<select id="WebUserList" name="WebUserList" onchange="ShowOldArea(this.value)">';
		for (i = 0; i < stModifyUserInfos.length - 1; i++) {
			if (stModifyUserInfos[i].Enable == 1) {
				output += '<option value="' + (j+1) + '">' + htmlencode(stModifyUserInfos[i].UserName) + '</option>';
				CurUserBuf[j] = htmlencode(stModifyUserInfos[i].UserName); 
				j++;
			}
		}
		output +="</select>" ;

		$("#" + val).append(output);
		return true;
	} else {
		return false;
	}
}

function CheckPwdIsComplex(str)
{
	var i = 0;

	if (CfgMode.toUpperCase() == "TEDATA2") {
		if (str.length < 8) {
			return false;
		}

		if (!CompareString(str,sptUserName)) {
			return false;
		}

		if ((isLowercaseInString(str) == true) || (isUppercaseInString(str) == true)) {
			i++;
		}

		if (isDigitInString(str)) {
			i++;
		}

		if (isSpecialCharacterNoSpace(str)) {
			i++;
		}
		
		if (i >= 3) {
			return true;
		}
	} else {
		if (str.length < 6) {
			return false;
		}

		if (!CompareString(str,sptUserName)) {
			return false;
		}

		if (isLowercaseInString(str)) {
			i++;
		}

		if (isUppercaseInString(str)) {
			i++;
		}

		if (isDigitInString(str)) {
			i++;
		}

		if (isSpecialCharacterNoSpace(str)) {
			i++;
		}
		
		if (i >= 2) {
			return true;
		}
	}

	return false;
}

function CheckPwdIsComplexWithSpace(str)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}

	if (!CompareString(str,sptUserName) )
	{
		return false;
	}

	if ( isLowercaseInString(str) )
	{
		i++;
	}

	if ( isUppercaseInString(str) )
	{
		i++;
	}

	if ( isDigitInString(str) )
	{
		i++;
	}

	if ( isSpecialCharacterInString(str) )
	{
		i++;
	}
	if ( i >= 2 )
	{
		return true;
	}
	return false;
}
function LoadFrame()
{
    InitValue();
	if ((curChangeMode !="" && curChangeMode != 0) || GhnDevFlag == 1)
	{
		$("#checkinfo1Row").css("display", "none");
		
		$("#wssl").css("display", "none");
		$("#yssl").css("display", "");
		$("#wssll").css("display", "none");
		$("#yssll").css("display", "");

	}
	else
	{
		$("#checkinfo1Row").css("display", "none");
		
		$("#wssl").css("display", "");
		$("#yssl").css("display", "none");
		$("#wssll").css("display", "");
		$("#yssll").css("display", "none");
	}
	
	if ((ShowOldPwd == 1) && (CfgMode.toUpperCase() != "TEDATA2"))
	{
		document.getElementById('oldPasswordDEFHIDERow').style.display  = ""; 
	}	
	
	if( ( window.location.href.indexOf("complex.cgi?") > 0) )
	{
		AlertEx(GetLanguageDesc("s0d14"));
	}

	
    
    if((curChangeMode != "" && curChangeMode != 0) || GhnDevFlag == 1 || PwdTipsFlag == 1)
    {
        var pwdcheck1 = document.getElementById('checkinfo1');
        pwdcheck1.innerHTML =' <div class="row hidden-pw-row" id="psd_checkpwd" style="display:none;"><div class="left" style="display: table-cell; float:left; width: 126px;"><span style="text-align:center;" class="language-string" id="pwdvalue1" BindText="s1448"></span> </div></div>';
    }
    if (PwdType == 3)
    {
        document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("ss1116f");
    }
    else
    {
		if (CfgMode.toUpperCase() == "DTURKCELL2WIFI")
		{
			if (adminUsrName == sptUserName)
			{
				document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("s1116h");
			}
			else
			{
				document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("s1116i");
			}
		} else if (CfgMode.toUpperCase() == "TEDATA2") {
			document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("s1116b");
		} else {
			document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("s1116a");
		}
		
    }
}

function ShowOldArea(pwdlevel)
{
    if (pwdlevel == 0)
    {    
        return;
    }
    
    sptUserName = CurUserBuf[pwdlevel - 1];
    if (sptAdminName == sptUserName)
    {
        ShowOldPwd = 1;
        document.getElementById('oldPasswordDEFHIDERow').style.display  = ""; 
    }
    else
    {
        ShowOldPwd = 0;
        document.getElementById('oldPasswordDEFHIDERow').style.display  = "none"; 
    }
    CancelValue();
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

function CheckParaWeak()
{
    var newPassword = document.getElementById("newPassword").value;
	if (newPassword.length > 32)
	{
		AlertEx("The password must contain at most 32 characters.");
		return false;
	}
    
    if (newPassword.length < PwdMinLen)
    {
        AlertEx("The password must contain at least 6 characters.");
        return false;
    }
        
    if (newPassword.charAt(0) == " " || newPassword.charAt(newPassword.length-1) == " ")
    {
        AlertEx("The password must not include the space character at the beginning of the key or at the end.");
        return false;
    }
    
    for(var i = 0; i <= newPassword.length-2; i++)
    {
        if(newPassword.charAt(i) == " " && newPassword.charAt(i+1) == " ")
        {
           AlertEx("The password can not have several consecutive spaces.");
            return false;        
        }
    }
    return true;
}

function CheckPwdIsComplexForViettel8045A2(str)
{
if ( 8 > str.length )
    {
        return false;
    }
    if ( !isLowercaseInString(str) )
    {
       return false;
    }
    if ( !isUppercaseInString(str) )
    {
        return false;
    }
    if ( !isDigitInString(str) )
    {
        return false;
    }
	if ( !isSpecialCharacterNoSpace(str) )
    {
         return false;
    }

	return true
}

function CheckParameter()
{
	var newPassword = getValue("newPassword");
	var cfmPassword = getValue("cfmPassword");
	var CheckResult = 0;
	var CheckResultPwdSsid1 = 0;
	var CheckResultPwdSsid2 = 0;
	
	if (newPassword == "")
	{
		alert(AccountLgeDes["S2415"]);
		return false;
	}

	if (newPassword.length > 127)
	{
		alert(AccountLgeDes["S2416"]);
		return false;
	}

	if (!isValidAscii(newPassword))
	{
		alert(AccountLgeDes["S2417"]);
		return false;
	}

	if (cfmPassword != newPassword)
	{
		alert(AccountLgeDes["S2418"]);
		return false;
	}

	if(!CheckPwdIsComplex(newPassword))
	{
		alert(AccountLgeDes["S2420"]);
		return false;
	}

	return true;
}

function SubmitPwd()
{
	if(CheckParameter() == false)
	{
		return false;
	}
	
	var Form = new webSubmitForm();

	if (curUserType != sysUserType)
	{
		Form.addParameter('z.Password', getValue('newPassword'));
		Form.setAction('MdfPwdNormalNoLg.cgi?&z=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1&RequestFile=/login.asp');
	}
	else if (curUserType == sysUserType)
	{
		Form.addParameter('z.Password', getValue('newPassword'));
		Form.setAction('MdfPwdAdminNoLg.cgi?&z=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2&RequestFile=/login.asp');
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
		
	Form.addParameter('x.X_HW_Token', cnt);
	Form.submit();
}

function GetLanguageDesc(Name)
{
    return AccountLgeDes[Name];
}

function CancelValue()
{
    setText('newPassword','');
    setText('cfmPassword','');
    setText('oldPasswordDEFHIDE','');
    
    if((curChangeMode != "" && curChangeMode != 0) || GhnDevFlag == 1 || PwdTipsFlag == 1)
    {
        $("#checkinfo1Row").css("display", "none");
        $("#psd_checkpwd").css("display", "none");
    }
}
function fchange() {
    var ffile = document.getElementById("f_file");
    var tfile = document.getElementById("t_file");
    ffile.value = tfile.value;

    var buttonstart = document.getElementById('ImportCertification');
    buttonstart.focus();
}
function GetLanguageDesc(Name)
{
    return AccountLgeDes[Name];
}


function CheckNoticeForSSL(){

	var password1 = getElementById("WebcertPassword").value;
	
	if(password1.length == 0){
		return;
	}
	
	if(CheckPwdIsComplexWithSpace(password1) == false)
	{
		AlertEx(GetLanguageDesc("s1902"));
		return false;
	}
	
	return true;
}

function CheckPwdNotice()
{
	var password1 = getElementById("newPassword").value;
	
	if(password1.length == 0){
		return;
	}
	
	if(!CheckPwdIsComplex(password1)&&(IsViettel8045A2Flag!=1))
	{
        if(PwdType == 3)
        {
            var confirmVal = confirm(GetLanguageDesc("s1902a"));
            if(confirmVal){
                return;
            }
            else{
				setText('newPassword','');
                return;
            }    
        }
        else
        {
            AlertEx(GetLanguageDesc("s1902"));    
            return false;
            
        }
        
    }
	
	return;
}

function psdStrength()
{
	var lengthmatch=0;
	var lowerCharmatch=0;
	var upCharmatch=0;
	var NumCharmatch=0;
	var specialCharmatch=0;
    var score = 0;
	var totalscore = 0;
    var password1 = getElementById("newPassword").value;
	var DestPwdLen=6;
	
	if ("DTURKCELL2WIFI" == CfgMode.toUpperCase() && curUserType == sysUserType)
	{
		DestPwdLen = 8;
	}

    if(password1.length >= DestPwdLen) {
		lengthmatch = 1;
		score++;
	}

    if(password1.match(/[a-z]/)) {
		lowerCharmatch = 1;
		score++;
	}
	
	if(password1.match(/[A-Z]/)){
		upCharmatch = 1;
		score++;
	}
	
	if(password1.match(/[0-9]/)){
		NumCharmatch = 1;
		score++;
	}

    if(password1.match(/\d/)) score++;

    if ( password1.match(/.[!,@,#,$,%,^,&,*,?,_,~,-,(,)]/) ) {
		specialCharmatch=1;
		score++;
	}
	
	totalscore = lengthmatch + lowerCharmatch + upCharmatch + NumCharmatch + specialCharmatch;
	
	if(0 == lengthmatch || totalscore <=2 ){
	    getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s1448');
        getElementById("pwdvalue1").style.width=18+"%";
        getElementById("pwdvalue1").style.borderBottom="4px solid #FF0000";
        getElementById("pwdvalue1").style.float="left";
        getElementById("pwdvalue1").style.display="block";
		return;
	}
	
	
	if(1 == lengthmatch && totalscore == 3){
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s1449');
        getElementById("pwdvalue1").style.width=49.8+"%";
        getElementById("pwdvalue1").style.borderBottom="4px solid #FFA500";
		return;
	}
	
	if(1 == lengthmatch && totalscore > 3 ){
        getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s1450');
        getElementById("pwdvalue1").style.width=100+"%";
        getElementById("pwdvalue1").style.borderBottom="4px solid #008000";
		return;
	}
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();">
    <script language="JavaScript" type="text/javascript">    
    if(1 == Ftmodifyadmin)
    {
        HWCreatePageHeadInfo("accountadmin", GetDescFormArrayById(AccountLgeDes, "s0102"), GetDescFormArrayById(AccountLgeDes, "s0f12"), false);
    }
    else
    {
        HWCreatePageHeadInfo("accountadmin", GetDescFormArrayById(AccountLgeDes, "s0102"), GetDescFormArrayById(AccountLgeDes, "s0f07"), false);
    }
        
    </script>
    <div class="title_spread"></div>
    <div class="func_title" BindText="s0101"></div>
    <table width="100%" border="0" cellpadding="0" cellspacing="1">
        <tr id="secUsername">
            <td class="width_per40">
                <form id="PwdChangeCfgForm"  name="PwdChangeCfgForm">
                    <table id="PwdChangeCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF">
                        <li id="WebUserName" RealType="HtmlText" DescRef="s0f08" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="WebUserName" InitValue="Empty"/>
                        <li id="oldPasswordDEFHIDE" RealType="TextBox"  DescRef="s0f13" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.oldPassword"  InitValue="Empty"/>
                        <li id="newPassword" RealType="TextBox"  DescRef="s0f09" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Password"  InitValue="Empty" onKeyUp="psdStrength()" />
                        <li id="cfmPassword" RealType="TextBox"  DescRef="s0f0b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"       InitValue="Empty"/>

                        <li id="checkinfo1" RealType="HtmlText"  DescRef="s1447" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField=""  InitValue="Empty" style="display:none;" />

                    </table>                    
                    <script>
                        var PwdChangeCfgFormList = new Array();
                        PwdChangeCfgFormList = HWGetLiIdListByForm("PwdChangeCfgForm", null);
                        var TableClass = new stTableClass("width_per60", "width_per40");
                        HWParsePageControlByID("PwdChangeCfgForm", TableClass, AccountLgeDes, null);
                        if (MultiUser == 1)
                        {
                            WriteUserListOption("WebUserName");
                        }
                        else
                        {
                            var PwdChangeArray = new Array();
                            PwdChangeArray["WebUserName"] = sptUserName;
                            HWSetTableByLiIdList(PwdChangeCfgFormList, PwdChangeArray, null);
                        }
                        $('#newPassword').bind('keyup',function(){
                            if((curChangeMode != "" && curChangeMode != 0) || GhnDevFlag == 1 || PwdTipsFlag == 1)
                            {
                                $("#checkinfo1Row").css("display", "");
                                $("#psd_checkpwd").css("display", "block");
                                psdStrength();
                            }
                        });
						
						$('#newPassword').blur(function()
						{
							CheckPwdNotice();
						});
                    </script>
                </form>
            </td>
            <td class="tabal_pwd_notice width_per60" id="PwdNotice"></td>
        </tr>               
    </table>
    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
        <tr>
            <td class="table_submit width_per25"></td>
            <td class="table_submit">
                <input type="button" id="MdyPwdApply"  name="MdyPwdApply"  class="ApplyButtoncss buttonwidth_100px"  onClick="SubmitPwd();"    BindText="s0f0c" />
                <input type="button" id="MdyPwdcancel" name="MdyPwdcancel" class="CancleButtonCss buttonwidth_100px" onClick="CancelValue();"  BindText="s0f0d" />
            </td>
        </tr>
    </table>
      <div class="func_spread"></div> 
    <script>
        ParseBindTextByTagName(AccountLgeDes, "div",    1);
        ParseBindTextByTagName(AccountLgeDes, "td",     1);
        ParseBindTextByTagName(AccountLgeDes, "input",  2);
    </script>
</body>
</html>

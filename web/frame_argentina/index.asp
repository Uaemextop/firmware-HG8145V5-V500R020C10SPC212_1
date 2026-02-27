<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(index.css);%>" rel="stylesheet" type="text/css" />
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="frame.asp"></script>
        <title>HUAWEI</title>
    </head>
    <body>
        <div id="main">
            <div id="header">
                <div id="headerLogoImg"></div>
                <div id="headerContent">
                    <div id="headerInfo">
                        <div id="headerTitle"></div>
                        <div id="headerLogout" style="display:none">
                            <span id="headerLogoutText"></span>
                        </div>
                    </div>
                    <div id="headerTab"><ul></ul></div>
                </div>
                <div id="headerSpace">&nbsp;</div>
            </div>
            <div id="center">
                <div id="nav"><ul></ul></div>
                <div id="content">
                    <div id="topNav">
                        <span id="topNavMainMenu"></span>&nbsp;&gt;&nbsp;<span id="topNavSubMenu"></span>
                    </div>
                    <div id="frameWarpContent">
                        <iframe id="frameContent" frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" width="100%"></iframe>
                    </div>
                </div>
            </div>
            <div id="footer">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td id="footerLogo"></td>
                        <td id="footerText"></td>
                    </tr>
                </table>
            </div>
            <div id="fresh">
                <iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="refresh.asp" width="100%"></iframe>
            </div>
        </div>
    </body>
	
<script language="JavaScript" type="text/javascript">
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var telecom = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_TELECOM);%>';

if(telecom == 1 && curUserType == sysUserType)
{
	document.getElementById("headerLogout").style.display="";
}

</script>

</html>
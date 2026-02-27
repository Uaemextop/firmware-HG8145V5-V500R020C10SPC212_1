<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="Cuscss/<%HW_WEB_GetCusSource(index.css);%>" rel="stylesheet" type="text/css" />
<link href="images/o3_logo.ico" rel="shortcut icon" type="image/x-icon" />
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="frame.asp"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebMode = '<%HW_WEB_GetWebMode();%>'; 
var wlanFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>'; 
var IsSmartDev = "<%HW_WEB_GetFeatureSupport(HW_OSGI_FT_BUNDLEINFOWEB);%>";
var IsSmartLanDev = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_LAN_UPPORT);%>";	

</script>
<title></title>
</head>
<body> 
<div id="main"> 
  <div id="header">
  <div id="headerLogoImg">
  </div>
    <div id="headerContent"> 
      <div id="headerInfo"> 
        <div id="headerTitle">
		</div> 
        <div id="headerLogout">
		<div id="headerLogoutArea"><span id="headerLogoutText"></span></div>
		<div id="headerLogoutImg"></div>
		</div>
		<div id="headerRightArea">
		<div id="headerRightImg"></div>
		<div id="CallUs"><span id="CallUsNum"></span></div>
		</div> 
      </div>
      <div id="headerTab">
        <ul> </ul> 
      </div>
    </div> 
    <div id="headerSpace">&nbsp;</div> 
  </div> 
  <div id="center"> 
    <div id="nav" class="others"> <ul> </ul> </div>
    <div id="content"> 
      <div id="topNav"> <span id="topNavMainMenu"></span>&nbsp;&gt;&nbsp;<span id="topNavSubMenu"></span> </div> 
      <div id="frameWarpContent"> 
        <iframe id="frameContent" frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" width="100%"></iframe> 
      </div> 
    </div> 
  </div> 
  <div id="footer"> 
    <table border="0" cellpadding="0" cellspacing="0" width="100%"> 
      <tr>
		  <td  valign="bottom" height="100%">
		  <div id="footLink">
		  <div id="footLinkYouTube"></div>
		  <div id="footLinkFaceBook"></div>
		  <div id="footLinkO3"><span id="footLinkO3Text"></span></div>
		  </div>
		  <div id="footCopyRight">
			<div id="footerText" nowrap></div>
			<div id="footerLogo"></div>
		  </div>
		</td>
      </tr> 
    </table> 
  </div> 
  <div id="fresh"> 
    <iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="refresh.asp" width="100%"></iframe> 
  </div> 
</div> 
</body>
</html>

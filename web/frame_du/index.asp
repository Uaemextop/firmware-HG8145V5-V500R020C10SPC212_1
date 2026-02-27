<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="Cuscss/<%HW_WEB_GetCusSource(index.css);%>" rel="stylesheet" type="text/css" />
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="frame.asp"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebMode = '<%HW_WEB_GetWebMode();%>'; 
var wlanFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
var SonetFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SONET);%>'; 
var IsSmartDev = "<%HW_WEB_GetFeatureSupport(HW_OSGI_FT_BUNDLEINFOWEB);%>";
var IsPTVDF = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_PTVDF);%>';
var IsSmartLanDev = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FT_LAN_UPPORT);%>";
var RosFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_ROS);%>'; 
function MouseProcess()
{
	$("#link_f").mouseover(function() {
		$("#link_f").css({
			"opacity" : "1"
		});
	});
	$("#link_f").mouseout(function() {
		$("#link_f").css({
			"opacity" : "0.8"
		});
	});
	
	$("#link_bird").mouseover(function() {
		$("#link_bird").css({
			"opacity" : "1"
		});
	});
	$("#link_bird").mouseout(function() {
		$("#link_bird").css({
			"opacity" : "0.8"
		});
	});
	$("#link_in").mouseover(function() {
		$("#link_in").css({
			"opacity" : "1"
		});
	});
	$("#link_in").mouseout(function() {
		$("#link_in").css({
			"opacity" : "0.8"
		});
	});
	$("#link_tube").mouseover(function() {
		$("#link_tube").css({
			"opacity" : "1"
		});
	});
	$("#link_tube").mouseout(function() {
		$("#link_tube").css({
			"opacity" : "0.8"
		});
	});
}
function LoadFrame() 
{
	MouseProcess();
}
</script>
<title>HUAWEI</title>
</head>
<body onLoad="LoadFrame();"> 
<div id="main"> 
  <div id="header"> 
<script language="JavaScript" type="text/javascript">
	document.write('<div id="headerLogoImg"></div>');	
</script>
    <div id="headerContent"> 
      <div id="headerInfo"> 
        <div id="headerTitle"></div>
        <div id="headerLogout">
		<span id="headerLogoutText"></span> </div> 
      </div> 
      <div id="headerTab"> 
        <ul> </ul> 
      </div> 
    </div> 
    <div id="headerSpace">&nbsp;</div> 
  </div> 
  <div id="center"> 
	<div id="nav" class="others"> 
		<ul> 
		</ul> 
	</div>	
	
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
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td height='100%' valign='top'></td></tr>
				<tr></tr>
			</table>
		</td>
      </tr> 
    </table> 
  </div> 
  
	<div id="link_f" style="position:relative;margin-left:40px;top:-45px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.facebook.com/du" target="_black">
			<img style="border:none;" src="images/ico_f.gif">
		</a>
	</div>
	<div id="link_bird" style="position:relative;margin-left:80px;top:-85px;height:40px;width:40px; opacity:0.8">
		<a href="https://twitter.com/dutweets" target="_black">
			<img style="border:none;" src="images/ico_bird.gif">
		</a>
	</div>
	<div id="link_in" style="position:relative;margin-left:120px;top:-125px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.linkedin.com/company/du/" target="_black">
			<img style="border:none;" src="images/ico_in.gif">
		</a>
	</div>
	<div id="link_tube" style="position:relative;margin-left:160px;top:-165px;height:40px;width:40px; opacity:0.8">
		<a href="https://www.youtube.com/user/theduchannel" target="_black">
			<img style="border:none;" src="images/ico_tube.gif">
		</a>
	</div>	
  
  <div id="fresh"> 
    <iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="refresh.asp" width="100%"></iframe> 
  </div> 
</div> 
</body>
</html>

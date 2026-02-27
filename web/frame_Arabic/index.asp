<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="Cuscss/<%HW_WEB_Resource(index.css);%>" rel="stylesheet" type="text/css" />
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="frame.asp"></script>
<title>HUAWEI</title>
<script language="JavaScript" type="text/javascript">

function changelang(obj)
{
	var Form = new webSubmitForm();
	Form.addParameter('language', obj.value);
	Form.setAction('setlanguage.cgi?'+'&RequestFile=index.asp');   
    Form.submit(); 
}
</script>
</head>
<body > 
<div id="main"> 
  <div id="header"> 
    <div id="headerContent"> 
      <div id="headerInfo">  
	  <div id="headerInfoSpace"></div>
      </div> 
      <div id="headerTab"> 
        <ul> </ul> 
	  <div id="headerInfoText">
	      <div id="headerLogout"><span id="headerLogoutText"></span></div>
	          <div id="headerlangSelect">
	              <select name="langSelect" id="langSelect" onchange="changelang(this)">
	              </select>
	          </div>
	      </div>
      </div> 
    </div> 
  </div> 
  <div id="mainspace"> </div>
  <div id="center"> 
    <div id="nav"> 
      <ul> </ul> 
    </div> 
	<div id="space"></div>
	<div id="content2"> 
	      <div id="ContentSpace"> </div>
      <div id="frameWarpContent2"> 
        <iframe id="frameContent" frameborder="0" height="480" marginheight="0" marginwidth="0" width="100%"></iframe> 
      </div> 
	  <div id="ContentSpace2"></div> 
    </div> 
  </div> 
  <div id="mainspace2"></div>
  <div id="fresh"> 
    <iframe frameborder="0" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="refresh.asp" width="100%"></iframe> 
  </div> 
</div> 
</body>
</html>
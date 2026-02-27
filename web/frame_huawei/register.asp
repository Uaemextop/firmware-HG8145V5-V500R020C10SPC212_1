<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<title>Register</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
</head>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<style type="text/css">
body {
	margin:0 auto;
	padding: 0px;
	border-width: 0px;
	text-align: center;
	vertical-align: center;
	margin-left: auto;
	margin-right: auto;
	margin-top: 80px;
	width: 955px;
	height: 600px;
}

.submit {
	background: #fefefe url(../images/button_bg.gif) center repeat-x;
	font: 12px Arial;
	color: #000;
	height: 21px;
	border: #c8c8c8 1px solid;
	padding-left: 5px;
	padding-right: 5px;
}
</style>

<script type="text/javascript">
function stRegInfo(domain,loid, state)
{
	this.domain = domain;
	this.loid  = loid;
    this.state = state;
}
var stRegInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_RegistInfo, LOID|State, stRegInfo);%>;
if(null == stRegInfos || null == stRegInfos[0])
{
	var stRegInfos = new Array(new stResultInfo("InternetGatewayDevice.X_HW_RegistInfo","","0"),null);
}
var stReginfo = stRegInfos[0];
var regLoid = stReginfo.loid;
var regStatus = stReginfo.state;

function getElementById(sId)
{
	if (document.getElementById)
	{
		return document.getElementById(sId);	
	}
	else if (document.all)
	{
		return document.all(sId);
	}
	else if (document.layers)
	{
		return document.layers[sId];
	}
	else
	{
		return null;
	}
}

function getTtemByName(id)
{   
	if (document.getElementsByName)
	{
		var item = document.getElementsByName(id);
		
		if (item.length == 0)
		{
			return null;
		}
		else if (item.length == 1)
		{
			return 	item[0];
		}
		
		return item;		
	}
}

function getElement(id)
{
	 var item = getTtemByName(id); 
	 if (item == null)
	 {
		 return getElementById(id);
	 }
	 return item;
}

function setText(id, sValue)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return false;
	}
  
  if(null != sValue)
	{
		sValue = sValue.toString().replace(/&nbsp;/g," ");
		sValue = sValue.toString().replace(/&quot;/g,"\"");
		sValue = sValue.toString().replace(/&gt;/g,">");
		sValue = sValue.toString().replace(/&lt;/g,"<");
		sValue = sValue.toString().replace(/&#39;/g, "\'");
		sValue = sValue.toString().replace(/&#40;/g, "\(");
		sValue = sValue.toString().replace(/&#41;/g, "\)");
		sValue = sValue.toString().replace(/&amp;/g,"&");
	}
	  
	item.value = sValue;
	return true;
}

function getValue(id)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return -1;
	}

	return item.value;
}

function setDisable(sId, flag)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		return false;
	}

    if ( typeof(item.disabled) == 'undefined' )
    {
        if ( item.tagName == "DIV" || item.tagName == "div" )
        {
            var ele = getDivInnerId(sId);            
            setDisable(ele, flag);
        }
    }
    else
    {
        if ( flag == 1 || flag == '1' ) 
        {
             item.disabled = true;
        }
        else
        {
             item.disabled = false;
        }     
    }
    
    return true;
}

function LoidReset()
{

	setText('LOIDValue','');
	
}

function SetCookie(cookiename, cookievalue)
{
    var expires = (SetCookie.arguments.length > 2) ? SetCookie.arguments[2] : null;
    var domain = (SetCookie.arguments.length > 4) ? SetCookie.arguments[4] : null;
    var secure = (SetCookie.arguments.length > 5) ? SetCookie.arguments[5] : false;

    var cookiepath = "/";
    if (expires != null) {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + (expires * 1000));
    }
    document.cookie = cookiename + "=" + escape (cookievalue) +((expires == null) ? "" : ("; expires="+ expdate.toGMTString()))
    +((cookiepath == null) ? "" : ("; cookiepath=" + cookiepath)) +((domain == null) ? "" : ("; domain=" + domain))
    +((secure == true) ? "; secure" : "");
}

function isValidAscString(str)
{
    for ( var i = 0 ; i < str.length ; i++ )
    {
        var ch = str.charAt(i);
        if ( ch < ' ' || ch > '~' )
        {
            return ch;
        }
    }
    return '';
}

function CheckLoidPswForm()
{
    var loid = getValue('LOIDValue');
    var inLen = 0;
	
	if ((null == loid) || ('' == loid))
	{
		alert("LOID cannot be null.");
		return false;
	}
	
	if (isValidAscString(loid) != '')
	{
		alert("Invalid string of LOID.");
		return false;
	}

	if (loid.length > 24)
	{
		alert("The string length of LOID should be less then 24 characters.");
		return false;
	}

	inLen =  loid.length;
	if( inLen != 0)
	{
    	if ( ( loid.charAt(0) == ' ' ) || (loid.charAt(inLen -1) == ' ') )
    	{
        	if(false == confirm('The LOID starts with or ends with blank space, sure to continue?'))
        	{			
        		return false;
        	}
    	}
	}	
	
	return true;
}

function LoidRegSubmit(SubmitUrl)
{
	var loidvalue = getValue('LOIDValue');	
	var paralist = "&x.UserName=" + loidvalue;
	setDisable('Submit',1);
	setDisable('Cancel',1);	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data: paralist,
		url : "loid.cgi?x=InternetGatewayDevice.X_HW_UserInfo&RequestFile=" + SubmitUrl,
		success : function(data) {
		}
	});

	window.location = "/" + SubmitUrl;
}	

function LoidSubmit()
{
	if (!CheckLoidPswForm())
	{
		return;
	}
	
	SetCookie("lStartTime",new Date());
	LoidRegSubmit("regresult.asp");
}

function LoadFrame()
{
	if ("5" == regStatus && 0 != regLoid.length)
	{
		document.getElementById('RegisterModule').style.display="none";
		window.location="/regsuccess.asp";
	}
	else
	{
		document.getElementById('RegisterModule').style.display="";
	}
}

</script>
<body onLoad="LoadFrame();"> 
<div id="RegisterModule" class="module" style="display:none;position:relative;width:600px;height:205px;background-color:#f2f2f2;border-radius:10px;margin:auto;">

	<table width="100%" height = "10px" border="0" cellspacing="1" cellpadding="0"> 
	<tr> 	<td align="center"> 	</td> 	</tr> 
	</table> 
	
	<div><p align="right"><a href="/login.asp">RETURN>></a></p></div>
	
	<table width="100%" height = "6px" border="0" cellspacing="1" cellpadding="0"> 
	<tr> 	<td align="center"> 	</td> 	</tr> 
	</table> 
	
	<div align="center">
	<p style="font-size:20px">
		Loid:&nbsp;
		<input type="text" name="textfield" id="LOIDValue" style="font-size:16px" />
		<strong style="color:#FF0033;line-height:38px;">*</strong>
	</p>
    </div>
	
	<div align="center">
	<p>
      <input class="submit" type="submit" name="Submit" value="Submit" onClick="LoidSubmit();" />
		&nbsp;&nbsp;
      <input class="submit" type="submit" name="Cancel" value="Cancel" onClick="LoidReset();" />
	</p>
    </div>
	
	<div>
		<span id="usertips"></span>  
	</div>
	
	<table width="100%" height = "10px" border="0" cellspacing="1" cellpadding="0"> 
	<tr> 	<td align="center"> 	</td> 	</tr> 
	</table> 
</div>
</body>
</html>
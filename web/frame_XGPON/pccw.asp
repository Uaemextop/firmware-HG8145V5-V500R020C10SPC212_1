<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<meta http-equiv="Pragma" content="no-cache" />
<link href="/Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet"/>
<link href="/Cuscss/<%HW_WEB_GetCusSource(frame.css);%>"  media="all" rel="stylesheet" />
<link href='/Cuscss/<%HW_WEB_GetCusSource(guide.css);%>' rel="stylesheet" type='text/css'>

<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script id="langResource" language="JavaScript" src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>"></script>

<script language="JavaScript" type="text/javascript">

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

document.title = ProductName;

var pccwCondition = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Register.Condition);%>';

var IpAddress = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress,stLanHostInfo);%>;
var Br0IpAddr = IpAddress[0].ipaddr;

if(pccwCondition == '0')
{
	window.location.replace('/login.asp');
	
}

function stLanHostInfo(domain,ipaddr)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
}


function isValidAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch < ' ' || ch > '~' )
        {
            return ch;
        }
    }
    return '';
}

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

function getElementByName(sId)
{   
	if (document.getElementsByName)
	{
		var element = document.getElementsByName(sId);
		
		if (element.length == 0)
		{
			return null;
		}
		else if (element.length == 1)
		{
			return 	element[0];
		}
		
		return element;		
	}
}

function getElement(sId)
{
	 var ele = getElementByName(sId); 
	 if (ele == null)
	 {
		 return getElementById(sId);
	 }
	 return ele;
}

function debug(info)
{
}

function getValue(sId)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return -1;
	}

	return item.value;
}

function setText(sId, sValue)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return false;
	}
    
	item.value = sValue;
	return true;
}

function getDivInnerId(divID)
{
    var nameStartPos = -1;
    var nameEndPos = -1;
    var ele;

    divHTML = getElement(divID).innerHTML;
    nameStartPos = divHTML.indexOf("name=");
    nameEndPos   = divHTML.indexOf(' ', nameStartPos);
    if(nameEndPos <= 0)
    {
        nameEndPos = divHTML.indexOf(">", nameStartPos);
    }
    
    try
    {
        ele = eval(divHTML.substring(nameStartPos+3, nameEndPos));
    }
    catch (e)
    {
        ele = divHTML.substring(nameStartPos+3, nameEndPos);
    }
    return ele;
}

function setDisable(sId, flag)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
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

function webSubmitForm(sFormName, DomainNamePrefix)
{
    this.setPrefix = function(Prefix)
    {
		if (Prefix == null)
		{
			this.DomainNamePrefix = '.';
		}
		else
		{
			this.DomainNamePrefix = Prefix + '.';
		}
	}
	
	this.getDomainName = function(sName){
		if (this.DomainNamePrefix == '.')
		{
		    return sName;
		}
		else
		{
		    return this.DomainNamePrefix + sName;
		}
	}
	
    this.getNewSubmitForm = function()
	{
		var submitForm = document.createElement("FORM");
		document.body.appendChild(submitForm);
		submitForm.method = "POST";
		return submitForm;
	}
	
	this.createNewFormElement = function (elementName, elementValue){
	    var newElement = document.createElement('INPUT');
		newElement.setAttribute('name',elementName);
		newElement.setAttribute('value',elementValue);
		newElement.setAttribute('type','hidden');
		return newElement;
	}
	
	this.addForm = function(sFormName,DomainNamePrefix){
	    this.setPrefix(DomainNamePrefix);
	    var srcForm = getElement(sFormName);
		if (srcForm != null && srcForm.length > 0 && this.oForm != null 
			&& srcForm.style.display != 'none')
		{
			MakeCheckBoxValue(srcForm);
			
			for(i=0; i < srcForm.elements.length; i++)
			{  
			     var type = srcForm.elements[i].type;
			     if (type != 'button' && srcForm.elements[i].disabled == false)
				 {				
					 if (this.DomainNamePrefix != '.')
					 {
						 var ele = this.createNewFormElement(this.DomainNamePrefix 
												              + srcForm.elements[i].name,
												              srcForm.elements[i].value);	
						 this.oForm.appendChild(ele);
					 }	   
					 else
					 {
						var ele = this.createNewFormElement(srcForm.elements[i].name,
												             srcForm.elements[i].value
															  );
						this.oForm.appendChild(ele);
					 }	 
				 }
			 }
		}
		else
		{
			this.status = false;
		}
		
		this.DomainNamePrefix = '.';
	}
    
	this.addDiv = function(sDivName,Prefix)
	{
		if (Prefix == null)
		{
			Prefix = '';
		}
		else
		{
			Prefix += '.';
		}
		
		var srcDiv = getElement(sDivName);	
		if (srcDiv == null)
		{
			debug(sDivName + ' is not existed!')
			return;
		}
		if (srcDiv.style.display == 'none')
		{
			return;
		}
		var eleSelect = srcDiv.getElementsByTagName("select");
		if (eleSelect != null)
	    {
			for (k = 0; k < eleSelect.length; k++)
			{
				if (eleSelect[k].disabled == false)
				{
					this.addParameter(Prefix+eleSelect[k].name,eleSelect[k].value)
				}
			}
		}
		
		MakeCheckBoxValue(srcDiv);
		var eleInput = srcDiv.getElementsByTagName("input");
		if (eleInput != null)
	    {
			for (k = 0; k < eleInput.length; k++)
			{
				if (eleInput[k].type != 'button' && eleInput[k].disabled == false)
				{
				    this.addParameter(Prefix+eleInput[k].name,eleInput[k].value)
				}
			}	
		}
	}
	
	this.addParameter = function(sName, sValue){
		var DomainName = this.getDomainName(sName);
		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].value = sValue;
				this.oForm.elements[i].disabled = false;
				return;
			}
		}
	
		if(i == this.oForm.elements.length) 
		{	
			var ele = this.createNewFormElement(DomainName,sValue);	
			this.oForm.appendChild(ele);
		}
	}
	
    this.disableElement = function(sName){	
	    var DomainName = this.getDomainName(sName);		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].disabled = true;
				return;
			}
		}
	}
	
    this.usingPrefix = function(Prefix){
	     this.DomainNamePrefix = Prefix + '.';
	}
	
    this.endPrefix = function(){
	     this.DomainNamePrefix = '.';
	}
	
	this.setMethod = function(sMethod) {
		if(sMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};

	this.setAction = function(sUrl) {
		this.oForm.action = sUrl;
	}

	this.setTarget = function(sTarget) {
		this.oForm.target = sTarget;
	};

	this.submit = function(sURL, sMethod) {
		if( sURL != null && sURL != "" ) this.setAction(sURL);
		if( sMethod != null && sMethod!= "" ) this.setMethod(sMethod);
		
		if (this.status == true)
		    this.oForm.submit();
	};
	
	this.status = true;

	this.setPrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if (sFormName != null && sFormName != '')
	{
		this.addForm(sFormName,this.DomainNamePrefix);
	}
}

function MakeCheckBoxValue(srcForm)
{
	var Inputs = srcForm.getElementsByTagName("input");
	for (var i = 0; i < Inputs.length; i++) 
	{
		if (Inputs[i].type == "checkbox")
		{
			var CheckBox = getElement(Inputs[i].name);

			if (CheckBox.checked == true)
			{
				CheckBox.value = 1;
			}
			else
			{
				CheckBox.value = 0;
			}
		}
		else if (Inputs[i].type == "radio")
		{
			var radio = getElement(Inputs[i].name);
	        for (k = 0; k < radio.length; k++)
			{
				if (radio[k].checked == false)
				{
				    radio[k].disabled = true;
				}				
			}
		}
	}
}

function Submit(type)
{
    if (CheckForm(type) == true)
	{
	    var Form = new webSubmitForm();
	    AddSubmitParam(Form,type);		
		Form.submit();
	}
}

function LoadFrame() {
    document.getElementById('txt_Password').focus();
 }

function SubmitPassword()
{
    var Password = document.getElementById("txt_Password");
	if (Password.value.length > 10)
	{
	    alert("The password length must be from 0 to 10 characters long.");
		return false;
	}
	var SubmitForm = new webSubmitForm();
	
	SubmitForm.addParameter('x.X_HW_PonPassword', getValue('txt_Password'));

	SubmitForm.addParameter("y.RegistrationID", getValue('txt_Password'));
	SubmitForm.addParameter("y.PreSharedKey", getValue('txt_Password'));
						
	SubmitForm.addParameter('x.X_HW_ForceSet', 1);
	SubmitForm.setAction('PccwReg.cgi?' +'x=InternetGatewayDevice.DeviceInfo&y=InternetGatewayDevice.X_HW_XgponDeviceInfo&RequestFile=PccwShowProc.asp');
    setDisable('button_cancel',1);
	setDisable('button_submit',1);
	SubmitForm.submit();
	return true;
}

function CleanPassword()
{   
	setText('txt_Password', '');
}

</script>

</head>

<body onLoad="LoadFrame();"> 

<div id="main_wrapper">
	<div id="loginarea">

		<div style="width:100%;">
			<div id="brandlog"></div>
			<div id="ProductName"><script>document.write(ProductName);</script></div>
		</div>

		<div style="float:right; ">
			<a id="toLogin" href="login.asp"><font color="#0000FF" style="font-size: 14px;">Return to login page</font></a>
			<script>document.getElementById("toLogin").href = "http://" + Br0IpAddr + "/login.asp"</script>
		</div>
		
		<div class="labelBoxlogin" style="text-align:center;width:100%;margin-bottom:20px;margin-top: 200px;">
			Please enter password for service authentication.</div>

		<div class="labelBoxlogin"><span id="Password" BindText="frame002"></span></div>
		<div class="contenboxlogin"><input type="password" autocomplete="off" id="txt_Password" name="txt_Password" class="logininputcss" /></div>


		<div style="float: left;width:100%;margin-left: -8px;margin-top: 20px;">
			<input type="button"  class="CancleButtonCss buttonwidth_100px" id="button_submit" onClick="SubmitPassword();" value="Submit" />
			<input type="button"  class="CancleButtonCss buttonwidth_100px" id="button_cancel" onClick="CleanPassword();" value="Clear" />
		</div>
		
	</div>
	
	<div id="greenline"></div>
	<div id="copyright">
	<div id="copyrightspace"></div>
	<div id="copyrightlog"></div>
	<script>
		document.write('<div id="copyrighttext"><span id="footer" BindText="frame015a"></span></div>');
	</script>
	</div>

</div>

<script>
	ParseBindTextByTagName(framedesinfo, "span",  1);
</script>

</body>
</html>

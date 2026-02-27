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
var logo_singtel = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_SINGTEL);%>';
var TypeWord_com = '<%HW_WEB_GetTypeWord();%>';
var IpAddress = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress,stLanHostInfo);%>;
var Br0IpAddr = IpAddress[0].ipaddr;

if (true == logo_singtel && TypeWord_com != "COMMON")
{
	var link1 = document.createElement('link');
	link1.setAttribute("rel", "shortcut icon");     
	link1.setAttribute("href", "../images/singtel.ico");	
	var link2 = document.createElement('link');
	link2.setAttribute("rel", "Bookmark");     
	link2.setAttribute("href", "../images/singtel.ico");	
	var head = document.head || document.getElementsByTagName('head')[0];
	head.appendChild(link1);
	head.appendChild(link2);
}

if(pccwCondition == '0')
{
	window.location.replace('/login.asp');
	
}

function stLanHostInfo(domain,ipaddr)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
}

function isValidAscii(asciiStr) {
    for (var i = 0; i < asciiStr.length; i++) {
        var ch = asciiStr.charAt(i);
        if ( ch < ' ' || ch > '~' ) {
            return ch;
        }
    }
    return '';
}

function getElementById(eId) {
	if (document.getElementById) {
		return document.getElementById(eId);	
	} else if (document.all) {
		return document.all(eId);
	} else if (document.layers) {
		return document.layers[eId];
	} else {
		return null;
	}
}

function getElementByName(eName) {   
	if (document.getElementsByName) {
		var element = document.getElementsByName(eName);
		if (element.length == 0) {
			return null;
		} else if (element.length == 1) {
			return 	element[0];
		}
		return element;		
	}
}

function getElement(elementAttr) {
	var ele = getElementByName(elementAttr); 
	if (ele == null) {
		return getElementById(elementAttr);
	}
	return ele;
}

function debug(info)
{
}

function getValue(elementId) {
	var item = getElement(elementId);
	if (item == null) {
		debug(elementId + " is not existed" );
		return -1;
	}
	return item.value;
}

function setText(elementId, value)
{
	var item = getElement(elementId);
	if (item == null) {
		debug(elementId + " is not existed" );
		return false;
	}
	item.value = value;
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

function setDisable(elementId, flag)
{
	var item = getElement(elementId);
	if (item == null) {
		debug(elementId + " is not existed" );
		return false;
	}

	if (typeof(item.disabled) != 'undefined') {
		if ((flag == 1) || (flag == '1')) {
			item.disabled = true;
		} else {
			item.disabled = false;
		}
		return true;
	}

	if (item.tagName == "DIV" || item.tagName == "div") {
		var element = getDivInnerId(elementId);            
		setDisable(element, flag);
	}
	
	return true;
}

function webSubmitForm(formName, DomainNamePrefix) {
    this.setPrefix = function(prefix) {
		this.DomainNamePrefix = '.';
		if (prefix != null) {
			this.DomainNamePrefix = prefix + '.';
		}
	}
	
	this.getDomainName = function(domainName) {
		if (this.DomainNamePrefix == '.') {
		    return domainName;
		} else {
		    return this.DomainNamePrefix + domainName;
		}
	}
	
    this.getNewSubmitForm = function() {
		var newForm = document.createElement("FORM");
		document.body.appendChild(newForm);
		newForm.method = "POST";
		return newForm;
	}
	
	this.createNewFormElement = function (name, value) {
	    var newElement = document.createElement('INPUT');
		newElement.setAttribute('name',name);
		newElement.setAttribute('value',value);
		newElement.setAttribute('type','hidden');
		return newElement;
	}
	
	this.addForm = function(formName, DomainNamePrefix) {
		this.setPrefix(DomainNamePrefix);
		var elementForm = getElement(formName);
		if (elementForm != null && elementForm.length > 0 && this.oForm != null && elementForm.style.display != 'none') {
			MakeCheckBoxValue(elementForm);
			for (i = 0; i < elementForm.elements.length; i++) {  
				var type = elementForm.elements[i].type;
				if (type != 'button' && elementForm.elements[i].disabled == false) {				
					if (this.DomainNamePrefix != '.') {
						var newElement = this.createNewFormElement(this.DomainNamePrefix + elementForm.elements[i].name, elementForm.elements[i].value);	
						this.oForm.appendChild(newElement);
					} else {
						var newElement = this.createNewFormElement(elementForm.elements[i].name, elementForm.elements[i].value);
						this.oForm.appendChild(newElement);
					}
				}
			}
		} else {
			this.status = false;
		}

		this.DomainNamePrefix = '.';
	}
    	
	this.addParameter = function(name, value){
		var domainName = this.getDomainName(name);
		for (i = 0; i < this.oForm.elements.length; i++) {
			if (this.oForm.elements[i].name == domainName) {
				this.oForm.elements[i].value = value;
				this.oForm.elements[i].disabled = false;
				return;
			}
		}
	
		if (i == this.oForm.elements.length) {	
			var newElement = this.createNewFormElement(domainName, value);	
			this.oForm.appendChild(newElement);
		}
	}
	
	this.setMethod = function(method) {
		if (method.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};

	this.setAction = function(url) {
		this.oForm.action = url;
	}

	this.submit = function(url, method) {
		if (url != null && url != "") {
			this.setAction(url);
		}

		if (method != null && method!= "") {
			this.setMethod(method);
		}
		
		if (this.status == true)
		    this.oForm.submit();
	};
	
	this.status = true;
	this.setPrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if (formName != null && formName != '') {
		this.addForm(formName, this.DomainNamePrefix);
	}
}

function MakeCheckBoxValue(box) {
	var inputElement = box.getElementsByTagName("input");
	for (var i = 0; i < inputElement.length; i++) {
		if (inputElement[i].type == "checkbox") {
			var checkBox = getElement(inputElement[i].name);
			if (checkBox.checked == true) {
				checkBox.value = 1;
			} else {
				checkBox.value = 0;
			}
		} else if (inputElement[i].type == "radio") {
			var radio = getElement(inputElement[i].name);
	        for (j = 0; j < radio.length; j++) {
				if (radio[k].checked == false) {
				    radio[k].disabled = true;
				}				
			}
		}
	}
}

function Submit(type) {
    if (CheckForm(type) == true) {
	    var form = new webSubmitForm();
	    AddSubmitParam(form, type);		
		form.submit();
	}
}

function LoadFrame() {
    document.getElementById('txt_Password').focus();
	
	if(true == logo_singtel)
	{
		if(TypeWord_com == "COMMON")
		{
			document.getElementById('brandlog_singtel').style.display = 'none';
		}
		else
		{
			document.getElementById('brandlog_singtel').style.display = 'block';
		}
	}
	else
	{
		document.getElementById('brandlog').style.display = 'block';
	}	
								
	if(true == logo_singtel && TypeWord_com == "COMMON")
	{
		document.getElementById('copyrightlog').style.display = 'none';
	}
	else
	{
		document.getElementById('copyrightlog').style.display = 'block';
	}	
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
	SubmitForm.setAction('RedirectReg.cgi?' +'x=InternetGatewayDevice.DeviceInfo&y=InternetGatewayDevice.X_HW_XgponDeviceInfo&RequestFile=EnRedirectShowProc.asp');
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
			<script>
			if(true == logo_singtel)
			{
				document.write('<div id="brandlog_singtel" style="display:none;"></div>');
			}
			else
			{
				document.write('<div id="brandlog" style="display:none;"></div>');
			}
			</script>   
			<div id="ProductName"><script>document.write(ProductName);</script></div>
		</div>

		<div style="float:right; ">
			<a id="toLogin" href="login.asp"><font color="#0000FF" style="font-size: 14px;">Return to login page</font></a>
			<script>document.getElementById("toLogin").href = "http://" + Br0IpAddr + "/login.asp"</script>
		</div>
		
		<div class="labelBoxlogin" style="text-align:center;width:100%;margin-bottom:20px;margin-top: 200px;">
			Please enter password for service authentication.</div>

		<div class="labelBoxlogin"><span id="Password" BindText="frame002"></span></div>
		<div class="contenboxlogin"><input autocomplete="off" type="password" id="txt_Password" name="txt_Password" class="logininputcss" autocomplete="off" /></div>


		<div style="float: left;width:100%;margin-left: -8px;margin-top: 20px;">
			<input type="button"  class="CancleButtonCss buttonwidth_100px" id="button_submit" onClick="SubmitPassword();" value="Submit" />
			<input type="button"  class="CancleButtonCss buttonwidth_100px" id="button_cancel" onClick="CleanPassword();" value="Clear" />
		</div>
		
	</div>
	
	<div id="greenline"></div>
	<div id="copyright">
	<div id="copyrightspace"></div>
	<div id="copyrightlog" style="display:none;"></div>
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

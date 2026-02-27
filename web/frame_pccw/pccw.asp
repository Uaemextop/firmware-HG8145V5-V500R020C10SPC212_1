<html>
<head>
<title></title>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<link href="/Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet"/>
<script language="JavaScript" type="text/javascript">

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

document.title = ProductName;

var pccwCondition = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Register.Condition);%>';

if(pccwCondition == '0')
{
	window.location.replace('/login.asp');
	
}

function stLanHostInfo(domain,ipaddr)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
}
 
var IpAddress = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress,stLanHostInfo);%>;
var Br0IpAddr = IpAddress[0].ipaddr

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
	SubmitForm.addParameter('x.X_HW_ForceSet', 1);
	SubmitForm.setAction('PccwReg.cgi?' +'x=InternetGatewayDevice.DeviceInfo&RequestFile=PccwShowProc.asp');
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
  <table border="0" cellpadding="0" cellspacing="0" width="100%"> 
    <tr> 
      <td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="50%"> 
          <tr> 
            <td align="right"><A href="login.asp">
              <script language="JavaScript" type="text/javascript">
            		var httplink = "http://"+Br0IpAddr+"/login.asp";
            		document.write("<A href=" + httplink + ">");
          		</script>  
            <FONT color="#0000FF">Return to login page</FONT></A></td> 
          </tr> 
        </table> 
        <table border="0" cellpadding="0" cellspacing="0" height="30" width="50%"> 
          <tr> 
            <td></td> 
          </tr> 
        </table> 
        <table border="0" cellpadding="0" cellspacing="0" width="30%"> 
          <tr> 
            <td align="center" width="36%"> <img height="75" src="/images/logo.gif" width="70" alt=""> </td> 
            <td class="hg_logo" width="64%" id="hg_logo"> <script language="JavaScript" type="text/javascript">
					document.write(ProductName);
				</script> </td> 
          </tr> 
        </table> 
        <table border="0" cellpadding="0" cellspacing="0"  width="50%"> 
          <tr> 
            <td height="25" align="center">Please enter password for service authentication.</td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td align="center" height="65"> <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="58" width="40%"> 
          <tr> 
            <td class="whitebold" height="37" align="right" id="Password">Password</td> 
            <td class="whitebold" height="37" align="center" >:</td> 
            <td> <input id="txt_Password" class="input_login" name="txt_Password" type="text" maxlength="127"> </td> 
          </tr> 
          <tr> 
            <td height="21" class="whitebold"></td> 
            <td align="left"  class="whitebold"></td> 
            <td align="left"> <input  class="submit" name="button_submit" id = "button_submit" type="button" onClick="SubmitPassword();" value="Submit"> 
&nbsp;&nbsp;&nbsp;&nbsp; 
              <input class="submit" name="button_cancel" id = "button_cancel" type="button" onClick="CleanPassword();" value="Clear"> </td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class="info_text" height="25" id="footer">Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved. </td> 
    </tr> 
    <tr> 
      <td align="center"> <table border="0" cellpadding="0" cellspacing="0" height="300" width="490" style="background: url('/images/pic.jpg') no-repeat center;"> 
          <tr> 
            <td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none"> 
                <table border="0" cellpadding="0" cellspacing="5" height="33" width="99%"> 
                  <tr> 
                    <td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;"> 
                      <div id="DivErrPage"></div> 
                      </span> </td> 
                  </tr> 
                </table> 
              </div></td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
</div> 
</body>
</html>

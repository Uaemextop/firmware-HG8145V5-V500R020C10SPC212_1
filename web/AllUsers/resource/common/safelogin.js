
var TabWidth = "75%";

function GetDescFormArrayById(Language,Name)
{
    return (Language[Name] == null || Language[Name] == "undefined") ? "" : Language[Name];
}

function ParseBindTextByTagName(LanguageArray, TagName, TagType)
{
	var all = document.getElementsByTagName(TagName);
	for (var i = 0; i < all.length; i++)
	{
		var b = all[i];
		var c = b.getAttribute("BindText");
		if(c == null)
		{
			continue;
		}
		
		if(1 == TagType)
		{
			b.innerHTML = GetDescFormArrayById(LanguageArray, c);
		}
		else if(2 == TagType)
		{
			b.value = GetDescFormArrayById(LanguageArray, c);
		}
	}
}

function isValidAscii(val)
{
 for (var i = 0 ; i < val.length ; i++)
 {
 var ch = val.charAt(i);
 if (ch < ' ' || ch > '~')
 {
 return false;
 }
 }
 return true;
}
function SetDivValue(Id, Value)
{
 try
 {
 var Div = document.getElementById(Id);
 Div.innerHTML = Value;
 }
 catch(ex)
 {
 }
}
function getElById(id)
{
 return getElement(id);
}
function getElementById(id)
{
 if (document.getElementById)
 {
 return document.getElementById(id); 
 }
 else if (document.all)
 {
 return document.all(id);
 }
 else if (document.layers)
 {
 return document.layers[id];
 }
 else
 {
 return null;
 }
}

function getElementByName(id)
{ 
 if (document.getElementsByName)
 {
 var element = document.getElementsByName(id);
 if (element.length == 0)
 {
 return null;
 }
 else if (element.length == 1)
 {
 return element[0];
 }
 return element; 
 }
}
function getElement(id)
{
 var ele = getElementByName(id); 
 if (ele == null)
 {
 return getElementById(id);
 }
 return ele;
}
function setDisplay(id, sh)
{
 var status;
 if (sh > 0) 
 {
        status = "";
 }
 else 
 {
        status = "none";
 }
 var item = getElement(id);
 if (null != item)
 {
 getElement(id).style.display = status;
 }
}
function getDivInnerId(divID)
{
 var nameStartPos = -1;
 var nameEndPos = -1;
 var ele;
 divHTML = getElement(divID).innerHTML;
    nameStartPos = divHTML.indexOf("name=");
 nameEndPos = divHTML.indexOf(' ', nameStartPos);
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
function setDisable(id, enable)
{
 var item;
 if (null == (item = getElement(id)))
 {
		debug(id + " is not existed" );
 return false;
 }
 if ( typeof(item.disabled) == 'undefined' )
 {
        if ( item.tagName == "DIV" || item.tagName == "div" )
 {
 var ele = getDivInnerId(id); 
 setDisable(ele, enable);
 }
 }
 else
 {
 if ( enable == 1 || enable == '1' ) 
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
	this.setNamePrefix = function(namePrefix) {
		if (namePrefix == null){
			this.DomainNamePrefix = '.';
		} else {
			this.DomainNamePrefix = namePrefix + '.';
		}
	}
	this.getDomainName = function(name){
		if (this.DomainNamePrefix == '.') {
			return name;
		} else {
			return this.DomainNamePrefix + name;
		}
	}
	this.getNewSubmitForm = function() {
		var newSubmit = document.createElement("FORM");
		document.body.appendChild(newSubmit);
		newSubmit.method = "POST";
		return newSubmit;
	}
	this.createNewFormElement = function (elementName, elementValue){
		var newForm = document.createElement('INPUT');
		newForm.setAttribute('name',elementName);
		newForm.setAttribute('value',elementValue);
		newForm.setAttribute('type','hidden');
		return newForm;
	}
 
	this.addForm = function(sFormName,DomainNamePrefix){
		this.setNamePrefix(DomainNamePrefix);
		var formname = getElement(sFormName);
		if ((formname != null) && (formname.length > 0) && (this.oForm != null) 
			&& (formname.style.display != 'none')) {
			MakeCheckBoxValue(formname);
			for(i=0; i < formname.elements.length; i++) { 
				var type = formname.elements[i].type;
				if (type != 'button' && formname.elements[i].disabled == false) { 
					if (this.DomainNamePrefix != '.') {
						var newform = this.createNewFormElement(this.DomainNamePrefix 
						+ formname.elements[i].name,
						formname.elements[i].value); 
						this.oForm.appendChild(newform);
					} else {
						var newform = this.createNewFormElement(formname.elements[i].name, formname.elements[i].value);
						this.oForm.appendChild(newform);
					} 
				}
			}
		} else {
			this.status = false;
		}
		this.DomainNamePrefix = '.';
	}
	this.addDiv = function(divname,divprefix) {
		if (divprefix == null) {
			divprefix = '';
		} else {
			divprefix += '.';
		}
		var srcDiv = getElement(divname); 
		if (srcDiv == null) {
			debug(divname + ' is not existed!')
			return;
		}
		if (srcDiv.style.display == 'none') {
			return;
		}
		var divSelect = srcDiv.getElementsByTagName("select");
		if (divSelect != null) {
			for (k = 0; k < divSelect.length; k++) {
				if (divSelect[k].disabled == false) {
					his.addParameter(divprefix+divSelect[k].name,divSelect[k].value)
				}
			}
		}
		MakeCheckBoxValue(srcDiv);
		var divInput = srcDiv.getElementsByTagName("input");
		if (divInput != null) {
			for (k = 0; k < divInput.length; k++) {
				if (divInput[k].type != 'button' && divInput[k].disabled == false) {
					this.addParameter(divprefix+divInput[k].name,divInput[k].value)
				}
			} 
		}
	}
	this.addParameter = function(paraName, paraValue){
		var domainNameTmp = this.getDomainName(paraName);
		for(i=0; i < this.oForm.elements.length; i++) {
			if(this.oForm.elements[i].name == domainNameTmp) {
				this.oForm.elements[i].value = paraValue;
				this.oForm.elements[i].disabled = false;
				return;
			}
		}
		if(i == this.oForm.elements.length) { 
			var ele = this.createNewFormElement(domainNameTmp,paraValue); 
			this.oForm.appendChild(ele);
		}
	}
	this.disableElement = function(name){ 
		var domainNameTmp = this.getDomainName(name); 
		for(i=0; i < this.oForm.elements.length; i++) {
			if(this.oForm.elements[i].name == domainNameTmp) {
				this.oForm.elements[i].disabled = true;
				return;
			}
		}
	}
	this.usingPrefix = function(domainPrefix){
		this.DomainNamePrefix = domainPrefix + '.';
	}
	this.endPrefix = function(){
		this.DomainNamePrefix = '.';
	}
	this.setMethod = function(paraMethod) {
		if (paraMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};
	this.setAction = function(url) {
		this.oForm.action = url;
	}
	this.setTarget = function(target) {
		this.oForm.target = target;
	};
	this.submit = function(url, sMethod) {
		if( url != null && url != "" ) this.setAction(url);
		if( sMethod != null && sMethod!= "" ) this.setMethod(sMethod);
		if(this.status == true)
			this.oForm.submit();
	};
	this.status = true;
	this.setNamePrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if(sFormName != null && sFormName != '') {
		this.addForm(sFormName,this.DomainNamePrefix);
	}
}
function Submit(type)
{
 if (CheckForm(type) == true)
 {
 var Form = new webSubmitForm();
 AddSubmitParam(Form,type); 
 Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
 Form.submit();
 }
}
function CreateXMLHttp()
{ 
	var xmlTmpHttp = null;
	var aVersions = ["MSXML2.XMLHttp.5.0","MSXML2.XMLHttp.4.0","MSXML2.XMLHttp.3.0",      
					"MSXML2.XMLHttp","Microsoft.XMLHttp"];
	if(window.XMLHttpRequest) { 
		try {
			xmlTmpHttp = new XMLHttpRequest();
		}
		catch (e) {
		}
	} else {
		if(window.ActiveXObject) { 
			for (var i=0; i<5; i++) {
				try { 
					xmlTmpHttp = new ActiveXObject(aVersions[i]);
					return xmlTmpHttp;
				}
				catch (e) {
				}
			}
		}
	} 
	return xmlTmpHttp;
}
function XmlHttpSendAspFlieWithoutResponse(FileName)
{
 var xmlHttp = null;
 if(null == FileName
	   || FileName == "")
 {
 return false;
 }
 if(window.XMLHttpRequest) {
 xmlHttp = new XMLHttpRequest();
 } else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
 }
    xmlHttp.open("GET", FileName, false);
 xmlHttp.send(null);
}

var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var base64DecodeChars = new Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1,
 -1, -1, -1, -1);
function base64encode(codeStr) {
 var c1, c2, c3;
 var strLen = codeStr.length;
 var i = 0;
 var out = "";
 while (i < strLen) {
 c1 = codeStr.charCodeAt(i++) & 0xff;
 if (i == strLen) {
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt((c1 & 0x3) << 4);
            out += "==";
 break;
 }
 c2 = codeStr.charCodeAt(i++);
 if (i == strLen) {
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
 out += base64EncodeChars.charAt((c2 & 0xF) << 2);
 out += "=";
 break;
 }
 c3 = codeStr.charCodeAt(i++);
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
 out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
 out += base64EncodeChars.charAt(c3 & 0x3F);
 }
 return out;
}
function base64decode(codeStr) {
 var c1, c2, c3, c4;
 var strLen = codeStr.length;
 var i = 0;
 var out = "";
 while (i < strLen) {
 
 do {
 c1 = base64DecodeChars[codeStr.charCodeAt(i++) & 0xff];
 } while (i < strLen && c1 == -1);
 if (c1 == -1)
 break;
 
 do {
 c2 = base64DecodeChars[codeStr.charCodeAt(i++) & 0xff];
 } while (i < strLen && c2 == -1);
 if (c2 == -1)
 break;
 out += String.fromCharCode((c1 << 2) | ((c2 & 0x30) >> 4));
 
 do {
 c3 = codeStr.charCodeAt(i++) & 0xff;
 if (c3 == 61)
 return out;
 c3 = base64DecodeChars[c3];
 } while (i < strLen && c3 == -1);
 if (c3 == -1)
 break;
 out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));
 
 do {
 c4 = codeStr.charCodeAt(i++) & 0xff;
 if (c4 == 61)
 return out;
 c4 = base64DecodeChars[c4];
 } while (i < strLen && c4 == -1);
 if (c4 == -1)
 break;
 out += String.fromCharCode(((c3 & 0x03) << 6) | c4);
 }
 return out;
}

function HwAjaxGetPara(ObjPath, ParameterList)
{
	var Result = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/getajax.cgi?' + ObjPath,
		data: ParameterList,
		success : function(data) {
			 Result  = '"' + data + '"';
		}
	});
	  
	try{
		return eval(Result);
	}
	catch(e){
		return null;	
	}
}

function HwAjaxSetPara(ObjPath, ParameterList)
{
	var Result = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/setajax.cgi?' + ObjPath + "&RequestFile=/CustomApp/index.asp",
		data: ParameterList,
		success : function(data) {
			 Result  = '"' + data + '"';
		}
	});
	
	try{
		return eval(Result);
	}
	catch(e){
		return null;	
	}
}

function HwAjaxAddPara(ObjPath, ParameterList)
{
	var Result = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/addcfg.cgi?' + ObjPath + "&RequestFile=nopage",
		data: ParameterList,
		success : function(data) {
			 Result  = '"' + data + '"';
		}
	});
	
	try{
		return eval(Result);
	}
	catch(e){
		return null;	
	}
}

function HwAjaxComplexPara(ObjPath, ParameterList)
{
	var Result = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/complex.cgi?' + ObjPath + "&RequestFile=nopage",
		data: ParameterList,
		success : function(data) {
			 Result  = '"' + data + '"';
		}
	});
	
	try{
		return eval(Result);
	}
	catch(e){
		return null;	
	}
}

function HWGetAction(Url, ParameterList, tokenvalue)
{
	var tokenstring = (null == tokenvalue) ? "" : ("x.X_HW_Token=" + tokenvalue);
	var ResultTmp = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : Url,
		data: ParameterList + tokenstring,
		success : function(data) {
			 var TmpResultTmp  = "\"" + data + "\"";
			 ResultTmp = eval(TmpResultTmp);
		}
	});

	try{
		var ReturnJson = $.parseJSON(ResultTmp);
	}catch(e){
		var ReturnJson = null;
	}

	return ReturnJson;
}

function HwAjaxGetUsbContentInfo(usbtolen)
{
	var usb1;
	var usb2;
	var ParameterList="DeviceList";
	var ObjPath = "x=InternetGatewayDevice.X_HW_UsbInterface.X_HW_UsbStorageDevice&RequestFile=/CustomApp/index.asp";
	if(null != usbtolen)
	{
		var tokenstr = "&x.X_HW_Token=" + usbtolen;
		ParameterList += tokenstr;
	}
	
	var TmpUsbList = HwAjaxGetPara(ObjPath, ParameterList);
	
	if(-1 == TmpUsbList.indexOf('|'))
	{
		return null;
	}
	
	var	UsbList = $.parseJSON(TmpUsbList);
	
	var DeviceStr = UsbList.DeviceList;
	if(DeviceStr != '')
	{
		DeviceArray = DeviceStr.split("|");
	}
	
	if(DeviceArray.length > 0)
	{
		return DeviceArray;
	}

	return null;
}

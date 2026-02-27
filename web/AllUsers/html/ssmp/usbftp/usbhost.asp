<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
<link type='text/css' rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>'>
<link type='text/css' rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet" href="../smblist/<%HW_WEB_CleanCache_Resource(thickbox.css);%>" type="text/css" media="screen" />
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script type="text/javascript" src="../smblist/<%HW_WEB_CleanCache_Resource(thickbox.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(errdes.html);%>"></script>
<style type='text/css'>
  span.language-string {
  padding: 0px 15px;
  display: block;
  height: 40px;
  line-height: 40px;
}
.row.hidden-pw-row {
  width: 132px;
  height: 30px;
  line-height: 30px;
}
 #SaveAsPath_text {
	 width: 120px;
 }
</style>
<script language="JavaScript" type="text/javascript">
var USBFileName;
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var USBROLIST = '<%HW_WEB_GetUSBDRWStatus();%>';

var IsGlobeFlag = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GLOBE);%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var typeWord='<%HW_WEB_GetTypeWordMode();%>';
var isSupportPCDN = '<%HW_WEB_GetFeatureSupport(FT_PCDN_SUPPORT);%>';
var enblHON = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_USBPlugin.Enable);%>';
function GetLanguageDesc(Name)
{
	return UsbHostLgeDes[Name];
}

function stUSBDevice(domain,DeviceList)
{
	this.domain = domain;
	this.DeviceList = DeviceList;
}

function stFtpSrvCfg(domain, enable, username, ftpport, rootdirpath, usrnum)
{
	this.domain = domain ;
	this.enable  = enable ;
	this.username = username ;
	this.passwd = '********************************';
	this.ftpport = ftpport;
	this.rootdirpath = rootdirpath;
	this.usrnum = usrnum;
}

function stUsbInfo(mntpath, devname)
{
	this.mntpath = mntpath;
	this.devname = devname;
}

var g_configftppath=UsbHostLgeDes['s052e'];
var IsItVdf = '<%HW_WEB_GetFeatureSupport(FT_ITVDF_SUPPORT);%>';
var IsPtVdf = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_PTVDF);%>";
var IsTelmex = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_TELMEX);%>';
var CuOSGIMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_CU_OSGI_MODE);%>';
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var UsbDevice = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UsbInterface.X_HW_UsbStorageDevice,DeviceList,stUSBDevice);%>;
var FtpSrvCfgs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_ServiceManage, FtpEnable|FtpUserName|FtpPort|FtpRoorDir|FtpUserNum, stFtpSrvCfg);%>;
var tedataGuide = "<%HW_WEB_GetFeatureSupport(HW_FT_FEATURE_TEDATAGUIDE);%>";
var frame = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_FRAME.STRING);%>';
var ftpsrvcfg = FtpSrvCfgs[0];
if (ftpsrvcfg == null) {
    ftpsrvcfg = new stFtpSrvCfg("", false, "", "", 0, "", 0);
}
var stUsbInfo = <%HW_WEB_GetUSBAllInfo();%>;
var PwdTipsFlag = '<%HW_WEB_GetFeatureSupport(FT_WEB_SHOW_PWD_TIPS);%>';
var usb1 = null;
var usb2 = null;

var DeviceStr = null;
var DeviceArray = null;

var SFTPClientInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ClientInfo.{i}, SftpEnable|SftpUserName|SftpPassword|SftpRoorDir|EncryptMode|Permission, stSFTPClientInfo);%>;
var CurrentSFTPClientIndex = 0;
var SFTPSrvInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ServerInfo, SftpEnable|SftpPort|SftpLANEnable|SftpWANEnable|SftpStatus|SftpMaxDuration|SftpEnableTime|SftpMaxIdleDur, stSFTPSrvCfg);%>;
var SFTPSrvInfo = SFTPSrvInfoList[0];
if ((tedataGuide == 1) && (SFTPSrvInfo == null)) {
    SFTPSrvInfo = new stSFTPSrvCfg("InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ServerInfo","0","22","0","0","1","86400","0","300");
}

if ( UsbDevice.length > 1 )
{
	usb1 = UsbDevice[0].DeviceList;
}

if (UsbDevice.length > 2)
{
	usb2 = UsbDevice[1].DeviceList;
}

DeviceStr = usb1 + usb2;

if(DeviceStr != '')
{
	DeviceArray = DeviceStr.split("|");
}

function MakeDeviceName(DiskName)
{
	var device = DiskName.split("/");
	return device[device.length - 1];
}

function GetDevNameByOldMntPath(mntpath)
{
	if (null == stUsbInfo)return "";
	
	for (var i = 0; i < stUsbInfo.length; i++)
	{
		if (null == stUsbInfo[i])continue;
		
		if (stUsbInfo[i].mntpath == mntpath)
			return stUsbInfo[i].devname;
	}
	
	return "";
}

function GetMntPathByDevName(devname)
{
	if (null == stUsbInfo)return "";
	
	for (var i = 0; i < stUsbInfo.length; i++)
	{
		if (null == stUsbInfo[i])continue;
		
		if (stUsbInfo[i].devname == devname)
			return stUsbInfo[i].mntpath;
	}
	
	return "";
}

function init()
{
	if (1 == IsPtVdf)
	{		
		setSelect('TransModeSelect', top.FTPType);
	}

	
	with(document.forms[0])
	{
		if (DeviceArray == '')
			btnDown.disabled = true;

		setCheck('FtpdEnable', ftpsrvcfg.enable);
		setText('SrvUsername', ftpsrvcfg.username);
		setText('SrvPort', ftpsrvcfg.ftpport);
		setText('Srvpassword', ftpsrvcfg.passwd);

		var tmp;
		var i;
		var newPath="";

		if("" != ftpsrvcfg.rootdirpath)
		{
			tmp = ftpsrvcfg.rootdirpath.split("/");
			for(i=0; i<tmp.length - 3; i++)
			{
				newPath += tmp[3+i];

				if(i != tmp.length - 4)
				{
					newPath += '/';
				}
			}

			if ( 'jffs2' == newPath )
			{
				newPath='';
			}
			
			if (1 == IsItVdf)
			{
				WriteDeviceOption(newPath);
				g_configftppath = newPath;
				setText('RootDirPath', newPath);
			}
			else if (1 == IsPtVdf)
			{
				setText('RootDirPath', GetDevNameByOldMntPath('/mnt/usb/'+newPath));
				setSelect('SrvClDevType', GetDevNameByOldMntPath('/mnt/usb/'+tmp[3])+'/');
			}
			else
			{
				setText('RootDirPath', newPath);
				setSelect('SrvClDevType', '/mnt/usb/'+tmp[3]+'/');
			}
		}
		else
		{
			setText('RootDirPath',    '');
			setSelect('SrvClDevType', '');
		}

		SetFtpEnable();
	}
	$("#checkinfo1Row").css("display", "none");
}

function isSafeCharSN(val)
{
	if ( ( val == '<' )
	  || ( val == '>' )
	  || ( val == '\'' )
	  || ( val == '\"' )
	  || ( val == '#' )
	  || ( val == '{' )
	  || ( val == '}' )
	  || ( val == '\\' )
	  || ( val == '|' )
	  || ( val == '^' )
	  || ( val == '[' )
	  || ( val == ']' ) )
	{
		return false;
	}

	return true;
}

function isSafeStringSN(val)
{
	if ( val == "" )
	{
		return false;
	}

	for ( var j = 0 ; j < val.length ; j++ )
	{
		if ( !isSafeCharSN(val.charAt(j)) )
		{
			return false;
		}
	}

	return true;
}

function UsbFtpchooseValue(obj)
{
	var text = obj.innerHTML;
	var ShowId = "IframeUSBHost" + "show";
	$('#'+ShowId).html(text);
	g_configftppath = obj.id;
	setText('RootDirPath', g_configftppath);
	SetClickFlag(false);
	$('#'+ShowId).css("background-image","url('../../../images/arrow-down.png')");
}

function WriteDeviceOption(id)
{
	if(1 == IsItVdf){
	
		if (DeviceStr != 'null'){
		
			var arr = [];
			
			var DefaultValue = (null != id || "" != id)?id:UsbHostLgeDes['s052e'];
			
			for (var i in DeviceArray)
			{
				if ((DeviceArray[i] == 'null')
					|| (DeviceArray[i] == 'undefined'))
					continue;
				arr.push(MakeDeviceName(DeviceArray[i]));
			}
			
		}else{
			var arr = [UsbHostLgeDes['s052e']];
			var DefaultValue = UsbHostLgeDes['s052e'];
		}
		
		createDropdown("IframeUSBHost",DefaultValue,"225px", arr, "UsbFtpchooseValue(this);");
			
	}else{
	
		var select = document.getElementById(id);
	
		if (DeviceStr != 'null')
		{
			for (var i in DeviceArray)
			{
				if ((DeviceArray[i] == 'null')
					|| (DeviceArray[i] == 'undefined'))
					continue;
				var opt = document.createElement('option');
				var html;
				
				if (1 == IsPtVdf)
				{
					var devname = GetDevNameByOldMntPath(DeviceArray[i]);
					html = document.createTextNode(devname);
				}
				else
				{
					html = document.createTextNode(MakeDeviceName(DeviceArray[i]));
				}
				opt.value = DeviceArray[i] + '/';
				opt.appendChild(html);
				select.appendChild(opt);
			}
			return true;
		}
		else
		{
			var opt = document.createElement('option');
			var html = document.createTextNode(UsbHostLgeDes['s052e']);
			opt.value = '';
			opt.appendChild(html);
			select.appendChild(opt);
			return false;
		}
	}
}

function CheckPwdIsComplex(str, strName)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}

	if (!CompareString(str,strName) )
	{
		return false;
	}

	if ( isLowercaseInString(str) )
	{
		i++;
	}

	if ( isUppercaseInString(str) )
	{
		i++;
	}

	if ( isDigitInString(str) )
	{
		i++;
	}

	if ( isSpecialCharacterInString(str) )
	{
		i++;
	}

	if ( i >= 2 )
	{
		return true;
	}
	return false;
}

function title_show(input)
{
	var div=document.getElementById("title_show");

	if ("ARABIC" == LoginRequestLanguage.toUpperCase())
	{
		div.style.right = (input.offsetLeft + 50) + "px";
	}
	else if (curWebFrame == 'frame_UNICOM'||curWebFrame == 'frame_LNUNICOM')
	{
		div.style.left = (input.offsetLeft + 300) + "px";
		div.style.width = "auto";
		div.style.overflow= "auto";
	}
	else
	{
		div.style.left = (input.offsetLeft + 370) + "px";
	}

	div.innerHTML = UsbHostLgeDes['ss1116b'];
	if (CuOSGIMode == 1)
	{
		div.style.color = "#000000";
		div.style.width = "270px";
	}
	div.style.display = '';
	if ( 'ZAIN' == CfgMode.toUpperCase())
	{
		div.style.color = '#000000';
	}
	if (CfgModeWord.toUpperCase() == "ROSUNION") {
	    div.style.background = 'rgb(39, 58, 100)';
	    div.style.color = '#fff';
	    div.style.border = 'none';
	    div.style.padding = '5px';
	}
}

function title_back(input)
{
	var div=document.getElementById("title_show");
	div.style.display = "none";
}

function GetUSBRoInfoText()
{
	if(((USBROLIST.indexOf("USB") > -1) || (USBROLIST.indexOf("usb") > -1))
	   && (USBROLIST.indexOf("SD_card") > -1) )
	{
		return UsbHostLgeDes["s0542"];
	}
	else if(USBROLIST.indexOf("SD_card") > -1)
	{
		return UsbHostLgeDes["s0541"];
	}
	else
	{
		return UsbHostLgeDes["s0540"];
	}
}

function GetLanguageDesc(Name)
{
	return UsbHostLgeDes[Name];
}

function psdStrength()
{
	if (top.FTPType == "SFTP")
	{
		return;
	}
	
	var score = 0;
	var password1 = getElementById("Srvpassword").value;
	if(password1.length > 8) score++;

	if(password1.match(/[a-z]/) && password1.match(/[A-Z]/)) score++;

	if(password1.match(/\d/)) score++;

	if ( password1.match(/.[!,@,#,$,%,^,&,*,?,_,~,-,(,)]/) ) score++;

	if (password1.length > 12) score++;


	if(0 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0558');
		getElementById("pwdvalue1").style.width=16.6+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #FF0000";
	}

	if(1 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0558');
		getElementById("pwdvalue1").style.width=33.2+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #FF0000";
	}
	if(2 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0559');
		getElementById("pwdvalue1").style.width=49.8+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #FFA500";
	}
	if(3 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0559');
		getElementById("pwdvalue1").style.width=66.4+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #FFA500";
	}
	if(4 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0560');
		getElementById("pwdvalue1").style.width=83+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #008000";
	}
	if(5 == score)
	{
		getElementById("pwdvalue1").innerHTML=GetLanguageDesc('s0560');
		getElementById("pwdvalue1").style.width=100+"%";
		getElementById("pwdvalue1").style.borderBottom="4px solid #008000";
	}
}

function checkFtpURL()
{
	var ServerPos;
	var URLValue = document.getElementById('URL').value;

	if (URLValue == '' || URLValue.substr(0, 6) != "ftp://" || URLValue.length <= 6)
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}

	if (!isSafeStringSN(URLValue))
	{
		AlertEx(UsbHostLgeDes["s0534"]);
		document.getElementById('URL').focus();
		return false;
	}

	if(URLValue.charAt(URLValue.length - 1) == '/')
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}

	ServerPos=URLValue.substr(6, URLValue.length);
	if(ServerPos.indexOf('/') <= 0)
	{
		AlertEx(UsbHostLgeDes["s050a"]);
		return false;
	}
	else
	{
		USBFileName = ServerPos.substr(ServerPos.indexOf('/') + 1,ServerPos.length);
		if (USBFileName == '')
		{
			AlertEx(UsbHostLgeDes["s050a"]);
			return false;
		}
		return true;
	}
}

function CheckUSBFileIsExist()
{
	var USBFileLocalPath = document.getElementById('SaveAsPath_text').value;
	var CheckResult = 0;
	var USBFileInfo = "";
	if (1 == IsPtVdf)
	{
		var arr = USBFileLocalPath.split("/");
		var newFileLocalPath = "";
		if (null != arr && arr.length > 2)
		{
			newFileLocalPath = GetMntPathByDevName(arr[1]);
			for (var i = 2; i < arr.length; ++i)
			{
				newFileLocalPath += '/' + arr[i];
			}
			USBFileInfo = newFileLocalPath +'/' + USBFileName;
		}
	}
	else
	{
		USBFileInfo = '/mnt/usb' + USBFileLocalPath +'/' + USBFileName;
	}

	$.ajax(
	{
		type : "POST",
		async : false,
		cache : false,
		url : "../common/CheckUSBFileExist.asp?&1=1",
		data :'USBFileInfo=' + encodeURIComponent(USBFileInfo),
		success : function(data) {
			CheckResult = data;
		}
	});

	if (CheckResult == 1)
	{
		if (!ConfirmEx(UsbHostLgeDes["s0533"]))
		{
			return false;
		}
	}

	return true;
}

function checkFtpClient()
{
	with( document.forms["ConfigForm"] )
	{
		if ( (Port.value !='') &&(isNaN(parseInt(Port.value )) == true))
		{
			AlertEx(GetLanguageDesc("s0501"));
			return false;
		}
		var info = parseFloat(Port.value );
		if (info < 1 || info > 65535)
		{
			AlertEx(GetLanguageDesc("s0502"));
			return false;
		}

		if (Username.value.length > 255)
		{
			AlertEx(GetLanguageDesc("s0503"));
			return false;
		}
		if (isValidString(Username.value) == false )
		{
			msg = GetLanguageDesc("s0504");
			AlertEx(msg);
			return false;
		}

		for (var iTemp = 0; iTemp < Username.value.length; iTemp ++)
		{
			if (Username.value.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0505"));
				return false;
			}
		}

		if (Userpassword.value.length > 255)
		{
			AlertEx(GetLanguageDesc("s0506"));
			return false;
		}
		if ( isValidString(Userpassword.value) == false )
		{
			msg = GetLanguageDesc("s0507");
			AlertEx(msg);
			return false;
		}

		var tmp = SaveAsPath_text.value;
		if (tmp.length > 255)
		{
			AlertEx(GetLanguageDesc("s0508"));
			return false;
		}
		if ("" == tmp)
		{
			msg = GetLanguageDesc("s0509");
			AlertEx(msg);
			return false;
		}

		if(checkFtpURL()==false)
		{
			return;
		}

		if ( getSelectVal('ClDevType') == "" )
		{
			AlertEx(GetLanguageDesc("s050c"));
			return false;
		}
	}

	if(!CheckUSBFileIsExist())
	{
		return false;
	}
	return true;

}

function CheckForm()
{
	return checkFtpClient();
}

function AddSubmitParam(Form,type)
{
	setDisable('ClDevType', 1);
	setDisable('SaveAsPath_text', 1);
	setDisable('btnDown',   1);

	var tmp = getValue('URL');
	var URLPath = tmp.toString().replace(/%20/g, " ");

	Form.usingPrefix('x');

	Form.addParameter('Username',     getValue('Username'));
	Form.addParameter('Userpassword', getValue('Userpassword'));
	Form.addParameter('URL',          URLPath);
	var NullCheckValue = getValue('Port');
	if(NullCheckValue != '')
	{
		Form.addParameter('Port', getValue('Port'));
	}
	
    if ((NullCheckValue == '') &&
        ((CfgMode.toUpperCase() == "TELMEXVULA") ||
         (CfgMode.toUpperCase() == "TELMEXACCESS") ||
         (CfgMode.toUpperCase() == "TELMEXRESALE"))) {
        Form.addParameter('Port', 21);
    }
	var savepath = getValue('SaveAsPath_text');

	var Devicepath = "";
	if (undefined != savepath.split("/")[2])
	{
		if (1 == IsPtVdf)
		{
			Devicepath = GetMntPathByDevName(savepath.split("/")[1]) + '/';
		}
		else
		{
			Devicepath = '/mnt/usb/' +savepath.split("/")[1] +'/';
		}
	}
	else
	{
		if (1 == IsPtVdf)
		{
			Devicepath = GetMntPathByDevName(savepath.split("/")[1]);
		}
		else
		{
			Devicepath = '/mnt/usb/' +savepath.split("/")[1];
		}
	}

	var LocalPath = savepath.substr(savepath.split("/")[1].length + 2,savepath.length);
	LocalPath = LocalPath +"/"+ USBFileName;
	
	Form.addParameter('Device',  Devicepath);
	Form.addParameter('LocalPath', LocalPath);
	Form.addParameter('X_HW_Token',   getValue('onttoken'));
	Form.endPrefix();
	Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.FtpClient&'
				 + 'RequestFile=html/ssmp/usbftp/usbhost.asp');
}

function checkPort(portVal)
{
	if ((portVal == '') || (isPlusInteger(portVal) == false))
	{
		AlertEx(GetLanguageDesc("s0501"));
		return false;
	}		

	var portInfo = parseInt(portVal, 10);
	if (portInfo < 1 || portInfo > 65535)
	{
		AlertEx(GetLanguageDesc("s0502"));
		return false;
	}
	
	return true;
}

function checkFtpSrv()
{
	with (document.forms[0])
	{
		if( 0 == getCheckVal('FtpdEnable') || '0' == getCheckVal('FtpdEnable') )
		{
			return true;
		}

		if (getValue("SrvUsername").length > 256)
		{
			AlertEx(GetLanguageDesc("s050d"));
			return false;
		}

		if (getValue("SrvUsername").length == 0)
		{
			AlertEx(GetLanguageDesc("s050e"));
			return false;
		}

		if (getValue("SrvUsername") == 'anonymous' || getValue("SrvUsername") == 'Anonymous')
		{
			AlertEx(GetLanguageDesc("s050f"));
			return false;
		}

		if (isValidString(getValue("SrvUsername")) == false )
		{
			msg = GetLanguageDesc("s050f");
			AlertEx(msg);
			return false;
		}

		var srvUName = getValue("SrvUsername");
		for (var iTemp = 0; iTemp < srvUName.length; iTemp ++)
		{
			if (srvUName.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0505"));
				return false;
			}
		}

		if (getValue("Srvpassword").length > 256)
		{
			AlertEx(GetLanguageDesc("s0511"));
			return false;
		}

		if (getValue("Srvpassword").length == 0)
		{
			AlertEx(GetLanguageDesc("s0512"));
			return false;
		}

		if(getValue("Srvpassword").charAt(0) == ' ')
		{
			AlertEx(GetLanguageDesc("s052c"));
			return false;
		}

		if(getValue("Srvpassword").charAt(getValue("Srvpassword").length - 1) == ' ')
		{
			AlertEx(GetLanguageDesc("s052d"));
			return false;
		}

		if ( isValidString(getValue("Srvpassword")) == false )
		{
			msg = GetLanguageDesc("s0513");
			AlertEx(msg);
			return false;
		}

		var tmpSrvPasswd = getValue("Srvpassword");
		for (var iTemp = 0; iTemp < tmpSrvPasswd.length; iTemp ++)
		{
			if (tmpSrvPasswd.charAt(iTemp) == ' ')
			{
				AlertEx(GetLanguageDesc("s0513"));
				return false;
			}
		}
		
		var portVal = getValue("SrvPort");
		if (false == checkPort(portVal))
		{
			return false;
		}

		if ( getSelectVal('SrvClDevType') == "" )
		{
			AlertEx(GetLanguageDesc("s0514"));
			return false;
		}

		var tmp = getValue("RootDirPath");
		if (tmp.length > 256)
		{
			AlertEx(GetLanguageDesc("s0515"));
			return false;
		}

		if (isValidString(getValue("RootDirPath")) == false )
		{
			msg = GetLanguageDesc("s0516");
			AlertEx(msg);
			return false;
		}

	}

	var pwd_value = getValue("Srvpassword");
	if (ftpsrvcfg.passwd != pwd_value)
	{
		if (!CheckPwdIsComplex(pwd_value, srvUName))
		{
			if (tedataGuide == 1) {
				AlertEx(UsbHostLgeDes['s0651sftp']);
 				return false;
			}

			if (!ConfirmEx(UsbHostLgeDes['s1439'])) {
				return false;
			}
		}
	}

	if (ConfirmEx(GetLanguageDesc("s0517")))
	{
		return true;
	}
	else
	{
		return false;
	}

	return true;

}

function ShowResult(Result)
{
	var i = 0;
	var errorCodeArray = new Array('0xf734b001', '0xf734b002', '0xf734b003', '0xf734b004', '0xf734b005');
	var errorstring = new Array('s0543', 's0544', 's0545', 's0546', 's0547');
	var StrCode = "\"" + Result + "\"";
	try{
	
		var ResultInfo = eval("("+ eval(StrCode) + ")");
		if (0 == ResultInfo.result)
		{
			return;
		}
		
		for (i = 0; i < errorCodeArray.length; i++)
		{
			if (errorCodeArray[i] == ResultInfo.error)
			{
				AlertEx(GetLanguageDesc(errorstring[i]));
				return;
			}
		}

		var errData = errLanguage['s' + ResultInfo.error];
		if ('string' != typeof(errData))
		{
			errData = errLanguage['s0xf7205001'];
		}

		AlertEx(errData);
	}catch(e){
	
		errData = errLanguage['s0xf7205001'];
		AlertEx(errData);
	}
}

function SetSftpEnable()
{
	if("1" != getCheckVal("SFTPEnable")){
		return;
	}
	
	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : "x.SftpEnable=0" + "&x.X_HW_Token=" + getValue('onttoken'),
		 url : "setajax.cgi?x=InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ServerInfo&RequestFile=html/ssmp/usbftp/usbhost.asp",
		 success : function(data) {
		 }
	});
}

function SrvSubmit()
{
	var Ret;

	Ret = checkFtpSrv();
	if (false == Ret)
	{
		return;
	}

	setDisable('SrvClDevType', 1);
	setDisable('RootDirPath', 1);
	setDisable('btnDownSrvApply',  1);
	setDisable('btnDownSrcCancle', 1);

	var ftpInfoData="x.FtpEnable=" + getCheckVal('FtpdEnable');

	if (1 == getCheckVal('FtpdEnable') || '1' == getCheckVal('FtpdEnable'))
	{
		ftpInfoData += "&x.FtpUserName=" + encodeURIComponent(getValue('SrvUsername'));

		if (ftpsrvcfg.passwd != getValue('Srvpassword'))
		{
			ftpInfoData += "&x.FtpPassword=" + encodeURIComponent(getValue('Srvpassword'));
		}
	
		ftpInfoData += "&x.FtpPort=" + getValue('SrvPort');
		
		if (1 == IsItVdf)
		{
			ftpInfoData += "&x.FtpRoorDir=/mnt/usb/" + encodeURIComponent(g_configftppath);
		}
		else if (1 == IsPtVdf)
		{
			var tmpDirPath = "";
			var tmpDirPathArr = getValue('RootDirPath').split("/");
			if (null != tmpDirPathArr)
			{
				tmpDirPath = tmpDirPathArr[0];
			}
			ftpInfoData += "&x.FtpRoorDir=" + encodeURIComponent(GetMntPathByDevName(tmpDirPath));
		}
		else
		{
			ftpInfoData += "&x.FtpRoorDir=/mnt/usb/" + encodeURIComponent(getValue('RootDirPath'));
		}
		
	}

	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : ftpInfoData + "&x.X_HW_Token=" + getValue('onttoken'),
		 url : "setajax.cgi?x=InternetGatewayDevice.X_HW_ServiceManage&RequestFile=html/ssmp/usbftp/usbhost.asp",
		 success : function(data) {
						
			ShowResult(data);
			window.location.href = "/html/ssmp/usbftp/usbhost.asp";
		 }
	});
}

function SetFtpEnable()
{
	var enable = getCheckVal('FtpdEnable');
	
	if(1 == enable || '1' == enable)
	{
		if ((ftpsrvcfg.enable == false) && (tedataGuide == 1) && (DeviceStr == 'null')) {
			AlertEx(GetLanguageDesc("s0562"));
			setCheck('FtpdEnable', 0);
			return;
		}
		setDisable("SrvUsername",  0);
		setDisable("Srvpassword",  0);
		setDisable("SrvPort",  0);
		
		setDisable("RootDirPath",  0);
			
		if(1 == IsItVdf){
			setDisable("SrvClDevTypeCol",0);
			$("#IframeUSBHostshow").css("color","#5D5D5D");
			$("#IframeDropdownCorver").css("display","none");
		}else{
			setDisable("SrvClDevType", 0);
		}
		if(1==IsPtVdf)
		{
		setDisplay("ftpwarningRow",1);
		}
	}
	else
	{
		setDisable("SrvUsername",  1);
		setDisable("Srvpassword",  1);
		setDisable("SrvPort",  1);
		setDisable("RootDirPath",  1);
		
		if(1 == IsItVdf){
			setDisable("SrvClDevTypeCol",1);
			$("#IframeUSBHostshow").css("color","#C5C5C5");
			$("#IframeDropdownCorver").css("display","block");
		}else{
			setDisable("SrvClDevType", 1);
		}
		setDisplay("ftpwarningRow",0);
	}
}

function onChangeDev()
{
	var dev = getSelectVal('SrvClDevType');
	var tmp;

	if (DeviceArray.length-1 > 1)
	{
		return;
	}

	if ( "" != dev)
	{
		tmp = dev.split("/");
		if (1 == IsPtVdf)
		{
			setText('RootDirPath', GetDevNameByOldMntPath('/mnt/usb/'+tmp[3])+'/');
		}
		else
		{			
			setText('RootDirPath', tmp[3]+'/');
		}		
	}
	else
	{
		setText('RootDirPath', '');
	}
}


function onSelectDev()
{
	var dev = getSelectVal('SrvClDevType');
	var tmp;

	if( "" != dev)
	{
		tmp = dev.split("/");
		if (1 == IsPtVdf)
		{
			setText('RootDirPath', GetDevNameByOldMntPath('/mnt/usb/'+tmp[3])+'/');
		}
		else
		{			
			setText('RootDirPath', tmp[3]+'/');
		}
	}
	else
	{
		setText('RootDirPath', '');
	}
}

function stDownloadInfo(Domain,Username,URL,Port,LocalPath,Status,Device)
{
	this.Domain = null;
	this.Username = null;
	this.URL = null;
	this.Port = null;
	this.LocalPath = null;
	this.Status = null;
	this.Device = null;
}

function stRecordList(domain, Username, URL, Port, LocalPath, Status, Device)
{
	this.domain = domain;
	this.Username = Username;
	this.URL = URL;
	this.Port = Port;
	this.LocalPath = LocalPath;
	this.Status = Status;
	this.Device = Device;
}

var RecordString = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.SMP.DM.FtpClient.{i},Username|URL|Port|LocalPath|Status|Device,stRecordList);%>;

var DownloadInfo = new Array();

CreateUsbRecord();

function CreateUsbRecord()
{
	for(i = 0; i < RecordString.length - 1; i++)
	{
		DownloadInfo[i] = new stDownloadInfo();
		var posLast = RecordString[i].Device.lastIndexOf('/');
		var tmpDevice = "";
		if(RecordString[i].LocalPath.replace(/(^\s*)|(\s*$)/g, "")=='')
		{
			var pos = RecordString[i].URL.lastIndexOf('/');
			if (1 == IsPtVdf)
			{
				tmpDevice = (posLast + 1 == RecordString[i].Device.length) ? RecordString[i].Device.substr(0, RecordString[i].Device.length-1) : RecordString[i].Device;
				RecordString[i].LocalPath = GetDevNameByOldMntPath(tmpDevice) + "/" + RecordString[i].URL.substr(pos + 1, RecordString[i].URL.length - pos -1);
			}
			else
			{
				RecordString[i].LocalPath = RecordString[i].Device + RecordString[i].URL.substr(pos + 1, RecordString[i].URL.length - pos -1);
			}			
		}
		else
		{
			if (1 == IsPtVdf)
			{
				tmpDevice = (posLast + 1 == RecordString[i].Device.length) ? RecordString[i].Device.substr(0, RecordString[i].Device.length-1) : RecordString[i].Device;
				var newDevice = GetDevNameByOldMntPath(tmpDevice);
				if ("" == newDevice)
				{
					RecordString[i].LocalPath = RecordString[i].Device + RecordString[i].LocalPath;
				}
				else
				{
					if (tmpDevice == RecordString[i].Device)
					{
						RecordString[i].LocalPath = "/" + newDevice + RecordString[i].LocalPath;
					}
					else
					{
						RecordString[i].LocalPath = "/" + newDevice + "/" + RecordString[i].LocalPath;
					}
				}
			}
			else
			{
				RecordString[i].LocalPath = RecordString[i].Device + RecordString[i].LocalPath;
			}
		}
		DownloadInfo[i] = RecordString[i];
	}
}

function Cancleconfig()
{
	init();
}

var TableClass = new stTableClass("width_per25", "width_per75");

function stSFTPClientInfo(Domain, SftpEnable, SftpUserName, SftpPassword, SftpRoorDir, EncryptMode, Permission)
{
	this.Domain = Domain;
	this.SftpUserName = SftpUserName;
	this.SftpPassword = SftpPassword;
	this.SftpRoorDir = SftpRoorDir;
	this.EncryptMode = EncryptMode;
	this.Permission = Permission;
	this.EnableAccount = SftpEnable;
}

function stSFTPClientShowInfo(Domain, SftpEnable, SftpUserName, SftpRoorDir, Permission)
{
	this.Domain = Domain;
	this.SftpUserName = SftpUserName;
	this.SftpRoorDir = SftpRoorDir;
	this.Permission = Permission;
	this.EnableAccount = SftpEnable;
}

function stSFTPSrvCfg(Domain, SftpEnable, SftpPort, SftpLANEnable, SftpWANEnable, SftpStatus, SftpMaxDuration, SftpEnableTime, SftpMaxIdleDur)
{
	this.Domain = Domain;
	this.SftpEnable = SftpEnable;
	this.SftpPort = SftpPort;
	this.SftpLANEnable = SftpLANEnable;
	this.SftpWANEnable = SftpWANEnable;
	this.SftpStatus = SftpStatus;
	this.SftpMaxDuration = SftpMaxDuration;
	this.SftpEnableTime = SftpEnableTime;
	this.SftpMaxIdleDur = SftpMaxIdleDur;
}

function ShowListControlInfo()
{
	var ColumnNum = 4;
    var ShowListLength = SFTPClientInfoList.length - 1;
	var Listlen = 0;
	var TableDataInfo = new Array();
	
	for (var i = 0; i < ShowListLength; i++)
	{
		TableDataInfo[Listlen] = new stSFTPClientShowInfo();
		TableDataInfo[Listlen].SftpUserName = SFTPClientInfoList[i].SftpUserName;
		
		if (1 == IsPtVdf)
		{
			var substr = SFTPClientInfoList[i].SftpRoorDir.substr(8, SFTPClientInfoList[i].SftpRoorDir.length - 1);
			var arr = substr.split('/');
			arr[1] = GetDevNameByOldMntPath('/mnt/usb/'+arr[1]);
			var rootdir = '';
			for(var j = 1; j < arr.length; ++j)
			{
				rootdir += '/'+arr[j];
			}
			TableDataInfo[Listlen].SftpRoorDir = rootdir;
		}
		else
		{
			TableDataInfo[Listlen].SftpRoorDir = SFTPClientInfoList[i].SftpRoorDir.substr(8, SFTPClientInfoList[i].SftpRoorDir.length - 1);
		}
		
		if (SFTPClientInfoList[i].Permission == 1)
		{
			TableDataInfo[Listlen].Permission = UsbHostLgeDes['s0656sftp'];
		}
		else
		{
			TableDataInfo[Listlen].Permission = UsbHostLgeDes['s0657sftp'];
		}
		
		if (SFTPClientInfoList[i].EnableAccount == 1)
		{
			TableDataInfo[Listlen].EnableAccount = UsbHostLgeDes['s0654sftp'];
		}
		else
		{
			TableDataInfo[Listlen].EnableAccount = UsbHostLgeDes['s0655sftp'];
		}
		
		Listlen++;
	}
	
	if (0 == ShowListLength)
    {
        TableDataInfo[Listlen] = new stSFTPClientShowInfo();
		TableDataInfo[Listlen].SftpUserName = "--";
		TableDataInfo[Listlen].SftpRoorDir = "--";
		TableDataInfo[Listlen].Permission = "--";
		TableDataInfo[Listlen].EnableAccount = "--";
    }
    else
    {
        TableDataInfo.push(null);
    }
	
	HWShowTableListByType(1, "UsbSFTPConfigList", true, ColumnNum, TableDataInfo, UsbConfiglistInfo, UsbHostLgeDes, null);
}

function SFTPEditClientSubmit()
{
	if(0 == IsPtVdf)
	{
		return;
	}
	var sftpClientUserName = getValue("SFTPUsername");
	var sftpClientNewPwd = getValue("SFTPNewPassword");
	var sftpClientConfirmPwd = getValue("SFTPCfmPassword");
	
	var Form = new webSubmitForm();
		
	if (sftpClientNewPwd != sftpClientConfirmPwd)
	{
		AlertEx(UsbHostLgeDes['s0650sftp']);
		return;
	}
	
	if (false == CheckPwdIsComplex(sftpClientNewPwd, sftpClientUserName))
	{
		AlertEx(UsbHostLgeDes['s0651sftp']);
		return;
	}
	
	Form.addParameter('x.SftpPassword',FormatUrlEncode(sftpClientNewPwd));
	Form.addParameter('x.EncryptMode',0);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	Form.setAction('set.cgi?' +'x='+ SFTPClientInfoList[CurrentSFTPClientIndex].Domain + '&RequestFile=html/ssmp/usbftp/usbhost.asp');
	Form.submit();
}

function SFTPEditClientCancle()
{
	setDisplay("SFTPConfigForm", 1);
	setDisplay("SFTPEditPwd", 0);
}

function OnChangeTransmissionMode()
{
	ControlTransMode()
	
	return;
}

function OnChangeDirMode()
{
	ControlDirMode();
}

function OnChangeChooseDir()
{
	tb_show("Browse Directory", "../smblist/smb_choosedir_list.asp?&amp;Choose=1&amp;TB_iframe=true", "false");
	setDisplay("TB_window", 1);
	return;
}

function OnChangeEditSFTPClientCfg()
{
	setDisplay("SFTPConfigForm", 0);
	setDisplay("SFTPEditPwd", 1);
	getElementById("SFTPEditUserName").innerHTML = getValue("SFTPUsername");
	return;
}

function OnChangeSFTPPort()
{
	ControlSFTPPort();
}

function isValidInASCII(val)
{
	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch <= ' ' || ch > '~' )
		{
			return false;
		}
	}
	return true;
}

function ClientSubmit()
{
	if(0 == IsPtVdf)
	{
		return;
	}
	var sftpClientEnable = getCheckVal("EnableAccount");
	var sftpClientUserName = getValue("SFTPUsername");
	var sftpClientPwd = getValue("SFTPUserpassword");
	var sftpClientConfirmPwd = getValue("SFTPConfirmpassword");
	var sftpClientDirEnable = getRadioVal("Dirmode");
	var sftpClientUSBDir = "";
	var sftpClientPrivilegeValue = getRadioVal("Privilege");
	var sftpClientPrivilege = 0;
	
	var Form = new webSubmitForm();
	
	if (sftpClientPwd != sftpClientConfirmPwd)
	{
		AlertEx(UsbHostLgeDes['s0650sftp']);
		return;
	}
	
	if (false == CheckPwdIsComplex(sftpClientPwd, sftpClientUserName))
	{
		AlertEx(UsbHostLgeDes['s0651sftp']);
		return;
	}
	
	if (sftpClientDirEnable == 1)
	{
		if(1 == IsPtVdf)
		{
			var tmp = getValue("ChoosDir");
			var arr = tmp.split("/");
			if(null != arr && arr.length >= 2)
			{
				sftpClientUSBDir = GetMntPathByDevName(arr[1]);
				for(var i = 2; i < arr.length; ++i)
				{
					sftpClientUSBDir += '/' + arr[i];
				}
			}			
		}
		else
		{
			sftpClientUSBDir = "/mnt/usb" + getValue("ChoosDir");
		}
	}
	else
	{
		sftpClientUSBDir = "/mnt/usb/";
	}

	if (true != isValidInASCII(sftpClientUSBDir))
	{
		AlertEx(UsbHostLgeDes['s0658sftp']);
		return;		
	}
	
	if (sftpClientPrivilegeValue == 0)
	{
		sftpClientPrivilege = 1;
	}
	else
	{
		sftpClientPrivilege = 0;
	}
	
	Form.addParameter('x.SftpEnable',sftpClientEnable);
	Form.addParameter('x.SftpUserName',sftpClientUserName);
	Form.addParameter('x.SftpPassword',FormatUrlEncode(sftpClientPwd));
	Form.addParameter('x.SftpRoorDir', sftpClientUSBDir);
	Form.addParameter('x.EncryptMode',0);
	Form.addParameter('x.Permission',sftpClientPrivilege);
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ClientInfo&RequestFile=html/ssmp/usbftp/usbhost.asp');
	Form.submit();
	return;
}

function ClientCancle()
{
	var tableRow = getElement("UsbSFTPConfigList");
	setDisplay("SFTPConfigForm", 0);
	
	if (tableRow.rows.length != 1 && tableRow.rows.length != 2)
	{
		tableRow.deleteRow(tableRow.rows.length - 1);
        selectLine("UsbSFTPConfigList_record_0");
	}
	
	return;
}

function OnChangeSFTPEnable()
{
	ControlSFTPServiceEnable();
	return;
}

function OnChangeMaximumIdleTime()
{
	ControlMaximumIdleTime();
}


function SFTPShowResult(Result)
{
	var errorCodeArray = new Array('0xf720b001','0xf734b001', '0xf734b002', '0xf734b003', '0xf734b004', '0xf734b005');
	var errorstring = new Array('s0638sftp', 's0543', 's0544', 's0545', 's0546', 's0547');
	var StrCode = "\"" + Result + "\"";
	var ResultInfo = eval("("+ eval(StrCode) + ")");
	try{
	
		var ResultInfo = eval("("+ eval(StrCode) + ")");
		if (0 == ResultInfo.result)
		{
			return;
		}
		
		for (i = 0; i < errorCodeArray.length; i++)
		{
			if (errorCodeArray[i] == ResultInfo.error)
			{
				AlertEx(GetLanguageDesc(errorstring[i]));
				return;
			}
		}

		var errData = errLanguage['s' + ResultInfo.error];
		if ('string' != typeof(errData))
		{
			errData = errLanguage['s0xf7205001'];
		}

		AlertEx(errData);
	}catch(e){
	
		errData = errLanguage['s0xf7205001'];
		AlertEx(errData);
	}
	return;
}


function SetDisableFtpEnable()
{
	if("1" != getCheckVal("FtpdEnable")){
		return;
	}
	
	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : "x.FtpEnable=0" + "&x.X_HW_Token=" + getValue('onttoken'),
		 url : "setajax.cgi?x=InternetGatewayDevice.X_HW_ServiceManage&RequestFile=html/ssmp/usbftp/usbhost.asp",
		 success : function(data) {
		 }
	});
}

function SFTPSrvSubmit()
{
	if(0 == IsPtVdf)
	{
		return;
	}
	var TempTimeInfo = getValue("MaximumIdleTimeInfo");
	if (TempTimeInfo < 60 || TempTimeInfo > 300)
	{
		AlertEx(UsbHostLgeDes["s0653sftp"]);
		return;
	}
	
	SFTPSrvInfo.SftpEnable = getCheckVal("SFTPEnable");
	SFTPSrvInfo.SftpLANEnable = getCheckVal("LANWANEnable1");
	SFTPSrvInfo.SftpWANEnable = getCheckVal("LANWANEnable2");
	if (getCheckVal("SFTPPort") == 0)
	{
		SFTPSrvInfo.SftpPort = 22;
	}
	else
	{
		SFTPSrvInfo.SftpPort = getValue("SFTPPortInfo");
	}
	
	if (false == checkPort(SFTPSrvInfo.SftpPort))
	{
		return false;
	}
	
	if (getCheckVal("MaximumIdleTime") == 0)
	{
		SFTPSrvInfo.SftpMaxIdleDur = 300;
	}
	else
	{
		SFTPSrvInfo.SftpMaxIdleDur = TempTimeInfo;
	}
	
	var sftpInfoData="x.SftpEnable=" + SFTPSrvInfo.SftpEnable;
	sftpInfoData += "&x.SftpPort=" + SFTPSrvInfo.SftpPort;
	sftpInfoData += "&x.SftpLANEnable=" + SFTPSrvInfo.SftpLANEnable;
    if (tedataGuide != 1) {
        sftpInfoData += "&x.SftpWANEnable=" + SFTPSrvInfo.SftpWANEnable;
    }
	sftpInfoData += "&x.SftpMaxIdleDur=" + SFTPSrvInfo.SftpMaxIdleDur;

	$.ajax({
		 type : "POST",
		 async : false,
		 cache : false,
		 data : sftpInfoData + "&x.X_HW_Token=" + getValue('hwonttoken'),
		 url : "setajax.cgi?x=InternetGatewayDevice.X_HW_SFTP.X_HW_SFTP_ServerInfo&RequestFile=html/ssmp/usbftp/usbhost.asp",
		 success : function(data) {
			if(1 == IsPtVdf)
			{
				SetDisableFtpEnable();
			}
			SFTPShowResult(data);
			window.location.href = "/html/ssmp/usbftp/usbhost.asp";
		 }
	});
	
	return;
}

function SFTPSrvCancle()
{
	InitCfgInfo();
	InitControl();
	return;
}

function AddSFTPClientEditHtml(UserName)
{
    var html = '<tr border="1" id="SftpConfigEditButtonRow" style="">' +
               '    <td id="UserNameIndex" class="table_title width_per25">'+ UserName + '</td>' +
               '    <td id="" class="table_right width_per75">' +
               '        <input id="SftpConfigEditButton" type="button" value="' + UsbHostLgeDes["s0642sftp"] + '" ' +
               '               class="CancleButtonCss browserbutton" style="margin-left:0;" ' +
               '               onclick="OnChangeEditSFTPClientCfg()">' +
               '    </td>' +
               '</tr>';
	$("#SFTPUsernameRow").before(html);
}

function AddChoosDirHtml()
{
    var html =  '<tr border="1" id="ChooseDirRow"> ' +
                '    <td id="" class="table_title width_per25"></td>' +
                '    <td id="" class="table_right width_per75">' +
                '        <input id="ChoosDir" type="text" title="" class="TextBox osgidisable" maxlength="null" ' +
                '               realtype="TextBox" bindfield="Empty" disabled=""/>' +
                '    </td>' +
                '</tr>' +
                '<tr border="1" id="ChooseDirButton">' +
                    '<td id="" class="table_title width_per25"></td>' +
                    '<td id="" class="table_right width_per75">' +
                    '    <input id="ChoosDirButton" type="button" value="' + UsbHostLgeDes["s0636sftp"] + '" ' +
                    '           title="' + UsbHostLgeDes["s0637sftp"] + '" ' +
                    '           class="CancleButtonCss browserbutton thickbox" style="margin-left:0;"' +
                    '           alt="../smblist/smb_choosedir_list.asp?&Choose=1&TB_iframe=true"/>' +
                    '</td>' +
                '</tr>';
	$("#DirmodeRow").after(html);
}

function AddPortIDTextHtml()
{
	var html='<input class="UserInput" id="SFTPPortInfo" maxlength="255"/>';	
	$("#SFTPPortspan").after(html);
}

function AddMaximumIdleTimeTextHtml()
{
	var html='<input class="UserInput" id="MaximumIdleTimeInfo" maxlength="255"/> <span class="gray" id="MaximumIdleTimeRange">' + UsbHostLgeDes["s0628sftp"] + '</span>';	
	$("#MaximumIdleTimespan").after(html);
}

function AddPwdNoticeHtml()
{
	var PwdNoticeInfoObj = document.getElementById("PwdNotice");
	PwdNoticeInfoObj.innerHTML = UsbHostLgeDes["s0647sftp"]; 
}

function ControlDirMode()
{
	var DirModeValue = getCheckVal("Dirmode2");
	
	if (DirModeValue == "1")
	{
		setDisplay("ChooseDirRow", 1);
		setDisplay("ChooseDirButton", 1);
	}
	else
	{
		setDisplay("ChooseDirRow", 0);
		setDisplay("ChooseDirButton", 0);
	}
}

function ControlSFTPPort()
{
	if ("1" == getCheckVal("SFTPPort"))
	{
		setDisplay("SFTPPortspan", 0);
		setDisplay("SFTPPortInfo", 1);
		setDisplay("SFTPPortWarn", 1);
	}
	else
	{
		setDisplay("SFTPPortInfo", 0);
		setDisplay("SFTPPortWarn", 0);
		setDisplay("SFTPPortspan", 1);
	}
}

function ControlMaximumIdleTime()
{
	if ("1" == getCheckVal("MaximumIdleTime"))
	{
		setDisplay("MaximumIdleTimespan", 0);
		setDisplay("MaximumIdleTimeInfo", 1);
		setDisplay("MaximumIdleTimeRange", 1);
	}
	else
	{
		setDisplay("MaximumIdleTimeInfo", 0);
		setDisplay("MaximumIdleTimeRange", 0);
		setDisplay("MaximumIdleTimespan", 1);
	}
}

function ControlSFTPServiceEnable()
{
	if ("1" == getCheckVal("SFTPEnable"))
	{
		if (tedataGuide == 1) {
			if (DeviceStr == 'null') {
				AlertEx(GetLanguageDesc("s0562"));
				setCheck('SFTPEnable', 0);
			}
		} else {
			setDisplay("SFTPwarningRow", 1);
		}
	} else {
		setDisplay("SFTPwarningRow", 0);
	}
}

function OnDeleteButtonClick()
{
	var Form = new webSubmitForm();
	Form.addParameter(SFTPClientInfoList[CurrentSFTPClientIndex].Domain, "");
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?&RequestFile=html/ssmp/usbftp/usbhost.asp');
	Form.submit();
}

function setControl(index)
{
	CurrentSFTPClientIndex = index;
	if (index == -2)
	{
		setDisplay("SftpConfigEditButtonRow", 0);
		setDisplay("SFTPConfigForm", 0);
	}
	else if (index == -1)
	{
		setDisplay("SftpConfigEditButtonRow", 0);
		setDisplay("SFTPConfigForm", 1);
		setDisplay("sftpPwdNotice", 1);
		setDisplay("SFTPConfirmpasswordRow", 1);
		setDisplay("btnDownClientApply", 1);
		setDisplay("btnDownClientCancle", 1);
		setDisable("SFTPUsername", 0);
		setDisable("SFTPUserpassword", 0);
		setDisable("Dirmode1", 0);
		setDisable("Dirmode2", 0);
		setDisable("Privilege1", 0);
		setDisable("Privilege2", 0);
		setDisable("EnableAccount", 0);
		setDisable("btnDownClientApply", 0);
		setDisable("btnDownClientCancle", 0);
		setText("SFTPUsername", "");
		setText("SFTPUserpassword", "");
		setCheck("Dirmode1", 1);
		setCheck("Privilege1", 1);
	}
	else
	{
		setDisplay("btnDownClientApply", 0);
		setDisplay("btnDownClientCancle", 0);
		setDisplay("SFTPConfirmpasswordRow", 0);
		setDisplay("SftpConfigEditButtonRow", 1);
		setDisplay("SFTPConfigForm", 1);
		setDisplay("sftpPwdNotice", 0);
		setDisable("SFTPUsername", 1);
		setDisable("SFTPUserpassword", 1);
		setDisable("Dirmode1", 1);
		setDisable("Dirmode2", 1);
		setDisable("Privilege1", 1);
		setDisable("Privilege2", 1);
		setDisable("EnableAccount", 1);
		setDisable("btnDownClientApply", 1);
		setDisable("btnDownClientCancle", 1);
		document.getElementById("UserNameIndex").innerHTML = SFTPClientInfoList[index].SftpUserName + ":";
		setText("SFTPUsername", SFTPClientInfoList[index].SftpUserName);
		setText("SFTPUserpassword", "******");
		if (SFTPClientInfoList[index].SftpRoorDir == "/mnt/usb/")
		{
			setRadio("Dirmode", 0);
		}
		else
		{
			setRadio("Dirmode", 1);
		}
		
		if (SFTPClientInfoList[index].Permission == 1)
		{
			setRadio("Privilege", 0);
		}
		else
		{
			setRadio("Privilege", 1);
		}
		
		setCheck("EnableAccount", SFTPClientInfoList[index].EnableAccount);
	}
}

function InitCfgInfo()
{		
	setSelect('TransModeSelect', top.FTPType);
	setCheck("SFTPEnable",SFTPSrvInfo.SftpEnable);
	setCheck("LANWANEnable1", SFTPSrvInfo.SftpLANEnable);
    setCheck("LANWANEnable2", SFTPSrvInfo.SftpWANEnable);
    if (tedataGuide == 1) {
        setDisplay("LANWANEnable2", 0);
        setDisplay("LANWANEnable2_text", 0);
    }
	setText("SFTPPortInfo", SFTPSrvInfo.SftpPort);

	if (SFTPSrvInfo.SftpPort == 22)
	{
		setCheck("SFTPPort", 0);
	}
	else
	{
		setCheck("SFTPPort", 1);
	}
	
	setText("MaximumIdleTimeInfo", SFTPSrvInfo.SftpMaxIdleDur);
	
	if (SFTPSrvInfo.SftpMaxIdleDur == 300)
	{
		setCheck("MaximumIdleTime", 0);
	}
	else
	{
		setCheck("MaximumIdleTime", 1);
	}
	
	setText("WANMaxDuration", SFTPSrvInfo.SftpMaxDuration);
	if (SFTPSrvInfo.SftpStatus == 1)
	{
		setText("Status", "UP");
	}
	else
	{
		setText("Status", "DOWN");
	}
	
	setText("EnableTime",SFTPSrvInfo.SftpEnableTime);
}

function InitFrameHtml()
{
    var InitUserName = "";
	AddSFTPClientEditHtml(InitUserName);
	AddChoosDirHtml();
	AddPortIDTextHtml();
	AddMaximumIdleTimeTextHtml();
	AddPwdNoticeHtml();
	return;	
}

function ControlTransMode()
{
	top.FTPType = getValue("TransModeSelect");

	if ("FTP" == top.FTPType)
	{
		setDisplay("ConfigForm", 1);
		setDisplay("SvrConfigForm", 1);
		setDisplay("SFTPSvrConfigForm", 0);
		setDisplay("SFTPClientConfigForm", 0);	
	}
	else
	{
		setDisplay("ConfigForm", 0);
		setDisplay("SvrConfigForm", 0);
		setDisplay("SFTPSvrConfigForm", 1);
		setDisplay("SFTPClientConfigForm", 1);
	}
}

function NotDisplaySftpInfo()
{
    setDisplay("ftpwarningRow",0);
    setDisplay("ModeConfigForm",0);
    setDisplay("SFTPClientConfigForm", 0);
    setDisplay("SFTPEditPwd", 0);
    setDisplay("SFTPConfigForm", 0);
    setDisplay("SFTPSvrConfigForm", 0);
}

function InitControl()
{
	ControlTransMode();
	ControlSFTPPort();
	ControlMaximumIdleTime();
	ControlDirMode();
	ControlSFTPServiceEnable();
	setDisplay("SFTPEditPwd", 0);
	setDisplay("WANMaxDurationRow", 0);
	setDisplay("EnableTimeRow", 0);
	setDisable("WANMaxDuration", 1);
	setDisable("EnableTime", 1);
	setDisable("Status", 1);
	return;
}

function LoadFrame()
{
    init();
    if (IsGlobeFlag == 1) {
        setDisable('FtpdEnable',1);
        setDisable('SrvUsername',1);
        setDisable('Srvpassword',1);
        setDisable('SrvClDevType',1);
        setDisable('RootDirPath',1);
        setDisable('btnDownSrvApply',1);
        setDisable('btnDownSrcCancle',1);
        setDisable('table_downloadinfo',1);
        setDisable('URL',1);
        setDisable('Port',1);
        setDisable('Username',1);
        setDisable('Userpassword',1);
        setDisable('SaveAsPath_text',1);
        setDisable('SaveAsPath_button',1);
        setDisable('btnDown',1);
    }

    if (PwdTipsFlag == 1) {
        var pwdcheck1 = document.getElementById('checkinfo1');
        pwdcheck1.innerHTML =' <div class="row hidden-pw-row" id="psd_checkpwd" style="display:none;"><div class="left" style="display: table-cell; float:left; width: 126px;"><span style="text-align:center;" class="language-string" id="pwdvalue1" BindText="s0558"></span> </div></div>';
    }

    if (IsPtVdf == 1) {
         var enable = getCheckVal('FtpdEnable');
         if ((enable == 1) || (enable == '1')) {
            setDisplay("ftpwarningRow",1);
        } else {
            setDisplay("ftpwarningRow",0);
        }

        InitFrameHtml();
        InitCfgInfo();
        InitControl();
    } else {
        NotDisplaySftpInfo();
    }

    if (USBROLIST != "OK") {
        AlertEx(GetUSBRoInfoText());
    }

    if ((typeWord == 'CDN') && (isSupportPCDN == 1) && (enblHON == 1)) {
        setDisplay("SrvClDevTypeRow", 0);
        setDisplay("RootDirPathRow", 0);
    }

    return;
}
</script>
<style type="text/css">
input .UserInput{
	width:160px;
}

input .UserPort{
	width:40px;
}
</style>
</head>

<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		
		HWCreatePageHeadInfo("USBHOST", GetDescFormArrayById(UsbHostLgeDes, "s0538"), GetDescFormArrayById(UsbHostLgeDes, "s0539"), false);
		

		if ("frame_itvdf" == frame)
		{
			$("#USBHOST").before("<h1>"+GetLanguageDesc("s0548")+"</h1>");
		}
	</script>
	
	<form id="ModeConfigForm" action="" style="display:none">
		<div class="title_spread"></div>
		<div class="func_title" BindText="s0601sftp"></div>
		<table id="" width="100%" cellspacing="1" cellpadding="0">
		<tr border="1" id="TransModeRow">
			<td class="table_title width_per25" id="WanModeColleft" BindText="s0602sftp"></td>
			<td id="TransModeCol" class="table_right width_per75">
				<select id="TransModeSelect" class="Select" realtype="DropDownList" onchange="OnChangeTransmissionMode(this);">
					<option id="1" value="SFTP">SFTP</option>
				</select>
			</td>
		</tr>
		</table>
	</form>

	<form id="ConfigForm" action="">
		<div class="title_spread"></div>
		<div class="func_title" BindText="s0518"></div>
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="URL"          		RealType="TextBox"      DescRef="s052f" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="256"   ElementClass="UserInput" InitValue="Empty"/>
			<li id="Port"         		RealType="TextBox"      DescRef="s051a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="5"     ElementClass="UserPort"  InitValue="Empty"/>
			<li id="Username"     		RealType="TextBox"      DescRef="s051b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="255"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="Userpassword"       RealType="TextBox"      DescRef="s051c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="255"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="SaveAsPath_text"    RealType="TextOtherBox" DescRef="s051e" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="Empty" MaxLength="256"    ElementClass="UserInput" disabled="disabled" InitValue="[{Item:[{AttrName:'id', AttrValue:'UrlBase'},{AttrName:'type', AttrValue:'text'}, {AttrName:'style', AttrValue:'display:none'}, {AttrName:'maxlength', AttrValue:'256'}]},{Item:[{AttrName:'id', AttrValue:'SaveAsPath_button'},{AttrName:'name', AttrValue:'SaveAsPath_button'},{AttrName:'type', AttrValue:'button'}, {AttrName:'class', AttrValue:'CancleButtonCss browserbutton thickbox'}, {AttrName:'value', AttrValue:'s1605'}, {AttrName:'title', AttrValue:'s1436'}, {AttrName:'alt', AttrValue:'../smblist/smb_choosedir_list.asp?&Choose=1&TB_iframe=true'}]}]"/>
		</table>
		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("ConfigForm", null);
			var formid_hide_id = null;

			HWParsePageControlByID("ConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);

            if ((CfgMode.toUpperCase() != "TELMEXVULA") &&
                (CfgMode.toUpperCase() != "TELMEXACCESS") &&
                (CfgMode.toUpperCase() != "TELMEXRESALE")) {
                document.getElementById("URL").value = "ftp://";
                document.getElementById("Port").value = "21";
            } else {
                document.getElementById("URL").value = "";
                document.getElementById("Port").value = "";
            }
			
			if (!IsTelmex)
			{
				document.getElementById('SaveAsPath_textRemark').style.display = "none";
			}
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="button" name="btnDown" id="btnDown" style= "width: 130px;" class="ApplyButtoncss buttonwidth_100px" BindText="s051f" onClick='Submit()'>
				</td>
			</tr>
		</table>

		<div class="func_spread"></div>
		<script type="text/javascript">
			if (rosunionGame == "1") {
				$("#btnDown").removeClass("ApplyButtoncss").addClass("CancleButtonCss");
			}
			var UsbConfiglistInfo = new Array(new stTableTileInfo("s0528", null, "Username", false, 10),
											  new stTableTileInfo("s0529", null, "UserPassword"),
											  new stTableTileInfo("s052a", null, "Port"),
											  new stTableTileInfo("s0530", null, "URL", false, 30),
											  new stTableTileInfo("s052b", null, "LocalPath", false, 30),
											  new stTableTileInfo("s0520", null, "Status", false, 8),
											  null);

			var ColumnNum = 6;
			var TableDataInfo = HWcloneObject(DownloadInfo, 1);
			for (var i in TableDataInfo)
			{
				TableDataInfo[i].UserPassword = '*****';
			}
			TableDataInfo[TableDataInfo.length] = 'null';
			HWShowTableListByType(1, "UsbConfigList", 0, ColumnNum, TableDataInfo, UsbConfiglistInfo, UsbHostLgeDes, null);
		</script>
	</form>

	<form id="SvrConfigForm" action="">
		<div class="title_spread"></div>
		<div class="func_title" BindText="s0521"></div>
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="FtpdEnable"   RealType="CheckDivBox"  DescRef="s0524" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:310px; border:solid 1px #999999; background:#edeef0;'}]}]" ClickFuncApp="onClick=SetFtpEnable"/>
			<li id="ftpwarning"  RealType="HorizonBar"   DescRef="s0561" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="ftpwarning" InitValue="Empty"/>
			<li id="SrvUsername"  RealType="TextBox"      DescRef="s051b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty"/>
			<li id="Srvpassword"  RealType="TextBox"      DescRef="s051c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty" ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
			<li id="checkinfo1" RealType="HtmlText"  DescRef="s0557" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField=""  InitValue="Empty" style="display:none;" />
			<li id="SrvPort"      RealType="TextBox"      DescRef="s051a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="5" ElementClass="UserPort" InitValue="Empty"/>
			<li id="SrvClDevType" RealType="DropDownList" DescRef="s051d" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" Elementclass="UserInput" ClickFuncApp="onClick=onChangeDev;onChange=onSelectDev"/>
			<li id="RootDirPath"  RealType="TextBox"      DescRef="s0525" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" ElementClass="UserInput" InitValue="Empty"/>
		</table>

		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("SvrConfigForm", null);
			var formid_hide_id = null;

			HWParsePageControlByID("SvrConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);
			if(1 == IsItVdf){
				$("#SrvClDevType").remove();
				$('#SrvClDevTypeCol').html('<div class="iframeDropLog"><div id="IframeDropdownCorver" class="IframeDropdownCorver"></div><div id="IframeUSBHost" class="IframeDropdown"></div></div>');
				WriteDeviceOption('SrvClDevType');
			}
			else{
				WriteDeviceOption('SrvClDevType');
			}
			
			$('#Srvpassword').on('keyup',function(){
				if (PwdTipsFlag ==1)
				{
					$("#checkinfo1Row").css("display", "");
					$("#psd_checkpwd").css("display", "block");
					psdStrength();
				}
			});
			
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>" />
					<input type="button" name="btnDownSrvApply"  id="btnDownSrvApply"  class="ApplyButtoncss  buttonwidth_100px" BindText="s0526" onClick='SrvSubmit()' />
					<input type="button" name="btnDownSrcCancle" id="btnDownSrcCancle" class="CancleButtonCss buttonwidth_100px" BindText="s0527" onClick='Cancleconfig()' />
				</td>
			</tr>
		</table>
	</form>
	<div id="SFTPClientConfigForm" style="display:none">
	<div class="title_spread"></div>
	<div class="func_title" BindText="s0603sftp"></div>
	<script type="text/javascript">
		var UsbConfiglistInfo = new Array(new stTableTileInfo("s0614sftp", null, "SftpUserName"),
										  new stTableTileInfo("s0616sftp", null, "SftpRoorDir"),
										  new stTableTileInfo("s0617sftp", null, "Permission"),
										  new stTableTileInfo("s0618sftp", null, "EnableAccount"),null);
		ShowListControlInfo();
	</script>	
	<form id="SFTPConfigForm" style="display:none">
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="SFTPUsername"        RealType="TextBox"         DescRef="s0604sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="255"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="SFTPUserpassword"    RealType="TextBox"         DescRef="s0605sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="255"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="SFTPConfirmpassword" RealType="TextBox"         DescRef="s0606sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" MaxLength="255"    ElementClass="UserInput" InitValue="Empty"/>
			<li id="Dirmode"             RealType="RadioButtonList" DescRef="s0607sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{TextRef:'s0608sftp',Value:'0'},{TextRef:'s0609sftp',Value:'1'}]" ClickFuncApp="onclick=OnChangeDirMode"/>
			<li id="Privilege"           RealType="RadioButtonList" DescRef="s0610sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{TextRef:'s0611sftp',Value:'0'},{TextRef:'s0612sftp',Value:'1'}]"/>			
			<li id="EnableAccount"       RealType="CheckBox"        DescRef="s0613sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
		</table>
		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("SFTPConfigForm", null);
			var formid_hide_id = null;
			HWParsePageControlByID("SFTPConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="button" name="btnDownClientApply"  id="btnDownClientApply"  class="ApplyButtoncss  buttonwidth_100px" BindText="s0634sftp" onClick='ClientSubmit()' />
					<input type="button" name="btnDownClientCancle" id="btnDownClientCancle" class="CancleButtonCss buttonwidth_100px" BindText="s0635sftp" onClick='ClientCancle()' />
				</td>
			</tr>
		</table>
		<div class="func_spread"></div>
	</form>
	</div>
	
	<div id="SFTPEditPwd" style="display:none">
		<table width="100%" border="0" cellpadding="0" cellspacing="1">
			<tr id="secUsername">
				<td class="width_per40">
					<form id="SFTPEditPwdForm"  name="PwdChangeCfgForm">
						<table id="PwdChangeCfg" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF">
							<li id="SFTPEditUserName" RealType="HtmlText" DescRef="s0643sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"  InitValue="Empty"/>
							<li id="SFTPNewPassword"  RealType="TextBox"  DescRef="s0645sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"  InitValue="Empty" onKeyUp="psdStrength()" />
							<li id="SFTPCfmPassword"  RealType="TextBox"  DescRef="s0646sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"  InitValue="Empty"/>
						</table>
						<script>
							var UsbSFTPEditPwdFormList = HWGetLiIdListByForm("SFTPEditPwdForm", null);
							var PwdTableClass = new stTableClass("width_per60", "width_per40");
							HWParsePageControlByID("SFTPEditPwdForm", PwdTableClass, UsbHostLgeDes, null);
						</script>
					</form>
				</td>
				<td class="tabal_pwd_notice width_per60" id="PwdNotice"></td>
			</tr>             
		</table>

		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="button" name="btnSFTPEditApply"  id="btnSFTPEditApply"  class="ApplyButtoncss  buttonwidth_100px" BindText="s0648sftp" onClick='SFTPEditClientSubmit()' />
					<input type="button" name="btnSFTPEditCancle" id="btnSFTPEditCancle" class="CancleButtonCss buttonwidth_100px" BindText="s0649sftp" onClick='SFTPEditClientCancle()' />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="func_spread"></div>
	<form id="SFTPSvrConfigForm" action="" style="display:none">
		<div class="func_title" bindtext="s0619sftp"></div>
		<table id="table_downloadinfo" width="100%" cellspacing="1" cellpadding="0">
			<li id="SFTPEnable"        RealType="CheckBox"  DescRef="s0620sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" ClickFuncApp="onclick=OnChangeSFTPEnable"/>
			<li id="SFTPwarning"       RealType="HorizonBar"   DescRef="s0641sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
			<li id="LANWANEnable"      RealType="CheckBoxList"  DescRef="s0621sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="[{TextRef:'s0622sftp',Value:'0'},{TextRef:'s0623sftp',Value:'0'}]"/>
			<li id="SFTPPort"          RealType="CheckBox"  DescRef="s0624sftp" RemarkRef="s0625sftp" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" ClickFuncApp="onclick=OnChangeSFTPPort"/>
			<li id="MaximumIdleTime"   RealType="CheckBox"  DescRef="s0626sftp" RemarkRef="s0627sftp" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty" ClickFuncApp="onclick=OnChangeMaximumIdleTime"/>
			<li id="Status"            RealType="TextBox"   DescRef="s0629sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
			<li id="WANMaxDuration"    RealType="TextBox"   DescRef="s0630sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
			<li id="EnableTime"        RealType="TextBox"   DescRef="s0631sftp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/>
		</table>
		<script>
			var UsbConfigFormList = HWGetLiIdListByForm("SFTPSvrConfigForm", null);
			var formid_hide_id = null;
			HWParsePageControlByID("SFTPSvrConfigForm", TableClass, UsbHostLgeDes, formid_hide_id);
		</script>
		
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per25"></td>
				<td class="table_submit">
					<input type="button" name="btnSFTPSrvApply"  id="btnSFTPSrvApply"  class="ApplyButtoncss  buttonwidth_100px" BindText="s0632sftp" onClick='SFTPSrvSubmit()' />
					<input type="button" name="btnSFTPSrvCancle" id="btnSFTPSrvCancle" class="CancleButtonCss buttonwidth_100px" BindText="s0633sftp" onClick='SFTPSrvCancle()' />
				</td>
			</tr>
		</table>
	</form>	

	<script>
		ParseBindTextByTagName(UsbHostLgeDes, "div",    1);
		ParseBindTextByTagName(UsbHostLgeDes, "td",     1);
		ParseBindTextByTagName(UsbHostLgeDes, "input",  2);
		ParseBindTextByTagName(UsbHostLgeDes, "h1",     1);
	</script>
</body>
</html>

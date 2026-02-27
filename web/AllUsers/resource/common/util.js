function DebugLog(msg)
{
	try {
		console.log(msg);
	}catch(e){};
}

function SetDivValue(Id, Value)
{
	 try
	 {
		 var Div = document.getElementById(Id);
		 Div.innerHTML = Value;
	 }
	 catch(ex){
	 }
}
function GetDescFormArrayById(Language,Name)
{
	return (Language[Name] == null || Language[Name] == "undefined") ? "" : Language[Name];
}

function TranslateStrBySonetFlag(str, flag)
{
	var ret = str;
	if (flag != null && parseInt(flag, 10) == 1)
	{
		if (ret.match(/huawei[ ]?/ig) != null)
		{
			if (ret.match(/\bAll rights reserved\b/ig) == null)
				ret = ret.replace(/huawei[ ]?/ig, '');
		}

		if (ret.match(/\bONT\b/g) != null)
		{
			ret = ret.replace(/\bONT\b/g, "ONU");
		}
	}
	return ret;
}

function TranslateStrBySingtelFlag(str, flag)
{
	var ret = str;
	if (flag != null && parseInt(flag, 10) == 1)
	{
		if (ret.match(/\bONT\b/g) != null)
		{
			ret = ret.replace(/\bONT\b/g, "ONR");
		}
	}
	return ret;
}

function htmlencode(s)
{  
	var div = document.createElement('div');  
	div.appendChild(document.createTextNode(s));
	
	var innerHTMLcode = div.innerHTML;
	innerHTMLcode = innerHTMLcode.toString().replace(/\"/g,"&quot;");
	innerHTMLcode = innerHTMLcode.toString().replace(/\'/g, "&#39;");
	innerHTMLcode = innerHTMLcode.toString().replace(/\(/g, "&#40;");
	innerHTMLcode = innerHTMLcode.toString().replace(/\)/g, "&#41;");
	
	return innerHTMLcode;  
}

function ParseBindTextByTagName(LanguageArray, TagName, TagType, sonetflag, singtelflag)
{
	var all = document.getElementsByTagName(TagName);
	for (var i = 0; i < all.length; i++)
	{
		var b = all[i];
		var c = b.getAttribute("BindText");
		var str = GetDescFormArrayById(LanguageArray, c);
		if(c == null)
		{
			continue;
		}

		str = TranslateStrBySonetFlag(str, sonetflag);
		str = TranslateStrBySingtelFlag(str, singtelflag);

		if (1 == TagType)
		{
			b.innerHTML = str;
		}
		else if(2 == TagType)
		{
			b.value = str;
		}
	}
}

if(!window.console){
	window.console = {};
	var funcs = ['clear', 'debug', 'error','info', 'log', 'trace', 'warn'];
	for(var i = 0; i < funcs.length; i++) {
		window.console[funcs[i]] = function(){};
	}
}

function isSafeCharSN(val)
{
	if ( ( val == '<' )
	  || ( val == '>' )
	  || ( val == '\'' )
	  || ( val == '\"' )
	  || ( val == ' ' )
	  || ( val == '%' )
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

function isValidAscii(val)
{
	var str = '';
	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch < ' ' || ch > '~' )
		{
			str += ch;
		}
	}
	return str;
}

function isValidCfgStr(cfgName, val, len)
{
	if (isValidAscii(val) != '')
	{
		alert(cfgName + ' has invalid character "' + isValidAscii(val) + '".')
		return false;
	}
   if (val.length > len)
   {
	   alert(cfgName + ' cannot exceed ' + len  + ' characters.');
	   return false;
   }
}

function isHexaDigit(digit) {
	var hexVals = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
							"A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f");
	var hexValsLen = hexVals.length;
	var i = 0;
	var ret = false;
	for (i = 0; i < hexValsLen; i++)
	if (digit == hexVals[i] ) break;
	if (i < hexValsLen)
		ret = true;
	return ret;
}

function last8isHexaNumber(number)
{
	for (var index = 4; index < number.length; index++)
	{
		if (isHexaDigit(number.charAt(index)) == false)
		{
			return false;
		}
	}
	return true;
}

function isSafeStringExc(cmpStr, safeStr)
{
	for (var i = 0; i < cmpStr.length; i++) {
		var c = cmpStr.charAt(i);
		if (isValidAscii(c) != '') {
			 return false;
		} else {
			if (safeStr.indexOf(c) > -1) {
				return false;
			}
		}
	}
	return true;
}

function isSafeStringIn(cmpStr, safeStr)
{
	for (var i = 0; i < cmpStr.length; i++)
	{
		var c = cmpStr.charAt(i);
		if (isValidAscii(c) != '') {
			 return false;
		} else {
			if (safeStr.indexOf(c) == -1) {
				return false;
			}
		}
	}
	return true;
}

function IsSameSubnet(lip,rip)
{
	var laddrParts = lip.split('.');
	var raddrParts = rip.split('.');

	for(i=0; i<3; i++)
	{
		if(parseInt(laddrParts[i],10) != parseInt(raddrParts[i],10))
		{
			return false;
		}
	}

	return true;
}

function isValidName(name)
{
   return isSafeStringExc(name,'"<>%\\^[]`\+\$\,=\'#&: \t');
}

function isValidString(name)
{
   return isSafeStringExc(name,'"\\');
}

function isInteger(para)
{
	if (/^(\+|-)?\d+$/.test(para)) {
		return true;
	} else {
		return false;
	}
}

function isPlusInteger(para)
{
	if ((isInteger(para)) && (parseInt(para) >= 0)) {
		return true;
	} else {
		return false;
	}
}

function isFloat(para)
{
	if (/^(\+|-)?\d+($|\.\d+$)/.test(para)) {
		return true;
	} else {
		return false;
	}
}

function CheckNumber(Value, MinRange, MaxRange)
{
	if ( Value.length > 1 && Value.charAt(0) == '0' )
	{
		return false;
	}

	if (false == isInteger(Value))
	{
		return false;
	}

	var t = parseInt(Value, 10);
	if (isNaN(t) ==  true)
	{
		return false;
	}

	if (t < MinRange || t > MaxRange)
	{
		return false;
	}

	return true;
}

function CheckNumberHex(Value, MinRange, MaxRange)
{
	var i = 0;

	if ( Value.length > 5 )
	{
		return false;
	}
	for (i = 0; i < Value.length; i++)
	{
		if (false == isHexaDigit(Value.charAt(i)))
		{
			return false;
		}
	}

	var t = parseInt(Value, 16);
	if (t < MinRange || t > MaxRange)
	{
		return false;
	}

	return true;
}

function isValidCfgInteger(cfgName, val, start, end)
{
	   if (isInteger(val) == false)
	   {
		   alert(cfgName + ' is invalid, it must be digist.');
		   return false;
	   }
	   var temp = parseInt(val);
	   if (temp < start || temp > end)
	   {
		   alert(cfgName + ' must be greater than ' + start.toString()
				 + ' and less than ' + end.toString() + '.');
		   return false;
	   }
}

function isEndGTEStart(EndIp, StartIp)
{
   addrEnd = EndIp.split('.');
   addrStart = StartIp.split('.');
   E = parseInt(addrEnd[3],10) + 1;
   S = parseInt(addrStart[3],10) + 1;
   if (E < S)
	  return false;
   return true;
}

function IpCompare(Ip1, Ip2, Ip3, Mask1)
{
   lan1a = Ip1.split('.');
   lan2a = Ip2.split('.');
   lan1m = Mask1.split('.');

	  l1a_n = parseInt(lan1a[3]);
	  l2a_n = parseInt(lan2a[3]);
	  l1m_n = parseInt(lan1m[3]);

	  if (((l1a_n & l1m_n) ? (l1a_n & l1m_n) : l1a_n) > (Ip3)
		  ||(Ip3) > ((l2a_n & l1m_n) ? (l2a_n & l1m_n) : l2a_n))
	  {
		return false;
	  }
   return true;
}

function isValidIpAddress(address) {
   var i = 0;
   if ((address == '0.0.0.0') || (address == '255.255.255.255'))
	  return false;
   var addrParts = address.split('.');
   if (addrParts.length != 4) return false;
   for (i = 0; i < 4; i++) {
	  if (isNaN(addrParts[i]) || addrParts[i] ==""
		  || addrParts[i].charAt(0) == '+' ||  addrParts[i].charAt(0) == '-' )
		 return false;
	  if (addrParts[i].length > 3 || addrParts[i].length < 1)
	  {
		  return false;
	  }

	  if (addrParts[i].length > 1 && addrParts[i].charAt(0) == '0')
	  {
		  return false;
	  }

	  if (!isInteger(addrParts[i]) || addrParts[i] < 0)
	  {
		  return false;
	  }
	  num = parseInt(addrParts[i]);
	  if (i == 0 && num == 0)
	  {
		  return false;
	  }

	  if ( num < 0 || num > 255 )
		 return false;
   }
   return true;
}

function isBroadcastIp(ipAddress, subnetMask)
{
	 var maskLenNum = 0;
	 tmpMask = subnetMask.split('.');
	 tmpIp = ipAddress.split('.');

	 if((parseInt(tmpIp[0]) > 223) || ( 127 == parseInt(tmpIp[0])))
	 {
		 return true;
	 }

	 for(maskLenNum = 0; maskLenNum < 4; maskLenNum++)
	 {
		 if(parseInt(tmpMask[maskLenNum]) < 255)
			break;
	 }

	 tmpNum0 = parseInt(tmpIp[maskLenNum]);
	 tmpNum1 = 255 - parseInt(tmpMask[maskLenNum]);
	 tmpNum2 = tmpNum0 & tmpNum1;
	 if((tmpNum2 != 0) && (tmpNum2 != tmpNum1))
	 {
		 return false;
	 }

	 if(maskLenNum == 3)
	 {
		 return true;
	 }
	 else if(maskLenNum == 2)
	 {
		 if(((tmpIp[3] == 0)&&(tmpNum2 == 0))||
			 ((tmpIp[3] == 255)&&(tmpNum2 == tmpNum1)))
		 {
			 return true;
		 }
	 }
	 else if(maskLenNum == 1)
	 {
		 if(((tmpNum2 == 0)&&(tmpIp[3] == 0)&&(tmpIp[2] == 0)) ||
			 ((tmpNum2 == tmpNum1)&&(tmpIp[3] == 255)&&(tmpIp[2] == 255)))
		 {
			 return true;
		 }
	 }
	 else if(maskLenNum == 0)
	 {
		 if(((tmpNum2 == 0)&&(tmpIp[3] == 0)&&(tmpIp[2] == 0)&&(tmpIp[1] == 0)) ||
			 ((tmpNum2 == tmpNum1)&&(tmpIp[3] == 255)&&(tmpIp[2] == 255) &&(tmpIp[1] == 255)))
		 {
			 return true;
		 }
	 }

	 return false;

}

function isAbcIpAddress(address)
{
	if (isValidIpAddress(address) == false)
	{
		return false;
	}

	var addrParts = address.split('.');
	var num = 0;

	num = parseInt(addrParts[0]);
	if (num < 1 || num >= 224 || num == 127)
	{
		return false;
	}

	return true;
}

function isHostIpWithSubnetMask(address, subnet)
{
	if (isAbcIpAddress(address) == false)
	{
		return false;
	}

	if (isValidSubnetMask(subnet) == false)
	{
		return false;
	}

	var addr = IpAddress2DecNum(address);
	var mask = SubnetAddress2DecNum(subnet);
	if (0 == (addr & (~mask)))
	{
		return false;
	}

	if (isBroadcastIp(address,subnet) == true)
	{
	   return false;
	}

	return true;
}

function isDeIpAddress(address)
{
	if (isValidIpAddress(address) == false)
	{
		return false;
	}

	var num = 0;
	var addrParts = address.split('.');
	if (addrParts.length != 4)
	{
		return false;
	}

	if (!isInteger(addrParts[0]) || addrParts[0] < 0 )
	{
		return false;
	}
	num = parseInt(addrParts[0]);
	if (!(num >= 224 && num <= 247))
	{
		return false;
	}

	for (var i = 1; i <= 3; i++)
	{
		if (!isInteger(addrParts[i]) || addrParts[i] < 0)
		{
			return false;
		}
		num = parseInt(addrParts[i]);
		if (!(num >= 0 && num <= 255))
		{
			return false;
		}
	}

	return true;
}

function isBroadcastIpAddress(address)
{
	if (isValidIpAddress(address) == false)
	{
		return false;
	}

	var addrParts = address.split('.');
	if (addrParts[3] == '255')
	{
		return true;
	}
	return false;
}

function isLoopIpAddress(address)
{
	if (isValidIpAddress(address) == false)
	{
		return false;
	}

	var addrParts = address.split('.');
	if (addrParts[0] == '127')
	{
		return true;
	}
	return false;
}

function getLeftMostZeroBitPos(bitPos)
{
   var i = 0;
   var bitPosArr = [128, 64, 32, 16, 8, 4, 2, 1];

   for (i = 0; i < bitPosArr.length; i++)
	  if ((bitPos & bitPosArr[i]) == 0 )
		 return i;

   return bitPosArr.length;
}
function getRightMostOneBitPos(bitPos) {
   var i = 0;
   var bitPosArr = [1, 2, 4, 8, 16, 32, 64, 128];

   for (i = 0; i < bitPosArr.length; i++)
	  if (((bitPos & bitPosArr[i]) >> i) == 1)
		 return (bitPosArr.length - i - 1);

   return -1;
}

function maskIsAllZero(mask)
{
	if (mask.charAt(0) == '0' && mask.charAt(0) == ':')
	  return true;
}

function getV6AddrLeftMostZeroBitPos(num)
{
   var i = 0;
   var bitPosArr = [0x8000, 0x4000, 0x2000, 0x1000, 0x800, 0x400, 0x200, 0x100, 0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1];

   for ( i = 0; i < bitPosArr.length; i++ )
	  if ( (num & bitPosArr[i]) == 0 )
		 return i;

   return bitPosArr.length;
}

function getV6AddrRightMostOneBitPos(num)
{
   var i = 0;
   var bitPosArr = [1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100, 0x200, 0x400, 0x800, 0x1000, 0x2000, 0x4000, 0x8000];
   for ( i = 0; i < bitPosArr.length; i++ )
	  if (((num & bitPosArr[i]) >> i) == 1)
		 return (bitPosArr.length - i - 1);
   return -1;
}
function isValidSubnetMask(mask) {
   var i = 0;
   var num = 0;
   var zeroPos = 0;
   var oneBitPos = 0;
   var zeroBitExisted = false;

   if (mask == '0.0.0.0')
	  return false;

   var maskParts = mask.split('.');
   if ( maskParts.length != 4 ) return false;

   for (i = 0; i < 4; i++) {
	  if ( isNaN(maskParts[i]) == true || maskParts[i] == ""
		  || maskParts[i].charAt(0) == '+' ||  maskParts[i].charAt(0) == '-')
		 return false;
	  if (!isInteger(maskParts[i]) || maskParts[i] < 0)
	  {
		  return false;
	  }
	  num = parseInt(maskParts[i]);
	  if ((num < 0) || (num > 255))
		 return false;
	  if ((zeroBitExisted == true) && (num != 0))
		 return false;
	  zeroPos = getLeftMostZeroBitPos(num);
	  oneBitPos = getRightMostOneBitPos(num);
	  if (zeroPos < oneBitPos)
		 return false;
	  if (zeroPos < 8)
		 zeroBitExisted = true;
   }

   return true;
}

function isValidIPV6SubnetMask(mask)
{
   var i = 0, num = 0;
   var zeroBitPos = 0, oneBitPos = 0;
   var zeroBitExisted = false;

   if (maskIsAllZero(mask))
   {
		return false;
   }

   var shortMaskParts = mask.split('::');

   if (shortMaskParts.length >= 3)
   {
	   return false;
   }

   if (shortMaskParts.length == 2)
   {
	   if (shortMaskParts[1] != '')
	   {
		   return false;
	   }
	   var maskParts = shortMaskParts[0].split(':');
	   if (maskParts.length >= 8)
	   {
		   return false;
	   }
   }
   else if (shortMaskParts.length == 1)
   {
	   var maskParts = shortMaskParts[0].split(':');
	   if (maskParts.length != 8)
	   {
		   return false;
	   }
   }
   for (i = 0; i < maskParts.length; i++)
   {
	  if (false ==  IsIPv6AddressUshortValid(maskParts[i]))
	  {
		 return false;
	  }
	  num = parseInt(maskParts[i], 16);

	  if ( num < 0 || num > 65535 )
		 return false;
	  if ( zeroBitExisted == true && num != 0 )
		 return false;
	  zeroBitPos = getV6AddrLeftMostZeroBitPos(num);
	  oneBitPos = getV6AddrRightMostOneBitPos(num);

	  if ( zeroBitPos < oneBitPos )
		 return false;
	  if ( zeroBitPos < 16 )
		 zeroBitExisted = true;
   }
	return true;
}

function isValidPort(port)
{
   if (!isInteger(port) || port < 1 || port > 65535)
   {
	   return false;
   }

   return true;
}

function isValidPort2(port)
{
   if (!isInteger(port) || port < 1 || port > 65535)
   {
	   if(port == 0)
	   {
		   return true;
	   }
	   return false;
   }

   return true;
}

function isValidPortPair(StartPort,EndPort)
{
   if (!isValidPort(StartPort) || !isValidPort(EndPort))
   {
	   return false;
   }

   if (parseInt(StartPort) <= parseInt(EndPort) )
		   return false;

   return true;
}

function isMulticastMacAddress(address)
{
	var addrParts = address.split(':');
	if((addrParts[0] == '01')&&(addrParts[1] == '00')&&(addrParts[2] == '5e'))
	{
		return false;
	}

	return true;
}

function standIpv6Address(StrAddr)
{
	var i,j,k = 8;
	var addr = ['0','0','0','0','0','0','0','0'];
	var aAddr = StrAddr.split(":");
	var len = aAddr.length;

	if (len == 8)
	{
		return aAddr;
	}

	for (i = 0; i < len; i++)
	{
		if (aAddr[i] != '')
		{
			addr[i] = aAddr[i];
		}
		else
		{
			break;
		}
	}

	for (j = len - 1; j > 0; j--)
	{
		if (aAddr[j] != '')
		{
		   addr[k - 1] = aAddr[j];
		   k--;
		}
		else
		{
			break;
		}
	}

	return addr;
}

function isStartIpbigerEndIp(Startaddress,Endaddress)
{
	var i = 0;

	var startaddress = standIpv6Address(Startaddress);
	var endaddress   = standIpv6Address(Endaddress);

	for (i = 0; i < 8; i++)
	{
		if (parseInt(startaddress[i],16) < parseInt(endaddress[i],16))
		{
			return false;
		}
		else if (parseInt(startaddress[i],16) > parseInt(endaddress[i],16))
		{
			return true;
		}
	}
	return false;
}

function isStartIpSameEndIp(Startaddress,Endaddress)
{
	var i = 0;

	var startaddress = standIpv6Address(Startaddress);
	var endaddress   = standIpv6Address(Endaddress);

	for (i = 0; i < 8; i++)
	{
		if (parseInt(startaddress[i],16) != parseInt(endaddress[i],16))
		{
			return false;
		}
	}
	return true;
}

function isValidMacAddress(address)
{
   var str = '';
   var i = 0, j = 0;

   if ( address.toLowerCase() == 'ff:ff:ff:ff:ff:ff' )
   {
	   return false;
   }

   if ( address.toLowerCase() == '00:00:00:00:00:00' )
   {
	   return false;
   }

   var addrParts = address.split(':');
   if (addrParts.length != 6) return false;
   for (i = 0; i < 6; i++) {
	  if ( addrParts[i] == '' )
	  {
		 return false;
	  }

	  if ( addrParts[i].length != 2)
	  {
		return false;
	  }

	  if ( addrParts[i].length != 2) {
		 return false;
	  }
	  for (j = 0; j < addrParts[i].length; j++ ) {
		 str = addrParts[i].toLowerCase().charAt(j);
		 if ((str >= '0' && str <= '9') || (str >= 'a' && str <= 'f'))
			continue;
		 else
			return false;
	  }
   }

   return true;
}

function isValidMacAddress1(address)
{
   var str = '';
   var i = 0, j = 0;

   if ( address.toLowerCase() == 'ff:ff:ff:ff:ff:ff' )
   {
	   return false;
   }

   if ( address.toLowerCase() == '00:00:00:00:00:00' )
   {
	   return false;
   }

   var addrPara = address.split(':');
   if (addrPara.length != 6 ) return false;
   for (i = 0; i < 6; i++) {
	  if (addrPara[i] == '')
		 return false;
	  if (addrPara[i].length != 2) {
		return false;
	  }
	  if (addrPara[i].length != 2) {
		 return false;
	  }
	  for (j = 0; j < addrPara[i].length; j++) {
		 str = addrPara[i].toLowerCase().charAt(j);
		 if ((str >= '0' && str <= '9') || (str >= 'a' && str <= 'f'))
			continue;
		 else
			return false;
	  }
   }
   return true;
}


function isNtwkSgmtIpAddress(address)
{
	if (isValidIpAddress(address) == false)
	{
		return false;
	}

	var addrParts = address.split('.');
	if (addrParts[3] == '0')
	{
		return true;
	}
	return false;
}

function isSameSubNet(Ip1, Mask1, Ip2, Mask2)
{
   var index = 0;
   var lan1a = Ip1.split('.');
   var lan1m = Mask1.split('.');
   var lan2a = Ip2.split('.');
   var lan2m = Mask2.split('.');

   for (i = 0; i < 4; i++) {
	  var l1a_n = parseInt(lan1a[i]);
	  var l1m_n = parseInt(lan1m[i]);
	  var l2a_n = parseInt(lan2a[i]);
	  var l2m_n = parseInt(lan2m[i]);
	  if ((l1a_n & l1m_n) == (l2a_n & l2m_n))
		index++;
   }
   if (index == 4)
	  return true;
   else
	  return false;
}

function checkSpace(str)
{
	var len=str.length;

	if(len==0)
	{
		return false;
	}
	if(str.charAt(0)==' ')
	{
		return false;
	}
	if(str.charAt(len-1)==' ')
	{
		return false;
	}
	return true;
}

function CheckUrlParameter(inputUrl)
{
	if(checkSpace(inputUrl)==false)
	{
	  return false;
	}

	if(inputUrl.indexOf('http://')!=-1)
	{
		if(inputUrl.indexOf('http://')!=0)
		{
			return false;
		}
		if(inputUrl=="http://")
		{
			return false;
		}
		inputUrl=inputUrl.substring(7);
	}
	if(inputUrl.indexOf('/')==0)
	{
		return false;
	}
	var CutUrl=inputUrl.split('/');
	var Domine=CutUrl[0];
	var ports=Domine.split(':');
	var len=ports.length;
	if(ports.length>1)
	{
		if((parseInt(ports[len-1],10)>0&&parseInt(ports[len-1],10)<65536)==false)
		{
			return false;
		}
		Domine=Domine.substring(0,(Domine.length)-1-ports[len-1].length);
	}

	var i=0;
	var adds=Domine.split('.');
	if(adds[0]=='0'&&adds.length==4)
	{
		var isip=1;
		for(var key=1;key<=3;key++)
		{
			if(adds[key]<=255 && adds[key]>=0)
			{
				continue;
			}
			else
			{
				isip=0;
				break;
			}
		}
		if(isip==1)
		{
			return false;
		}
	}
	while(Domine.indexOf(" ")==0)
	{
		Domine=Domine.substring(1);
	}
	if(Domine=='0.0.0.0'||Domine=='255.255.255.255')
	{
		return false;
	}
	if ((isValidIpAddress(Domine) == true))
	{
		var addrs=Domine.split('.');
		if(parseInt(addrs[0],10)>=224)
		{
			return false;
		}
		if(Domine=='127.0.0.1')
		{
			return false;
		}
		if(addrs[3]=='0')
		{
			return false;
		}
	}
	return true;

}

function isNum(str)
{
	var valid=/[0-9]/;
	var i;
	for(i=0; i<str.length; i++)
	{
		if(false == valid.test(str.charAt(i)))
		{
			return false;
		}
	}
	return true;
}

function isNull( str )
{
	if ( str == "" ) return true;
	var regu = "^[ ]+$";
	var re = new RegExp(regu);
	return re.test(str);
}

function IsUrlValid(_Url)
{
	if(true == isNull(_Url))
	{
		return false;
	}
	var Url = new String(_Url.toLocaleLowerCase().replace("http://",""));
	var ExitColon = false;
	var ColonLocation = 0;
	var ColorReg = new RegExp(".*[a-zA-Z0-9]+:[0-9]+/*");

	var ArrayOfUrl = Url.split("//");

	if(ArrayOfUrl[0].toUpperCase() == "FTP:" || ArrayOfUrl[0].toUpperCase() == "HTTPS:")
	{
		return false;
	}
	if (ArrayOfUrl.length >= 2)
	{
		Url = ArrayOfUrl[1];
	}

	if (Url.length == 0)
	{
		return false;
	}

	ColonLocation = Url.indexOf(":", 0);
	if (ColonLocation == 0)
	{
		return false;
	}

	ExitColon = ColonLocation > 0 ? true : false;

	if (ExitColon == false)
	{
		return true;
	}

	return ColorReg.test(Url);
}

function IpAddress2DecNum(address)
{
	if (isValidIpAddress(address) == false)
	{
		return -1;
	}
	var addrParts = address.split('.');
	var num = 0;
	for (i = 0; i < 4; i++)
	{
		num += parseInt(addrParts[i]) * Math.pow(256, 3 - i);
	}
	return num;
}
function SubnetAddress2DecNum(address)
{
	if (isValidSubnetMask(address) == false)
	{
		return -1;
	}
	var addrParts = address.split('.');
	var num = 0;
	for (i = 0; i < 4; i++)
	{
		num += parseInt(addrParts[i]) * Math.pow(256, 3 - i);
	}
	return num;
}

function MacAddress2DecNum(address)
{
	if (isValidMacAddress(address) == false)
	{
		return -1;
	}
	var addrParts = address.split(':');
	var num = 0;
	for (i = 0; i < 6; i++)
	{
		num += parseInt(addrParts[i],16) * Math.pow(256, 5 - i);
	}
	return num;
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

function getOptionIndex(id,value)
{
	var selObj = getElement(id);
	if (selObj == null)
	{
		return -1;
	}

	for (i = 0; i < selObj.length; i++)
	{
		if (selObj.options[i].value == value)
		{
			return i;
		}
	}

	return -1;
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

function setVisible(id, sh)
{
	var status;
	if (sh > 0)
	{
		status = "visible";
	}
	else
	{
		status = "hidden"
	}
	var item = getElement(id);
	if (null != item)
	{
		getElement(id).style.visibility = status;
	}
}

function setElementInnerHtmlById(sId, sValue)
{
	document.getElementById(sId).innerHTML = htmlencode(sValue);
}

function setElementInnerHtml(sId, sValue)
{
	getElement(sId).innerHTML = htmlencode(sValue);
}

function setElementInnerHtmlByObj(obj, sValue)
{
	obj.innerHTML = htmlencode(sValue);
}

function setObjNoEncodeInnerHtmlValue(obj, sValue)
{
	obj.innerHTML = sValue;
}

function setNoEncodeInnerHtmlValue(sId, sValue)
{
	getElement(sId).innerHTML = sValue;
}

function setSelect(id, value)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return false;
	}

	for (var i = 0; i < item.options.length; i++)
	{
		if (item.options[i].value == value)
		{

			item.selectedIndex = i;
			return true;
		}
	}

	return false;
}

function setText(id, value)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return false;
	}

	item.value = value;
	return true;
}


function setCheck(id, value)
{
	var item;
	if (null == (item = getElement(id))) {
		debug(id + " is not existed" );
		return false;
	}
	if (value == '1') {
	   item.checked = true;
	} else {
	   item.checked = false;
	}

	return true;
}

function setRadio(id, value)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return false;
	}

	for (i=0; i<item.length; i++)
	{
		if (item[i].value == value)
		{
			item[i].checked = true;
			return true;
		}
	}

	debug("the option which value is " + value + " is not existed in " + id);
	return false;
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
			 addClass(sId,"osgidisable");
			 item.disabled = true;
		}
		else
		{
			 removeClass(sId,"osgidisable")
			 item.disabled = false;
		}
	}

	return true;
}

function getCheckVal(id)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return -1;
	}
	if (item.checked == true)
	{
		return 1;
	}

	else
	{
		return 0;
	}
}

function getRadioVal(id)
{
	var item;
	if (null == (item = getElement(id)))
	{
		debug(id + " is not existed" );
		return -1;
	}
	var itemLen = item.length;
	for (i = 0; i < itemLen; i++) {
		if (item[i].checked == true) {
		   return item[i].value;
		}
	}

	return -1;
}

function getSelectVal(id)
{
   return getValue(id);
}

function addOption(sId,OptionName,OptionValue,OptionText)
{
	var Param = document.createElement("option");
	Param.setAttribute('name',OptionName);
	Param.setAttribute('value',OptionValue);
	Param.innerHTML = OptionText;

	var selItem;
	if ((selItem = getElement(sId)) != null)
	{
		selItem.appendChild(Param);
		return Param;
	}
	else
	{
		debug(sId + " is not existed" );
		return null;
	}
}

function removeOption(sId,sValue)
{
	var selItem;
	if ((selItem = getElement(sId)) != null)
	{
		var index = getOptionIndex(sId,sValue);
		if (index >= 0)
		{

			selItem.removeChild(selItem.options[index]);
			return true;
		}
		else
		{
			debug("the option which value is " + sValue + " is not existed" );
			return false;
		}
	}

	debug(sId + " is not existed" );
	return false;
}

function removeAllOption(sId)
{
	var selItem;
	if ((selItem = getElement(sId)) != null)
	{
		selItem.length = 0;
		return true;
	}

	debug(sId + " is not existed" );
	return false;
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
					this.addParameter(divprefix+divSelect[k].name,divSelect[k].value)
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
			if(this.oForm.elements[i].name == domainNameTmp)
			{
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

		if (this.status == true)
			this.oForm.submit();
	};

	this.status = true;

	this.setNamePrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if (sFormName != null && sFormName != '') {
		this.addForm(sFormName,this.DomainNamePrefix);
	}
}

function MakeCheckBoxValue(srcForm)
{
	var inputArry = srcForm.getElementsByTagName("input");
	for (var i = 0; i < inputArry.length; i++)
	{
		if (inputArry[i].type == "checkbox")
		{
			var CheckBox = getElement(inputArry[i].name);
			if (CheckBox.checked == true)
			{
				CheckBox.value = 1;
			}
			else
			{
				CheckBox.value = 0;
			}
		}
		else if (inputArry[i].type == "radio")
		{
			var radio = getElement(inputArry[i].name);
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
var g_redirectTimer;
function util_GetXmlHttp()
{
	var util_xmlHttp;
	if(window.ActiveXObject){
	try {
		util_xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	}catch (e) {
	}
	if (util_xmlHttp == null)
		try{
		   util_xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (e) {
		}
	} else {
		util_xmlHttp = new XMLHttpRequest();
	}
	return util_xmlHttp;
}
function RedirectCurrentPage()
{
	var curLoc = window.location.href;

	if ( curLoc.lastIndexOf("RequestFile=") > 0 ){
		curLoc = "/" + curLoc.split("RequestFile=")[1];
	}
	try {
		var util_xmlHttp = util_GetXmlHttp();
		util_xmlHttp.open("GET",curLoc,false);
		util_xmlHttp.send();
		if( 4 == util_xmlHttp.readyState ) {
			if( 200 == util_xmlHttp.status ) {
				window.location = curLoc;
			}else{
				console.info(curLoc, util_xmlHttp.status);
			}
		}
	} catch (e){
	}
}
function DisableRepeatSubmit()
{
}
function Submit(type)
{
	if (CheckForm(type) == true)
	{
		var Form = new webSubmitForm();
		AddSubmitParam(Form,type);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
		DisableRepeatSubmit();
	}
}

function FinishLoad()
{
}

function DoUnload()
{
}

function DoLogout()
{
}

function CreateXMLHttp()
{
	 var xmlTmpHttp = null;
	 var aVersions = ["MSXML2.XMLHttp.5.0","MSXML2.XMLHttp.4.0","MSXML2.XMLHttp.3.0",
					  "MSXML2.XMLHttp","Microsoft.XMLHttp"];

	 if(window.XMLHttpRequest)
	 {
		 try
		 {
			 xmlTmpHttp = new XMLHttpRequest();
		 }
		 catch (e)
		 {
		 }
	 }
	 else
	 {
		 if(window.ActiveXObject)
		 {
			 for (var i=0; i<5; i++)
			 {
				  try
				  {
					   xmlTmpHttp = new ActiveXObject(aVersions[i]);
					   return xmlTmpHttp;
				  }
				  catch (e)
				  {
				  }
			 }
		  }
	 }


	 return xmlTmpHttp;
}

function AssociateParam(dest,src,name)
{
   var DestObj = eval(dest);
   var SrcObj = eval(src);
   var NameArray = name.split('|');

   for (j = 0; j < DestObj.length; j++)
   {
	  if (DestObj[j] == null)
		 break;
	  for (i = 0; i < SrcObj.length; i++)
	  {
		if (SrcObj[i] == null)
			break;
		if (DestObj[j].key.indexOf(SrcObj[i].key) > -1)
		{
			try
			{
				eval(dest + '[' + j + ']' + '.' + 'Relating' + '='
					 + src + '[' + i + ']');
			}
			catch (e)
			{
			}
			 for (k = 0; k < NameArray.length; k++)
			{
				 if (NameArray[k] == '')
				 {
					 continue;
				 }

				 try
				 {
					 eval(dest + '[' + j + ']' + '.' + NameArray[k] + '='
					   + src + '[' + i + ']' + '.' + NameArray[k]);
				 }
				 catch (e)
				 {
				 }
			}
			break;
		}
	  }
   }

}

function toBreakWord(val,lineLength)
{
   var content = '';
   var index = 0;
   var len = val.length;

   while (len > lineLength)
   {
	  content += val.substr(index,lineLength) + '<br>';
	  len -= lineLength;
	  index += lineLength;
   }
   content += val.substr(index);

   return content;
}

function getBoolValue(param)
{
	var value = parseInt(param);
	if (isNaN(value) == true )
	{
	   var LowerParam = param.toLowerCase();
	   if (LowerParam == 'enable')
	   {
		  return 1;
	   }
	   else
	   {
		  return 0;
	   }
	}
	else
	{
	   return value;
	}
}

function debug(info)
{
}

function isMaskOf24BitOrMore(mask)
{
	var i = 0, num = 0;
	if(false == isValidSubnetMask(mask))
	{
		return false;
	}
	var maskParts = mask.split('.');
	for(i = 0;i < 3;i++)
	{
		num = parseInt(maskParts[i]);
		if(num != 255)
			return false;
	}
	return true;
}

function ipInSubnet(ip,subnetStart,subnetEnd)
{
	var ipDec;
	var subnetStartDec;
	var subnetEndDec;

	ipDec = IpAddress2DecNum(ip);
	subnetStartDec = SubnetAddress2DecNum(subnetStart);
	subnetEndDec = SubnetAddress2DecNum(subnetEnd);
   if((ipDec >= subnetStartDec) && (ipDec <= subnetEndDec ))
	{
		return true;
	}

	return false;
}
function netmaskIsContinue(Mask)
{
	var ulmask;
	var i;
	var ulTmp = 0xffffffff;
	ulmask = SubnetAddress2DecNum(Mask);
	for (i = 0; i < 32; i++)
	{
		if (ulTmp == ulmask)
		{
			return 0;
		}

		ulTmp <<= 1 ;
	}

	return 1;
}

function getmaskLength(Mask)
{

	var ulTmp;
	var ulCount = 0;
	var ulmask;
	ulTmp = IP_NetmaskIsContinue(Mask);
	ulmask = SubnetAddress2DecNum(Mask);
	if (ulTmp)
	{
		return 0;
	}

	while (ulmask != 0)
	{
		ulmask = ulmask << 1;
		ulCount++;
	}
	return ulCount;
}

function removeSpaceTrim(inputStr)
{
   var inputStrTemp;
   var i,j = 0;

   if(inputStr == "")
   {
	  return "";
   }

   for(i=0;i<inputStr.length;i++)
	{
	   if(inputStr.charAt(i) == ' ')
	   {
		   continue;
	   }
	   else
	   {
		   break;
	   }
	}

	inputStrTemp = inputStr.substr(i,inputStr.length-i);

	if(inputStrTemp == "")
	{
	   return "";
	}

	for(i=inputStrTemp.length-1;i>=0;i--)
	{
		if(inputStrTemp.charAt(i) == ' ')
		{
			j++;
			continue;
		}
		else
		{
			break;
		}
	}

	inputStrTemp = inputStrTemp.substr(0,inputStrTemp.length-j);

	return inputStrTemp;

}


function XmlHttpSendAspFlieWithoutResponse(FileName)
{
	var xmlHttp = null;
	if(null == FileName || FileName == "")
	{
		return false;
	}
	if(window.XMLHttpRequest)
	{
		xmlHttp = new XMLHttpRequest();
	}
	else if(window.ActiveXObject)
	{
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlHttp.open("GET", FileName, false);
	xmlHttp.send(null);
}

function AlertEx(content)
{
	XmlHttpSendAspFlieWithoutResponse("/html/ssmp/common/StartFileLoad.asp");
	alert(content);
}

function ConfirmEx(content)
{
	XmlHttpSendAspFlieWithoutResponse("/html/ssmp/common/StartFileLoad.asp");
	if(confirm(content))
	{
		return true;
	}
	return false;
}

function CheckIpAddressValid(ipAddr)
{
	if ( ipAddr != '' && (isValidIpAddress(ipAddr) == false || isAbcIpAddress(ipAddr) == false))
	{
		if(IsIPv6AddressValid(ipAddr) == false)
		{
			return false;
		}
	}
	return true;
}
function CheckDomainName(domainName)
{
	if(domainName != '')
	{
		var adr  = domainName;
		var arr  = domainName.split(".");
		var i=0;
		var j=0;

		if (adr.length >= 256)
		{
			return false;
		}

		if( (adr.charAt(adr.length -1) == '.' ) || (adr.charAt(0) == '.'))
		{
			return false;
		}

		for(i=0;i<adr.length;i++)
		{
			if( ((adr.charAt(i) =='.') && (adr.charAt(i+1) =='.')))
			{
				return false;
			}
		}

		for(i=0;i<arr.length;i++)
		{
			if (arr[i].length > 63)
			{
				return false;
			}
			for(j=0;j<arr[i].length;j++)
			{
				if( !((arr[i].charAt(j)>='A' && arr[i].charAt(j)<='Z') || (arr[i].charAt(j)>='a' && arr[i].charAt(j)<='z') || (arr[i].charAt(j)>='0' && arr[i].charAt(j)<='9') || (arr[i].charAt(j)=='-')) )
				{
					return false;
				}
			}
		}

		if( (arr[arr.length-1].charAt(arr[arr.length-1].length -1)== '-') || (arr[arr.length-1].charAt(arr[arr.length-1].length -1)== '.' ) || (arr[0].charAt(0)== '.'))
		{
			return false;
		}
	}

	return true;
}

function CheckMultDomainName(domainName)
{		
	var domainParts = domainName.split(',');
	var num = domainParts.length;
	for (var i = 0;i<num;i++)
	{
		if (false == CheckDomainName(domainParts[i]))
		{
			return false;
		}
	}
    return true;		
}

function CheckDomainNameWithWildcard(domainName)
{
	if(domainName != '')
	{
		var adr  = domainName;
		var arr  = domainName.split(".");
		var i=0;
		var j=0;

		if (adr.length >= 256)
		{
			return false;
		}

		if( (adr.charAt(adr.length - 1) == '.' ) || (adr.charAt(0) == '.'))
		{
			return false;
		}

		for(i=0;i<adr.length;i++)
		{
			if( ((adr.charAt(i) =='.') && (adr.charAt(i+1) =='.')))
			{
				return false;
			}
		}

		for(i=0;i<arr.length;i++)
		{
			if (arr[i].length > 63)
			{
				return false;
			}
			for(j=0;j<arr[i].length;j++)
			{
				var IsWildcardVaild = 0;
				if (arr[i].length == 1 && arr[i] == '*')
				{
					IsWildcardVaild = 1;
				}

				if( !((arr[i].charAt(j)>='A' && arr[i].charAt(j)<='Z')
				|| (arr[i].charAt(j)>='a' && arr[i].charAt(j)<='z')
				|| (arr[i].charAt(j)>='0' && arr[i].charAt(j)<='9')
				|| (arr[i].charAt(j)=='-')
				|| IsWildcardVaild))
				{
					return false;
				}
			}
		}

		if( (arr[arr.length-1].charAt(arr[arr.length-1].length -1)== '-') || (arr[arr.length-1].charAt(arr[arr.length-1].length -1)== '.' ) || (arr[0].charAt(0)== '.'))
		{
			return false;
		}
	}

	return true;
}

function CheckIsIpOrNot(ipOrDomainStr)
{
	var ch = ipOrDomainStr.charAt(0);
	if( (ch <= '9' && ch >= '0') || (-1 != ipOrDomainStr.indexOf(":")) )
	{
		return true;
	}

	return false;
}

function CheckIpOrDomainIsValid(ipOrDomainStr)
{
	if( true == CheckIsIpOrNot(ipOrDomainStr) )
	{
		if(false == CheckIpAddressValid(ipOrDomainStr))
		{
			return false;
		}
	}
	else
	{
		if (false == CheckDomainName(ipOrDomainStr))
		{
			return false;
		}
	}
	return true;
}

function CheckPwdIsComplex(str,UserName)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}

	if (!CompareString(str,UserName) )
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

function isSpecialCharacterInString(str)
{
	var specia_Reg =/^.*[`~!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\'\;\,\./:\"\?><\\\| ]{1,}.*$/;
	var MyReg = new RegExp(specia_Reg);
	if ( MyReg.test(str) )
	{
		return true;
	}
	return false;
}

function isSpecialCharacterNoSpace(str)
{
	var specia_Reg =/^.*[`~!@#\$%\^&\*\(\)_\+\-=\[\]\{\}\'\;\,\./:\"\?><\\\|]{1,}.*$/;
	var MyReg = new RegExp(specia_Reg);
	if ( MyReg.test(str) )
	{
		return true;
	}
	return false;
}

function isDigitInString(str)
{
	var digit_reg = /^.*([0-9])+.*$/;
	var MyReg = new RegExp(digit_reg);
	if ( MyReg.test(str) )
	{
		return true;
	}
	return false;
}

function isUppercaseInString(str)
{
		var upper_reg = /^.*([A-Z])+.*$/;
		var MyReg = new RegExp(upper_reg);
		if ( MyReg.test(str) )
		{
			return true;
		}
		return false;
}

function isLowercaseInString(str)
{
		var lower_reg = /^.*([a-z])+.*$/;
		var MyReg = new RegExp(lower_reg);
		if ( MyReg.test(str) )
		{
			return true;
		}
		return false;
}

function CompareString(srcstr,deststr)
{
	var reverestr=(srcstr.split("").reverse().join(""));
	if ( srcstr == deststr )
	{
		return false;
	}

	if (reverestr == deststr )
	{
		return false;
	}
	return true;
}

function GetStringContent(str, Length)
{
	if (str.length > Length)
	{
			str = str.toString().replace(/&nbsp;/g," ");
			str = str.toString().replace(/&quot;/g,"\"");
			str = str.toString().replace(/&gt;/g,">");
			str = str.toString().replace(/&lt;/g,"<");
			str = str.toString().replace(/&#39;/g, "\'");
			str = str.toString().replace(/&#40;/g, "\(");
			str = str.toString().replace(/&#41;/g, "\)");
			str = str.toString().replace(/&amp;/g,"&");

			var strNewLength = str.length;
			if(strNewLength > Length )
			{
				str=str.substr(0, Length) + "......";
			}
			else
			{
				str=str.substr(0, Length);
			}
			str = str.toString().replace(/&/g,"&amp;");
			str = str.toString().replace(/>/g,"&gt;");
			str = str.toString().replace(/</g,"&lt;");
			str = str.toString().replace(/ /g,"&nbsp;");
			str = str.toString().replace(/\"/g,"&quot;");
			str = str.toString().replace(/\'/g,"&#39;");
			return str;
	}
	str = str.toString().replace(/ /g,"&nbsp;");
	return str;
}


function GetStringContentForTitle(str, Length)
{
	if (str.length > Length)
	{
			str = str.toString().replace(/&nbsp;/g," ");
			str = str.toString().replace(/&quot;/g,"\"");
			str = str.toString().replace(/&gt;/g,">");
			str = str.toString().replace(/&lt;/g,"<");
			str = str.toString().replace(/&#39;/g, "\'");
			str = str.toString().replace(/&#40;/g, "\(");
			str = str.toString().replace(/&#41;/g, "\)");
			str = str.toString().replace(/&amp;/g,"&");

			var strNewLength = str.length;
			if(strNewLength > Length )
			{
				str=str.substr(0, Length) + "...";
			}
			else
			{
				str=str.substr(0, Length);
			}
			str = str.toString().replace(/&/g,"&amp;");
			str = str.toString().replace(/>/g,"&gt;");
			str = str.toString().replace(/</g,"&lt;");
			str = str.toString().replace(/ /g,"&nbsp;");
			str = str.toString().replace(/\"/g,"&quot;");
			str = str.toString().replace(/\'/g,"&#39;");
			return str;
	}
	str = str.toString().replace(/ /g,"&nbsp;");
	return str;
}

function GetUnescapedString(str)
{
	str = str.toString().replace(/&nbsp;/g," ");
	str = str.toString().replace(/&quot;/g,"\"");
	str = str.toString().replace(/&gt;/g,">");
	str = str.toString().replace(/&lt;/g,"<");
	str = str.toString().replace(/&amp;/g,"&");
	str = str.toString().replace(/&#39;/g, "\'");
	str = str.toString().replace(/&#40;/g, "\(");
	str = str.toString().replace(/&#41;/g, "\)");
    return str;
}


function ShowNewRow(oldstring)
{
	var newstring = '';
	var LineLength = 200;
	for (j = 0; j < parseInt((oldstring.length)/LineLength); j++)
	{
		newstring += oldstring.substr(LineLength*j,LineLength*(j+1)) + ' ';
	}
	newstring +=  oldstring.substr(LineLength*j,oldstring.length);
	return newstring;
}

var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var base64DecodeChars = new Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
		16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1,
		-1, -1, -1, -1);

function Base64Encode(codeStr) {
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

function Base64Decode(codeStr) {
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

function isValidBase64(value)
{
	if((value.length)%4 != 0 )
	{
		return false;
	}

	var List = value.split('=');
	if(List.length > 3)
	{
		return false;
	}
	if(List.length == 2)
	{
		if(!(List[1] == ""))
		{
			return false;
		}
	}
	if(List.length == 3)
	{
		if(!(List[1] == "" && List[2] == ""))
		{
			return false;
		}
	}

	for (var i = 0; i < value.length; i++)
	{
		var ch = value.charAt(i);

		var find = false;
		for (var j = 0; j < base64EncodeChars.length; j++)
		{
			if ((ch == base64EncodeChars.charAt(j)) || (ch == '='))
			{
				find = true;
				break;
			}
		}

		if (find == false)
			return false;

	}

	var TempHex;
	var TempBase64;
	TempHex = ConvertBase64ToHex(value);
	TempBase64 = ConvertHexToBase64(TempHex);
	if(TempBase64 != value)
	{
		return false;
	}

	return true;
}


function ConvertHexToBase64(value)
{
	var hexstr;
	var hexvalue;
	var inflow;
	inflow = "";
	var temp;


	if ((value.length)%2 == 1)
	{
	temp = '0' + value;
	}
	else
	{
		temp = value;
	}
	for(var i = 0; i < temp.length/2; i++)
	{
		hexstr = temp.substr(i*2, 2);
		hexvalue = parseInt(hexstr, 16);
		inflow += String.fromCharCode(hexvalue);
	}

	var out = Base64Encode(inflow);

	return out;
}


function ConvertBase64ToHex(value)
{
	var inflow = Base64Decode(value);
	var out;
	out = "";

	for (var i = 0; i < inflow.length; i++)
	{
		var temp = inflow.charCodeAt(i).toString(16);
		if (temp.length == 1)
		{
			out += '0' + temp;
		}
		else
		{
		   out += temp;
		}
	}

	return out;
}

function CheckDateIsValid(chkDate)
{
	var theDateReg = /^(\d{4})(-)([1][0-2]|[0]{0,1}[1-9])(-)([3][0-1]|[1-2]\d|[0]{0,1}[1-9])$/g;
	var matchResult = chkDate.match(theDateReg);

	if(null == matchResult){
		return false;
	}
	var strDate = chkDate.split("-");
	var currentDate = new Date(strDate[0],strDate[1],0);
	if(strDate[2] > currentDate.getDate()){
		return false;
	}
	return true;
}


function TabControl(Id, CssName, TabItemList)
{
	this.Id = Id;
	this.CssName = CssName;
	this.TableItemList = TabItemList;
}

function TabControlItem(ReferenceId, Text)
{
	this.ReferenceId = ReferenceId;
	this.Text = Text;
}

function OnClickTableControlItem(CurrentIndex, List, Id)
{
	var IdList = List.split(",");
	var i;
	for (i = 0; i < IdList.length; i++)
	{
		if (IdList[i].length == 0)
		{
			continue;
		}
		try
		{
			document.getElementById(IdList[i]).style.display = "none";
			document.getElementById('LinkItem'+i).style.color = "blue";
		}
		catch(ex)
		{

		}
	}
	document.getElementById(Id).style.display = "block";
	document.getElementById('LinkItem'+CurrentIndex).style.color = "red";

}

function TabControlParser(NativeControl)
{
	this.NativeControl = NativeControl;
	this.ParseControlItem = function(_ItemHtml)
	{
		var ItemHtml = _ItemHtml.replace("{","").replace("}","");
		var Arr = ItemHtml.split(",");
		return new TabControlItem(Arr[0], Arr[1]);
	}
	this.ParseTabControl = function()
	{
		var Reference = NativeControl.reference;
		var RefList = Reference.split("},");
		var RefLength = RefList.length;
		var i = 0;
		var TabItemList = new Array();
		for (i = 0; i < RefLength; i++)
		{
			TabItemList[i] = this.ParseControlItem(RefList[i]);
		}
		return new TabControl(this.NativeControl.Id, this.NativeControl.Css, TabItemList);
	}

	this.GetOuterHTML = function(Tab)
	{
		if (null == Tab)
		{
			return "";
		}

		var OuterHTML = "<table border=\"0\" id=\""+Tab.Id+"\"><tr css=\""+this.CssName+"\">";
		var i = 0;
		var ItemList = Tab.TableItemList;
		var ItemCount = ItemList.length;
		var EachItem = null;
		var IdListText = "";
		for (i = 0; i < ItemCount; i++)
		{
			EachItem = ItemList[i];
			IdListText += EachItem.ReferenceId + ",";
		}
		for (i = 0; i < ItemCount; i++)
		{
			EachItem = ItemList[i];
			OuterHTML +="<td onclick='return OnClickTableControlItem("+i+",\""+IdListText+"\",\""+EachItem.ReferenceId+"\");'><a id='LinkItem"+i+"' href=# style='color:blue;text-decoration: underline'>"+EachItem.Text+"</a></td>";
		}

		OuterHTML+= "</tr></table>";
		return OuterHTML;
	}

	this.RenderControl = function()
	{
		var Tab = this.ParseTabControl();
		var OuterHTML = this.GetOuterHTML(Tab);
		this.NativeControl.outerHTML = OuterHTML;
		var i = 0;
		for (i = 0; i < Tab.TableItemList.length; i++)
		{
		 document.getElementById(Tab.TableItemList[i].ReferenceId).style.display="none";
		}
		document.getElementById(Tab.TableItemList[0].ReferenceId).style.display="block";
		document.getElementById("LinkItem0").style.color="red";

	}
}


function InitControlDataType()
{
	var TextBoxList = document.getElementsByTagName("input");
	var i = 0;
	var DataType = null;
	var Control = null;
	for (i = 0; i < TextBoxList.length; i++)
	{
		Control = TextBoxList[i];
		if (Control.type != "text")
		{
			continue;
		}

		DataType = TextBoxList[i].getAttribute("datatype");
		if (null == DataType)
		{
			continue;
		}

		if (DataType == "int")
		{
			Control.onkeypress = function(event)
			{
				var event = event || window.event;
				var KeyCode = event.keyCode || event.charCode;

				if ((KeyCode < 48 || KeyCode > 57) && KeyCode != 8)
				{
					this.focus();
					return false;
				}

				return true;
			};

			Control.onchange = function()
			{
				var MinValue = this.getAttribute("minvalue");
				var MaxValue = this.getAttribute("maxvalue");
				var ErrorMsg = this.getAttribute("ErrorMsg");
				var DefaultValue = this.getAttribute("default");

				if (this.value.length == 0 || this.vlue*1 == 0)
				{
						if ((ErrorMsg != null ) && (ErrorMsg != "undefined"))
						{
							AlertEx(ErrorMsg);
						}

						this.value = DefaultValue;
						this.focus();
						return false;
				}

				if  ((MinValue != null)
				&& (MaxValue != null)
				&& (MinValue != undefined)
				&& (MaxValue != undefined))
				{
					if (this.value*1 < MinValue*1 || this.value*1 > MaxValue*1)
					{
						if ((ErrorMsg != null ) && (ErrorMsg != "undefined"))
						{
							AlertEx(ErrorMsg);
						}

						this.value = DefaultValue;
						this.focus();
						return false;
					}
				}

				return true;
			};

		}
	}
}

function UrlFilterInfoClass(_UrlEnable, _NameListMode, _SmartEnable, _UrlList)
{
	this.UrlEnable = _UrlEnable;
	this.NameListMode = _NameListMode;
	this.SmartEnable = _SmartEnable;
	this.UrlList = _UrlList;
	this.Observer = new Array();
	this.SetEnable = function(Value)
	{
		this.UrlEnable = Value;
		this.NotifyObserver();
	}
	this.GetEnable = function()
	{
		return this.UrlEnable;
	}

	this.SetSmartEnable = function(Value)
	{
		this.SmartEnable = Value;
	}
	this.GetSmartEnable = function()
	{
		return this.SmartEnable;
	}

	this.SetNameListMode = function(Value)
	{
		this.NameListMode = Value;
		this.NotifyObserver();
	}
	this.GetNameListMode = function()
	{
		return this.NameListMode;
	}

	this.GetUrlList = function()
	{
		return this.UrlList;
	}
	this.SetUrlList = function(Value)
	{
		this.UrlList = Value;
		this.NotifyObserver();
	}

	this.AddUrl = function(Value)
	{
		this.UrlList.push(Value);
		this.NotifyObserver();
	}
	this.AddAllUrl = function(Value, Spliter)
	{
		var i = 0;
		var x = new String();
		var ArrayOfUrl = Value.split(Spliter);
		for (i = 0; i < Value.length; i++)
		{
			this.AddUrl(ArrayOfUrl[i]);
		}

	}

	this.DeleteUrl = function(Value)
	{
		var i = 0;
		for (i = 0; i < this.UrlList.length; i++)
		{
			if (this.UrlList[i] == Value)
			{
				this.UrlList[i] = null;
			}
		}

		this.NotifyObserver();
	}
	this.GetUrlListLength = function()
	{
		var i = 0;
		var Length = 0;
		for (i = 0; i < this.UrlList.length; i++)
		{
			if (this.UrlList[i] != null)
			{
				Length++;
			}
		}

		return Length;
	}

	this.GetUrlString = function()
	{
		var UrlString = "";
		var i = 0;
		for (i = 0; i < this.UrlList.length; i++)
		{
			if (this.UrlList[i] != null)
			{
				UrlString = UrlString + "|" + this.UrlList[i];
			}
		}

		if (UrlString.length > 0)
		{
		   return UrlString.substr(1, UrlString.length-1);
		}

		return UrlString;
	}
	this.GetAllUrl  = function()
	{
		return this.UrlList;
	}

	this.AddObserver = function(DataUIObserverObj)
	{
		this.Observer.push(DataUIObserverObj);
	}

	this.NotifyObserver = function()
	{
		var i = 0;
		for (i = 0; i < this.Observer.length; i++)
		{
			this.Observer[i].UpdateUI(this);
		}
	}

	this.SaveData = function(DataObj)
	{
		DataObj.SaveData(this);
	}
}

function adjustFrameHeight(frameContainerID, frameID, diffOffset, minHeight)
{
	var ifm = document.getElementById(frameID);
	try{
	var subWeb = document.frames ? document.frames[frameID].document : ifm.contentDocument;
	}
	catch(e){
		return ;	
	}
	var newMin = 0;

	if (minHeight != null)
	{
		var minClientHeight = document.body.clientHeight - 56 - ((navigator.appName.indexOf("Internet Explorer") >= 0) ? 4 : 0);
		newMin = Math.max(minHeight, minClientHeight);
	}

	if (ifm != null && subWeb != null && subWeb.body != null)
	{
		var newHeight = subWeb.body.offsetHeight + diffOffset;
		//if (document.getElementById(frameContainerID).scrollHeight < subWeb.body.scrollHeight)
		{
			//ifm.height = newHeight;
			$("#" + frameContainerID).css("height", Math.max(newHeight, newMin) + "px");
		}
	}
}

function GetShortStr(str, num)
{
	if(null == str || 0 == str.length){
		return "";
	}
	num = (isNaN(num) || num) < 0? 5: num;
	var newStr = "";
	var UpReg = /^[A-Z]+$/;
	var LittleReg = /^[a-z0-9\_]+$/;
	var curNum = 0;
	for(i=0; i< str.length; i++){
		if(UpReg.test(str[i])){
			curNum += 0.8;
		}else if(LittleReg.test(str[i])){
			curNum += 0.45;
		}else{
			curNum += 1;
		}
		if(curNum >= num){
			newStr = str.substring(0, i) + "...";
			break;
		}
		if(i >= str.length - 1)
		{
			newStr = str;
			break;
		}
	}
	return newStr;
}

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
			 var TmpResult  = "\"" + data + "\"";
			 Result = eval(TmpResult);
		}
	});
	
	return Result;
}

function CheckHwAjaxRet(Parameter)
{
	var TmpResult  = "\"" + Parameter + "\"";
	var Result = eval(TmpResult);
		
	if(Result == '{ "result": 0 }')
	{
		return true;
	}
	else
	{
		return false;
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

function HWGetDesByIndexId(DesArray,Id)
{
	try{
		return DesArray[Id];
	}catch(e){

		return "undefined";
	}
}

function HWParseResult(ReturnStr, ConfigIdList)
{
	if(null == ReturnStr)
	{
		return;
	}

	var result = ReturnStr.result;
	var ErrCode = "s" + ReturnStr.error;
	var ErrorId = HWGetIdByBindField(ConfigIdList, ReturnStr.pro);
	if(1 == result)
	{
		var ErrorDes = HWGetDesByIndexId(errLanguage, ErrCode);
		ErrorDes = "undefined" == ErrorDes ? errLanguage["s0xf7205001"]: ErrorDes;
		document.getElementById(ErrorId).style.backgroundColor="#FF0000";
	}
	else
	{
		var ErrorDes = HWGetDesByIndexId(errLanguage, "success");
	}
}

function createDropdown(selectid,dropdowndefault,width,dropdownArr,callfuncobj){
	
	//dropdownShow
	
	var i = 0;
	var dropdownShowId = selectid + "show";
	var dropdownHideId = selectid + "hide";
	$('#'+selectid).css({"width":width});
	
	var DropdownIdStr = "<div class='iframedropdownShow' id='" + dropdownShowId + "' onclick='showDropdown(this,event);'></div><ul class='iframedropdownHide' name='dropDownList' id='" + dropdownHideId + "' style='display:none;'></ul>";
	
	$('#'+selectid).html(DropdownIdStr);
	
	$('#'+dropdownShowId).html(dropdowndefault);
	$('#'+dropdownShowId).css({"width":"98%"});
	
	for(i;i<dropdownArr.length;i++){
		$("#"+dropdownHideId).append("<li id='"+ dropdownArr[i] + "' onclick='" + callfuncobj + "' >"+dropdownArr[i]+"</li>")
	}
	$('#'+dropdownHideId).css({"width":width});
}

var thisDropdownArr = '';
function createWlanDropdown(selectid,dropdowndefault,width,dropdownArr,callfuncobj){
	
	//dropdownShow
	thisDropdownArr = dropdownArr;
	var i = 0;
	var dropdownShowId = selectid + "show";
	var dropdownHideId = selectid + "hide";
	$('#'+selectid).css({"width":width});
	
	var DropdownIdStr = "<div class='iframedropdownShow' id='" + dropdownShowId + "' onclick='showWlanDropdown(this,event);'></div><ul class='iframedropdownHide' id='" + dropdownHideId + "' style='display:none;'></ul>";
	$('#'+selectid).html(DropdownIdStr);
	$('#'+dropdownShowId).html(dropdowndefault[0]);
	$('#'+dropdownShowId).css({"width":"98%"});
	
	for(i;i<dropdownArr.length;i++){
		$("#"+dropdownHideId).append("<li id='"+ dropdownArr[i][0] + "' dataValue = '" + dropdownArr[i][1] + "' onclick='" + callfuncobj + "' >"+dropdownArr[i][0]+"</li>")
	}
	$('#'+dropdownHideId).css({"width":width});
}

function setDropdownSelVal(selectid,dropdowndefault)
{
	var dropdownShowId = selectid + "show";
	$('#'+dropdownShowId).html(dropdowndefault);
}

var g_Allclickshow = false;
function SetClickFlag(flag)
{
	g_Allclickshow = flag;	
}

function showDropdown(obj, event){
	
	var ShowId = obj.id;
	var HideId = obj.id.split("show")[0] + "hide";
	$("#" + HideId).toggle(function(){
		if(false == g_Allclickshow){
			$('#'+ShowId).css("background-image","url('../../../images/arrow-up.png')");
			g_Allclickshow = true;
			
		}else{
			g_Allclickshow = false;
			$('#'+ShowId).css("background-image","url('../../../images/arrow-down.png')");
		}
	}
	);
	
	$("body").click(function(){
		$("#"+HideId).hide();
		g_Allclickshow = false;
		$('#'+ShowId).css("background-image","url('../../../images/arrow-down.png')");
	});
	
	var e = window.event || event;
	if(e.stopPropagation){
		e.stopPropagation();
	}else{
		window.event.cancelBubble = true;
	}
}

function showWlanDropdown(obj, event){
	
	var ShowId = obj.id;
	var HideId = obj.id.split("show")[0] + "hide";
	var dropdownArrHeight = (thisDropdownArr.length*39) + 'px';  
	$("#" + HideId).toggle(function(){
		if(false == g_Allclickshow){
			$("#DivEmpty").css('height',dropdownArrHeight);
			$('#'+ShowId).css("background-image","url('../../../images/arrow-up.png')");
			g_Allclickshow = true;
		}else{
			$("#DivEmpty").css('height','0px');
			g_Allclickshow = false;
			$('#'+ShowId).css("background-image","url('../../../images/arrow-down.png')");
		}
	}
	);
	
	$("body").click(function(){
		$("#DivEmpty").css('height','0px');
		$("#"+HideId).hide();
		g_Allclickshow = false;
		$('#'+ShowId).css("background-image","url('../../../images/arrow-down.png')");
	});
	
	var e = window.event || event;
	if(e.stopPropagation){
		e.stopPropagation();
	}else{
		window.event.cancelBubble = true;
	}
	
}

function chooseValue(obj){
	var text = obj.innerHTML;
	$('#dropdownShow').html(text);
}

function pageDisable()
{
    var input = document.getElementsByTagName("input");
    var select = document.getElementsByTagName("select");
	var textarea = document.getElementsByTagName("textarea");
    for(var i =0;i<input.length;i++)
    {
        input[i].disabled = true;
    }
    for(var i =0;i<select.length;i++)
    {
        select[i].disabled = true;
    }
	for(var i =0;i<textarea.length;i++)
    {
        textarea[i].disabled = true;
    }
	
}

function addClass(id, cls){

	var classval = getElement(id).getAttribute("class");
	var newclass = "";

	classval = (classval==null)?cls:classval.concat(" " + cls)

	if (hasClass(id, cls))
	{
		return;
	}

	getElement(id).setAttribute("class",classval);
}


function removeClass(id, cls){

	var classval = getElement(id).getAttribute("class");
	var newclass = "";

	if (classval == null)
	{
		return;
	}
	else
	{
		classval = classval.replace(cls,"");
	}

	getElement(id).setAttribute("class",classval);
}

function hasClass(id,cls)
{
    var re = new RegExp("\\b"+cls+"\\b");

    var elm = getElement(id);

    return re.test(elm.className);
}
if (!String.prototype.trim)
{
	String.prototype.trim = function() {
		var strTmp = this,
		strTmp = strTmp.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = strTmp.length;
		while (ws.test(strTmp.charAt(--i)));
		return strTmp.slice(0, i + 1);
	}
}

function IsKeyBoardContinuousChar(str) {
    var c1 = [ 
                ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
                ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
                ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
                ['z', 'x', 'c', 'v', 'b', 'n', 'm']
    ];

    str = str.split("");
    var y = [];
    var x = [];
    for (var c = 0; c < str.length; c++) {
        y[c] = 0;
        x[c] = -1;

        for (var i = 0; i < c1.length; i++) {
            for (var j = 0; j < c1[i].length; j++) {
                if (str[c] == c1[i][j]) {
                    y[c] = i; x[c] = j;
                }
            }
        }
    }

    for (var c = 1; c < str.length - 2; c++) {
        if (y[c - 1] == y[c] && y[c] == y[c + 1] && y[c + 1] == y[c + 2]) {
            if ((x[c - 1] + 1 == x[c] && x[c] + 1 == x[c + 1]  && x[c + 1] + 1 == x[c + 2])) {
                keyBoardConsecutiveNumber = str[c - 1] + str[c] + str[c + 1] + str[c + 2];
                return true;
            }
        }
    }
    return false;
}

function CheckConsecutiveChar(firstChar, secondChar, thirdChar, forthChar) {
    if (((forthChar - thirdChar) == 1) && ((thirdChar - secondChar) == 1) && ((secondChar - firstChar) == 1)) {
        return true;
    }

    return false;
}

function IsconsecutiveChar(str){
    var arr = str.split('');
    for (var i = 1; i < arr.length-2; i++) {
        var firstIndex = arr[i-1].charCodeAt();
        var secondIndex = arr[i].charCodeAt();
        var thirdIndex = arr[i+1].charCodeAt();
        var forthIndex = arr[i+2].charCodeAt();

        if ((CheckConsecutiveChar(firstIndex, secondIndex, thirdIndex, forthIndex)) ||
            (CheckConsecutiveChar(forthIndex, thirdIndex, secondIndex, firstIndex))) {
            consecutiveNumber = arr[i-1] + arr[i] + arr[i+1] + arr[i+2];
            return true;
        }
    }
    return false;
}

function IsRepeatedChar(str){
    var arr = str.split('');
    for (var i = 1; i < arr.length-2; i++) {
        var firstIndex = arr[i-1].charCodeAt();
        var secondIndex = arr[i].charCodeAt();
        var thirdIndex = arr[i+1].charCodeAt();
        var forthIndex = arr[i+2].charCodeAt();

        if ((forthIndex - thirdIndex == 0) && (thirdIndex - secondIndex == 0) && (secondIndex - firstIndex==0)) {
            repeatedNumber = arr[i-1] + arr[i] + arr[i+1] + arr[i+2];
            return true;
        }
    }
    return false; 
}

function TtnetComplex(oldPassword, newPassword) {
    if (newPassword.length < 8) {
        AlertEx(GetLanguageDesc("S2422"));
        return false;
    }

    if (/^[0-9]*$/.test(newPassword)) {
        AlertEx(GetLanguageDesc("S2423"));
        return false;
    }

    if (/^[a-zA-Z]*$/.test(newPassword)) {
        AlertEx(GetLanguageDesc("S2424"));
        return false;
    }

    if (IsKeyBoardContinuousChar(newPassword)){
        AlertEx(GetLanguageDesc("S2425") + keyBoardConsecutiveNumber + GetLanguageDesc("S2426")); 
        return false;
    }

    if (IsconsecutiveChar(newPassword)){
        AlertEx(GetLanguageDesc("S2427") + consecutiveNumber + GetLanguageDesc("S2426"));
        return false;
    }

    if (IsRepeatedChar(newPassword)){
        AlertEx(GetLanguageDesc("S2428") + repeatedNumber + GetLanguageDesc("S2426"));
        return false;
    }

    if (oldPassword == newPassword) {
        AlertEx(GetLanguageDesc("S2429"));
        return false;
    }

    return true;
}

function GetToken()
{
    var tokenstring="";
    $.ajax(
    {
        type : "POST",
        async : false,
        cache : false,
        url : "/html/ssmp/common/GetRandToken.asp",
        success : function(data) 
        {
            tokenstring = data;
        }
    });
    return tokenstring;
}

function logoutfunc(timeStamp)
{
    var token = GetToken();
    var sUserAgent = navigator.userAgent;
    var url = 'logout.cgi?RequestFile=html/logout.html';
    var isIELarge11 = (sUserAgent.indexOf("Trident") > -1 && sUserAgent.indexOf("rv") > -1);
    if (isIELarge11) {
        if (timeStamp != undefined) {
            url += "&TimeStamp=";
            url += timeStamp;
        }
        url += '&x.X_HW_Token=';
        url += token;
        $.post(url);
        window.location = "/";
    }
    else
    {
        var Form = new webSubmitForm();
        Form.addParameter('x.X_HW_Token', token);
        Form.setAction('logout.cgi?RequestFile=html/logout.html');
        Form.submit();
    }
}

function LogoutWithPara(submitType, location, diffAdminPath)
{
    var token = GetToken();
    var sysUser = '0';
    var curUser = '<%HW_WEB_GetUserType();%>';
    var sUserAgent = navigator.userAgent;
    var isIELarge11 = (sUserAgent.indexOf("Trident") > -1 && sUserAgent.indexOf("rv") > -1);
    var url = '/logout.cgi?';
    if (submitType != "") {
        url += '&SubmitType=' + submitType;
    }
    url += '&RequestFile=/html/logout.html';
    if (isIELarge11) {
        url += '&x.X_HW_Token=' + token;
        $.post(url);
        if (((diffAdminPath == true) && (sysUser != curUser)) || (location == "")) {
            window.location = "/";
        } else {
            window.location = location;
        }
    } else {
        var Form = new webSubmitForm();
        Form.addParameter('x.X_HW_Token', token);
        Form.setAction(url);
        Form.submit();
    }
}

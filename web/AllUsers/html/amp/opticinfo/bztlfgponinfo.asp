<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(gateway.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="Javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<title>Optic information</title>

<script language="JavaScript" type="text/javascript">
var t2Flag = '<%HW_WEB_GetFeatureSupport(FT_FEATURE_TDE);%>';

function stOpticInfo(domain, transOpticPower, revOpticPower, LosStatus)
{
    this.domain = domain;
    this.transOpticPower = transOpticPower;
    this.revOpticPower = revOpticPower;
    this.LosStatus = LosStatus;
}

function stDevInfo(domain, SerialNumber, devtype, loid, eponpwd, hexpassword)
{
    this.domain = domain;
    this.SerialNumber = SerialNumber;    
    this.devtype="1";
    if('1' == t2Flag)
    {
        hexpassword = convTo20Bit(hexpassword);
    }
    this.hexpassword = hexpassword;     
	this.loid       = loid;
    this.eponpwd = eponpwd;
	eponpassword = eponpwd;
}

var deviceInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetOntAuthInfo, InternetGatewayDevice.DeviceInfo, SerialNumber|X_HW_UpPortMode|X_HW_Loid|X_HW_EponPwd|X_HW_PonHexPassword, stDevInfo);%>;

function ONTInfo(domain,ONTID,State)
{
	this.domain = domain;
	this.ONTID  = ONTID;
	this.State = State;
}


var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower|LosStatus, stOpticInfo);%>; 
var opticInfo = opticInfos[0];

var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;

function convTo20Bit(str)
{
    var newStr = str;
    
    if(newStr == null)
    {
        newStr = "";
    }
    
    for(var i = 0; (i < 20) && (newStr.length < 20); i++)
    {
        newStr += "0";
    }

    return newStr;
}

function ChangeHextoAscii(hexpasswd)
{
    var str;
	var len = 0;
	
	len = hexpasswd.length;

	if (0 != len%2)
	{
	    hexpasswd += "0";
	}
	
    str = hexpasswd.replace(/[a-f\d]{2}/ig, function(m){
    return String.fromCharCode(parseInt(m, 16));});

    return str;
}

function conv16to12Sn(SerialNum)
{
    var charVid = "";
	var hexVid = "";
	var vssd = "";
	var i;

    hexVid = SerialNum.substr(0,8);
	vssd = SerialNum.substr(8,8);
	
	for(i=0; i<8; i+=2)
	{
		charVid += String.fromCharCode("0x"+hexVid.substr(i, 2));
	}

	return charVid+vssd;
}

function WriteStResult()
{
    var GPONLinkStatus = opticInfo.LosStatus == '1' ? cfg_gpon_tdevivo_language['amp_info_linkdown'] : cfg_gpon_tdevivo_language['amp_info_linkup'];;
    var revOpticPower = opticInfo.LosStatus == '1' ? '0' : opticInfo.revOpticPower;
    var transOpticPower = opticInfo.LosStatus == '1' ? '0' : opticInfo.transOpticPower; 
    document.getElementById("tdgponlink").innerHTML = GPONLinkStatus;
    
    document.getElementById('tdgpondownpower').innerHTML = revOpticPower;
    document.getElementById('tdgponuppower').innerHTML = transOpticPower;
    
    var gponSN = deviceInfos[0].SerialNumber; 
    document.getElementById("tdgponsn").innerHTML = gponSN;

    var gponslid = deviceInfos[0].hexpassword;
    for(var i = 0; (i < 10) && (gponslid.length < 20); i++)
    {
        gponslid += "00";
    }
    document.getElementById("tdgponslid").innerHTML = gponslid;
    var ontInfostate = ontInfos[0].State;
    
    if (ontInfostate == 'o1' || ontInfostate == 'O1')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o1'];
    }
    else if (ontInfostate == 'o2' || ontInfostate == 'O2')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o2'];
    }
    else if (ontInfostate == 'o3' || ontInfostate == 'O3')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o3'];
    }
    else if (ontInfostate == 'o4' || ontInfostate == 'O4')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o4'];
    }
    else if (ontInfostate == 'o5' || ontInfostate == 'O5')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o5'];
    }
    else if (ontInfostate == 'o6' || ontInfostate == 'O6')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate  + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o6'];
    }
    else if (ontInfostate == 'o7' || ontInfostate == 'O7')
    {
        document.getElementById('tdgponstate').innerHTML = ontInfostate  + '&nbsp;-&nbsp; ' + cfg_gpon_tdevivo_language['amp_gpon_vivo_o7'];
    }
    
}

function LoadFrame()
{ 
    ParseBindTextByTagName(cfg_gpon_tdevivo_language, "th",  1);    
    ParseBindTextByTagName(cfg_gpon_tdevivo_language, "td",  1);
    
    WriteStResult();
}
</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">

				<div id="tab-06" >
	
				<div id="tabela_esquerdaDSL">
					<table class="setupWifiTable width-hpna">
						<tbody>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_gponlink" ></td>
								<td class="cinza center" id= "tdgponlink" ></td>
							</tr>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_gponsn" ></td>
								<td class="cinza center" id= "tdgponsn" ></td>
							</tr>
						</tbody>
					</table>
				</div>	
					
					<div id="tabela_direitaDSL">
					<table class="setupWifiTable width-hpna">
						<tbody>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_state" ></td>
								<td class="cinza center" id= "tdgponstate" ></td>
							</tr>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_slid" ></td>
								<td class="cinza center" id= "tdgponslid" ></td>
							</tr>
						</tbody>
					</table>
					</div>
				
		
				<div id="tabela_esquerdaDSL">
					<table class="setupWifiTable width-hpna">
						<thead>
							<th class="no-up" colspan="2" width="240" BindText="amp_gpon_vivo_downstream" ></th>
						</thead>
						<thead>
							<th class="no-up" width="240" BindText="amp_gpon_vivo_statics" ></th>
							<th class="no-up" BindText="amp_gpon_vivo_value" ></th>
						</thead>
						<tbody>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_power" ></td>
								<td class="cinza center" id= "tdgpondownpower" ></td>
							</tr>
						</tbody>
					</table>
					</div>	
					
					<div id="tabela_direitaDSL">
					<table class="setupWifiTable width-hpna">
						<thead>
							<th class="no-up" colspan="2" width="240" BindText="amp_gpon_vivo_upstream" ></th>
						</thead>
						<thead>
							<th class="no-up" width="240" BindText="amp_gpon_vivo_statics" ></th>
							<th class="no-up" BindText="amp_gpon_vivo_value" ></th>
						</thead>
						<tbody>
							<tr>
								<td class="cinza" BindText="amp_gpon_vivo_power" ></td>
								<td class="cinza center" id= "tdgponuppower" ></td>
							</tr>
						</tbody>
					</table>
					</div>
			
				</div><!--tab-06-->              


</body>
</html>


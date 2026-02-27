<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(gateway.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/lanuserinfo.asp"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<title>Eth Port Information</title>
<script language="JavaScript" type="text/javascript">

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';



function LANStats(domain,txPakets,txBytes,rxPackets,rxBytes)
{  
    this.domain   = domain;
    this.txPackets = txPakets;
    this.txBytes  = txBytes;
	this.rxPackets = rxPackets;
	this.rxBytes  = rxBytes;
}

var userEthInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.Statistics,SendFrame|SendGoodPktOcts|RcvFrame|RcvGoodPktOcts,LANStats);%>;

function IncorrectStats(domain, RcvFrame_Undersize, RcvTooLong, RcvFragmentFrame, RcvJabbersFrame, RcvFcsErrFrame, RcvAlignErrFrame, MacRxErrFrame, CarrierSenseErrCnt,ExcessCollisionFrame, MacSendErrFrame)
{  
    var delta = 0;
    if ( (parseInt(RcvTooLong) >= parseInt(RcvJabbersFrame)) && (parseInt(RcvFcsErrFrame) >= parseInt(RcvJabbersFrame)) )
    {
    	delta = parseInt(RcvTooLong) + parseInt(RcvFcsErrFrame) - parseInt(RcvJabbersFrame);
    }
    else
    {
    	delta = parseInt(RcvTooLong) + parseInt(RcvFcsErrFrame);
    }

    this.domain   			= domain;

    this.rxDiscardPackets 	=   parseInt(RcvFrame_Undersize)     						 
    						  + parseInt(RcvAlignErrFrame) 
    						  + parseInt(MacRxErrFrame)
    						  + delta;

    this.txDiscardPackets 	=   parseInt(CarrierSenseErrCnt)
    						  + parseInt(ExcessCollisionFrame)
    						  + parseInt(MacSendErrFrame);

    this.rxErrorPackets 	=   parseInt(RcvFrame_Undersize)     						
    						  + parseInt(MacRxErrFrame)
    						  + delta;

    this.txErrorPackets 	= 0; 
}

var incorrectPortStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.Statistics, RcvFrame_Undersize|RcvTooLong|RcvFragmentFrame|RcvJabbersFrame|RcvFcsErrFrame|RcvAlignErrFrame|MacRxErrFrame|CarrierSenseErrCnt|ExcessCollisionFrame|MacSendErrFrame, IncorrectStats);%>;



function WriteStResult()
{
    for (i=0; i<userEthInfos.length - 1; i++)
    {
        var lanid = i+1;
        var rxpktsid = "rxpktslan" + lanid;
        document.getElementById(rxpktsid).innerHTML = userEthInfos[i].rxPackets;
        
        var rxbytesid = "rxbyteslan" + lanid;
        document.getElementById(rxbytesid).innerHTML = userEthInfos[i].rxBytes;
        
        var rxerrsid = "rxerrslan" + lanid;
        document.getElementById(rxerrsid).innerHTML = incorrectPortStats[i].rxErrorPackets;
        
        var rxdropsid = "rxdropslan" + lanid;
        document.getElementById(rxdropsid).innerHTML = incorrectPortStats[i].rxDiscardPackets;
        
        var rxpererrsid = "rxpererrslan" + lanid;
        var rxpererrs = 0.00;
        if (userEthInfos[i].rxPackets != 0)
        {
            rxpererrs = incorrectPortStats[i].rxErrorPackets * 100 / userEthInfos[i].rxPackets;
        }
        document.getElementById(rxpererrsid).innerHTML = rxpererrs.toFixed(2);
        
        
        var txpktsid = "txpktslan" + lanid;
        document.getElementById(txpktsid).innerHTML = userEthInfos[i].txPackets;
        
        var txbytesid = "txbyteslan" + lanid;
        document.getElementById(txbytesid).innerHTML = userEthInfos[i].txBytes;
        
        var txerrsid = "txerrslan" + lanid;
        document.getElementById(txerrsid).innerHTML = incorrectPortStats[i].txErrorPackets;
        
        var txdropsid = "txdropslan" + lanid;
        document.getElementById(txdropsid).innerHTML = incorrectPortStats[i].txDiscardPackets;
        
        var txpererrsid = "txpererrslan" + lanid;
        var txpererrs = 0.00;
        if (userEthInfos[i].txPackets != 0)
        {
            txpererrs = incorrectPortStats[i].txErrorPackets * 100 / userEthInfos[i].txPackets;
        }
        document.getElementById(txpererrsid).innerHTML = txpererrs.toFixed(2);
    }
}

function LoadFrame() 
{
    ParseBindTextByTagName(cfg_ethinfo_tdevivo_language, "div",  1);    
    ParseBindTextByTagName(cfg_ethinfo_tdevivo_language, "td",  1);    
    
    WriteStResult();
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">


<div style="overflow:auto;overflow-y:hidden"> 

<table class="setupWifiTable">
    <thead>
        <th class="no-up" ><script>document.write(cfg_ethinfo_tdevivo_language['amp_ethinfo_vivo_statistics']);</script> </th>
        <th class="no-up">LAN 1</th>
        <th class="no-up">LAN 2</th>
        <th class="no-up">LAN 3</th>
        <th class="no-up">LAN 4</th>
    </thead>
    <tbody>
        <tr><td colspan="5" BindText="amp_ethinfo_vivo_rx" ></td></tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_pkts" ></td>
            <td id= "rxpktslan1" class="center"></td>
            <td id= "rxpktslan2" class="center"></td>
            <td id= "rxpktslan3" class="center"></td>
            <td id= "rxpktslan4" class="center"></td>
        </tr>
        <tr>
            <td class="cinza2" BindText="amp_ethinfo_vivo_bytes" ></td>
            <td id= "rxbyteslan1" class="cinza2 center"></td>
            <td id= "rxbyteslan2" class="cinza2 center"></td>
            <td id= "rxbyteslan3" class="cinza2 center"></td>
            <td id= "rxbyteslan4" class="cinza2 center"></td>
        </tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_err" ></td>
            <td id= "rxerrslan1" class="cinza center"></td>
            <td id= "rxerrslan2" class="cinza center"></td>
            <td id= "rxerrslan3" class="cinza center"></td>
            <td id= "rxerrslan4" class="cinza center"></td>
        </tr>
        <tr>
            <td class="cinza2" BindText="amp_ethinfo_vivo_drop" ></td>
            <td id= "rxdropslan1" class="cinza2 center"></td>
            <td id= "rxdropslan2" class="cinza2 center"></td>
            <td id= "rxdropslan3" class="cinza2 center"></td>
            <td id= "rxdropslan4" class="cinza2 center"></td>
        </tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_pererr" ></td>
            <td id= "rxpererrslan1" class="center"></td>
            <td id= "rxpererrslan2" class="center"></td>
            <td id= "rxpererrslan3" class="center"></td>
            <td id= "rxpererrslan4" class="center"></td>
        </tr>
        <tr><td colspan="5" BindText="amp_ethinfo_vivo_tx"></td></tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_pkts" ></td>
            <td id= "txpktslan1" class="center"></td>
            <td id= "txpktslan2" class="center"></td>
            <td id= "txpktslan3" class="center"></td>
            <td id= "txpktslan4" class="center"></td>
        </tr>
        <tr>
            <td class="cinza2" BindText="amp_ethinfo_vivo_bytes" ></td>
            <td id= "txbyteslan1" class="cinza2 center"></td>
            <td id= "txbyteslan2" class="cinza2 center"></td>
            <td id= "txbyteslan3" class="cinza2 center"></td>
            <td id= "txbyteslan4" class="cinza2 center"></td>
        </tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_err" ></td>
            <td id= "txerrslan1" class="cinza center"></td>
            <td id= "txerrslan2" class="cinza center"></td>
            <td id= "txerrslan3" class="cinza center"></td>
            <td id= "txerrslan4" class="cinza center"></td>
        </tr>
        <tr>
            <td class="cinza2" BindText="amp_ethinfo_vivo_drop" ></td>
            <td id= "txdropslan1" class="cinza2 center"></td>
            <td id= "txdropslan2" class="cinza2 center"></td>
            <td id= "txdropslan3" class="cinza2 center"></td>
            <td id= "txdropslan4" class="cinza2 center"></td>
        </tr>
        <tr>
            <td class="cinza" BindText="amp_ethinfo_vivo_pererr" ></td>
            <td id= "txpererrslan1" class="center"></td>
            <td id= "txpererrslan2" class="center"></td>
            <td id= "txpererrslan3" class="center"></td>
            <td id= "txpererrslan4" class="center"></td>
        </tr>
    </tbody>
</table>

</div>


</body>

</html>

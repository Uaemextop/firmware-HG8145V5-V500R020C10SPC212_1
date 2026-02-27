(function(){
function WanPPP(domain, ConnectionStatus,Mode,ServiceList,Enable,LastConnectionError)
{
    this.domain 	       = domain;
    this.ConnectionStatus  = ConnectionStatus;
    this.Mode		       = Mode;
    this.ServiceList       = ServiceList;
	this.Enable            = Enable;
    this.LastConnectionError       = LastConnectionError;
}
var PPPWanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionStatus|ConnectionType|X_HW_SERVICELIST|Enable|LastConnectionError,WanPPP);%>;
//Important:telmex only support gpon,not support epon
//var Pon = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,State,PonLink);%>;

function GetIPv4PPPoeError(CurrentWan)
{
    var errStr = "";
    if (CurrentWan.Enable == "0")
    {
        errStr = waninfo_language['bbsp_wanerror_disable'];
        return errStr;
    }
	
	if (CurrentWan.ConnectionStatus == "Connected")
    {
        errStr = telmex_language['Telmex_wanLinkStatus_connect'];		
        return errStr;
    }

    switch(CurrentWan.LastConnectionError)
    {
			
		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass_telmex'];
			break;
			
		case "ERROR_PADO_TIME_OUT":
		    errStr = waninfo_language['bbsp_wanerror_vlanerror'];
			break;
			
		default:
		    errStr = waninfo_language['bbsp_wanerror_ispfailue'];
		    break;
	}

    return errStr;
    
}

function GetTr069InternetPppoeRoutedWanStatus()
{
	if (PPPWanList.length >= 2)
	{
		var loop = 0;
		
		for (loop = 0; loop < PPPWanList.length - 1; loop++)
		{
			if ((('TR069_INTERNET' == PPPWanList[loop].ServiceList.toUpperCase()) || ('TR069_VOIP_INTERNET' == PPPWanList[loop].ServiceList.toUpperCase())) && ('IP_ROUTED' == PPPWanList[loop].Mode.toUpperCase()))
			{
				return GetIPv4PPPoeError(PPPWanList[loop]);;
			}
		}
	}
	
	return telmex_language['Telmex_wanLinkStatus_disconnect'];
}

function GetPonStatus()
{
   if (Pon.length < 1)
   {
	   ponStatus = "Disconnected";
   }
   else
   {
	   ponStatus = Pon[0].State;
   }
   
   return ponStatus;
}

function PonLink(domain, State)
{
	this.domain = domain;
	this.State  = State;
}

function GetPonAndPPPoEStatus()
{
   var PPPoEStatus = GetTr069InternetPppoeRoutedWanStatus();   
   //var ponStatus = GetPonStatus();
   
   //var PonAndPPPoEStatus = PPPoEStatus + '|' + ponStatus;
   return PPPoEStatus;
}

return GetPonAndPPPoEStatus();
})();

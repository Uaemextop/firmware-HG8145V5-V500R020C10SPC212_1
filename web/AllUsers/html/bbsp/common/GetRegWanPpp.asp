var isOntGlobe2Flag = '<%HW_WEB_GetFeatureSupport(FT_MNGT_GLOBE2);%>';

(function(){
	function BasicWanPPP(domain,Enable,Username,Password,X_HW_VLAN,X_HW_SERVICELIST,ConnectionType,ConnectionTrigger,ConnectionStatus,ExternalIPAddress,LastConnectionError)
	{
		this.domain             = domain;
		this.Enable             = Enable;	
		this.Username           = Username;	
		this.X_HW_VLAN          = X_HW_VLAN;
		this.X_HW_SERVICELIST   = X_HW_SERVICELIST;
		this.ConnectionType     = ConnectionType;
		this.Password           = Password;
		this.ConnectionTrigger = ConnectionTrigger;
		this.ConnectionStatus  = ConnectionStatus;
		this.IPv4IPAddress     = ExternalIPAddress;
		this.LastConnectionError    = LastConnectionError;
	}	
	if (1 == isOntGlobe2Flag)
	{
	var ResultInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|Username|Password|X_HW_VLAN|X_HW_SERVICELIST|ConnectionType|ConnectionTrigger|ConnectionStatus|ExternalIPAddress|LastConnectionError,BasicWanPPP);%>;
	}
	else
	{
		var ResultInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|Username|Password|X_HW_VLAN|X_HW_SERVICELIST|ConnectionType|ConnectionTrigger|ConnectionStatus|ExternalIPAddress|LastConnectionError,BasicWanPPP);%>;
	}
	return ResultInfo;
})();

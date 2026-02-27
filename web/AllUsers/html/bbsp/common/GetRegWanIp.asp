var isOntGlobe2Flag = '<%HW_WEB_GetFeatureSupport(FT_MNGT_GLOBE2);%>';

(function(){
	function BasicWanIPOE(domain,ExternalIPAddress,SubnetMask,DefaultGateway,X_HW_VLAN,X_HW_SERVICELIST,ConnectionStatus,AddressingType)
	{
		this.domain             = domain;
		this.ExternalIPAddress  = ExternalIPAddress;	
		this.SubnetMask         = SubnetMask;
		this.DefaultGateway     = DefaultGateway;
		this.X_HW_VLAN          = X_HW_VLAN;
		this.X_HW_SERVICELIST   = X_HW_SERVICELIST;
		this.ConnectionStatus   = ConnectionStatus;
		this.AddressingType     = AddressingType;
	}
	if (isOntGlobe2Flag == 1)
	{
    var ResultInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},ExternalIPAddress|SubnetMask|DefaultGateway|X_HW_VLAN|X_HW_SERVICELIST|ConnectionStatus|AddressingType,BasicWanIPOE);%>;
	}
	else
	{
		var ResultInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.{i}.WANConnectionDevice.{i}.WANIPConnection.{i},ExternalIPAddress|SubnetMask|DefaultGateway|X_HW_VLAN|X_HW_SERVICELIST|ConnectionStatus|AddressingType,BasicWanIPOE);%>;
	}
	
	return ResultInfo;
})();

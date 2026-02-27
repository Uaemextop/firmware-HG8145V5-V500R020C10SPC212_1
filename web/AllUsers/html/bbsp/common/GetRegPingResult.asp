(function(){
	function PingResultClass(domain, FailureCount, SuccessCount)
	{
	    this.domain = domain;
	    this.FailureCount = FailureCount;
	    this.SuccessCount = SuccessCount;
	} 
		
	var ResultInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.IPPingDiagnostics,FailureCount|SuccessCount, PingResultClass);%>;
	return ResultInfo[0];
})();

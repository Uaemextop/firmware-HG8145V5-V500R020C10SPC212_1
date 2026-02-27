<html>
<head>
<title>Register</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<style type="text/css">
.input_time {border:0px; }
* {margin:0;padding:0;}

body {
	margin:0 auto;
	padding: 0px;
	border-width: 0px;
	text-align: center;
	vertical-align: center;
	margin-left: auto;
	margin-right: auto;
	margin-top: 80px;
	width: 955px;
	height: 600px;
}

.submit {
	background: #fefefe url(../images/button_bg.gif) center repeat-x;
	font: 12px Arial;
	color: #000;
	height: 21px;
	border: #c8c8c8 1px solid;
	padding-left: 5px;
	padding-right: 5px;
}


</style>

<script language="JavaScript" type="text/javascript">

function stRegInfo(domain,loid, state)
{
	this.domain = domain;
	this.loid  = loid;
    this.state = state;
}
var stRegInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_RegistInfo, LOID|State, stRegInfo);%>;
var stReginfo = stRegInfos[0];
var regLoid = stReginfo.loid;
var regStatus = stReginfo.state;


function JumpTo()
{
	window.location="/login.asp";

}

function LoadFrame()
{
	if ("5" != regStatus || 0 == regLoid.length)
	{
		window.location="/register.asp";
	}

	htmlDes="Registration successful. Service distribution successful. <br/><br/>The ONT can register to ACS again only after restoring default configuration.";
	document.getElementById("regResult").innerHTML = htmlDes;
}	
</script>
</head>
<body onLoad="LoadFrame();"> 

	<div align="center"  id="RegisterModule" class="module" style="display:;position:relative;width:600px;height:205px;background-color:#f2f2f2;border-radius:10px;margin:auto;"> 
		<TABLE> 
				<TR>
					<TD colspan="2" align="center">
						<div id="prograss" style="padding-top:30px;padding-bottom:15px;">
							<span id="percent" style="font-size:15px;font-weight:bold;color:#5c5d55;"></span>
						</div>
					</TD> 
				</TR> 
				
				<TR height="8"> 
					<TD  align="center" style="padding-top:15px;">
						<span id="regResult" style="font-size:15px;font-weight:bold;"></span>
					</TD> 
				</TR> 
				<TR>
					<TD  align="center" style="padding-top:30px;">
						<input type="button" class="submit" value="Return" onclick="JumpTo();"/>
					</TD>
				</TR>
				<TR> 

				</TR> 
			</TABLE> 
		</TABLE>
	</div> 

</body>
</html>

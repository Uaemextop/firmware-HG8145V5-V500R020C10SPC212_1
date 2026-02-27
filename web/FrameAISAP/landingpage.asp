<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
<meta http-equiv="Pragma" content="no-cache" />
<link href="/resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" rel="stylesheet" type="text/css" />
<link href="/Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>" rel="stylesheet" type="text/css" />
<script id="langResource" language="JavaScript" src="/frameaspdes/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<script language="JavaScript" src="/resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>

<script language="JavaScript" type="text/javascript">
var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
var httptype = window.location.protocol;
var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
function LoadFrame() {
    document.getElementById("login").href = httptype + '//' + br0Ip + ':'+ httpport + '/';
    document.getElementById("images").src = httptype + '//' + br0Ip + ':'+ httpport + '/images/aisfibre.jpg';
}
</script>

</head>
<title>Landing Page</title>
<body onLoad="LoadFrame();">
    <div class="container-fluid">
        <div class="row">
            <div class="wrapper">
                <div class="logo">
                    <div style="text-align: center;">
                        <img id="images" src="" style="width:450px">
                    </div>
                </div>
                <div class="attention">
                    <div style="font-size: 40px">
                        <script>document.write(framedesinfo["frame024"]);</script>
                    </div>
                    <div>
                        <script>document.write(framedesinfo["frame025"]);</script>
                    </div>
                    <div style="padding-bottom: 10px; padding-right:120px;">
                        <script>document.write(framedesinfo["frame024_AIS"]);</script>
                    </div>
                    <div style="padding-bottom: 10px">
                        <script>document.write(framedesinfo["frame025_AIS"]);</script>
                    </div>
                </div>
                <div class="button">
                    <a id="login" href="/">Continue</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

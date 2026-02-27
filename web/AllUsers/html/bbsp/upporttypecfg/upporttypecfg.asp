<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-IE7 mode->
<script src="/resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script>
var upportfeature ='<%HW_WEB_GetFeatureSupport(FT_AP_WEB_SELECT_UPPORT);%>';
var isVDFAP ='<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_VDFPTAP);%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var currentValue;
var cfgMode ='<%HW_WEB_GetCfgMode();%>';
var styelcss1 = "url(../../../images/wan1.png";
var styelcss2 = "url(../../../images/wan2.png)";

if ((productName.toUpperCase() == "K562") || (productName.toUpperCase() == "A623")) {
    styelcss1 ="url(../../../images/K562_1.png";
    styelcss2 ="url(../../../images/K562_2.png)";
}

function LoadFrame()
{
    if(upportfeature == 1) {
        $('input[name="wanLan"][value=1]').attr("checked",true);
        $("#wanLanImg").css("background-image",styelcss1);
        currentValue = 1;
    } else {
        $('input[name="wanLan"][value=2]').attr("checked",true);
        $("#wanLanImg").css("background-image",styelcss2);
        currentValue = 2;
    }
    
    $('input[type=radio][name=wanLan]').change(function() {
        if (this.value == 1) {
            $("#wanLanImg").css("background-image",styelcss1);
        } else if (this.value == 2) {
            $("#wanLanImg").css("background-image",styelcss2);
        }
    });

    if ((isVDFAP != 1) && ((productName.toUpperCase() == "K562") || (productName.toUpperCase() == "A623"))) {
        document.getElementById('wanLanImg').style.width = '300px';
        document.getElementById('wanLanImg').style.height = '394px';
    }

    if (cfgMode.toUpperCase() == "RDSAP") {
        setDisable("wanLanRadio1", 1);
        setDisable("wanLanRadio2", 1);
        setDisable("btnApply", 1);
    }
}

function SubmitForm()
{
    var selected = $('input:radio:checked') .val();
    var UpModeType;
    var selectResult = false;

    if (cfgMode.toUpperCase() == "RDSAP") {
       return;
    }

    if(selected == currentValue)
    {
        window.location.reload() ;
        return;
    }
    
    if(selected == 1)
    {
        UpModeType = 1 ;
        selectResult = ConfirmEx(wantelnet_language['wantelnet05']);
    }
    else if(selected == 2)
    {
        UpModeType = 0 ;
        var warningKey = 'wantelnet06';
        if (cfgMode.toUpperCase() == "VIETTELAP") {
            warningKey = 'wantelnet06_viet';
        }
        selectResult = ConfirmEx(wantelnet_language[warningKey]);
    }
 
    var configType = "configupmodetype.cgi";
    if (cfgMode.toUpperCase() == "RDSAP") {
        configType = "routerbridgechange.cgi";
    }

    if (selectResult == true) {
        setDisable('btnApply', 1);
        $.ajax({
         type : "POST",
         async : true,
         cache : false,
         data : 'UpModeType=' + UpModeType + "&x.X_HW_Token=" + getValue('onttoken'),
         url : configType + "?&RequestFile=html/bbsp/upporttypecfg/upporttypecfg.asp",
         success : function(data) {
         },
         complete: function (XHR, TS) {
            XHR=null;
         }
        });
    }
}
</script>
</head>
<body onLoad="LoadFrame();"  class="mainbody">
<script language="JavaScript" type="text/javascript">
var titleKey = 'bbsp_dhcpstatic_title';
if (cfgMode.toUpperCase() == "VIETTELAP") {
    titleKey = 'bbsp_dhcpstatic_title_viet';
}else if (cfgMode.toUpperCase() == "DESKAPASTRO") {
    titleKey = 'bbsp_dhcpstatic_title_astro';
}
HWCreatePageHeadInfo("dhcpstatic", GetDescFormArrayById(wantelnet_language, "bbsp_mune"), GetDescFormArrayById(wantelnet_language, titleKey), false);
</script>
<div class="title_spread"></div>
<form id="wanLanForm">
    <table id="wanLanformSet">
        <tr>
            <td>
                <script>document.write(wantelnet_language['wantelnet01']);</script>
            </td>
            <td>
                <input type="radio" id="wanLanRadio1" value="1" name="wanLan"/>
                <input type="hidden" id="onttoken"  name="onttoken" value="<%HW_WEB_GetToken();%>"/>
            </td>
            <td>
                <script>document.write(wantelnet_language['wantelnet02']);</script>
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                <input type="radio" id="wanLanRadio2" value="2" name="wanLan" />
            </td>
            <td>
                <script>
                    var radioKey = 'wantelnet03';
                    if (cfgMode.toUpperCase() == "VIETTELAP") {
                        radioKey = 'wantelnet03_viet';
                    }
                    document.write(wantelnet_language[radioKey]);
                </script>
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
            </td>
            <td class="wanMsg">
                <script>
                    var msgKey = 'wantelnet04';
                    if (cfgMode.toUpperCase() == "VIETTELAP") {
                        msgKey = 'wantelnet04_viet';
                    }
                    document.write(wantelnet_language[msgKey]);
                </script>
            </td>
        </tr>
    </table>
    <script language="JavaScript" type="text/javascript">
        if ((isVDFAP != 1) && (productName != "K562e")) {
            document.write('<div id="wanLanImg" style=""></div>');
        }
    </script>
</form>
<button type="button" name="btnApply" id="btnApply" onClick="SubmitForm();" class="wanLanButton ApplyButtoncss"><script>document.write(wantelnet_language['wantelnet07']);</script></button>
</body>
</html>

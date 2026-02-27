
﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.js);%>"></script>
<title>Automatic Reboot</title>
<script language="JavaScript" type="text/javascript">

function GetLanguageDesc(Name)
{
    return cfg_rebootdule_language[Name];
}

function stDuration(domain, RebootStartTime, RepeatDay)
{
    this.domain = domain;
    this.RebootStartTime = RebootStartTime;
    this.RepeatDay = RepeatDay;
}

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var DurationArr = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AutoRebootByWeek, RebootStartTime|RepeatDay, stDuration);%>;

function GetDurationIndex(DurationDomain)
{
    var index = 0;
    index = DurationDomain.indexOf('.Duration.', 0);
    index += '.Duration.'.length;
    return DurationDomain.substr(index, index+1) ;
}

function rebootTimeSplit(strTimeStart)
{  
    var i = strTimeStart.indexOf(':', 0);
    if (i != 0)
    {
        setText('time_start_hour', strTimeStart.substr(0, i));
        setText('time_start_min', strTimeStart.substr(i + 1));
    }
}

function rebootRepeatSplit(strValue)
{
    var i = 0;
    
    if (strValue == '')
    {
        return;
    }

    for (i = 1; i <= 7; i++)
    {
        var CheckID = 'repeat_day' + + i;
        setCheck(CheckID, 0);
    }

    for (i = 0; i < strValue.length; i = i + 2)
    {
        var CheckID = 'repeat_day' + + strValue.charAt(i);
        setCheck(CheckID, 1);
    }
}

function LoadResource()
{
    var all = document.getElementsByTagName("td");
    for (var i = 0; i < all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }

        if (cfg_rebootdule_language[b.getAttribute("BindText")]) 
        {
            b.innerHTML = cfg_rebootdule_language[b.getAttribute("BindText")];
        }
    }
}

function LoadFrame()
{
    var rebootEnable = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_AutoRebootByWeek.Enable);%>;
    setCheck('rebootChEnable', rebootEnable);    

    setDisplay('rebootCtrlTable',rebootEnable);
    setDisplay('rebootApplyTable',rebootEnable);

    if (rebootEnable == 1)
    {
        rebootTimeSplit(DurationArr[0].RebootStartTime);
        rebootRepeatSplit(DurationArr[0].RepeatDay);
    }  
}

function rebootSetEnable()
{
    var Form = new webSubmitForm();
    var enable = getCheckVal('rebootChEnable');

    setDisplay('rebootCtrlTable',enable);
    setDisplay('rebootApplyTable',enable);

    Form.addParameter('x.Enable',enable);
    Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_AutoRebootByWeek'
                    + '&RequestFile=html/ssmp/autoreboot/Autorebootdule.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function isIntegerOrNull(value)
{
    if ((true != isPlusInteger(value)) && ('' != value))
    {
        return false;
    }
    
    return true;
}
function setParameterTimeCheck(Form)
{
    var time1_begin_h = getValue('time_start_hour');
    
    var time1_begin_m = getValue('time_start_min');

    if ((time1_begin_h.charAt(0) == '-') ||
        (time1_begin_m.charAt(0) == '-') ||
        (time1_begin_h.charAt(0) == '+') ||
        (time1_begin_m.charAt(0) == '+'))
    {
        AlertEx(GetLanguageDesc('ssmp_rebootdule_type_invalid'));
        return false;
    }  

    if (!(isIntegerOrNull(time1_begin_h) && isIntegerOrNull(time1_begin_m)))
    {
        AlertEx(GetLanguageDesc('ssmp_rebootdule_type_invalid'));
        return false;
    }        

    if ((time1_begin_h == '') || (time1_begin_m == ''))
    {
        if ((time1_begin_h != '') || (time1_begin_m != ''))
        {
            AlertEx(ssmp_rebootdule_time_empty("ssmp_rebootdule_time_empty"));
            return false;
        }
    }

    if ((time1_begin_h == '') && (time1_begin_m == ''))
    {
        time1_begin_h = 0;
        time1_begin_m = 0;
        time1_end_h = 0;
        time1_end_m = 0;
    }

    if (time1_begin_h > 23)
    {
        AlertEx(GetLanguageDesc("ssmp_rebootdule_hour_invalid"));
        return false;
    }

    if (time1_begin_m > 59)
    {
        AlertEx(GetLanguageDesc("ssmp_rebootdule_min_invalid"));
        return false;
    }

    return true;
}

function repeatdayformat(repeatday)
{
    if (getCheckVal(repeatday) == 1)
    {
        var length = repeatday.length;
        var str = parseInt(repeatday.charAt(length-1));
        return str + ',';
    }

    return '';
}

function droplastsplitRepeatDay(time_repeat)
{
    var length = time_repeat.length; 
    if (length > 0)
    {
        return time_repeat.substr(0,length-1);
    }

    return '';
}

function droplastsplitTime(time_value)
{
    if (time_value ==  ':')
    {
        return '';
    }

    return time_value;
}

function Apply()
{
    var Form = new webSubmitForm();
    var enable = getCheckVal('rebootChEnable');
    if (setParameterTimeCheck(Form) == false)
    {
        return false;
    }

    var time1_start = getValue('time_start_hour') + ':' + getValue('time_start_min');
    var time1_repeat = repeatdayformat('repeat_day1') + repeatdayformat('repeat_day2') + repeatdayformat('repeat_day3') + repeatdayformat('repeat_day4') 
                       + repeatdayformat('repeat_day5') + repeatdayformat('repeat_day6') + repeatdayformat('repeat_day7');
    time1_repeat = droplastsplitRepeatDay(time1_repeat);
    time1_start = droplastsplitTime(time1_start);
    
    if (time1_repeat == '')
    {
        AlertEx(GetLanguageDesc("ssmp_rebootdule_week_empty"));
        return false;
    }
    Form.addParameter('x.RebootStartTime',time1_start);
    Form.addParameter('x.RepeatDay',time1_repeat);

    Form.setAction('set.cgi?' 
                    + 'x=' + 'InternetGatewayDevice.X_HW_AutoRebootByWeek'
                    + '&RequestFile=html/ssmp/autoreboot/Autorebootdule.asp');
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

function Cancel()
{
    LoadFrame();
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr></table>  
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("rebootSche", GetDescFormArrayById(cfg_rebootdule_language, "ssmp_rebootdule_header"), GetDescFormArrayById(cfg_rebootdule_language, "ssmp_rebootdule_title"), false);
</script>

<div class="title_spread"></div>

<div class="func_title"><SCRIPT>document.write(GetLanguageDesc("ssmp_rebootdule_config"));</SCRIPT></div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="rebootScheCfg">
<tr><td>
<form id="ConfigForm" action="../network/set.cgi">
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
        <tr id="para_enable">
            <td class="table_title" width="100%"><input type='checkbox' id='rebootChEnable' name='rebootChEnable' onClick='rebootSetEnable();' value="OFF">
                                               <script>document.write(GetLanguageDesc("ssmp_rebootdule_enable"));</script></input></td>
        </tr>
    </table>

    <table id="rebootCtrlTable" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="display:none">
        <tr id="para_header">
          <td class="table_title" width="15%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_time_start"));</script></td>
            </table>
          </td>
          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_mon"));</script></td>
            </table>
          </td>
          
          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">          
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_tue"));</script></td>
            </table>
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">          
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_wed"));</script></td>
            </table>
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_thu"));</script></td>
            </table>
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_fri"));</script></td>
            </table>
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_sat"));</script></td>
            </table>
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><script>document.write(GetLanguageDesc("ssmp_rebootdule_week_sun"));</script></td>  
            </table>         
          </td>
        </tr>

        <tr id="para_time1">
          <td class="table_title" width="15%">
            <input type='text' id="time_start_hour" name="time_start_hour" style="width: 2rem" maxlength="2">
           <script>document.write(GetLanguageDesc("ssmp_rebootdule_time_separator"));</script>
            <input type='text' id="time_start_min" name="time_start_min" style="width: 2rem" maxlength="2">
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day1' name='repeat_day1'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day2' name='repeat_day2'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day3' name='repeat_day3'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day4' name='repeat_day4'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day5' name='repeat_day5'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day6' name='repeat_day6'  value="OFF"></td>
            </table>         
          </td>

          <td class="table_title" width="12%">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
            <td class="table_title" width="100%"><input type='checkbox' id='repeat_day7' name='repeat_day7'  value="OFF"></td>
            </table>         
          </td>
        </tr>
    </table>

    <table id="rebootApplyTable" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
      <tr><td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
          <tr>
            <td class="table_submit width_per25"></td>
            <td class="table_submit"> 
              <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
              <button id="applyButton" name="applyButton" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Apply();"><script>document.write(GetLanguageDesc("ssmp_rebootdule_apply"));</script></button>
              <button id="cancelButton" name="cancelButton" type="button" class="CancleButtonCss buttonwidth_100px" onClick="Cancel();"><script>document.write(GetLanguageDesc("ssmp_rebootdule_cancel"));</script></button>
            </td>
          </tr>
        </table>
      </td></tr>
    </table>
 
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr ><td class="width_15px"></td></tr>
    </table> 

</form>
</td></tr>
</table>
<!-- InstanceEndEditable -->
</body>
<!-- InstanceEnd -->
</html>

<!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    <link rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
    <link rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
    <script>
      var emEnableValue = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.EasyMesh.Enable);%>';
      function cancelValue() {
        LoadFrame();
      }

      function LoadFrame() {
        if (emEnableValue != null) {
          setCheck("easyMeshEnable", emEnableValue);
        }
      }

      function btnApplySubmit() {
        setDisable('btnApplySubmit', 0);
        let Form = new webSubmitForm();
        let easyMeshenable = getCheckVal('easyMeshEnable')
        Form.addParameter('x.Enable', easyMeshenable);
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('set.cgi?x=InternetGatewayDevice.EasyMesh&RequestFile=html/amp/wlaninfo/easymeshTopovitall.asp');
        Form.submit();
        setDisable('btnApplySubmit', 1);
        setDisable('cancel', 1);
      }
    </script>

</head>

<body onLoad="LoadFrame();" class="mainbody">
  <input type="hidden" id="onttoken" name="onttoken" value="<%HW_WEB_GetToken();%>" />
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td></td>
    </tr>
  </table>
  <script language="JavaScript" type="text/javascript">
    HWCreatePageHeadInfo(cfg_wlaninfo_easymesh_language['amp_easymesh_multiap_title'], cfg_wlaninfo_easymesh_language['amp_easymesh_multiap_title'], cfg_wlaninfo_easymesh_language['amp_easymesh_title_note'], false);
  </script>
  <div class="title_spread"></div>

  <div>
    <form id="UpModeCfgForm" name="UpModeCfgForm">
      <table border="0" cellpadding="0" cellspacing="1" width="100%" class="tabal_noborder_bg">
        <tr border="1" id="easyMeshEnableTr">
          <td class="table_title width_per25" id="UpModeRadioColleft">
            <script>
              document.write(cfg_wlaninfo_easymesh_language['amp_easymesh_enable']);
            </script>
          </td>
          <td id="easyMeshEnableCol" class="table_right width_per75">
            <input type="checkbox" id="easyMeshEnable" name="easyMeshEnable" value="ON">
            <span id="ssidLenTips" class="gray">
              <script>
                document.write(cfg_wlaninfo_easymesh_language['amp_easymesh_enable_note']);
              </script>
            </span>
          </td>
        </tr>
      </table>
    </form>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
        <tr>
          <td class="table_submit width_per25"></td>
          <td class="table_submit">
            <button id="btnApplySubmit" name="btnApplySubmit" type="button" class="ApplyButtoncss buttonwidth_100px"
              onClick="btnApplySubmit();">
              <script>document.write(cfg_wlancfgother_language['amp_wlancfg_apply']);</script>
            </button>
            <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px"
              onClick="cancelValue();">
              <script>document.write(cfg_wlancfgother_language['amp_wlancfg_cancel']);</script>
            </button>
          </td>
        </tr>
      </table>
    </table>
  </div>
</body>

</html>
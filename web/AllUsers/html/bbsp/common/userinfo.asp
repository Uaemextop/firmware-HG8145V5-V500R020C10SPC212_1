var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var DBAA1 = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATRUE_DBAA1);%>";
var dbaa1SuperSysUserType = '2';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>';

function IsAdminUser()
{
    if (curCfgModeWord.toUpperCase() == "DESKAPHRINGDU") {
        return curUserType == '1';
    }

    if (DBAA1 == '1') {
        return curUserType == dbaa1SuperSysUserType;
    }
    return curUserType == sysUserType;
}
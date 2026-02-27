var ssidIdx = 0;
var changeWlanClick = 1;
var WlanBasicPage = '2G';
var WlanAdvancePage = '2G';
var WlanSTAPIN = '';
var lanDevIndex = 1;
var QoSCurInterface = '';
var DDNSProvider = '';
var ripIndex = "";
var previousPage = "";
var preAddDomain = "";
var editIndex = -1;
var editDomain = '';
var sptUserType = '1';
var sysUserType = '0';
var remoteNum = 0;
var MenuName = "";
var StartIndex = 1;
var Menu2Path = "";
var authMode = 0;
var Passwordmode = 0;
var changeMethod = 999;
var UpgradeFlag = 0;
var SaveDataFlag = 0;
var ontPonStatus = null;
var ontPPPoEStatus = "";
var ontReStatusInfo = null;
var ontReStatusId =null;
var ontPonStatusInfo =null;
var subLength=15;
var label_pon = "";
var label_pppoe = "";
var ponLinkStatus = "";
var pppoeStatus = "";
var TELMEX = true;
var PPPTimer;
var Outtime;
var refreshTime;
var EquipFlag = 0;
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var menuArray = <%HW_WEB_GetWebMenuArray();%>;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var secondLoginStatus ='<%WEB_GetSecondLoginIsUsed();%>';
var TELMEXgetpppstatusflag = 1;
document.title = productName;

function GetIdByUrl(Type, BaseUrl)
{	
	var NewId = Type+"_";
	var MarkEnd="";
	try{
		var lastindex = BaseUrl.lastIndexOf('/');
		if( lastindex > -1 )
		{
			NewId += BaseUrl.substring(lastindex+1, BaseUrl.length);
		}
		else
		{
			NewId += BaseUrl;
		}
		
		if(NewId.indexOf("?") > -1)
		{
			MarkEnd = NewId.split("?")[1];
		}
		
		NewId = NewId.split(".")[0]+MarkEnd;
		
	}catch(e){
		NewId += Math.round(Math.random() * 10000);
	}
	return NewId;
}

var Frame = {
	menuItems : [],
	mainMenuCounter : 0,
	subMenuCounter : 0,
	$mainMenu : null,
	$subMenu : null,
	$content : null,

	init : function() {
		this.initData();
		this.initElement();
	},

	initData : function() {
		var frame = this;

		this.mainMenuCounter = 0;
		this.subMenuCounter = 0;

		this.$mainMenu = $("#headerTab ul");
		this.$subMenu = $("#nav ul");
		this.$content = $("#frameContent");

		this.$content.on("load", function() {
			frame.$content.show();
			frame.setContentHeight();
		});

		this.menuItems = eval(menuArray);
	},

	initElement : function() {
		$("#headerTitle").text(productName);

		this.setLogoutElement(curLanguage);
		this.setCopyRightInfo(curLanguage);

		if (this.menuItems.length > 0) {
			this.addMenuItems(this.$mainMenu, this.menuItems, "main");
            if (secondLoginStatus == 1) {
                if (CfgMode.toUpperCase() == 'TELMEXACCESSNV') {
                    var pwdurl = "html/ssmp/tr069/tr069.asp";
                } else if (CfgMode.toUpperCase() == 'TELMEXACCESS') {
                    var pwdurl = "html/voip/voipinterface/voipinterface.asp";
                }

                if (curLanguage.toUpperCase() == "ENGLISH") {
                    if (CfgMode.toUpperCase() == 'TELMEXACCESS') {
                        MenuName = "Voice and Remote Administration";
                        Menu2Path = "VoIP Basic Configuration";
                    } else if (CfgMode.toUpperCase() == 'TELMEXACCESSNV') {
                        MenuName = "Remote Administration";
                        Menu2Path = "Remote Administration Configuration";
                    }
                } else {
                    if (CfgMode.toUpperCase() == 'TELMEXACCESS') {
                        MenuName = "Administración remota y de voz";
                        Menu2Path = "Configuración de VoIP básica";
                    } else if (CfgMode.toUpperCase() == 'TELMEXACCESSNV') {
                        MenuName = "Administración remota";
                        Menu2Path = "Gestión de configuraciones";
                    }
                }

                var indexPos;
                for (indexPos = 0; indexPos < this.menuItems.length; indexPos++) {
                    if (this.menuItems[indexPos].name == MenuName) {
                        break;
                    }
                }

                if (indexPos == this.menuItems.length) {
                    indexPos = this.menuItems.length - 1;
                }
                this.addMenuItems(this.$subMenu, this.menuItems[indexPos].subMenus, "sub");
                this.setContentPath(pwdurl);
            } else {
                this.addMenuItems(this.$subMenu, this.menuItems[0].subMenus, "sub");
                MenuName = this.menuItems[0].name;
                Menu2Path = this.menuItems[0].subMenus[0].name;
                this.setContentPath(this.menuItems[0].subMenus[0].url);
            }
		}
	},

	addMenuItems : function(element, menus, type) {
		var frame = this;
		element.empty();
		if(type == "main") {
			this.mainMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {
                if ((menus[i].name == "Remote Administration") || (menus[i].name == "Administración remota") ||
                    (menus[i].name == "Voice and Remote Administration") || (menus[i].name == "Administración remota y de voz")) {
                    remoteNum = i;
                }
                var maindivname = GetIdByUrl("maindiv", menus[i].url);
                var mainliname = GetIdByUrl("mainli", menus[i].url);
                var leftlistr = '<li value="' + i + '" name="' + mainliname + '">';
                if ((maindivname == "maindiv_usbhost") && (CfgMode.toUpperCase() == 'TELMEXACCESS' || CfgMode.toUpperCase() == 'TELMEXACCESSNV')) {
                    var middledivstr = '<div class="tabBtnCenter" style="line-height:13px;width:75px;" name="' + maindivname + '">' + menus[i].name + '</div>';
                } else if (((maindivname == "maindiv_remoteandvoip") || (maindivname == "maindiv_voipinterface")) && (CfgMode.toUpperCase() == 'TELMEXACCESS')) {
                    var middledivstr = '<div class="tabBtnCenter" style="line-height:13px;width:105px;" name="' + maindivname + '">' + menus[i].name + '</div>';
                } else if (((maindivname == "maindiv_remoteandvoip") || (maindivname == "maindiv_tr069")) && (CfgMode.toUpperCase() == 'TELMEXACCESSNV')) {
                    var middledivstr = '<div class="tabBtnCenter" style="line-height:13px;width:90px;" name="' + maindivname + '">' + menus[i].name + '</div>';
                } else {
                    var middledivstr = '<div class="tabBtnCenter" name="' + maindivname + '">' + menus[i].name + '</div>';
                }
                element.append( leftlistr + '<div class="tabBtnLeft"></div>' + middledivstr + '<div class="tabBtnRight"></div>' + '</li>');
            }
            if (secondLoginStatus == 1) {
                element.children("li").eq(remoteNum).addClass("hover");
            } else {
                element.children("li").eq(0).addClass("hover");
            }
            element.children("li").click(function() {
                if (!element.children("li").eq(this.value).is(".hover")) {
                    if(frame.mainMenuCounter != remoteNum) {
                        element.children("li").eq(remoteNum).removeClass("hover");
                    }
					element.children("li").eq(frame.mainMenuCounter).removeClass("hover");
					element.children("li").eq(this.value).addClass("hover");
					frame.mainMenuCounter = this.value;
					frame.addMenuItems($("#nav ul"), menus[this.value].subMenus, "sub");

					MenuName = menus[this.value].name;
					Menu2Path = (menus[this.value].subMenus.length == 0) ? menus[this.value].name : menus[this.value].subMenus[0].name;

					frame.setContentPath(menus[this.value].url);
				}
			});
		} else if (type == "sub") {
			this.subMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {
				var subdivname = GetIdByUrl("subdiv", menus[i].url);
				var subliname = GetIdByUrl("subli", menus[i].url);
				element.append('<li value="' + i + '" name="' + subliname +'"><div name="' + subdivname + '">' + menus[i].name + '</div></li>');
			}

			if (true == TELMEX)
			{
				label_pon = telmex_language['Telmex_ponLinkStatus_title'];
				label_pppoe = telmex_language['Telmex_pppoeStatus_title'];
				element.append('<div id="ontStatus" class="div_ontstatus">'
								+ '<li class="li_ontstatus">' + label_pon + '</li>' + '<li class="li_ontstatus">' + ponLinkStatus + '</li>'
								+ '<li class="li_ontstatus">' + label_pppoe + '</li>' + '<li class="li_ontstatus">' + pppoeStatus + '</li>'
								+ '</div>');
			}
			element.children("li").eq(0).addClass("hover");
			element.children("li").click(function() {
				element.children("li").eq(frame.subMenuCounter).removeClass("hover");
				element.children("li").eq(this.value).addClass("hover");
				frame.subMenuCounter = this.value;

				Menu2Path = menus[this.value].name;
				frame.setContentPath(menus[this.value].url);
			});
		}
	},

	setContentPath : function(url) {

		var msg;
		if (UpgradeFlag == 1)
		{
			if(curLanguage == 'spanish') {
				msg = 'Nota: Si decide cambiar de página, la actualización \nse interrumpirá y es posible que el dispositivo no arranque \nla próxima vez. Se recomienda presionar cancelar y permanecer en esta página hasta que se complete la actualización.';
			} else if(curLanguage == 'english') {
				msg = 'Note: Upgrade will be interrupted and the device might not boot successfully next time if you switch to another page. It is strongly recommended to press cancel and remain on this page until the upgrade is complete.';
			}

			if(confirm(msg))
			{
				UpgradeFlag = 0;
				this.setMenuPath();
				this.$content.attr("src", url);
			}
		}
		else
		{
			this.setMenuPath();
			this.$content.attr("src", url);
		}
	},

	setContentHeight : function() {
		setInterval(function() {
			try {
				var height = 0;

				if (window.ActiveXObject) {
					height = document.getElementById("frameContent").contentWindow.document.body.scrollHeight;
				}
				else if (window.XMLHttpRequest) {
                    if (document.getElementById("frameContent").src.indexOf('remoteandvoip') != -1) {
                        height = 600;
                    } else {
                        height = document.getElementById("frameContent").contentWindow.document.body.offsetHeight;
                    }
				}

				height = Math.max(height, 520, this.$("#nav li").length * 25);
				$("#center").height(height + 25);
				$("#nav").height(height + 25);
				$("#content").height(height + 25);
				$("#frameWarpContent").height(height);
				$("#frameContent").height(height);
			} catch (e) {

			}
		}, 200);
	},

	setMenuPath : function() {
		$("#topNav #topNavMainMenu").text(MenuName);
		$("#topNav #topNavSubMenu").text(Menu2Path);
	},

	setLogoutElement : function(curLanguage) {
		if(curLanguage == "english") {
			$("#headerLogout span").html("Logout");
		} else if(curLanguage == "spanish") {
			$("#headerLogout span").html("Cerrar sesión");
		}
		var frame = this;

		$("#headerLogout span").mouseover(function() {
			$("#headerLogout span").css({
				"color" : "#990000",
				"text-decoration" : "underline"
			});
		});
		$("#headerLogout span").mouseout(function() {
			$("#headerLogout span").css({
				"color" : "#000000",
				"text-decoration" : "none"
			});
		});
		$("#headerLogout span").click(function() {
			frame.clickLogout();
		});
	},

	setCopyRightInfo : function(language) {
		if (language == "spanish") {
			$("#footerText").html("Copyright © 2022 Huawei Technologies Co., Ltd. Todos los derechos reservados. ");
		} else if (language == "english") {
			$("#footerText").html("Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved. ");
		}
	},

	clickLogout : function() {
		logoutfunc();
	},
	show : function() {
		var frame = this;
		$(document).ready(function() {
			frame.init();
		});
	},
	showjump : function(hpa,zpa)
	{
		if((productName == 'HG8045') && (curUserType == sysUserType))
		{
			hpa--;
		}
		this.$mainMenu.children("li").eq(this.mainMenuCounter).removeClass("hover");
		this.$mainMenu.children("li").eq(this.menuItems.length-hpa).addClass("hover");
		this.mainMenuCounter=this.menuItems.length-hpa;
		this.addMenuItems($("#nav ul"), this.menuItems[this.menuItems.length-hpa].subMenus, "sub");
		this.$subMenu.children("li").eq(this.subMenuCounter).removeClass("hover");
		this.$subMenu.children("li").eq(zpa).addClass("hover");
		MenuName = this.menuItems[this.menuItems.length-hpa].name;
		Menu2Path = this.menuItems[this.menuItems.length-hpa].subMenus[zpa].name;
		this.setContentPath(this.menuItems[this.menuItems.length-hpa].subMenus[zpa].url);
		this.subMenuCounter=zpa;
	}
};

Frame.show();


function updatePonAndPPPOEStatus(ontPonStatus)
{
	ponLinkStatus = ('o5' == ontPonStatus || 'O5' == ontPonStatus)? telmex_language['Telmex_wanLinkStatus_connect'] : telmex_language['Telmex_wanLinkStatus_disconnect'];
	if('O5' != ontPonStatus && 'o5' != ontPonStatus)
	{
		pppoeStatus = telmex_language['Telmex_wanLinkStatus_disconnect'];
	}
	else
	{
		$.ajax({
			type : "POST",
			async : false,
			cache : false,
			url : "asp/getPPPoEConnStatus.asp",
			success : function(data) {
				ontPPPoEStatus=eval(data);
				pppoeStatus = ontPPPoEStatus;
			}
		});
	}

	ontPonStatusInfo = '<li class="li_ontstatus">' + htmlencode(label_pon) + '</li>' + '<li class="li_ontstatus">' + htmlencode(ponLinkStatus) + '</li>';
	ontReStatusInfo = ontPonStatusInfo + '<li class="li_ontstatus">' + htmlencode(label_pppoe) + '</li>' + '<li class="li_ontstatus">' + htmlencode(pppoeStatus) + '</li>';
	ontReStatusId = document.getElementById("ontStatus");
	if(null != ontPonStatus)
	{
		ontReStatusId.innerHTML = ontReStatusInfo;
	}
}



function getPonAndPPPOEStatus()
{
	if (0 == TELMEXgetpppstatusflag)
	{
		return;
	}
	
	$.ajax({
		type : "POST",
		async : true,
		cache : false,
		url : "asp/getPonConnStatus.asp",
		success : function(data) {
			updatePonAndPPPOEStatus(data);
		}
	});
}


PPPTimer = setInterval("getPonAndPPPOEStatus()", 5000);


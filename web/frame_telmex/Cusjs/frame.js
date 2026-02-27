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
var curWebFrame = null;
var curWebMenuPath = null;
var productName = null; 
var curLanguage = null; 
var sptUserType = '1';
var sysUserType = '0';
var curUserType = null;
var MenuName = "";
var StartIndex = 1;
var Menu2Path = "";
var pageName11 = null;
var authMode = 0;
var Passwordmode = 0;
var changeMethod = 999;
var UpgradeFlag = 0;
var SaveDataFlag = 0;
var menuArray = null;
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
        
        this.$content.load(function() {
        	frame.$content.show();
            frame.setContentHeight();
        });

        this.menuItems = eval(menuArray);
    },

    getRemoteData : function() {
	  $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "asp/getMenuArray.asp",
            success : function(data) {
                 menuArray  = data;
            }
        });
			 
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "asp/getProductName.asp",
            success : function(data) {
                productName = data;
                document.title = productName;
            }
        });
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../html/ssmp/common/getCurLanguage.asp",
            success : function(data) {
                curLanguage = data;
            }
        });
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../html/ssmp/common/getCurWebFrame.asp",
            success : function(data) {
                curWebFrame = data;
            }
        });
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../html/ssmp/common/getCurWebMenuPath.asp",
            success : function(data) {
                curWebMenuPath = data;
            }
        });
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../html/ssmp/common/getCurUserType.asp",
            success : function(data) {
               	curUserType = data;
            }
        });
        $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "../html/ssmp/common/getPageName.asp",
            success : function(data) {
                pageName11 = data;
            }
        });

    },

    initElement : function() {
    	$("#headerTitle").text(productName);
    	
    	this.setLogoutElement(curLanguage);
    	this.setCopyRightInfo(curLanguage);
    	
    	if (this.menuItems.length > 0) {
            this.addMenuItems(this.$mainMenu, this.menuItems, "main");
            this.addMenuItems(this.$subMenu, this.menuItems[0].subMenus, "sub");

            MenuName = this.menuItems[0].name;
            Menu2Path = this.menuItems[0].subMenus[0].name;
            this.setContentPath(this.menuItems[0].subMenus[0].url);
        }
    },

    addMenuItems : function(element, menus, type) {
    	var frame = this;
    	element.empty();
		if(type == "main") {
			this.mainMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {
				element.append('<li value="' + i + '">' +
					'<div class="tabBtnLeft"></div>' +
					'<div class="tabBtnCenter">' + menus[i].name + '</div>' +
					'<div class="tabBtnRight"></div>' +
				'</li>');
		    }
		    element.children("li").eq(0).addClass("hover");
            element.children("li").click(function() {
                if (!element.children("li").eq(this.value).is(".hover")) {
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
                element.append('<li value="' + i + '"><div>' + menus[i].name + '</div></li>');
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
                    height = document.getElementById("frameContent").contentWindow.document.body.offsetHeight;
                }

                height = Math.max(height, 520);
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
            $("#footerText").html("Copyright © ##.COPY_RIGHT_YEAR.## Huawei Technologies Co., Ltd. Todos los derechos reservados. ");
        } else if (language == "english") {
            $("#footerText").html("Copyright © ##.COPY_RIGHT_YEAR.## Huawei Technologies Co., Ltd. All rights reserved. ");
        }
    },

    clickLogout : function() {
        logoutfunc();
    },
	show : function() {
        var frame = this;
        frame.getRemoteData();
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


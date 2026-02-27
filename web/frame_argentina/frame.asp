var ssidIdx = 0;
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
var MenuName = "";
var StartIndex = 1;
var Menu2Path = "";
var authMode = 0;
var Passwordmode = 0;
var changeMethod = 999; 
var UpgradeFlag = 0;
var SaveDataFlag = 0;
var collectType = "";
var PwdModifyFlag = 1;
var PwdAspNum = 0;
var SystemToolsNum = 0;
var EquipFlag = 0;
var refreshTime;
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var curWebMenuPath = '<%HW_WEB_GetWEBMenuPath();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var pageName11 = '<%webGetReplacePage();%>';
var jumptomodifypwd = '<%HW_WEB_GetWebUserMdFlag();%>';       
var menuArray = <%HW_WEB_GetWebMenuArray();%>;
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
			
			MenuName = this.menuItems[0].name;
			Menu2Path = this.menuItems[0].subMenus[0].name;
			this.addMenuItems(this.$mainMenu, this.menuItems, "main");
			this.addMenuItems(this.$subMenu, this.menuItems[0].subMenus, "sub");
        }
    },

    addMenuItems : function(element, menus, type) {
    	var frame = this;
		var posDeviceInfo = 0;
    	element.empty();
		if(type == "main") {
			this.mainMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {
				
				if( menus[i].name == "System Tools")
				{
					SystemToolsNum = i;
				}
				
				var maindivname = GetIdByUrl("maindiv", menus[i].url);
				var mainliname = GetIdByUrl("mainli", menus[i].url);
				var leftlistr = '<li value="' + i + '" name="' + mainliname + '">';
				var middledivstr = '<div class="tabBtnCenter" name="' + maindivname + '">' + menus[i].name + '</div>';
				element.append( leftlistr + '<div class="tabBtnLeft"></div>' + middledivstr + '<div class="tabBtnRight"></div>' + '</li>');
		    }
			
			element.children("li").eq(0).addClass("hover");

            element.children("li").click(function() {
                if (!element.children("li").eq(this.value).is(".hover")) {
					if(frame.mainMenuCounter != SystemToolsNum)
					{
						element.children("li").eq(SystemToolsNum).removeClass("hover");
					}
				
                    element.children("li").eq(frame.mainMenuCounter).removeClass("hover");
                    element.children("li").eq(this.value).addClass("hover");
                    frame.mainMenuCounter = this.value;
					MenuName = menus[this.value].name;
                    frame.addMenuItems($("#nav ul"), menus[this.value].subMenus, "sub");


                }
            });
		} else if (type == "sub") {
            this.subMenuCounter = 0;
            for (var i = 0, len = menus.length; i < len; i++) {
				var subdivname = GetIdByUrl("subdiv", menus[i].url);
				var subliname = GetIdByUrl("subli", menus[i].url);
				element.append('<li value="' + i + '" name="' + subliname +'"><div name="' + subdivname + '">' + menus[i].name + '</div></li>');
				if("Device Information" == menus[i].name)
				{
					posDeviceInfo = i;
				}
			}
			
			element.children("li").eq(frame.subMenuCounter).removeClass("hover");
			element.children("li").eq(posDeviceInfo).addClass("hover");
			frame.subMenuCounter = posDeviceInfo;
			Menu2Path = menus[posDeviceInfo].name;
			frame.setContentPath(menus[posDeviceInfo].url);

            element.children("li").click(function() {
				 if(PwdAspNum != frame.subMenuCounter)
				 {
					 element.children("li").eq(PwdAspNum).removeClass("hover");
			     }
												 
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
			if(curLanguage == 'chinese') {
				msg = '提醒:系统正在升级，离开本页面会导致升级失败。强烈建议您点击\"取消\"，停留在本页面，直到升级成功。';
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

                height = Math.max(height, 470);
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
    	} else if(curLanguage == "chinese") {
    		$("#headerLogout span").html("退出");
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
			LogoutAdminFunc();
        });
    },

	setCopyRightInfo : function(language) {
        if (language == "chinese") {
            $("#footerText").html("版权所有 © 2022 华为技术有限公司。保留一切权利。");
        } else if (language == "english") {
            $("#footerText").html("Copyright © 2022 Huawei Technologies Co., Ltd. All rights reserved. ");
        }
    },

    clickLogout : function() {
        LogoutAdminFunc();
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
